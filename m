Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbZEDQrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbZEDQrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbZEDQq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:46:57 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:46771 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674AbZEDQq4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:46:56 -0400
X-BigFish: VPS-17(zz1432R98dR1805M936fJzz1202hzzz32i6bh6di15fn43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KJ4P9P-01-0HF-01
Date: Mon, 4 May 2009 18:46:14 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu,
       tglx@linutronix.de, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 01/21] x86: add methods for writing of an MSR on
	several CPUs
Message-ID: <20090504164614.GA21710@aftab>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <1241024107-14535-2-git-send-email-borislav.petkov@amd.com> <49F890D0.7000109@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <49F890D0.7000109@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 04 May 2009 16:46:17.0993 (UTC) FILETIME=[D88D1790:01C9CCD7]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(adding Mauro to CC)

On Wed, Apr 29, 2009 at 10:39:28AM -0700, H. Peter Anvin wrote:
> Borislav Petkov wrote:
> > +}
> > +
> > +/* rdmsr on a bunch of cpus
> > + *
> > + * @mask:	which cpus
> > + * @msr_no:	which MSR
> > + * @l:		array of the lower 32-bit MSR values
> > + * @h:		array of the higher 32-bit MSR values
> > + *
> 
> Urk!
> 
> Please, for the love of God, no!
> 
> Make it an array of u64s or (equivalently!) an array of (l,h)
> structures, not separate arrays for the halves of the register.

how about something like the following then? If there's agreement I could
convert all users to struct msr later.

@Mauro: here's 1/21.

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Wed, 29 Apr 2009 15:20:11 +0200
Subject: [PATCH] x86: add methods for writing of an MSR on several CPUs

Add a struct representing a 64bit MSR pair consisting of a low and high
register part.

Also, rename msr-on-cpu.c to msr.c accordingly.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/msr.h |   16 +++++
 arch/x86/lib/Makefile      |    2 +-
 arch/x86/lib/msr-on-cpu.c  |   97 ----------------------------
 arch/x86/lib/msr.c         |  152 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 169 insertions(+), 98 deletions(-)
 delete mode 100644 arch/x86/lib/msr-on-cpu.c
 create mode 100644 arch/x86/lib/msr.c

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 638bf62..7f117a6 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_MSR_H
 
 #include <asm/msr-index.h>
+#include <asm/cpumask.h>
 
 #ifndef __ASSEMBLY__
 # include <linux/types.h>
@@ -13,6 +14,11 @@
 #include <asm/asm.h>
 #include <asm/errno.h>
 
+struct msr {
+	u32 l;
+	u32 h;
+};
+
 static inline unsigned long long native_read_tscp(unsigned int *aux)
 {
 	unsigned long low, high;
@@ -216,6 +222,8 @@ do {                                                            \
 #ifdef CONFIG_SMP
 int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
+int rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs);
+int wrmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs);
 int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
 #else  /*  CONFIG_SMP  */
@@ -229,6 +237,14 @@ static inline int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
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
index 0000000..0ba5402
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
+	struct msr reg;
+	int cpu, tmp, err = 0;
+	int off = cpumask_first(mask);
+
+	for_each_cpu(cpu, mask) {
+		reg = msrs[cpu - off];
+
+		tmp = rdmsr_on_cpu(cpu, msr_no, &reg.l, &reg.h);
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


-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

