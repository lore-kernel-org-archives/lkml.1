Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbYJWUkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbYJWUkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 16:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYJWUjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 16:39:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752860AbYJWUjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 16:39:54 -0400
Date: Thu, 23 Oct 2008 13:38:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Keith Packard <keithp@keithp.com>
Cc: mingo@elte.hu, keithp@keithp.com, nickpiggin@yahoo.com.au,
       airlied@linux.ie, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       dri-devel@lists.sf.net, yinghai@kernel.org
Subject: Re: Adding kmap_atomic_prot_pfn  (was: [git pull] drm patches for
 2.6.27-rc1)
Message-Id: <20081023133840.d4eef579.akpm@linux-foundation.org>
In-Reply-To: <1224793332.22877.8.camel@koto.keithp.com>
References: <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
	<20081018203741.GA23396@elte.hu>
	<1224366690.4384.89.camel@koto.keithp.com>
	<20081018223214.GA5093@elte.hu>
	<1224389697.4384.118.camel@koto.keithp.com>
	<1224398496.5303.7.camel@koto.keithp.com>
	<20081019175320.GA6442@elte.hu>
	<1224450291.5303.23.camel@koto.keithp.com>
	<20081020115810.GC10594@elte.hu>
	<1224517744.5195.1.camel@koto.keithp.com>
	<20081022093615.GF12453@elte.hu>
	<1224793332.22877.8.camel@koto.keithp.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008 13:22:12 -0700
Keith Packard <keithp@keithp.com> wrote:

> We just ran some numbers on a box with PAT enabled and broken MTRRs.
> Finally we have a test platform for the difference between kmap_atomic
> and kmap_atomic_prot. Using regular kmap_atomic on this platform, we get
> UC access to the graphics device; sending data from the CPU is a bit
> slow. Adding kmap_atomic_prot_pfn and specifying WC access raises that
> by a fairly significant factor, taking our CPU utilization for
> copy_from_user from 40% to 2%.
> 
> Here's a patch which adds kmap_atomic_prot_pfn to the kernel for this
> usage. When we add native io-mapping support instead of sitting on top
> of kmap, we can remove this function.
> 
> I've reworked the io_mapping patches to use this function as well, along
> with cleaning up the i915 code along the lines of Linus' current
> version. I'll post those if this patch looks acceptable.
> 
> From e3f633dcb36889fa85ea06cca339072df3c44ae0 Mon Sep 17 00:00:00 2001
> From: Keith Packard <keithp@keithp.com>
> Date: Thu, 23 Oct 2008 11:53:45 -0700
> Subject: [PATCH] Add kmap_atomic_prot_pfn
> 
> kmap_atomic_prot_pfn is a mixture of kmap_atomic_prot and kmap_atomic_pfn,
> accepting both a pfn instead of a page and an explicit protection value.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  arch/x86/mm/highmem_32.c  |   19 +++++++++++++++++++
>  include/asm-x86/highmem.h |    1 +
>  include/linux/highmem.h   |    1 +
>  3 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
> index bcc079c..91ae5e8 100644
> --- a/arch/x86/mm/highmem_32.c
> +++ b/arch/x86/mm/highmem_32.c
> @@ -139,6 +139,25 @@ void *kmap_atomic_pfn(unsigned long pfn, enum km_type type)
>  }
>  EXPORT_SYMBOL_GPL(kmap_atomic_pfn); /* temporarily in use by i915 GEM until vmap */
>  
> +/* This is the same as kmap_atomic_prot() but can map memory that doesn't
> + * have a struct page associated with it.
> + */
> +void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
> +{
> +	enum fixed_addresses idx;
> +	unsigned long vaddr;
> +
> +	pagefault_disable();
> +
> +	idx = type + KM_TYPE_NR*smp_processor_id();
> +	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
> +	set_pte(kmap_pte-idx, pfn_pte(pfn, prot));
> +	arch_flush_lazy_mmu_mode();
> +
> +	return (void*) vaddr;
> +}
> +EXPORT_SYMBOL_GPL(kmap_atomic_prot_pfn); /* temporarily in use by i915 GEM until vmap */

I guess one could reimplemenet kmap_atomic_pfn() to call this.  Sometime.

>  struct page *kmap_atomic_to_page(void *ptr)
>  {
>  	unsigned long idx, vaddr = (unsigned long)ptr;
> diff --git a/include/asm-x86/highmem.h b/include/asm-x86/highmem.h
> index bc3f6a2..a1f8f8c 100644
> --- a/include/asm-x86/highmem.h
> +++ b/include/asm-x86/highmem.h
> @@ -66,6 +66,7 @@ void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot);
>  void *kmap_atomic(struct page *page, enum km_type type);
>  void kunmap_atomic(void *kvaddr, enum km_type type);
>  void *kmap_atomic_pfn(unsigned long pfn, enum km_type type);
> +void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot);

Given that all highmem-implementing archtiectures must use the same
declaration here, we might as well put it into include/linux/highmem.h.
Although that goes against current mistakes^Wcode.

Does powerpc32 still implement highmem?  It seems that way.  You broke
it, no?
