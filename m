Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbZH2NdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbZH2NdG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 09:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbZH2NdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 09:33:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40754 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbZH2NdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 09:33:04 -0400
Date: Sat, 29 Aug 2009 15:31:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kmemleak: Ignore the aperture memory hole on x86_64
Message-ID: <20090829133152.GC24123@elte.hu>
References: <20090827165927.27901.97270.stgit@pc1117.cambridge.arm.com> <20090827170258.27901.83613.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827170258.27901.83613.stgit@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Catalin Marinas <catalin.marinas@arm.com> wrote:

> This block is allocated with alloc_bootmem() and scanned by kmemleak but
> the kernel direct mapping may no longer exist. This patch tells kmemleak
> to ignore this memory hole. The dma32_bootmem_ptr in
> dma32_reserve_bootmem() is also ignored.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/aperture_64.c |    6 ++++++
>  arch/x86/kernel/pci-dma.c     |    6 ++++++
>  2 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
> index 676debf..128111d 100644
> --- a/arch/x86/kernel/aperture_64.c
> +++ b/arch/x86/kernel/aperture_64.c
> @@ -20,6 +20,7 @@
>  #include <linux/bitops.h>
>  #include <linux/ioport.h>
>  #include <linux/suspend.h>
> +#include <linux/kmemleak.h>
>  #include <asm/e820.h>
>  #include <asm/io.h>
>  #include <asm/iommu.h>
> @@ -94,6 +95,11 @@ static u32 __init allocate_aperture(void)
>  	 * code for safe
>  	 */
>  	p = __alloc_bootmem_nopanic(aper_size, aper_size, 512ULL<<20);
> +	/*
> +	 * Kmemleak should not scan this block as it may not be mapped via the
> +	 * kernel direct mapping.
> +	 */
> +	kmemleak_ignore(p);
>  	if (!p || __pa(p)+aper_size > 0xffffffff) {
>  		printk(KERN_ERR
>  			"Cannot allocate aperture memory hole (%p,%uK)\n",

This sure does not look right for the rare but theoretically 
possible !p case, does it?

> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index 1a041bc..fa80f60 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -3,6 +3,7 @@
>  #include <linux/dmar.h>
>  #include <linux/bootmem.h>
>  #include <linux/pci.h>
> +#include <linux/kmemleak.h>
>  
>  #include <asm/proto.h>
>  #include <asm/dma.h>
> @@ -88,6 +89,11 @@ void __init dma32_reserve_bootmem(void)
>  	size = roundup(dma32_bootmem_size, align);
>  	dma32_bootmem_ptr = __alloc_bootmem_nopanic(size, align,
>  				 512ULL<<20);
> +	/*
> +	 * Kmemleak should not scan this block as it may not be mapped via the
> +	 * kernel direct mapping.
> +	 */
> +	kmemleak_ignore(dma32_bootmem_ptr);
>  	if (dma32_bootmem_ptr)
>  		dma32_bootmem_size = size;

Same question.

	Ingo
