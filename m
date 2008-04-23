Return-Path: <linux-kernel-owner+w=401wt.eu-S1757037AbYDWMzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbYDWMzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 08:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYDWMyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 08:54:53 -0400
Received: from brick.kernel.dk ([87.55.233.238]:20906 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731AbYDWMyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 08:54:51 -0400
Date: Wed, 23 Apr 2008 14:54:46 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       npiggin@suse.de, peterz@infradead.org, sam@ravnborg.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/11] x86: convert to generic helpers for IPI function  calls
Message-ID: <20080423125445.GN12774@kernel.dk>
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com> <1208890227-24808-3-git-send-email-jens.axboe@oracle.com> <alpine.LFD.1.10.0804221157220.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804221157220.2779@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22 2008, Linus Torvalds wrote:
> 
> [ Ingo added to cc, since this is x86-specific ]
> 
> On Tue, 22 Apr 2008, Jens Axboe wrote:
> > +++ b/arch/x86/kernel/apic_32.c
> > @@ -1357,6 +1357,10 @@ void __init smp_intr_init(void)
> >  
> >  	/* IPI for generic function call */
> >  	set_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
> > +
> > +	/* IPI for single call function */
> > +	set_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
> > +				call_function_single_interrupt);
> 
> Ok, one more comment..
> 
> Why bother with separate vectors for this?
> 
> Why not just make the single vector do
> 
> 	void smp_call_function_interrupt(void)
> 	{
> 		ack_APIC_irq();
> 		irq_enter();
> 		generic_smp_call_function_single_interrupt();
> 		generic_smp_call_function_interrupt();
> 	#ifdef CONFIG_X86_32
> 		__get_cpu_var(irq_stat).irq_call_count++;
> 	#else
> 		add_pda(irq_call_count, 1);
> 	#endif
> 		irq_exit();
> 	}
> 
> since they are both doing the exact same thing anyway?
> 
> Do we really require us to be able to handle the "single" case _while_ a 
> "multiple" case is busy? Aren't we running all of these things with 
> interrupts disabled anyway, so that it cannot happen?
> 
> Or is it just a performance optimization?  Do we expect to really have so 
> many of the multiple interrupts that it's expensive to walk the list just 
> because we also had a single interrupt to another CPU? That sounds a bit 
> unlikely, but if true, very interesting..
> 
> Inquiring minds want to know..

Regarding that last comment... The reason why I'm doing this work is
because I want to use smp_call_function_single() to redirect IO
completions. So there WILL be lots of
smp_call_function_single_interrupt() interrupts, they will be a lot more
prevalent than smp_call_function() interrupts. I don't have any numbers
on this since I haven't tried collapsing them all, but I'd be surprised
if it wasn't noticable.

That said, some archs do use a single IPI for multiple actions and just
keep a bitmask of what to do in that IPI. So it would still be possible
to use a single hardware IPI to do various things, without resorting to
calling into the interrupt handler for each of them. The _single()
interrupt handler is a cheap check though, an smp memory barrier and a
list_empty() check is enough (like it currently does).

-- 
Jens Axboe

