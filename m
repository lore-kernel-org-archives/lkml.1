Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbZEOU1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbZEOU1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 16:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbZEOU1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 16:27:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:50601 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbZEOU1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 16:27:22 -0400
Subject: Re: perf counter issue -
 WARN_ON_ONCE(!list_empty(&tsk->perf_counter_ctx.counter_list));
From: Peter Zijlstra <peterz@infradead.org>
To: vatsa@in.ibm.com
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <1242409073.32543.187.camel@laptop>
References: <20090513165433.GD16373@in.ibm.com>
	 <20090513165724.GA32707@in.ibm.com> <20090515135604.GC16389@elte.hu>
	 <20090515145144.GD13664@ghostprotocols.net>
	 <20090515155807.GA25957@in.ibm.com>  <1242404001.32543.100.camel@laptop>
	 <1242409073.32543.187.camel@laptop>
Content-Type: text/plain
Date: Fri, 15 May 2009 22:27:08 +0200
Message-Id: <1242419228.32543.360.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-15 at 19:37 +0200, Peter Zijlstra wrote:
> On Fri, 2009-05-15 at 18:13 +0200, Peter Zijlstra wrote:
> > On Fri, 2009-05-15 at 21:28 +0530, Srivatsa Vaddagiri wrote:
> > > On Fri, May 15, 2009 at 11:51:44AM -0300, Arnaldo Carvalho de Melo wrote:
> > > > > hm, is there a reproducer perhaps? Is there some class file i could 
> > > > > run with specific parameters to reproduce it?
> > > > 
> > > > I'll try this with some java benchmarks we have, AMQP related, lets see
> > > > if I can reproduce it.
> > > 
> > > I tried this with SPECJbb - which I am not at liberty to distribute
> > > unfortunately. I will try and recreate it with volanomark or other open
> > > source benchmarks.
> > 
> > I could indeed reproduce with vmark. Am poking at it.. still clueless
> > though ;-)
> 
> [root@opteron tmp]# cat foo.c
> #include <pthread.h>
> #include <unistd.h>
> 
> void *thread(void *arg)
> {
>         sleep(5);
>         return NULL;
> }
> 
> void main(void)
> {
>         pthread_t thr;
>         pthread_create(&thr, NULL, thread, NULL);
> }
> 
> The above instantly triggers it. It appears we fail to cleanup on the
> reparent path. I'll go root around in exit.c.

OK, so the cleanup isn't solid.. I've been poking at things, and below
is the current state of my tinkering, but it seems to make things
worse...

With only the callback in do_exit() the above test works but hackbench
fails, with only the call in wait_task_zombie() hackbench works and the
above fails.

With both, we segfault the kernel on a list op on either :-)

Will continue poking tomorrow and such, unless someone beats me to it.


---
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -115,6 +115,7 @@ list_add_counter(struct perf_counter *co
 	}
 
 	list_add_rcu(&counter->event_entry, &ctx->event_list);
+	ctx->nr_counters++;
 }
 
 static void
@@ -122,6 +123,8 @@ list_del_counter(struct perf_counter *co
 {
 	struct perf_counter *sibling, *tmp;
 
+	ctx->nr_counters--;
+
 	list_del_init(&counter->list_entry);
 	list_del_rcu(&counter->event_entry);
 
@@ -209,7 +212,6 @@ static void __perf_counter_remove_from_c
 	counter_sched_out(counter, cpuctx, ctx);
 
 	counter->task = NULL;
-	ctx->nr_counters--;
 
 	/*
 	 * Protect the list operation against NMI by disabling the
@@ -276,7 +278,6 @@ retry:
 	 * succeed.
 	 */
 	if (!list_empty(&counter->list_entry)) {
-		ctx->nr_counters--;
 		list_del_counter(counter, ctx);
 		counter->task = NULL;
 	}
@@ -544,7 +545,6 @@ static void add_counter_to_ctx(struct pe
 			       struct perf_counter_context *ctx)
 {
 	list_add_counter(counter, ctx);
-	ctx->nr_counters++;
 	counter->prev_state = PERF_COUNTER_STATE_OFF;
 	counter->tstamp_enabled = ctx->time;
 	counter->tstamp_running = ctx->time;
@@ -3252,8 +3252,8 @@ __perf_counter_exit_task(struct task_str
 	 */
 	if (child != current) {
 		wait_task_inactive(child, 0);
-		list_del_init(&child_counter->list_entry);
 		update_counter_times(child_counter);
+		list_del_counter(child_counter, child_ctx);
 	} else {
 		struct perf_cpu_context *cpuctx;
 		unsigned long flags;
@@ -3272,9 +3272,7 @@ __perf_counter_exit_task(struct task_str
 		group_sched_out(child_counter, cpuctx, child_ctx);
 		update_counter_times(child_counter);
 
-		list_del_init(&child_counter->list_entry);
-
-		child_ctx->nr_counters--;
+		list_del_counter(child_counter, child_ctx);
 
 		perf_enable();
 		local_irq_restore(flags);
@@ -3288,13 +3286,6 @@ __perf_counter_exit_task(struct task_str
 	 */
 	if (parent_counter) {
 		sync_child_counter(child_counter, parent_counter);
-		list_for_each_entry_safe(sub, tmp, &child_counter->sibling_list,
-					 list_entry) {
-			if (sub->parent) {
-				sync_child_counter(sub, sub->parent);
-				free_counter(sub);
-			}
-		}
 		free_counter(child_counter);
 	}
 }
@@ -3315,9 +3306,18 @@ void perf_counter_exit_task(struct task_
 	if (likely(!child_ctx->nr_counters))
 		return;
 
+again:
 	list_for_each_entry_safe(child_counter, tmp, &child_ctx->counter_list,
 				 list_entry)
 		__perf_counter_exit_task(child, child_counter, child_ctx);
+
+	/*
+	 * If the last counter was a group counter, it will have appended all
+	 * its siblings to the list, but we obtained 'tmp' before that which
+	 * will still point to the list head terminating the iteration.
+	 */
+	if (!list_empty(&child_ctx->counter_list))
+		goto again;
 }
 
 /*
Index: linux-2.6/kernel/exit.c
===================================================================
--- linux-2.6.orig/kernel/exit.c
+++ linux-2.6/kernel/exit.c
@@ -155,7 +155,7 @@ static void delayed_put_task_struct(stru
 	struct task_struct *tsk = container_of(rhp, struct task_struct, rcu);
 
 #ifdef CONFIG_PERF_COUNTERS
-	WARN_ON_ONCE(!list_empty(&tsk->perf_counter_ctx.counter_list));
+	WARN_ON(!list_empty(&tsk->perf_counter_ctx.counter_list));
 #endif
 	trace_sched_process_free(tsk);
 	put_task_struct(tsk);
@@ -1002,6 +1002,8 @@ NORET_TYPE void do_exit(long code)
 	if (tsk->splice_pipe)
 		__free_pipe_info(tsk->splice_pipe);
 
+	perf_counter_exit_task(tsk);
+
 	preempt_disable();
 	/* causes final put_task_struct in finish_task_switch(). */
 	tsk->state = TASK_DEAD;


