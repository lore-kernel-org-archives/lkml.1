Return-Path: <linux-kernel-owner+w=401wt.eu-S1760868AbXEKPTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868AbXEKPTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 11:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbXEKPTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 11:19:17 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:61146 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbXEKPTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 11:19:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=bsIs4mt7cGYw+Xw2scbJFqdq7NxpomcmgbJHzAGBtv4eVQLdwT2KaSEV0zWkHJLi/6TOV5ZTIzg0jSSOzhg/GziK+APCLOHykIVQMwUmZnCGUVaPi3ojfb6HIPdyTAumaNXbiS7iNjP7gd4/4wriiJ//mCG762WJN4HQ/bgUHmY=
Message-ID: <46448965.7070500@gmail.com>
Date: Fri, 11 May 2007 17:19:01 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       David Howells <dhowells@redhat.com>, Gautham Shenoy <ego@in.ibm.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
References: <20070503204226.GA212@tv-sign.ru> <464475EB.3000408@gmail.com> <20070511134714.GA191@tv-sign.ru>
In-Reply-To: <20070511134714.GA191@tv-sign.ru>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
>> and this.  After grabbing cwq lock, compare it to get_wq_data() first,
>> if they are the same, both are using the same lock so there's no
>> reason for the barriers.  If they are different, it doesn't matter
>> anyway.  We need to retry the locking.
> 
> I think this is not right. The problem is that work->data (its
> WORK_STRUCT_WQ_DATA_MASK part, cwq) could be changed _without_ holding
> the old cwq->lock.
> 
> Suppose that CPU_0 does queue_delayed_work(dwork). We start the timer,
> work->data points to cwq_0. CPU_DEAD comes, the timer migrates to
> CPU_1, but work->data was not changed yet.
> 
>>   retry:
>> 	cwq = get_sw_data(work);
>> 	if (!cwq)
>> 		return ret;
>>
>> 	spin_lock_irq(&cwq->lock);
>> 	if (unlikely(cwq != get_wq_data(work))) {
>> 		/* oops wrong cwq */
>> 		spin_unlock_irq(&cwq->lock);
>> 		goto retry;	/* or just return 0; */
>> 	}
> 
> dwork->timer fires, delayed_work_timer_fn() changes work->data to cwq_1
> and queues this work on cwq_1.
> 
>> 	if (!list_empty(&work->entry)) {
>> 		list_del_init(&work->entry);
> 
> Oops! we are holding cwq_0->lock, but modify cwq_1->worklist.
> 
> Actually, we have the same problem with a plain queue_work() if _cpu_down()
> comes at "right" time.
>
> However, I agree, this smp_wmb() in insert_work() should die. We can
> introduce "smp_mb__before_spinlock()" (no-op on x86 at least) to kill it.

Yeah, right, we allow cwq pointer to change without holding the lock.
Although I still think that is where we should fix the problem.  Taking
down CPU is a cold cold path.  We can afford a lot of overhead there.
IMHO, if we can do that, it would be far better than memory barrier
dance which tends to be difficult to understand and thus prove/maintain
correctness.  I'll think about it more.

>>> + * It is possible to use this function if the work re-queues itself. It can
>>> + * cancel the work even if it migrates to another workqueue, however in that
>>> + * case it only garantees that work->func() has completed on the last queued
>>> + * workqueue.
>> We first prevent requeueing from happening; then, wait for each cwq to
>> finish the work, so I think we're guaranteed that they're finished on
>> all cpus.  Otherwise, the 'sync' part isn't too useful as it means all
>> rearming tasks might be running on completion of cancel_work_sync().
> 
> Yes, sure, you are right. What I meant was:
> 
> 	struct workqueue_struct *WQ1, *WQ1;
> 
> 	void work_func(struct work_struct *self)
> 	{
> 		// migrate on another workqueue
> 		queue_work(WQ2, self);
> 
> 		do_something();
> 	}
> 
> 	queue_work(WQ1, work);
> 
> Now, cancel_work_sync() can't guarantee that this work has finished
> its execution on WQ1.

Right again, I misunderstood that the migration was between cwqs.
Things definitely won't work if it's between different wqs.

Thanks.

-- 
tejun
