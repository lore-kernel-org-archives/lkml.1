Return-Path: <linux-kernel-owner+w=401wt.eu-S1759577AbZAWNdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577AbZAWNdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 08:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbZAWNd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 08:33:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40969 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898AbZAWNd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 08:33:28 -0500
Date: Fri, 23 Jan 2009 14:30:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Matthew Wilcox <matthew@wil.cx>, Chuck Lever <cel@citi.umich.edu>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC v4] wait: prevent waiter starvation in __wait_on_bit_lock
Message-ID: <20090123133050.GA19226@redhat.com>
References: <20090117215110.GA3300@redhat.com> <20090118013802.GA12214@cmpxchg.org> <20090118023211.GA14539@redhat.com> <20090120203131.GA20985@cmpxchg.org> <20090121143602.GA16584@redhat.com> <20090121213813.GB23270@cmpxchg.org> <20090122202550.GA5726@redhat.com> <20090123095904.GA22890@cmpxchg.org> <20090123113541.GB12684@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090123113541.GB12684@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23, Oleg Nesterov wrote:
>
> It is no that I think this new helper is really needed for this
> particular case, personally I agree with the patch you sent.
>
> But if we have other places with the similar problem, then perhaps
> it is better to introduce the special finish_wait_exclusive() or
> whatever.

To clarify, I suggest something like this.

	int finish_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait,
					int ret, int state, void *key)
	{
		unsigned long flags;

		__set_current_state(TASK_RUNNING);

		if (ret || !list_empty_careful(&wait->task_list)) {
			spin_lock_irqsave(&q->lock, flags);
			if (list_empty(&wait->task_list))
				 __wake_up_common(q, state, 1, key);
			else
				list_del_init(&wait->task_list);
			spin_unlock_irqrestore(&q->lock, flags);
		}

		return ret;
	}

Now, __wait_on_bit_lock() becomes:

	int __sched
	__wait_on_bit_lock(wait_queue_head_t *wq, struct wait_bit_queue *q,
				int (*action)(void *), unsigned mode)
	{
		int ret = 0;

		do {
			prepare_to_wait_exclusive(wq, &q->wait, mode);
			if (test_bit(q->key.bit_nr, q->key.flags) &&
			   (ret = (*action)(q->key.flags))
				break;
		} while (test_and_set_bit(q->key.bit_nr, q->key.flags));

		return finish_wait_exclusive(wq, &q->wait, ret, mode, &q->key);
	}

And __wait_event_interruptible_exclusive:

	#define __wait_event_interruptible_exclusive(wq, condition, ret)	\
	do {									\
		DEFINE_WAIT(__wait);						\
										\
		for (;;) {							\
			prepare_to_wait_exclusive(&wq, &__wait,			\
						TASK_INTERRUPTIBLE);		\
			if (condition)						\
				break;						\
			if (!signal_pending(current)) {				\
				schedule();					\
				continue;					\
			}							\
			ret = -ERESTARTSYS;					\
			break;							\
		}								\
		finish_wait_exclusive(&wq, &__wait,				\
					ret, TASK_INTERRUPTIBLE, NULL);		\
	} while (0)

But I can't convince myself this is what we really want. So I am not
sending the patch. And yes, we have to check ret twice.

Oleg.

