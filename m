Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbZCFTJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbZCFTJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZCFTJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:09:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34953 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbZCFTJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:09:04 -0500
Date: Fri, 6 Mar 2009 20:08:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
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
Subject: Re: [PATCH -tip 4/4] Atomic text_poke() with fixmap take2
Message-ID: <20090306190828.GA28582@elte.hu>
References: <49B1428A.9050500@redhat.com> <49B14352.2040705@redhat.com> <20090306181356.GD14236@Krystal> <49B16C69.6060203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B16C69.6060203@redhat.com>
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


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

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

I'm not sure at all about this widening of the irq-atomic 
section and the idea of allowing non-locked access on single-CPU 
situations - we dont really want to micro-optimize any of this 
on such a level, holding the text lock is a robust rule all code 
should be listening to. (Creating locking assymetry always 
inserts a certain amount of fragility - adding to an already 
fragile concept here.)

And note that there's no reason why text_poke could not be used 
in stop_machine_run() - the stop_machine_run() handler must not 
take the text_lock of course - but outside code calling 
stop_machine_run() can do it and can hence serialize properly.

Note that even if we did this then your v2 patch is not fully 
correct: you need to move the sync_core() at the end of the 
sequence inside the critical section too. (right now this is 
mostly harmless because the INVLPG inside the clear_fixmap() 
happens to be serializing so it has an implicit sync_core() 
property - but nevertheless we better do this straight away to 
not cause problems later down the line.)

	Ingo
