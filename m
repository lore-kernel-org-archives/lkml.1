Return-Path: <linux-kernel-owner+w=401wt.eu-S1763458AbYALMCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763458AbYALMCT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 07:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759563AbYALMCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 07:02:03 -0500
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:50681 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759477AbYALMCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 07:02:00 -0500
X-Authuid: gaboregry1
Subject: [PATCH] kconfig: multibyte character support for lxdialog
From: EGRY Gabor <gaboregry1@t-online.hu>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-kernel@zh-kernel.org
Content-Type: text/plain
Date: Sat, 12 Jan 2008 13:01:55 +0100
Message-Id: <1200139315.2785.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


UTF-8 support for lxdialog with wchar. The installed wide ncurses (ncursesw) is optional.

Signed-off-by: Egry Gabor <gaboregry1@t-online.hu>
---

 kbuild-szilard/scripts/kconfig/lxdialog/check-lxdialog.sh |    6 
 kbuild-szilard/scripts/kconfig/lxdialog/checklist.c       |   13 -
 kbuild-szilard/scripts/kconfig/lxdialog/dialog.h          |   60 ++++++
 kbuild-szilard/scripts/kconfig/lxdialog/inputbox.c        |   32 ++-
 kbuild-szilard/scripts/kconfig/lxdialog/menubox.c         |   25 +-
 kbuild-szilard/scripts/kconfig/lxdialog/textbox.c         |   31 +--
 kbuild-szilard/scripts/kconfig/lxdialog/util.c            |  124 +++++++++++---
 kbuild-szilard/scripts/kconfig/lxdialog/yesno.c           |    5 
 8 files changed, 223 insertions(+), 73 deletions(-)

diff -puN scripts/kconfig/lxdialog/checklist.c~kconfig-i18n-04-lxdialog-multibyte scripts/kconfig/lxdialog/checklist.c
--- kbuild/scripts/kconfig/lxdialog/checklist.c~kconfig-i18n-04-lxdialog-multibyte	2008-01-12 12:21:03.000000000 +0100
+++ kbuild-szilard/scripts/kconfig/lxdialog/checklist.c	2008-01-12 12:21:03.000000000 +0100
@@ -44,9 +44,9 @@ static void print_item(WINDOW * win, int
 	wprintw(win, "(%c)", item_is_tag('X') ? 'X' : ' ');
 
 	wattrset(win, selected ? dlg.tag_selected.atr : dlg.tag.atr);
-	mvwaddch(win, choice, item_x, item_str()[0]);
+	LXD_MVWADDCH(win, choice, item_x, item_str()[0]);
 	wattrset(win, selected ? dlg.item_selected.atr : dlg.item.atr);
-	waddstr(win, (char *)item_str() + 1);
+	LXD_WADDSTR(win, &item_str()[1]);
 	if (selected) {
 		wmove(win, choice, check_x + 1);
 		wrefresh(win);
@@ -112,8 +112,9 @@ int dialog_checklist(const char *title, 
 		     int width, int list_height)
 {
 	int i, x, y, box_x, box_y;
-	int key = 0, button = 0, choice = 0, scroll = 0, max_choice;
+	int button = 0, choice = 0, scroll = 0, max_choice;
 	WINDOW *dialog, *list;
+	LXD_KEYTYPE key = 0;
 
 	/* which item to highlight */
 	item_foreach() {
@@ -173,7 +174,7 @@ do_resize:
 	/* Find length of longest item in order to center checklist */
 	check_x = 0;
 	item_foreach()
-		check_x = MAX(check_x, strlen(item_str()) + 4);
+		check_x = MAX(check_x, MIN(list_width, LXD_STRLEN(item_str()) + 4));
 
 	check_x = (list_width - check_x) / 2;
 	item_x = check_x + 4;
@@ -199,11 +200,11 @@ do_resize:
 	doupdate();
 
 	while (key != KEY_ESC) {
-		key = wgetch(dialog);
+		LXD_WGETCH(dialog, key);
 
 		for (i = 0; i < max_choice; i++) {
 			item_set(i + scroll);
-			if (toupper(key) == toupper(item_str()[0]))
+			if (LXD_TOUPPER(key) == LXD_TOUPPER(item_str()[0]))
 				break;
 		}
 
diff -puN scripts/kconfig/lxdialog/dialog.h~kconfig-i18n-04-lxdialog-multibyte scripts/kconfig/lxdialog/dialog.h
--- kbuild/scripts/kconfig/lxdialog/dialog.h~kconfig-i18n-04-lxdialog-multibyte	2008-01-12 12:21:03.000000000 +0100
+++ kbuild-szilard/scripts/kconfig/lxdialog/dialog.h	2008-01-12 12:23:17.000000000 +0100
@@ -37,6 +37,60 @@
 #endif
 #include CURSES_LOC
 
+/* Wide character support for lxdialog */
+#ifdef USE_WIDE_CURSES
+#include <wchar.h>
+#include <wctype.h>
+#define LXD_CHAR wchar_t
+#define LXD_KEYTYPE wchar_t
+#define LXD_WADDCH(a, b) waddnwstr(a, &b, 1)
+#define LXD_WADDSTR waddwstr
+#define LXD_WADDNSTR waddnwstr
+#define LXD_MVWADDCH(a, b, c, d) mvwaddnwstr(a, b, c, &d, 1)
+#define LXD_MVWADDSTR mvwaddwstr
+#define LXD_MVWADDNSTR mvwaddnwstr
+#define LXD_WGETCH(a, b) wget_wch(a, &b)
+#define LXD_STRLEN wcslen
+#define LXD_STRCPY wcscpy
+#define LXD_STRNCPY wcsncpy
+#define LXD_STRADDWCS(str1, str2, n) stradd2wcs(str1, str2, n)
+#define LXD_WCSADDSTR(str1, str2, n) wcsadd2str(str1, str2, n)
+#define LXD_STRCHR wcschr
+#define LXD_ISALPHA iswalpha
+#define LXD_ISPRINT iswprint
+#define LXD_TOLOWER towlower
+#define LXD_TOUPPER towupper
+#define LXD_STR2WCS(var1, var2) var1 = str2wcs(var2)
+#define LXD_FREE(var) free(var)
+wchar_t* str2wcs (const char *mbs);
+int stradd2wcs (wchar_t* wcs, const char *mbs, size_t n);
+int wcsadd2str (char *mbs, const wchar_t *wcs, size_t n);
+
+#else /* USE_WIDE_CURSES */
+
+#define LXD_CHAR char
+#define LXD_KEYTYPE int
+#define LXD_WADDCH(a, b) waddch(a, b)
+#define LXD_WADDSTR waddstr
+#define LXD_WADDNSTR waddnstr
+#define LXD_MVWADDCH(a, b, c, d) mvwaddch(a, b, c, d)
+#define LXD_MVWADDSTR mvwaddstr
+#define LXD_MVWADDNSTR mvwaddnstr
+#define LXD_WGETCH(a, b) b = wgetch(a)
+#define LXD_STRLEN strlen
+#define LXD_STRCPY strcpy
+#define LXD_STRNCPY strncpy
+#define LXD_WCSADDSTR(str1, str2, n) strncpy(str1, str2, n)
+#define LXD_STRADDWCS(str1, str2, n) strncpy(str1, str2, n)
+#define LXD_STRCHR strchr
+#define LXD_ISALPHA isalpha
+#define LXD_ISPRINT isprint
+#define LXD_TOLOWER tolower
+#define LXD_TOUPPER toupper
+#define LXD_STR2WCS(var1, var2) var1 = (char*)var2
+#define LXD_FREE(var)
+#endif /* USE_WIDE_CURSES */
+
 /*
  * Colors in ncurses 1.9.9e do not work properly since foreground and
  * background colors are OR'd rather than separately masked.  This version
@@ -163,7 +217,7 @@ char item_tag(void);
 /* item list manipulation for lxdialog use */
 #define MAXITEMSTR 200
 struct dialog_item {
-	char str[MAXITEMSTR];	/* promtp displayed */
+	LXD_CHAR str[MAXITEMSTR];	/* prompt displayed */
 	char tag;
 	void *data;	/* pointer to menu item - used by menubox+checklist */
 	int selected;	/* Set to 1 by dialog_*() function if selected. */
@@ -182,7 +236,7 @@ extern struct dialog_list *item_head;
 int item_count(void);
 void item_set(int n);
 int item_n(void);
-const char *item_str(void);
+const LXD_CHAR *item_str(void);
 int item_is_selected(void);
 int item_is_tag(char tag);
 #define item_foreach() \
@@ -205,7 +259,7 @@ void draw_box(WINDOW * win, int y, int x
 	      chtype border);
 void draw_shadow(WINDOW * win, int y, int x, int height, int width);
 
-int first_alpha(const char *string, const char *exempt);
+int first_alpha(const LXD_CHAR *string, const char *exempt);
 int dialog_yesno(const char *title, const char *prompt, int height, int width);
 int dialog_msgbox(const char *title, const char *prompt, int height,
 		  int width, int pause);
diff -puN scripts/kconfig/lxdialog/inputbox.c~kconfig-i18n-04-lxdialog-multibyte scripts/kconfig/lxdialog/inputbox.c
--- kbuild/scripts/kconfig/lxdialog/inputbox.c~kconfig-i18n-04-lxdialog-multibyte	2008-01-12 12:21:03.000000000 +0100
+++ kbuild-szilard/scripts/kconfig/lxdialog/inputbox.c	2008-01-12 12:21:03.000000000 +0100
@@ -45,14 +45,15 @@ int dialog_inputbox(const char *title, c
                     const char *init)
 {
 	int i, x, y, box_y, box_x, box_width;
-	int input_x = 0, scroll = 0, key = 0, button = -1;
-	char *instr = dialog_input_result;
+	int input_x = 0, scroll = 0, button = -1;
+	LXD_CHAR instr[MAX_LEN + 1];
+	LXD_KEYTYPE key = 0;
 	WINDOW *dialog;
 
 	if (!init)
 		instr[0] = '\0';
 	else
-		strcpy(instr, init);
+		LXD_STRADDWCS(instr, init, MAX_LEN + 1);
 
 do_resize:
 	if (getmaxy(stdscr) <= (height - 2))
@@ -97,15 +98,15 @@ do_resize:
 	wmove(dialog, box_y, box_x);
 	wattrset(dialog, dlg.inputbox.atr);
 
-	input_x = strlen(instr);
+	input_x = LXD_STRLEN(instr);
 
 	if (input_x >= box_width) {
 		scroll = input_x - box_width + 1;
 		input_x = box_width - 1;
 		for (i = 0; i < box_width - 1; i++)
-			waddch(dialog, instr[scroll + i]);
+			LXD_WADDCH(dialog, instr[scroll + i]);
 	} else {
-		waddstr(dialog, instr);
+		LXD_WADDSTR(dialog, instr);
 	}
 
 	wmove(dialog, box_y, box_x + input_x);
@@ -113,7 +114,7 @@ do_resize:
 	wrefresh(dialog);
 
 	while (key != KEY_ESC) {
-		key = wgetch(dialog);
+		LXD_WGETCH(dialog, key);
 
 		if (button == -1) {	/* Input box selected */
 			switch (key) {
@@ -133,10 +134,10 @@ do_resize:
 						scroll = scroll < box_width - 1 ? 0 : scroll - (box_width - 1);
 						wmove(dialog, box_y, box_x);
 						for (i = 0; i < box_width; i++)
-							waddch(dialog,
-							       instr[scroll + input_x + i] ?
-							       instr[scroll + input_x + i] : ' ');
-						input_x = strlen(instr) - scroll;
+							instr[scroll + input_x + i] ?
+								LXD_WADDCH(dialog, instr[scroll + input_x + i]) :
+								waddch(dialog, ' ');
+						input_x = LXD_STRLEN(instr) - scroll;
 					} else
 						input_x--;
 					instr[scroll + input_x] = '\0';
@@ -146,7 +147,7 @@ do_resize:
 				}
 				continue;
 			default:
-				if (key < 0x100 && isprint(key)) {
+				if (LXD_ISPRINT(key)) {
 					if (scroll + input_x < MAX_LEN) {
 						wattrset(dialog, dlg.inputbox.atr);
 						instr[scroll + input_x] = key;
@@ -155,10 +156,10 @@ do_resize:
 							scroll++;
 							wmove(dialog, box_y, box_x);
 							for (i = 0; i < box_width - 1; i++)
-								waddch(dialog, instr [scroll + i]);
+								LXD_WADDCH(dialog, instr[scroll + i]);
 						} else {
 							wmove(dialog, box_y, input_x++ + box_x);
-							waddch(dialog, key);
+							LXD_WADDCH(dialog, key);
 						}
 						wrefresh(dialog);
 					} else
@@ -170,10 +171,12 @@ do_resize:
 		switch (key) {
 		case 'O':
 		case 'o':
+			LXD_WCSADDSTR(dialog_input_result, instr, MAX_LEN + 1);
 			delwin(dialog);
 			return 0;
 		case 'H':
 		case 'h':
+			LXD_WCSADDSTR(dialog_input_result, instr, MAX_LEN + 1);
 			delwin(dialog);
 			return 1;
 		case KEY_UP:
@@ -217,6 +220,7 @@ do_resize:
 			break;
 		case ' ':
 		case '\n':
+			LXD_WCSADDSTR(dialog_input_result, instr, MAX_LEN + 1);
 			delwin(dialog);
 			return (button == -1 ? 0 : button);
 		case 'X':
diff -puN scripts/kconfig/lxdialog/menubox.c~kconfig-i18n-04-lxdialog-multibyte scripts/kconfig/lxdialog/menubox.c
--- kbuild/scripts/kconfig/lxdialog/menubox.c~kconfig-i18n-04-lxdialog-multibyte	2008-01-12 12:21:03.000000000 +0100
+++ kbuild-szilard/scripts/kconfig/lxdialog/menubox.c	2008-01-12 12:55:15.000000000 +0100
@@ -63,13 +63,13 @@ static int menu_width, item_x;
 /*
  * Print menu item
  */
-static void do_print_item(WINDOW * win, const char *item, int line_y,
+static void do_print_item(WINDOW * win, const LXD_CHAR *item, int line_y,
                           int selected, int hotkey)
 {
 	int j;
-	char *menu_item = malloc(menu_width + 1);
+	LXD_CHAR *menu_item = malloc((menu_width + 1) * sizeof(LXD_CHAR));
 
-	strncpy(menu_item, item, menu_width - item_x);
+	LXD_STRNCPY(menu_item, item, menu_width - item_x);
 	menu_item[menu_width - item_x] = '\0';
 	j = first_alpha(menu_item, "YyNnMmHh");
 
@@ -86,11 +86,11 @@ static void do_print_item(WINDOW * win, 
 	wclrtoeol(win);
 #endif
 	wattrset(win, selected ? dlg.item_selected.atr : dlg.item.atr);
-	mvwaddstr(win, line_y, item_x, menu_item);
+	LXD_MVWADDSTR(win, line_y, item_x, menu_item);
 	if (hotkey) {
 		wattrset(win, selected ? dlg.tag_key_selected.atr
 			 : dlg.tag_key.atr);
-		mvwaddch(win, line_y, item_x + j, menu_item[j]);
+		LXD_MVWADDCH(win, line_y, item_x + j, menu_item[j]);
 	}
 	if (selected) {
 		wmove(win, line_y, item_x + 1);
@@ -184,9 +184,10 @@ int dialog_menu(const char *title, const
 {
 	int i, j, x, y, box_x, box_y;
 	int height, width, menu_height;
-	int key = 0, button = 0, scroll = 0, choice = 0;
+	int button = 0, scroll = 0, choice = 0;
 	int first_item =  0, max_choice;
 	WINDOW *dialog, *menu;
+	LXD_KEYTYPE key = 0;
 
 do_resize:
 	height = getmaxy(stdscr);
@@ -278,25 +279,25 @@ do_resize:
 	wrefresh(menu);
 
 	while (key != KEY_ESC) {
-		key = wgetch(menu);
+		LXD_WGETCH(menu, key);
 
-		if (key < 256 && isalpha(key))
-			key = tolower(key);
+		if (key < 256 && LXD_ISALPHA(key))
+			key = LXD_TOLOWER(key);
 
-		if (strchr("ynmh", key))
+		if (strchr("ynmh", (int)key))
 			i = max_choice;
 		else {
 			for (i = choice + 1; i < max_choice; i++) {
 				item_set(scroll + i);
 				j = first_alpha(item_str(), "YyNnMmHh");
-				if (key == tolower(item_str()[j]))
+				if (key == LXD_TOLOWER(item_str()[j]))
 					break;
 			}
 			if (i == max_choice)
 				for (i = 0; i < max_choice; i++) {
 					item_set(scroll + i);
 					j = first_alpha(item_str(), "YyNnMmHh");
-					if (key == tolower(item_str()[j]))
+					if (key == LXD_TOLOWER(item_str()[j]))
 						break;
 				}
 		}
diff -puN scripts/kconfig/lxdialog/textbox.c~kconfig-i18n-04-lxdialog-multibyte scripts/kconfig/lxdialog/textbox.c
--- kbuild/scripts/kconfig/lxdialog/textbox.c~kconfig-i18n-04-lxdialog-multibyte	2008-01-12 12:21:03.000000000 +0100
+++ kbuild-szilard/scripts/kconfig/lxdialog/textbox.c	2008-01-12 12:21:03.000000000 +0100
@@ -24,13 +24,13 @@
 static void back_lines(int n);
 static void print_page(WINDOW * win, int height, int width);
 static void print_line(WINDOW * win, int row, int width);
-static char *get_line(void);
+static LXD_CHAR *get_line(void);
 static void print_position(WINDOW * win);
 
 static int hscroll;
 static int begin_reached, end_reached, page_length;
-static const char *buf;
-static const char *page;
+static LXD_CHAR *buf;
+static const LXD_CHAR *page;
 
 /*
  * refresh window content
@@ -51,16 +51,17 @@ static void refresh_text_box(WINDOW *dia
 int dialog_textbox(const char *title, const char *tbuf,
 		   int initial_height, int initial_width)
 {
-	int i, x, y, cur_x, cur_y, key = 0;
+	int i, x, y, cur_x, cur_y;
 	int height, width, boxh, boxw;
 	int passed_end;
 	WINDOW *dialog, *box;
+	LXD_KEYTYPE key = 0;
 
 	begin_reached = 1;
 	end_reached = 0;
 	page_length = 0;
 	hscroll = 0;
-	buf = tbuf;
+	LXD_STR2WCS(buf, tbuf);
 	page = buf;	/* page is pointer to start of page to be displayed */
 
 do_resize:
@@ -123,7 +124,7 @@ do_resize:
 	refresh_text_box(dialog, box, boxh, boxw, cur_y, cur_x);
 
 	while ((key != KEY_ESC) && (key != '\n')) {
-		key = wgetch(dialog);
+		LXD_WGETCH(dialog, key);
 		switch (key) {
 		case 'E':	/* Exit */
 		case 'e':
@@ -146,7 +147,7 @@ do_resize:
 
 			end_reached = 1;
 			/* point to last char in buf */
-			page = buf + strlen(buf);
+			page = &buf[LXD_STRLEN(buf)];
 			back_lines(boxh);
 			refresh_text_box(dialog, box, boxh, boxw,
 					 cur_y, cur_x);
@@ -321,13 +322,13 @@ static void print_page(WINDOW * win, int
 static void print_line(WINDOW * win, int row, int width)
 {
 	int y, x;
-	char *line;
+	LXD_CHAR *line;
 
 	line = get_line();
-	line += MIN(strlen(line), hscroll);	/* Scroll horizontally */
+	line += MIN(LXD_STRLEN(line), hscroll) * sizeof(LXD_CHAR);	/* Scroll horizontally */
 	wmove(win, row, 0);	/* move cursor to correct line */
 	waddch(win, ' ');
-	waddnstr(win, line, MIN(strlen(line), width - 2));
+	LXD_WADDNSTR(win, line, MIN(LXD_STRLEN(line), width - 2));
 
 	getyx(win, y, x);
 	/* Clear 'residue' of previous line */
@@ -337,9 +338,9 @@ static void print_line(WINDOW * win, int
 		for (i = 0; i < width - x; i++)
 			waddch(win, ' ');
 	}
-#else
+#else /* OLD_NCURSES */
 	wclrtoeol(win);
-#endif
+#endif /* OLD_NCURSES */
 }
 
 /*
@@ -347,10 +348,10 @@ static void print_line(WINDOW * win, int
  * 'page' should point to start of current line before calling, and will be
  * updated to point to start of next line.
  */
-static char *get_line(void)
+static LXD_CHAR *get_line(void)
 {
 	int i = 0;
-	static char line[MAX_LEN + 1];
+	static LXD_CHAR line[MAX_LEN + 1];
 
 	end_reached = 0;
 	while (*page != '\n') {
@@ -385,7 +386,7 @@ static void print_position(WINDOW * win)
 
 	wattrset(win, dlg.position_indicator.atr);
 	wbkgdset(win, dlg.position_indicator.atr & A_COLOR);
-	percent = (page - buf) * 100 / strlen(buf);
+	percent = (page - buf) * 100 / LXD_STRLEN(buf);
 	wmove(win, getmaxy(win) - 3, getmaxx(win) - 9);
 	wprintw(win, "(%3d%%)", percent);
 }
diff -puN scripts/kconfig/lxdialog/util.c~kconfig-i18n-04-lxdialog-multibyte scripts/kconfig/lxdialog/util.c
--- kbuild/scripts/kconfig/lxdialog/util.c~kconfig-i18n-04-lxdialog-multibyte	2008-01-12 12:21:03.000000000 +0100
+++ kbuild-szilard/scripts/kconfig/lxdialog/util.c	2008-01-12 12:48:28.000000000 +0100
@@ -309,12 +309,15 @@ void end_dialog(int x, int y)
  **/
 void print_title(WINDOW *dialog, const char *title, int width)
 {
+	LXD_CHAR *wtitle;
 	if (title) {
-		int tlen = MIN(width - 2, strlen(title));
+		LXD_STR2WCS(wtitle, title);
+		int tlen = MIN(width - 2, LXD_STRLEN(wtitle));
 		wattrset(dialog, dlg.title.atr);
 		mvwaddch(dialog, 0, (width - tlen) / 2 - 1, ' ');
-		mvwaddnstr(dialog, 0, (width - tlen)/2, title, tlen);
+		LXD_MVWADDNSTR(dialog, 0, (width - tlen)  / 2, wtitle, tlen);
 		waddch(dialog, ' ');
+		LXD_FREE(wtitle);
 	}
 }
 
@@ -328,11 +331,11 @@ void print_autowrap(WINDOW * win, const 
 {
 	int newl, cur_x, cur_y;
 	int i, prompt_len, room, wlen;
-	char tempstr[MAX_LEN + 1], *word, *sp, *sp2;
+	LXD_CHAR tempstr[MAX_LEN + 1], *word, *sp, *sp2;
 
-	strcpy(tempstr, prompt);
+	LXD_STRADDWCS(tempstr, prompt, MAX_LEN + 1);
 
-	prompt_len = strlen(tempstr);
+	prompt_len = LXD_STRLEN(tempstr);
 
 	/*
 	 * Remove newlines
@@ -344,14 +347,14 @@ void print_autowrap(WINDOW * win, const 
 
 	if (prompt_len <= width - x * 2) {	/* If prompt is short */
 		wmove(win, y, (width - prompt_len) / 2);
-		waddstr(win, tempstr);
+		LXD_WADDSTR(win, tempstr);
 	} else {
 		cur_x = x;
 		cur_y = y;
 		newl = 1;
 		word = tempstr;
 		while (word && *word) {
-			sp = strchr(word, ' ');
+			sp = LXD_STRCHR(word, ' ');
 			if (sp)
 				*sp++ = 0;
 
@@ -359,17 +362,17 @@ void print_autowrap(WINDOW * win, const 
 			   or it is the first word of a new sentence, and it is
 			   short, and the next word does not fit. */
 			room = width - cur_x;
-			wlen = strlen(word);
+			wlen = LXD_STRLEN(word);
 			if (wlen > room ||
 			    (newl && wlen < 4 && sp
-			     && wlen + 1 + strlen(sp) > room
-			     && (!(sp2 = strchr(sp, ' '))
+			     && wlen + 1 + LXD_STRLEN(sp) > room
+			     && (!(sp2 = LXD_STRCHR(sp, ' '))
 				 || wlen + 1 + (sp2 - sp) > room))) {
 				cur_y++;
 				cur_x = x;
 			}
 			wmove(win, cur_y, cur_x);
-			waddstr(win, word);
+			LXD_WADDSTR(win, word);
 			getyx(win, cur_y, cur_x);
 			cur_x++;
 			if (sp && *sp == ' ') {
@@ -389,6 +392,7 @@ void print_autowrap(WINDOW * win, const 
 void print_button(WINDOW * win, const char *label, int y, int x, int selected)
 {
 	int i, temp;
+	LXD_CHAR *wlabel;
 
 	wmove(win, y, x);
 	wattrset(win, selected ? dlg.button_active.atr
@@ -396,20 +400,22 @@ void print_button(WINDOW * win, const ch
 	waddstr(win, "<");
 	temp = strspn(label, " ");
 	label += temp;
+	LXD_STR2WCS(wlabel, label);
 	wattrset(win, selected ? dlg.button_label_active.atr
 		 : dlg.button_label_inactive.atr);
 	for (i = 0; i < temp; i++)
 		waddch(win, ' ');
 	wattrset(win, selected ? dlg.button_key_active.atr
 		 : dlg.button_key_inactive.atr);
-	waddch(win, label[0]);
+	waddch(win, wlabel[0]);
 	wattrset(win, selected ? dlg.button_label_active.atr
 		 : dlg.button_label_inactive.atr);
-	waddstr(win, (char *)label + 1);
+	LXD_WADDSTR(win, &wlabel[1]);
 	wattrset(win, selected ? dlg.button_active.atr
 		 : dlg.button_inactive.atr);
 	waddstr(win, ">");
 	wmove(win, y, x + temp + 1);
+	LXD_FREE(wlabel);
 }
 
 /*
@@ -471,19 +477,19 @@ void draw_shadow(WINDOW * win, int y, in
 /*
  *  Return the position of the first alphabetic character in a string.
  */
-int first_alpha(const char *string, const char *exempt)
+int first_alpha(const LXD_CHAR *string, const char *exempt)
 {
 	int i, in_paren = 0, c;
 
-	for (i = 0; i < strlen(string); i++) {
-		c = tolower(string[i]);
+	for (i = 0; i < LXD_STRLEN(string); i++) {
+		c = LXD_TOLOWER(string[i]);
 
 		if (strchr("<[(", c))
 			++in_paren;
 		if (strchr(">])", c) && in_paren > 0)
 			--in_paren;
 
-		if ((!in_paren) && isalpha(c) && strchr(exempt, c) == 0)
+		if ((!in_paren) && LXD_ISALPHA(c) && strchr(exempt, c) == 0)
 			return i;
 	}
 
@@ -548,6 +554,10 @@ void item_reset(void)
 void item_make(const char *fmt, ...)
 {
 	va_list ap;
+#ifdef USE_WIDE_CURSES
+	char *tempstr;
+	size_t n;
+#endif /* USE_WIDE_CHAR */
 	struct dialog_list *p = malloc(sizeof(*p));
 
 	if (item_head)
@@ -558,21 +568,39 @@ void item_make(const char *fmt, ...)
 	memset(p, 0, sizeof(*p));
 
 	va_start(ap, fmt);
+#ifdef USE_WIDE_CURSES
+	n = sizeof(item_cur->node.str) / sizeof(LXD_CHAR);
+	tempstr = malloc(n + 1);
+	vsnprintf(tempstr, n, fmt, ap);
+	LXD_STRADDWCS(item_cur->node.str, tempstr, n);
+	free(tempstr);
+#else /* USE_WIDE_CHAR */
 	vsnprintf(item_cur->node.str, sizeof(item_cur->node.str), fmt, ap);
+#endif /* USE_WIDE_CHAR */
 	va_end(ap);
 }
 
 void item_add_str(const char *fmt, ...)
 {
 	va_list ap;
+#ifdef USE_WIDE_CURSES
+	char *tempstr;
+#endif /* USE_WIDE_CHAR */
         size_t avail;
 
-	avail = sizeof(item_cur->node.str) - strlen(item_cur->node.str);
+	avail = sizeof(item_cur->node.str)  / sizeof(LXD_CHAR) - LXD_STRLEN(item_cur->node.str);
 
 	va_start(ap, fmt);
+#ifdef USE_WIDE_CURSES
+	tempstr = malloc(avail);
+	vsnprintf(tempstr, avail, fmt, ap);
+	LXD_STRADDWCS(&item_cur->node.str[LXD_STRLEN(item_cur->node.str)], tempstr, avail);
+	free(tempstr);
+#else /* USE_WIDE_CHAR */
 	vsnprintf(item_cur->node.str + strlen(item_cur->node.str),
 		  avail, fmt, ap);
-	item_cur->node.str[sizeof(item_cur->node.str) - 1] = '\0';
+#endif /* USE_WIDE_CHAR */
+	item_cur->node.str[sizeof(item_cur->node.str) / sizeof(LXD_CHAR) - 1] = '\0';
 	va_end(ap);
 }
 
@@ -639,7 +667,7 @@ int item_n(void)
 	return 0;
 }
 
-const char *item_str(void)
+const LXD_CHAR *item_str(void)
 {
 	return item_cur->node.str;
 }
@@ -653,3 +681,59 @@ int item_is_tag(char tag)
 {
 	return (item_cur->node.tag == tag);
 }
+
+#ifdef USE_WIDE_CURSES
+/* Return the wide char version of multibyte character */
+wchar_t* str2wcs (const char *mbs)
+{
+	wchar_t *wcs;
+	size_t n;
+
+	if (mbs) {
+		n = (2 + strlen(mbs)) * sizeof(wchar_t);
+    		wcs = (wchar_t*) malloc (n);
+    		if (stradd2wcs(wcs, mbs, n) != 0) {
+			free (wcs);
+        		wcs = 0;
+    		}
+	}
+	else
+    	    wcs = 0;
+
+	return wcs;
+}
+
+/* Copy a multibyte string into the allocated widechar string */
+int stradd2wcs (wchar_t *wcs, const char *mbs, size_t n)
+{
+	mbstate_t state;
+	const char *mbsptr;
+
+	if (mbs) {
+    		memset (&state, 0, sizeof(state));
+    		mbsptr = mbs;
+    		if (mbsrtowcs (wcs, &mbsptr, n, &state) < 0)
+    			return -1;
+		return 0;
+	}
+
+	return -1;
+}
+
+/* Copy a widechar string into the allocated multibyte string */
+int wcsadd2str (char *mbs, const wchar_t *wcs, size_t n)
+{
+	mbstate_t state;
+	const wchar_t *wcsptr;
+
+	if (wcs) {
+    		memset (&state, 0, sizeof(state));
+    		wcsptr = wcs;
+    		if (wcsrtombs (mbs, &wcsptr, n, &state) < 0)
+    			return -1;
+		return 0;
+	}
+
+	return -1;
+}
+#endif /* USE_WIDE_CURSES */
diff -puN scripts/kconfig/lxdialog/yesno.c~kconfig-i18n-04-lxdialog-multibyte scripts/kconfig/lxdialog/yesno.c
--- kbuild/scripts/kconfig/lxdialog/yesno.c~kconfig-i18n-04-lxdialog-multibyte	2008-01-12 12:21:03.000000000 +0100
+++ kbuild-szilard/scripts/kconfig/lxdialog/yesno.c	2008-01-12 12:21:03.000000000 +0100
@@ -41,8 +41,9 @@ static void print_buttons(WINDOW * dialo
  */
 int dialog_yesno(const char *title, const char *prompt, int height, int width)
 {
-	int i, x, y, key = 0, button = 0;
+	int i, x, y, button = 0;
 	WINDOW *dialog;
+	LXD_KEYTYPE key = 0;
 
 do_resize:
 	if (getmaxy(stdscr) < (height + 4))
@@ -76,7 +77,7 @@ do_resize:
 	print_buttons(dialog, height, width, 0);
 
 	while (key != KEY_ESC) {
-		key = wgetch(dialog);
+		LXD_WGETCH(dialog, key);
 		switch (key) {
 		case 'Y':
 		case 'y':
diff -puN scripts/kconfig/lxdialog/check-lxdialog.sh~kconfig-i18n-04-lxdialog-multibyte scripts/kconfig/lxdialog/check-lxdialog.sh
--- kbuild/scripts/kconfig/lxdialog/check-lxdialog.sh~kconfig-i18n-04-lxdialog-multibyte	2008-01-12 12:21:03.000000000 +0100
+++ kbuild-szilard/scripts/kconfig/lxdialog/check-lxdialog.sh	2008-01-12 12:54:51.000000000 +0100
@@ -19,7 +19,11 @@ ldflags()
 # Where is ncurses.h?
 ccflags()
 {
-	if [ -f /usr/include/ncurses/ncurses.h ]; then
+	if [ -f /usr/include/ncursesw/curses.h ]; then
+		echo '-DCURSES_LOC="<ncursesw/curses.h>" -DUSE_WIDE_CURSES'
+	elif [ -f /usr/include/ncursesw/ncurses.h ]; then
+		echo '-DCURSES_LOC="<ncursesw/ncurses.h>" -DUSE_WIDE_CURSES'
+	elif [ -f /usr/include/ncurses/ncurses.h ]; then
 		echo '-I/usr/include/ncurses -DCURSES_LOC="<ncurses.h>"'
 	elif [ -f /usr/include/ncurses/curses.h ]; then
 		echo '-I/usr/include/ncurses -DCURSES_LOC="<ncurses/curses.h>"'
_

