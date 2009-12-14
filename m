Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbZLNJIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbZLNJIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZLNJIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:08:41 -0500
Received: from gate.crashing.org ([63.228.1.57]:47789 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbZLNJIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:08:40 -0500
Subject: Re: linux-next: 52xx-and-virtex tree build failure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Albert Herranz <albert_herranz@yahoo.es>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
In-Reply-To: <20091214163456.e2e948cc.sfr@canb.auug.org.au>
References: <20091214163456.e2e948cc.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 20:08:17 +1100
Message-ID: <1260781697.2217.15.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 16:34 +1100, Stephen Rothwell wrote:
> Hi Grant,
> 
> Today's linux-next build (powerpc ppc44x_defconfig) failed like this:
> 
> arch/powerpc/mm/pgtable_32.c: In function 'mapin_ram':
> arch/powerpc/mm/pgtable_32.c:318: error: too many arguments to function 'mmu_mapin_ram'
> 
> Casued by commit de32400dd26e743c5d500aa42d8d6818b79edb73 ("wii: use both
> mem1 and mem2 as ram").
> 
> I applied the following patch for today, but this may be too much or
> there may be a better solution.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 14 Dec 2009 16:04:15 +1100
> Subject: [PATCH] powerpc: fix up for mmu_mapin_ram api change
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Grant, please add to your tree along with the Nintendo stuff.

Cheers,
Ben.

> ---
>  arch/powerpc/mm/40x_mmu.c       |    2 +-
>  arch/powerpc/mm/44x_mmu.c       |    2 +-
>  arch/powerpc/mm/fsl_booke_mmu.c |    2 +-
>  arch/powerpc/mm/mmu_decl.h      |    6 +++---
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/powerpc/mm/40x_mmu.c b/arch/powerpc/mm/40x_mmu.c
> index f5e7b9c..08dfa8e 100644
> --- a/arch/powerpc/mm/40x_mmu.c
> +++ b/arch/powerpc/mm/40x_mmu.c
> @@ -91,7 +91,7 @@ void __init MMU_init_hw(void)
>  #define LARGE_PAGE_SIZE_16M	(1<<24)
>  #define LARGE_PAGE_SIZE_4M	(1<<22)
>  
> -unsigned long __init mmu_mapin_ram(void)
> +unsigned long __init mmu_mapin_ram(unsigned long top)
>  {
>  	unsigned long v, s, mapped;
>  	phys_addr_t p;
> diff --git a/arch/powerpc/mm/44x_mmu.c b/arch/powerpc/mm/44x_mmu.c
> index 98052ac..3986264 100644
> --- a/arch/powerpc/mm/44x_mmu.c
> +++ b/arch/powerpc/mm/44x_mmu.c
> @@ -88,7 +88,7 @@ void __init MMU_init_hw(void)
>  	flush_instruction_cache();
>  }
>  
> -unsigned long __init mmu_mapin_ram(void)
> +unsigned long __init mmu_mapin_ram(unsigned long top)
>  {
>  	unsigned long addr;
>  
> diff --git a/arch/powerpc/mm/fsl_booke_mmu.c b/arch/powerpc/mm/fsl_booke_mmu.c
> index fcfcb6e..c539472 100644
> --- a/arch/powerpc/mm/fsl_booke_mmu.c
> +++ b/arch/powerpc/mm/fsl_booke_mmu.c
> @@ -207,7 +207,7 @@ unsigned long map_mem_in_cams(unsigned long ram, int max_cam_idx)
>  	return amount_mapped;
>  }
>  
> -unsigned long __init mmu_mapin_ram(void)
> +unsigned long __init mmu_mapin_ram(unsigned long top)
>  {
>  	return tlbcam_addrs[tlbcam_index - 1].limit - PAGE_OFFSET + 1;
>  }
> diff --git a/arch/powerpc/mm/mmu_decl.h b/arch/powerpc/mm/mmu_decl.h
> index eef7aaf..d49a775 100644
> --- a/arch/powerpc/mm/mmu_decl.h
> +++ b/arch/powerpc/mm/mmu_decl.h
> @@ -139,15 +139,15 @@ extern void wii_memory_fixups(void);
>   */
>  #if defined(CONFIG_8xx)
>  #define MMU_init_hw()		do { } while(0)
> -#define mmu_mapin_ram()		(0UL)
> +#define mmu_mapin_ram(top)	(0UL)
>  
>  #elif defined(CONFIG_4xx)
>  extern void MMU_init_hw(void);
> -extern unsigned long mmu_mapin_ram(void);
> +extern unsigned long mmu_mapin_ram(unsigned long top);
>  
>  #elif defined(CONFIG_FSL_BOOKE)
>  extern void MMU_init_hw(void);
> -extern unsigned long mmu_mapin_ram(void);
> +extern unsigned long mmu_mapin_ram(unsigned long top);
>  extern void adjust_total_lowmem(void);
>  
>  #elif defined(CONFIG_PPC32)
> -- 
> 1.6.5.4
> 


