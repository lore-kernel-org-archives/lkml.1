Return-Path: <linux-kernel-owner+w=401wt.eu-S933173AbYF3WqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173AbYF3WqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 18:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932503AbYF3WqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 18:46:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51013 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbYF3WqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 18:46:09 -0400
Message-ID: <48696167.6050000@zytor.com>
Date: Mon, 30 Jun 2008 15:42:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Sean Young <sean@mess.org>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org
Subject: Re: Regression: boot failure on AMD Elan TS-5500
References: <20080616121138.GA51097@atlantis.8hz.com> <200806162327.34912.rusty@rustcorp.com.au> <48566C88.6000702@goop.org> <20080616161944.GA53539@atlantis.8hz.com> <20080630214347.GA57988@atlantis.8hz.com> <4869558A.9020907@goop.org> <48695871.8000805@zytor.com> <48695F88.9080905@goop.org>
In-Reply-To: <48695F88.9080905@goop.org>
Content-Type: multipart/mixed;
 boundary="------------020705080601080501020404"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020705080601080501020404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Jeremy Fitzhardinge wrote:
> 
> Maybe it really does require the far jump immediately after setting PE 
> in cr0...
> 
> Hm, I don't remember this paragraph being in vol 3a, section 8.9.1 
> before.  Is it a recent addition?
> 
>    Random failures can occur if other instructions exist between steps
>    3 and 4 above.  Failures will be readily seen in some situations,
>    such as when instructions that reference memory are inserted between
>    steps 3 and 4 while in system management mode.
> 

I don't remember that, either.

Sean: could you try the following patch?

	-hpa

--------------020705080601080501020404
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/arch/x86/boot/pmjump.S b/arch/x86/boot/pmjump.S
index ab049d4..141b6e2 100644
--- a/arch/x86/boot/pmjump.S
+++ b/arch/x86/boot/pmjump.S
@@ -33,6 +33,8 @@ protected_mode_jump:
 	movw	%cs, %bx
 	shll	$4, %ebx
 	addl	%ebx, 2f
+	jmp	1f			# Short jump to serialize on 386/486
+1:
 
 	movw	$__BOOT_DS, %cx
 	movw	$__BOOT_TSS, %di
@@ -40,8 +42,6 @@ protected_mode_jump:
 	movl	%cr0, %edx
 	orb	$X86_CR0_PE, %dl	# Protected mode
 	movl	%edx, %cr0
-	jmp	1f			# Short jump to serialize on 386/486
-1:
 
 	# Transition to 32-bit mode
 	.byte	0x66, 0xea		# ljmpl opcode

--------------020705080601080501020404--
