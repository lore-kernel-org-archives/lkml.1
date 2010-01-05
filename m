Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677Ab0AEAia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab0AEAia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991Ab0AEAiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:38:13 -0500
Received: from kroah.org ([198.145.64.141]:42496 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557Ab0AEAgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:36:16 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Borislav Petkov <petkovbb@googlemail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <petkovbb@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 89/97] x86, msr: msrs_alloc/free for CONFIG_SMP=n
Date: Mon,  4 Jan 2010 16:33:42 -0800
Message-Id: <1262651630-7354-89-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <petkovbb@googlemail.com>

commit 6ede31e03084ee084bcee073ef3d1136f68d0906 upstream.

Randy Dunlap reported the following build error:

"When CONFIG_SMP=n, CONFIG_X86_MSR=m:

ERROR: "msrs_free" [drivers/edac/amd64_edac_mod.ko] undefined!
ERROR: "msrs_alloc" [drivers/edac/amd64_edac_mod.ko] undefined!"

This is due to the fact that <arch/x86/lib/msr.c> is conditioned on
CONFIG_SMP and in the UP case we have only the stubs in the header.
Fork off SMP functionality into a new file (msr-smp.c) and build
msrs_{alloc,free} unconditionally.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
LKML-Reference: <20091216231625.GD27228@liondog.tnic>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/include/asm/msr.h |   12 +++
 arch/x86/lib/Makefile      |    4 +-
 arch/x86/lib/msr-smp.c     |  204 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/lib/msr.c         |  213 --------------------------------------------
 4 files changed, 218 insertions(+), 215 deletions(-)
 create mode 100644 arch/x86/lib/msr-smp.c

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index bb30776..0e3e728 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -27,6 +27,18 @@ struct msr {
 	};
 };
 
+struct msr_info {
+	u32 msr_no;
+	struct msr reg;
+	struct msr *msrs;
+	int err;
+};
+
+struct msr_regs_info {
+	u32 *regs;
+	int err;
+};
+
 static inline unsigned long long native_read_tscp(unsigned int *aux)
 {
 	unsigned long low, high;
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 85f5db9..c2b6f39 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -2,14 +2,14 @@
 # Makefile for x86 specific library files.
 #
 
-obj-$(CONFIG_SMP) := msr.o
+obj-$(CONFIG_SMP) += msr-smp.o
 
 lib-y := delay.o
 lib-y += thunk_$(BITS).o
 lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
 
-obj-y += msr-reg.o msr-reg-export.o
+obj-y += msr.o msr-reg.o msr-reg-export.o
 
 ifeq ($(CONFIG_X86_32),y)
         obj-y += atomic64_32.o
diff --git a/arch/x86/lib/msr-smp.c b/arch/x86/lib/msr-smp.c
new file mode 100644
index 0000000..a6b1b86
--- /dev/null
+++ b/arch/x86/lib/msr-smp.c
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
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index 8728341..8f8eebd 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -1,123 +1,7 @@
 #include <linux/module.h>
 #include <linux/preempt.h>
-#include <linux/smp.h>
 #include <asm/msr.h>
 
-struct msr_info {
-	u32 msr_no;
-	struct msr reg;
-	struct msr *msrs;
-	int err;
-};
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
 struct msr *msrs_alloc(void)
 {
 	struct msr *msrs = NULL;
@@ -137,100 +21,3 @@ void msrs_free(struct msr *msrs)
 	free_percpu(msrs);
 }
 EXPORT_SYMBOL(msrs_free);
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
-struct msr_regs_info {
-	u32 *regs;
-	int err;
-};
-
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
-- 
1.6.6

