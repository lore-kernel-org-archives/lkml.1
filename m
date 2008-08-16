Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbYHPVTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbYHPVTS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 17:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYHPVTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 17:19:05 -0400
Received: from saeurebad.de ([85.214.36.134]:33360 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbYHPVTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 17:19:04 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@osdl.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] De-macro spin_trylock_irq, spin_trylock_irqsave, write_trylock_irqsave
References: <20080816095951.GA19926@martell.zuzino.mipt.ru>
	<20080816134600.GC20652@elte.hu>
	<20080816210439.GB5151@martell.zuzino.mipt.ru>
Date: Sat, 16 Aug 2008 23:18:38 +0200
In-Reply-To: <20080816210439.GB5151@martell.zuzino.mipt.ru> (Alexey Dobriyan's
	message of "Sun, 17 Aug 2008 01:04:39 +0400")
Message-ID: <87pro8psk1.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Alexey Dobriyan <adobriyan@gmail.com> writes:

> On Sat, Aug 16, 2008 at 03:46:00PM +0200, Ingo Molnar wrote:
>> 
>> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> 
>> > 1) de-macro, remove ({ usages as side-effect,
>> > 2) change calling convention to not accept "flags" by value -- trylock
>> >    functions can modify them, so by-value is misleading, and number of users
>> >    is relatively low.
>> > 3) de-macro spin_trylock_irq() for a change.
>> 
>> > +++ b/kernel/sched.c
>> > @@ -1174,7 +1174,7 @@ static void resched_cpu(int cpu)
>> >  	struct rq *rq = cpu_rq(cpu);
>> >  	unsigned long flags;
>> >  
>> > -	if (!spin_trylock_irqsave(&rq->lock, flags))
>> > +	if (!spin_trylock_irqsave(&rq->lock, &flags))
>> >  		return;
>> 
>> hm, i dont really like this assymetric calling convention to other 
>> locking primitives that all take 'flags' as a value. 
>> [spin_lock_irqsave(), etc.]
>> 
>> so what's the point really? It sure does not make actual usage more 
>> readable.
>
> Only slightly, reader is hinted that flags can be changed, otherwise
> they will be passed by value.
>
>> If we switched _all_ primitives to use flags as a pointer, 
>> that might make sense, in theory.
>
> We can't really, and I don't propose that: ~8700 usages of
> spin_lock_irqsave, ~1300 usages of local_irq_save. However for code
> which has small number of users, why not?

I would also prefer to maintain symmetry here.  Your argument is moot,
why diverge a small part of one API just because it is not used much?

Everyone using the spin_lock functions learns the weird interface pretty
fast.  If you are in a rare situation where you have to use the trylock
versions, you would really expect them to be used equivalently.

It is weird but diverging it doesn't make it any better.

> The prehistory of this patch is that I'm deeply in spinlock and
> irqflags.h headers for clean irq_flags_t conversion and overall
> implession is that they're horrible.
>
> Just the joke with local_irq_enable() defined via raw_local_irq_enable()
> and several lines below in the opposite order.
>
> The patch is about slightly cleaner code close to C. ;-)
>
>> (but it would also be hugely invasive, 
>> with not much upside with tons of downside like years of migration 
>> fallout and having to rewrite hundreds of kernel hacking books ;-) )
>
> I want my money back for scheduler chapter from "Understanding the
> Linux Kernel"!

I agree that this argument of Ingo's is not a very good one... ;)

	Hannes
