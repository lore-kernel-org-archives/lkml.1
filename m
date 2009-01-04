Return-Path: <linux-kernel-owner+w=401wt.eu-S1757698AbZADVDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698AbZADVDU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 16:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZADVDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 16:03:10 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34850 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbZADVDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 16:03:06 -0500
Date: Sun, 4 Jan 2009 13:03:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       laijs@cn.fujitsu.com, manfred@colorfullife.com
Subject: [PATCH -tip] Eliminate synchronize_rcu_xxx macro
Message-ID: <20090104210302.GR6958@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expand macro into two files.

The synchronize_rcu_xxx macro is quite ugly and it's only used by two
callers, so expand it instead.  This makes this code easier to change.

Ingo, could you please include into tip/core/rcu?

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 1168fbc..921340a 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -204,18 +204,6 @@ struct rcu_synchronize {

 extern void wakeme_after_rcu(struct rcu_head  *head);

-#define synchronize_rcu_xxx(name, func) \
-void name(void) \
-{ \
-	struct rcu_synchronize rcu; \
-	\
-	init_completion(&rcu.completion); \
-	/* Will wake me after RCU finished. */ \
-	func(&rcu.head, wakeme_after_rcu); \
-	/* Wait for it. */ \
-	wait_for_completion(&rcu.completion); \
-}
-
 /**
  * synchronize_sched - block until all CPUs have exited any non-preemptive
  * kernel code sequences.
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index ad63af8..d92a76a 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -77,8 +77,15 @@ void wakeme_after_rcu(struct rcu_head  *head)
  * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
  * and may be nested.
  */
-void synchronize_rcu(void);	/* Makes kernel-doc tools happy */
-synchronize_rcu_xxx(synchronize_rcu, call_rcu)
+void synchronize_rcu(void)
+{
+	struct rcu_synchronize rcu;
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	call_rcu(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+}
 EXPORT_SYMBOL_GPL(synchronize_rcu);

 static void rcu_barrier_callback(struct rcu_head *notused)
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 0498265..77fa728 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -1176,7 +1176,16 @@ EXPORT_SYMBOL_GPL(call_rcu_sched);
  * in -rt this does -not- necessarily result in all currently executing
  * interrupt -handlers- having completed.
  */
-synchronize_rcu_xxx(__synchronize_sched, call_rcu_sched)
+void __synchronize_sched(void)
+{
+	struct rcu_synchronize rcu;
+
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	call_rcu_sched(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+}
 EXPORT_SYMBOL_GPL(__synchronize_sched);

 /*
-- 
ak@linux.intel.com

----- End forwarded message -----
