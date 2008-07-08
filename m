Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbYGHF5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbYGHF5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 01:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbYGHF5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 01:57:15 -0400
Received: from gw.goop.org ([64.81.55.164]:46990 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbYGHF5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 01:57:14 -0400
Message-ID: <487301B0.8050801@goop.org>
Date: Mon, 07 Jul 2008 22:57:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Rik van Riel <riel@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>, Petr Tesarik <ptesarik@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin
 with irqs disable
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com> <20080707154651.35d1004c@cuia.bos.redhat.com> <4872792F.9080609@goop.org> <200807081207.34453.nickpiggin@yahoo.com.au>
In-Reply-To: <200807081207.34453.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Tuesday 08 July 2008 06:14, Jeremy Fitzhardinge wrote:
>
>   
>> The other point, of course, is that ticket locks are massive overkill
>> for the problem they're trying to solve.
>>     
>
> No they aren't.
>
>
>   
>> It's one thing to introduce an 
>> element of fairness into spinlocks, its another to impose strict FIFO
>> ordering.  It would be enough to make the locks "polite" by preventing a
>> new lock-holder from taking the lock while its under contention.
>> Something like:
>>
>> 	union lock {
>> 		unsigned short word;
>> 		struct { unsigned char lock, count; };
>> 	};
>>
>> spin_lock:		# ebx - lock pointer
>> 	movw	$0x0001, %ax	# add 1 to lock, 0 to count
>> 	xaddw	%ax, (%ebx)	# attempt to take lock and test user count
>> 	testw	%ax,%ax
>> 	jnz	slow
>>
>> taken:	ret
>>
>> # slow path
>> slow:	lock incb 1(%ebx)	# inc count
>>
>> 1:	rep;nop
>> 	cmpb	$0,(%ebx)
>> 	jnz	1b		# wait for unlocked
>>
>> 	movb	$1,%al		# attempt to take lock (count already increased)
>> 	xchgb	%al,(%ebx)
>> 	testb	%al,%al
>> 	jnz	1b
>>
>> 	lock decb 1(%ebx)	# drop count
>> 	jmp	taken
>>
>> spin_unlock:
>> 	movb	$0,(%ebx)
>> 	ret
>>
>>
>> The uncontended fastpath is similar to the pre-ticket locks, but it
>> refuses to take the lock if there are other waiters, even if the lock is
>> not currently held.  This prevents the rapid lock-unlock cycle on one
>> CPU from starving another CPU, which I understand was the original
>> problem tickets locks were trying to solve.
>>     
>
> They prevent lots of unfairness and starvation problems. The most
> prominent one (ie. actually observed in Linux) was a single CPU
> being totally starved by N others (to the point where lockup timers
> would kick in).
>   

Yep.  My understanding was that the specific case was that cpu A was 
repeatedly taking and releasing the lock, while other cpus spin waiting 
for it, and that the cache coherence logic kept the cacheline owned by A 
(presumably because it kept modifying it).  Ticket locks work well in 
this case because, as you say, it enforces a fairness policy that the 
hardware doesn't implement.  Are there other cases that ticket locks 
help with?  Does the algorithm above solve the starvation issue?

> As an aside, these locks you propose are also a lot more costly in
> the contended path. 4 vs 1 atomic operations on the lock cacheline
> is not so great.
>   

Yep, that's not great.  But it doesn't bounce cache lines around as much 
either, so perhaps it doesn't make much difference.

But really, I was being my own devil's advocate, to see if there's some 
other lock algorithm which satisfies both the normal ticket-lock case 
and the virtualization case.

I have no real objections to ticket locks, so long as I can turn them off ;)

    J
