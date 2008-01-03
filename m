Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbYACQWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbYACQWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 11:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbYACQWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 11:22:39 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:50444 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbYACQWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 11:22:39 -0500
Date: Thu, 3 Jan 2008 17:22:35 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Andi Kleen <ak@suse.de>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [6/16] Add a new arch_early_alloc() interface for
 x86-64
Message-Id: <20080103172235.58c069c9.dada1@cosmosbay.com>
In-Reply-To: <20080103154220.0CCD814DDB@wotan.suse.de>
References: <20080103442.621670000@suse.de>
	<20080103154220.0CCD814DDB@wotan.suse.de>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  3 Jan 2008 16:42:20 +0100 (CET)
Andi Kleen <ak@suse.de> wrote:

> 
> This allows to allocate memory really early before bootmem is setup.
> 
> And a symbol that can be tested by the preprocessor.
> 
> pgtable.h is probably not the best include for it, but also not the worst.
> 
> Cc: peterz@infradead.org
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86/kernel/e820_64.c    |   14 ++++++++++++++
>  include/asm-x86/pgtable_64.h |    3 +++
>  2 files changed, 17 insertions(+)
> 
> Index: linux/arch/x86/kernel/e820_64.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/e820_64.c
> +++ linux/arch/x86/kernel/e820_64.c
> @@ -819,3 +819,17 @@ int __init arch_get_ram_range(int slot, 
>  		max_pfn << PAGE_SHIFT) - *addr;
>  	return i + 1;
>  }
> +
> +#define EARLY_ALLOC_START (32<<20)
> +__init void *arch_early_alloc(unsigned long size)
> +{
> +	unsigned long p = find_e820_area(EARLY_ALLOC_START, -1UL, size);
> +	if (p == -1ULL) {
> +		/* Risk filling the DMA zone */
> +		p = find_e820_area(EARLY_ALLOC_START, -1UL, size);

Hum... Are you sure of this EARLY_ALLOC_START here ?

> +		if (p == -1ULL)
> +			panic("arch_early_alloc %lu failed", size);
> +	}
> +	reserve_early(p, p + size);
> +	return __va(p);
> +}

