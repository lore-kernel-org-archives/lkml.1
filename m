Return-Path: <linux-kernel-owner+w=401wt.eu-S933294AbZHVLea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294AbZHVLea (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 07:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933248AbZHVLea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 07:34:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:43676 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933163AbZHVLe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 07:34:29 -0400
Date: Sat, 22 Aug 2009 11:33:45 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090822050851.GA8414@linux.vnet.ibm.com>
References: <20090822050851.GA8414@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Expunge lingering references to CONFIG_CLASSIC_RCU, optimize on !SMP
Message-ID: <tip-b560d8ad8583803978aaaeba50ef29dc8e97a610@git.kernel.org>
Git-Commit-ID: b560d8ad8583803978aaaeba50ef29dc8e97a610
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 22 Aug 2009 11:33:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b560d8ad8583803978aaaeba50ef29dc8e97a610
Gitweb:     http://git.kernel.org/tip/b560d8ad8583803978aaaeba50ef29dc8e97a610
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Fri, 21 Aug 2009 22:08:51 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 22 Aug 2009 13:07:09 +0200

rcu: Expunge lingering references to CONFIG_CLASSIC_RCU, optimize on !SMP

A couple of references to CONFIG_CLASSIC_RCU have survived.
Although these are harmless, it is past time for them to go.
The one in hardirq.h is strictly a readability problem.

The two in pagemap.h appear to disable a !SMP performance
optimization (which this patch re-enables).

This does raise the issue as to whether pagemap.h should really
be referring to the CPU implementation.  Long term, I intend to
make the RCU implementation driven by CONFIG_PREEMPT, at which
point these should change from defined(CONFIG_TREE_RCU) to
!defined(CONFIG_PREEMPT). In the meantime, is there something
else that could be done in pagemap.h?

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josht@linux.vnet.ibm.com
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
LKML-Reference: <20090822050851.GA8414@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/hardirq.h |    4 ++--
 include/linux/pagemap.h |    4 ++--
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
