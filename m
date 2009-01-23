Return-Path: <linux-kernel-owner+w=401wt.eu-S1761413AbZAWKA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761413AbZAWKA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 05:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756179AbZAWKAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 05:00:14 -0500
Received: from cmpxchg.org ([85.214.51.133]:56870 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869AbZAWKAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 05:00:13 -0500
Date: Fri, 23 Jan 2009 10:59:04 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Matthew Wilcox <matthew@wil.cx>, Chuck Lever <cel@citi.umich.edu>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC v4] wait: prevent waiter starvation in __wait_on_bit_lock
Message-ID: <20090123095904.GA22890@cmpxchg.org>
References: <20090117215110.GA3300@redhat.com> <20090118013802.GA12214@cmpxchg.org> <20090118023211.GA14539@redhat.com> <20090120203131.GA20985@cmpxchg.org> <20090121143602.GA16584@redhat.com> <20090121213813.GB23270@cmpxchg.org> <20090122202550.GA5726@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122202550.GA5726@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 09:25:50PM +0100, Oleg Nesterov wrote:
> On 01/21, Johannes Weiner wrote:
> >
> > @@ -187,6 +187,31 @@ __wait_on_bit_lock(wait_queue_head_t *wq, struct wait_bit_queue *q,
> >  		}
> >  	} while (test_and_set_bit(q->key.bit_nr, q->key.flags));
> >  	finish_wait(wq, &q->wait);
> > +	if (unlikely(ret)) {
> > +		/*
> > +		 * Contenders are woken exclusively.  If we were woken
> > +		 * by an unlock we have to take the lock ourselves and
> > +		 * wake the next contender on unlock.  But the waiting
> > +		 * function failed, we do not take the lock and won't
> > +		 * unlock in the future.  Make sure the next contender
> > +		 * does not wait forever on an unlocked bit.
> > +		 *
> > +		 * We can also get here without being woken through
> > +		 * the waitqueue, so there is a small chance of doing a
> > +		 * bogus wake up between an unlock clearing the bit and
> > +		 * the next contender being woken up and setting it again.
> > +		 *
> > +		 * It does no harm, though, the scheduler will ignore it
> > +		 * as the process in question is already running.
> > +		 *
> > +		 * The unlock path clears the bit and then wakes up the
> > +		 * next contender.  If the next contender is us, the
> > +		 * barrier makes sure we also see the bit cleared.
> > +		 */
> > +		smp_rmb();
> > +		if (!test_bit(q->key.bit_nr, q->key.flags)))
> > +			__wake_up_bit(wq, q->key.flags, q->key.bit_nr);
> 
> I think this is correct, and (unfortunately ;) you are right:
> we need rmb() even after finish_wait().
> 
> And we have to check ret twice, and the false wakeup is still
> possible. This is minor, but just for discussion, can't we do
> this differently?
> 
> 	int finish_wait_xxx(wait_queue_head_t *q, wait_queue_t *wait)
> 	{
> 		unsigned long flags;
> 		int woken;
> 
> 		__set_current_state(TASK_RUNNING);
> 		spin_lock_irqsave(&q->lock, flags);
> 		woken = list_empty(&wait->task_list);
> 		list_del_init(&wait->task_list);
> 		spin_unlock_irqrestore(&q->lock, flags);
> 
> 		return woken;
> 	}

Hehe, there is only n solutions to this problem.  I had thought about
that too, even written it down.  But I was not sure if taking the
spinlock, toggling irqs and (re)storing the flags is better than an
untaken branch. ;)

> Now, __wait_on_bit_lock() does:
> 
> 		if (test_bit(q->key.bit_nr, q->key.flags)) {
> 			if ((ret = (*action)(q->key.flags))) {
> 				if (finish_wait_xxx(...))
> 					__wake_up_bit(...);
> 				return ret;
> 			}
> 		}

If you don't mind putting a second finish_wait() in there (you still
need the one after the loop, right?), we can fix up my version to not
check ret twice but do finish_wait() as you describe and then the
test_bit() && wake up:

	do {
		if (test_bit())
			if ((ret = action())) {
				finish_wait()
				smp_rmb()
				if (!test_bit())
					__wake_up_bit()
				return ret
			}
		}
	} while (test_and_set_bit())
	finish_wait()
	return 0

> Or we can introduce
> 
> 	int finish_wait_yyy(wait_queue_head_t *q, wait_queue_t *wait,
> 				int mode, void *key)
> 	{
> 		unsigned long flags;
> 		int woken;
> 
> 		__set_current_state(TASK_RUNNING);
> 		spin_lock_irqsave(&q->lock, flags);
> 		woken = list_empty(&wait->task_list);
> 		if (woken)
> 			__wake_up_common(q, mode, 1, key);
> 		else
> 			list_del_init(&wait->task_list);
> 		spin_unlock_irqrestore(&q->lock, flags);
> 
> 		return woken;
> 	}
> 
> Perhaps a bit too much for this particular case, but I am thinking
> about other cases when we need to abort the exclusive wait.
> 
> For example, don't we have the similar problems with
> wait_event_interruptible_exclusive() ?

Yeah, we do IIUC.  Then having finish_wait() extended is probably a
good idea.

> Oleg.

	Hannes
