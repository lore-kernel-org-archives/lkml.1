Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbZKFDns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbZKFDns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 22:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755840AbZKFDnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 22:43:47 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59082 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755081AbZKFDnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 22:43:46 -0500
Message-ID: <4AF39B6D.50001@cn.fujitsu.com>
Date: Fri, 06 Nov 2009 11:43:41 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Eric Paris <eparis@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] sched: fix bug that task run on a wrong and unallowed
 cpu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


a1f84a3ab8e002159498814eaa7e48c33752b04b brought a bug that
task may run on a unallowed cpu.

In my box, this bug trigger debug_smp_processor_id()'s complaints:

BUG: using smp_processor_id() in preemptible [00000000] code: events/1/10
caller is vmstat_update+0x2a/0x3e
Pid: 10, comm: events/1 Not tainted 2.6.32-rc6-tip-01796-gd995f1d-dirty #118
Call Trace:
 [<c02a3871>] debug_smp_processor_id+0xa5/0xbc
 [<c01a229e>] vmstat_update+0x2a/0x3e
 [<c014d6df>] worker_thread+0x134/0x1c2
 [<c01a2274>] ? vmstat_update+0x0/0x3e
 [<c0151361>] ? autoremove_wake_function+0x0/0x38
 [<c014d5ab>] ? worker_thread+0x0/0x1c2
 [<c0151298>] kthread+0x66/0x6e
 [<c0151232>] ? kthread+0x0/0x6e
 [<c0102e97>] kernel_thread_helper+0x7/0x10

See:
debug_smp_processor_id() {
	.....
	/*
	 * Kernel threads bound to a single CPU can safely use
	 * smp_processor_id():
	 */
	if (cpumask_equal(&current->cpus_allowed, cpumask_of(this_cpu)))
		goto out;
	.....
}

When events/1 run on wrong cpu, cpumask_equal() will fail,
and debug_smp_processor_id() complains.

Ftrace also shows events/1 was run on wrong cpu(cpu#0):

          <idle>-0     [000]   947.573038: perf_event_task_sched_out <-schedule
          <idle>-0     [000]   947.573039: memcpy <-tracing_record_cmdline
          <idle>-0     [000]   947.573040: __switch_to <-schedule
        events/1-10    [000]   947.573050: finish_task_switch <-schedule
        events/1-10    [000]   947.573051: perf_event_task_sched_in <-finish_task_switch
        events/1-10    [000]   947.573051: _spin_unlock_irq <-finish_task_switch
        events/1-10    [000]   947.573052: finish_wait <-worker_thread
        events/1-10    [000]   947.573053: kthread_should_stop <-worker_thread
        events/1-10    [000]   947.573054: _spin_lock_irq <-worker_thread
        events/1-10    [000]   947.573055: _spin_lock_irqsave <-probe_workqueue_execution
        events/1-10    [000]   947.573056: _spin_unlock_irqrestore <-probe_workqueue_execution
        events/1-10    [000]   947.573057: _spin_unlock_irq <-worker_thread
        events/1-10    [000]   947.573058: flush_to_ldisc <-worker_thread


events/1 should run at cpu#1, but [000] shows it was run at cpu#0

After a1f84a3ab8e002159498814eaa7e48c33752b04b applied,
select_task_rq_fair() select candidate cpu without checking
the p->cpus_allowed. This fix repair it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 32f06ed..6a8f389 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1414,7 +1414,8 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 				}
 
 				if (candidate == -1 || candidate == cpu) {
-					for_each_cpu(i, sched_domain_span(tmp)) {
+					for_each_cpu_and(i, sched_domain_span(tmp),
+							&p->cpus_allowed) {
 						if (!cpu_rq(i)->cfs.nr_running) {
 							candidate = i;
 							break;
