Return-Path: <linux-kernel-owner+w=401wt.eu-S1759814AbXEMUSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814AbXEMUSa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 16:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755763AbXEMUSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 16:18:23 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:61033 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbXEMUSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 16:18:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=QEd2nj8mCKrPI0kEgD6VZfbpR5l4IzLXSUFWt6v3SPSpNdFzXOIlCnA2w+bxWiMfoftH4fRhNR6YEtZYrbqUFqS5NZ7Qgfn6fGGP932FnOqzD/VZzMZjwooy/AFIBP48TycDCWHSRwkzuNr1LXcnkPU99o3+J8y8nHndjM6hdAg=
Message-ID: <46477239.9030007@gmail.com>
Date: Sun, 13 May 2007 22:16:57 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       David Howells <dhowells@redhat.com>, Gautham Shenoy <ego@in.ibm.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
References: <20070503204226.GA212@tv-sign.ru> <464475EB.3000408@gmail.com> <20070511134714.GA191@tv-sign.ru> <46448965.7070500@gmail.com> <20070511145345.GA240@tv-sign.ru> <4645559D.4050602@gmail.com> <20070513192753.GA3014@tv-sign.ru>
In-Reply-To: <20070513192753.GA3014@tv-sign.ru>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Oleg Nesterov wrote:
> On 05/12, Tejun Heo wrote:
>> Oleg Nesterov wrote:
>>> Yes I hate this barrier too. That is why changelog explicitly mentions it.
>>> Probably we can do something else.
>> Fortunately, we have one bit left in the flags and can use it to mark
>> pointer validity instead of list_empty() test.  flags and wq_data live
>> in the same atomic_long and thus can be updated together atomically.
> 
> Heh. I thought about another bit-in-pointer too. I can't explain this,
> but I personally hate these bits even more than barriers.

I'm the other way around but it's like saying "I like donkey poo better
than horse poo".  Let's accept that we have different tastes in poos.

> I must admit, your suggestion is much more clean compared to what I
> had in mind.

Gee... what did you have in mind?  Twisted one.  :-P

>> * insert_work() sets VALID bit and the cwq pointer using one
>> atomic_long_set().
> 
> OK, but not very suitable, we need to copy-and-paste set_wq_data(),
> because it is also used by queue_delayed_work(). Not a big problem.

Yeap, we'll need to either adjust set/get_wq_data() interface a bit or
open code it.  More on this later.

>> * queue_delayed_work_on() sets the cwq pointer but not the VALID bit.
> 
> ... and queue_delayed_work(), of course.

Yeap.

>> * run_workqueue() clears the cwq pointer and VALID bit while holding
>> lock before executing the work.
> 
> We should not clear cwq. I guess you meant "does list_del() and clears
> VALID bit".

Yeap, I've used the term 'clearing' as more of a logical term - making
the pointer invalid, but is there any reason why we can't clear the
pointer itself?

>> * try_to_grab_pending() checks VALID && pointers equal after grabbing
>> cwq->lock.
> 
> We don't even need to check the pointers. VALID bit is always changed
> under cwq->lock. So, if we see VALID under cwq->lock, we have a right
> pointer.

But there are multiple cwq->lock's.  VALID can be set with one of other
cwq->lock's locked.

>> What do you think?  Is there any hole?
> 
> I'd be happy to say I found many nasty unfixable holes in your idea,
> but I can't see any :) Something like the patch below, I guess.
> 
> Ugh. OK, the barrier is evil. As I said, we can convert smp_wmb() to
> smp_bm__before_spinlock() (which we don't currently have, but which we
> imho need regardless to workqueue.c), but anyway it is not easy to
> understand the code with barriers.

I didn't really get the smp_mb__before_spinlock() thing.  How are you
planning to use it?  spinlock() is already a read barrier.  What do you
gain by making it also a write barrier?

> OTOH, the new VALID bit is _only_ needed to implement a special cancel_xxx
> functions. And unlike wmb/smp_bm__before_spinlock it is not hidden in
> insert_work(), but spreads over the queue/unqueue path. And. the
> bit-in-pointer is always a hack, imho. And. It is a bit difficult to
> understand why do we need a VALID bit when we have !list_empty(), so
> _perhaps_ a barrier is not much worse.
> 
> I am looking at the patch below, and I can't undestand whether this is
> good change or not. I am biased, of course. Tejun, if you say "I strongly
> believe this is better", I'll send the patch.

We're deep into per-cpu synchronization neverland and one can only trust
one's own Alice.  I can't say my Alice is better than yours but I'll try
to present why I like mine.

I like the VALID bit thing because we can make it look and act similar
to the relatively regular per-cpu locked enter/leave model people can
understand without too much difficulty.  If we change get/set_wq() such
that they contain the VALID bit thing inside them, the code can be
explained as simple (really?) locked enter/leave model.  That's why I
mentioned clearing the cwq pointer while locked.  The closer we stay to
the known model, the easier to understand and explain.

Maybe the bit shouldn't be called VALID but IGNORE, CACHE_ONLY or
somesuch.  The only reason why we can't do real enter/leave model is the
cwq caching for delayed works, so it might make more sense to mark the
pointer as invalid while being used for caching rather than the other
way around.

Thanks for working on this neverland thing.  :-)

-- 
tejun
