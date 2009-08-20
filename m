Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbZHTBbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbZHTBbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 21:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbZHTBby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 21:31:54 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48109 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbZHTBby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 21:31:54 -0400
Date: Wed, 19 Aug 2009 18:31:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, mingo@elte.hu, josht@linux.vnet.ibm.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, hugh.dickins@tiscali.co.uk,
       benh@kernel.crashing.org
Subject: [PATCH -tip/core/rcu] Fix rcu_migrate_callback() to allow for
	multiple waiters
Message-ID: <20090820013153.GA19944@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current interaction between rcu_barrier() and CPU hotplug can result
in multiple tasks waiting on rcu_migrate_wq: there can be one CPU-hotplug
notifier, and, because rcu_barrier() invokes wait_migrated_callbacks()
outside of rcu_barrier_mutex, an arbitrarily large number of tasks
executing in _rcu_barrier().  This situation could result in hangs,
because rcu_migrate_callback() would wake up but one task.

This patch addresses this problem by awakening all sleepers.

Located-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcupdate.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index bd5d5c8..6c59e1b 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -211,10 +211,17 @@ void rcu_barrier_sched(void)
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_sched);
 
+/*
+ * Wake up anyone waiting on migration of RCU callbacks from a CPU
+ * going offline.  There can be only one CPU-hotplug notifier waiting,
+ * but there can be any number of rcu_barrier() invocations waiting,
+ * due to the fact that rcu_barrier() does its wait outside of the
+ * rcu_barrier_mutex.
+ */
 static void rcu_migrate_callback(struct rcu_head *notused)
 {
 	if (atomic_dec_and_test(&rcu_migrate_type_count))
-		wake_up(&rcu_migrate_wq);
+		wake_up_all(&rcu_migrate_wq);
 }
 
 extern int rcu_cpu_notify(struct notifier_block *self,
