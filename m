Return-Path: <linux-kernel-owner+w=401wt.eu-S935663AbZFPFkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935663AbZFPFkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbZFPFjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:39:02 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:38223 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934732AbZFPFjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:39:00 -0400
Subject: [RFD PATCH 4/4] cpu: measure time taken by subsystem notifiers during
	cpu-hotplug
To: linux-kernel@vger.kernel.org
From: Gautham R Shenoy <ego@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Balbir Singh <balbir@in.ibm.com>,
       Rusty Russel <rusty@rustcorp.com.au>,
       Paul E McKenney <paulmck@us.ibm.com>, Nathan Lynch <ntl@pobox.com>,
       Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Shoahua Li <shaohua.li@linux.com>
Date: Tue, 16 Jun 2009 11:08:59 +0530
Message-ID: <20090616053859.30891.79196.stgit@sofia.in.ibm.com>
In-Reply-To: <20090616053431.30891.18682.stgit@sofia.in.ibm.com>
References: <20090616053431.30891.18682.stgit@sofia.in.ibm.com>
User-Agent: StGit/0.14.3.384.g9ab0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Place tracepoints at appropriate places to profile the time consumed by the
notifiers and the core-cpu-hotplug operations.

Change the notifier chain api to pass private data which can be used for
filtering out the trace results.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---
 include/trace/notifier_trace.h |   32 ++++++++++++++++++++++++++++++++
 kernel/cpu.c                   |   11 +++++++++++
 kernel/notifier.c              |   23 ++++++++++++++++++-----
 3 files changed, 61 insertions(+), 5 deletions(-)
 create mode 100644 include/trace/notifier_trace.h

diff --git a/include/trace/notifier_trace.h b/include/trace/notifier_trace.h
new file mode 100644
index 0000000..1591a40
--- /dev/null
+++ b/include/trace/notifier_trace.h
@@ -0,0 +1,32 @@
+#ifndef _HOTPLUG_CPU_TRACE_H_
+#define _HOTPLUG_CPU_TRACE_H_
+
+#include <linux/tracepoint.h>
+#include <linux/notifier.h>
+
+DECLARE_TRACE(hotplug_notifier_event_start,
+		TP_PROTO(void *notifier_call, unsigned int val,
+						void *chain_head),
+		TP_ARGS(notifier_call, val, chain_head));
+
+DECLARE_TRACE(hotplug_notifier_event_stop,
+		TP_PROTO(void *notifier_call, unsigned int val,
+						void *chain_head),
+		TP_ARGS(notifier_call, val, chain_head));
+
+DECLARE_TRACE(stop_machine_event_start,
+	TP_PROTO(void),
+	TP_ARGS());
+
+DECLARE_TRACE(stop_machine_event_stop,
+	TP_PROTO(void),
+	TP_ARGS());
+
+DECLARE_TRACE(cpu_up_event_start,
+	TP_PROTO(void),
+	TP_ARGS());
+
+DECLARE_TRACE(cpu_up_event_stop,
+	TP_PROTO(void),
+	TP_ARGS());
+#endif
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 2b5d4e0..256a3e4 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -14,6 +14,7 @@
 #include <linux/kthread.h>
 #include <linux/stop_machine.h>
 #include <linux/mutex.h>
+#include <trace/notifier_trace.h>
 
 #ifdef CONFIG_SMP
 /* Serializes the updates to cpu_online_mask, cpu_present_mask */
@@ -190,6 +191,9 @@ static int __ref take_cpu_down(void *_param)
 	return 0;
 }
 
+DEFINE_TRACE(stop_machine_event_start);
+DEFINE_TRACE(stop_machine_event_stop);
+
 /* Requires cpu_add_remove_lock to be held */
 static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 {
@@ -229,7 +233,9 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	set_cpus_allowed_ptr(current,
 			     cpumask_of(cpumask_any_but(cpu_online_mask, cpu)));
 
+	trace_stop_machine_event_start();
 	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
+	trace_stop_machine_event_stop();
 	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
 		if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
@@ -327,6 +333,9 @@ int __ref cpu_down(unsigned int cpu)
 EXPORT_SYMBOL(cpu_down);
 #endif /*CONFIG_HOTPLUG_CPU*/
 
+DEFINE_TRACE(cpu_up_event_start);
+DEFINE_TRACE(cpu_up_event_stop);
+
 /* Requires cpu_add_remove_lock to be held */
 static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 {
@@ -349,7 +358,9 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 	}
 
 	/* Arch-specific enabling code. */
+	trace_cpu_up_event_start();
 	ret = __cpu_up(cpu);
+	trace_cpu_up_event_stop();
 	if (ret != 0)
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));
diff --git a/kernel/notifier.c b/kernel/notifier.c
index 61d5aa5..5729035 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -5,6 +5,7 @@
 #include <linux/rcupdate.h>
 #include <linux/vmalloc.h>
 #include <linux/reboot.h>
+#include <trace/notifier_trace.h>
 
 /*
  *	Notifier list for kernel code which wants to be called
@@ -59,6 +60,9 @@ static int notifier_chain_unregister(struct notifier_block **nl,
 	return -ENOENT;
 }
 
+DEFINE_TRACE(hotplug_notifier_event_start);
+DEFINE_TRACE(hotplug_notifier_event_stop);
+
 /**
  * notifier_call_chain - Informs the registered notifiers about an event.
  *	@nl:		Pointer to head of the blocking notifier chain
@@ -68,12 +72,16 @@ static int notifier_chain_unregister(struct notifier_block **nl,
  *			value of this parameter is -1.
  *	@nr_calls:	Records the number of notifications sent. Don't care
  *			value of this field is NULL.
+ *	@chain_head:	Pointer to the head of the notifier chain. We cast it as
+ *			void * to allow different kinds of notifier chains to
+ *			pass the value of their chain heads.
  *	@returns:	notifier_call_chain returns the value returned by the
  *			last notifier function called.
  */
 static int __kprobes notifier_call_chain(struct notifier_block **nl,
 					unsigned long val, void *v,
-					int nr_to_call,	int *nr_calls)
+					int nr_to_call,	int *nr_calls,
+					void *chain_head)
 {
 	int ret = NOTIFY_DONE;
 	struct notifier_block *nb, *next_nb;
@@ -90,7 +98,11 @@ static int __kprobes notifier_call_chain(struct notifier_block **nl,
 			continue;
 		}
 #endif
+		trace_hotplug_notifier_event_start((void *)(nb->notifier_call),
+						val, (void *)chain_head);
 		ret = nb->notifier_call(nb, val, v);
+		trace_hotplug_notifier_event_stop((void *)(nb->notifier_call),
+						val, (void *) chain_head);
 
 		if (nr_calls)
 			(*nr_calls)++;
@@ -179,7 +191,7 @@ int __kprobes __atomic_notifier_call_chain(struct atomic_notifier_head *nh,
 	int ret;
 
 	rcu_read_lock();
-	ret = notifier_call_chain(&nh->head, val, v, nr_to_call, nr_calls);
+	ret = notifier_call_chain(&nh->head, val, v, nr_to_call, nr_calls, nh);
 	rcu_read_unlock();
 	return ret;
 }
@@ -312,7 +324,7 @@ int __blocking_notifier_call_chain(struct blocking_notifier_head *nh,
 	if (rcu_dereference(nh->head)) {
 		down_read(&nh->rwsem);
 		ret = notifier_call_chain(&nh->head, val, v, nr_to_call,
-					nr_calls);
+					nr_calls, nh);
 		up_read(&nh->rwsem);
 	}
 	return ret;
@@ -388,7 +400,8 @@ int __raw_notifier_call_chain(struct raw_notifier_head *nh,
 			      unsigned long val, void *v,
 			      int nr_to_call, int *nr_calls)
 {
-	return notifier_call_chain(&nh->head, val, v, nr_to_call, nr_calls);
+	return notifier_call_chain(&nh->head, val, v, nr_to_call, nr_calls,
+									nh);
 }
 EXPORT_SYMBOL_GPL(__raw_notifier_call_chain);
 
@@ -491,7 +504,7 @@ int __srcu_notifier_call_chain(struct srcu_notifier_head *nh,
 	int idx;
 
 	idx = srcu_read_lock(&nh->srcu);
-	ret = notifier_call_chain(&nh->head, val, v, nr_to_call, nr_calls);
+	ret = notifier_call_chain(&nh->head, val, v, nr_to_call, nr_calls, nh);
 	srcu_read_unlock(&nh->srcu, idx);
 	return ret;
 }

