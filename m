Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968652Ab0B0RCG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:02:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43783 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030414Ab0B0RCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 12:02:00 -0500
Date: Sat, 27 Feb 2010 17:59:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/setup changes for v2.6.34
Message-ID: <20100227165956.GA23974@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-setup-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-setup-for-linus

 Thanks,

	Ingo

------------------>
H. Peter Anvin (3):
      x86, setup: When restoring the screen, update boot_params.screen_info
      x86-64, setup: Inhibit decompressor output if video info is invalid
      x86, setup: Don't skip mode setting for the standard VGA modes


 arch/x86/boot/compressed/misc.c |    2 --
 arch/x86/boot/video-vga.c       |    9 +--------
 arch/x86/boot/video.c           |    7 +++++++
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 3b22fe8..3487e86 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -185,11 +185,9 @@ static void __putstr(int error, const char *s)
 		return;
 #endif
 
-#ifdef CONFIG_X86_32
 	if (real_mode->screen_info.orig_video_mode == 0 &&
 	    lines == 0 && cols == 0)
 		return;
-#endif
 
 	x = real_mode->screen_info.orig_x;
 	y = real_mode->screen_info.orig_y;
diff --git a/arch/x86/boot/video-vga.c b/arch/x86/boot/video-vga.c
index 819caa1..ed7aeff 100644
--- a/arch/x86/boot/video-vga.c
+++ b/arch/x86/boot/video-vga.c
@@ -42,22 +42,15 @@ static u8 vga_set_basic_mode(void)
 {
 	struct biosregs ireg, oreg;
 	u16 ax;
-	u8 rows;
 	u8 mode;
 
 	initregs(&ireg);
 
+	/* Query current mode */
 	ax = 0x0f00;
 	intcall(0x10, &ireg, &oreg);
 	mode = oreg.al;
 
-	set_fs(0);
-	rows = rdfs8(0x484);	/* rows minus one */
-
-	if ((oreg.ax == 0x5003 || oreg.ax == 0x5007) &&
-	    (rows == 0 || rows == 24))
-		return mode;
-
 	if (mode != 3 && mode != 7)
 		mode = 3;
 
diff --git a/arch/x86/boot/video.c b/arch/x86/boot/video.c
index f767164..43eda28 100644
--- a/arch/x86/boot/video.c
+++ b/arch/x86/boot/video.c
@@ -298,11 +298,18 @@ static void restore_screen(void)
 	}
 
 	/* Restore cursor position */
+	if (saved.curx >= xs)
+		saved.curx = xs-1;
+	if (saved.cury >= ys)
+		saved.cury = ys-1;
+
 	initregs(&ireg);
 	ireg.ah = 0x02;		/* Set cursor position */
 	ireg.dh = saved.cury;
 	ireg.dl = saved.curx;
 	intcall(0x10, &ireg, NULL);
+
+	store_cursor_position();
 }
 
 void set_video(void)
