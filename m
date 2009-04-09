Return-Path: <linux-kernel-owner+w=401wt.eu-S934982AbZDISqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934982AbZDISqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934435AbZDISqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:46:19 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:61814 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934326AbZDISqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:46:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEAJfa3UlMQW1W/2dsb2JhbACBUs0tg3sG
Date: Thu, 9 Apr 2009 14:46:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Gary Hade <garyhade@us.ibm.com>
Subject: Re: [BUGFIX][PATCH] x86: fix set_fixmap to use phys_addr_t
Message-ID: <20090409184605.GA4252@Krystal>
References: <49D76FFF.6020202@redhat.com> <20090404154230.GB2451@Krystal> <49D7A6DF.8080804@redhat.com> <49D7AF26.5030808@redhat.com> <49D82987.5090003@redhat.com> <49DA37CB.4020901@redhat.com> <20090408123133.GE18581@elte.hu> <49DCBB53.2020202@redhat.com> <20090408145953.GP12931@elte.hu> <49DE3695.6040800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49DE3695.6040800@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:45:01 up 40 days, 15:11,  1 user,  load average: 0.18, 0.40,
	0.31
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Use phys_addr_t for receiving a physical address argument
> instead of unsigned long. This allows fixmap to handle
> pages higher than 4GB on x86-32.
> 

You might also want to update arch/x86/mm/ioremap.c:early_set_fixmap()
and __early_set_fixmap().

Otherwise it looks good.

Thanks,

Mathieu

> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> ---
> 
>  arch/x86/include/asm/fixmap.h   |    4 ++--
>  arch/x86/include/asm/paravirt.h |    4 ++--
>  arch/x86/mm/pgtable.c           |    3 ++-
>  arch/x86/xen/mmu.c              |    2 +-
>  4 files changed, 7 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
> index 81937a5..2d81af3 100644
> --- a/arch/x86/include/asm/fixmap.h
> +++ b/arch/x86/include/asm/fixmap.h
> @@ -151,11 +151,11 @@ extern pte_t *pkmap_page_table;
> 
>  void __native_set_fixmap(enum fixed_addresses idx, pte_t pte);
>  void native_set_fixmap(enum fixed_addresses idx,
> -		       unsigned long phys, pgprot_t flags);
> +		       phys_addr_t phys, pgprot_t flags);
> 
>  #ifndef CONFIG_PARAVIRT
>  static inline void __set_fixmap(enum fixed_addresses idx,
> -				unsigned long phys, pgprot_t flags)
> +				phys_addr_t phys, pgprot_t flags)
>  {
>  	native_set_fixmap(idx, phys, flags);
>  }
> diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
> index 7727aa8..378e369 100644
> --- a/arch/x86/include/asm/paravirt.h
> +++ b/arch/x86/include/asm/paravirt.h
> @@ -347,7 +347,7 @@ struct pv_mmu_ops {
>  	/* Sometimes the physical address is a pfn, and sometimes its
>  	   an mfn.  We can tell which is which from the index. */
>  	void (*set_fixmap)(unsigned /* enum fixed_addresses */ idx,
> -			   unsigned long phys, pgprot_t flags);
> +			   phys_addr_t phys, pgprot_t flags);
>  };
> 
>  struct raw_spinlock;
> @@ -1432,7 +1432,7 @@ static inline void arch_leave_lazy_mmu_mode(void)
>  void arch_flush_lazy_mmu_mode(void);
> 
>  static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
> -				unsigned long phys, pgprot_t flags)
> +				phys_addr_t phys, pgprot_t flags)
>  {
>  	pv_mmu_ops.set_fixmap(idx, phys, flags);
>  }
> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> index 7a4d6ee..8e43bdd 100644
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -347,7 +347,8 @@ void __native_set_fixmap(enum fixed_addresses idx, pte_t pte)
>  	fixmaps_set++;
>  }
> 
> -void native_set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t flags)
> +void native_set_fixmap(enum fixed_addresses idx, phys_addr_t phys,
> +		       pgprot_t flags)
>  {
>  	__native_set_fixmap(idx, pfn_pte(phys >> PAGE_SHIFT, flags));
>  }
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index db3802f..2a81838 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1750,7 +1750,7 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
>  }
>  #endif	/* CONFIG_X86_64 */
> 
> -static void xen_set_fixmap(unsigned idx, unsigned long phys, pgprot_t prot)
> +static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
>  {
>  	pte_t pte;
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
