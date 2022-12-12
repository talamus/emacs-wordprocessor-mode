;;;
;;; Emacs settings for Word Processing by tero.niemi(a)nimbus.fi
;;;

;;; General settings:

(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp"))	; Add local directory to load-path.
(setq frame-title-format "%b %+%+ %f")				; Window title.
(setq inhibit-startup-message 1)				; Disable splash screen.
(setq display-time-24hr-format 1)				; Use 24 hour clock.
(cua-mode 1)							; Windows-like keyboard shortcuts.

;;; Additional keys:

(global-set-key (kbd "C-f") 'isearch-forward)			; [Ctrl F] Windows-like find. (Was previously 'forward-char', same as right arrow.)
(global-set-key (kbd "C-s") 'save-buffer)			; [Ctrl S] Windows-like save. (Was previously 'isearch-forward', same as [Ctrl F].)
(global-set-key (kbd "<M-f4>") 'save-buffers-kill-terminal)			; Windows-like [Alt F4]
(global-set-key (kbd "<home>") 'beginning-of-visual-line)			; Windows-like [Home] key
(global-set-key (kbd "C-M--") (lambda () (interactive) (ucs-insert #x2014)))	; [Ctrl Meta -] EM DASH
(global-set-key (kbd "<Scroll_Lock>") 'scroll-lock-mode)			; Traditional [Scroll Lock]

;;; Simple Semi-Windows-like redo:

;(require 'cl)
;(setf (global-key-binding (kbd "C-y")) (kbd "<right> C-z"))	; [Ctrl Y] Redo last undo/redo. (Was previously 'cua-paste', same as [Ctrl V].)
                                                                ; This redo is simple but quite non-perfect.
                                                                ; For a better alternative install 'undo-tree.el',
                                                                ; or use the emacs style shortcut [Ctrl G][Ctrl Z][Ctrl Z]...
;;; Windows-like vertical scrolling:

(setq scroll-step 1)						; Scroll only 1 row at time.
(setq scroll-conservatively 1000000)				; Do not jump ahead.
(setq scroll-up-aggressively 0)					; Do no jump back.
(setq scroll-down-aggressively 0)				; Do not jump ahead.
(setq auto-window-vscroll nil)					; Do not jump on big objects.
(setq scroll-preserve-screen-position t)			; Preserve cursor position on page-up and page-down.

;;; How near window edge cursor can come? Choose the preferred style:

(setq scroll-margin 100)					; Keep margin between cursor and window edge.

;; or, alternatively:

;(setq scroll-margin 0)						; Windows-like behaviour

;;; X11 specific settings:

(when (eq window-system 'x)

  ;;; [Ctrl -] [Ctrl +] [Ctrl 0] Change font size:

  (setq text-scale-mode-step 1.05)
  (global-set-key (kbd "C-+") 'text-scale-increase)
  (global-set-key (kbd "C--") 'text-scale-decrease)
  (global-set-key (kbd "C-0") (lambda () (interactive) (text-scale-increase 0)))

  ;;; Appearance:

  (set-default 'cursor-type '(bar . 2))				; Cursor is 2 pixel wide vertical bar
  (set-face-attribute 'italic nil :italic t :underline nil)	; Use real italics instead of underlining

  ;;; Colors:

  (setq   background-color "#374763")
  (setq   foreground-color "#FFFFFF")
  (setq   minibuffer-color "#95A2B9")
  (setq    selection-color "#7887A3")
  (setq mode-line-bg-color "#DCDCDC")
  (setq mode-line-fg-color "#222222")
  (set-face-attribute 'default           nil :background   background-color :foreground   foreground-color)
  (set-face-attribute 'fringe            nil :background   background-color :foreground   foreground-color)
  (set-face-attribute 'minibuffer-prompt nil                                :foreground   minibuffer-color)
  (set-face-attribute 'region            nil :background    selection-color                               )
  (set-face-attribute 'mode-line         nil :background mode-line-bg-color :foreground mode-line-fg-color)
  (set-cursor-color minibuffer-color)

  ;;; [F11] Fullscreen mode:

  (defun toggle-fullscreen ()
         "Toggle full screen on X11"
         (interactive)
         (if (frame-parameter nil 'fullscreen)
             (progn
               (set-frame-parameter nil 'fullscreen nil)
               (menu-bar-mode 1)
               (tool-bar-mode 1)
               (scroll-bar-mode 1)
               (set-face-attribute 'mode-line nil :background mode-line-bg-color :foreground mode-line-fg-color))
           (progn
             (set-frame-parameter nil 'fullscreen 'fullboth)
             (menu-bar-mode 0)
             (tool-bar-mode 0)
             (scroll-bar-mode 0)
             (set-face-attribute 'mode-line nil :background background-color :foreground selection-color))))
  (global-set-key (kbd "<f11>") 'toggle-fullscreen)

  ) ; X11 specific settings

;;; Text mode specific settings:

(unless window-system
  (menu-bar-mode 0)						; Hide menu bar. (Still accessible via [F10].)
  (display-time-mode 1)						; Show time.

  ;;; Xterm-style keyboard escape codes:

  (load-file "~/.emacs.d/keymap.el")

  ;;; Colors:

  (set-face-attribute 'default   nil :background    "blue" :foreground "white")
  (set-face-attribute 'region    nil :background    "cyan"                    )
  (set-face-attribute 'mode-line nil :inverse-video nil    :foreground "cyan" )

  ) ; Text mode specific settings

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; A Word Processor -like mode:

(define-derived-mode wp-mode fundamental-mode "WP"
  "A Word Processor -like Mode."

  (set-buffer-file-coding-system 'utf-8-unix)			; Force utf-8 encoding and Unix-style newlines.
  (enriched-mode 1)						; Allow Bold and Italics in text.
  (visual-line-mode 1)						; Wrap long lines only at whitespace.
  (auto-save-mode 1)						; Enable auto save.

  ;;; X11 specific settings:

  (when (eq window-system 'x)

    (setq left-margin-width 32)					; Set left margin.
    (setq right-margin-width 32)				; Set right margin.
    (setq tab-width 8)						; Set tab width.
    (toggle-fullscreen)						; Start in fullscreen mode.

    ;;; Font:

    (variable-pitch-mode 1)					; Do not use monospaced font
    (setq line-spacing 0.7)					; Line spacing (relative to font height)
    (make-face 'wp-font-face)					; Create new face and set attributes
    (buffer-face-set 'wp-font-face)				; Set as default buffer face
    (set-face-attribute 'wp-font-face nil :family "Gentium" :height 144)  ; Font face

    ) ; X11 specific settings

  ;;; Text mode specific settings:

  (unless window-system
    (setq left-margin-width 5)					; Set left margin.
    (setq right-margin-width 2)					; Set right margin.
    (setq tab-width 5))						; Set tab width.

  ;;; Mode-line:

  (setq minor-mode-alist nil)					; Do not list minor modes.
  (size-indication-mode 1)					; Show file size.

  ;;; Paragraph indentation. Choose the preferred style:

  (setq indent-line-function 'insert-tab)			; Automagically insert tabs.

  ;; or, alternatively:

  ;(setq indent-line-function 'ignore)				; Disable automagical indentation.
  ;(local-set-key (kbd "<tab>") 'self-insert-command)		; Force Tab-key to insert Tab-character.

  ;;; Abbreviations:

  (abbrev-mode 1)
  (load-file "~/.emacs.d/abbreviations.el")
  (setq save-abbrevs nil)					; Do not try to save the abbreviations.
)

(add-to-list 'auto-mode-alist '(".wp" . wp-mode))		; Associate "*.wp" files with wp-mode.