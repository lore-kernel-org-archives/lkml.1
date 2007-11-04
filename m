Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbXKDXzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbXKDXzI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 18:55:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbXKDXy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 18:54:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60796 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbXKDXy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 18:54:56 -0500
Message-ID: <472E5B0F.7000805@zytor.com>
Date: Sun, 04 Nov 2007 15:51:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix i486 boot failure due to stale %ds
References: <200711042158.lA4Lwv9S014628@harpo.it.uu.se> <472E50C5.5020201@goop.org>
In-Reply-To: <472E50C5.5020201@goop.org>
Content-Type: multipart/mixed;
 boundary="------------030203000106090103050806"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030203000106090103050806
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Mikael, can you try this patch (rev 3) on your 486?

	-hpa

--------------030203000106090103050806
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/arch/x86/boot/pmjump.S b/arch/x86/boot/pmjump.S
index 2e55923..d93a0c2 100644
--- a/arch/x86/boot/pmjump.S
+++ b/arch/x86/boot/pmjump.S
@@ -28,17 +28,21 @@
  * void protected_mode_jump(u32 entrypoint, u32 bootparams);
  */
 protected_mode_jump:
-	xorl	%ebx, %ebx		# Flag to indicate this is a boot
 	movl	%edx, %esi		# Pointer to boot_params table
-	movl	%eax, 2f		# Patch ljmpl instruction
+	movl	%eax, 3f		# Patch ljmpl instruction
 	jmp	1f			# Short jump to flush instruction q.
-
 1:
+
 	movw	$__BOOT_DS, %cx
+	xorl	%ebx, %ebx		# Per protocol
+	xorl	%ebp, %ebp		# Per protocol
+	xorl	%edi, %edi		# Per protocol
 
 	movl	%cr0, %edx
 	orb	$1, %dl			# Protected mode (PE) bit
 	movl	%edx, %cr0
+	jmp	2f			# Short jump to serialize
+2:
 
 	movw	%cx, %ds
 	movw	%cx, %es
@@ -48,7 +52,7 @@ protected_mode_jump:
 
 	# Jump to the 32-bit entrypoint
 	.byte	0x66, 0xea		# ljmpl opcode
-2:	.long	0			# offset
+3:	.long	0			# offset
 	.word	__BOOT_CS		# segment
 
 	.size	protected_mode_jump, .-protected_mode_jump

--------------030203000106090103050806--
