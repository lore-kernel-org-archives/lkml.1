Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbYBKNJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbYBKNJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 08:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYBKNJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 08:09:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51661 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbYBKNJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 08:09:02 -0500
Date: Mon, 11 Feb 2008 14:08:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: ying.huang@intel.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [6/8] Account overlapped mappings in end_pfn_map
Message-ID: <20080211130843.GC23733@elte.hu>
References: <200802111034.764275766@suse.de> <20080211093434.E30961B41CE@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211093434.E30961B41CE@basil.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> When end_pfn is not aligned to 2MB (or 1GB) then the kernel might map 
> more memory than end_pfn. Account this in end_pfn_mapped.

can you see any practical relevance? Your patch description only deals 
with the mechanical details of the change instead of analyzing the most 
important thing: relevance and impact analysis. That makes it harder to 
add your patches and easier to miss a good fix accidentally. It also 
makes it quite a bit harder to trust your patches.

at a quick glance the relevance is to EFI only, in 
efi_enter_virtual_mode(). max_pfn_mapped is used as a differentiator 
between __va() and efi_ioremap(). AFAICS EFI will typically have its 
runtime code not right after the end of physical memory.

Nevertheless, i do agree that the max_pfn_mapped/end_pfn_map limit needs 
to be sharpened to reflect reality (for later PAT support).

your patch is also a bit unclean:

> -static void __meminit
> +static unsigned long __meminit
>  phys_pmd_update(pud_t *pud, unsigned long address, unsigned long end)
>  {
> +	unsigned long r;
>  	pmd_t *pmd = pmd_offset(pud, 0);
>  	spin_lock(&init_mm.page_table_lock);
> -	phys_pmd_init(pmd, address, end);
> +	r = phys_pmd_init(pmd, address, end);
>  	spin_unlock(&init_mm.page_table_lock);
>  	__flush_tlb_all();
> +	return r;
>  }

a meaningless "r" parameter. Use "true_end" instead.

and here's another type of variable naming problem:

> +unsigned long __init_refok
> +init_memory_mapping(unsigned long start, unsigned long end)
>  {
> -	unsigned long next;
> +	unsigned long next, true_end = end;

that "true_end" is already a _pfn_, so name it accordingly: 
true_end_pfn. Because we switch between pfn and addr types it's 
important to point out where it's pfn and where it's a linear/physical 
address.

>  	struct zone *zone = pgdat->node_zones + ZONE_NORMAL;
>  	unsigned long start_pfn = start >> PAGE_SHIFT;
>  	unsigned long nr_pages = size >> PAGE_SHIFT;
> +	unsigned long r;
>  	int ret;
>  
> -	init_memory_mapping(start, start + size-1);
> +	r = init_memory_mapping(start, start + size-1);
> +	if (r > end_pfn_map)
> +		end_pfn_map = r;

rename "r" to "true_end_pfn".

	Ingo
