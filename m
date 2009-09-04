Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbZIDPmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbZIDPmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 11:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbZIDPmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 11:42:14 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56721 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116AbZIDPmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 11:42:14 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] VT: Add a boot option to disable cursor on boot
Date: Fri,  4 Sep 2009 11:48:09 -0400
Message-Id: <1252079289-5383-1-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.4.1
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 146.115.120.20
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VT code currently enables a visible cursor on boot. This is a fairly
unnecessary visual distraction for setups which boot to a splash screen
before going directly into X, so add a boot option (vt.hide_boot_cursor=1)
that doesn't enable the cursor for initial VT setup. VT resets and any
later VT creation will leave the cursor turned on, as before.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 Documentation/kernel-parameters.txt |    6 ++++++
 drivers/char/vt.c                   |   23 ++++++++++++++---------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7936b80..c60ce61 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2645,6 +2645,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			Default is 1, i.e. UTF-8 mode is enabled for all
 			newly opened terminals.
 
+	vt.hide_boot_cursor=
+			[VT]
+			Format=<0|1>
+			Hide the VT cursor on boot. Default is 0, resulting
+			in the cursor being shown by default.
+
 	waveartist=	[HW,OSS]
 			Format: <io>,<irq>,<dma>,<dma2>
 
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 404f4c1..a885311 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -146,10 +146,12 @@ static const struct consw *con_driver_map[MAX_NR_CONSOLES];
 
 static int con_open(struct tty_struct *, struct file *);
 static void vc_init(struct vc_data *vc, unsigned int rows,
-		    unsigned int cols, int do_clear);
+		    unsigned int cols, int do_clear,
+		    int show_cursor);
 static void gotoxy(struct vc_data *vc, int new_x, int new_y);
 static void save_cur(struct vc_data *vc);
-static void reset_terminal(struct vc_data *vc, int do_clear);
+static void reset_terminal(struct vc_data *vc, int do_clear,
+			   int show_cursor);
 static void con_flush_chars(struct tty_struct *tty);
 static int set_vesa_blanking(char __user *p);
 static void set_cursor(struct vc_data *vc);
@@ -159,6 +161,8 @@ static void blank_screen_t(unsigned long dummy);
 static void set_palette(struct vc_data *vc);
 
 static int printable;		/* Is console ready for printing? */
+static int hide_boot_cursor;	/* Show the cursor at boot time? */
+module_param(hide_boot_cursor, int, S_IRUGO | S_IWUSR);
 int default_utf8 = true;
 module_param(default_utf8, int, S_IRUGO | S_IWUSR);
 
@@ -776,7 +780,7 @@ int vc_allocate(unsigned int currcons)	/* return 0 on success */
 		vc_cons[currcons].d = NULL;
 		return -ENOMEM;
 	    }
-	    vc_init(vc, vc->vc_rows, vc->vc_cols, 1);
+	    vc_init(vc, vc->vc_rows, vc->vc_cols, 1, 1);
 	    vcs_make_sysfs(currcons);
 	    atomic_notifier_call_chain(&vt_notifier_list, VT_ALLOCATE, &param);
 	}
@@ -1595,7 +1599,7 @@ enum { ESnormal, ESesc, ESsquare, ESgetpars, ESgotpars, ESfunckey,
 	ESpalette };
 
 /* console_sem is held (except via vc_init()) */
-static void reset_terminal(struct vc_data *vc, int do_clear)
+static void reset_terminal(struct vc_data *vc, int do_clear, int show_cursor)
 {
 	vc->vc_top		= 0;
 	vc->vc_bottom		= vc->vc_rows;
@@ -1616,7 +1620,7 @@ static void reset_terminal(struct vc_data *vc, int do_clear)
 	vc->vc_decscnm		= 0;
 	vc->vc_decom		= 0;
 	vc->vc_decawm		= 1;
-	vc->vc_deccm		= 1;
+	vc->vc_deccm		= show_cursor;
 	vc->vc_decim		= 0;
 
 	set_kbd(vc, decarm);
@@ -1756,7 +1760,7 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 			vc->vc_state = EShash;
 			return;
 		case 'c':
-			reset_terminal(vc, 1);
+			reset_terminal(vc, 1, 1);
 			return;
 		case '>':  /* Numeric keypad */
 			clr_kbd(vc, kbdapplic);
@@ -2803,7 +2807,7 @@ module_param_named(italic, default_italic_color, int, S_IRUGO | S_IWUSR);
 module_param_named(underline, default_underline_color, int, S_IRUGO | S_IWUSR);
 
 static void vc_init(struct vc_data *vc, unsigned int rows,
-		    unsigned int cols, int do_clear)
+		    unsigned int cols, int do_clear, int show_cursor)
 {
 	int j, k ;
 
@@ -2825,7 +2829,7 @@ static void vc_init(struct vc_data *vc, unsigned int rows,
 	vc->vc_itcolor         = default_italic_color;
 	vc->vc_halfcolor       = 0x08;   /* grey */
 	init_waitqueue_head(&vc->paste_wait);
-	reset_terminal(vc, do_clear);
+	reset_terminal(vc, do_clear, show_cursor);
 }
 
 /*
@@ -2877,7 +2881,8 @@ static int __init con_init(void)
 		visual_init(vc, currcons, 1);
 		vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_NOWAIT);
 		vc_init(vc, vc->vc_rows, vc->vc_cols,
-			currcons || !vc->vc_sw->con_save_screen);
+			currcons || !vc->vc_sw->con_save_screen,
+			!hide_boot_cursor);
 	}
 	currcons = fg_console = 0;
 	master_display_fg = vc = vc_cons[currcons].d;
-- 
1.6.4.1

