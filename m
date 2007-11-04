Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbXKDSdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbXKDSdU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 13:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbXKDSdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 13:33:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54246 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbXKDSdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 13:33:12 -0500
Message-ID: <472E0F8E.1010609@zytor.com>
Date: Sun, 04 Nov 2007 10:29:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH] fix i486 boot failure due to stale %ds
References: <200711041644.lA4Gi4Ms013028@harpo.it.uu.se>
In-Reply-To: <200711041644.lA4Gi4Ms013028@harpo.it.uu.se>
Content-Type: multipart/mixed;
 boundary="------------030507010202000607010608"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030507010202000607010608
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Mikael Pettersson wrote:
> 
> The machine in question is a ca 1993 vintage Siemens 486 with
> a Quadtel S3 / Phoenix BIOS from 1994, booting via grub-0.95-13
> from Fedora Core 4.
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
> ---
>  arch/x86/boot/compressed/head_32.S |    5 +++++
>  1 files changed, 5 insertions(+)
> 
> --- linux-2.6.24-rc1-git13/arch/x86/boot/compressed/head_32.S.~1~	2007-11-04 16:34:33.000000000 +0100
> +++ linux-2.6.24-rc1-git13/arch/x86/boot/compressed/head_32.S	2007-11-04 16:44:15.000000000 +0100
> @@ -33,6 +33,11 @@
>  	.globl startup_32
>  
>  startup_32:
> +	/* workaround for BIOSen or boot loaders that don't reload %ds
> +	   after changing the GDT (insane but unfortunately true) */
> +	movl %ds,%eax
> +	movl %eax,%ds
> +
>  	cld
>  	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
>  	 * us to not reload segments */

Double bogus flag here.

It's not an issue of the BIOS or the boot loader (in your case, Grub) 
unless you have a boot loader that does 32-bit entry (e.g. kexec or ELILO.)

Second, the "workaround" you have here effectively disables the meaning 
of the KEEP_SEGMENTS flag, so it's unacceptable.

If one couldn't rely on %ds, then we could load the loadflags with a 
%cs: override, but there is something much more bizarre going on here. 
Since you're doing a normal 16-bit entry (unless your Grub is 
configured/patched to do something extremely weird, not that that would 
be anything out of the ordinary for Grub) the code that should have been 
executed immediately before this point is this code from 
arch/x86/boot/pm_jump.S:

protected_mode_jump:
         xorl    %ebx, %ebx              # Flag to indicate this is a boot
         movl    %edx, %esi              # Pointer to boot_params table
         movl    %eax, 2f                # Patch ljmpl instruction
         jmp     1f                      # Short jump to flush 
instruction q.

1:
         movw    $__BOOT_DS, %cx

         movl    %cr0, %edx
         orb     $1, %dl                 # Protected mode (PE) bit
         movl    %edx, %cr0

         movw    %cx, %ds
         movw    %cx, %es
         movw    %cx, %fs
         movw    %cx, %gs
         movw    %cx, %ss

         # Jump to the 32-bit entrypoint
         .byte   0x66, 0xea              # ljmpl opcode
2:      .long   0                       # offset
         .word   __BOOT_CS               # segment

         .size   protected_mode_jump, .-protected_mode_jump


As you can see, all the segments should have been properly set up.  I'm 
somewhat wondering if you have found one lone CPU revision in the entire 
x86 menagerie which doesn't properly serialize on mov to %cr0, which 
would casue the mov to %ds immediately after to be misexecuted.  If 
that's the case, I believe I owe Eric Biederman a drink of choice.

Could you send me your /proc/cpuinfo?

Also, I would be very interested if you could try out this patch:


--------------030507010202000607010608
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/arch/x86/boot/pmjump.S b/arch/x86/boot/pmjump.S
index 2e55923..97cf407 100644
--- a/arch/x86/boot/pmjump.S
+++ b/arch/x86/boot/pmjump.S
@@ -30,7 +30,6 @@
 protected_mode_jump:
 	xorl	%ebx, %ebx		# Flag to indicate this is a boot
 	movl	%edx, %esi		# Pointer to boot_params table
-	movl	%eax, 2f		# Patch ljmpl instruction
 	jmp	1f			# Short jump to flush instruction q.
 
 1:
@@ -39,16 +38,17 @@ protected_mode_jump:
 	movl	%cr0, %edx
 	orb	$1, %dl			# Protected mode (PE) bit
 	movl	%edx, %cr0
+	ljmpw	__BOOT_CS, 2f
 
-	movw	%cx, %ds
-	movw	%cx, %es
-	movw	%cx, %fs
-	movw	%cx, %gs
-	movw	%cx, %ss
+	.code32
+2:
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
+	jmpl	%eax
+	
 	.size	protected_mode_jump, .-protected_mode_jump

--------------030507010202000607010608--
