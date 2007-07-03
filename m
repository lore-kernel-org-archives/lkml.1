Return-Path: <linux-kernel-owner+w=401wt.eu-S1761330AbXGCRbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761330AbXGCRbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 13:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758388AbXGCRbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 13:31:13 -0400
Received: from mail.screens.ru ([213.234.233.54]:34315 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758020AbXGCRbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 13:31:12 -0400
Date: Tue, 3 Jul 2007 21:31:12 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
       Thomas Sattler <tsattler@gmx.de>
Subject: Re: [RFC/PATCH] debug workqueue deadlocks with lockdep
Message-ID: <20070703173112.GA108@tv-sign.ru>
References: <1182969638.4769.56.camel@johannes.berg> <1183048429.4089.1.camel@johannes.berg> <1183052001.4089.2.camel@johannes.berg> <1183190728.7932.43.camel@earth4> <20070630114658.GA344@tv-sign.ru> <1183381393.4089.117.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183381393.4089.117.camel@johannes.berg>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02, Johannes Berg wrote:
>
> On Sat, 2007-06-30 at 15:46 +0400, Oleg Nesterov wrote:
>
> > Johannes, could you change wait_on_work() as well? Most users of
> > flush_workqueue() should be converted to use it.

(to avoid a possible confusion: I meant, most users of flush_workqueue()
 should be converted to use cancel_work_sync/cancel_delayed_work_sync
 which in turn use wait_on_work()).

> I think this could lead to false positives, but then I think we
> shouldn't care about those. Let me explain. The thing is that with this
> it can happen that the code using the workqueue somehow obeys an
> ordering in the work it queues, so as far as I can tell it'd be fine to
> have two work items A and B where only B takes a lock L1, and then have
> a wait_on_work(A) under L1, if and only if B was always queued right
> after A (or something like that).

Not sure I understand. Yes, we can have false positives, but I think the
ordering in the workqueue doesn't matter.

If A does NOT take a lock L1, then it is OK to do cancel_work_sync(A)
under L1, regardless of which other work_structs this workqueue has,
before or after A.

Now we have a false positive if some time we queue B into that workqueue,
and this is not good.

We can avoid this problem if we put lockdep_map into work_struct, so
that wait_on_work() "locks" work->lockdep_map, while flush_workqueue()
takes wq->lockdep_map.

But probably we don't need this right now, at least until we really
have a lot of false positives while converting from flush_workqueue()
to cancel_work_sync/cancel_delayed_work_sync.

> However, since this invariant is
> rather likely to be broken by subsequent changes to the code, I think
> such code should probably use two workqueues instead, and I doubt it
> ever happens anyway since then people could in most cases just put both
> works into one function.

Well, I am not sure, think about the shared workqueues like keventd_wq...

> Hence I included it in my patch below.

a couple of minor nits below,

> @@ -257,7 +260,9 @@ static void run_workqueue(struct cpu_wor
>
>  		BUG_ON(get_wq_data(work) != cwq);
>  		work_clear_pending(work);
> +		lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
>  		f(work);
> +		lock_release(&cwq->wq->lockdep_map, 0, _THIS_IP_);
                                                   ^^^
Isn't it better to call lock_release() with nested == 1 ?

> +#define create_workqueue(name) \
> +({								\
> +	static struct lock_class_key __key;			\
> +	struct workqueue_struct *__wq;				\
> +								\
> +	__wq = __create_workqueue((name), 0, 0, &__key);	\
> +	__wq;							\
> +})

Why do we need __wq ?

	+#define create_workqueue(name) \
	({							\
		static struct lock_class_key __key;		\
		__create_workqueue((name), 0, 0, &__key);	\
	})

Actually, I'd suggest to rename __create_workqueue() to __create_workqueue_key(),
and then you need the only change in linux/workqueue.h

	- extern struct workqueue_struct *__create_workqueue(...);
	+ extern struct workqueue_struct *__create_workqueue_key(..., key);
	+ #define __create_workqueue(...)	\
	+	static struct lock_class_key __key;	\
	+	__create_workqueue_key(..., key);	\

but this is a matter of taste.

Btw, I think your patch found a real bug in net/mac80211/, cool!

Oleg.

