Return-Path: <linux-kernel-owner+w=401wt.eu-S1758367AbZB0SHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367AbZB0SHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 13:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbZB0SHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 13:07:30 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:51175 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752460AbZB0SH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 13:07:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIEAGe5p0lMQWWY/2dsb2JhbACBWdVZhBQG
Date: Fri, 27 Feb 2009 13:07:24 -0500
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
Message-ID: <20090227180724.GA17947@Krystal>
References: <alpine.DEB.2.00.0902222317510.18221@gandalf.stny.rr.com> <20090223045357.GA9158@Krystal> <alpine.DEB.2.00.0902230928000.18221@gandalf.stny.rr.com> <20090223154258.GB28727@Krystal> <alpine.DEB.2.00.0902231044050.18221@gandalf.stny.rr.com> <20090223161312.GA30279@Krystal> <alpine.DEB.2.00.0902231125520.18221@gandalf.stny.rr.com> <20090223173108.GB1441@Krystal> <alpine.DEB.2.00.0902231236340.18221@gandalf.stny.rr.com> <49A82851.5080707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49A82851.5080707@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:01:49 up 6 days,  9:35,  3 users,  load average: 0.37, 0.47,
	0.38
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Steven Rostedt wrote:
> > On Mon, 23 Feb 2009, Mathieu Desnoyers wrote:
> >>> Hmm, lets see. I simply set a bit in the PTE mappings. There's not many, 
> >>> since a lot are 2M pages, for x86_64. Call stop_machine, and now I can 
> >>> modify 1 or 20,000 locations. Set the PTE bit back. Note, the changing of 
> >>> the bits are only done when CONFIG_DEBUG_RODATA is set.
> >>>
> >>> text_poke requires allocating a page. Map the page into memory. Set up a 
> >>> break point.
> >> text_poke does not _require_ a break point. text_poke can work with
> >> stop_machine.
> > 
> > It can? Doesn't text_poke require allocating pages? The code called by 
> > stop_machine is all atomic. vmap does not give an option to allocate with 
> > GFP_ATOMIC.
> 
> Hi,
> 
> With my patch, text_poke() never allocate pages any more :)
> 
> BTW, IMHO, both of your methods are useful and have trade-off.
> 
> ftrace wants to change massive amount of code at once. If we do
> that with text_poke(), we have to map/unmap pages each time and
> it will take a long time -- might be longer than one stop_machine_run().
> 
> On the other hand, text_poke() user like as kprobes and tracepoints,
> just want to change a few amount of code at once, and it will be
> added/removed incrementally. If we do that with stop_machine_run(),
> we'll be annoyed by frequent machine stops.(Moreover, kprobes uses
> breakpoint, so it doesn't need stop_machine_run())
> 

Hi Masami,

Is this text_poke version executable in atomic context ? If yes, then
that would be good to add a comment saying it. Please see below for
comments.

> 
> Thank you,
> 
[...]
> Use map_vm_area() instead of vmap() in text_poke() for avoiding page allocation
> and delayed unmapping.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> ---
>  arch/x86/include/asm/alternative.h |    1 +
>  arch/x86/kernel/alternative.c      |   25 ++++++++++++++++++++-----
>  init/main.c                        |    3 +++
>  3 files changed, 24 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/asm/alternative.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/alternative.h
> +++ linux-2.6/arch/x86/include/asm/alternative.h
> @@ -177,6 +177,7 @@ extern void add_nops(void *insns, unsign
>   * The _early version expects the memory to already be RW.
>   */
>  
> +extern void text_poke_init(void);
>  extern void *text_poke(void *addr, const void *opcode, size_t len);
>  extern void *text_poke_early(void *addr, const void *opcode, size_t len);
>  
> Index: linux-2.6/arch/x86/kernel/alternative.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/alternative.c
> +++ linux-2.6/arch/x86/kernel/alternative.c
> @@ -485,6 +485,16 @@ void *text_poke_early(void *addr, const 
>  	return addr;
>  }
>  
> +static struct vm_struct *text_poke_area[2];
> +static DEFINE_SPINLOCK(text_poke_lock);
> +
> +void __init text_poke_init(void)
> +{
> +	text_poke_area[0] = get_vm_area(PAGE_SIZE, VM_ALLOC);
> +	text_poke_area[1] = get_vm_area(2 * PAGE_SIZE, VM_ALLOC);

Why is this text_poke_area[1] 2 * PAGE_SIZE in size ? I would have
thought that text_poke_area[0] would be PAGE_SIZE, text_poke_area[1]
also be PAGE_SIZE, and that the sum of both would be 2 * PAGE_SIZE..

> +	BUG_ON(!text_poke_area[0] || !text_poke_area[1]);
> +}
> +
>  /**
>   * text_poke - Update instructions on a live kernel
>   * @addr: address to modify
> @@ -501,8 +511,9 @@ void *__kprobes text_poke(void *addr, co
>  	unsigned long flags;
>  	char *vaddr;
>  	int nr_pages = 2;
> -	struct page *pages[2];
> -	int i;
> +	struct page *pages[2], **pgp = pages;

Hrm, why do you need **pgp ? Could you simply pass &pages to map_vm_area ?

Thanks,

Mathieu

> +	int i, ret;
> +	struct vm_struct *vma;
>  
>  	if (!core_kernel_text((unsigned long)addr)) {
>  		pages[0] = vmalloc_to_page(addr);
> @@ -515,12 +526,16 @@ void *__kprobes text_poke(void *addr, co
>  	BUG_ON(!pages[0]);
>  	if (!pages[1])
>  		nr_pages = 1;
> -	vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
> -	BUG_ON(!vaddr);
> +	spin_lock(&text_poke_lock);
> +	vma = text_poke_area[nr_pages-1];
> +	ret = map_vm_area(vma, PAGE_KERNEL, &pgp);
> +	BUG_ON(ret);
> +	vaddr = vma->addr;
>  	local_irq_save(flags);
>  	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
>  	local_irq_restore(flags);
> -	vunmap(vaddr);
> +	unmap_kernel_range((unsigned long)vma->addr, (unsigned long)vma->size);
> +	spin_unlock(&text_poke_lock);
>  	sync_core();
>  	/* Could also do a CLFLUSH here to speed up CPU recovery; but
>  	   that causes hangs on some VIA CPUs. */
> @@ -528,3 +543,4 @@ void *__kprobes text_poke(void *addr, co
>  		BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);
>  	return addr;
>  }
> +EXPORT_SYMBOL_GPL(text_poke);
> Index: linux-2.6/init/main.c
> ===================================================================
> --- linux-2.6.orig/init/main.c
> +++ linux-2.6/init/main.c
> @@ -676,6 +676,9 @@ asmlinkage void __init start_kernel(void
>  	taskstats_init_early();
>  	delayacct_init();
>  
> +#ifdef CONFIG_X86
> +	text_poke_init();
> +#endif
>  	check_bugs();
>  
>  	acpi_early_init(); /* before LAPIC and SMP init */


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
