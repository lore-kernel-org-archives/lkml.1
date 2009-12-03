Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbZLCVUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbZLCVUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756582AbZLCVUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:20:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44064 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756558AbZLCVUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:20:32 -0500
Date: Thu, 3 Dec 2009 22:20:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/setup for v2.6.33
Message-ID: <20091203212026.GA32476@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-setup-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-setup-for-linus


out-of-topic modifications in x86-setup-for-linus:
--------------------------------------------------
drivers/char/vt.c                  # f6c06b6: vc: Add support for hiding the cu
drivers/video/console/vgacon.c     # b434a68: vgacon: Add support for setting t
                                   # f6c06b6: vc: Add support for hiding the cu
include/linux/screen_info.h        # d9b2635: x86, setup: Store the boot cursor
include/linux/vt_kern.h            # f6c06b6: vc: Add support for hiding the cu

 Thanks,

	Ingo

------------------>
Matthew Garrett (3):
      x86, setup: Store the boot cursor state
      vc: Add support for hiding the cursor when creating VTs
      vgacon: Add support for setting the default cursor state


 Documentation/kernel-parameters.txt |    9 +++++++++
 arch/x86/boot/video.c               |    6 ++++++
 drivers/char/vt.c                   |   11 ++++++++++-
 drivers/video/console/vgacon.c      |    5 +++++
 include/linux/screen_info.h         |    5 ++++-
 include/linux/vt_kern.h             |    3 +++
 6 files changed, 37 insertions(+), 2 deletions(-)

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
 
diff --git a/arch/x86/boot/video.c b/arch/x86/boot/video.c
index d42da38..f767164 100644
--- a/arch/x86/boot/video.c
+++ b/arch/x86/boot/video.c
@@ -27,6 +27,12 @@ static void store_cursor_position(void)
 
 	boot_params.screen_info.orig_x = oreg.dl;
 	boot_params.screen_info.orig_y = oreg.dh;
+
+	if (oreg.ch & 0x20)
+		boot_params.screen_info.flags |= VIDEO_FLAGS_NOCURSOR;
+
+	if ((oreg.ch & 0x1f) > (oreg.cl & 0x1f))
+		boot_params.screen_info.flags |= VIDEO_FLAGS_NOCURSOR;
 }
 
 static void store_video_mode(void)
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 0c80c68..1e3d728 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -161,6 +161,8 @@ static void set_palette(struct vc_data *vc);
 static int printable;		/* Is console ready for printing? */
 int default_utf8 = true;
 module_param(default_utf8, int, S_IRUGO | S_IWUSR);
+int global_cursor_default = -1;
+module_param(global_cursor_default, int, S_IRUGO | S_IWUSR);
 
 /*
  * ignore_poke: don't unblank the screen when things are typed.  This is
@@ -775,6 +777,12 @@ int vc_allocate(unsigned int currcons)	/* return 0 on success */
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
@@ -1616,7 +1624,7 @@ static void reset_terminal(struct vc_data *vc, int do_clear)
 	vc->vc_decscnm		= 0;
 	vc->vc_decom		= 0;
 	vc->vc_decawm		= 1;
-	vc->vc_deccm		= 1;
+	vc->vc_deccm		= global_cursor_default;
 	vc->vc_decim		= 0;
 
 	set_kbd(vc, decarm);
@@ -4078,6 +4086,7 @@ EXPORT_SYMBOL(fg_console);
 EXPORT_SYMBOL(console_blank_hook);
 EXPORT_SYMBOL(console_blanked);
 EXPORT_SYMBOL(vc_cons);
+EXPORT_SYMBOL(global_cursor_default);
 #ifndef VT_SINGLE_DRIVER
 EXPORT_SYMBOL(take_over_console);
 EXPORT_SYMBOL(give_up_console);
diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index da55cca..cc4bbbe 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -585,6 +585,11 @@ static void vgacon_init(struct vc_data *c, int init)
 	vgacon_uni_pagedir[1]++;
 	if (!vgacon_uni_pagedir[0] && p)
 		con_set_default_unimap(c);
+
+	/* Only set the default if the user didn't deliberately override it */
+	if (global_cursor_default == -1)
+		global_cursor_default =
+			!(screen_info.flags & VIDEO_FLAGS_NOCURSOR);
 }
 
 static void vgacon_deinit(struct vc_data *c)
diff --git a/include/linux/screen_info.h b/include/linux/screen_info.h
index 1ee2c05..899fbb4 100644
--- a/include/linux/screen_info.h
+++ b/include/linux/screen_info.h
@@ -14,7 +14,8 @@ struct screen_info {
 	__u16 orig_video_page;	/* 0x04 */
 	__u8  orig_video_mode;	/* 0x06 */
 	__u8  orig_video_cols;	/* 0x07 */
-	__u16 unused2;		/* 0x08 */
+	__u8  flags;		/* 0x08 */
+	__u8  unused2;		/* 0x09 */
 	__u16 orig_video_ega_bx;/* 0x0a */
 	__u16 unused3;		/* 0x0c */
 	__u8  orig_video_lines;	/* 0x0e */
@@ -65,6 +66,8 @@ struct screen_info {
 
 #define VIDEO_TYPE_EFI		0x70	/* EFI graphic mode		*/
 
+#define VIDEO_FLAGS_NOCURSOR	(1 << 0) /* The video mode has no cursor set */
+
 #ifdef __KERNEL__
 extern struct screen_info screen_info;
 
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
