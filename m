Return-Path: <linux-kernel-owner+w=401wt.eu-S1423344AbXBPGfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423344AbXBPGfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 01:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423348AbXBPGfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 01:35:12 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53680 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423347AbXBPGfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 01:35:10 -0500
Date: Thu, 15 Feb 2007 22:34:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
Subject: Re: [patch 10/21] Xen-paravirt: add hooks to intercept mm creation
 and destruction
Message-Id: <20070215223409.eea8f1e3.akpm@linux-foundation.org>
In-Reply-To: <20070216022531.267584466@goop.org>
References: <20070216022449.739760547@goop.org>
	<20070216022531.267584466@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 18:24:59 -0800 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Add hooks to allow a paravirt implementation to track the lifetime of
> an mm.
> 
> --- a/arch/i386/kernel/paravirt.c
> +++ b/arch/i386/kernel/paravirt.c
> @@ -706,6 +706,10 @@ struct paravirt_ops paravirt_ops = {
>  	.irq_enable_sysexit = native_irq_enable_sysexit,
>  	.iret = native_iret,
>  
> +	.dup_mmap = (void *)native_nop,
> +	.exit_mmap = (void *)native_nop,
> +	.activate_mm = (void *)native_nop,
> +
>  	.startup_ipi_hook = (void *)native_nop,
>  };

eww.  I suppose there's a good reason for the casting.

> ===================================================================
> --- a/include/asm-i386/mmu_context.h
> +++ b/include/asm-i386/mmu_context.h
> @@ -5,6 +5,7 @@
>  #include <asm/atomic.h>
>  #include <asm/pgalloc.h>
>  #include <asm/tlbflush.h>
> +#include <asm/paravirt.h>
>  
>  /*
>   * Used for LDT copy/destruction.
> @@ -65,7 +66,10 @@ static inline void switch_mm(struct mm_s
>  #define deactivate_mm(tsk, mm)			\
>  	asm("movl %0,%%gs": :"r" (0));
>  
> -#define activate_mm(prev, next) \
> -	switch_mm((prev),(next),NULL)
> +#define activate_mm(prev, next)				\
> +	do {						\
> +		arch_activate_mm(prev, next);		\
> +		switch_mm((prev),(next),NULL);		\
> +	} while(0);

It seems strange to call out to arch_foo() from within an arch header file.
I mean, we implicity know we're i386.

Maybe it's just poorly named.

> +static inline void paravirt_activate_mm(struct mm_struct *prev,
> +					struct mm_struct *next)
> +{
> +}
> +
> +static inline void paravirt_dup_mmap(struct mm_struct *oldmm,
> +				     struct mm_struct *mm)
> +{
> +}
> +
> +static inline void paravirt_exit_mmap(struct mm_struct *mm)
> +{
> +}

These functions are unreferenced in this patchset.

>  #endif /* CONFIG_PARAVIRT */
>  #endif	/* __ASM_PARAVIRT_H */
> ===================================================================
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -374,6 +374,12 @@ struct mm_struct {
>  	rwlock_t		ioctx_list_lock;
>  	struct kioctx		*ioctx_list;
>  };
> +
> +#ifndef __HAVE_ARCH_MM_LIFETIME
> +#define arch_activate_mm(prev, next)	do {} while(0)
> +#define arch_dup_mmap(oldmm, mm)	do {} while(0)
> +#define arch_exit_mmap(mm)		do {} while(0)
> +#endif

Can we lose __HAVE_ARCH_MM_LIFETIME?  Just define these (preferably in C,
not in cpp) in the appropriate include/asm-foo/ files?

>  struct sighand_struct {
>  	atomic_t		count;
> ===================================================================
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -286,6 +286,7 @@ static inline int dup_mmap(struct mm_str
>  		if (retval)
>  			goto out;
>  	}
> +	arch_dup_mmap(oldmm, mm);
>  	retval = 0;
>  out:
>  	up_write(&mm->mmap_sem);
> ===================================================================
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1976,6 +1976,8 @@ void exit_mmap(struct mm_struct *mm)
>  	struct vm_area_struct *vma = mm->mmap;
>  	unsigned long nr_accounted = 0;
>  	unsigned long end;
> +
> +	arch_exit_mmap(mm);
>  
>  	lru_add_drain();
>  	flush_cache_mm(mm);

Perhaps some commentary telling the arch maintainer what these hooks he's
being offered are for?
