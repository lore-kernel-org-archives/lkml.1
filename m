Return-Path: <linux-kernel-owner+w=401wt.eu-S1759185AbZFOMGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759185AbZFOMGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbZFOMFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:05:41 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:35609 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757990AbZFOMFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:05:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18998.13388.920691.523227@cargo.ozlabs.ibm.com>
Date: Mon, 15 Jun 2009 21:45:16 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter: Make set_perf_counter_pending
   declaration common
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At present, every architecture that supports perf_counters has to
declare set_perf_counter_pending() in its arch-specific headers.
This consolidates the declarations into a single declaration in one
common place, include/linux/perf_counter.h.  On powerpc, we continue
to provide a static inline definition of set_perf_counter_pending()
in the powerpc hw_irq.h.

Also, this removes from the x86 perf_counter.h the unused null
definitions of {test,clear}_perf_counter_pending.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/include/asm/hw_irq.h       |    1 -
 arch/powerpc/include/asm/perf_counter.h |    2 ++
 arch/x86/include/asm/perf_counter.h     |    5 -----
 include/linux/perf_counter.h            |    1 +
 4 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/hw_irq.h b/arch/powerpc/include/asm/hw_irq.h
index 5351237..1974cf1 100644
--- a/arch/powerpc/include/asm/hw_irq.h
+++ b/arch/powerpc/include/asm/hw_irq.h
@@ -163,7 +163,6 @@ static inline unsigned long test_perf_counter_pending(void)
 	return 0;
 }
 
-static inline void set_perf_counter_pending(void) {}
 static inline void clear_perf_counter_pending(void) {}
 #endif /* CONFIG_PERF_COUNTERS */
 
diff --git a/arch/powerpc/include/asm/perf_counter.h b/arch/powerpc/include/asm/perf_counter.h
index cc7c887..b398a84 100644
--- a/arch/powerpc/include/asm/perf_counter.h
+++ b/arch/powerpc/include/asm/perf_counter.h
@@ -10,6 +10,8 @@
  */
 #include <linux/types.h>
 
+#include <asm/hw_irq.h>
+
 #define MAX_HWCOUNTERS		8
 #define MAX_EVENT_ALTERNATIVES	8
 #define MAX_LIMITED_HWCOUNTERS	2
diff --git a/arch/x86/include/asm/perf_counter.h b/arch/x86/include/asm/perf_counter.h
index 876ed97..5fb33e1 100644
--- a/arch/x86/include/asm/perf_counter.h
+++ b/arch/x86/include/asm/perf_counter.h
@@ -84,11 +84,6 @@ union cpuid10_edx {
 #define MSR_ARCH_PERFMON_FIXED_CTR2			0x30b
 #define X86_PMC_IDX_FIXED_BUS_CYCLES			(X86_PMC_IDX_FIXED + 2)
 
-extern void set_perf_counter_pending(void);
-
-#define clear_perf_counter_pending()	do { } while (0)
-#define test_perf_counter_pending()	(0)
-
 #ifdef CONFIG_PERF_COUNTERS
 extern void init_hw_perf_counters(void);
 extern void perf_counters_lapic_init(void);
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 1b3118a..eccae43 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -604,6 +604,7 @@ extern void perf_counter_task_tick(struct task_struct *task, int cpu);
 extern int perf_counter_init_task(struct task_struct *child);
 extern void perf_counter_exit_task(struct task_struct *child);
 extern void perf_counter_free_task(struct task_struct *task);
+extern void set_perf_counter_pending(void);
 extern void perf_counter_do_pending(void);
 extern void perf_counter_print_debug(void);
 extern void __perf_disable(void);
