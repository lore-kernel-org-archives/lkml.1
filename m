Return-Path: <linux-kernel-owner+w=401wt.eu-S935039AbXGQRyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935039AbXGQRyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764274AbXGQRyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:54:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:58544 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763257AbXGQRyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:54:38 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] x86: make SMP locks handling interact properly with CONFIG_DEBUG_RODATA (2nd try)
Date: Tue, 17 Jul 2007 19:54:34 +0200
User-Agent: KMail/1.9.6
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
References: <468B5B54.76E4.0078.0@novell.com>
In-Reply-To: <468B5B54.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707171954.34541.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 July 2007 08:33:24 Jan Beulich wrote:

Sorry for late feedback.


> +#ifdef CONFIG_DEBUG_RODATA
> +
> +#ifdef CONFIG_X86_32
> +#include <asm/highmem.h>
> +#define MODULES_VADDR VMALLOC_START
> +#endif
> +
> +static inline void make_writable(const void *instr, unsigned int len)
> +{
> +	unsigned long va = (unsigned long)instr;
> +
> +	if (va < MODULES_VADDR) {
> +		change_page_attr(virt_to_page(instr),
> +				 PFN_UP(va + len) - PFN_DOWN(va),
> +				 PAGE_KERNEL_EXEC);
> +		global_flush_tlb();
> +	}
> +}
> +
> +static inline void make_readonly(const void *instr, unsigned int len)
> +{
> +	unsigned long va = (unsigned long)instr;
> +
> +	if (va < MODULES_VADDR) {
> +		change_page_attr(virt_to_page(instr),
> +				 PFN_UP(va + len) - PFN_DOWN(va),
> +#ifdef CONFIG_X86_64
> +				 PAGE_KERNEL_RO);
> +#else
> +				 PAGE_KERNEL_RX);
> +#endif
> +		global_flush_tlb();
> +	}
> +}

Can you please move those into the respective pageattr.cs without ifdefs? 
Also the va < MODULES_VADDR test seems overly magic; while it may work right now
it seems fragile. It would be better to test the exact ranges in the respective
architectures

>  void alternatives_smp_module_del(struct module *mod)
>  {
>  	struct smp_alt_module *item;
> -	unsigned long flags;
>  
>  	if (smp_alt_once || noreplace_smp)
>  		return;
>  
> -	spin_lock_irqsave(&smp_alt, flags);
> +	spin_lock(&smp_alt);

Unrelated change?  Why? Should probably be separate patch.

> --- linux-2.6.22-rc7/arch/x86_64/kernel/vmlinux.lds.S	2007-07-03 10:57:39.000000000 +0200
> +++ 2.6.22-rc7-x86-alt-page-attr/arch/x86_64/kernel/vmlinux.lds.S	2007-07-02 14:40:15.000000000 +0200
> @@ -131,20 +131,11 @@ SECTIONS
>    /* might get freed after init */
>    . = ALIGN(4096);
>    __smp_alt_begin = .;
> -  __smp_alt_instructions = .;
> -  .smp_altinstructions : AT(ADDR(.smp_altinstructions) - LOAD_OFFSET) {
> -	*(.smp_altinstructions)
> -  }
> -  __smp_alt_instructions_end = .;
> -  . = ALIGN(8);
>    __smp_locks = .;
>    .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
>  	*(.smp_locks)
>    }
>    __smp_locks_end = .;
> -  .smp_altinstr_replacement : AT(ADDR(.smp_altinstr_replacement) - LOAD_OFFSET) {
> -	*(.smp_altinstr_replacement)
> -  }

While ok too it should be also separate please.

-Andi
