Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbZCFST7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbZCFST7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbZCFSTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:19:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48992 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282AbZCFSTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:19:49 -0500
Date: Fri, 6 Mar 2009 19:18:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -tip 4/4] Atomic text_poke() with fixmap
Message-ID: <20090306181857.GA26642@elte.hu>
References: <49B1428A.9050500@redhat.com> <49B14352.2040705@redhat.com> <20090306181356.GD14236@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306181356.GD14236@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
> > Use fixmaps instead of vmap/vunmap in text_poke() for avoiding page allocation
> > and delayed unmapping.
> > 
> > At the result of above change, text_poke() becomes atomic and can be called
> > from stop_machine() etc.
> > 
> > Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> > Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > ---
> >  arch/x86/include/asm/fixmap.h |    2 ++
> >  arch/x86/kernel/alternative.c |   24 +++++++++++++++---------
> >  2 files changed, 17 insertions(+), 9 deletions(-)
> > 
> > Index: linux-2.6-tip/arch/x86/kernel/alternative.c
> > ===================================================================
> > --- linux-2.6-tip.orig/arch/x86/kernel/alternative.c
> > +++ linux-2.6-tip/arch/x86/kernel/alternative.c
> > @@ -13,7 +13,9 @@
> >  #include <asm/nmi.h>
> >  #include <asm/vsyscall.h>
> >  #include <asm/cacheflush.h>
> > +#include <asm/tlbflush.h>
> >  #include <asm/io.h>
> > +#include <asm/fixmap.h>
> > 
> >  #define MAX_PATCH_LEN (255-1)
> > 
> > @@ -505,15 +507,16 @@ void *text_poke_early(void *addr, const
> >   * It means the size must be writable atomically and the address must be aligned
> >   * in a way that permits an atomic write. It also makes sure we fit on a single
> >   * page.
> > + *
> > + * Note: Must be called under text_mutex.
> >   */
> >  void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
> >  {
> > +	unsigned long flags;
> >  	char *vaddr;
> > -	int nr_pages = 2;
> >  	struct page *pages[2];
> >  	int i;
> > 
> > -	might_sleep();
> >  	if (!core_kernel_text((unsigned long)addr)) {
> >  		pages[0] = vmalloc_to_page(addr);
> >  		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
> > @@ -523,14 +526,17 @@ void *__kprobes text_poke(void *addr, co
> >  		pages[1] = virt_to_page(addr + PAGE_SIZE);
> >  	}
> >  	BUG_ON(!pages[0]);
> > -	if (!pages[1])
> > -		nr_pages = 1;
> > -	vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
> > -	BUG_ON(!vaddr);
> > -	local_irq_disable();
> > +	set_fixmap(FIX_TEXT_POKE0, page_to_phys(pages[0]));
> 
> Can the set_fixmap/clear_fixmap/local_flush_tlb be called 
> within local_irq_save ? If yes, that would be better, 
> especially for the SMP alternatives code, which would rely on 
> interrupt disabling in text_poke for consistency (the mutex is 
> not needed there).

yes, it is atomic.

	Ingo
