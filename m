Return-Path: <linux-kernel-owner+w=401wt.eu-S932636AbZHVFJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636AbZHVFJE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 01:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932302AbZHVFJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 01:09:03 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35831 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932294AbZHVFJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 01:09:02 -0400
Date: Fri, 21 Aug 2009 22:08:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org
Subject: [PATCH -tip/core/rcu] expunge lingering references to
	CONFIG_CLASSIC_RCU
Message-ID: <20090822050851.GA8414@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of references to CONFIG_CLASSIC_RCU have survived.  Although
these are harmless, it is past time for them to go.  The one in hardirq.h
is strictly a readability problem.  The two in pagemap.h appear to disable
a !SMP performance optimization (which this patch re-enables).

This does raise the issue as to whether pagemap.h should really be
referring to the CPU implementation.  Long term, I intend to make
the RCU implementation driven by CONFIG_PREEMPT, at which point these
should change from defined(CONFIG_TREE_RCU) to !defined(CONFIG_PREEMPT).
In the meantime, is there something else that could be done in
pagemap.h?

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 hardirq.h |    4 ++--
 pagemap.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 8246c69..330cb31 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -132,7 +132,7 @@ static inline void account_system_vtime(struct task_struct *tsk)
 }
 #endif
 
-#if defined(CONFIG_NO_HZ) && !defined(CONFIG_CLASSIC_RCU)
+#if defined(CONFIG_NO_HZ)
 extern void rcu_irq_enter(void);
 extern void rcu_irq_exit(void);
 extern void rcu_nmi_enter(void);
@@ -142,7 +142,7 @@ extern void rcu_nmi_exit(void);
 # define rcu_irq_exit() do { } while (0)
 # define rcu_nmi_enter() do { } while (0)
 # define rcu_nmi_exit() do { } while (0)
-#endif /* #if defined(CONFIG_NO_HZ) && !defined(CONFIG_CLASSIC_RCU) */
+#endif /* #if defined(CONFIG_NO_HZ) */
 
 /*
  * It is safe to do non-atomic ops on ->hardirq_context,
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index aec3252..ed5d750 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -132,7 +132,7 @@ static inline int page_cache_get_speculative(struct page *page)
 {
 	VM_BUG_ON(in_interrupt());
 
-#if !defined(CONFIG_SMP) && defined(CONFIG_CLASSIC_RCU)
+#if !defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)
 # ifdef CONFIG_PREEMPT
 	VM_BUG_ON(!in_atomic());
 # endif
@@ -170,7 +170,7 @@ static inline int page_cache_add_speculative(struct page *page, int count)
 {
 	VM_BUG_ON(in_interrupt());
 
-#if !defined(CONFIG_SMP) && defined(CONFIG_CLASSIC_RCU)
+#if !defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)
 # ifdef CONFIG_PREEMPT
 	VM_BUG_ON(!in_atomic());
 # endif
