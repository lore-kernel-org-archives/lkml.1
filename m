Return-Path: <linux-kernel-owner+w=401wt.eu-S936827AbXGQUzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936827AbXGQUzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757606AbXGQUza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:55:30 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:55493 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763792AbXGQUz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:55:28 -0400
Date: Tue, 17 Jul 2007 16:55:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <ak@suse.de>
Cc: Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: Re: [PATCH] x86: make SMP locks handling interact properly with CONFIG_DEBUG_RODATA (2nd try)
Message-ID: <20070717205524.GA13567@Krystal>
References: <468B5B54.76E4.0078.0@novell.com> <200707171954.34541.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200707171954.34541.ak@suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:51:44 up 15:25,  4 users,  load average: 0.54, 0.33, 0.35
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

I guess the patch I proposed there:
"Text Edit Lock"
http://www.ussg.iu.edu/hypermail/linux/kernel/0707.1/2980.html

solves the problem more generally than the patch discussed in this
thread. It provides locking (architecture independent) and correct
page protection (architecture dependent) for paravirt, alternatives
kprobes and, eventually, immediate values.

Mathieu

* Andi Kleen (ak@suse.de) wrote:
> On Wednesday 04 July 2007 08:33:24 Jan Beulich wrote:
> 
> Sorry for late feedback.
> 
> 
> > +#ifdef CONFIG_DEBUG_RODATA
> > +
> > +#ifdef CONFIG_X86_32
> > +#include <asm/highmem.h>
> > +#define MODULES_VADDR VMALLOC_START
> > +#endif
> > +
> > +static inline void make_writable(const void *instr, unsigned int len)
> > +{
> > +	unsigned long va = (unsigned long)instr;
> > +
> > +	if (va < MODULES_VADDR) {
> > +		change_page_attr(virt_to_page(instr),
> > +				 PFN_UP(va + len) - PFN_DOWN(va),
> > +				 PAGE_KERNEL_EXEC);
> > +		global_flush_tlb();
> > +	}
> > +}
> > +
> > +static inline void make_readonly(const void *instr, unsigned int len)
> > +{
> > +	unsigned long va = (unsigned long)instr;
> > +
> > +	if (va < MODULES_VADDR) {
> > +		change_page_attr(virt_to_page(instr),
> > +				 PFN_UP(va + len) - PFN_DOWN(va),
> > +#ifdef CONFIG_X86_64
> > +				 PAGE_KERNEL_RO);
> > +#else
> > +				 PAGE_KERNEL_RX);
> > +#endif
> > +		global_flush_tlb();
> > +	}
> > +}
> 
> Can you please move those into the respective pageattr.cs without ifdefs? 
> Also the va < MODULES_VADDR test seems overly magic; while it may work right now
> it seems fragile. It would be better to test the exact ranges in the respective
> architectures
> 
> >  void alternatives_smp_module_del(struct module *mod)
> >  {
> >  	struct smp_alt_module *item;
> > -	unsigned long flags;
> >  
> >  	if (smp_alt_once || noreplace_smp)
> >  		return;
> >  
> > -	spin_lock_irqsave(&smp_alt, flags);
> > +	spin_lock(&smp_alt);
> 
> Unrelated change?  Why? Should probably be separate patch.
> 
> > --- linux-2.6.22-rc7/arch/x86_64/kernel/vmlinux.lds.S	2007-07-03 10:57:39.000000000 +0200
> > +++ 2.6.22-rc7-x86-alt-page-attr/arch/x86_64/kernel/vmlinux.lds.S	2007-07-02 14:40:15.000000000 +0200
> > @@ -131,20 +131,11 @@ SECTIONS
> >    /* might get freed after init */
> >    . = ALIGN(4096);
> >    __smp_alt_begin = .;
> > -  __smp_alt_instructions = .;
> > -  .smp_altinstructions : AT(ADDR(.smp_altinstructions) - LOAD_OFFSET) {
> > -	*(.smp_altinstructions)
> > -  }
> > -  __smp_alt_instructions_end = .;
> > -  . = ALIGN(8);
> >    __smp_locks = .;
> >    .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
> >  	*(.smp_locks)
> >    }
> >    __smp_locks_end = .;
> > -  .smp_altinstr_replacement : AT(ADDR(.smp_altinstr_replacement) - LOAD_OFFSET) {
> > -	*(.smp_altinstr_replacement)
> > -  }
> 
> While ok too it should be also separate please.
> 
> -Andi
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
