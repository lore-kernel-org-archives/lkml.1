Return-Path: <linux-kernel-owner+w=401wt.eu-S1759277AbZB0S6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbZB0S6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 13:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759022AbZB0S62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 13:58:28 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:65282 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759015AbZB0S61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 13:58:27 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIEAEvGp0lMQWWY/2dsb2JhbACBWdVNhBQG
Date: Fri, 27 Feb 2009 13:53:16 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/6] ftrace, x86: make kernel text writable only for
	conversions
Message-ID: <20090227185316.GA19811@Krystal>
References: <alpine.DEB.2.00.0902230928000.18221@gandalf.stny.rr.com> <20090223154258.GB28727@Krystal> <alpine.DEB.2.00.0902231044050.18221@gandalf.stny.rr.com> <20090223161312.GA30279@Krystal> <alpine.DEB.2.00.0902231125520.18221@gandalf.stny.rr.com> <20090223173108.GB1441@Krystal> <alpine.DEB.2.00.0902231236340.18221@gandalf.stny.rr.com> <49A82851.5080707@redhat.com> <20090227180724.GA17947@Krystal> <49A83237.40604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49A83237.40604@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:44:22 up 6 days, 10:18,  3 users,  load average: 0.03, 0.15,
	0.23
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Mathieu Desnoyers wrote:
> > * Masami Hiramatsu (mhiramat@redhat.com) wrote:
> >> Steven Rostedt wrote:
> >>> On Mon, 23 Feb 2009, Mathieu Desnoyers wrote:
> >>>>> Hmm, lets see. I simply set a bit in the PTE mappings. There's not many, 
> >>>>> since a lot are 2M pages, for x86_64. Call stop_machine, and now I can 
> >>>>> modify 1 or 20,000 locations. Set the PTE bit back. Note, the changing of 
> >>>>> the bits are only done when CONFIG_DEBUG_RODATA is set.
> >>>>>
> >>>>> text_poke requires allocating a page. Map the page into memory. Set up a 
> >>>>> break point.
> >>>> text_poke does not _require_ a break point. text_poke can work with
> >>>> stop_machine.
> >>> It can? Doesn't text_poke require allocating pages? The code called by 
> >>> stop_machine is all atomic. vmap does not give an option to allocate with 
> >>> GFP_ATOMIC.
> >> Hi,
> >>
> >> With my patch, text_poke() never allocate pages any more :)
> >>
> >> BTW, IMHO, both of your methods are useful and have trade-off.
> >>
> >> ftrace wants to change massive amount of code at once. If we do
> >> that with text_poke(), we have to map/unmap pages each time and
> >> it will take a long time -- might be longer than one stop_machine_run().
> >>
> >> On the other hand, text_poke() user like as kprobes and tracepoints,
> >> just want to change a few amount of code at once, and it will be
> >> added/removed incrementally. If we do that with stop_machine_run(),
> >> we'll be annoyed by frequent machine stops.(Moreover, kprobes uses
> >> breakpoint, so it doesn't need stop_machine_run())
> >>
> > 
> > Hi Masami,
> > 
> > Is this text_poke version executable in atomic context ? If yes, then
> > that would be good to add a comment saying it. Please see below for
> > comments.
> 
> Thank you for comments!
> I think it could be. ah, spin_lock might be changed to spin_lock_irqsave()...
> 

You are right. If we plan to execute this in both atomic and non-atomic
context, spin_lock_irqsave would make sure we are always busy-looping
with interrupts off.

Having spinlocks taken in _both_ interrupts on and off contexts leads to
higher interrupt latencies when the interrupt-off waits for an
interrupt-on thread.


> >> Thank you,
> >>
> > [...]
> >> Use map_vm_area() instead of vmap() in text_poke() for avoiding page allocation
> >> and delayed unmapping.
> >>
> >> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> >> ---
> >>  arch/x86/include/asm/alternative.h |    1 +
> >>  arch/x86/kernel/alternative.c      |   25 ++++++++++++++++++++-----
> >>  init/main.c                        |    3 +++
> >>  3 files changed, 24 insertions(+), 5 deletions(-)
> >>
> >> Index: linux-2.6/arch/x86/include/asm/alternative.h
> >> ===================================================================
> >> --- linux-2.6.orig/arch/x86/include/asm/alternative.h
> >> +++ linux-2.6/arch/x86/include/asm/alternative.h
> >> @@ -177,6 +177,7 @@ extern void add_nops(void *insns, unsign
> >>   * The _early version expects the memory to already be RW.
> >>   */
> >>  
> >> +extern void text_poke_init(void);
> >>  extern void *text_poke(void *addr, const void *opcode, size_t len);
> >>  extern void *text_poke_early(void *addr, const void *opcode, size_t len);
> >>  
> >> Index: linux-2.6/arch/x86/kernel/alternative.c
> >> ===================================================================
> >> --- linux-2.6.orig/arch/x86/kernel/alternative.c
> >> +++ linux-2.6/arch/x86/kernel/alternative.c
> >> @@ -485,6 +485,16 @@ void *text_poke_early(void *addr, const 
> >>  	return addr;
> >>  }
> >>  
> >> +static struct vm_struct *text_poke_area[2];
> >> +static DEFINE_SPINLOCK(text_poke_lock);
> >> +
> >> +void __init text_poke_init(void)
> >> +{
> >> +	text_poke_area[0] = get_vm_area(PAGE_SIZE, VM_ALLOC);
> >> +	text_poke_area[1] = get_vm_area(2 * PAGE_SIZE, VM_ALLOC);
> > 
> > Why is this text_poke_area[1] 2 * PAGE_SIZE in size ? I would have
> > thought that text_poke_area[0] would be PAGE_SIZE, text_poke_area[1]
> > also be PAGE_SIZE, and that the sum of both would be 2 * PAGE_SIZE..
> 
> Unfortunately, current map_vm_area() tries to map the size of vm_area,
> this means, you can't use 2page-size vm_area for mapping just 1 page...
> (or maybe, we can set pages[1] = pages[0] when 2nd page doesn't exist)
> 

OK, given we sometimes have to map only a single page (e.g. at the end
of a text section), we really need both 1 and 2 pages mapping. So I
think you solution is good.

> 
> >> +	BUG_ON(!text_poke_area[0] || !text_poke_area[1]);
> >> +}
> >> +
> >>  /**
> >>   * text_poke - Update instructions on a live kernel
> >>   * @addr: address to modify
> >> @@ -501,8 +511,9 @@ void *__kprobes text_poke(void *addr, co
> >>  	unsigned long flags;
> >>  	char *vaddr;
> >>  	int nr_pages = 2;
> >> -	struct page *pages[2];
> >> -	int i;
> >> +	struct page *pages[2], **pgp = pages;
> > 
> > Hrm, why do you need **pgp ? Could you simply pass &pages to map_vm_area ?
> 
> As you know, pages means just the address(value) of an array, so you can't
> get the address of the address...(pages and &pages are same.)
> 
>         int array[2];
>         printf("%p, %p",array, &array);
> 
> please try it :)
> 
> And actually, map_vm_area() requires the address of a pointer.

Ah yes, thanks for the explanation.

After changing the spinlock/irqsave, I think that patch would be good to
merge. And then Steve could use text_poke within stop_machine if he
likes.

Mathieu

> ---
> int map_vm_area(struct vm_struct *area, pgprot_t prot, struct page ***pages)
> {
>         unsigned long addr = (unsigned long)area->addr;
>         unsigned long end = addr + area->size - PAGE_SIZE;
>         int err;
> 
>         err = vmap_page_range(addr, end, prot, *pages);
>         if (err > 0) {
>                 *pages += err;
>                 ^^^^^^^^^^^^^^ Here, it tries to add err(=number of mapped pages)
>                                to the pages pointer!
>                 err = 0;
>         }
> 
>         return err;
> }
> ---
> 
> 
> > 
> > Thanks,
> > 
> > Mathieu
> > 
> >> +	int i, ret;
> >> +	struct vm_struct *vma;
> >>  
> >>  	if (!core_kernel_text((unsigned long)addr)) {
> >>  		pages[0] = vmalloc_to_page(addr);
> >> @@ -515,12 +526,16 @@ void *__kprobes text_poke(void *addr, co
> >>  	BUG_ON(!pages[0]);
> >>  	if (!pages[1])
> >>  		nr_pages = 1;
> >> -	vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
> >> -	BUG_ON(!vaddr);
> >> +	spin_lock(&text_poke_lock);
> >> +	vma = text_poke_area[nr_pages-1];
> >> +	ret = map_vm_area(vma, PAGE_KERNEL, &pgp);
> >> +	BUG_ON(ret);
> >> +	vaddr = vma->addr;
> >>  	local_irq_save(flags);
> >>  	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
> >>  	local_irq_restore(flags);
> >> -	vunmap(vaddr);
> >> +	unmap_kernel_range((unsigned long)vma->addr, (unsigned long)vma->size);
> >> +	spin_unlock(&text_poke_lock);
> >>  	sync_core();
> >>  	/* Could also do a CLFLUSH here to speed up CPU recovery; but
> >>  	   that causes hangs on some VIA CPUs. */
> >> @@ -528,3 +543,4 @@ void *__kprobes text_poke(void *addr, co
> >>  		BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);
> >>  	return addr;
> >>  }
> >> +EXPORT_SYMBOL_GPL(text_poke);
> >> Index: linux-2.6/init/main.c
> >> ===================================================================
> >> --- linux-2.6.orig/init/main.c
> >> +++ linux-2.6/init/main.c
> >> @@ -676,6 +676,9 @@ asmlinkage void __init start_kernel(void
> >>  	taskstats_init_early();
> >>  	delayacct_init();
> >>  
> >> +#ifdef CONFIG_X86
> >> +	text_poke_init();
> >> +#endif
> >>  	check_bugs();
> >>  
> >>  	acpi_early_init(); /* before LAPIC and SMP init */
> > 
> > 
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
