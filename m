Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab0APJpr (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 04:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866Ab0APJpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 04:45:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:54280 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270Ab0APJpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 04:45:43 -0500
Date: Sat, 16 Jan 2010 09:45:01 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12635142581560-git-send-email->
References: <12635142581560-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Fix sparse warnings
Message-ID: <tip-017c426138122c8e9b9f5057fbd0567c37b35247@git.kernel.org>
Git-Commit-ID: 017c426138122c8e9b9f5057fbd0567c37b35247
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 16 Jan 2010 09:45:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  017c426138122c8e9b9f5057fbd0567c37b35247
Gitweb:     http://git.kernel.org/tip/017c426138122c8e9b9f5057fbd0567c37b35247
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Thu, 14 Jan 2010 16:10:58 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 16 Jan 2010 10:25:22 +0100

rcu: Fix sparse warnings

Rename local variable "i" in rcu_init() to avoid conflict with
RCU_INIT_FLAVOR(), restrict the scope of RCU_TREE_NONCORE, and
make __synchronize_srcu() static.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <12635142581560-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c |    6 +++---
 kernel/rcutree.h |    6 ++----
 kernel/srcu.c    |    2 +-
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 3b13d64..099a255 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1888,7 +1888,7 @@ do { \
 
 void __init rcu_init(void)
 {
-	int i;
+	int cpu;
 
 	rcu_bootup_announce();
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
@@ -1908,8 +1908,8 @@ void __init rcu_init(void)
 	 * or the scheduler are operational.
 	 */
 	cpu_notifier(rcu_cpu_notify, 0);
-	for_each_online_cpu(i)
-		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)i);
+	for_each_online_cpu(cpu)
+		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
 }
 
 #include "rcutree_plugin.h"
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index bd5d78a..d9d032a 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -323,8 +323,6 @@ struct rcu_state {
 #define RCU_OFL_TASKS_EXP_GP	0x2		/* Tasks blocking expedited */
 						/*  GP were moved to root. */
 
-#ifdef RCU_TREE_NONCORE
-
 /*
  * RCU implementation internal declarations:
  */
@@ -339,7 +337,7 @@ extern struct rcu_state rcu_preempt_state;
 DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
-#else /* #ifdef RCU_TREE_NONCORE */
+#ifndef RCU_TREE_NONCORE
 
 /* Forward declarations for rcutree_plugin.h */
 static void rcu_bootup_announce(void);
@@ -372,4 +370,4 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
 static void rcu_preempt_send_cbs_to_orphanage(void);
 static void __init __rcu_init_preempt(void);
 
-#endif /* #else #ifdef RCU_TREE_NONCORE */
+#endif /* #ifndef RCU_TREE_NONCORE */
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 818d7d9..31b275b 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -144,7 +144,7 @@ EXPORT_SYMBOL_GPL(srcu_read_unlock);
 /*
  * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
  */
-void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
+static void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
 {
 	int idx;
 
