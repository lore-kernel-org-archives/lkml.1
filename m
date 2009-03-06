Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbZCFSpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbZCFSpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756725AbZCFSpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:45:13 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:61997 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365AbZCFSpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:45:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah0FAIT9sElMQW1W/2dsb2JhbACBTtURhAgG
Date: Fri, 6 Mar 2009 13:45:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -tip 4/4] Atomic text_poke() with fixmap take2
Message-ID: <20090306184506.GA16067@Krystal>
References: <49B1428A.9050500@redhat.com> <49B14352.2040705@redhat.com> <20090306181356.GD14236@Krystal> <49B16C69.6060203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49B16C69.6060203@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:44:06 up 6 days, 15:10,  2 users,  load average: 1.89, 1.39,
	1.08
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Mathieu Desnoyers wrote:
> >> @@ -523,14 +526,17 @@ void *__kprobes text_poke(void *addr, co
> >>  		pages[1] = virt_to_page(addr + PAGE_SIZE);
> >>  	}
> >>  	BUG_ON(!pages[0]);
> >> -	if (!pages[1])
> >> -		nr_pages = 1;
> >> -	vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
> >> -	BUG_ON(!vaddr);
> >> -	local_irq_disable();
> >> +	set_fixmap(FIX_TEXT_POKE0, page_to_phys(pages[0]));
> > 
> > Can the set_fixmap/clear_fixmap/local_flush_tlb be called within
> > local_irq_save ? If yes, that would be better, especially for the SMP
> > alternatives code, which would rely on interrupt disabling in text_poke
> > for consistency (the mutex is not needed there).
> 
> Yes, that just changes pte.
> 
> ---
> Use fixmaps instead of vmap/vunmap in text_poke() for avoiding page allocation
> and delayed unmapping.
> 
> At the result of above change, text_poke() becomes atomic and can be called
> from stop_machine() etc.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/include/asm/fixmap.h |    2 ++
>  arch/x86/kernel/alternative.c |   24 +++++++++++++++---------
>  2 files changed, 17 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6-tip/arch/x86/kernel/alternative.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/x86/kernel/alternative.c
> +++ linux-2.6-tip/arch/x86/kernel/alternative.c
> @@ -13,7 +13,9 @@
>  #include <asm/nmi.h>
>  #include <asm/vsyscall.h>
>  #include <asm/cacheflush.h>
> +#include <asm/tlbflush.h>
>  #include <asm/io.h>
> +#include <asm/fixmap.h>
> 
>  #define MAX_PATCH_LEN (255-1)
> 
> @@ -505,15 +507,16 @@ void *text_poke_early(void *addr, const
>   * It means the size must be writable atomically and the address must be aligned
>   * in a way that permits an atomic write. It also makes sure we fit on a single
>   * page.
> + *
> + * Note: Must be called under text_mutex.

Maybe you could add "or in specific cases ensuring UP behavior".

The rest looks fine.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

>   */
>  void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
>  {
> +	unsigned long flags;
>  	char *vaddr;
> -	int nr_pages = 2;
>  	struct page *pages[2];
>  	int i;
> 
> -	might_sleep();
>  	if (!core_kernel_text((unsigned long)addr)) {
>  		pages[0] = vmalloc_to_page(addr);
>  		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
> @@ -523,14 +526,17 @@ void *__kprobes text_poke(void *addr, co
>  		pages[1] = virt_to_page(addr + PAGE_SIZE);
>  	}
>  	BUG_ON(!pages[0]);
> -	if (!pages[1])
> -		nr_pages = 1;
> -	vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
> -	BUG_ON(!vaddr);
> -	local_irq_disable();
> +	local_irq_save(flags);
> +	set_fixmap(FIX_TEXT_POKE0, page_to_phys(pages[0]));
> +	if (pages[1])
> +		set_fixmap(FIX_TEXT_POKE1, page_to_phys(pages[1]));
> +	vaddr = (char *)fix_to_virt(FIX_TEXT_POKE0);
>  	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
> -	local_irq_enable();
> -	vunmap(vaddr);
> +	clear_fixmap(FIX_TEXT_POKE0);
> +	if (pages[1])
> +		clear_fixmap(FIX_TEXT_POKE1);
> +	local_flush_tlb();
> +	local_irq_restore(flags);
>  	sync_core();
>  	/* Could also do a CLFLUSH here to speed up CPU recovery; but
>  	   that causes hangs on some VIA CPUs. */
> Index: linux-2.6-tip/arch/x86/include/asm/fixmap.h
> ===================================================================
> --- linux-2.6-tip.orig/arch/x86/include/asm/fixmap.h
> +++ linux-2.6-tip/arch/x86/include/asm/fixmap.h
> @@ -111,6 +111,8 @@ enum fixed_addresses {
>  #ifdef CONFIG_PARAVIRT
>  	FIX_PARAVIRT_BOOTMAP,
>  #endif
> +	FIX_TEXT_POKE0,	/* reserve 2 pages for text_poke() */
> +	FIX_TEXT_POKE1,
>  	__end_of_permanent_fixed_addresses,
>  #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
>  	FIX_OHCI1394_BASE,
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
