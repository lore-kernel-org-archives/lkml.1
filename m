Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbZESRZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbZESRZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 13:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZESRZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 13:25:08 -0400
Received: from sg2ehsobe001.messaging.microsoft.com ([207.46.51.75]:38040 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751177AbZESRZH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 13:25:07 -0400
X-BigFish: VPS-23(zz1432R98dR1805Mzz1202hzzz32i6bh6di61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KJWJ16-02-1DE-01
Date: Tue, 19 May 2009 19:24:49 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu, hpa@zytor.com
CC: norsk5@yahoo.com, tglx@linutronix.de, mchehab@redhat.com, aris@redhat.com,
       edt@aei.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/22] x86: add methods for writing of an MSR on
	several CPUs
Message-ID: <20090519172449.GB18874@aftab>
References: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com> <1242390153-24493-2-git-send-email-borislav.petkov@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1242390153-24493-2-git-send-email-borislav.petkov@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 19 May 2009 17:24:48.0887 (UTC) FILETIME=[B625C870:01C9D8A6]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, May 15, 2009 at 02:22:12PM +0200, Borislav Petkov wrote:
> Add a struct representing a 64bit MSR pair consisting of a low and high
> register part.
> 
> Also, rename msr-on-cpu.c to msr.c accordingly.
> 
> Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> CC: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

here's an updated version of the patch fixing a linux-next allmodconfig build
issue.

Peter, let me know in case there are any objections.

Thanks.

--

From: Borislav Petkov <borislav.petkov@amd.com>
Date: Wed, 29 Apr 2009 15:20:11 +0200
Subject: [PATCH UPDATED 01/22] x86: add methods for writing of an MSR on several CPUs

Add a struct representing a 64bit MSR pair consisting of a low and high
register part.

Also, rename msr-on-cpu.c to msr.c accordingly.

Finally, put the cpumask.h include in __KERNEL__ space and thus fix a
allmodconfig build failure in the headers_check target. Fix a bunch of
checkpatch issues, while at it.

Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/msr.h |   23 +++++++
 arch/x86/lib/Makefile      |    2 +-
 arch/x86/lib/msr-on-cpu.c  |   97 ----------------------------
 arch/x86/lib/msr.c         |  151 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 175 insertions(+), 98 deletions(-)
 delete mode 100644 arch/x86/lib/msr-on-cpu.c
 create mode 100644 arch/x86/lib/msr.c

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 638bf62..e49c14e 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -12,6 +12,17 @@
 
 #include <asm/asm.h>
 #include <asm/errno.h>
+#include <asm/cpumask.h>
+
+struct msr {
+	union {
+		struct {
+			u32 l;
+			u32 h;
+		};
+		u64 q;
+	};
+};
 
 static inline unsigned long long native_read_tscp(unsigned int *aux)
 {
@@ -216,6 +227,8 @@ do {                                                            \
 #ifdef CONFIG_SMP
 int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
+int rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs);
+int wrmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs);
 int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
 #else  /*  CONFIG_SMP  */
@@ -229,6 +242,16 @@ static inline int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 	wrmsr(msr_no, l, h);
 	return 0;
 }
+static inline int rdmsr_on_cpus(const cpumask_t *m, u32 msr_no,
+				struct msr **msrs)
+{
+	return rdmsr_on_cpu(msr_no, &(msrs[0].l), &(msrs[0].h));
+}
+static inline int wrmsr_on_cpus(const cpumask_t *m, u32 msr_no,
+				struct msr **msrs)
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
index 0000000..774dc29
--- /dev/null
+++ b/arch/x86/lib/msr.c
@@ -0,0 +1,151 @@
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
+EXPORT_SYMBOL(rdmsr_on_cpu);
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
+EXPORT_SYMBOL(wrmsr_on_cpu);
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
+EXPORT_SYMBOL(rdmsr_on_cpus);
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
+EXPORT_SYMBOL(wrmsr_on_cpus);
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
+EXPORT_SYMBOL(rdmsr_safe_on_cpu);
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
+EXPORT_SYMBOL(wrmsr_safe_on_cpu);
-- 
1.6.2.4


-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

