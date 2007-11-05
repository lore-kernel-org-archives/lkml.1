Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614AbXKEAPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbXKEAPq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 19:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbXKEAPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 19:15:39 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42824 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbXKEAPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 19:15:39 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486DX4
References: <200711042257.lA4Mvobr025200@tazenda.hos.anvin.org>
Date: Sun, 04 Nov 2007 17:14:41 -0700
In-Reply-To: <200711042257.lA4Mvobr025200@tazenda.hos.anvin.org> (H. Peter
	Anvin's message of "Sun, 4 Nov 2007 14:57:50 -0800")
Message-ID: <m1bqa9blam.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Hi Linus; please pull:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git
> for-linus
>
> H. Peter Anvin (1):
>       x86 setup: correct booting on 486DX4
>
>  arch/x86/boot/pmjump.S |   32 +++++++++++++++++++++-----------
>  1 files changed, 21 insertions(+), 11 deletions(-)
>
> [Full diff and log follows]

Looks reasonable to me.

> commit ac3b37b78c5f0f0be0b476a35370650f7bad482f
> Author: H. Peter Anvin <hpa@zytor.com>
> Date:   Sun Nov 4 14:33:41 2007 -0800
>
>     x86 setup: correct booting on 486DX4
>     
>     Apparently, the 486DX4 does not correctly serialize a mov to %cr0, so
>     we really do need the far jump immediately afterwards.  This means
>     losing the nice separation between 16- and 32-bit code, but c'est la
>     vie.
>     
>     Also pass %ebx = %edi = %ebp = 0 to support future extension of the
>     32-bit boot protocol.
>     
>     Signed-off-by: H. Peter Anvin <hpa@zytor.com>
>
> diff --git a/arch/x86/boot/pmjump.S b/arch/x86/boot/pmjump.S
> index 2e55923..17e6dec 100644
> --- a/arch/x86/boot/pmjump.S
> +++ b/arch/x86/boot/pmjump.S
> @@ -28,27 +28,37 @@
>   * void protected_mode_jump(u32 entrypoint, u32 bootparams);
>   */
>  protected_mode_jump:
> -	xorl	%ebx, %ebx		# Flag to indicate this is a boot
>  	movl	%edx, %esi		# Pointer to boot_params table
> -	movl	%eax, 2f		# Patch ljmpl instruction
> +
> +	xorl	%edx, %edx
> +	movw	%cs, %dx
> +	shll	$4, %edx		# Patch ljmpl instruction
> +	addl	%edx, 2f
>  	jmp	1f			# Short jump to flush instruction q.
>  
>  1:
>  	movw	$__BOOT_DS, %cx
> +	xorl	%ebx, %ebx		# Per protocol
> +	xorl	%ebp, %ebp		# Per protocol
> +	xorl	%edi, %edi		# Per protocol
>  
>  	movl	%cr0, %edx
>  	orb	$1, %dl			# Protected mode (PE) bit
>  	movl	%edx, %cr0
> +	
> +	.byte	0x66, 0xea		# ljmpl opcode
> +2:	.long	3f			# Offset
> +	.word	__BOOT_CS		# Segment
>  
> -	movw	%cx, %ds
> -	movw	%cx, %es
> -	movw	%cx, %fs
> -	movw	%cx, %gs
> -	movw	%cx, %ss
> +	.code32
> +3:
> +	movl	%ecx, %ds
> +	movl	%ecx, %es
> +	movl	%ecx, %fs
> +	movl	%ecx, %gs
> +	movl	%ecx, %ss
>  
>  	# Jump to the 32-bit entrypoint
> -	.byte	0x66, 0xea		# ljmpl opcode
> -2:	.long	0			# offset
> -	.word	__BOOT_CS		# segment
> -
> +	jmpl	*%eax
> +	
>  	.size	protected_mode_jump, .-protected_mode_jump
