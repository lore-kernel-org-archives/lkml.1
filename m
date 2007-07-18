Return-Path: <linux-kernel-owner+w=401wt.eu-S935266AbXGRS6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935266AbXGRS6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759078AbXGRS6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:58:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55894 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758425AbXGRS6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:58:21 -0400
Date: Wed, 18 Jul 2007 11:58:10 -0700
Message-Id: <200707181858.l6IIwA27032630@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Bug- and documentation fixes for the x86 setup code
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Etienne Lorrain <etienne_lorrain@yahoo.fr>,
       Chuck Ebbert <cebbert@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git for-linus

H. Peter Anvin (5):
      [x86 setup] MAINTAINERS: document x86 setup code git tree
      [x86 setup] build/tools.c: fix comment
      [x86 setup] Fix assembly constraints
      [x86 setup] VGA: Clear the Protect bit before setting the vertical height
      [x86 setup] Save/restore DS around invocations of INT 10h

Sam Ravnborg (1):
      x86: do not recompile boot for each build

 MAINTAINERS                  |    1 +
 arch/i386/boot/Makefile      |    2 +-
 arch/i386/boot/boot.h        |    2 +-
 arch/i386/boot/cpucheck.c    |    4 ++--
 arch/i386/boot/mca.c         |    2 +-
 arch/i386/boot/pm.c          |    2 +-
 arch/i386/boot/tools/build.c |    2 +-
 arch/i386/boot/tty.c         |    2 +-
 arch/i386/boot/video.c       |    9 +++++++--
 arch/i386/boot/video.h       |    9 ++++++++-
 arch/i386/boot/voyager.c     |    2 +-
 11 files changed, 25 insertions(+), 12 deletions(-)

[Full commit log and diff follows]

commit 3fbc54165d7217abf62b871c0dd074e76ce0eb31
Author: Sam Ravnborg <sam@ravnborg.org>
Date:   Tue Jul 17 22:27:22 2007 +0200

    [PATCH] x86: do not recompile boot for each build
    
    Keep the arch/i386/boot directory from being rebuilt every time.
    
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

commit 8c027ae2dcfa7b9130941a2a743c735c1fee04ee
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Mon Jul 16 11:58:24 2007 -0700

    [x86 setup] Save/restore DS around invocations of INT 10h
    
    There exists at least one card, Trident TVGA8900CL (BIOS dated 1992/9/8)
    which clobbers DS when "scrolling in an SVGA text mode of more than
    800x600 pixels."  Although we are extremely unlikely to run into that
    situation, it is cheap insurance to save and restore DS, and it only adds
    a grand total of 50 bytes to the total output.
    
    Pointed out by Etienne Lorrain.
    
    Cc: Etienne Lorrain <etienne_lorrain@yahoo.fr>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

commit 7ad37df02c529525c4ad19035359af89d2d2a5bd
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Tue Jul 17 16:16:10 2007 -0700

    [x86 setup] VGA: Clear the Protect bit before setting the vertical height
    
    If the user has asked for the vertical height registers to be recomputed
    by setting bit 15 in the video mode number, we do so without clearing the
    Protect bit in the Vertical Retrace Register before setting the Overflow
    register.  As a result, if the VGA BIOS had set the Protect bit, the
    write to the Overflow register will be dropped, and bits [9:8] of the
    vertical height will be left unchanged.
    
    This is a bug imported from the assembly version of this code.  It was
    pointed out by Etienne Lorrain.
    
    Cc: Etienne Lorrain <etienne_lorrain@yahoo.fr>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

commit 5593eaa854d0b23c3b270933a93b9b82946df729
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Sat Jul 14 16:47:13 2007 -0700

    [x86 setup] Fix assembly constraints
    
    Fix incorrect assembly constraints.  In particular, fix memory
    constraints used inside push..pop, which can cause invalid operation
    since gcc may generate %esp-relative references.
    
    Additionally:
    
    outl() should have "dN" not "dn".
    
    query_mca() shouldn't listen 16/32-bit registers in an 8-bit only
    context.
    
    has_eflag(): the "mask" is only used well after both the stack pointer
    and the output registers have been touched; this requires the output
    registers to be earlyclobbers (=&) and the input to exclude memory (so
    "ri", not "g").
    
    Thanks to Etienne Lorrain and Chuck Ebbert for prompting this review.
    
    Cc: Etienne Lorrain <etienne_lorrain@yahoo.fr>
    Cc: Chuck Ebbert <cebbert@redhat.com>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

commit 9aa3909c0ea33da41755e15182fa4f88ae036d83
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Fri Jul 13 16:28:27 2007 -0700

    [x86 setup] build/tools.c: fix comment
    
    Correct a comment in arch/i386/boot/build/tools.c; we now build the
    kernel from only two components instead of three, since the boot
    sector has been integrated in the setup code.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

commit 72af61c6ae6ce6e6b3935a11073b193508cb3b39
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Fri Jul 13 16:26:55 2007 -0700

    [x86 setup] MAINTAINERS: document x86 setup code git tree
    
    Document the existence of a published git tree for the x86 setup code.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 1698dbb..e78f62f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1740,6 +1740,7 @@ S:	Maintained
 i386 SETUP CODE / CPU ERRATA WORKAROUNDS
 P:	H. Peter Anvin
 M:	hpa@zytor.com
+T:	git.kernel.org:/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git
 S:	Maintained
 
 IA64 (Itanium) PLATFORM
diff --git a/arch/i386/boot/Makefile b/arch/i386/boot/Makefile
index 08678a0..93386a4 100644
--- a/arch/i386/boot/Makefile
+++ b/arch/i386/boot/Makefile
@@ -39,7 +39,7 @@ setup-y		+= printf.o string.o tty.o video.o version.o voyager.o
 setup-y		+= video-vga.o
 setup-y		+= video-vesa.o
 setup-y		+= video-bios.o
-
+targets		+= $(setup-y)
 hostprogs-y	:= tools/build
 
 HOSTCFLAGS_build.o := $(LINUXINCLUDE)
diff --git a/arch/i386/boot/boot.h b/arch/i386/boot/boot.h
index 0329c4f..dec70c9 100644
--- a/arch/i386/boot/boot.h
+++ b/arch/i386/boot/boot.h
@@ -56,7 +56,7 @@ static inline u16 inw(u16 port)
 
 static inline void outl(u32 v, u16 port)
 {
-	asm volatile("outl %0,%1" : : "a" (v), "dn" (port));
+	asm volatile("outl %0,%1" : : "a" (v), "dN" (port));
 }
 static inline u32 inl(u32 port)
 {
diff --git a/arch/i386/boot/cpucheck.c b/arch/i386/boot/cpucheck.c
index 8b0f447..991e8ce 100644
--- a/arch/i386/boot/cpucheck.c
+++ b/arch/i386/boot/cpucheck.c
@@ -115,8 +115,8 @@ static int has_eflag(u32 mask)
 	    "pushfl ; "
 	    "popl %1 ; "
 	    "popfl"
-	    : "=r" (f0), "=r" (f1)
-	    : "g" (mask));
+	    : "=&r" (f0), "=&r" (f1)
+	    : "ri" (mask));
 
 	return !!((f0^f1) & mask);
 }
diff --git a/arch/i386/boot/mca.c b/arch/i386/boot/mca.c
index 9b68bd1..68222f2 100644
--- a/arch/i386/boot/mca.c
+++ b/arch/i386/boot/mca.c
@@ -26,7 +26,7 @@ int query_mca(void)
 	    "setc %0 ; "
 	    "movw %%es, %1 ; "
 	    "popw %%es"
-	    : "=acdSDm" (err), "=acdSDm" (es), "=b" (bx)
+	    : "=acd" (err), "=acdSD" (es), "=b" (bx)
 	    : "a" (0xc000));
 
 	if (err)
diff --git a/arch/i386/boot/pm.c b/arch/i386/boot/pm.c
index 3fa53e1..1df025c 100644
--- a/arch/i386/boot/pm.c
+++ b/arch/i386/boot/pm.c
@@ -65,7 +65,7 @@ static void move_kernel_around(void)
 			     "popw %%ds ; "
 			     "popw %%es"
 			     : "+c" (dwords)
-			     : "rm" (dst_seg), "rm" (src_seg)
+			     : "r" (dst_seg), "r" (src_seg)
 			     : "esi", "edi");
 
 		syssize -= paras;
diff --git a/arch/i386/boot/tools/build.c b/arch/i386/boot/tools/build.c
index 886f47d..b424874 100644
--- a/arch/i386/boot/tools/build.c
+++ b/arch/i386/boot/tools/build.c
@@ -5,7 +5,7 @@
  */
 
 /*
- * This file builds a disk-image from three different files:
+ * This file builds a disk-image from two different files:
  *
  * - setup: 8086 machine code, sets up system parm
  * - system: 80386 code for actual system
diff --git a/arch/i386/boot/tty.c b/arch/i386/boot/tty.c
index a8db787..9c668aa 100644
--- a/arch/i386/boot/tty.c
+++ b/arch/i386/boot/tty.c
@@ -31,7 +31,7 @@ void __attribute__((section(".inittext"))) putchar(int ch)
 
 	/* int $0x10 is known to have bugs involving touching registers
 	   it shouldn't.  Be extra conservative... */
-	asm volatile("pushal; int $0x10; popal"
+	asm volatile("pushal; pushw %%ds; int $0x10; popw %%ds; popal"
 		     : : "b" (0x0007), "c" (0x0001), "a" (0x0e00|ch));
 }
 
diff --git a/arch/i386/boot/video.c b/arch/i386/boot/video.c
index 3bb3573..958130e 100644
--- a/arch/i386/boot/video.c
+++ b/arch/i386/boot/video.c
@@ -195,7 +195,7 @@ static void vga_recalc_vertical(void)
 {
 	unsigned int font_size, rows;
 	u16 crtc;
-	u8 ov;
+	u8 pt, ov;
 
 	set_fs(0);
 	font_size = rdfs8(0x485); /* BIOS: font size (pixels) */
@@ -206,7 +206,12 @@ static void vga_recalc_vertical(void)
 
 	crtc = vga_crtc();
 
+	pt = in_idx(crtc, 0x11);
+	pt &= ~0x80;		/* Unlock CR0-7 */
+	out_idx(pt, crtc, 0x11);
+
 	out_idx((u8)rows, crtc, 0x12); /* Lower height register */
+
 	ov = in_idx(crtc, 0x07); /* Overflow register */
 	ov &= 0xbd;
 	ov |= (rows >> (8-1)) & 0x02;
@@ -411,7 +416,7 @@ static void restore_screen(void)
 			     "1: rep;stosl ; "
 			     "popw %%es"
 			     : "+D" (dst), "+c" (npad)
-			     : "bdSm" (video_segment),
+			     : "bdS" (video_segment),
 			       "a" (0x07200720));
 	}
 
diff --git a/arch/i386/boot/video.h b/arch/i386/boot/video.h
index 29eca17..b92447d 100644
--- a/arch/i386/boot/video.h
+++ b/arch/i386/boot/video.h
@@ -117,8 +117,15 @@ extern int graphic_mode;	/* Graphics mode with linear frame buffer */
  * int $0x10 is notorious for touching registers it shouldn't.
  * gcc doesn't like %ebp being clobbered, so define it as a push/pop
  * sequence here.
+ *
+ * A number of systems, including the original PC can clobber %bp in
+ * certain circumstances, like when scrolling.  There exists at least
+ * one Trident video card which could clobber DS under a set of
+ * circumstances that we are unlikely to encounter (scrolling when
+ * using an extended graphics mode of more than 800x600 pixels), but
+ * it's cheap insurance to deal with that here.
  */
-#define INT10 "pushl %%ebp; int $0x10; popl %%ebp"
+#define INT10 "pushl %%ebp; pushw %%ds; int $0x10; popw %%ds; popl %%ebp"
 
 /* Accessing VGA indexed registers */
 static inline u8 in_idx(u16 port, u8 index)
diff --git a/arch/i386/boot/voyager.c b/arch/i386/boot/voyager.c
index 9221614..61c8fe0 100644
--- a/arch/i386/boot/voyager.c
+++ b/arch/i386/boot/voyager.c
@@ -32,7 +32,7 @@ int query_voyager(void)
 	    "setc %0 ; "
 	    "movw %%es, %1 ; "
 	    "popw %%es"
-	    : "=qm" (err), "=rm" (es), "=D" (di)
+	    : "=q" (err), "=r" (es), "=D" (di)
 	    : "a" (0xffc0));
 
 	if (err)
