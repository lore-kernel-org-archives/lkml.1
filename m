Return-Path: <linux-kernel-owner+w=401wt.eu-S965253AbZLPXQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965253AbZLPXQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935282AbZLPXQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:16:35 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:29578 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965221AbZLPXQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:16:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=VPsQIve6/9Cv2wpnXIeULWRhRqlfvW1sgJlIKbTzjlG6L9/eKH7RvBicoImFNu2f2N
         iiKmKqS02Ma6Vzit7aHBVFs60E8O5FX0ES60HdhGsai9yV/6F4VsJxraSU/Pe5gZpBv4
         YO6N/t3lvy1AWrg7UwCh7YCAph0fqwJwPV6Z8=
Date: Thu, 17 Dec 2009 00:16:25 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] x86 msrs: alloc/free for CONFIG_SMP=n
Message-ID: <20091216231625.GD27228@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Borislav Petkov <borislav.petkov@amd.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20091216183212.118c5e14.sfr@canb.auug.org.au>
 <20091216092424.5f87214c.randy.dunlap@oracle.com>
 <4B2919BD.40001@zytor.com>
 <20091216174524.GH11618@aftab>
 <4B2928AC.3020807@zytor.com>
 <20091216135119.e283e525.randy.dunlap@oracle.com>
 <20091216215808.GB27228@liondog.tnic>
 <4B296209.2010902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4B296209.2010902@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 02:41:13PM -0800, H. Peter Anvin wrote:
> My preference would be to move the SMP-specific functions to a new
> file, call it msr-smp.c, and then leave only the functions that should
> be included unconditionally in msr.c (I believe it is cleaner to do it
> that way than the opposite.)

v2:

---
From: Borislav Petkov <petkovbb@gmail.com>
Date: Wed, 16 Dec 2009 22:49:18 +0100
Subject: [PATCH] x86, msr: fix CONFIG_SMP=n build

Randy Dunlap reported the following build error:

"When CONFIG_SMP=n, CONFIG_X86_MSR=m:

ERROR: "msrs_free" [drivers/edac/amd64_edac_mod.ko] undefined!
ERROR: "msrs_alloc" [drivers/edac/amd64_edac_mod.ko] undefined!"

This is due to the fact that <arch/x86/lib/msr.c> is conditioned on
CONFIG_SMP and in the UP case we have only the stubs in the header.
Fork off SMP functionality into a new file (msr-smp.c) and build
msrs_{alloc,free} unconditionally.

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 arch/x86/include/asm/msr.h |   12 +++
 arch/x86/lib/Makefile      |    4 +-
 arch/x86/lib/msr-smp.c     |  204 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/lib/msr.c         |  213 --------------------------------------------
 4 files changed, 218 insertions(+), 215 deletions(-)
 create mode 100644 arch/x86/lib/msr-smp.c

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 2d228fc..a0157f2 100644
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
index 45b20e4..cffd754 100644
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
 lib-$(CONFIG_KPROBES) += insn.o inat.o
 
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
1.6.5


-- 
Regards/Gruss,
    Boris.
