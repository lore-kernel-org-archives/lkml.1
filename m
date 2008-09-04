Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbYIDNxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbYIDNxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 09:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbYIDNwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 09:52:44 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:59125
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755895AbYIDNwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 09:52:43 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 1/4] revert "sched: sched_cacheflush is now unused"
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: peterz@infradead.org, Lin Ming <ming.m.lin@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, mingo@elte.hu
Date: Thu, 04 Sep 2008 09:50:18 -0400
Message-ID: <20080904135018.26109.74483.stgit@dev.haskins.net>
In-Reply-To: <20080904134959.26109.90529.stgit@dev.haskins.net>
References: <20080904134959.26109.90529.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

revert c41917df8a1adde34864116ce2231a7fe308d2ff

	Author: Ralf Baechle <ralf@linux-mips.org>
	Date:   Thu Jul 19 21:28:35 2007 +0200

	    [PATCH] sched: sched_cacheflush is now unused

	    Since Ingo's recent scheduler rewrite which was merged as commit
	    0437e109e1841607f2988891eaa36c531c6aa6ac sched_cacheflush is unused.

	    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
	    Signed-off-by: Ingo Molnar <mingo@elte.hu>

We want to restore sd->cache_hot_time for better migration decisions.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 arch/ia64/kernel/setup.c    |    9 +++++++++
 include/asm-m32r/system.h   |   10 ++++++++++
 include/asm-mips/system.h   |   10 ++++++++++
 include/asm-parisc/system.h |   11 +++++++++++
 include/asm-x86/system.h    |    9 +++++++++
 5 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index c27d5b2..c0050ab 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -1051,6 +1051,15 @@ cpu_init (void)
 	pm_idle = default_idle;
 }
 
+/*
+ * On SMP systems, when the scheduler does migration-cost autodetection,
+ * it needs a way to flush as much of the CPU's caches as possible.
+ */
+void sched_cacheflush(void)
+{
+	ia64_sal_cache_flush(3);
+}
+
 void __init
 check_bugs (void)
 {
diff --git a/include/asm-m32r/system.h b/include/asm-m32r/system.h
index 70a57c8..d2f9559 100644
--- a/include/asm-m32r/system.h
+++ b/include/asm-m32r/system.h
@@ -54,6 +54,16 @@
 	); \
 } while(0)
 
+/*
+ * On SMP systems, when the scheduler does migration-cost autodetection,
+ * it needs a way to flush as much of the CPU's caches as possible.
+ *
+ * TODO: fill this in!
+ */
+static inline void sched_cacheflush(void)
+{
+}
+
 /* Interrupt Control */
 #if !defined(CONFIG_CHIP_M32102) && !defined(CONFIG_CHIP_M32104)
 #define local_irq_enable() \
diff --git a/include/asm-mips/system.h b/include/asm-mips/system.h
index a944eda..aaba821 100644
--- a/include/asm-mips/system.h
+++ b/include/asm-mips/system.h
@@ -78,6 +78,16 @@ do {									\
 		write_c0_userlocal(current_thread_info()->tp_value);	\
 } while (0)
 
+/*
+ * On SMP systems, when the scheduler does migration-cost autodetection,
+ * it needs a way to flush as much of the CPU's caches as possible.
+ *
+ * TODO: fill this in!
+ */
+static inline void sched_cacheflush(void)
+{
+}
+
 static inline unsigned long __xchg_u32(volatile int * m, unsigned int val)
 {
 	__u32 retval;
diff --git a/include/asm-parisc/system.h b/include/asm-parisc/system.h
index ee80c92..21fbfc5 100644
--- a/include/asm-parisc/system.h
+++ b/include/asm-parisc/system.h
@@ -48,6 +48,17 @@ extern struct task_struct *_switch_to(struct task_struct *, struct task_struct *
 	(last) = _switch_to(prev, next);			\
 } while(0)
 
+/*
+ * On SMP systems, when the scheduler does migration-cost autodetection,
+ * it needs a way to flush as much of the CPU's caches as possible.
+ *
+ * TODO: fill this in!
+ */
+static inline void sched_cacheflush(void)
+{
+}
+
+
 /* interrupt control */
 #define local_save_flags(x)	__asm__ __volatile__("ssm 0, %0" : "=r" (x) : : "memory")
 #define local_irq_disable()	__asm__ __volatile__("rsm %0,%%r0\n" : : "i" (PSW_I) : "memory" )
diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
index 983ce37..7847702 100644
--- a/include/asm-x86/system.h
+++ b/include/asm-x86/system.h
@@ -306,6 +306,15 @@ void enable_hlt(void);
 
 void cpu_idle_wait(void);
 
+/*
+ * On SMP systems, when the scheduler does migration-cost autodetection,
+ * it needs a way to flush as much of the CPU's caches as possible:
+ */
+static inline void sched_cacheflush(void)
+{
+	wbinvd();
+}
+
 extern unsigned long arch_align_stack(unsigned long sp);
 extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
 

