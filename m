Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbXKDTBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbXKDTBT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 14:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbXKDTBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 14:01:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53433 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbXKDTBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 14:01:04 -0500
Message-ID: <472E16D6.4080706@zytor.com>
Date: Sun, 04 Nov 2007 11:00:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH] fix i486 boot failure due to stale %ds
References: <200711041644.lA4Gi4Ms013028@harpo.it.uu.se> <472E0F8E.1010609@zytor.com>
In-Reply-To: <472E0F8E.1010609@zytor.com>
Content-Type: multipart/mixed;
 boundary="------------080808090703080506030200"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080808090703080506030200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Urk, -ENOTAWAKEYET.  Try *THIS* patch, please.

	-hpa


--------------080808090703080506030200
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/arch/x86/boot/pmjump.S b/arch/x86/boot/pmjump.S
index 2e55923..17e6dec 100644
--- a/arch/x86/boot/pmjump.S
+++ b/arch/x86/boot/pmjump.S
@@ -28,27 +28,37 @@
  * void protected_mode_jump(u32 entrypoint, u32 bootparams);
  */
 protected_mode_jump:
-	xorl	%ebx, %ebx		# Flag to indicate this is a boot
 	movl	%edx, %esi		# Pointer to boot_params table
-	movl	%eax, 2f		# Patch ljmpl instruction
+
+	xorl	%edx, %edx
+	movw	%cs, %dx
+	shll	$4, %edx		# Patch ljmpl instruction
+	addl	%edx, 2f
 	jmp	1f			# Short jump to flush instruction q.
 
 1:
 	movw	$__BOOT_DS, %cx
+	xorl	%ebx, %ebx		# Per protocol
+	xorl	%ebp, %ebp		# Per protocol
+	xorl	%edi, %edi		# Per protocol
 
 	movl	%cr0, %edx
 	orb	$1, %dl			# Protected mode (PE) bit
 	movl	%edx, %cr0
+	
+	.byte	0x66, 0xea		# ljmpl opcode
+2:	.long	3f			# Offset
+	.word	__BOOT_CS		# Segment
 
-	movw	%cx, %ds
-	movw	%cx, %es
-	movw	%cx, %fs
-	movw	%cx, %gs
-	movw	%cx, %ss
+	.code32
+3:
+	movl	%ecx, %ds
+	movl	%ecx, %es
+	movl	%ecx, %fs
+	movl	%ecx, %gs
+	movl	%ecx, %ss
 
 	# Jump to the 32-bit entrypoint
-	.byte	0x66, 0xea		# ljmpl opcode
-2:	.long	0			# offset
-	.word	__BOOT_CS		# segment
-
+	jmpl	*%eax
+	
 	.size	protected_mode_jump, .-protected_mode_jump

--------------080808090703080506030200--
