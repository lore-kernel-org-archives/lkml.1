Return-Path: <linux-kernel-owner+w=401wt.eu-S932374AbZKMT6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbZKMT6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932299AbZKMT55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:57:57 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:37302 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284AbZKMT5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:57:52 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, gregkh@suse.de, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/3] vc: Add support for hiding the cursor when creating VTs
Date: Fri, 13 Nov 2009 14:57:01 -0500
Message-Id: <1258142222-16092-2-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1258142222-16092-1-git-send-email-mjg@redhat.com>
References: <1258142222-16092-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for setting a global default for whether or not a visible
cursor should be enabled when creating VCs. The default will be to do so,
unless overridden by the user at boot time or by a driver.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 Documentation/kernel-parameters.txt |    9 +++++++++
 drivers/char/vt.c                   |   22 ++++++++++++++++------
 drivers/video/console/vgacon.c      |    2 ++
 include/linux/vt_kern.h             |    3 +++
 4 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9107b38..dd42eb6 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2729,6 +2729,15 @@ and is between 256 and 4096 characters. It is defined in the file
 			Default is 1, i.e. UTF-8 mode is enabled for all
 			newly opened terminals.
 
+	vt.global_cursor_default=
+			[VT]
+			Format=<-1|0|1>
+			Set system-wide default for whether a cursor
+			is shown on new VTs. Default is -1,
+			i.e. cursors will be created by default unless
+			overridden by individual drivers. 0 will hide
+			cursors, 1 will display them.
+
 	waveartist=	[HW,OSS]
 			Format: <io>,<irq>,<dma>,<dma2>
 
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 0c80c68..eccd532 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -146,10 +146,11 @@ static const struct consw *con_driver_map[MAX_NR_CONSOLES];
 
 static int con_open(struct tty_struct *, struct file *);
 static void vc_init(struct vc_data *vc, unsigned int rows,
-		    unsigned int cols, int do_clear);
+		    unsigned int cols, int do_clear)
 static void gotoxy(struct vc_data *vc, int new_x, int new_y);
 static void save_cur(struct vc_data *vc);
-static void reset_terminal(struct vc_data *vc, int do_clear);
+static void reset_terminal(struct vc_data *vc, int do_clear,
+			   int show_cursor);
 static void con_flush_chars(struct tty_struct *tty);
 static int set_vesa_blanking(char __user *p);
 static void set_cursor(struct vc_data *vc);
@@ -161,6 +162,8 @@ static void set_palette(struct vc_data *vc);
 static int printable;		/* Is console ready for printing? */
 int default_utf8 = true;
 module_param(default_utf8, int, S_IRUGO | S_IWUSR);
+static int global_cursor_default = -1;
+module_param(global_cursor_default, int, S_IRUGO | S_IWUSR);
 
 /*
  * ignore_poke: don't unblank the screen when things are typed.  This is
@@ -775,6 +778,12 @@ int vc_allocate(unsigned int currcons)	/* return 0 on success */
 		vc_cons[currcons].d = NULL;
 		return -ENOMEM;
 	    }
+
+	    /* If no drivers have overridden us and the user didn't pass a
+	       boot option, default to displaying the cursor */
+	    if (global_cursor_default == -1)
+		    global_cursor_default = 1;
+
 	    vc_init(vc, vc->vc_rows, vc->vc_cols, 1);
 	    vcs_make_sysfs(currcons);
 	    atomic_notifier_call_chain(&vt_notifier_list, VT_ALLOCATE, &param);
@@ -1616,7 +1625,7 @@ static void reset_terminal(struct vc_data *vc, int do_clear)
 	vc->vc_decscnm		= 0;
 	vc->vc_decom		= 0;
 	vc->vc_decawm		= 1;
-	vc->vc_deccm		= 1;
+	vc->vc_deccm		= global_cursor_default;
 	vc->vc_decim		= 0;
 
 	set_kbd(vc, decarm);
@@ -1756,7 +1765,7 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 			vc->vc_state = EShash;
 			return;
 		case 'c':
-			reset_terminal(vc, 1);
+			reset_terminal(vc, 1, 1);
 			return;
 		case '>':  /* Numeric keypad */
 			clr_kbd(vc, kbdapplic);
@@ -2821,7 +2830,7 @@ static void vc_init(struct vc_data *vc, unsigned int rows,
 	vc->vc_itcolor         = default_italic_color;
 	vc->vc_halfcolor       = 0x08;   /* grey */
 	init_waitqueue_head(&vc->paste_wait);
-	reset_terminal(vc, do_clear);
+	reset_terminal(vc, do_clear, show_cursor);
 }
 
 /*
@@ -2873,7 +2882,7 @@ static int __init con_init(void)
 		visual_init(vc, currcons, 1);
 		vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_NOWAIT);
 		vc_init(vc, vc->vc_rows, vc->vc_cols,
-			currcons || !vc->vc_sw->con_save_screen);
+			currcons || !vc->vc_sw->con_save_screen)
 	}
 	currcons = fg_console = 0;
 	master_display_fg = vc = vc_cons[currcons].d;
@@ -4078,6 +4087,7 @@ EXPORT_SYMBOL(fg_console);
 EXPORT_SYMBOL(console_blank_hook);
 EXPORT_SYMBOL(console_blanked);
 EXPORT_SYMBOL(vc_cons);
+EXPORT_SYMBOL(global_cursor_default);
 #ifndef VT_SINGLE_DRIVER
 EXPORT_SYMBOL(take_over_console);
 EXPORT_SYMBOL(give_up_console);
diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index da55cca..564643e 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -585,6 +585,8 @@ static void vgacon_init(struct vc_data *c, int init)
 	vgacon_uni_pagedir[1]++;
 	if (!vgacon_uni_pagedir[0] && p)
 		con_set_default_unimap(c);
+
+	hide_boot_cursor(screen_info.flags & VIDEO_FLAGS_NOCURSOR);
 }
 
 static void vgacon_deinit(struct vc_data *c)
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index c0c4e11..7f56db4 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -110,6 +110,7 @@ extern char con_buf[CON_BUF_SIZE];
 extern struct mutex con_buf_mtx;
 extern char vt_dont_switch;
 extern int default_utf8;
+extern int global_cursor_default;
 
 struct vt_spawn_console {
 	spinlock_t lock;
@@ -130,4 +131,6 @@ struct vt_notifier_param {
 extern int register_vt_notifier(struct notifier_block *nb);
 extern int unregister_vt_notifier(struct notifier_block *nb);
 
+extern void hide_boot_cursor(bool hide);
+
 #endif /* _VT_KERN_H */
-- 
1.6.5.2

