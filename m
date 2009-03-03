Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbZCCROV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbZCCROV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 12:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbZCCROJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 12:14:09 -0500
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:57497 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753912AbZCCROI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 12:14:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABvxrElMQW1W/2dsb2JhbACBTtZ0hAYG
Date: Tue, 3 Mar 2009 12:08:59 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH] x86: make text_poke() atomic using fixmap
Message-ID: <20090303170859.GA31532@Krystal>
References: <49AC5A87.7000604@redhat.com> <20090302222254.GA31962@elte.hu> <49AC63FA.70801@redhat.com> <20090302230915.GA11626@elte.hu> <49AC6DEA.2050304@redhat.com> <20090302234910.GA17956@elte.hu> <49AC7453.8020307@redhat.com> <20090303002214.GA4147@elte.hu> <49AC7A5F.7080009@redhat.com> <49AD5B55.10002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49AD5B55.10002@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:08:01 up 3 days, 13:34,  2 users,  load average: 0.78, 0.53,
	0.36
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Masami Hiramatsu wrote:
> > Ingo Molnar wrote:
> >> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> >>
> >>> Ingo Molnar wrote:
> >>>> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> >>>>
> >>>>> Ingo Molnar wrote:
> >>>>>>>> So perhaps another approach to (re-)consider would be to go back 
> >>>>>>>> to atomic fixmaps here. It spends 3 slots but that's no big 
> >>>>>>>> deal.
> >>>>>>> Oh, it's a good idea! fixmaps must make it simpler.
> >>>>>>>
> >>>>>>>> In exchange it will be conceptually simpler, and will also scale 
> >>>>>>>> much better than a global spinlock. What do you think?
> >>>>>>> I think even if I use fixmaps, we have to use a spinlock to protect
> >>>>>>> the fixmap area from other threads...
> >>>>>> that's why i suggested to use an atomic-kmap, not a fixmap.
> >>>>> Even if the mapping is atomic, text_poke() has to protect pte
> >>>>> from other text_poke()s while changing code.
> >>>>> AFAIK, atomic-kmap itself doesn't ensure that, does it?
> >>>> Well, but text_poke() is not a serializing API to begin with. 
> >>>> It's normally used in code patching sequences when we 'know' 
> >>>> that there cannot be similar parallel activities. The kprobes 
> >>>> usage of text_poke() looks unsafe - and that needs to be fixed.
> >>> Oh, kprobes already prohibited parallel arming/disarming
> >>> by using kprobe_mutex. :-)
> >> yeah, but still the API is somewhat unsafe.
> > 
> > Yeah, kprobe_mutex protects text_poke from other kprobes, but
> > not from other text_poke() users...
> > 
> >> In any case, you also answered your own question:
> >>
> >>>>> Even if the mapping is atomic, text_poke() has to protect pte
> >>>>> from other text_poke()s while changing code.
> >>>>> AFAIK, atomic-kmap itself doesn't ensure that, does it?
> >> kprobe_mutex does that.
> > 
> > Anyway, text_edit_lock ensures that.
> > 
> > By the way, I think set_fixmap/clear_fixmap seems simpler than
> > kmap_atomic() variant. Would you think improving kmap_atomic_prot()
> > is better?
> 
> Hi Ingo,
> 
> Here is the patch which uses fixmaps instead of vmap in text_poke().
> This made the code much simpler than I thought :).
> 
> Thanks,
> 
> ----
> Use fixmaps instead of vmap/vunmap in text_poke() for avoiding page allocation
> and delayed unmapping.
> 
> At the result of above change, text_poke() becomes atomic and can be called
> from stop_machine() etc.
> 

It looks great, thanks !

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> ---
>  arch/x86/include/asm/fixmap_32.h |    2 ++
>  arch/x86/include/asm/fixmap_64.h |    2 ++
>  arch/x86/kernel/alternative.c    |   18 ++++++++++++------
>  3 files changed, 16 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/asm/fixmap_32.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/fixmap_32.h
> +++ linux-2.6/arch/x86/include/asm/fixmap_32.h
> @@ -81,6 +81,8 @@ enum fixed_addresses {
>  #ifdef CONFIG_PARAVIRT
>  	FIX_PARAVIRT_BOOTMAP,
>  #endif
> +	FIX_TEXT_POKE0,	/* reserve 2 pages for text_poke() */
> +	FIX_TEXT_POKE1,
>  	__end_of_permanent_fixed_addresses,
>  	/*
>  	 * 256 temporary boot-time mappings, used by early_ioremap(),
> Index: linux-2.6/arch/x86/include/asm/fixmap_64.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/fixmap_64.h
> +++ linux-2.6/arch/x86/include/asm/fixmap_64.h
> @@ -49,6 +49,8 @@ enum fixed_addresses {
>  #ifdef CONFIG_PARAVIRT
>  	FIX_PARAVIRT_BOOTMAP,
>  #endif
> +	FIX_TEXT_POKE0,	/* reserve 2 pages for text_poke() */
> +	FIX_TEXT_POKE1,
>  	__end_of_permanent_fixed_addresses,
>  #ifdef CONFIG_ACPI
>  	FIX_ACPI_BEGIN,
> Index: linux-2.6/arch/x86/kernel/alternative.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/alternative.c
> +++ linux-2.6/arch/x86/kernel/alternative.c
> @@ -12,7 +12,9 @@
>  #include <asm/nmi.h>
>  #include <asm/vsyscall.h>
>  #include <asm/cacheflush.h>
> +#include <asm/tlbflush.h>
>  #include <asm/io.h>
> +#include <asm/fixmap.h>
> 
>  #define MAX_PATCH_LEN (255-1)
> 
> @@ -495,12 +497,13 @@ void *text_poke_early(void *addr, const
>   * It means the size must be writable atomically and the address must be aligned
>   * in a way that permits an atomic write. It also makes sure we fit on a single
>   * page.
> + *
> + * Note: Must be called under text_mutex.
>   */
>  void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
>  {
>  	unsigned long flags;
>  	char *vaddr;
> -	int nr_pages = 2;
>  	struct page *pages[2];
>  	int i;
> 
> @@ -513,14 +516,17 @@ void *__kprobes text_poke(void *addr, co
>  		pages[1] = virt_to_page(addr + PAGE_SIZE);
>  	}
>  	BUG_ON(!pages[0]);
> -	if (!pages[1])
> -		nr_pages = 1;
> -	vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
> -	BUG_ON(!vaddr);
> +	set_fixmap(FIX_TEXT_POKE0, page_to_phys(pages[0]));
> +	if (pages[1])
> +		set_fixmap(FIX_TEXT_POKE1, page_to_phys(pages[1]));
> +	vaddr = (char *)fix_to_virt(FIX_TEXT_POKE0);
>  	local_irq_save(flags);
>  	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
>  	local_irq_restore(flags);
> -	vunmap(vaddr);
> +	clear_fixmap(FIX_TEXT_POKE0);
> +	if (pages[1])
> +		clear_fixmap(FIX_TEXT_POKE1);
> +	local_flush_tlb();
>  	sync_core();
>  	/* Could also do a CLFLUSH here to speed up CPU recovery; but
>  	   that causes hangs on some VIA CPUs. */
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
