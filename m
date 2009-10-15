Return-Path: <linux-kernel-owner+w=401wt.eu-S933970AbZJOJ0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970AbZJOJ0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933205AbZJOJ0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:26:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:45708 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932361AbZJOJ0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:26:30 -0400
Date: Thu, 15 Oct 2009 09:25:07 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12555405592331-git-send-email->
References: <12555405592331-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Stopgap fix for synchronize_rcu_expedited() for TREE_PREEMPT_RCU
Message-ID: <tip-019129d595caaa5bd0b41d128308da1be6a91869@git.kernel.org>
Git-Commit-ID: 019129d595caaa5bd0b41d128308da1be6a91869
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 09:25:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  019129d595caaa5bd0b41d128308da1be6a91869
Gitweb:     http://git.kernel.org/tip/019129d595caaa5bd0b41d128308da1be6a91869
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 14 Oct 2009 10:15:56 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Oct 2009 11:17:17 +0200

rcu: Stopgap fix for synchronize_rcu_expedited() for TREE_PREEMPT_RCU

For the short term, map synchronize_rcu_expedited() to
synchronize_rcu() for TREE_PREEMPT_RCU and to
synchronize_sched_expedited() for TREE_RCU.

Longer term, there needs to be a real expedited grace period for
TREE_PREEMPT_RCU, but candidate patches to date are considerably
more complex and intrusive.

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
Cc: npiggin@suse.de
Cc: jens.axboe@oracle.com
LKML-Reference: <12555405592331-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/rcutree.h |    6 +-----
 kernel/rcutree_plugin.h |   21 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 46e9ab3..9642c6b 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -76,11 +76,7 @@ static inline void __rcu_read_unlock_bh(void)
 
 extern void call_rcu_sched(struct rcu_head *head,
 			   void (*func)(struct rcu_head *rcu));
-
-static inline void synchronize_rcu_expedited(void)
-{
-	synchronize_sched_expedited();
-}
+extern void synchronize_rcu_expedited(void);
 
 static inline void synchronize_rcu_bh_expedited(void)
 {
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c0cb783..ebd20ee 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -393,6 +393,17 @@ void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 EXPORT_SYMBOL_GPL(call_rcu);
 
 /*
+ * Wait for an rcu-preempt grace period.  We are supposed to expedite the
+ * grace period, but this is the crude slow compatability hack, so just
+ * invoke synchronize_rcu().
+ */
+void synchronize_rcu_expedited(void)
+{
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
+
+/*
  * Check to see if there is any immediate preemptable-RCU-related work
  * to be done.
  */
@@ -565,6 +576,16 @@ void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 EXPORT_SYMBOL_GPL(call_rcu);
 
 /*
+ * Wait for an rcu-preempt grace period, but make it happen quickly.
+ * But because preemptable RCU does not exist, map to rcu-sched.
+ */
+void synchronize_rcu_expedited(void)
+{
+	synchronize_sched_expedited();
+}
+EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
+
+/*
  * Because preemptable RCU does not exist, it never has any work to do.
  */
 static int rcu_preempt_pending(int cpu)
