Return-Path: <linux-kernel-owner+w=401wt.eu-S1757882AbZCaMnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882AbZCaMnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 08:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756881AbZCaMn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 08:43:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47012 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749AbZCaMn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 08:43:28 -0400
Date: Tue, 31 Mar 2009 14:43:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: [GIT PULL] RCU updates for v2.6.30
Message-ID: <20090331124315.GA6658@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest rcu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rcu-for-linus

A quiet RCU cycle. No known regressions.

 Thanks,

	Ingo

------------------>
Lai Jiangshan (1):
      rcu: rcu_barrier VS cpu_hotplug: Ensure callbacks in dead cpu are migrated to online cpu


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
