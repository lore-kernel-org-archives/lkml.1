Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbYBHXVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbYBHXVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYBHXVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:21:00 -0500
Received: from waste.org ([66.93.16.53]:48695 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbYBHXU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:20:59 -0500
Subject: Re: [PATCH] x86 (Linux Tiny): configure out support for some
	processors
From: Matt Mackall <mpm@selenic.com>
To: Michael Opdenacker <michael-lists@free-electrons.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Linux-tiny@selenic.com
In-Reply-To: <200802082347.25364.michael-lists@free-electrons.com>
References: <200802082347.25364.michael-lists@free-electrons.com>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 17:20:12 -0600
Message-Id: <1202512812.17934.680.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-08 at 23:47 +0100, Michael Opdenacker wrote:
> This patch against x86/mm tries to revive an original patch
> from Matt Mackall which didn't get merged at that time. It makes
> it possible to disable support code for some processors. This can
> be useful to support only the exact processor type used
> in a given system.
> 
> I may have made wrong assumptions with the code handling
> force_mwait. As force_mwait is only declared in
> arch/x86/kernel/cpu/amd.c, which is only compiled
> when CONFIG_X86_32 is set, I thought it was safe
> to make the code depend on CONFIG_CPU_SUP_AMD,
> but I could be wrong.
> 
> Your comments are more than welcome! To make the code
> cleaner, I could use empty inline functions instead
> of ifdef's, as suggested in Documentation/SubmittingPatches.

Please include the output of size with all these options on and off.

> diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
> index dabdbef..8f9a123 100644
> --- a/arch/x86/kernel/process_32.c
> +++ b/arch/x86/kernel/process_32.c
> @@ -287,8 +287,10 @@ static void mwait_idle(void)
>  
>  static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
>  {
> +#ifdef CONFIG_CPU_SUP_AMD
>  	if (force_mwait)
>  		return 1;
> +#endif

Probably makes sense to move force_mwait (one word) here and eliminate
these ifdefs.

> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index 347a8cd..812bfa0 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -211,12 +211,14 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
>  	}
>  }
>  
> +#ifdef CONFIG_CPU_SUP_INTEL
>  static inline int page_kills_ppro(unsigned long pagenr)
>  {
>  	if (pagenr >= 0x70000 && pagenr <= 0x7003F)
>  		return 1;
>  	return 0;
>  }
> +#endif
>  /*
>   * devmem_is_allowed() checks to see if /dev/mem access to a certain address
> @@ -287,7 +289,11 @@ static void __meminit free_new_highpage(struct page *page)
>  
>  void __init add_one_highpage_init(struct page *page, int pfn, int bad_ppro)
>  {
> -	if (page_is_ram(pfn) && !(bad_ppro && page_kills_ppro(pfn))) {
> +	if (page_is_ram(pfn)
> +#ifdef CONFIG_CPU_SUP_INTEL
> +	    && !(bad_ppro && page_kills_ppro(pfn))
> +#endif

Yuck. A better way to do this is move the bad_ppro check into
page_kills_ppro and then ifdef out -the body- of the inline.

> @@ -592,7 +598,11 @@ void __init mem_init(void)
>  #ifdef CONFIG_FLATMEM
>  	BUG_ON(!mem_map);
>  #endif
> +#ifdef CONFIG_CPU_SUP_INTEL
>  	bad_ppro = ppro_with_ram_bug();
> +#else
> +	bad_ppro = 0;
> +#endif

Again, move the storage for this, let it get initialized to zero
automatically, and initialize it in the CPU-specific code (if ordering
allows).
 
-- 
Mathematics is the supreme nostalgia of our time.

