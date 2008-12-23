Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbYLWWGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbYLWWGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 17:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbYLWWGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 17:06:41 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56169 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbYLWWGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 17:06:39 -0500
Date: Tue, 23 Dec 2008 14:06:48 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org,
       ralf@linux-mips.org, kernel@wantstofly.org, hskinnemoen@atmel.com,
       cooloney@kernel.org, tony.luck@intel.com, geert@linux-m68k.org,
       zippel@linux-m68k.org, jwboyer@linux.vnet.ibm.com,
       mporter@kernel.crashing.org, grant.likely@secretlab.ca,
       paulus@samba.org, benh@kernel.crashing.org, dhowells@redhat.com,
       yasutake.koichi@jp.panasonic.com, lethal@linux-sh.org, hpa@zytor.com
Subject: [PATCH, -tip] Make hierarchical RCU be the default
Message-ID: <20081223220648.GB16472@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1229991147545-git-send-email-paulmck@linux.vnet.ibm.com> <12299911471985-git-send-email-paulmck@linux.vnet.ibm.com> <20081223142542.GC29151@elte.hu> <20081223215948.GA16137@linux.vnet.ibm.com> <20081223220345.GA16472@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081223220345.GA16472@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the new TREE_RCU be the default, pointing the old
CLASSIC_RCU Kconfig symbol at it and introducing a new FLAT_RCU symbol
to allow the old version to be selected.

This patch is -not- yet suitable for inclusion, only for testing in
-tip, -next, and the like.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/hardirq.h  |    4 ++--
 include/linux/pagemap.h  |    4 ++--
 include/linux/rcupdate.h |    4 ++--
 kernel/Kconfig.preempt   |   19 +++++++++++++++----
 kernel/Makefile          |    2 +-
 lib/Kconfig.debug        |    2 +-
 6 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 9b70b92..0afd180 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -118,7 +118,7 @@ static inline void account_system_vtime(struct task_struct *tsk)
 }
 #endif
 
-#if defined(CONFIG_NO_HZ) && !defined(CONFIG_CLASSIC_RCU)
+#if defined(CONFIG_NO_HZ) && !defined(CONFIG_FLAT_RCU)
 extern void rcu_irq_enter(void);
 extern void rcu_irq_exit(void);
 extern void rcu_nmi_enter(void);
@@ -128,7 +128,7 @@ extern void rcu_nmi_exit(void);
 # define rcu_irq_exit() do { } while (0)
 # define rcu_nmi_enter() do { } while (0)
 # define rcu_nmi_exit() do { } while (0)
-#endif /* #if defined(CONFIG_NO_HZ) && !defined(CONFIG_CLASSIC_RCU) */
+#endif /* #if defined(CONFIG_NO_HZ) && !defined(CONFIG_FLAT_RCU) */
 
 /*
  * It is safe to do non-atomic ops on ->hardirq_context,
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 709742b..5cfb133 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -140,7 +140,7 @@ static inline int page_cache_get_speculative(struct page *page)
 {
 	VM_BUG_ON(in_interrupt());
 
-#if !defined(CONFIG_SMP) && defined(CONFIG_CLASSIC_RCU)
+#if !defined(CONFIG_SMP) && defined(CONFIG_FLAT_RCU)
 # ifdef CONFIG_PREEMPT
 	VM_BUG_ON(!in_atomic());
 # endif
@@ -178,7 +178,7 @@ static inline int page_cache_add_speculative(struct page *page, int count)
 {
 	VM_BUG_ON(in_interrupt());
 
-#if !defined(CONFIG_SMP) && defined(CONFIG_CLASSIC_RCU)
+#if !defined(CONFIG_SMP) && defined(CONFIG_FLAT_RCU)
 # ifdef CONFIG_PREEMPT
 	VM_BUG_ON(!in_atomic());
 # endif
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index bfd289a..819bf83 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -52,7 +52,7 @@ struct rcu_head {
 	void (*func)(struct rcu_head *head);
 };
 
-#if defined(CONFIG_CLASSIC_RCU)
+#if defined(CONFIG_FLAT_RCU)
 #include <linux/rcuclassic.h>
 #elif defined(CONFIG_TREE_RCU)
 #include <linux/rcutree.h>
@@ -60,7 +60,7 @@ struct rcu_head {
 #include <linux/rcupreempt.h>
 #else
 #error "Unknown RCU implementation specified to kernel configuration"
-#endif /* #else #if defined(CONFIG_CLASSIC_RCU) */
+#endif /* #else #if defined(CONFIG_FLAT_RCU) */
 
 #define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL }
 #define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index 463f297..417a76b 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -52,16 +52,27 @@ config PREEMPT
 
 endchoice
 
+config CLASSIC_RCU
+	bool "Select default RCU implementation"
+	select TREE_RCU
+	help
+	  This option provides backwards compatibility for old defconfig
+	  files that used CLASSIC_RCU.
+
+	  Say Y if you are unsure.
+
 choice
 	prompt "RCU Implementation"
-	default CLASSIC_RCU
+	default TREE_RCU
 
-config CLASSIC_RCU
-	bool "Classic RCU"
+config FLAT_RCU
+	bool "Flat (AKA classic) RCU"
 	help
 	  This option selects the classic RCU implementation that is
 	  designed for best read-side performance on non-realtime
-	  systems.
+	  systems with modest numbers of CPUs.  Its flat bit-map
+	  implementation makes it unsuitable for systems with hundreds
+	  or thousands of CPUs.
 	  
 	  Select this option if you are unsure.
 
diff --git a/kernel/Makefile b/kernel/Makefile
index b4fdbbf..73e9a94 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -73,7 +73,7 @@ obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
-obj-$(CONFIG_CLASSIC_RCU) += rcuclassic.o
+obj-$(CONFIG_FLAT_RCU) += rcuclassic.o
 obj-$(CONFIG_TREE_RCU) += rcutree.o
 obj-$(CONFIG_PREEMPT_RCU) += rcupreempt.o
 obj-$(CONFIG_TREE_RCU_TRACE) += rcutree_trace.o
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8bae51a..7739ad8 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -608,7 +608,7 @@ config RCU_TORTURE_TEST_RUNNABLE
 
 config RCU_CPU_STALL_DETECTOR
 	bool "Check for stalled CPUs delaying RCU grace periods"
-	depends on CLASSIC_RCU || TREE_RCU
+	depends on TREE_RCU || FLAT_RCU
 	default n
 	help
 	  This option causes RCU to printk information on which
-- 
1.5.2.5

