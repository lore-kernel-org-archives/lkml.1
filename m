Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbZASCTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbZASCTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 21:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756753AbZASCTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 21:19:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:59206 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756977AbZASCTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 21:19:02 -0500
Message-ID: <4973E30D.3030102@kernel.org>
Date: Mon, 19 Jan 2009 11:18:53 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86-64: Remove the PDA
References: <73c1f2160901181651w3dff5e2co762b767168416c92@mail.gmail.com> <1232326345-3534-1-git-send-email-brgerst@gmail.com> <1232326345-3534-2-git-send-email-brgerst@gmail.com> <1232326345-3534-3-git-send-email-brgerst@gmail.com> <1232326345-3534-4-git-send-email-brgerst@gmail.com>
In-Reply-To: <1232326345-3534-4-git-send-email-brgerst@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 19 Jan 2009 02:18:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Brian.

Brian Gerst wrote:
...
> @@ -881,13 +881,9 @@ __setup("clearcpuid=", setup_disablecpuid);
>  #ifdef CONFIG_X86_64
>  struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
>  
> -DEFINE_PER_CPU_PAGE_ALIGNED(char[IRQ_STACK_SIZE], irq_stack);
> -#ifdef CONFIG_SMP
> -DEFINE_PER_CPU(char *, irq_stack_ptr);	/* will be set during per cpu init */
> -#else
> +DEFINE_PER_CPU_FIRST(union irq_stack_union, irq_stack_union) __aligned(PAGE_SIZE);
>  DEFINE_PER_CPU(char *, irq_stack_ptr) =
> -	per_cpu_var(irq_stack) + IRQ_STACK_SIZE - 64;
> -#endif
> +	per_cpu_var(irq_stack_union.irq_stack) + IRQ_STACK_SIZE - 64;
>  
>  DEFINE_PER_CPU(unsigned long, kernel_stack) =
>  	(unsigned long)&init_thread_union - KERNEL_STACK_OFFSET + THREAD_SIZE;
>
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index 98ea26a..8c83de6 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -216,6 +216,7 @@ ENTRY(secondary_startup_64)
>  	cmpl	$0, per_cpu__cpu_number(%rax)
>  	jne	1f
>  	addq	%rax, early_gdt_descr_base(%rip)
> +	addq	%rax, per_cpu__irq_stack_ptr(%rax)
>  1:
>  #endif
>  	/*

As discussed before, the above chunks do drop one #ifdef CONFIG_SMP
but it does add a obscure relocation and please note that it's
different from early_gdt_descr.  early_gdt_descr is needed to bring up
the cpu so there's no other way to do it but to relocate it in
assembly.  If you absolutely have to relocate irq_stack_ptr early,
please do it in C code in head64.c but then again irq_stack_ptr is not
even necessary till traps_init() which is way after per cpu area
setup.  So, the above two chunks are not necessary && even if they go
in, they don't have much to do with this patch.

In general, I think trying to early initialize per cpu pointer to per
cpu variable just isn't a good idea and should be avoided as much as
possible.  I think the #ifdef there is fine - it's short and apparent
and represntative of the two separate percpu implementations we have.
If you're annoyed by it, I think it would be better to either
consolidate such #ifdefs (there are a few other places) or define a
wrapper macro to conditionalize and document the different
initialization paths, but please don't add obscure assembly
relocation, especially not without comment explaining it.

Thanks.

-- 
tejun
