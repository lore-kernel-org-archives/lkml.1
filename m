Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793AbZFLIhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbZFLIhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbZFLIhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:37:25 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39720 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbZFLIhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:37:24 -0400
Subject: Re: [GIT PULL v3] Early boot SLAB for 2.6.31
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <cl@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       hannes@cmpxchg.org, mpm@selenic.com, npiggin@suse.de
In-Reply-To: <4A318FD5.7090908@kernel.org>
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI>
	 <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain>
	 <alpine.LFD.2.01.0906101332440.6847@localhost.localdomain>
	 <Pine.LNX.4.64.0906111416070.10394@melkki.cs.Helsinki.FI>
	 <alpine.DEB.1.10.0906110954030.29827@gentwo.org>
	 <84144f020906110706y8df301bhd930dc48f3188d3c@mail.gmail.com>
	 <84144f020906110824g7b3981abmdbcf94ae2f9068de@mail.gmail.com>
	 <4A3143E3.3090705@kernel.org>
	 <Pine.LNX.4.64.0906112101020.21593@melkki.cs.Helsinki.FI>
	 <20090611214342.GA12762@elte.hu>  <4A318FD5.7090908@kernel.org>
Date: Fri, 12 Jun 2009 11:37:25 +0300
Message-Id: <1244795845.30512.26.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 16:14 -0700, Yinghai Lu wrote:
> please check
> 
> [PATCH] x86: make zap_low_mapping could be used early
> 
> only one cpu is there, just call __flush_tlb for it
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/tlbflush.h |    2 +-
>  arch/x86/kernel/smpboot.c       |    2 +-
>  arch/x86/mm/init_32.c           |   10 +++++++---
>  3 files changed, 9 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/asm/tlbflush.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/tlbflush.h
> +++ linux-2.6/arch/x86/include/asm/tlbflush.h
> @@ -172,6 +172,6 @@ static inline void flush_tlb_kernel_rang
>  	flush_tlb_all();
>  }
>  
> -extern void zap_low_mappings(void);
> +extern void zap_low_mappings(bool early);
>  
>  #endif /* _ASM_X86_TLBFLUSH_H */
> Index: linux-2.6/arch/x86/kernel/smpboot.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/smpboot.c
> +++ linux-2.6/arch/x86/kernel/smpboot.c
> @@ -875,7 +875,7 @@ int __cpuinit native_cpu_up(unsigned int
>  
>  	err = do_boot_cpu(apicid, cpu);
>  
> -	zap_low_mappings();
> +	zap_low_mappings(false);
>  	low_mappings = 0;
>  #else
>  	err = do_boot_cpu(apicid, cpu);
> Index: linux-2.6/arch/x86/mm/init_32.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/init_32.c
> +++ linux-2.6/arch/x86/mm/init_32.c
> @@ -576,7 +576,7 @@ static inline void save_pg_dir(void)
>  }
>  #endif /* !CONFIG_ACPI_SLEEP */
>  
> -void zap_low_mappings(void)
> +void zap_low_mappings(bool early)
>  {
>  	int i;
>  
> @@ -593,7 +593,11 @@ void zap_low_mappings(void)
>  		set_pgd(swapper_pg_dir+i, __pgd(0));
>  #endif
>  	}
> -	flush_tlb_all();
> +
> +	if (early)
> +		__flush_tlb();
> +	else
> +		flush_tlb_all();
>  }
>  
>  pteval_t __supported_pte_mask __read_mostly = ~(_PAGE_NX | _PAGE_GLOBAL | _PAGE_IOMAP);
> @@ -968,7 +972,7 @@ void __init mem_init(void)
>  		test_wp_bit();
>  
>  	save_pg_dir();
> -	zap_low_mappings();
> +	zap_low_mappings(true);
>  }
>  
>  #ifdef CONFIG_MEMORY_HOTPLUG

Applied, thanks!

			Pekka

