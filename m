Return-Path: <linux-kernel-owner+w=401wt.eu-S1760717AbYD2H17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760717AbYD2H17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 03:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758066AbYD2HZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 03:25:53 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17208 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910AbYD2HZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 03:25:45 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, npiggin@suse.de, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
       Jens Axboe <jens.axboe@oracle.com>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 10/10] sh: convert to generic helpers for IPI function calls
Date: Tue, 29 Apr 2008 09:26:30 +0200
Message-Id: <1209453990-7735-11-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.5.1.57.g5909c
In-Reply-To: <1209453990-7735-1-git-send-email-jens.axboe@oracle.com>
References: <1209453990-7735-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts sh to use the new helpers for smp_call_function() and
friends, and adds support for smp_call_function_single(). Not tested,
but it compiles.

Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/sh/Kconfig      |    1 +
 arch/sh/kernel/smp.c |   48 ++++++++----------------------------------------
 include/asm-sh/smp.h |   12 ++----------
 3 files changed, 11 insertions(+), 50 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 6a679c3..60cfdf5 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -698,6 +698,7 @@ config CRASH_DUMP
 config SMP
 	bool "Symmetric multi-processing support"
 	depends on SYS_SUPPORTS_SMP
+	select USE_GENERIC_SMP_HELPERS
 	---help---
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
index 5d039d1..2ed8dce 100644
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -36,13 +36,6 @@ EXPORT_SYMBOL(cpu_possible_map);
 cpumask_t cpu_online_map;
 EXPORT_SYMBOL(cpu_online_map);
 
-static atomic_t cpus_booted = ATOMIC_INIT(0);
-
-/*
- * Run specified function on a particular processor.
- */
-void __smp_call_function(unsigned int cpu);
-
 static inline void __init smp_store_cpu_info(unsigned int cpu)
 {
 	struct sh_cpuinfo *c = cpu_data + cpu;
@@ -178,42 +171,17 @@ void smp_send_stop(void)
 	smp_call_function(stop_this_cpu, 0, 1, 0);
 }
 
-struct smp_fn_call_struct smp_fn_call = {
-	.lock		= __SPIN_LOCK_UNLOCKED(smp_fn_call.lock),
-	.finished	= ATOMIC_INIT(0),
-};
-
-/*
- * The caller of this wants the passed function to run on every cpu.  If wait
- * is set, wait until all cpus have finished the function before returning.
- * The lock is here to protect the call structure.
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler.
- */
-int smp_call_function(void (*func)(void *info), void *info, int retry, int wait)
+void arch_send_call_function_ipi(cpumask_t mask)
 {
-	unsigned int nr_cpus = atomic_read(&cpus_booted);
-	int i;
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	spin_lock(&smp_fn_call.lock);
-
-	atomic_set(&smp_fn_call.finished, 0);
-	smp_fn_call.fn = func;
-	smp_fn_call.data = info;
-
-	for (i = 0; i < nr_cpus; i++)
-		if (i != smp_processor_id())
-			plat_send_ipi(i, SMP_MSG_FUNCTION);
-
-	if (wait)
-		while (atomic_read(&smp_fn_call.finished) != (nr_cpus - 1));
+	int cpu;
 
-	spin_unlock(&smp_fn_call.lock);
+	for_each_cpu_mask(cpu, mask)
+		plat_send_ipi(cpu, SMP_MSG_FUNCTION);
+}
 
-	return 0;
+void arch_send_call_function_single_ipi(int cpu)
+{
+	plat_send_ipi(cpu, SMP_MSG_FUNCTION_SINGLE);
 }
 
 /* Not really SMP stuff ... */
diff --git a/include/asm-sh/smp.h b/include/asm-sh/smp.h
index 9c8d34b..7982516 100644
--- a/include/asm-sh/smp.h
+++ b/include/asm-sh/smp.h
@@ -26,18 +26,10 @@ extern int __cpu_logical_map[NR_CPUS];
 
 #define NO_PROC_ID	(-1)
 
-struct smp_fn_call_struct {
-	spinlock_t lock;
-	atomic_t   finished;
-	void (*fn)(void *);
-	void *data;
-};
-
-extern struct smp_fn_call_struct smp_fn_call;
-
 #define SMP_MSG_FUNCTION	0
 #define SMP_MSG_RESCHEDULE	1
-#define SMP_MSG_NR		2
+#define SMP_MSG_FUNCTION_SINGLE	2
+#define SMP_MSG_NR		3
 
 void plat_smp_setup(void);
 void plat_prepare_cpus(unsigned int max_cpus);
-- 
1.5.5.1.57.g5909c

