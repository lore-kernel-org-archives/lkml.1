Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbYCYPlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbYCYPlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 11:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbYCYPlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 11:41:05 -0400
Received: from www.tglx.de ([62.245.132.106]:48367 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198AbYCYPlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:41:04 -0400
Date: Tue, 25 Mar 2008 16:40:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: andreas.herrmann3@amd.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CPA: Add statistics about state of direct mapping v3
In-Reply-To: <20080322095041.GA20734@basil.nowhere.org>
Message-ID: <alpine.LFD.1.00.0803251631050.3781@apollo.tec.linutronix.de>
References: <20080312353.598285931@firstfloor.org> <20080312025333.BAF5F1B41D1@basil.firstfloor.org> <alpine.LFD.1.00.0803211822220.3781@apollo.tec.linutronix.de> <20080321175538.GI2346@one.firstfloor.org> <20080322095041.GA20734@basil.nowhere.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2008, Andi Kleen wrote:

> [I didn't switch to debugfs because I strongly disagreed with that
> suggestion. But all the other points you made are addressed.]

Halfways :)
  
> +static void update_page_count(int level, unsigned long pages)
> +{
> +#ifdef CONFIG_PROC_FS
> +	unsigned long flags;
> +	/* Protect against CPA */
> +	spin_lock_irqsave(&pgd_lock, flags);
> +	direct_pages_count[PG_LEVEL_2M] += pages;

Shouldn't this update direct_pages_count[level] perhaps ?

> +	spin_unlock_irqrestore(&pgd_lock, flags);
> +#endif
> +}

Also I asked to move the update function to pageattr.c where we have
the variable, so we dont need to make it global and can change the
statistics implementation w/o changing the callers

> @@ -356,6 +371,7 @@ phys_pmd_update(pud_t *pud, unsigned lon
>  static unsigned long __meminit
>  phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end)
>  {
> +	unsigned long pages = 0;
>  	unsigned long true_end = end;
>  	int i = pud_index(addr);
>  
> @@ -380,6 +396,7 @@ phys_pud_init(pud_t *pud_page, unsigned 
>  		}
>  
>  		if (direct_gbpages) {
> +			direct_pages_count[PG_LEVEL_1G]++;

  direct update

>  			set_pte((pte_t *)pud,
>  				pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
>  			true_end = (addr & PUD_MASK) + PUD_SIZE;
> @@ -397,6 +414,8 @@ phys_pud_init(pud_t *pud_page, unsigned 
>  	}
>  	__flush_tlb_all();
>  
> +	update_page_count(PG_LEVEL_1G, pages);
> +

  update via function call with pages = 0 ?

Thanks,

	tglx
