Return-Path: <linux-kernel-owner+w=401wt.eu-S937000AbZDJGe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937000AbZDJGe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 02:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759196AbZDJGer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 02:34:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019AbZDJGeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 02:34:46 -0400
Date: Thu, 9 Apr 2009 23:29:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: liqin.chen@sunplusct.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: [PATCH 4/14] score - New architecure port to SunplusCT S+CORE
Message-Id: <20090409232957.b97dd46e.akpm@linux-foundation.org>
In-Reply-To: <OF37DA4769.A6BC9B10-ON48257592.00287E6E-48257592.0028CC22@sunplusct.com>
References: <OF37DA4769.A6BC9B10-ON48257592.00287E6E-48257592.0028CC22@sunplusct.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009 15:23:28 +0800 liqin.chen@sunplusct.com wrote:

> From: Chen Liqin <liqin.chen@sunplusct.com>
> 
> asm/kmap_types.h, asm/linkage.h, asm/local.h, asm/mman.h, 
> asm/mmu_context.h,
> asm/mmu.h, asm/module.h, asm/msgbuf.h, asm/mutex.h, asm/page.h, 
> asm/param.h,
> asm/pci.h, asm/percpu.h, asm/pgalloc.h, asm/pgtable-32.h, 
> asm/pgtable-bits.h,
> asm/pgtable.h, asm/poll.h, asm/posix_types.h and asm/processor.h
> for the score architecture.
>
> ...
>
> --- linux-2.6-git.ori/arch/score/include/asm/kmap_types.h       1970-01-01 
> 08:00:00.000000000 +0800
> +++ linux-2.6-git.new/arch/score/include/asm/kmap_types.h       2009-04-03 
> 17:01:04.000000000 +0800
> @@ -0,0 +1,21 @@
> +#ifndef __SCORE_KMAP_TYPES_H
> +#define __SCORE_KMAP_TYPES_H
> +
> +enum km_type {
> +       KM_BOUNCE_READ,
> +       KM_SKB_SUNRPC_DATA,
> +       KM_SKB_DATA_SOFTIRQ,
> +       KM_USER0,
> +       KM_USER1,
> +       KM_BIO_SRC_IRQ,
> +       KM_BIO_DST_IRQ,
> +       KM_PTE0,
> +       KM_PTE1,
> +       KM_IRQ0,
> +       KM_IRQ1,
> +       KM_SOFTIRQ0,
> +       KM_SOFTIRQ1,
> +       KM_TYPE_NR
> +};

hm.  Our nineteenth copy of kmap_types.h, all of them basically the
same.

That's not a problem for this patchset, but we suck.

>
> ...
>
> +static inline void
> +get_new_mmu_context(struct mm_struct *mm, unsigned long cpu)
> +{
> +       unsigned long asid = asid_cache(0);
> +
> +       if (!((asid = asid + ASID_INC) & ASID_MASK)) {

ick.  Complex statements likethis are to be avoided, please.

	unsigned long asid = asid_cache(0) + ASID_INC;

	if (!(asid & ASID_MASK)) {

is nicer, no?

> +               local_flush_tlb_all();          /* start new asid cycle */
> +               if (!asid)                      /* fix version if needed 
> */
> +                       asid = ASID_FIRST_VERSION;
> +       }
> +       cpu_context(0, mm) = asid_cache(0) = asid;

This style causes less concern, but some would even prefer

	cpu_context(0, mm) = asid;
	asid_cache(0) = asid;

C lets you perform lots of weird shortcuts and tricks, but we actively
avoid many of them in the kernel.

> +}
> +
> +/*
> + * Initialize the context related info for a new mm_struct
> + * instance.
> + */
> +static inline int
> +init_new_context(struct task_struct *tsk, struct mm_struct *mm)
> +{
> +       cpu_context(0, mm) = 0;

More stylistic whining - this is one of my pet peeves.  It's just a
meaningless absurdity to call a function and to then modify its return
value.

So cpu_context() _has_ to be a macro which evaluates to an lvalue. 
Which wrecks any concept of encapsulation. 
Macros-which-look-like-functions should be interchangesable with
functions, but this one isn't.

I mean, the above statement jusst isn't C.  Whereas

	set_cpu_context(0, mm0, 0);

_is_ C.  See what I mean.

Anwyay.  I'm not saying you should go off and change everything.  But
it's daft.

> +       return 0;
> +}
> +
> +static inline void switch_mm(struct mm_struct *prev, struct mm_struct 
> *next,
> +                               struct task_struct *tsk)
> +{
> +       unsigned long flags;
> +
> +       local_irq_save(flags);
> +       if ((cpu_context(0, next) ^ asid_cache(0)) & ASID_VERSION_MASK)
> +               get_new_mmu_context(next, 0);
> +       set_PEVN(cpu_context(0, next));
> +       TLBMISS_HANDLER_SETUP_PGD(next->pgd);

Some macros are all-lower-case.

Some macros are part-lower-case and part-upper-case.

Some macros are all-upper-case.

Is there any sense behind it all?

> +       local_irq_restore(flags);
> +}
> +
> +/*
> + * Destroy context related info for an mm_struct that is about
> + * to be put to rest.
> + */
> +static inline void destroy_context(struct mm_struct *mm)
> +{}
> +
> +#define deactivate_mm(tsk, mm) do {} while (0)

static inline void deactivate_mm(struct task_struct *task, struct mm_struct *mm)

is nicer.  It isn't a macro, and it provides typechecking and sometimes
it can fix an unused-variable warning at callsites.

Probably you copied this from somewhere else.  Sigh.

> +/*
> + * After we have set current->mm to a new value, this activates
> + * the context for the new mm so we see the new mappings.
> + */
> +static inline void
> +activate_mm(struct mm_struct *prev, struct mm_struct *next)
> +{
> +       unsigned long flags;
> +
> +       local_irq_save(flags);
> +       get_new_mmu_context(next, 0);
> +       set_PEVN(cpu_context(0, next));
> +       TLBMISS_HANDLER_SETUP_PGD(next->pgd);
> +       local_irq_restore(flags);
> +}
> +
> +#endif /* __SCORE_MMU_CONTEXT_H */
> diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
> linux-2.6-git.ori/arch/score/include/asm/mmu.h 
> linux-2.6-git.new/arch/score/include/asm/mmu.h
> --- linux-2.6-git.ori/arch/score/include/asm/mmu.h      1970-01-01 
> 08:00:00.000000000 +0800
> +++ linux-2.6-git.new/arch/score/include/asm/mmu.h      2009-04-08 
> 10:51:34.000000000 +0800
> @@ -0,0 +1,6 @@
> +#ifndef __SCORE_MMU_H
> +#define __SCORE_MMU_H
> +
> +typedef unsigned long mm_context_t[NR_CPUS];

hm.  Is this an SMP-capable architecture?

> +#endif /* __SCORE_MMU_H */
> diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
>
> ...
>
> +#ifdef CONFIG_CPU_SCORE7
> +#define MODULE_PROC_FAMILY "SCORE7"
> +#else
> +#error MODULE_PROC_FAMILY undefined for your processor configuration
> +#endif

Is the #error necessary?  If it triggers, that indicates a bug in
Kconfig, no?

>
> ...
>
> +#define ARCH_PFN_OFFSET                PFN_UP(PHYS_OFFSET)
> +
> +#define clear_page(page)       memset((void *)(page), 0, PAGE_SIZE)
> +#define copy_page(to, from)    memcpy((to), (from), PAGE_SIZE)
> +
> +#define clear_user_page(page, vaddr, pg)       clear_page(page)
> +#define copy_user_page(to, from, vaddr, pg)    copy_page(to, from)

Well that's nice and simple ;)


