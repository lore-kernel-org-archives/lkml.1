Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052Ab0AUQmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab0AUQmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968Ab0AUQl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:41:26 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38395 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab0AUQlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:41:24 -0500
From: Borislav Petkov <bp@amd64.org>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>
Cc: <andreas.herrmann3@amd.com>, <x86@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] x86, smp: Convert msr-smp.c to an smp library
Date: Thu, 21 Jan 2010 17:41:27 +0100
Message-Id: <1264092093-13739-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264092093-13739-1-git-send-email-bp@amd64.org>
References: <1264092093-13739-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Put all smp-related helpers into lib/smp.c to use for the rest of the
kernel.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/lib/Makefile  |    2 +-
 arch/x86/lib/msr-smp.c |  204 ------------------------------------------------
 arch/x86/lib/smp.c     |  204 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 205 insertions(+), 205 deletions(-)
 delete mode 100644 arch/x86/lib/msr-smp.c
 create mode 100644 arch/x86/lib/smp.c

diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index cffd754..48a5ced 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -14,7 +14,7 @@ $(obj)/inat.o: $(obj)/inat-tables.c
 
 clean-files := inat-tables.c
 
-obj-$(CONFIG_SMP) += msr-smp.o
+obj-$(CONFIG_SMP) += smp.o
 
 lib-y := delay.o
 lib-y += thunk_$(BITS).o
diff --git a/arch/x86/lib/msr-smp.c b/arch/x86/lib/msr-smp.c
deleted file mode 100644
index a6b1b86..0000000
--- a/arch/x86/lib/msr-smp.c
+++ /dev/null
@@ -1,204 +0,0 @@
-#include <linux/module.h>
-#include <linux/preempt.h>
-#include <linux/smp.h>
-#include <asm/msr.h>
-
-static void __rdmsr_on_cpu(void *info)
-{
-	struct msr_info *rv = info;
-	struct msr *reg;
-	int this_cpu = raw_smp_processor_id();
-
-	if (rv->msrs)
-		reg = per_cpu_ptr(rv->msrs, this_cpu);
-	else
-		reg = &rv->reg;
-
-	rdmsr(rv->msr_no, reg->l, reg->h);
-}
-
-static void __wrmsr_on_cpu(void *info)
-{
-	struct msr_info *rv = info;
-	struct msr *reg;
-	int this_cpu = raw_smp_processor_id();
-
-	if (rv->msrs)
-		reg = per_cpu_ptr(rv->msrs, this_cpu);
-	else
-		reg = &rv->reg;
-
-	wrmsr(rv->msr_no, reg->l, reg->h);
-}
-
-int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
-{
-	int err;
-	struct msr_info rv;
-
-	memset(&rv, 0, sizeof(rv));
-
-	rv.msr_no = msr_no;
-	err = smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 1);
-	*l = rv.reg.l;
-	*h = rv.reg.h;
-
-	return err;
-}
-EXPORT_SYMBOL(rdmsr_on_cpu);
-
-int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
-{
-	int err;
-	struct msr_info rv;
-
-	memset(&rv, 0, sizeof(rv));
-
-	rv.msr_no = msr_no;
-	rv.reg.l = l;
-	rv.reg.h = h;
-	err = smp_call_function_single(cpu, __wrmsr_on_cpu, &rv, 1);
-
-	return err;
-}
-EXPORT_SYMBOL(wrmsr_on_cpu);
-
-static void __rwmsr_on_cpus(const struct cpumask *mask, u32 msr_no,
-			    struct msr *msrs,
-			    void (*msr_func) (void *info))
-{
-	struct msr_info rv;
-	int this_cpu;
-
-	memset(&rv, 0, sizeof(rv));
-
-	rv.msrs	  = msrs;
-	rv.msr_no = msr_no;
-
-	this_cpu = get_cpu();
-
-	if (cpumask_test_cpu(this_cpu, mask))
-		msr_func(&rv);
-
-	smp_call_function_many(mask, msr_func, &rv, 1);
-	put_cpu();
-}
-
-/* rdmsr on a bunch of CPUs
- *
- * @mask:       which CPUs
- * @msr_no:     which MSR
- * @msrs:       array of MSR values
- *
- */
-void rdmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs)
-{
-	__rwmsr_on_cpus(mask, msr_no, msrs, __rdmsr_on_cpu);
-}
-EXPORT_SYMBOL(rdmsr_on_cpus);
-
-/*
- * wrmsr on a bunch of CPUs
- *
- * @mask:       which CPUs
- * @msr_no:     which MSR
- * @msrs:       array of MSR values
- *
- */
-void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs)
-{
-	__rwmsr_on_cpus(mask, msr_no, msrs, __wrmsr_on_cpu);
-}
-EXPORT_SYMBOL(wrmsr_on_cpus);
-
-/* These "safe" variants are slower and should be used when the target MSR
-   may not actually exist. */
-static void __rdmsr_safe_on_cpu(void *info)
-{
-	struct msr_info *rv = info;
-
-	rv->err = rdmsr_safe(rv->msr_no, &rv->reg.l, &rv->reg.h);
-}
-
-static void __wrmsr_safe_on_cpu(void *info)
-{
-	struct msr_info *rv = info;
-
-	rv->err = wrmsr_safe(rv->msr_no, rv->reg.l, rv->reg.h);
-}
-
-int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
-{
-	int err;
-	struct msr_info rv;
-
-	memset(&rv, 0, sizeof(rv));
-
-	rv.msr_no = msr_no;
-	err = smp_call_function_single(cpu, __rdmsr_safe_on_cpu, &rv, 1);
-	*l = rv.reg.l;
-	*h = rv.reg.h;
-
-	return err ? err : rv.err;
-}
-EXPORT_SYMBOL(rdmsr_safe_on_cpu);
-
-int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
-{
-	int err;
-	struct msr_info rv;
-
-	memset(&rv, 0, sizeof(rv));
-
-	rv.msr_no = msr_no;
-	rv.reg.l = l;
-	rv.reg.h = h;
-	err = smp_call_function_single(cpu, __wrmsr_safe_on_cpu, &rv, 1);
-
-	return err ? err : rv.err;
-}
-EXPORT_SYMBOL(wrmsr_safe_on_cpu);
-
-/*
- * These variants are significantly slower, but allows control over
- * the entire 32-bit GPR set.
- */
-static void __rdmsr_safe_regs_on_cpu(void *info)
-{
-	struct msr_regs_info *rv = info;
-
-	rv->err = rdmsr_safe_regs(rv->regs);
-}
-
-static void __wrmsr_safe_regs_on_cpu(void *info)
-{
-	struct msr_regs_info *rv = info;
-
-	rv->err = wrmsr_safe_regs(rv->regs);
-}
-
-int rdmsr_safe_regs_on_cpu(unsigned int cpu, u32 *regs)
-{
-	int err;
-	struct msr_regs_info rv;
-
-	rv.regs   = regs;
-	rv.err    = -EIO;
-	err = smp_call_function_single(cpu, __rdmsr_safe_regs_on_cpu, &rv, 1);
-
-	return err ? err : rv.err;
-}
-EXPORT_SYMBOL(rdmsr_safe_regs_on_cpu);
-
-int wrmsr_safe_regs_on_cpu(unsigned int cpu, u32 *regs)
-{
-	int err;
-	struct msr_regs_info rv;
-
-	rv.regs = regs;
-	rv.err  = -EIO;
-	err = smp_call_function_single(cpu, __wrmsr_safe_regs_on_cpu, &rv, 1);
-
-	return err ? err : rv.err;
-}
-EXPORT_SYMBOL(wrmsr_safe_regs_on_cpu);
diff --git a/arch/x86/lib/smp.c b/arch/x86/lib/smp.c
new file mode 100644
index 0000000..a6b1b86
--- /dev/null
+++ b/arch/x86/lib/smp.c
@@ -0,0 +1,204 @@
+#include <linux/module.h>
+#include <linux/preempt.h>
+#include <linux/smp.h>
+#include <asm/msr.h>
+
+static void __rdmsr_on_cpu(void *info)
+{
+	struct msr_info *rv = info;
+	struct msr *reg;
+	int this_cpu = raw_smp_processor_id();
+
+	if (rv->msrs)
+		reg = per_cpu_ptr(rv->msrs, this_cpu);
+	else
+		reg = &rv->reg;
+
+	rdmsr(rv->msr_no, reg->l, reg->h);
+}
+
+static void __wrmsr_on_cpu(void *info)
+{
+	struct msr_info *rv = info;
+	struct msr *reg;
+	int this_cpu = raw_smp_processor_id();
+
+	if (rv->msrs)
+		reg = per_cpu_ptr(rv->msrs, this_cpu);
+	else
+		reg = &rv->reg;
+
+	wrmsr(rv->msr_no, reg->l, reg->h);
+}
+
+int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+{
+	int err;
+	struct msr_info rv;
+
+	memset(&rv, 0, sizeof(rv));
+
+	rv.msr_no = msr_no;
+	err = smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 1);
+	*l = rv.reg.l;
+	*h = rv.reg.h;
+
+	return err;
+}
+EXPORT_SYMBOL(rdmsr_on_cpu);
+
+int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+{
+	int err;
+	struct msr_info rv;
+
+	memset(&rv, 0, sizeof(rv));
+
+	rv.msr_no = msr_no;
+	rv.reg.l = l;
+	rv.reg.h = h;
+	err = smp_call_function_single(cpu, __wrmsr_on_cpu, &rv, 1);
+
+	return err;
+}
+EXPORT_SYMBOL(wrmsr_on_cpu);
+
+static void __rwmsr_on_cpus(const struct cpumask *mask, u32 msr_no,
+			    struct msr *msrs,
+			    void (*msr_func) (void *info))
+{
+	struct msr_info rv;
+	int this_cpu;
+
+	memset(&rv, 0, sizeof(rv));
+
+	rv.msrs	  = msrs;
+	rv.msr_no = msr_no;
+
+	this_cpu = get_cpu();
+
+	if (cpumask_test_cpu(this_cpu, mask))
+		msr_func(&rv);
+
+	smp_call_function_many(mask, msr_func, &rv, 1);
+	put_cpu();
+}
+
+/* rdmsr on a bunch of CPUs
+ *
+ * @mask:       which CPUs
+ * @msr_no:     which MSR
+ * @msrs:       array of MSR values
+ *
+ */
+void rdmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs)
+{
+	__rwmsr_on_cpus(mask, msr_no, msrs, __rdmsr_on_cpu);
+}
+EXPORT_SYMBOL(rdmsr_on_cpus);
+
+/*
+ * wrmsr on a bunch of CPUs
+ *
+ * @mask:       which CPUs
+ * @msr_no:     which MSR
+ * @msrs:       array of MSR values
+ *
+ */
+void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs)
+{
+	__rwmsr_on_cpus(mask, msr_no, msrs, __wrmsr_on_cpu);
+}
+EXPORT_SYMBOL(wrmsr_on_cpus);
+
+/* These "safe" variants are slower and should be used when the target MSR
+   may not actually exist. */
+static void __rdmsr_safe_on_cpu(void *info)
+{
+	struct msr_info *rv = info;
+
+	rv->err = rdmsr_safe(rv->msr_no, &rv->reg.l, &rv->reg.h);
+}
+
+static void __wrmsr_safe_on_cpu(void *info)
+{
+	struct msr_info *rv = info;
+
+	rv->err = wrmsr_safe(rv->msr_no, rv->reg.l, rv->reg.h);
+}
+
+int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+{
+	int err;
+	struct msr_info rv;
+
+	memset(&rv, 0, sizeof(rv));
+
+	rv.msr_no = msr_no;
+	err = smp_call_function_single(cpu, __rdmsr_safe_on_cpu, &rv, 1);
+	*l = rv.reg.l;
+	*h = rv.reg.h;
+
+	return err ? err : rv.err;
+}
+EXPORT_SYMBOL(rdmsr_safe_on_cpu);
+
+int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+{
+	int err;
+	struct msr_info rv;
+
+	memset(&rv, 0, sizeof(rv));
+
+	rv.msr_no = msr_no;
+	rv.reg.l = l;
+	rv.reg.h = h;
+	err = smp_call_function_single(cpu, __wrmsr_safe_on_cpu, &rv, 1);
+
+	return err ? err : rv.err;
+}
+EXPORT_SYMBOL(wrmsr_safe_on_cpu);
+
+/*
+ * These variants are significantly slower, but allows control over
+ * the entire 32-bit GPR set.
+ */
+static void __rdmsr_safe_regs_on_cpu(void *info)
+{
+	struct msr_regs_info *rv = info;
+
+	rv->err = rdmsr_safe_regs(rv->regs);
+}
+
+static void __wrmsr_safe_regs_on_cpu(void *info)
+{
+	struct msr_regs_info *rv = info;
+
+	rv->err = wrmsr_safe_regs(rv->regs);
+}
+
+int rdmsr_safe_regs_on_cpu(unsigned int cpu, u32 *regs)
+{
+	int err;
+	struct msr_regs_info rv;
+
+	rv.regs   = regs;
+	rv.err    = -EIO;
+	err = smp_call_function_single(cpu, __rdmsr_safe_regs_on_cpu, &rv, 1);
+
+	return err ? err : rv.err;
+}
+EXPORT_SYMBOL(rdmsr_safe_regs_on_cpu);
+
+int wrmsr_safe_regs_on_cpu(unsigned int cpu, u32 *regs)
+{
+	int err;
+	struct msr_regs_info rv;
+
+	rv.regs = regs;
+	rv.err  = -EIO;
+	err = smp_call_function_single(cpu, __wrmsr_safe_regs_on_cpu, &rv, 1);
+
+	return err ? err : rv.err;
+}
+EXPORT_SYMBOL(wrmsr_safe_regs_on_cpu);
-- 
1.6.6

