Return-Path: <linux-kernel-owner+w=401wt.eu-S1762352AbZCYPTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762352AbZCYPTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 11:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757265AbZCYPT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 11:19:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:58362 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200AbZCYPT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:19:27 -0400
Date: Wed, 25 Mar 2009 15:18:28 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237898630.25315.83.camel@penberg-laptop>
References: <1237898630.25315.83.camel@penberg-laptop>
Subject: [tip:tracing/kmemtrace] RCU, kmemtrace: fix linux/rcutree.h and linux/rcuclassic.h dependencies
Message-ID: <tip-e03b679cfb1ef2270282525fc006be1b183a1e07@git.kernel.org>
Git-Commit-ID: e03b679cfb1ef2270282525fc006be1b183a1e07
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 15:18:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e03b679cfb1ef2270282525fc006be1b183a1e07
Gitweb:     http://git.kernel.org/tip/e03b679cfb1ef2270282525fc006be1b183a1e07
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 13 Mar 2009 03:20:49 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 17:13:40 +0100

RCU, kmemtrace: fix linux/rcutree.h and linux/rcuclassic.h dependencies

Impact: build fix for all non-x86 architectures

The recent removal of percpu.h from rcuclassic.h/rcutree.h broke
the DECLARE_PER_CPU declarations in these files.

Move the quiescent counter management functions to their respective
RCU implementation .c files - they were slightly above the inlining
limit anyway.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: paulmck@linux.vnet.ibm.com
LKML-Reference: <1237898630.25315.83.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/rcuclassic.h |   15 ++-------------
 include/linux/rcutree.h    |   26 ++------------------------
 kernel/rcuclassic.c        |   23 +++++++++++++++++++++--
 kernel/rcutree.c           |   28 ++++++++++++++++++++++++----
 4 files changed, 49 insertions(+), 43 deletions(-)

diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index cc3f723..bfd92e1 100644
--- a/include/linux/rcuclassic.h
+++ b/include/linux/rcuclassic.h
@@ -107,25 +107,14 @@ struct rcu_data {
 	struct rcu_head barrier;
 };
 
-DECLARE_PER_CPU(struct rcu_data, rcu_data);
-DECLARE_PER_CPU(struct rcu_data, rcu_bh_data);
-
 /*
  * Increment the quiescent state counter.
  * The counter is a bit degenerated: We do not need to know
  * how many quiescent states passed, just if there was at least
  * one since the start of the grace period. Thus just a flag.
  */
-static inline void rcu_qsctr_inc(int cpu)
-{
-	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
-	rdp->passed_quiesc = 1;
-}
-static inline void rcu_bh_qsctr_inc(int cpu)
-{
-	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
-	rdp->passed_quiesc = 1;
-}
+extern void rcu_qsctr_inc(int cpu);
+extern void rcu_bh_qsctr_inc(int cpu);
 
 extern int rcu_pending(int cpu);
 extern int rcu_needs_cpu(int cpu);
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index a26b4f1..0cdda00 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -235,30 +235,8 @@ struct rcu_state {
 #endif /* #ifdef CONFIG_NO_HZ */
 };
 
-extern struct rcu_state rcu_state;
-DECLARE_PER_CPU(struct rcu_data, rcu_data);
-
-extern struct rcu_state rcu_bh_state;
-DECLARE_PER_CPU(struct rcu_data, rcu_bh_data);
-
-/*
- * Increment the quiescent state counter.
- * The counter is a bit degenerated: We do not need to know
- * how many quiescent states passed, just if there was at least
- * one since the start of the grace period. Thus just a flag.
- */
-static inline void rcu_qsctr_inc(int cpu)
-{
-	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
-	rdp->passed_quiesc = 1;
-	rdp->passed_quiesc_completed = rdp->completed;
-}
-static inline void rcu_bh_qsctr_inc(int cpu)
-{
-	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
-	rdp->passed_quiesc = 1;
-	rdp->passed_quiesc_completed = rdp->completed;
-}
+extern void rcu_qsctr_inc(int cpu);
+extern void rcu_bh_qsctr_inc(int cpu);
 
 extern int rcu_pending(int cpu);
 extern int rcu_needs_cpu(int cpu);
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index 654c640..0f2b0b3 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -65,6 +65,7 @@ static struct rcu_ctrlblk rcu_ctrlblk = {
 	.lock = __SPIN_LOCK_UNLOCKED(&rcu_ctrlblk.lock),
 	.cpumask = CPU_BITS_NONE,
 };
+
 static struct rcu_ctrlblk rcu_bh_ctrlblk = {
 	.cur = -300,
 	.completed = -300,
@@ -73,8 +74,26 @@ static struct rcu_ctrlblk rcu_bh_ctrlblk = {
 	.cpumask = CPU_BITS_NONE,
 };
 
-DEFINE_PER_CPU(struct rcu_data, rcu_data) = { 0L };
-DEFINE_PER_CPU(struct rcu_data, rcu_bh_data) = { 0L };
+static DEFINE_PER_CPU(struct rcu_data, rcu_data);
+static DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
+
+/*
+ * Increment the quiescent state counter.
+ * The counter is a bit degenerated: We do not need to know
+ * how many quiescent states passed, just if there was at least
+ * one since the start of the grace period. Thus just a flag.
+ */
+void rcu_qsctr_inc(int cpu)
+{
+	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
+	rdp->passed_quiesc = 1;
+}
+
+void rcu_bh_qsctr_inc(int cpu)
+{
+	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
+	rdp->passed_quiesc = 1;
+}
 
 static int blimit = 10;
 static int qhimark = 10000;
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 97ce315..a2015ed 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -72,11 +72,31 @@ EXPORT_SYMBOL_GPL(rcu_lock_map);
 	.n_force_qs_ngp = 0, \
 }
 
-struct rcu_state rcu_state = RCU_STATE_INITIALIZER(rcu_state);
-DEFINE_PER_CPU(struct rcu_data, rcu_data);
+static struct rcu_state rcu_state = RCU_STATE_INITIALIZER(rcu_state);
+static DEFINE_PER_CPU(struct rcu_data, rcu_data);
 
-struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
-DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
+static struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
+static DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
+
+/*
+ * Increment the quiescent state counter.
+ * The counter is a bit degenerated: We do not need to know
+ * how many quiescent states passed, just if there was at least
+ * one since the start of the grace period. Thus just a flag.
+ */
+void rcu_qsctr_inc(int cpu)
+{
+	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
+	rdp->passed_quiesc = 1;
+	rdp->passed_quiesc_completed = rdp->completed;
+}
+
+void rcu_bh_qsctr_inc(int cpu)
+{
+	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
+	rdp->passed_quiesc = 1;
+	rdp->passed_quiesc_completed = rdp->completed;
+}
 
 #ifdef CONFIG_NO_HZ
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
