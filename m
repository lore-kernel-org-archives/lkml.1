Return-Path: <linux-kernel-owner+w=401wt.eu-S1764229AbXKOGWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764229AbXKOGWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758941AbXKOGQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:16:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51122 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762766AbXKOGQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:16:48 -0500
Date: Wed, 14 Nov 2007 22:15:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 16/19] x86 setup: handle boot loaders which set up the
	stack incorrectly
Message-ID: <20071115061513.GQ7980@kroah.com>
References: <20071115054813.977066477@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-setup-handle-boot-loaders-which-set-up-the-stack-incorrectly.patch"
In-Reply-To: <20071115061415.GA7980@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: H. Peter Anvin <hpa@zytor.com>

patch 6b6815c6d5d1dc209701d1661a7a0e09a295db2f in mainline.

Apparently some specific versions of LILO enter the kernel with a
stack pointer that doesn't match the rest of the segments.  Make our
best attempt at untangling the resulting mess.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/boot/boot.h   |    4 +--
 arch/i386/boot/header.S |   62 ++++++++++++++++++++++++++++++++++--------------
 2 files changed, 46 insertions(+), 20 deletions(-)

--- a/arch/i386/boot/boot.h
+++ b/arch/i386/boot/boot.h
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
--- a/arch/i386/boot/header.S
+++ b/arch/i386/boot/header.S
@@ -173,7 +173,8 @@ ramdisk_size:	.long	0		# its size in byt
 bootsect_kludge:
 		.long	0		# obsolete
 
-heap_end_ptr:	.word	_end+1024	# (Header version 0x0201 or later)
+heap_end_ptr:	.word	_end+STACK_SIZE-512
+					# (Header version 0x0201 or later)
 					# space from here (exclusive) down to
 					# end of setup code can be used by setup
 					# for local heap purposes.
@@ -225,28 +226,53 @@ start_of_setup:
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

-- 
