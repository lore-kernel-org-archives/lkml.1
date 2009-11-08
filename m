Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbZKHMGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbZKHMGP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbZKHMGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:06:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35363 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbZKHMGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:06:14 -0500
Date: Sun, 8 Nov 2009 13:06:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: UV SGI, Don't track GRU space in PAT
Message-ID: <20091108120609.GW11372@elte.hu>
References: <20091029184723.GA562@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091029184723.GA562@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Jack Steiner <steiner@sgi.com> wrote:

> 
> GRU space is always mapped as WB in the page table. There is
> no need to track the mappings in the PAT. This also eliminates
> the "freeing invalid memtype" messages when the GRU space is unmapped.
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>
> 
> ---
> 
> (resend of patch sent on 9/9. Seems to have fallen thru the cracks...)
> 
> 
>  arch/x86/include/asm/uv/uv.h       |    2 ++
>  arch/x86/kernel/apic/x2apic_uv_x.c |   11 ++++++++++-
>  arch/x86/mm/pat.c                  |    5 +++--
>  3 files changed, 15 insertions(+), 3 deletions(-)
> 
> Index: linux/arch/x86/include/asm/uv/uv.h
> ===================================================================
> --- linux.orig/arch/x86/include/asm/uv/uv.h	2009-10-05 08:12:09.000000000 -0500
> +++ linux/arch/x86/include/asm/uv/uv.h	2009-10-05 08:36:59.000000000 -0500
> @@ -8,6 +8,7 @@ struct mm_struct;
>  
>  #ifdef CONFIG_X86_UV
>  
> +extern int is_GRU_range(u64 start, u64 end);
>  extern enum uv_system_type get_uv_system_type(void);
>  extern int is_uv_system(void);
>  extern void uv_cpu_init(void);
> @@ -19,6 +20,7 @@ extern const struct cpumask *uv_flush_tl
>  
>  #else	/* X86_UV */
>  
> +static inline int is_GRU_range(u64 start, u64 end)	{ return 0; }
>  static inline enum uv_system_type get_uv_system_type(void) { return UV_NONE; }
>  static inline int is_uv_system(void)	{ return 0; }
>  static inline void uv_cpu_init(void)	{ }
> Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2009-10-05 08:12:09.000000000 -0500
> +++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2009-10-05 08:36:59.000000000 -0500
> @@ -34,6 +34,7 @@
>  DEFINE_PER_CPU(int, x2apic_extra_bits);
>  
>  static enum uv_system_type uv_system_type;
> +static u64 gru_start_paddr, gru_end_paddr;
>  
>  static int early_get_nodeid(void)
>  {
> @@ -68,6 +69,11 @@ enum uv_system_type get_uv_system_type(v
>  	return uv_system_type;
>  }
>  
> +int is_GRU_range(u64 start, u64 end)
> +{
> +	return start >= gru_start_paddr && end < gru_end_paddr;
> +}
> +
>  int is_uv_system(void)
>  {
>  	return uv_system_type != UV_NONE;
> @@ -385,8 +391,11 @@ static __init void map_gru_high(int max_
>  	int shift = UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_SHFT;
>  
>  	gru.v = uv_read_local_mmr(UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR);
> -	if (gru.s.enable)
> +	if (gru.s.enable) {
>  		map_high("GRU", gru.s.base, shift, max_pnode, map_wb);
> +		gru_start_paddr = ((u64)gru.s.base << shift);
> +		gru_end_paddr = gru_start_paddr + (1UL << shift) * (max_pnode + 1);
> +	}
>  }
>  
>  static __init void map_mmr_high(int max_pnode)
> Index: linux/arch/x86/mm/pat.c
> ===================================================================
> --- linux.orig/arch/x86/mm/pat.c	2009-10-05 08:12:09.000000000 -0500
> +++ linux/arch/x86/mm/pat.c	2009-10-05 08:36:59.000000000 -0500
> @@ -28,6 +28,7 @@
>  #include <asm/msr.h>
>  #include <asm/pat.h>
>  #include <asm/io.h>
> +#include <asm/uv/uv.h>
>  
>  #ifdef CONFIG_X86_PAT
>  int __read_mostly pat_enabled = 1;
> @@ -388,7 +389,7 @@ int reserve_memtype(u64 start, u64 end, 
>  	}
>  
>  	/* Low ISA region is always mapped WB in page table. No need to track */
> -	if (is_ISA_range(start, end - 1)) {
> +	if (is_ISA_range(start, end - 1) || is_GRU_range(start, end - 1)) {
>  		if (new_type)
>  			*new_type = _PAGE_CACHE_WB;
>  		return 0;
> @@ -499,7 +500,7 @@ int free_memtype(u64 start, u64 end)
>  		return 0;
>  
>  	/* Low ISA region is always mapped WB. No need to track */
> -	if (is_ISA_range(start, end - 1))
> +	if (is_ISA_range(start, end - 1) || is_GRU_range(start, end - 1))
>  		return 0;

Hm, that's quite ugly - we used to have is_ISA_range() exceptions, now 
is_GRU_range() is added too.

We should instead have an x86_platform vector for PAT exceptions, which 
SGI/UV (and ISA) would fill in automatically, agreed?

	Ingo
