Return-Path: <linux-kernel-owner+w=401wt.eu-S1757853AbXENTpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853AbXENTpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbXENTpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:45:16 -0400
Received: from mail.screens.ru ([213.234.233.54]:46352 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682AbXENTpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:45:14 -0400
Date: Mon, 14 May 2007 23:44:46 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Tejun Heo <htejun@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       David Howells <dhowells@redhat.com>, Gautham Shenoy <ego@in.ibm.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
Message-ID: <20070514194446.GA159@tv-sign.ru>
References: <20070503204226.GA212@tv-sign.ru> <464475EB.3000408@gmail.com> <20070511134714.GA191@tv-sign.ru> <46448965.7070500@gmail.com> <20070511145345.GA240@tv-sign.ru> <4645559D.4050602@gmail.com> <20070513192753.GA3014@tv-sign.ru> <46477239.9030007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46477239.9030007@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13, Tejun Heo wrote:
> 
> Oleg Nesterov wrote:
> > Heh. I thought about another bit-in-pointer too. I can't explain this,
> > but I personally hate these bits even more than barriers.
> 
> I'm the other way around but it's like saying "I like donkey poo better
> than horse poo".  Let's accept that we have different tastes in poos.

Yes sure :)

> >> * run_workqueue() clears the cwq pointer and VALID bit while holding
> >> lock before executing the work.
> > 
> > We should not clear cwq. I guess you meant "does list_del() and clears
> > VALID bit".
> 
> Yeap, I've used the term 'clearing' as more of a logical term - making
> the pointer invalid, but is there any reason why we can't clear the
> pointer itself?

Because this breaks cancel_work_sync(work), it needs get_wq_data(work) for
wait_on_work(work).

> >> * try_to_grab_pending() checks VALID && pointers equal after grabbing
> >> cwq->lock.
> > 
> > We don't even need to check the pointers. VALID bit is always changed
> > under cwq->lock. So, if we see VALID under cwq->lock, we have a right
> > pointer.
> 
> But there are multiple cwq->lock's.  VALID can be set with one of other
> cwq->lock's locked.

Yes, you are right, thanks.

So, try_to_grab_pending() should check "VALID && pointers equal" atomically.
We can't do "if (VALID && cwq == get_wq_data(work))". We should do something
like this

	(((long)cwq) | VALID | PENDING) == atomic_long_read(&work->data)

Yes? I need to think more about this.

> I didn't really get the smp_mb__before_spinlock() thing.  How are you
> planning to use it?  spinlock() is already a read barrier.  What do you
> gain by making it also a write barrier?

As I said, we can shift set_wq_data() from insert_work() to __queue_work(),

	static void insert_work(struct cpu_workqueue_struct *cwq,
					struct work_struct *work, int tail)
	{
		if (tail)
			list_add_tail(&work->entry, &cwq->worklist);
		else
			list_add(&work->entry, &cwq->worklist);
		wake_up(&cwq->more_work);
	}

	static void __queue_work(struct cpu_workqueue_struct *cwq,
				 struct work_struct *work)
	{
		unsigned long flags;

		set_wq_data(work, cwq);

		smp_mb_before_spinlock();
		spin_lock_irqsave(&cwq->lock, flags);
		insert_work(cwq, work, 1);
		spin_unlock_irqrestore(&cwq->lock, flags);
	}

this needs very minor changes.

BTW, in _theory_, spinlock() is not a read barrier, yes?
>From Documentation/memory-barriers.txt

     Memory operations that occur before a LOCK operation may appear to happen
     after it completes.

Oleg.

