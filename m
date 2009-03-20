Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbZCTJln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbZCTJln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 05:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbZCTJld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 05:41:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50201 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbZCTJlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 05:41:32 -0400
Message-ID: <49C36476.1010400@cn.fujitsu.com>
Date: Fri, 20 Mar 2009 17:40:06 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu_barrier VS cpu_hotplug: Ensure callbacks in dead
 cpu are migrated to online cpu
References: <49B2526E.40106@cn.fujitsu.com> <20090308160005.GE19658@elte.hu> <49C1B6BF.5090702@cn.fujitsu.com> <20090319040503.GA7117@linux.vnet.ibm.com> <20090319082237.GA32179@elte.hu>
In-Reply-To: <20090319082237.GA32179@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> Lai, would you mind to resend the full patch with an updated 
> changelog tha adds Paul's review tag, against latest -tip?
>

Subject: [PATCH -tip] rcu_barrier VS cpu_hotplug: Ensure callbacks in dead cpu are migrated to online cpu (V2)

cpu hotplug may be happened asynchronously, some rcu callbacks are maybe
still in dead cpu, rcu_barrier() also needs to wait for these rcu callbacks
to complete, so we must ensure callbacks in dead cpu are migrated to
online cpu.

Paul E. McKenney's review:

  Good stuff, Lai!!!  Simpler than any of the approaches that I was
  considering, and, better yet, independent of the underlying RCU
  implementation!!!

  I was initially worried that wake_up() might wake only one of two
  possible wait_event()s, namely rcu_barrier() and the CPU_POST_DEAD code,
  but the fact that wait_event() clears WQ_FLAG_EXCLUSIVE avoids that issue.
  I was also worried about the fact that different RCU implementations have
  different mappings of call_rcu(), call_rcu_bh(), and call_rcu_sched(), but
  this is OK as well because we just get an extra (harmless) callback in the
  case that they map together (for example, Classic RCU has call_rcu_sched()
  mapping to call_rcu()).

  Overlap of CPU-hotplug operations is prevented by cpu_add_remove_lock,
  and any stray callbacks that arrive (for example, from irq handlers
  running on the dying CPU) either are ahead of the CPU_DYING callbacks on
  the one hand (and thus accounted for), or happened after the rcu_barrier()
  started on the other (and thus don't need to be accounted for).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index cae8a05..2c7b845 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -122,6 +122,8 @@ static void rcu_barrier_func(void *type)
 	}
 }
 
+static inline void wait_migrated_callbacks(void);
+
 /*
  * Orchestrate the specified type of RCU barrier, waiting for all
  * RCU callbacks of the specified type to complete.
@@ -147,6 +149,7 @@ static void _rcu_barrier(enum rcu_barrier type)
 		complete(&rcu_barrier_completion);
 	wait_for_completion(&rcu_barrier_completion);
 	mutex_unlock(&rcu_barrier_mutex);
+	wait_migrated_callbacks();
 }
 
 /**
@@ -176,9 +179,50 @@ void rcu_barrier_sched(void)
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_sched);
 
+static atomic_t rcu_migrate_type_count = ATOMIC_INIT(0);
+static struct rcu_head rcu_migrate_head[3];
+static DECLARE_WAIT_QUEUE_HEAD(rcu_migrate_wq);
+
+static void rcu_migrate_callback(struct rcu_head *notused)
+{
+	if (atomic_dec_and_test(&rcu_migrate_type_count))
+		wake_up(&rcu_migrate_wq);
+}
+
+static inline void wait_migrated_callbacks(void)
+{
+	wait_event(rcu_migrate_wq, !atomic_read(&rcu_migrate_type_count));
+}
+
+static int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
+		unsigned long action, void *hcpu)
+{
+	if (action == CPU_DYING) {
+		/*
+		 * preempt_disable() in on_each_cpu() prevents stop_machine(),
+		 * so when "on_each_cpu(rcu_barrier_func, (void *)type, 1);"
+		 * returns, all online cpus have queued rcu_barrier_func(),
+		 * and the dead cpu(if it exist) queues rcu_migrate_callback()s.
+		 *
+		 * These callbacks ensure _rcu_barrier() waits for all
+		 * RCU callbacks of the specified type to complete.
+		 */
+		atomic_set(&rcu_migrate_type_count, 3);
+		call_rcu_bh(rcu_migrate_head, rcu_migrate_callback);
+		call_rcu_sched(rcu_migrate_head + 1, rcu_migrate_callback);
+		call_rcu(rcu_migrate_head + 2, rcu_migrate_callback);
+	} else if (action == CPU_POST_DEAD) {
+		/* rcu_migrate_head is protected by cpu_add_remove_lock */
+		wait_migrated_callbacks();
+	}
+
+	return NOTIFY_OK;
+}
+
 void __init rcu_init(void)
 {
 	__rcu_init();
+	hotcpu_notifier(rcu_barrier_cpu_hotplug, 0);
 }
 
 void rcu_scheduler_starting(void)

