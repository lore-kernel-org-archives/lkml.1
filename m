Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbXFRQgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbXFRQgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 12:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbXFRQgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 12:36:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53172 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752841AbXFRQgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 12:36:42 -0400
Date: Mon, 18 Jun 2007 09:34:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Miklos Szeredi <miklos@szeredi.hu>, cebbert@redhat.com, chris@atlee.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
In-Reply-To: <20070618081204.GA11153@elte.hu>
Message-ID: <alpine.LFD.0.98.0706180857120.14121@woody.linux-foundation.org>
References: <E1HrEIp-0005qy-00@dorka.pomaz.szeredi.hu> <20070524144447.GA25068@elte.hu>
 <E1HrGom-0006AC-00@dorka.pomaz.szeredi.hu> <20070524210153.GB19672@elte.hu>
 <E1HrWSH-0000mH-00@dorka.pomaz.szeredi.hu> <E1Hyrnk-0006On-00@dorka.pomaz.szeredi.hu>
 <20070616103707.GA28096@elte.hu> <E1I02Zx-0005qu-00@dorka.pomaz.szeredi.hu>
 <20070618064343.GA31113@elte.hu> <E1I0Baz-0006cP-00@dorka.pomaz.szeredi.hu>
 <20070618081204.GA11153@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 Jun 2007, Ingo Molnar wrote:
> 
> To test this theory, could you try the patch below, does this fix your 
> hangs too?

I really think this the the wrong approach, although *testing* it makes 
sense.

I think we need to handle loops that take, release, and then immediately 
re-take differently.

Such loops are _usually_ of the form where they really just release the 
lock for some latency reason, but in this case I think it's actually just 
a bug.

That code does:

	if (unlikely(p->array || task_running(rq, p))) {

to decide if it needs to just unlock and repeat, but then to decide if it 
need to *yield* it only uses *one* of those tests (namely 

	preempted = !task_running(rq, p);
	..
	if (preempted)
		yield();

and I think that's just broken. It basically says:

 - if the task is running, I will busy-loop on getting/releasing the 
   task_rq_lock

and that is the _real_ bug here.

Trying to make the spinlocks do somethign else than what they do is just 
papering over the real bug. The real bug is that anybody who just 
busy-loops getting a lock is wasting resources so much that we should not 
be at all surprised that some multi-core or NUMA situations will get 
starvation.

Blaming some random Core 2 hardware implementation issue that just makes 
it show up is wrong. It's a software bug, plain and simple.

So how about this diff? The diff looks big, but the *code* is actually 
simpler and shorter, I just added tons of comments, which is what blows it 
up.

The new *code* looks like this:

	repeat:
		/* Unlocked, optimistic looping! */
	        rq = task_rq(p);
	        while (task_running(rq, p))
	                cpu_relax();

		/* Get the *real* values */
	        rq = task_rq_lock(p, &flags);
	        running = task_running(rq, p);
	        array = p->array;
	        task_rq_unlock(rq, &flags);

		/* Check them.. */
	        if (unlikely(running)) {
	                cpu_relax();
	                goto repeat;
	        }

	        if (unlikely(array)) {
	                yield();
	                goto repeat;
	        }

and while I haven't tested it, it looks fairly obviously correct, even if 
it's a bit subtle.

Basically, that first "while()" loop is done entirely without any locking 
at all, and so it's possibly "incorrect", but we don't care. Both the 
runqueue used, and the "task_running()" check might be the wrong tests, 
but they won't oops - they just mean that we might get the wrong results 
due to lack of locking.

So then we get the proper (and careful) rq lock, and check the 
running/runnable state _safely_. And if it turns out that our 
quick-and-dirty and unsafe loop was wrong after all, we just go back and 
try it all again.

Safe, simple, efficient. And we don't ever hold the lock for long times, 
and we will never *loop* by taking, releasing and re-taking the lock. 

Hmm? Untested, I know. Maybe I overlooked something. But even the 
generated assembly code looks fine (much better than it looked before!)

		Linus

----
 kernel/sched.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 60 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 13cdab3..66445e1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1159,21 +1159,72 @@ void wait_task_inactive(struct task_struct *p)
 {
 	unsigned long flags;
 	struct rq *rq;
-	int preempted;
+	struct prio_array *array;
+	int running;
 
 repeat:
+	/*
+	 * We do the initial early heuristics without holding
+	 * any task-queue locks at all. We'll only try to get
+	 * the runqueue lock when things look like they will
+	 * work out!
+	 */
+	rq = task_rq(p);
+
+	/*
+	 * If the task is actively running on another CPU
+	 * still, just relax and busy-wait without holding
+	 * any locks.
+	 *
+	 * NOTE! Since we don't hold any locks, it's not
+	 * even sure that "rq" stays as the right runqueue!
+	 * But we don't care, since "task_running()" will
+	 * return false if the runqueue has changed and p
+	 * is actually now running somewhere else!
+	 */
+	while (task_running(rq, p))
+		cpu_relax();
+
+	/*
+	 * Ok, time to look more closely! We need the rq
+	 * lock now, to be *sure*. If we're wrong, we'll
+	 * just go back and repeat.
+	 */
 	rq = task_rq_lock(p, &flags);
-	/* Must be off runqueue entirely, not preempted. */
-	if (unlikely(p->array || task_running(rq, p))) {
-		/* If it's preempted, we yield.  It could be a while. */
-		preempted = !task_running(rq, p);
-		task_rq_unlock(rq, &flags);
+	running = task_running(rq, p);
+	array = p->array;
+	task_rq_unlock(rq, &flags);
+
+	/*
+	 * Was it really running after all now that we
+	 * checked with the proper locks actually held?
+	 *
+	 * Oops. Go back and try again..
+	 */
+	if (unlikely(running)) {
 		cpu_relax();
-		if (preempted)
-			yield();
 		goto repeat;
 	}
-	task_rq_unlock(rq, &flags);
+
+	/*
+	 * It's not enough that it's not actively running,
+	 * it must be off the runqueue _entirely_, and not
+	 * preempted!
+	 *
+	 * So if it wa still runnable (but just not actively
+	 * running right now), it's preempted, and we should
+	 * yield - it could be a while.
+	 */
+	if (unlikely(array)) {
+		yield();
+		goto repeat;
+	}
+
+	/*
+	 * Ahh, all good. It wasn't running, and it wasn't
+	 * runnable, which means that it will never become
+	 * running in the future either. We're all done!
+	 */
 }
 
 /***
