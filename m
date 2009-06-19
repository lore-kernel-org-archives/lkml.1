Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbZFSM0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbZFSM0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 08:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbZFSM0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 08:26:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:35011 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbZFSM0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 08:26:17 -0400
Subject: Re: [tip:perfcounters/core] perf_counter: Simplify and fix task
 migration counting
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@redhat.com
Cc: hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <1245412779.19816.5.camel@twins>
References: <new-submission>
	 <tip-e5289d4a181fb6c0b7a7607649af2ffdc491335c@git.kernel.org>
	 <1245412779.19816.5.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 19 Jun 2009 14:26:05 +0200
Message-Id: <1245414365.19816.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-19 at 13:59 +0200, Peter Zijlstra wrote:
> On Fri, 2009-06-19 at 11:52 +0000, tip-bot for Peter Zijlstra wrote:
> > Commit-ID:  e5289d4a181fb6c0b7a7607649af2ffdc491335c
> > Gitweb:     http://git.kernel.org/tip/e5289d4a181fb6c0b7a7607649af2ffdc491335c
> > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > AuthorDate: Fri, 19 Jun 2009 13:22:51 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Fri, 19 Jun 2009 13:43:12 +0200
> > 
> > perf_counter: Simplify and fix task migration counting
> > 
> > The task migrations counter was causing rare and hard to decypher
> > memory corruptions under load. After a day of debugging and bisection
> > we found that the problem was introduced with:
> > 
> >   3f731ca: perf_counter: Fix cpu migration counter
> > 
> > Turning them off fixes the crashes. Incidentally, the whole
> > perf_counter_task_migration() logic can be done simpler as well,
> > by injecting a proper sw-counter event.
> > 
> > This cleanup also fixed the crashes. The precise failure mode is
> > not completely clear yet, but we are clearly not unhappy about
> > having a fix ;-)
> 
> 
> I actually do know what happens:
> 
> static struct perf_counter_context *
> perf_lock_task_context(struct task_struct *task, unsigned long *flags)
> {
> 	struct perf_counter_context *ctx;
> 
> 	rcu_read_lock();
>  retry:
> 	ctx = rcu_dereference(task->perf_counter_ctxp);
> 	if (ctx) {
> 
> 		spin_lock_irqsave(&ctx->lock, *flags);
> 		if (ctx != rcu_dereference(task->perf_counter_ctxp)) {
> 			spin_unlock_irqrestore(&ctx->lock, *flags);
> 			goto retry;
> 		}
> 	}
> 	rcu_read_unlock();
> 	return ctx;
> }
> 
> 
> static struct perf_counter_context *perf_pin_task_context(struct task_struct *task)
> {
> 	struct perf_counter_context *ctx;
> 	unsigned long flags;
> 
> 	ctx = perf_lock_task_context(task, &flags);
> 	if (ctx) {
> 		++ctx->pin_count;
> 		get_ctx(ctx);
> 		spin_unlock_irqrestore(&ctx->lock, flags);
> 	}
> 	return ctx;
> }
> 
> Is buggy because perf_lock_task_context() can return a dead context.
> 
> the RCU read lock in perf_lock_task_context() only guarantees the memory
> won't get freed, it doesn't guarantee the object is valid (in our case
> refcount > 0).
> 
> Therefore we can return a locked object that can get freed the moment we
> release the rcu read lock.
> 
> perf_pin_task_context() then increases the refcount and does an unlock
> on freed memory.
> 
> That increased refcount will cause a double free, in case it started out
> with 0.
> 

Maybe something like so..

---
 kernel/perf_counter.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 7e9108e..923189e 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -175,6 +175,11 @@ perf_lock_task_context(struct task_struct *task, unsigned long *flags)
 			spin_unlock_irqrestore(&ctx->lock, *flags);
 			goto retry;
 		}
+
+		if (!atomic_inc_not_zero(&ctx->refcount)) {
+			spin_unlock_irqrestore(&ctx->lock, *flags);
+			ctx = NULL;
+		}
 	}
 	rcu_read_unlock();
 	return ctx;
@@ -193,7 +198,6 @@ static struct perf_counter_context *perf_pin_task_context(struct task_struct *ta
 	ctx = perf_lock_task_context(task, &flags);
 	if (ctx) {
 		++ctx->pin_count;
-		get_ctx(ctx);
 		spin_unlock_irqrestore(&ctx->lock, flags);
 	}
 	return ctx;
@@ -1459,11 +1463,6 @@ static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 			put_ctx(parent_ctx);
 			ctx->parent_ctx = NULL;		/* no longer a clone */
 		}
-		/*
-		 * Get an extra reference before dropping the lock so that
-		 * this context won't get freed if the task exits.
-		 */
-		get_ctx(ctx);
 		spin_unlock_irqrestore(&ctx->lock, flags);
 	}
 
