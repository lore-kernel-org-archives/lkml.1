Return-Path: <linux-kernel-owner+w=401wt.eu-S1761846AbZDCKhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761846AbZDCKhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763634AbZDCKgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:36:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:42869 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763647AbZDCKgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:36:47 -0400
Date: Fri, 3 Apr 2009 10:35:59 GMT
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
Subject: [tip:tracing/kmemtrace-v2] kmemtrace, rcu: fix linux/rcutree.h and linux/rcuclassic.h dependencies
Message-ID: <tip-b1f77b0581b8fd837acb4a973f7d5496cae6efee@git.kernel.org>
Git-Commit-ID: b1f77b0581b8fd837acb4a973f7d5496cae6efee
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Apr 2009 10:36:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b1f77b0581b8fd837acb4a973f7d5496cae6efee
Gitweb:     http://git.kernel.org/tip/b1f77b0581b8fd837acb4a973f7d5496cae6efee
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 13 Mar 2009 03:20:49 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Apr 2009 12:23:02 +0200

kmemtrace, rcu: fix linux/rcutree.h and linux/rcuclassic.h dependencies

Impact: build fix for all non-x86 architectures

We want to remove percpu.h from rcuclassic.h/rcutree.h (for upcoming
kmemtrace changes) but that would break the DECLARE_PER_CPU based
declarations in these files.

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
index 80044a4..2d688b4 100644
--- a/include/linux/rcuclassic.h
+++ b/include/linux/rcuclassic.h
@@ -108,25 +108,14 @@ struct rcu_data {
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
index a722fb6..5d6f425 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -236,30 +236,8 @@ struct rcu_state {
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
