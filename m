Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbZAVUbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbZAVUbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 15:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbZAVUbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 15:31:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48358 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbZAVUa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 15:30:59 -0500
Date: Thu, 22 Jan 2009 21:25:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Matthew Wilcox <matthew@wil.cx>, Chuck Lever <cel@citi.umich.edu>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC v4] wait: prevent waiter starvation in __wait_on_bit_lock
Message-ID: <20090122202550.GA5726@redhat.com>
References: <20090117215110.GA3300@redhat.com> <20090118013802.GA12214@cmpxchg.org> <20090118023211.GA14539@redhat.com> <20090120203131.GA20985@cmpxchg.org> <20090121143602.GA16584@redhat.com> <20090121213813.GB23270@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090121213813.GB23270@cmpxchg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21, Johannes Weiner wrote:
>
> @@ -187,6 +187,31 @@ __wait_on_bit_lock(wait_queue_head_t *wq, struct wait_bit_queue *q,
>  		}
>  	} while (test_and_set_bit(q->key.bit_nr, q->key.flags));
>  	finish_wait(wq, &q->wait);
> +	if (unlikely(ret)) {
> +		/*
> +		 * Contenders are woken exclusively.  If we were woken
> +		 * by an unlock we have to take the lock ourselves and
> +		 * wake the next contender on unlock.  But the waiting
> +		 * function failed, we do not take the lock and won't
> +		 * unlock in the future.  Make sure the next contender
> +		 * does not wait forever on an unlocked bit.
> +		 *
> +		 * We can also get here without being woken through
> +		 * the waitqueue, so there is a small chance of doing a
> +		 * bogus wake up between an unlock clearing the bit and
> +		 * the next contender being woken up and setting it again.
> +		 *
> +		 * It does no harm, though, the scheduler will ignore it
> +		 * as the process in question is already running.
> +		 *
> +		 * The unlock path clears the bit and then wakes up the
> +		 * next contender.  If the next contender is us, the
> +		 * barrier makes sure we also see the bit cleared.
> +		 */
> +		smp_rmb();
> +		if (!test_bit(q->key.bit_nr, q->key.flags)))
> +			__wake_up_bit(wq, q->key.flags, q->key.bit_nr);

I think this is correct, and (unfortunately ;) you are right:
we need rmb() even after finish_wait().

And we have to check ret twice, and the false wakeup is still
possible. This is minor, but just for discussion, can't we do
this differently?

	int finish_wait_xxx(wait_queue_head_t *q, wait_queue_t *wait)
	{
		unsigned long flags;
		int woken;

		__set_current_state(TASK_RUNNING);
		spin_lock_irqsave(&q->lock, flags);
		woken = list_empty(&wait->task_list);
		list_del_init(&wait->task_list);
		spin_unlock_irqrestore(&q->lock, flags);

		return woken;
	}

Now, __wait_on_bit_lock() does:

		if (test_bit(q->key.bit_nr, q->key.flags)) {
			if ((ret = (*action)(q->key.flags))) {
				if (finish_wait_xxx(...))
					__wake_up_bit(...);
				return ret;
			}
		}

Or we can introduce

	int finish_wait_yyy(wait_queue_head_t *q, wait_queue_t *wait,
				int mode, void *key)
	{
		unsigned long flags;
		int woken;

		__set_current_state(TASK_RUNNING);
		spin_lock_irqsave(&q->lock, flags);
		woken = list_empty(&wait->task_list);
		if (woken)
			__wake_up_common(q, mode, 1, key);
		else
			list_del_init(&wait->task_list);
		spin_unlock_irqrestore(&q->lock, flags);

		return woken;
	}

Perhaps a bit too much for this particular case, but I am thinking
about other cases when we need to abort the exclusive wait.

For example, don't we have the similar problems with
wait_event_interruptible_exclusive() ?

Oleg.

