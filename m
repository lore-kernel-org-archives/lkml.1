Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbZDMDK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbZDMDK3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 23:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbZDMDKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 23:10:17 -0400
Received: from 219-87-157-179.static.tfn.net.tw ([219.87.157.179]:39215 "EHLO
	mswedge1.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbZDMDKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 23:10:15 -0400
In-Reply-To: <20090409232957.b97dd46e.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Kyle McMartin <kyle@mcmartin.ca>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 4/14] score - New architecure port to SunplusCT S+CORE
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF43EC993E.C89EBBA3-ON48257597.000E9F34-48257597.000F6685@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Mon, 13 Apr 2009 10:45:54 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/04/13 ?? 10:46:03,
	Serialize complete at 2009/04/13 ?? 10:46:03
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n3D3AYqu024417

Hi Andrew Morton,

        You only commented 4 patches,
        how about others?

        We want to update the code after you finished it.

Best Regards
Liqin

Andrew Morton <akpm@linux-foundation.org> Ğ´ÓÚ 2009-04-10 14:29:57:

> On Wed, 8 Apr 2009 15:23:28 +0800 liqin.chen@sunplusct.com wrote:
> 
> > From: Chen Liqin <liqin.chen@sunplusct.com>
> > 
> > asm/kmap_types.h, asm/linkage.h, asm/local.h, asm/mman.h, 
> > asm/mmu_context.h,
> > asm/mmu.h, asm/module.h, asm/msgbuf.h, asm/mutex.h, asm/page.h, 
> > asm/param.h,
> > asm/pci.h, asm/percpu.h, asm/pgalloc.h, asm/pgtable-32.h, 
> > asm/pgtable-bits.h,
> > asm/pgtable.h, asm/poll.h, asm/posix_types.h and asm/processor.h
> > for the score architecture.
> >
> > ...
> >
> > --- linux-2.6-git.ori/arch/score/include/asm/kmap_types.h 1970-01-01 
> > 08:00:00.000000000 +0800
> > +++ linux-2.6-git.new/arch/score/include/asm/kmap_types.h 2009-04-03 
> > 17:01:04.000000000 +0800
> > @@ -0,0 +1,21 @@
> > +#ifndef __SCORE_KMAP_TYPES_H
> > +#define __SCORE_KMAP_TYPES_H
> > +
> > +enum km_type {
> > +       KM_BOUNCE_READ,
> > +       KM_SKB_SUNRPC_DATA,
> > +       KM_SKB_DATA_SOFTIRQ,
> > +       KM_USER0,
> > +       KM_USER1,
> > +       KM_BIO_SRC_IRQ,
> > +       KM_BIO_DST_IRQ,
> > +       KM_PTE0,
> > +       KM_PTE1,
> > +       KM_IRQ0,
> > +       KM_IRQ1,
> > +       KM_SOFTIRQ0,
> > +       KM_SOFTIRQ1,
> > +       KM_TYPE_NR
> > +};
> 
> hm.  Our nineteenth copy of kmap_types.h, all of them basically the
> same.
> 
> That's not a problem for this patchset, but we suck.
> 
> >
> > ...
> >
> > +static inline void
> > +get_new_mmu_context(struct mm_struct *mm, unsigned long cpu)
> > +{
> > +       unsigned long asid = asid_cache(0);
> > +
> > +       if (!((asid = asid + ASID_INC) & ASID_MASK)) {
> 
> ick.  Complex statements likethis are to be avoided, please.
> 
>    unsigned long asid = asid_cache(0) + ASID_INC;
> 
>    if (!(asid & ASID_MASK)) {
> 
> is nicer, no?
> 
> > +               local_flush_tlb_all();          /* start new asid 
cycle */
> > +               if (!asid)                      /* fix version if 
needed 
> > */
> > +                       asid = ASID_FIRST_VERSION;
> > +       }
> > +       cpu_context(0, mm) = asid_cache(0) = asid;
> 
> This style causes less concern, but some would even prefer
> 
>    cpu_context(0, mm) = asid;
>    asid_cache(0) = asid;
> 
> C lets you perform lots of weird shortcuts and tricks, but we actively
> avoid many of them in the kernel.
> 
> > +}
> > +
> > +/*
> > + * Initialize the context related info for a new mm_struct
> > + * instance.
> > + */
> > +static inline int
> > +init_new_context(struct task_struct *tsk, struct mm_struct *mm)
> > +{
> > +       cpu_context(0, mm) = 0;
> 
> More stylistic whining - this is one of my pet peeves.  It's just a
> meaningless absurdity to call a function and to then modify its return
> value.
> 
> So cpu_context() _has_ to be a macro which evaluates to an lvalue. 
> Which wrecks any concept of encapsulation. 
> Macros-which-look-like-functions should be interchangesable with
> functions, but this one isn't.
> 
> I mean, the above statement jusst isn't C.  Whereas
> 
>    set_cpu_context(0, mm0, 0);
> 
> _is_ C.  See what I mean.
> 
> Anwyay.  I'm not saying you should go off and change everything.  But
> it's daft.
> 
> > +       return 0;
> > +}
> > +
> > +static inline void switch_mm(struct mm_struct *prev, struct mm_struct 

> > *next,
> > +                               struct task_struct *tsk)
> > +{
> > +       unsigned long flags;
> > +
> > +       local_irq_save(flags);
> > +       if ((cpu_context(0, next) ^ asid_cache(0)) & 
ASID_VERSION_MASK)
> > +               get_new_mmu_context(next, 0);
> > +       set_PEVN(cpu_context(0, next));
> > +       TLBMISS_HANDLER_SETUP_PGD(next->pgd);
> 
> Some macros are all-lower-case.
> 
> Some macros are part-lower-case and part-upper-case.
> 
> Some macros are all-upper-case.
> 
> Is there any sense behind it all?
> 
> > +       local_irq_restore(flags);
> > +}
> > +
> > +/*
> > + * Destroy context related info for an mm_struct that is about
> > + * to be put to rest.
> > + */
> > +static inline void destroy_context(struct mm_struct *mm)
> > +{}
> > +
> > +#define deactivate_mm(tsk, mm) do {} while (0)
> 
> static inline void deactivate_mm(struct task_struct *task, struct 
> mm_struct *mm)
> 
> is nicer.  It isn't a macro, and it provides typechecking and sometimes
> it can fix an unused-variable warning at callsites.
> 
> Probably you copied this from somewhere else.  Sigh.
> 
> > +/*
> > + * After we have set current->mm to a new value, this activates
> > + * the context for the new mm so we see the new mappings.
> > + */
> > +static inline void
> > +activate_mm(struct mm_struct *prev, struct mm_struct *next)
> > +{
> > +       unsigned long flags;
> > +
> > +       local_irq_save(flags);
> > +       get_new_mmu_context(next, 0);
> > +       set_PEVN(cpu_context(0, next));
> > +       TLBMISS_HANDLER_SETUP_PGD(next->pgd);
> > +       local_irq_restore(flags);
> > +}
> > +
> > +#endif /* __SCORE_MMU_CONTEXT_H */
> > diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
> > linux-2.6-git.ori/arch/score/include/asm/mmu.h 
> > linux-2.6-git.new/arch/score/include/asm/mmu.h
> > --- linux-2.6-git.ori/arch/score/include/asm/mmu.h      1970-01-01 
> > 08:00:00.000000000 +0800
> > +++ linux-2.6-git.new/arch/score/include/asm/mmu.h      2009-04-08 
> > 10:51:34.000000000 +0800
> > @@ -0,0 +1,6 @@
> > +#ifndef __SCORE_MMU_H
> > +#define __SCORE_MMU_H
> > +
> > +typedef unsigned long mm_context_t[NR_CPUS];
> 
> hm.  Is this an SMP-capable architecture?
> 
> > +#endif /* __SCORE_MMU_H */
> > diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
> >
> > ...
> >
> > +#ifdef CONFIG_CPU_SCORE7
> > +#define MODULE_PROC_FAMILY "SCORE7"
> > +#else
> > +#error MODULE_PROC_FAMILY undefined for your processor configuration
> > +#endif
> 
> Is the #error necessary?  If it triggers, that indicates a bug in
> Kconfig, no?
> 
> >
> > ...
> >
> > +#define ARCH_PFN_OFFSET                PFN_UP(PHYS_OFFSET)
> > +
> > +#define clear_page(page)       memset((void *)(page), 0, PAGE_SIZE)
> > +#define copy_page(to, from)    memcpy((to), (from), PAGE_SIZE)
> > +
> > +#define clear_user_page(page, vaddr, pg)       clear_page(page)
> > +#define copy_user_page(to, from, vaddr, pg)    copy_page(to, from)
> 
> Well that's nice and simple ;)
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
