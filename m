Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab0CDQf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:35:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:46507 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384Ab0CDQf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:35:27 -0500
Date: Thu, 4 Mar 2010 16:33:23 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267631219-8713-2-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1267631219-8713-2-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Suppress RCU lockdep warnings during early boot
Message-ID: <tip-54dbf96c921513bf98484a20ef366d51944a4c4d@git.kernel.org>
Git-Commit-ID: 54dbf96c921513bf98484a20ef366d51944a4c4d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Mar 2010 16:33:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54dbf96c921513bf98484a20ef366d51944a4c4d
Gitweb:     http://git.kernel.org/tip/54dbf96c921513bf98484a20ef366d51944a4c4d
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 3 Mar 2010 07:46:57 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Mar 2010 12:09:19 +0100

rcu: Suppress RCU lockdep warnings during early boot

RCU is used during very early boot, before RCU and lockdep have
been initialized.  So make the underlying primitives
(rcu_read_lock_held(), rcu_read_lock_bh_held(),
rcu_read_lock_sched_held(), and rcu_dereference_check()) check
for early boot via the rcu_scheduler_active flag.  This will
suppress false positives.

Also introduce a debug_lockdep_rcu_enabled() static inline
helper function, which tags the CONTINUE_PROVE_RCU case as
likely(), as suggested by Ingo Molnar.

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
LKML-Reference: <1267631219-8713-2-git-send-email-paulmck@linux.vnet.ibm.com>
[ v2: removed incomplete debug_lockdep_rcu_update() bits ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/rcupdate.h |   31 ++++++++++++++++++++++---------
 1 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index e22960e..75921b8 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -97,6 +97,11 @@ extern struct lockdep_map rcu_sched_lock_map;
 # define rcu_read_release_sched() \
 		lock_release(&rcu_sched_lock_map, 1, _THIS_IP_)
 
+static inline int debug_lockdep_rcu_enabled(void)
+{
+	return likely(rcu_scheduler_active && debug_locks);
+}
+
 /**
  * rcu_read_lock_held - might we be in RCU read-side critical section?
  *
@@ -104,12 +109,14 @@ extern struct lockdep_map rcu_sched_lock_map;
  * an RCU read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
  * this assumes we are in an RCU read-side critical section unless it can
  * prove otherwise.
+ *
+ * Check rcu_scheduler_active to prevent false positives during boot.
  */
 static inline int rcu_read_lock_held(void)
 {
-	if (debug_locks)
-		return lock_is_held(&rcu_lock_map);
-	return 1;
+	if (!debug_lockdep_rcu_enabled())
+		return 1;
+	return lock_is_held(&rcu_lock_map);
 }
 
 /**
@@ -119,12 +126,14 @@ static inline int rcu_read_lock_held(void)
  * an RCU-bh read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
  * this assumes we are in an RCU-bh read-side critical section unless it can
  * prove otherwise.
+ *
+ * Check rcu_scheduler_active to prevent false positives during boot.
  */
 static inline int rcu_read_lock_bh_held(void)
 {
-	if (debug_locks)
-		return lock_is_held(&rcu_bh_lock_map);
-	return 1;
+	if (!debug_lockdep_rcu_enabled())
+		return 1;
+	return lock_is_held(&rcu_bh_lock_map);
 }
 
 /**
@@ -135,15 +144,19 @@ static inline int rcu_read_lock_bh_held(void)
  * this assumes we are in an RCU-sched read-side critical section unless it
  * can prove otherwise.  Note that disabling of preemption (including
  * disabling irqs) counts as an RCU-sched read-side critical section.
+ *
+ * Check rcu_scheduler_active to prevent false positives during boot.
  */
 #ifdef CONFIG_PREEMPT
 static inline int rcu_read_lock_sched_held(void)
 {
 	int lockdep_opinion = 0;
 
+	if (!debug_lockdep_rcu_enabled())
+		return 1;
 	if (debug_locks)
 		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
-	return lockdep_opinion || preempt_count() != 0 || !rcu_scheduler_active;
+	return lockdep_opinion || preempt_count() != 0;
 }
 #else /* #ifdef CONFIG_PREEMPT */
 static inline int rcu_read_lock_sched_held(void)
@@ -174,7 +187,7 @@ static inline int rcu_read_lock_bh_held(void)
 #ifdef CONFIG_PREEMPT
 static inline int rcu_read_lock_sched_held(void)
 {
-	return preempt_count() != 0 || !rcu_scheduler_active;
+	return !rcu_scheduler_active || preempt_count() != 0;
 }
 #else /* #ifdef CONFIG_PREEMPT */
 static inline int rcu_read_lock_sched_held(void)
@@ -198,7 +211,7 @@ static inline int rcu_read_lock_sched_held(void)
  */
 #define rcu_dereference_check(p, c) \
 	({ \
-		if (debug_locks && !(c)) \
+		if (debug_lockdep_rcu_enabled() && !(c)) \
 			lockdep_rcu_dereference(__FILE__, __LINE__); \
 		rcu_dereference_raw(p); \
 	})
