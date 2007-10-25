Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbXJYVyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbXJYVyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 17:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbXJYVyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 17:54:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50809 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbXJYVyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 17:54:06 -0400
Message-ID: <47211070.4090502@zytor.com>
Date: Thu, 25 Oct 2007 14:53:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Joseph Parmelee <jparmele@wildbear.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Old version of lilo fails to boot 2.6.23
References: <Pine.LNX.4.64.0710151600090.15578@bruno> <20071025014746.96e5e776.akpm@linux-foundation.org>
In-Reply-To: <20071025014746.96e5e776.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------020607040809020801000602"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020607040809020801000602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

[Ancient LILO boot problem]

Joseph, could you try this patch on your ancient-LILO setup?

	-hpa

--------------020607040809020801000602
Content-Type: text/x-patch;
 name="newsetup-ancient-lilo.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="newsetup-ancient-lilo.patch"

diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 8353c81..295f9b9 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -242,11 +242,31 @@ setup2:
 	movw	%ax, %es
 	cld
 
+# Apparently some ancient versions of LILO invoked the kernel
+# with %ss != %ds, which happened to work by accident for the
+# old code.  If the CAN_USE_HEAP flag is set in loadflags, or
+# %ss != %ds, then adjust the stack pointer.
+	testb	$CAN_USE_HEAP, loadflags
+	jnz 2f
+
+	# No CAN_USE_HEAP
+	movw	%ss, %dx
+	cmpw	%ax, %dx	# %ds == %ss?
+	je	3f		# If so, assume %sp is valid
+
+	# If not, use the default value from heap_end_ptr
+	# as the %sp value -- it's the best we can do with an
+	# impossible situation.
+2:
+	movw	%ax, %ss
+	movw	heap_end_ptr, %sp
+	
 # Stack paranoia: align the stack and make sure it is good
 # for both 16- and 32-bit references.  In particular, if we
 # were meant to have been using the full 16-bit segment, the
 # caller might have set %sp to zero, which breaks %esp-based
 # references.
+3:	
 	andw	$~3, %sp	# dword align (might as well...)
 	jnz	1f
 	movw	$0xfffc, %sp	# Make sure we're not zero

--------------020607040809020801000602--
