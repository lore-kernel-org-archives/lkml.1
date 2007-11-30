Return-Path: <linux-kernel-owner+w=401wt.eu-S1763743AbXK3ALo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763743AbXK3ALo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 19:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763676AbXK3ALM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 19:11:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46369 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759749AbXK3ALK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 19:11:10 -0500
Date: Thu, 29 Nov 2007 16:10:27 -0800
Message-Id: <200711300010.lAU0ARA8030312@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Rottmann <JRottmann@lippert-at.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] x86 setup: don't recalculate ss:esp unless really necessary
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

It appears that unconditionally resetting the stack, which fixes old
LILO, breaks LOADLIN after all.  This patch should work with either,
as well as work around the command-line truncation bug in old versions
of SYSLINUX.

Please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git for-linus

Jens Rottmann (1):
      x86 setup: don't recalculate ss:esp unless really necessary

 arch/x86/boot/header.S |   41 ++++++++++++++++-------------------------
 1 files changed, 16 insertions(+), 25 deletions(-)

commit 16252da654800461e0e1c32697cb59f4cda15aa9
Author: Jens Rottmann <JRottmann@lippert-at.de>
Date:   Tue Nov 27 12:35:13 2007 +0100

    x86 setup: don't recalculate ss:esp unless really necessary
    
    In order to work around old LILO versions providing an invalid ss
    register, the current setup code always sets up a new stack,
    immediately following .bss and the heap. But this breaks LOADLIN.
    
    This rewrite of the workaround checks for an invalid stack (ss!=ds)
    first, and leaves ss:sp alone otherwise (apart from aligning esp).
    
    [hpa note: LOADLIN has a number of arbitrary hard-coded limits that
    are being pushed up against.  Without some major revision of LOADLIN
    itself it will not be sustainable keeping it alive.  This gives it
    another brief lease on life, however.  This patch also helps the
    cmdline truncation problem with old versions of SYSLINUX.]
    
    Signed-off-by: Jens Rottmann <JRottmann at LiPPERT-AT. de>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 6ef5a06..4cc5b04 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -236,39 +236,30 @@ start_of_setup:
 	movw	%ax, %es
 	cld
 
-# Apparently some ancient versions of LILO invoked the kernel
-# with %ss != %ds, which happened to work by accident for the
-# old code.  If the CAN_USE_HEAP flag is set in loadflags, or
-# %ss != %ds, then adjust the stack pointer.
+# Apparently some ancient versions of LILO invoked the kernel with %ss != %ds,
+# which happened to work by accident for the old code.  Recalculate the stack
+# pointer if %ss is invalid.  Otherwise leave it alone, LOADLIN sets up the
+# stack behind its own code, so we can't blindly put it directly past the heap.
 
-	# Smallest possible stack we can tolerate
-	movw	$(_end+STACK_SIZE), %cx
-
-	movw	heap_end_ptr, %dx
-	addw	$512, %dx
-	jnc	1f
-	xorw	%dx, %dx	# Wraparound - whole segment available
-1:	testb	$CAN_USE_HEAP, loadflags
-	jnz	2f
-
-	# No CAN_USE_HEAP
 	movw	%ss, %dx
 	cmpw	%ax, %dx	# %ds == %ss?
 	movw	%sp, %dx
-	# If so, assume %sp is reasonably set, otherwise use
-	# the smallest possible stack.
-	jne	4f		# -> Smallest possible stack...
+	je	2f		# -> assume %sp is reasonably set
+
+	# Invalid %ss, make up a new stack
+	movw	$_end, %dx
+	testb	$CAN_USE_HEAP, loadflags
+	jz	1f
+	movw	heap_end_ptr, %dx
+1:	addw	$STACK_SIZE, %dx
+	jnc	2f
+	xorw	%dx, %dx	# Prevent wraparound
 
-	# Make sure the stack is at least minimum size.  Take a value
-	# of zero to mean "full segment."
-2:
+2:	# Now %dx should point to the end of our stack space
 	andw	$~3, %dx	# dword align (might as well...)
 	jnz	3f
 	movw	$0xfffc, %dx	# Make sure we're not zero
-3:	cmpw	%cx, %dx
-	jnb	5f
-4:	movw	%cx, %dx	# Minimum value we can possibly use
-5:	movw	%ax, %ss
+3:	movw	%ax, %ss
 	movzwl	%dx, %esp	# Clear upper half of %esp
 	sti			# Now we should have a working stack
 
