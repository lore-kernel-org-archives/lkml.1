Return-Path: <linux-kernel-owner+w=401wt.eu-S1759383AbXJYWcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383AbXJYWcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbXJYWbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:31:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45399 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbXJYWbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:31:52 -0400
Message-ID: <4721194F.1040202@zytor.com>
Date: Thu, 25 Oct 2007 15:31:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Joseph Parmelee <jparmele@wildbear.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Old version of lilo fails to boot 2.6.23
References: <Pine.LNX.4.64.0710151600090.15578@bruno> <20071025014746.96e5e776.akpm@linux-foundation.org> <47211070.4090502@zytor.com>
In-Reply-To: <47211070.4090502@zytor.com>
Content-Type: multipart/mixed;
 boundary="------------020006010601050900090507"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020006010601050900090507
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

H. Peter Anvin wrote:
> [Ancient LILO boot problem]
> 
> Joseph, could you try this patch on your ancient-LILO setup?
> 

Actually, please try this one instead.

	-hpa

--------------020006010601050900090507
Content-Type: text/x-patch;
 name="newsetup-ancient-lilo-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="newsetup-ancient-lilo-2.patch"

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
index 8353c81..256098d 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -173,7 +173,7 @@ ramdisk_size:	.long	0		# its size in bytes
 bootsect_kludge:
 		.long	0		# obsolete
 
-heap_end_ptr:	.word	_end+1024	# (Header version 0x0201 or later)
+heap_end_ptr:	.word	_end+STACK_SIZE	# (Header version 0x0201 or later)
 					# space from here (exclusive) down to
 					# end of setup code can be used by setup
 					# for local heap purposes.
@@ -242,16 +242,38 @@ setup2:
 	movw	%ax, %es
 	cld
 
-# Stack paranoia: align the stack and make sure it is good
-# for both 16- and 32-bit references.  In particular, if we
-# were meant to have been using the full 16-bit segment, the
-# caller might have set %sp to zero, which breaks %esp-based
-# references.
-	andw	$~3, %sp	# dword align (might as well...)
+# Apparently some ancient versions of LILO invoked the kernel
+# with %ss != %ds, which happened to work by accident for the
+# old code.  If the CAN_USE_HEAP flag is set in loadflags, or
+# %ss != %ds, then adjust the stack pointer.
+
+	# Smallest possible stack we can tolerate
+	movw	$(_end+STACK_SIZE), %cx
+
+	testb	$CAN_USE_HEAP, loadflags
+	jnz	2f
+
+	# No CAN_USE_HEAP
+	movw	%ss, %dx
+	cmpw	%ax, %dx	# %ds == %ss?
+	movw	%sp, %dx
+	je	3f		# If so, assume %sp is valid
+
+2:
+	movw	heap_end_ptr, %dx
+
+	# Make sure the stack is at least minimum size.  Take a value
+	# of zero to mean "full segment."
+3:
+	andw	$~3, %dx	# dword align (might as well...)
 	jnz	1f
-	movw	$0xfffc, %sp	# Make sure we're not zero
-1:	movzwl	%sp, %esp	# Clear upper half of %esp
-	sti
+	movw	$0xfffc, %dx	# Make sure we're not zero
+1:	cmpw	%cx, %dx
+	jnb	4f
+	movw	%cx, %dx	# Minimum value we can possibly use
+4:	movw	%ax, %ss
+	movzwl	%dx, %esp	# Clear upper half of %esp
+	sti			# Now we should have a working stack
 
 # Check signature at end of setup
 	cmpl	$0x5a5aaa55, setup_sig

--------------020006010601050900090507--
