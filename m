Return-Path: <linux-kernel-owner+w=401wt.eu-S1763568AbZLQBBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763568AbZLQBBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763328AbZLQBBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:01:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:35278 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763555AbZLQBBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:01:25 -0500
Date: Thu, 17 Dec 2009 01:00:57 GMT
From: tip-bot for Borislav Petkov <petkovbb@googlemail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       petkovbb@googlemail.com, tglx@linutronix.de, petkovbb@gmail.com,
       randy.dunlap@oracle.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       petkovbb@googlemail.com, tglx@linutronix.de, randy.dunlap@oracle.com,
       petkovbb@gmail.com
In-Reply-To: <20091216231625.GD27228@liondog.tnic>
References: <20091216231625.GD27228@liondog.tnic>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, msr: msrs_alloc/free for CONFIG_SMP=n
Message-ID: <tip-6ede31e03084ee084bcee073ef3d1136f68d0906@git.kernel.org>
Git-Commit-ID: 6ede31e03084ee084bcee073ef3d1136f68d0906
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ede31e03084ee084bcee073ef3d1136f68d0906
Gitweb:     http://git.kernel.org/tip/6ede31e03084ee084bcee073ef3d1136f68d0906
Author:     Borislav Petkov <petkovbb@googlemail.com>
AuthorDate: Thu, 17 Dec 2009 00:16:25 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 16 Dec 2009 15:36:32 -0800

x86, msr: msrs_alloc/free for CONFIG_SMP=n

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
---
 arch/x86/include/asm/msr.h        |   12 ++
 arch/x86/lib/Makefile             |    4 +-
 arch/x86/lib/{msr.c => msr-smp.c} |   32 ------
 arch/x86/lib/msr.c                |  213 -------------------------------------
 4 files changed, 14 insertions(+), 247 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index cf985aa..c5bc4c2 100644
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
index a2d6472..706be8b 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -14,7 +14,7 @@ $(obj)/inat.o: $(obj)/inat-tables.c
 
 clean-files := inat-tables.c
 
-obj-$(CONFIG_SMP) := msr.o
+obj-$(CONFIG_SMP) += msr-smp.o
 
 lib-y := delay.o
 lib-y += thunk_$(BITS).o
@@ -22,7 +22,7 @@ lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
 lib-y += insn.o inat.o
 
-obj-y += msr-reg.o msr-reg-export.o
+obj-y += msr.o msr-reg.o msr-reg-export.o
 
 ifeq ($(CONFIG_X86_32),y)
         obj-y += atomic64_32.o
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr-smp.c
similarity index 90%
copy from arch/x86/lib/msr.c
copy to arch/x86/lib/msr-smp.c
index 8728341..a6b1b86 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr-smp.c
@@ -3,13 +3,6 @@
 #include <linux/smp.h>
 #include <asm/msr.h>
 
-struct msr_info {
-	u32 msr_no;
-	struct msr reg;
-	struct msr *msrs;
-	int err;
-};
-
 static void __rdmsr_on_cpu(void *info)
 {
 	struct msr_info *rv = info;
@@ -118,26 +111,6 @@ void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs)
 }
 EXPORT_SYMBOL(wrmsr_on_cpus);
 
-struct msr *msrs_alloc(void)
-{
-	struct msr *msrs = NULL;
-
-	msrs = alloc_percpu(struct msr);
-	if (!msrs) {
-		pr_warning("%s: error allocating msrs\n", __func__);
-		return NULL;
-	}
-
-	return msrs;
-}
-EXPORT_SYMBOL(msrs_alloc);
-
-void msrs_free(struct msr *msrs)
-{
-	free_percpu(msrs);
-}
-EXPORT_SYMBOL(msrs_free);
-
 /* These "safe" variants are slower and should be used when the target MSR
    may not actually exist. */
 static void __rdmsr_safe_on_cpu(void *info)
@@ -190,11 +163,6 @@ EXPORT_SYMBOL(wrmsr_safe_on_cpu);
  * These variants are significantly slower, but allows control over
  * the entire 32-bit GPR set.
  */
-struct msr_regs_info {
-	u32 *regs;
-	int err;
-};
-
 static void __rdmsr_safe_regs_on_cpu(void *info)
 {
 	struct msr_regs_info *rv = info;
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
