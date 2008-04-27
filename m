Return-Path: <linux-kernel-owner+w=401wt.eu-S1760998AbYD0OZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760998AbYD0OZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 10:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754984AbYD0OZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 10:25:23 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51221 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904AbYD0OZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 10:25:22 -0400
Date: Sun, 27 Apr 2008 18:25:29 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: get_online_cpus() && workqueues
Message-ID: <20080427142529.GA15005@tv-sign.ru>
References: <1208868236.7115.249.camel@twins> <20080423035802.GA8895@in.ibm.com> <20080424150714.GA8273@osiris.boeblingen.de.ibm.com> <1209052984.7115.369.camel@twins> <20080424155946.GA11160@tv-sign.ru> <20080424194810.GA4821@osiris.boeblingen.de.ibm.com> <20080424192706.GA165@tv-sign.ru> <20080425064044.GA10817@osiris.boeblingen.de.ibm.com> <20080426144330.GA6150@tv-sign.ru> <20080427122209.GB6754@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427122209.GB6754@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27, Heiko Carstens wrote:
>
> On Sat, Apr 26, 2008 at 06:43:30PM +0400, Oleg Nesterov wrote:
> > 
> > In short: work_struct can't use get_online_cpus() due to deadlock with the
> > CPU_DEAD phase.
> > 
> > Can't we add another nested lock which is dropped right after __cpu_die()?
> > (in fact I think it could be dropped after __stop_machine_run).
> > 
> > The new read-lock is get_online_map() (just a random name for now). The only
> > difference wrt get_online_cpus() is that it doesn't protect against CPU_DEAD,
> > but most users of get_online_cpus() doesn't need this, they only need a
> > stable cpu_online_map and sometimes they need to be sure that some per-cpu
> > object (say, cpu_workqueue_struct->thread) can't be destroyed under this
> > lock.
> > 
> > get_online_map() seem to fit for this, and can be used from work->func().
> > (actually, I think most users of use get_online_cpus() could use the new
> > helper instead, but this doen't matter).
> > 
> > Heiko, what do you think? Is it suitable for arch_reinit_sched_domains()?
> 
> Uhm, no. For arch_reinit_sched_domains that would allow for concurrent
> callers for arch_init_sched_domains since sched.c calls that function in
> quite a lot of the CPU_* phases (including CPU_DEAD)

OK, thanks,

> But on the other hand there can be already concurrent callers via
> sched_power_savings_store().
> 
> And with s390 calling arch_reinit_sched_domais() from outside there can be
> yet another concurrent caller. Looks like the locking is broken anyway.
> Sigh.
> 
> Looks like we need a new lock in arch_reinit_sched_domains() to prevent
> concurrent callers to arch_init_sched_domains().
...
> So conclusion is: the new get_online_map() wouldn't solve the deadlock
> here,

Well, if we add a new lock to arch_reinit_sched_domains(), perhaps we can
solve the deadlock, but this means we should also change update_sched_domains()
to take this lock too. Not pleasant, and

> For the "don't call get_online_cpus() from within a work_struct" I have
> the patch below.

yes, I think it is much better.



Still. It would be nice to find the general (and simple!) solution.
Especially because it can happen that some work->func() will use
get_online_cpus() indirectly.

Currently I am thinking about something like the patch below, but it
is so ugly...

Oleg.

--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -210,6 +210,8 @@ static inline int notifier_to_errno(int 
 #define CPU_DYING		0x0008 /* CPU (unsigned)v not running any task,
 				        * not handling interrupts, soon dead */
 
+#define CPU_DEAD_XXX		0x0002 /* HACK!!! for workqueus */
+
 /* Used for CPU hotplug events occuring while tasks are frozen due to a suspend
  * operation in progress
  */
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -271,6 +271,11 @@ static int _cpu_down(unsigned int cpu,
 	set_cpus_allowed(current, old_allowed);
 out_release:
 	cpu_hotplug_done();
+
+	if (!err)
+		// HAAAAAACK !!!!!!!!!!!
+		raw_notifier_call_chain(&cpu_chain, CPU_DEAD_XXX, hcpu);
+
 	return err;
 }
 
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -780,7 +780,7 @@ struct workqueue_struct *__create_workqu
 		err = create_workqueue_thread(cwq, singlethread_cpu);
 		start_workqueue_thread(cwq, -1);
 	} else {
-		get_online_cpus();
+		cpu_maps_update_begin();
 		spin_lock(&workqueue_lock);
 		list_add(&wq->list, &workqueues);
 		spin_unlock(&workqueue_lock);
@@ -792,7 +792,7 @@ struct workqueue_struct *__create_workqu
 			err = create_workqueue_thread(cwq, cpu);
 			start_workqueue_thread(cwq, cpu);
 		}
-		put_online_cpus();
+		cpu_maps_update_done();
 	}
 
 	if (err) {
@@ -807,7 +807,7 @@ static void cleanup_workqueue_thread(str
 {
 	/*
 	 * Our caller is either destroy_workqueue() or CPU_DEAD,
-	 * get_online_cpus() protects cwq->thread.
+	 * cpu_add_remove_lock protects cwq->thread.
 	 */
 	if (cwq->thread == NULL)
 		return;
@@ -841,14 +841,14 @@ void destroy_workqueue(struct workqueue_
 	const cpumask_t *cpu_map = wq_cpu_map(wq);
 	int cpu;
 
-	get_online_cpus();
+	cpu_maps_update_begin();
 	spin_lock(&workqueue_lock);
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
 
 	for_each_cpu_mask(cpu, *cpu_map)
 		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
-	put_online_cpus();
+	cpu_maps_update_done();
 
 	free_percpu(wq->cpu_wq);
 	kfree(wq);
@@ -887,7 +887,7 @@ static int __devinit workqueue_cpu_callb
 
 		case CPU_UP_CANCELED:
 			start_workqueue_thread(cwq, -1);
-		case CPU_DEAD:
+		case CPU_DEAD_XXX:
 			cleanup_workqueue_thread(cwq);
 			break;
 		}

