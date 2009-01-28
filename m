Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbZA1WG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbZA1WG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbZA1WGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 17:06:03 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:57851 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753658AbZA1WGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 17:06:00 -0500
X-Greylist: delayed 782 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jan 2009 17:06:00 EST
Message-Id: <1233179577.19086.1297291037@webmail.messagingengine.com>
X-Sasl-Enc: JLSvWQRmQMM+9A4DO8Bvc3PnVzYsM971f7UDklSsfRHn 1233179577
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20090128202125.GA32555@localhost>
Subject: Re: [PATCH -tip] x86: trampoline_64.S - use predefined constants with  
 simplification
In-Reply-To: <20090128202125.GA32555@localhost>
Date: Wed, 28 Jan 2009 22:52:57 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 23:21:25 +0300, "Cyrill Gorcunov"
<gorcunov@gmail.com> said:
> Impact: cleanup
> 
> We may use macros from processor-flags.h instead
> of hardcoding bits. Actually it's not direct mapping
> of old instructions with new ones -- BTS does change
> CF flag while MOV does not. But i didn't find any
> dependency on CF in this code.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>
> Please review

Looks good.

Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>

>  arch/x86/kernel/trampoline_64.S |   19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6.git/arch/x86/kernel/trampoline_64.S
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/trampoline_64.S
> +++ linux-2.6.git/arch/x86/kernel/trampoline_64.S
> @@ -29,6 +29,7 @@
>  #include <asm/page.h>
>  #include <asm/msr.h>
>  #include <asm/segment.h>
> +#include <asm/processor-flags.h>
>  
>  .section .rodata, "a", @progbits
>  
> @@ -37,7 +38,7 @@
>  ENTRY(trampoline_data)
>  r_base = .
>  	cli			# We should be safe anyway
> -	wbinvd	
> +	wbinvd
>  	mov	%cs, %ax	# Code and data in the same place
>  	mov	%ax, %ds
>  	mov	%ax, %es
> @@ -73,9 +74,8 @@ r_base = .
>  	lidtl	tidt - r_base	# load idt with 0, 0
>  	lgdtl	tgdt - r_base	# load gdt with whatever is appropriate
>  
> -	xor	%ax, %ax
> -	inc	%ax		# protected mode (PE) bit
> -	lmsw	%ax		# into protected mode
> +	mov	$X86_CR0_PE, %ax	# protected mode (PE) bit
> +	lmsw	%ax			# into protected mode
>  
>  	# flush prefetch and jump to startup_32
>  	ljmpl	*(startup_32_vector - r_base)
> @@ -86,9 +86,8 @@ startup_32:
>  	movl	$__KERNEL_DS, %eax	# Initialize the %ds segment register
>  	movl	%eax, %ds
>  
> -	xorl	%eax, %eax
> -	btsl	$5, %eax		# Enable PAE mode
> -	movl	%eax, %cr4
> +	movl	$X86_CR4_PAE, %eax
> +	movl	%eax, %cr4		# Enable PAE mode
>  
>  					# Setup trampoline 4 level pagetables
>  	leal	(trampoline_level4_pgt - r_base)(%esi), %eax
> @@ -99,9 +98,9 @@ startup_32:
>  	xorl	%edx, %edx
>  	wrmsr
>  
> -	xorl	%eax, %eax
> -	btsl	$31, %eax		# Enable paging and in turn activate Long Mode
> -	btsl	$0, %eax		# Enable protected mode
> +	# Enable paging and in turn activate Long Mode
> +	# Enable protected mode
> +	movl	$(X86_CR0_PG | X86_CR0_PE), %eax
>  	movl	%eax, %cr0
>  
>  	/*
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Faster than the air-speed velocity of an
                          unladen european swallow

