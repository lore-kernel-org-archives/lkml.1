Return-Path: <linux-kernel-owner+w=401wt.eu-S1752805AbZIILln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbZIILln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 07:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZIILlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 07:41:42 -0400
Received: from server1.wserver.cz ([82.113.45.157]:51266 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZIILlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 07:41:42 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: peterz@infradead.org
Cc: rjw@sisk.pl, laijs@cn.fujitsu.com, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/1] sched: fix cpu_down deadlock
Date: Wed,  9 Sep 2009 13:41:50 +0200
Message-Id: <1252496510-11898-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <4AA0FEBF.7040104@gmail.com>
References: <4AA0FEBF.7040104@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Thanks, in the end I found it manually. Goddammit! It's an -mm thing:
> cpu_hotplug-dont-affect-current-tasks-affinity.patch
> 
> Well, I don't know why, but when the kthread overthere runs under
> suspend conditions and gets rescheduled (e.g. by the might_sleep()
> inside) it never returns. pick_next_task always returns the idle task
> from the idle queue. State of the thread is TASK_RUNNING.
> 
> Why is it not enqueued into some queue? I tried also
> sched_setscheduler(current, FIFO, 99) in the thread itself. Unless I did
> it wrong, it seems like a global scheduler problem?

Actually not, it definitely seems like a cpu_down problem.
 
> Ingo, any ideas?

Apparently not, but nevermind :). What about the patch below?

--

After a cpu is taken down in __stop_machine, the kcpu_thread still may be
rescheduled to that cpu, but in fact the cpu is not running at that
moment.

This causes kcpu_thread to never run again, because its enqueued on another
runqueue, hence pick_next_task never selects it on the set of newly
running cpus.

We do set_cpus_allowed_ptr in _cpu_down_thread, but cpu_active_mask is
updated to not contain the cpu which goes down even after the thread finishes
(and _cpu_down returns).

For me this triggers mostly while suspending a SMP machine with
FAIR_GROUP_SCHED enabled and
cpu_hotplug-dont-affect-current-tasks-affinity patch applied. The patch
adds kthread to the cpu_down pipeline.

Fix this issue by eliminating the to-be-killed-cpu from active_cpu
locally.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/cpu.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index be9c5ad..17a3635 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -196,6 +196,14 @@ static int __ref _cpu_down_thread(void *_param)
 	unsigned long mod = param->mod;
 	unsigned int cpu = param->cpu;
 	void *hcpu = (void *)(long)cpu;
+	cpumask_var_t active_mask;
+
+	if (!alloc_cpumask_var(&active_mask, GFP_KERNEL))
+		return -ENOMEM;
+
+	/* make sure we are not running on the cpu which goes down,
+	   cpu_active_mask is altered even after we return! */
+	cpumask_andnot(active_mask, cpu_active_mask, cpumask_of(cpu));
 
 	cpu_hotplug_begin();
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
@@ -211,7 +219,7 @@ static int __ref _cpu_down_thread(void *_param)
 	}
 
 	/* Ensure that we are not runnable on dying cpu */
-	set_cpus_allowed_ptr(current, cpu_active_mask);
+	set_cpus_allowed_ptr(current, active_mask);
 
 	err = __stop_machine(take_cpu_down, param, cpumask_of(cpu));
 	if (err) {
@@ -237,9 +245,9 @@ static int __ref _cpu_down_thread(void *_param)
 		BUG();
 
 	check_for_tasks(cpu);
-
 out_release:
 	cpu_hotplug_done();
+	free_cpumask_var(active_mask);
 	if (!err) {
 		if (raw_notifier_call_chain(&cpu_chain, CPU_POST_DEAD | mod,
 					    hcpu) == NOTIFY_BAD)
-- 
1.6.3.3

