Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674Ab0A1M4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab0A1M4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 07:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125Ab0A1M4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 07:56:04 -0500
Received: from ozlabs.org ([203.10.76.45]:53014 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab0A1M4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 07:56:01 -0500
Date: Thu, 28 Jan 2010 23:52:02 +1100
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: [PATCH 2/2] sched: cpuacct: Use bigger percpu counter batch values
 for stats counters
Message-ID: <20100128125202.GG2996@kryten>
References: <20100118044142.GS12666@kryten>
 <tip-43f85eab1411905afe5db510fbf9841b516e7e6a@git.kernel.org>
 <661de9471001270534ve6f7bf0nb58ef58f9a6ff10e@mail.gmail.com>
 <20100127132212.cd43cd94.akpm@linux-foundation.org>
 <1264628600.4283.2080.camel@laptop>
 <20100128124854.GF2996@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100128124854.GF2996@kryten>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When CONFIG_VIRT_CPU_ACCOUNTING and CONFIG_CGROUP_CPUACCT are enabled we can
call cpuacct_update_stats with values much larger than percpu_counter_batch.
This means the call to percpu_counter_add will always add to the global count
which is protected by a spinlock and we end up with a global spinlock in
the scheduler.

Based on an idea by KOSAKI Motohiro, this patch scales the batch value by
cputime_one_jiffy such that we have the same batch limit as we would
if CONFIG_VIRT_CPU_ACCOUNTING was disabled. His patch did this once at boot
but that initialisation happened too early on PowerPC (before time_init)
and it was never updated at runtime as a result of a hotplug cpu add/remove.

This patch instead scales percpu_counter_batch by cputime_one_jiffy at
runtime, which keeps the batch correct even after cpu hotplug operations.
We cap it at INT_MAX in case of overflow.

For architectures that do not support CONFIG_VIRT_CPU_ACCOUNTING,
cputime_one_jiffy is the constant 1 and gcc is smart enough to
optimise min(s32 percpu_counter_batch, INT_MAX) to just percpu_counter_batch
at least on x86 and PowerPC. So there is no need to add an #ifdef.

On a 64 thread PowerPC box with CONFIG_VIRT_CPU_ACCOUNTING and 
CONFIG_CGROUP_CPUACCT enabled, a context switch microbenchmark is 234x faster
and almost matches a CONFIG_CGROUP_CPUACCT disabled kernel:

CONFIG_CGROUP_CPUACCT disabled:         16906698 ctx switches/sec
CONFIG_CGROUP_CPUACCT enabled:             61720 ctx switches/sec
CONFIG_CGROUP_CPUACCT + patch:          16663217 ctx switches/sec

Tested with:

wget http://ozlabs.org/~anton/junkcode/context_switch.c
make context_switch
for i in `seq 0 63`; do taskset -c $i ./context_switch & done
vmstat 1

Signed-off-by: Anton Blanchard <anton@samba.org>
---

v2: Added a comment and fixed the UP build.

Index: linux-cpumask/kernel/sched.c
===================================================================
--- linux-cpumask.orig/kernel/sched.c	2010-01-22 18:23:43.377212514 +1100
+++ linux-cpumask/kernel/sched.c	2010-01-28 23:24:02.677233753 +1100
@@ -10885,12 +10885,30 @@ static void cpuacct_charge(struct task_s
 }
 
 /*
+ * When CONFIG_VIRT_CPU_ACCOUNTING is enabled one jiffy can be very large
+ * in cputime_t units. As a result, cpuacct_update_stats calls
+ * percpu_counter_add with values large enough to always overflow the
+ * per cpu batch limit causing bad SMP scalability.
+ *
+ * To fix this we scale percpu_counter_batch by cputime_one_jiffy so we
+ * batch the same amount of time with CONFIG_VIRT_CPU_ACCOUNTING disabled
+ * and enabled. We cap it at INT_MAX which is the largest allowed batch value.
+ */
+#ifdef CONFIG_SMP
+#define CPUACCT_BATCH	\
+	min_t(long, percpu_counter_batch * cputime_one_jiffy, INT_MAX)
+#else
+#define CPUACCT_BATCH	0
+#endif
+
+/*
  * Charge the system/user time to the task's accounting group.
  */
 static void cpuacct_update_stats(struct task_struct *tsk,
 		enum cpuacct_stat_index idx, cputime_t val)
 {
 	struct cpuacct *ca;
+	int batch = CPUACCT_BATCH;
 
 	if (unlikely(!cpuacct_subsys.active))
 		return;
@@ -10899,7 +10917,7 @@ static void cpuacct_update_stats(struct 
 	ca = task_ca(tsk);
 
 	do {
-		percpu_counter_add(&ca->cpustat[idx], val);
+		__percpu_counter_add(&ca->cpustat[idx], val, batch);
 		ca = ca->parent;
 	} while (ca);
 	rcu_read_unlock();
