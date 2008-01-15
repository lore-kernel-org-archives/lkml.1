Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbYAOI4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbYAOI4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 03:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYAOI4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 03:56:17 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:47674 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbYAOI4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 03:56:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mbG4eYPSs3aAr8DRMI7/1iNdMcHrHZSBLMw92ozyB1FX9OPEfvdkJ2Fs+tRpNQ5vZ6C4KRwKBD6WANAk/tpW92egdfiZ4uom4wRugFwNKBuWL7z4G+WcXgaiNgV1HttXaXUboS4mFHiQrkNOh2HPIqX5McUh14RohLi5ljqUOaM=
Subject: Re: [PATCH] [7/31] Extract page table dumping code from i386 fault
	handler into dump_pagetable()
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
In-Reply-To: <20080114221639.31FC714F83@wotan.suse.de>
References: <200801141116.534682000@suse.de>
	 <20080114221639.31FC714F83@wotan.suse.de>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 00:56:17 -0800
Message-Id: <1200387377.16794.9.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-01-14 at 23:16 +0100, Andi Kleen wrote:
> Similar to x86-64. This is useful in other situations where we want
> the page table dumped too.
> 
> Besides anything that makes i386 do_page_fault shorter is good.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86/mm/fault_32.c |   72 ++++++++++++++++++++++++++-----------------------
>  1 file changed, 39 insertions(+), 33 deletions(-)
> 
> Index: linux/arch/x86/mm/fault_32.c
> ===================================================================
> --- linux.orig/arch/x86/mm/fault_32.c
> +++ linux/arch/x86/mm/fault_32.c
> @@ -28,6 +28,44 @@
>  #include <asm/desc.h>
>  #include <asm/segment.h>
>  
> +void dump_pagetable(unsigned long address)

static?

> +{
> +	typeof(pte_val(__pte(0))) page;

Is there any type that could be picked that would be nicer than
sprinkling ((__typeof__(page) *), typeof(pte_val(__pte(0))) etc
through here, I know it's just moving the code out to another
function, just wondering if you had any better ideas that someone
could follow-up on.

Maybe another helper printk_page()? could help here.

> +
> +	page = read_cr3();
> +	page = ((__typeof__(page) *) __va(page))[address >> PGDIR_SHIFT];
> +#ifdef CONFIG_X86_PAE
> +	printk("*pdpt = %016Lx ", page);
> +	if ((page >> PAGE_SHIFT) < max_low_pfn
> +	    && page & _PAGE_PRESENT) {
> +		page &= PAGE_MASK;
> +		page = ((__typeof__(page) *) __va(page))[(address >> PMD_SHIFT)
> +							 & (PTRS_PER_PMD - 1)];
> +		printk(KERN_CONT "*pde = %016Lx ", page);
> +		page &= ~_PAGE_NX;
> +	}
> +#else
> +	printk("*pde = %08lx ", page);
> +#endif
> +
> +	/*
> +	 * We must not directly access the pte in the highpte
> +	 * case if the page table is located in highmem.
> +	 * And let's rather not kmap-atomic the pte, just in case
> +	 * it's allocated already.
> +	 */
> +	if ((page >> PAGE_SHIFT) < max_low_pfn
> +	    && (page & _PAGE_PRESENT)
> +	    && !(page & _PAGE_PSE)) {
> +		page &= PAGE_MASK;
> +		page = ((__typeof__(page) *) __va(page))[(address >> PAGE_SHIFT)
> +							 & (PTRS_PER_PTE - 1)];
> +		printk("*pte = %0*Lx ", sizeof(page)*2, (u64)page);
> +	}
> +
> +	printk("\n");
> +}
> +

Cheers,

Harvey

