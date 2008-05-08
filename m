Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbYEHMCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbYEHMCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 08:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbYEHMBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 08:01:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44540 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbYEHMBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 08:01:52 -0400
Date: Thu, 8 May 2008 14:01:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch] speed up / fix the new generic semaphore code (fix AIM7
	40% regression with 2.6.26-rc1)
Message-ID: <20080508120130.GA2860@elte.hu>
References: <1210131712.3453.43.camel@ymzhang> <87lk2mbcqp.fsf@basil.nowhere.org> <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org> <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org> <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > > That said, "idle 0%" is easy when you spin. Do you also have 
> > > actual performance numbers?
> >
> > Yes. My conclusion is based on the actual number. cpu idle 0% is 
> > just a behavior it should be.
> 
> Thanks, that's all I wanted to verify.
> 
> I'll leave this overnight, and see if somebody has come up with some 
> smart and wonderful patch. And if not, I think I'll apply mine as 
> "known to fix a regression", and we can perhaps then improve on things 
> further from there.

hey, i happen to have such a smart and wonderful patch =B-)

i reproduced the AIM7 workload and can confirm Yanmin's findings that 
-.26-rc1 regresses over .25 - by over 67% here.

Looking at the workload i found and fixed what i believe to be the real 
bug causing the AIM7 regression: it was inefficient wakeup / scheduling 
/ locking behavior of the new generic semaphore code, causing suboptimal 
performance.

The problem comes from the following code. The new semaphore code does 
this on down():

        spin_lock_irqsave(&sem->lock, flags);
        if (likely(sem->count > 0))
                sem->count--;
        else
                __down(sem);
        spin_unlock_irqrestore(&sem->lock, flags);

and this on up():

        spin_lock_irqsave(&sem->lock, flags);
        if (likely(list_empty(&sem->wait_list)))
                sem->count++;
        else
                __up(sem);
        spin_unlock_irqrestore(&sem->lock, flags);

where __up() does:

        list_del(&waiter->list);
        waiter->up = 1;
        wake_up_process(waiter->task);

and where __down() does this in essence:

        list_add_tail(&waiter.list, &sem->wait_list);
        waiter.task = task;
        waiter.up = 0;
        for (;;) {
                [...]
                spin_unlock_irq(&sem->lock);
                timeout = schedule_timeout(timeout);
                spin_lock_irq(&sem->lock);
                if (waiter.up)
                        return 0;
        }

the fastpath looks good and obvious, but note the following property of 
the contended path: if there's a task on the ->wait_list, the up() of 
the current owner will "pass over" ownership to that waiting task, in a 
wake-one manner, via the waiter->up flag and by removing the waiter from 
the wait list.

That is all and fine in principle, but as implemented in 
kernel/semaphore.c it also creates a nasty, hidden source of contention!

The contention comes from the following property of the new semaphore 
code: the new owner owns the semaphore exclusively, even if it is not 
running yet.

So if the old owner, even if just a few instructions later, does a 
down() [lock_kernel()] again, it will be blocked and will have to wait 
on the new owner to eventually be scheduled (possibly on another CPU)! 
Or if another other task gets to lock_kernel() sooner than the "new 
owner" scheduled, it will be blocked unnecessarily and for a very long 
time when there are 2000 tasks running.

I.e. the implementation of the new semaphores code does wake-one and 
lock ownership in a very restrictive way - it does not allow 
opportunistic re-locking of the lock at all and keeps the scheduler from 
picking task order intelligently.

This kind of scheduling, with 2000 AIM7 processes running, creates awful 
cross-scheduling between those 2000 tasks, causes reduced parallelism, a 
throttled runqueue length and a lot of idle time. With increasing number 
of CPUs it causes an exponentially worse behavior in AIM7, as the chance 
for a newly woken new-owner task to actually run anytime soon is less 
and less likely.

Note that it takes just a tiny bit of contention for the 'new-semaphore 
catastrophy' to happen: the wakeup latencies get added to whatever small 
contention there is, and quickly snowball out of control!

I believe Yanmin's findings and numbers support this analysis too.

The best fix for this problem is to use the same scheduling logic that 
the kernel/mutex.c code uses: keep the wake-one behavior (that is OK and 
wanted because we do not want to over-schedule), but also allow 
opportunistic locking of the lock even if a wakee is already "in 
flight".

The patch below implements this new logic. With this patch applied the 
AIM7 regression is largely fixed on my quad testbox:

  # v2.6.25 vanilla:
  ..................
  Tasks   Jobs/Min        JTI     Real    CPU     Jobs/sec/task
  2000    56096.4         91      207.5   789.7   0.4675
  2000    55894.4         94      208.2   792.7   0.4658

  # v2.6.26-rc1-166-gc0a1811 vanilla:
  ...................................
  Tasks   Jobs/Min        JTI     Real    CPU     Jobs/sec/task
  2000    33230.6         83      350.3   784.5   0.2769
  2000    31778.1         86      366.3   783.6   0.2648

  # v2.6.26-rc1-166-gc0a1811 + semaphore-speedup:
  ...............................................
  Tasks   Jobs/Min        JTI     Real    CPU     Jobs/sec/task
  2000    55707.1         92      209.0   795.6   0.4642
  2000    55704.4         96      209.0   796.0   0.4642

i.e. a 67% speedup. We are now back to within 1% of the v2.6.25 
performance levels and have zero idle time during the test, as expected.

Btw., interactivity also improved dramatically with the fix - for 
example console-switching became almost instantaneous during this 
workload (which after all is running 2000 tasks at once!), without the 
patch it was stuck for a minute at times.

I also ran Linus's spinlock-BKL patch as well:

  # v2.6.26-rc1-166-gc0a1811 + Linus-BKL-spinlock-patch:
  ......................................................
  Tasks   Jobs/Min        JTI     Real    CPU     Jobs/sec/task
  2000    55889.0         92      208.3   793.3   0.4657
  2000    55891.7         96      208.3   793.3   0.4658

it is about 0.3% faster - but note that that is within the general noise 
levels of this test. I'd expect Linus's spinlock-BKL patch to give some 
small speedup because the BKL acquire times are short and 2000 tasks 
running all at once really increases the context-switching cost and most 
BKL contentions are within the cost of context-switching.

But i believe the better solution for that is to remove BKL use from all 
hotpaths, not to hide some of its costs by reintroducing it as a 
spinlock. Reintroducing the spinlock based BKL would have other 
disadvantages as well: it could reintroduce per-CPU-ness assumptions in 
BKL-using code and other complications as well. It's also not a very 
realistic workload - with 2000 tasks running the system was barely 
serviceable.

I'd much rather make BKL costs more apparent and more visible - but 50% 
regression was of course too much. But 0.3% for a 2000-tasks workload, 
which is near the noise level ... is acceptable i think - especially as 
this discussion has now reinvigorated the remove-the-BKL discussions and 
patches.

Linus, we can do your spinlock-BKL patch too if you feel strongly about 
it, but i'd rather not - we fought so hard for the preemptible BKL :-)

The spinlock-based-BKL patch only worked around the real problem i 
believe, because it eliminated the use of the suboptimal new semaphore 
code: with spinlocks there's no scheduling at all, so the wakeup/locking 
bug of the new semaphore code did not apply. It was not about any 
fastpath overhead AFAICS. [we'd have seen that with the 
CONFIG_PREEMPT_BKL=y code as well, which has been the default setting 
since v2.6.8.]

There's another nice side-effect of this speedup patch, the new generic 
semaphore code got even smaller:

   text    data     bss     dec     hex filename
   1241       0       0    1241     4d9 semaphore.o.before
   1207       0       0    1207     4b7 semaphore.o.after

(because the waiter.up complication got removed.)

Longer-term we should look into using the mutex code for the generic 
semaphore code as well - but i's not easy due to legacies and it's 
outside of the scope of v2.6.26 and outside the scope of this patch as 
well.

Hm?

	Ingo

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/semaphore.c |   36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

Index: linux/kernel/semaphore.c
===================================================================
--- linux.orig/kernel/semaphore.c
+++ linux/kernel/semaphore.c
@@ -54,10 +54,9 @@ void down(struct semaphore *sem)
 	unsigned long flags;
 
 	spin_lock_irqsave(&sem->lock, flags);
-	if (likely(sem->count > 0))
-		sem->count--;
-	else
+	if (unlikely(sem->count <= 0))
 		__down(sem);
+	sem->count--;
 	spin_unlock_irqrestore(&sem->lock, flags);
 }
 EXPORT_SYMBOL(down);
@@ -77,10 +76,10 @@ int down_interruptible(struct semaphore 
 	int result = 0;
 
 	spin_lock_irqsave(&sem->lock, flags);
-	if (likely(sem->count > 0))
-		sem->count--;
-	else
+	if (unlikely(sem->count <= 0))
 		result = __down_interruptible(sem);
+	if (!result)
+		sem->count--;
 	spin_unlock_irqrestore(&sem->lock, flags);
 
 	return result;
@@ -103,10 +102,10 @@ int down_killable(struct semaphore *sem)
 	int result = 0;
 
 	spin_lock_irqsave(&sem->lock, flags);
-	if (likely(sem->count > 0))
-		sem->count--;
-	else
+	if (unlikely(sem->count <= 0))
 		result = __down_killable(sem);
+	if (!result)
+		sem->count--;
 	spin_unlock_irqrestore(&sem->lock, flags);
 
 	return result;
@@ -157,10 +156,10 @@ int down_timeout(struct semaphore *sem, 
 	int result = 0;
 
 	spin_lock_irqsave(&sem->lock, flags);
-	if (likely(sem->count > 0))
-		sem->count--;
-	else
+	if (unlikely(sem->count <= 0))
 		result = __down_timeout(sem, jiffies);
+	if (!result)
+		sem->count--;
 	spin_unlock_irqrestore(&sem->lock, flags);
 
 	return result;
@@ -179,9 +178,8 @@ void up(struct semaphore *sem)
 	unsigned long flags;
 
 	spin_lock_irqsave(&sem->lock, flags);
-	if (likely(list_empty(&sem->wait_list)))
-		sem->count++;
-	else
+	sem->count++;
+	if (unlikely(!list_empty(&sem->wait_list)))
 		__up(sem);
 	spin_unlock_irqrestore(&sem->lock, flags);
 }
@@ -192,7 +190,6 @@ EXPORT_SYMBOL(up);
 struct semaphore_waiter {
 	struct list_head list;
 	struct task_struct *task;
-	int up;
 };
 
 /*
@@ -206,11 +203,11 @@ static inline int __sched __down_common(
 	struct task_struct *task = current;
 	struct semaphore_waiter waiter;
 
-	list_add_tail(&waiter.list, &sem->wait_list);
 	waiter.task = task;
-	waiter.up = 0;
 
 	for (;;) {
+		list_add_tail(&waiter.list, &sem->wait_list);
+
 		if (state == TASK_INTERRUPTIBLE && signal_pending(task))
 			goto interrupted;
 		if (state == TASK_KILLABLE && fatal_signal_pending(task))
@@ -221,7 +218,7 @@ static inline int __sched __down_common(
 		spin_unlock_irq(&sem->lock);
 		timeout = schedule_timeout(timeout);
 		spin_lock_irq(&sem->lock);
-		if (waiter.up)
+		if (sem->count > 0)
 			return 0;
 	}
 
@@ -259,6 +256,5 @@ static noinline void __sched __up(struct
 	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
 						struct semaphore_waiter, list);
 	list_del(&waiter->list);
-	waiter->up = 1;
 	wake_up_process(waiter->task);
 }
