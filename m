Return-Path: <linux-kernel-owner+w=401wt.eu-S1761495AbXKERXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761495AbXKERXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759858AbXKERQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:16:08 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56485 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759856AbXKERQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:16:04 -0500
Date: Mon, 5 Nov 2007 09:15:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>,
       Eric Biederman <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486 (revised)
In-Reply-To: <200711050358.lA53wlho003349@tazenda.hos.anvin.org>
Message-ID: <alpine.LFD.0.999.0711050842360.15101@woody.linux-foundation.org>
References: <200711050358.lA53wlho003349@tazenda.hos.anvin.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 4 Nov 2007, H. Peter Anvin wrote:
> 
> H. Peter Anvin (2):
>       x86 setup: add a near jump to serialize %cr0 on 386/486
>       x86 setup: set %ebx == %ebp == %edi == 0 on protected mode entry

Ok, I'm obviously happier, but I have to admit that the original code was 
safer than the new code. It did both the short jump and the far jump 
before reloading any segments.

So I suspect the new code _works_ fine, but it's simply not as 
fundamentally safe as the old code was.

The old code did do some instructions in between the short jump and the 
far jump, but they were all the kind of instructions that didn't care 
about the PE bit: there was a _read_ of the segment descriptor value, but 
that's mode-independent (it's only the writes that matter), and the other 
instructions were bog-standard integer instructions.

So I would actually prefer some additional safety, with something like 
the appended..

This is TOTALLY UNTESTED! I checked with objdump that the result looks 
roughly ok, but I didn't really think through the segment base address in 
that long jump thing. Do we have the difference between flat mode and the 
16-bit bootup mode in some better way?

Hmm?

		Linus

--
 arch/x86/boot/pmjump.S |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/x86/boot/pmjump.S b/arch/x86/boot/pmjump.S
index fa6bed1..587dc04 100644
--- a/arch/x86/boot/pmjump.S
+++ b/arch/x86/boot/pmjump.S
@@ -29,7 +29,11 @@
  */
 protected_mode_jump:
 	movl	%edx, %esi		# Pointer to boot_params table
-	movl	%eax, 2f		# Patch ljmpl instruction
+
+	xorl    %ecx, %ecx		# add data segment offset to
+	movw	%ds, %cx		# the "in_32_bit_mode" thing.
+	shll	$4, %ecx
+	addl 	%ecx, 2f
 
 	movw	$__BOOT_DS, %cx
 	xorl	%ebx, %ebx		# Per the 32-bit boot protocol
@@ -42,15 +46,20 @@ protected_mode_jump:
 	jmp	1f			# Short jump to serialize on 386/486
 1:
 
-	movw	%cx, %ds
-	movw	%cx, %es
-	movw	%cx, %fs
-	movw	%cx, %gs
-	movw	%cx, %ss
-
 	# Jump to the 32-bit entrypoint
 	.byte	0x66, 0xea		# ljmpl opcode
-2:	.long	0			# offset
+2:	.long	in_32_bit_mode		# offset
 	.word	__BOOT_CS		# segment
 
 	.size	protected_mode_jump, .-protected_mode_jump
+
+	.code32
+	.align 4
+in_32_bit_mode:
+	mov	%cx, %ds
+	mov	%cx, %es
+	mov	%cx, %fs
+	mov	%cx, %gs
+	mov	%cx, %ss
+	jmp	*%eax	
+	.size   in_32_bit_mode, .-in_32_bit_mode
