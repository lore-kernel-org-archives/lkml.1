Return-Path: <linux-kernel-owner+w=401wt.eu-S1759715AbXJZUCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715AbXJZUCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbXJZUCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:02:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48972 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbXJZUCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:02:36 -0400
Date: Fri, 26 Oct 2007 13:02:07 -0700
Message-Id: <200710262002.l9QK2739032059@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: tglx@linutronix.de, mingo@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, jparmele@wildbear.com,
       JRottmann@lippert-at.de, stable@kernel.org
Subject: [x86 setup] Unbreak booting with Loadlin and old LILO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git for-linus

These patches unbreaks booting with some old versions of LILO and
Loadlin.

These patches probably should be considered for -stable as well (with
s/x86/i386/ in the pathnames.)

H. Peter Anvin (2):
      x86 setup: handle boot loaders which set up the stack incorrectly
      x86 setup: sizeof() is unsigned, unbreak comparisons

 arch/x86/boot/boot.h       |    8 +++---
 arch/x86/boot/header.S     |   62 +++++++++++++++++++++++++++++++------------
 arch/x86/boot/video-bios.c |    2 +-
 arch/x86/boot/video-vesa.c |    2 +-
 arch/x86/boot/video.c      |    2 +-
 5 files changed, 51 insertions(+), 25 deletions(-)

[Full diffs and log messages follow]

commit e6e1ace9904b72478f0c5a5aa7bd174cb6f62561
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Thu Oct 25 16:09:38 2007 -0700

    x86 setup: sizeof() is unsigned, unbreak comparisons
    
    We use signed values for limit checking since the values can go
    negative under certain circumstances.  However, sizeof() is unsigned
    and forces the comparison to be unsigned, so move the comparison into
    the heap_free() macros so we can ensure it is a signed comparison.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 887874f..d2b5adf 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -216,9 +216,9 @@ static inline char *__get_heap(size_t s, size_t a, size_t n)
 #define GET_HEAP(type, n) \
 	((type *)__get_heap(sizeof(type),__alignof__(type),(n)))
 
-static inline int heap_free(void)
+static inline bool heap_free(size_t n)
 {
-	return heap_end-HEAP;
+	return (int)(heap_end-HEAP) >= (int)n;
 }
 
 /* copy.S */
diff --git a/arch/x86/boot/video-bios.c b/arch/x86/boot/video-bios.c
index 68e65d9..ed0672a 100644
--- a/arch/x86/boot/video-bios.c
+++ b/arch/x86/boot/video-bios.c
@@ -79,7 +79,7 @@ static int bios_probe(void)
 	video_bios.modes = GET_HEAP(struct mode_info, 0);
 
 	for (mode = 0x14; mode <= 0x7f; mode++) {
-		if (heap_free() < sizeof(struct mode_info))
+		if (!heap_free(sizeof(struct mode_info)))
 			break;
 
 		if (mode_defined(VIDEO_FIRST_BIOS+mode))
diff --git a/arch/x86/boot/video-vesa.c b/arch/x86/boot/video-vesa.c
index 1921907..4716b9a 100644
--- a/arch/x86/boot/video-vesa.c
+++ b/arch/x86/boot/video-vesa.c
@@ -57,7 +57,7 @@ static int vesa_probe(void)
 	while ((mode = rdfs16(mode_ptr)) != 0xffff) {
 		mode_ptr += 2;
 
-		if (heap_free() < sizeof(struct mode_info))
+		if (!heap_free(sizeof(struct mode_info)))
 			break;	/* Heap full, can't save mode info */
 
 		if (mode & ~0x1ff)
diff --git a/arch/x86/boot/video.c b/arch/x86/boot/video.c
index e4ba897..ad9712f 100644
--- a/arch/x86/boot/video.c
+++ b/arch/x86/boot/video.c
@@ -371,7 +371,7 @@ static void save_screen(void)
 	saved.curx = boot_params.screen_info.orig_x;
 	saved.cury = boot_params.screen_info.orig_y;
 
-	if (heap_free() < saved.x*saved.y*sizeof(u16)+512)
+	if (!heap_free(saved.x*saved.y*sizeof(u16)+512))
 		return;		/* Not enough heap to save the screen */
 
 	saved.data = GET_HEAP(u16, saved.x*saved.y);

commit 6b6815c6d5d1dc209701d1661a7a0e09a295db2f
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Thu Oct 25 16:11:33 2007 -0700

    x86 setup: handle boot loaders which set up the stack incorrectly
    
    Apparently some specific versions of LILO enter the kernel with a
    stack pointer that doesn't match the rest of the segments.  Make our
    best attempt at untangling the resulting mess.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 5f9a2e7..887874f 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -17,6 +17,8 @@
 #ifndef BOOT_BOOT_H
 #define BOOT_BOOT_H
 
+#define STACK_SIZE	512	/* Minimum number of bytes for stack */
+
 #ifndef __ASSEMBLY__
 
 #include <stdarg.h>
@@ -198,8 +200,6 @@ static inline int isdigit(int ch)
 }
 
 /* Heap -- available for dynamic lists. */
-#define STACK_SIZE	512	/* Minimum number of bytes for stack */
-
 extern char _end[];
 extern char *HEAP;
 extern char *heap_end;
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 8353c81..6ef5a06 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -173,7 +173,8 @@ ramdisk_size:	.long	0		# its size in bytes
 bootsect_kludge:
 		.long	0		# obsolete
 
-heap_end_ptr:	.word	_end+1024	# (Header version 0x0201 or later)
+heap_end_ptr:	.word	_end+STACK_SIZE-512
+					# (Header version 0x0201 or later)
 					# space from here (exclusive) down to
 					# end of setup code can be used by setup
 					# for local heap purposes.
@@ -230,28 +231,53 @@ start_of_setup:
 	int	$0x13
 #endif
 
-# We will have entered with %cs = %ds+0x20, normalize %cs so
-# it is on par with the other segments.
-	pushw	%ds
-	pushw	$setup2
-	lretw
-
-setup2:
 # Force %es = %ds
 	movw	%ds, %ax
 	movw	%ax, %es
 	cld
 
-# Stack paranoia: align the stack and make sure it is good
-# for both 16- and 32-bit references.  In particular, if we
-# were meant to have been using the full 16-bit segment, the
-# caller might have set %sp to zero, which breaks %esp-based
-# references.
-	andw	$~3, %sp	# dword align (might as well...)
-	jnz	1f
-	movw	$0xfffc, %sp	# Make sure we're not zero
-1:	movzwl	%sp, %esp	# Clear upper half of %esp
-	sti
+# Apparently some ancient versions of LILO invoked the kernel
+# with %ss != %ds, which happened to work by accident for the
+# old code.  If the CAN_USE_HEAP flag is set in loadflags, or
+# %ss != %ds, then adjust the stack pointer.
+
+	# Smallest possible stack we can tolerate
+	movw	$(_end+STACK_SIZE), %cx
+
+	movw	heap_end_ptr, %dx
+	addw	$512, %dx
+	jnc	1f
+	xorw	%dx, %dx	# Wraparound - whole segment available
+1:	testb	$CAN_USE_HEAP, loadflags
+	jnz	2f
+
+	# No CAN_USE_HEAP
+	movw	%ss, %dx
+	cmpw	%ax, %dx	# %ds == %ss?
+	movw	%sp, %dx
+	# If so, assume %sp is reasonably set, otherwise use
+	# the smallest possible stack.
+	jne	4f		# -> Smallest possible stack...
+
+	# Make sure the stack is at least minimum size.  Take a value
+	# of zero to mean "full segment."
+2:
+	andw	$~3, %dx	# dword align (might as well...)
+	jnz	3f
+	movw	$0xfffc, %dx	# Make sure we're not zero
+3:	cmpw	%cx, %dx
+	jnb	5f
+4:	movw	%cx, %dx	# Minimum value we can possibly use
+5:	movw	%ax, %ss
+	movzwl	%dx, %esp	# Clear upper half of %esp
+	sti			# Now we should have a working stack
+
+# We will have entered with %cs = %ds+0x20, normalize %cs so
+# it is on par with the other segments.
+	pushw	%ds
+	pushw	$6f
+	lretw
+6:
 
 # Check signature at end of setup
 	cmpl	$0x5a5aaa55, setup_sig
