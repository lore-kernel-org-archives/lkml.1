Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbZIKT5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbZIKT5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbZIKT5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:57:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42030 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978AbZIKT5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:57:30 -0400
Date: Fri, 11 Sep 2009 21:57:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] x86/setup for v2.6.32
Message-ID: <20090911195720.GA1146@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-setup-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-setup-for-linus

 Thanks,

	Ingo

------------------>
Cyrill Gorcunov (1):
      x86, e820: Guard against array overflowed in __e820_add_region()

H. Peter Anvin (1):
      x86, setup: remove obsolete pre-Kconfig CONFIG_VIDEO_ variables


 arch/x86/boot/video-vesa.c |    7 +------
 arch/x86/boot/video-vga.c  |   10 ----------
 arch/x86/boot/video.c      |    5 -----
 arch/x86/boot/video.h      |   20 ++------------------
 arch/x86/kernel/e820.c     |    2 +-
 5 files changed, 4 insertions(+), 40 deletions(-)

diff --git a/arch/x86/boot/video-vesa.c b/arch/x86/boot/video-vesa.c
index c700147..d7ef26b 100644
--- a/arch/x86/boot/video-vesa.c
+++ b/arch/x86/boot/video-vesa.c
@@ -31,7 +31,6 @@ static inline void vesa_store_mode_params_graphics(void) {}
 
 static int vesa_probe(void)
 {
-#if defined(CONFIG_VIDEO_VESA) || defined(CONFIG_FIRMWARE_EDID)
 	struct biosregs ireg, oreg;
 	u16 mode;
 	addr_t mode_ptr;
@@ -49,8 +48,7 @@ static int vesa_probe(void)
 	    vginfo.signature != VESA_MAGIC ||
 	    vginfo.version < 0x0102)
 		return 0;	/* Not present */
-#endif /* CONFIG_VIDEO_VESA || CONFIG_FIRMWARE_EDID */
-#ifdef CONFIG_VIDEO_VESA
+
 	set_fs(vginfo.video_mode_ptr.seg);
 	mode_ptr = vginfo.video_mode_ptr.off;
 
@@ -102,9 +100,6 @@ static int vesa_probe(void)
 	}
 
 	return nmodes;
-#else
-	return 0;
-#endif /* CONFIG_VIDEO_VESA */
 }
 
 static int vesa_set_mode(struct mode_info *mode)
diff --git a/arch/x86/boot/video-vga.c b/arch/x86/boot/video-vga.c
index 8f8d827..819caa1 100644
--- a/arch/x86/boot/video-vga.c
+++ b/arch/x86/boot/video-vga.c
@@ -47,14 +47,6 @@ static u8 vga_set_basic_mode(void)
 
 	initregs(&ireg);
 
-#ifdef CONFIG_VIDEO_400_HACK
-	if (adapter >= ADAPTER_VGA) {
-		ireg.ax = 0x1202;
-		ireg.bx = 0x0030;
-		intcall(0x10, &ireg, NULL);
-	}
-#endif
-
 	ax = 0x0f00;
 	intcall(0x10, &ireg, &oreg);
 	mode = oreg.al;
@@ -62,11 +54,9 @@ static u8 vga_set_basic_mode(void)
 	set_fs(0);
 	rows = rdfs8(0x484);	/* rows minus one */
 
-#ifndef CONFIG_VIDEO_400_HACK
 	if ((oreg.ax == 0x5003 || oreg.ax == 0x5007) &&
 	    (rows == 0 || rows == 24))
 		return mode;
-#endif
 
 	if (mode != 3 && mode != 7)
 		mode = 3;
diff --git a/arch/x86/boot/video.c b/arch/x86/boot/video.c
index bad728b..d42da38 100644
--- a/arch/x86/boot/video.c
+++ b/arch/x86/boot/video.c
@@ -221,7 +221,6 @@ static unsigned int mode_menu(void)
 	}
 }
 
-#ifdef CONFIG_VIDEO_RETAIN
 /* Save screen content to the heap */
 static struct saved_screen {
 	int x, y;
@@ -299,10 +298,6 @@ static void restore_screen(void)
 	ireg.dl = saved.curx;
 	intcall(0x10, &ireg, NULL);
 }
-#else
-#define save_screen()		((void)0)
-#define restore_screen()	((void)0)
-#endif
 
 void set_video(void)
 {
diff --git a/arch/x86/boot/video.h b/arch/x86/boot/video.h
index 5bb174a..ff339c5 100644
--- a/arch/x86/boot/video.h
+++ b/arch/x86/boot/video.h
@@ -17,19 +17,8 @@
 
 #include <linux/types.h>
 
-/* Enable autodetection of SVGA adapters and modes. */
-#undef CONFIG_VIDEO_SVGA
-
-/* Enable autodetection of VESA modes */
-#define CONFIG_VIDEO_VESA
-
-/* Retain screen contents when switching modes */
-#define CONFIG_VIDEO_RETAIN
-
-/* Force 400 scan lines for standard modes (hack to fix bad BIOS behaviour */
-#undef CONFIG_VIDEO_400_HACK
-
-/* This code uses an extended set of video mode numbers. These include:
+/*
+ * This code uses an extended set of video mode numbers. These include:
  * Aliases for standard modes
  *      NORMAL_VGA (-1)
  *      EXTENDED_VGA (-2)
@@ -67,13 +56,8 @@
 /* The "recalculate timings" flag */
 #define VIDEO_RECALC 0x8000
 
-/* Define DO_STORE according to CONFIG_VIDEO_RETAIN */
-#ifdef CONFIG_VIDEO_RETAIN
 void store_screen(void);
 #define DO_STORE() store_screen()
-#else
-#define DO_STORE() ((void)0)
-#endif /* CONFIG_VIDEO_RETAIN */
 
 /*
  * Mode table structures
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 7271fa3..2e5e0fa 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -115,7 +115,7 @@ static void __init __e820_add_region(struct e820map *e820x, u64 start, u64 size,
 {
 	int x = e820x->nr_map;
 
-	if (x == ARRAY_SIZE(e820x->map)) {
+	if (x >= ARRAY_SIZE(e820x->map)) {
 		printk(KERN_ERR "Ooops! Too many entries in the memory map!\n");
 		return;
 	}
