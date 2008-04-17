Return-Path: <linux-kernel-owner+w=401wt.eu-S1761805AbYDQJX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761805AbYDQJX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763588AbYDQJLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:31 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:59099
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763237AbYDQJLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:11:08 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Xiantao Zhang <xiantao.zhang@intel.com>
Subject: [PATCH 29/45] ia64: Implement smp_call_function_mask for ia64
Date: Thu, 17 Apr 2008 12:10:34 +0300
Message-Id: <1208423450-29415-30-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

This interface provides more flexible functionality for smp
infrastructure.

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/ia64/kernel/smp.c |   82 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/asm-ia64/smp.h |    3 ++
 2 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
index 4e446aa..9a9d4c4 100644
--- a/arch/ia64/kernel/smp.c
+++ b/arch/ia64/kernel/smp.c
@@ -213,6 +213,19 @@ send_IPI_allbutself (int op)
  * Called with preemption disabled.
  */
 static inline void
+send_IPI_mask(cpumask_t mask, int op)
+{
+	unsigned int cpu;
+
+	for_each_cpu_mask(cpu, mask) {
+			send_IPI_single(cpu, op);
+	}
+}
+
+/*
+ * Called with preemption disabled.
+ */
+static inline void
 send_IPI_all (int op)
 {
 	int i;
@@ -401,6 +414,75 @@ smp_call_function_single (int cpuid, void (*func) (void *info), void *info, int
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
+/**
+ * smp_call_function_mask(): Run a function on a set of other CPUs.
+ * <mask>	The set of cpus to run on.  Must not include the current cpu.
+ * <func> 	The function to run. This must be fast and non-blocking.
+ * <info>	An arbitrary pointer to pass to the function.
+ * <wait>	If true, wait (atomically) until function
+ *		has completed on other CPUs.
+ *
+ * Returns 0 on success, else a negative status code.
+ *
+ * If @wait is true, then returns once @func has returned; otherwise
+ * it returns just before the target cpu calls @func.
+ *
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler or from a bottom half handler.
+ */
+int smp_call_function_mask(cpumask_t mask,
+			   void (*func)(void *), void *info,
+			   int wait)
+{
+	struct call_data_struct data;
+	cpumask_t allbutself;
+	int cpus;
+
+	spin_lock(&call_lock);
+	allbutself = cpu_online_map;
+	cpu_clear(smp_processor_id(), allbutself);
+
+	cpus_and(mask, mask, allbutself);
+	cpus = cpus_weight(mask);
+	if (!cpus) {
+		spin_unlock(&call_lock);
+		return 0;
+	}
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
+	data.func = func;
+	data.info = info;
+	atomic_set(&data.started, 0);
+	data.wait = wait;
+	if (wait)
+		atomic_set(&data.finished, 0);
+
+	call_data = &data;
+	mb(); /* ensure store to call_data precedes setting of IPI_CALL_FUNC*/
+
+	/* Send a message to other CPUs */
+	if (cpus_equal(mask, allbutself))
+		send_IPI_allbutself(IPI_CALL_FUNC);
+	else
+		send_IPI_mask(mask, IPI_CALL_FUNC);
+
+	/* Wait for response */
+	while (atomic_read(&data.started) != cpus)
+		cpu_relax();
+
+	if (wait)
+		while (atomic_read(&data.finished) != cpus)
+			cpu_relax();
+	call_data = NULL;
+
+	spin_unlock(&call_lock);
+	return 0;
+
+}
+EXPORT_SYMBOL(smp_call_function_mask);
+
 /*
  * this function sends a 'generic call function' IPI to all other CPUs
  * in the system.
diff --git a/include/asm-ia64/smp.h b/include/asm-ia64/smp.h
index 4fa733d..ec5f355 100644
--- a/include/asm-ia64/smp.h
+++ b/include/asm-ia64/smp.h
@@ -38,6 +38,9 @@ ia64_get_lid (void)
 	return lid.f.id << 8 | lid.f.eid;
 }
 
+extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
+				  void *info, int wait);
+
 #define hard_smp_processor_id()		ia64_get_lid()
 
 #ifdef CONFIG_SMP
-- 
1.5.5

