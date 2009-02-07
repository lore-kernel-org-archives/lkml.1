Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbZBGXdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbZBGXdS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 18:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbZBGXdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 18:33:01 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36961 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbZBGXdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 18:33:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH v2 1/1] x86_64: acpi/wakeup_64 cleanup
Date: Sun, 8 Feb 2009 00:32:24 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: lenb@kernel.org, gorcunov@gmail.com, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@suse.cz>
References: <1234028641-5072-1-git-send-email-jirislaby@gmail.com> <1234043558-15784-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1234043558-15784-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902080032.24789.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 February 2009, Jiri Slaby wrote:
> - remove %ds re-set, it's already set in wakeup_long64
> - remove double labels and alignment (ENTRY already adds both)
> - use meaningful resume point labelname
> - skip alignment while jumping from wakeup_long64 to the resume point
> - remove .size, .type and unused labels
> [v2]
> - added ENDPROCs
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Pavel Machek <pavel@suse.cz>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  arch/x86/kernel/acpi/wakeup_64.S |   26 +++++++-------------------
>  1 files changed, 7 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/kernel/acpi/wakeup_64.S b/arch/x86/kernel/acpi/wakeup_64.S
> index bcc2934..b5dee6a 100644
> --- a/arch/x86/kernel/acpi/wakeup_64.S
> +++ b/arch/x86/kernel/acpi/wakeup_64.S
> @@ -13,7 +13,6 @@
>  	 * Hooray, we are in Long 64-bit mode (but still running in low memory)
>  	 */
>  ENTRY(wakeup_long64)
> -wakeup_long64:
>  	movq	saved_magic, %rax
>  	movq	$0x123456789abcdef0, %rdx
>  	cmpq	%rdx, %rax
> @@ -34,16 +33,12 @@ wakeup_long64:
>  
>  	movq	saved_rip, %rax
>  	jmp	*%rax
> +ENDPROC(wakeup_long64)
>  
>  bogus_64_magic:
>  	jmp	bogus_64_magic
>  
> -	.align 2
> -	.p2align 4,,15
> -.globl do_suspend_lowlevel
> -	.type	do_suspend_lowlevel,@function
> -do_suspend_lowlevel:
> -.LFB5:
> +ENTRY(do_suspend_lowlevel)
>  	subq	$8, %rsp
>  	xorl	%eax, %eax
>  	call	save_processor_state
> @@ -67,7 +62,7 @@ do_suspend_lowlevel:
>  	pushfq
>  	popq	pt_regs_flags(%rax)
>  
> -	movq	$.L97, saved_rip(%rip)
> +	movq	$resume_point, saved_rip(%rip)
>  
>  	movq	%rsp, saved_rsp
>  	movq	%rbp, saved_rbp
> @@ -79,13 +74,9 @@ do_suspend_lowlevel:
>  	movl	$3, %edi
>  	xorl	%eax, %eax
>  	jmp	acpi_enter_sleep_state
> -.L97:
> -	.p2align 4,,7
> -.L99:
> -	.align 4
> -	movl	$24, %eax
> -	movw	%ax, %ds
>  
> +	.align 4
> +resume_point:
>  	/* We don't restore %rax, it must be 0 anyway */
>  	movq	$saved_context, %rax
>  	movq	saved_context_cr4(%rax), %rbx
> @@ -117,12 +108,9 @@ do_suspend_lowlevel:
>  	xorl	%eax, %eax
>  	addq	$8, %rsp
>  	jmp	restore_processor_state
> -.LFE5:
> -.Lfe5:
> -	.size	do_suspend_lowlevel, .Lfe5-do_suspend_lowlevel
> -	
> +ENDPROC(do_suspend_lowlevel)
> +
>  .data
> -ALIGN
>  ENTRY(saved_rbp)	.quad	0
>  ENTRY(saved_rsi)	.quad	0
>  ENTRY(saved_rdi)	.quad	0
