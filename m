Return-Path: <linux-kernel-owner+w=401wt.eu-S1760724AbZEGNwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724AbZEGNwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756786AbZEGNuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:50:19 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:54095 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184AbZEGNuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:50:04 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KJA12W-02-CL0-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
CC: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 01/21] x86: add methods for writing of an MSR on several CPUs
Date: Thu, 7 May 2009 15:49:23 +0200
Message-ID: <1241704183-29223-2-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 07 May 2009 13:49:48.0172 (UTC) FILETIME=[AFC3E4C0:01C9CF1A]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a struct representing a 64bit MSR pair consisting of a low and high
register part.

Also, rename msr-on-cpu.c to msr.c accordingly.

Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/msr.h |   21 ++++++
 arch/x86/lib/Makefile      |    2 +-
 arch/x86/lib/msr-on-cpu.c  |   97 ----------------------------
 arch/x86/lib/msr.c         |  152 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 174 insertions(+), 98 deletions(-)
 delete mode 100644 arch/x86/lib/msr-on-cpu.c
 create mode 100644 arch/x86/lib/msr.c

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 638bf62..624c895 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_MSR_H
 
 #include <asm/msr-index.h>
+#include <asm/cpumask.h>
 
 #ifndef __ASSEMBLY__
 # include <linux/types.h>
@@ -13,6 +14,16 @@
 #include <asm/asm.h>
 #include <asm/errno.h>
 
+struct msr {
+	union {
+		struct {
+			u32 l;
+			u32 h;
+		};
+		u64 q;
+	};
+};
+
 static inline unsigned long long native_read_tscp(unsigned int *aux)
 {
 	unsigned long low, high;
@@ -216,6 +227,8 @@ do {                                                            \
 #ifdef CONFIG_SMP
 int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
+int rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs);
+int wrmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs);
 int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
 #else  /*  CONFIG_SMP  */
@@ -229,6 +242,14 @@ static inline int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 	wrmsr(msr_no, l, h);
 	return 0;
 }
+static inline int rdmsr_on_cpus(const cpumask_t *m, u32 msr_no, struct msr **msrs)
+{
+	return rdmsr_on_cpu(msr_no, &(msrs[0].l), &(msrs[0].h));
+}
+static inline int wrmsr_on_cpus(const cpumask_t *m, u32 msr_no, struct msr **msrs)
+{
+	return wrmsr_on_cpu(msr_no, msrs[0].l, msrs[0].h);
+}
 static inline int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no,
 				    u32 *l, u32 *h)
 {
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 55e11aa..f9d3563 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -2,7 +2,7 @@
 # Makefile for x86 specific library files.
 #
 
-obj-$(CONFIG_SMP) := msr-on-cpu.o
+obj-$(CONFIG_SMP) := msr.o
 
 lib-y := delay.o
 lib-y += thunk_$(BITS).o
diff --git a/arch/x86/lib/msr-on-cpu.c b/arch/x86/lib/msr-on-cpu.c
deleted file mode 100644
index 321cf72..0000000
--- a/arch/x86/lib/msr-on-cpu.c
+++ /dev/null
@@ -1,97 +0,0 @@
-#include <linux/module.h>
-#include <linux/preempt.h>
-#include <linux/smp.h>
-#include <asm/msr.h>
-
-struct msr_info {
-	u32 msr_no;
-	u32 l, h;
-	int err;
-};
-
-static void __rdmsr_on_cpu(void *info)
-{
-	struct msr_info *rv = info;
-
-	rdmsr(rv->msr_no, rv->l, rv->h);
-}
-
-static void __wrmsr_on_cpu(void *info)
-{
-	struct msr_info *rv = info;
-
-	wrmsr(rv->msr_no, rv->l, rv->h);
-}
-
-int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
-{
-	int err;
-	struct msr_info rv;
-
-	rv.msr_no = msr_no;
-	err = smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 1);
-	*l = rv.l;
-	*h = rv.h;
-
-	return err;
-}
-
-int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
-{
-	int err;
-	struct msr_info rv;
-
-	rv.msr_no = msr_no;
-	rv.l = l;
-	rv.h = h;
-	err = smp_call_function_single(cpu, __wrmsr_on_cpu, &rv, 1);
-
-	return err;
-}
-
-/* These "safe" variants are slower and should be used when the target MSR
-   may not actually exist. */
-static void __rdmsr_safe_on_cpu(void *info)
-{
-	struct msr_info *rv = info;
-
-	rv->err = rdmsr_safe(rv->msr_no, &rv->l, &rv->h);
-}
-
-static void __wrmsr_safe_on_cpu(void *info)
-{
-	struct msr_info *rv = info;
-
-	rv->err = wrmsr_safe(rv->msr_no, rv->l, rv->h);
-}
-
-int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
-{
-	int err;
-	struct msr_info rv;
-
-	rv.msr_no = msr_no;
-	err = smp_call_function_single(cpu, __rdmsr_safe_on_cpu, &rv, 1);
-	*l = rv.l;
-	*h = rv.h;
-
-	return err ? err : rv.err;
-}
-
-int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
-{
-	int err;
-	struct msr_info rv;
-
-	rv.msr_no = msr_no;
-	rv.l = l;
-	rv.h = h;
-	err = smp_call_function_single(cpu, __wrmsr_safe_on_cpu, &rv, 1);
-
-	return err ? err : rv.err;
-}
-
-EXPORT_SYMBOL(rdmsr_on_cpu);
-EXPORT_SYMBOL(wrmsr_on_cpu);
-EXPORT_SYMBOL(rdmsr_safe_on_cpu);
-EXPORT_SYMBOL(wrmsr_safe_on_cpu);
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
new file mode 100644
index 0000000..0641498
--- /dev/null
+++ b/arch/x86/lib/msr.c
@@ -0,0 +1,152 @@
+#include <linux/module.h>
+#include <linux/preempt.h>
+#include <linux/smp.h>
+#include <asm/msr.h>
+
+struct msr_info {
+	u32 msr_no;
+	u32 l, h;
+	int err;
+};
+
+static void __rdmsr_on_cpu(void *info)
+{
+	struct msr_info *rv = info;
+
+	rdmsr(rv->msr_no, rv->l, rv->h);
+}
+
+static void __wrmsr_on_cpu(void *info)
+{
+	struct msr_info *rv = info;
+
+	wrmsr(rv->msr_no, rv->l, rv->h);
+}
+
+int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+{
+	int err;
+	struct msr_info rv;
+
+	rv.msr_no = msr_no;
+	err = smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 1);
+	*l = rv.l;
+	*h = rv.h;
+
+	return err;
+}
+
+int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+{
+	int err;
+	struct msr_info rv;
+
+	rv.msr_no = msr_no;
+	rv.l = l;
+	rv.h = h;
+	err = smp_call_function_single(cpu, __wrmsr_on_cpu, &rv, 1);
+
+	return err;
+}
+
+/* rdmsr on a bunch of CPUs
+ *
+ * @mask:	which CPUs
+ * @msr_no:	which MSR
+ * @msrs:	array of MSR values
+ *
+ * Returns:
+ * 0 - success
+ * <0 - read failed on at least one CPU (latter in the mask)
+ */
+int rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
+{
+	struct msr *reg;
+	int cpu, tmp, err = 0;
+	int off = cpumask_first(mask);
+
+	for_each_cpu(cpu, mask) {
+		reg = &msrs[cpu - off];
+
+		tmp = rdmsr_on_cpu(cpu, msr_no, &reg->l, &reg->h);
+		if (tmp)
+			err = tmp;
+	}
+	return err;
+}
+
+/*
+ * wrmsr of a bunch of CPUs
+ *
+ * @mask:	which CPUs
+ * @msr_no:	which MSR
+ * @msrs:	array of MSR values
+  *
+ * Returns:
+ * 0 - success
+ * <0 - write failed on at least one CPU (latter in the mask)
+ */
+int wrmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
+{
+	struct msr reg;
+	int cpu, tmp, err = 0;
+	int off = cpumask_first(mask);
+
+	for_each_cpu(cpu, mask) {
+		reg = msrs[cpu - off];
+
+		tmp = wrmsr_on_cpu(cpu, msr_no, reg.l, reg.h);
+		if (tmp)
+			err = tmp;
+	}
+	return err;
+}
+
+/* These "safe" variants are slower and should be used when the target MSR
+   may not actually exist. */
+static void __rdmsr_safe_on_cpu(void *info)
+{
+	struct msr_info *rv = info;
+
+	rv->err = rdmsr_safe(rv->msr_no, &rv->l, &rv->h);
+}
+
+static void __wrmsr_safe_on_cpu(void *info)
+{
+	struct msr_info *rv = info;
+
+	rv->err = wrmsr_safe(rv->msr_no, rv->l, rv->h);
+}
+
+int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+{
+	int err;
+	struct msr_info rv;
+
+	rv.msr_no = msr_no;
+	err = smp_call_function_single(cpu, __rdmsr_safe_on_cpu, &rv, 1);
+	*l = rv.l;
+	*h = rv.h;
+
+	return err ? err : rv.err;
+}
+
+int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+{
+	int err;
+	struct msr_info rv;
+
+	rv.msr_no = msr_no;
+	rv.l = l;
+	rv.h = h;
+	err = smp_call_function_single(cpu, __wrmsr_safe_on_cpu, &rv, 1);
+
+	return err ? err : rv.err;
+}
+
+EXPORT_SYMBOL(rdmsr_on_cpu);
+EXPORT_SYMBOL(wrmsr_on_cpu);
+EXPORT_SYMBOL(rdmsr_on_cpus);
+EXPORT_SYMBOL(wrmsr_on_cpus);
+EXPORT_SYMBOL(rdmsr_safe_on_cpu);
+EXPORT_SYMBOL(wrmsr_safe_on_cpu);
-- 
1.6.2.4


