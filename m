Return-Path: <linux-kernel-owner+w=401wt.eu-S1760540AbXEMT22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760540AbXEMT22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 15:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757488AbXEMT2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 15:28:22 -0400
Received: from mail.screens.ru ([213.234.233.54]:39228 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755059AbXEMT2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 15:28:21 -0400
Date: Sun, 13 May 2007 23:27:53 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Tejun Heo <htejun@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       David Howells <dhowells@redhat.com>, Gautham Shenoy <ego@in.ibm.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
Message-ID: <20070513192753.GA3014@tv-sign.ru>
References: <20070503204226.GA212@tv-sign.ru> <464475EB.3000408@gmail.com> <20070511134714.GA191@tv-sign.ru> <46448965.7070500@gmail.com> <20070511145345.GA240@tv-sign.ru> <4645559D.4050602@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4645559D.4050602@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12, Tejun Heo wrote:
>
> Oleg Nesterov wrote:
> >
> > Yes I hate this barrier too. That is why changelog explicitly mentions it.
> > Probably we can do something else.
>
> Fortunately, we have one bit left in the flags and can use it to mark
> pointer validity instead of list_empty() test.  flags and wq_data live
> in the same atomic_long and thus can be updated together atomically.

Heh. I thought about another bit-in-pointer too. I can't explain this,
but I personally hate these bits even more than barriers.

I must admit, your suggestion is much more clean compared to what I
had in mind.

> * insert_work() sets VALID bit and the cwq pointer using one
> atomic_long_set().

OK, but not very suitable, we need to copy-and-paste set_wq_data(),
because it is also used by queue_delayed_work(). Not a big problem.

> * queue_delayed_work_on() sets the cwq pointer but not the VALID bit.

... and queue_delayed_work(), of course.

> * run_workqueue() clears the cwq pointer and VALID bit while holding
> lock before executing the work.

We should not clear cwq. I guess you meant "does list_del() and clears
VALID bit".

> * try_to_grab_pending() checks VALID && pointers equal after grabbing
> cwq->lock.

We don't even need to check the pointers. VALID bit is always changed
under cwq->lock. So, if we see VALID under cwq->lock, we have a right
pointer.

> What do you think?  Is there any hole?

I'd be happy to say I found many nasty unfixable holes in your idea,
but I can't see any :) Something like the patch below, I guess.

Ugh. OK, the barrier is evil. As I said, we can convert smp_wmb() to
smp_bm__before_spinlock() (which we don't currently have, but which we
imho need regardless to workqueue.c), but anyway it is not easy to
understand the code with barriers.

OTOH, the new VALID bit is _only_ needed to implement a special cancel_xxx
functions. And unlike wmb/smp_bm__before_spinlock it is not hidden in
insert_work(), but spreads over the queue/unqueue path. And. the
bit-in-pointer is always a hack, imho. And. It is a bit difficult to
understand why do we need a VALID bit when we have !list_empty(), so
_perhaps_ a barrier is not much worse.

I am looking at the patch below, and I can't undestand whether this is
good change or not. I am biased, of course. Tejun, if you say "I strongly
believe this is better", I'll send the patch.

Anybody else has an opinion?

Oleg.

--- t/kernel/workqueue.c~	2007-05-13 22:32:45.000000000 +0400
+++ t/kernel/workqueue.c	2007-05-13 22:37:42.000000000 +0400
@@ -120,11 +120,7 @@ static void insert_work(struct cpu_workq
 				struct work_struct *work, int tail)
 {
 	set_wq_data(work, cwq);
-	/*
-	 * Ensure that we get the right work->data if we see the
-	 * result of list_add() below, see try_to_grab_pending().
-	 */
-	smp_wmb();
+	__set_bit(WORK_STRUCT_QUEUED, work_data_bits(work));
 	if (tail)
 		list_add_tail(&work->entry, &cwq->worklist);
 	else
@@ -231,6 +227,12 @@ int queue_delayed_work_on(int cpu, struc
 }
 EXPORT_SYMBOL_GPL(queue_delayed_work_on);
 
+static inline void dequeue_work(struct work_struct *work)
+{
+	__clear_bit(WORK_STRUCT_QUEUED, work_data_bits(work));
+	list_del_init(&work->entry);
+}
+
 static void run_workqueue(struct cpu_workqueue_struct *cwq)
 {
 	spin_lock_irq(&cwq->lock);
@@ -246,8 +248,8 @@ static void run_workqueue(struct cpu_wor
 						struct work_struct, entry);
 		work_func_t f = work->func;
 
+		dequeue_work(work);
 		cwq->current_work = work;
-		list_del_init(cwq->worklist.next);
 		spin_unlock_irq(&cwq->lock);
 
 		BUG_ON(get_wq_data(work) != cwq);
@@ -410,17 +412,9 @@ static int try_to_grab_pending(struct wo
 		return ret;
 
 	spin_lock_irq(&cwq->lock);
-	if (!list_empty(&work->entry)) {
-		/*
-		 * This work is queued, but perhaps we locked the wrong cwq.
-		 * In that case we must see the new value after rmb(), see
-		 * insert_work()->wmb().
-		 */
-		smp_rmb();
-		if (cwq == get_wq_data(work)) {
-			list_del_init(&work->entry);
-			ret = 1;
-		}
+	if (test_bit(WORK_STRUCT_QUEUED, work_data_bits(work))) {
+		dequeue_work(work);
+		ret = 1;
 	}
 	spin_unlock_irq(&cwq->lock);
 

