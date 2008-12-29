Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224AbYL2Fie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbYL2Fie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 00:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbYL2FiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 00:38:25 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51569 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbYL2FiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 00:38:24 -0500
Date: Sun, 28 Dec 2008 19:22:49 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org,
       ralf@linux-mips.org, kernel@wantstofly.org, hskinnemoen@atmel.com,
       cooloney@kernel.org, tony.luck@intel.com, geert@linux-m68k.org,
       zippel@linux-m68k.org, jwboyer@linux.vnet.ibm.com,
       mporter@kernel.crashing.org, grant.likely@secretlab.ca,
       paulus@samba.org, benh@kernel.crashing.org, dhowells@redhat.com,
       yasutake.koichi@jp.panasonic.com, lethal@linux-sh.org, hpa@zytor.com,
       wli@holomorphy.com, rth@twiddle.net
Subject: [PATCH, -tip] v2 Make hierarchical RCU be the default
Message-ID: <20081229032249.GA7292@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1229991147545-git-send-email-paulmck@linux.vnet.ibm.com> <12299911471985-git-send-email-paulmck@linux.vnet.ibm.com> <20081223142542.GC29151@elte.hu> <20081223215948.GA16137@linux.vnet.ibm.com> <20081223220345.GA16472@linux.vnet.ibm.com> <20081223220648.GB16472@linux.vnet.ibm.com> <20081227103501.GG14639@elte.hu> <20081227232731.GC7041@linux.vnet.ibm.com> <20081227233926.GA8514@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227233926.GA8514@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the new TREE_RCU be the default, pointing the old
CLASSIC_RCU Kconfig symbol at it and introducing a new FLAT_RCU symbol
to allow the old version to be selected.  It also introduces the kernel
config parameter RCU_READ_PREEMPT_DISABLE, which allows debug code in
pagemap.h to operate in TREE_RCU as it did in FLAT_RCU.

The approach is to place the RCU-specific configs in a new file named
kernel/Kconfig.rcu, which is sourced from kernel/Kconfig.preempt,
making this change transparent to all architectures that source
kernel/Kconfig.preempt.  The remaining five architectures (alpha, frv,
h8300, m68k, and sparc) have been modified to select CLASSIC_RCU in
their arch Kconfigs and to source kernel/Kconfig.rcu.  The only
difference that these five arches will see is the RCU configs at the
very end of the config list.  These five architectures were tested by
directly invoking qconf on the corresponding Kconfig file, and the
results looked correct.  I do not have the corresponding hardware for
any sort of real testing.

The resulting patch is relatively small, and directly touches a minimum
number of architectures.

This patch is -not- yet suitable for inclusion, only for testing in
-tip, -next, and the like.  If all goes well, it might be appropriate
for 2.6.29.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 arch/alpha/Kconfig       |    2 
 arch/frv/Kconfig         |    3 +
 arch/h8300/Kconfig       |    3 +
 arch/m68k/Kconfig        |    3 +
 arch/sparc/Kconfig       |    3 +
 include/linux/hardirq.h  |    4 -
 include/linux/pagemap.h  |    4 -
 include/linux/rcupdate.h |    4 -
 init/Kconfig             |   87 ----------------------------------------
 kernel/Kconfig.preempt   |    1 
 kernel/Kconfig.rcu       |  100 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/Makefile          |    2 
 lib/Kconfig.debug        |    2 
 13 files changed, 123 insertions(+), 95 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 6110197..8f4e779 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -8,6 +8,7 @@ config ALPHA
 	select HAVE_AOUT
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select CLASSIC_RCU
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
@@ -671,3 +672,4 @@ source "crypto/Kconfig"
 
 source "lib/Kconfig"
 
+source "kernel/Kconfig.rcu"
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 9d1552a..0884abc 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -6,6 +6,7 @@ config FRV
 	bool
 	default y
 	select HAVE_IDE
+	select CLASSIC_RCU
 
 config ZONE_DMA
 	bool
@@ -398,3 +399,5 @@ source "security/Kconfig"
 source "crypto/Kconfig"
 
 source "lib/Kconfig"
+
+source "kernel/Kconfig.rcu"
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 28f06fd..8b13a5b 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -9,6 +9,7 @@ config H8300
 	bool
 	default y
 	select HAVE_IDE
+	select CLASSIC_RCU
 
 config MMU
 	bool
@@ -229,3 +230,5 @@ source "security/Kconfig"
 source "crypto/Kconfig"
 
 source "lib/Kconfig"
+
+source "kernel/Kconfig.rcu"
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 836fb66..1759981 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -7,6 +7,7 @@ config M68K
 	default y
 	select HAVE_AOUT
 	select HAVE_IDE
+	select CLASSIC_RCU
 
 config MMU
 	bool
@@ -622,3 +623,5 @@ source "security/Kconfig"
 source "crypto/Kconfig"
 
 source "lib/Kconfig"
+
+source "kernel/Kconfig.rcu"
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index e594559..daf88ce 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -79,6 +79,7 @@ config SPARC
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select RTC_CLASS
 	select RTC_DRV_M48T59
+	select CLASSIC_RCU
 
 # Identify this as a Sparc32 build
 config SPARC32
@@ -302,3 +303,5 @@ source "security/Kconfig"
 source "crypto/Kconfig"
 
 source "lib/Kconfig"
+
+source "kernel/Kconfig.rcu"
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
index 709742b..a8f427a 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -140,7 +140,7 @@ static inline int page_cache_get_speculative(struct page *page)
 {
 	VM_BUG_ON(in_interrupt());
 
-#if !defined(CONFIG_SMP) && defined(CONFIG_CLASSIC_RCU)
+#if !defined(CONFIG_SMP) && defined(CONFIG_RCU_READ_PREEMPT_DISABLE)
 # ifdef CONFIG_PREEMPT
 	VM_BUG_ON(!in_atomic());
 # endif
@@ -178,7 +178,7 @@ static inline int page_cache_add_speculative(struct page *page, int count)
 {
 	VM_BUG_ON(in_interrupt());
 
-#if !defined(CONFIG_SMP) && defined(CONFIG_CLASSIC_RCU)
+#if !defined(CONFIG_SMP) && defined(CONFIG_RCU_READ_PREEMPT_DISABLE)
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
diff --git a/init/Kconfig b/init/Kconfig
index 6b0fded..e2bf7b8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -928,90 +928,3 @@ source "block/Kconfig"
 config PREEMPT_NOTIFIERS
 	bool
 
-choice
-	prompt "RCU Implementation"
-	default CLASSIC_RCU
-
-config CLASSIC_RCU
-	bool "Classic RCU"
-	help
-	  This option selects the classic RCU implementation that is
-	  designed for best read-side performance on non-realtime
-	  systems.
-
-	  Select this option if you are unsure.
-
-config TREE_RCU
-	bool "Tree-based hierarchical RCU"
-	help
-	  This option selects the RCU implementation that is
-	  designed for very large SMP system with hundreds or
-	  thousands of CPUs.
-
-config PREEMPT_RCU
-	bool "Preemptible RCU"
-	depends on PREEMPT
-	help
-	  This option reduces the latency of the kernel by making certain
-	  RCU sections preemptible. Normally RCU code is non-preemptible, if
-	  this option is selected then read-only RCU sections become
-	  preemptible. This helps latency, but may expose bugs due to
-	  now-naive assumptions about each RCU read-side critical section
-	  remaining on a given CPU through its execution.
-
-endchoice
-
-config RCU_TRACE
-	bool "Enable tracing for RCU"
-	depends on TREE_RCU || PREEMPT_RCU
-	help
-	  This option provides tracing in RCU which presents stats
-	  in debugfs for debugging RCU implementation.
-
-	  Say Y here if you want to enable RCU tracing
-	  Say N if you are unsure.
-
-config RCU_FANOUT
-	int "Tree-based hierarchical RCU fanout value"
-	range 2 64 if 64BIT
-	range 2 32 if !64BIT
-	depends on TREE_RCU
-	default 64 if 64BIT
-	default 32 if !64BIT
-	help
-	  This option controls the fanout of hierarchical implementations
-	  of RCU, allowing RCU to work efficiently on machines with
-	  large numbers of CPUs.  This value must be at least the cube
-	  root of NR_CPUS, which allows NR_CPUS up to 32,768 for 32-bit
-	  systems and up to 262,144 for 64-bit systems.
-
-	  Select a specific number if testing RCU itself.
-	  Take the default if unsure.
-
-config RCU_FANOUT_EXACT
-	bool "Disable tree-based hierarchical RCU auto-balancing"
-	depends on TREE_RCU
-	default n
-	help
-	  This option forces use of the exact RCU_FANOUT value specified,
-	  regardless of imbalances in the hierarchy.  This is useful for
-	  testing RCU itself, and might one day be useful on systems with
-	  strong NUMA behavior.
-
-	  Without RCU_FANOUT_EXACT, the code will balance the hierarchy.
-
-	  Say N if unsure.
-
-config TREE_RCU_TRACE
-	def_bool RCU_TRACE && TREE_RCU
-	select DEBUG_FS
-	help
-	  This option provides tracing for the TREE_RCU implementation,
-	  permitting Makefile to trivially select kernel/rcutree_trace.c.
-
-config PREEMPT_RCU_TRACE
-	def_bool RCU_TRACE && PREEMPT_RCU
-	select DEBUG_FS
-	help
-	  This option provides tracing for the PREEMPT_RCU implementation,
-	  permitting Makefile to trivially select kernel/rcupreempt_trace.c.
diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index bf987b9..ac9c4cc 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -52,3 +52,4 @@ config PREEMPT
 
 endchoice
 
+source "kernel/Kconfig.rcu"
diff --git a/kernel/Kconfig.rcu b/kernel/Kconfig.rcu
new file mode 100644
index 0000000..e09f45d
--- /dev/null
+++ b/kernel/Kconfig.rcu
@@ -0,0 +1,100 @@
+
+config CLASSIC_RCU
+	bool
+	select TREE_RCU
+
+choice
+	prompt "RCU Implementation"
+	default TREE_RCU
+
+config FLAT_RCU
+	bool "Flat (AKA classic) RCU"
+	select RCU_READ_PREEMPT_DISABLE
+	help
+	  This option selects the classic RCU implementation that is
+	  designed for best read-side performance on non-realtime
+	  systems with modest numbers of CPUs.  Its flat bit-map
+	  implementation makes it unsuitable for systems with hundreds
+	  or thousands of CPUs.
+
+	  Select this option if you are unsure.
+
+config TREE_RCU
+	bool "Tree-based hierarchical RCU"
+	select RCU_READ_PREEMPT_DISABLE
+	help
+	  This option selects the RCU implementation that is
+	  designed for very large SMP system with hundreds or
+	  thousands of CPUs.
+
+config PREEMPT_RCU
+	bool "Preemptible RCU"
+	depends on PREEMPT
+	help
+	  This option reduces the latency of the kernel by making certain
+	  RCU sections preemptible. Normally RCU code is non-preemptible, if
+	  this option is selected then read-only RCU sections become
+	  preemptible. This helps latency, but may expose bugs due to
+	  now-naive assumptions about each RCU read-side critical section
+	  remaining on a given CPU through its execution.
+
+endchoice
+
+config RCU_TRACE
+	bool "Enable tracing for RCU"
+	depends on TREE_RCU || PREEMPT_RCU
+	help
+	  This option provides tracing in RCU which presents stats
+	  in debugfs for debugging RCU implementation.
+
+	  Say Y here if you want to enable RCU tracing
+	  Say N if you are unsure.
+
+config RCU_FANOUT
+	int "Tree-based hierarchical RCU fanout value"
+	range 2 64 if 64BIT
+	range 2 32 if !64BIT
+	depends on TREE_RCU
+	default 64 if 64BIT
+	default 32 if !64BIT
+	help
+	  This option controls the fanout of hierarchical implementations
+	  of RCU, allowing RCU to work efficiently on machines with
+	  large numbers of CPUs.  This value must be at least the cube
+	  root of NR_CPUS, which allows NR_CPUS up to 32,768 for 32-bit
+	  systems and up to 262,144 for 64-bit systems.
+
+	  Select a specific number if testing RCU itself.
+	  Take the default if unsure.
+
+config RCU_FANOUT_EXACT
+	bool "Disable tree-based hierarchical RCU auto-balancing"
+	depends on TREE_RCU
+	default n
+	help
+	  This option forces use of the exact RCU_FANOUT value specified,
+	  regardless of imbalances in the hierarchy.  This is useful for
+	  testing RCU itself, and might one day be useful on systems with
+	  strong NUMA behavior.
+
+	  Without RCU_FANOUT_EXACT, the code will balance the hierarchy.
+
+	  Say N if unsure.
+
+config TREE_RCU_TRACE
+	def_bool RCU_TRACE && TREE_RCU
+	select DEBUG_FS
+	help
+	  This option provides tracing for the TREE_RCU implementation,
+	  permitting Makefile to trivially select kernel/rcutree_trace.c.
+
+config PREEMPT_RCU_TRACE
+	def_bool RCU_TRACE && PREEMPT_RCU
+	select DEBUG_FS
+	help
+	  This option provides tracing for the PREEMPT_RCU implementation,
+	  permitting Makefile to trivially select kernel/rcupreempt_trace.c.
+
+config RCU_READ_PREEMPT_DISABLE
+	bool
+	default n
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
index 465d822..a036720 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -621,7 +621,7 @@ config RCU_CPU_STALL_DETECTOR
 
 config RCU_CPU_STALL_DETECTOR
 	bool "Check for stalled CPUs delaying RCU grace periods"
-	depends on CLASSIC_RCU || TREE_RCU
+	depends on TREE_RCU || FLAT_RCU
 	default n
 	help
 	  This option causes RCU to printk information on which
