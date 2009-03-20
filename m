Return-Path: <linux-kernel-owner+w=401wt.eu-S1760244AbZCTUBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760244AbZCTUBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 16:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760159AbZCTUBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 16:01:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:53289 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760006AbZCTUBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 16:01:00 -0400
Date: Fri, 20 Mar 2009 20:00:23 GMT
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <49C36476.1010400@cn.fujitsu.com>
References: <49C36476.1010400@cn.fujitsu.com>
Subject: [tip:core/rcu] rcu: rcu_barrier VS cpu_hotplug: Ensure callbacks in dead cpu are migrated to online cpu
Message-ID: <tip-04cb9ac11ba898049c99dc67ede6e68f6d700dee@git.kernel.org>
Git-Commit-ID: 04cb9ac11ba898049c99dc67ede6e68f6d700dee
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 20:00:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  04cb9ac11ba898049c99dc67ede6e68f6d700dee
Gitweb:     http://git.kernel.org/tip/04cb9ac11ba898049c99dc67ede6e68f6d700dee
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Fri, 20 Mar 2009 17:40:06 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 19:37:33 +0100

rcu: rcu_barrier VS cpu_hotplug: Ensure callbacks in dead cpu are migrated to online cpu

cpu hotplug may happen asynchronously, some rcu callbacks are maybe
still on dead cpu, rcu_barrier() also needs to wait for these rcu
callbacks to complete, so we must ensure callbacks in dead cpu are
migrated to online cpu.

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
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <49C36476.1010400@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/rcupdate.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

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
