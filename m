Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbZLCUnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbZLCUnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 15:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755045AbZLCUnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 15:43:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56891 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424AbZLCUnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 15:43:04 -0500
Date: Thu, 3 Dec 2009 21:42:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpu for v2.6.33
Message-ID: <20091203204258.GA11209@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cpu-for-linus

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      x86, msr: Unify rdmsr_on_cpus/wrmsr_on_cpus

Frederic Weisbecker (1):
      x86, msr: Remove the bkl from msr_open()

John Kacur (2):
      x86, cpuid: Remove the bkl from cpuid_open()
      x86, cpuid: Simplify the code in cpuid_open

Matteo Croce (1):
      x86: AMD Geode LX optimizations

Rusty Russell (1):
      x86, msr, cpumask: Use struct cpumask rather than the deprecated cpumask_t


 arch/x86/Kconfig.cpu       |    2 +-
 arch/x86/Makefile_32.cpu   |    2 +-
 arch/x86/include/asm/msr.h |    8 +++---
 arch/x86/kernel/cpuid.c    |   17 +++++----------
 arch/x86/kernel/msr.c      |   16 +++++---------
 arch/x86/lib/msr.c         |   46 ++++++++++++++++++-------------------------
 6 files changed, 37 insertions(+), 54 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 527519b..979de29 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -406,7 +406,7 @@ config X86_CMPXCHG64
 # generates cmov.
 config X86_CMOV
 	def_bool y
-	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64 || MATOM)
+	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64 || MATOM || MGEODE_LX)
 
 config X86_MINIMUM_CPU_FAMILY
 	int
diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
index 30e9a26..cbf0776 100644
--- a/arch/x86/Makefile_32.cpu
+++ b/arch/x86/Makefile_32.cpu
@@ -41,7 +41,7 @@ cflags-$(CONFIG_X86_ELAN)	+= -march=i486
 
 # Geode GX1 support
 cflags-$(CONFIG_MGEODEGX1)	+= -march=pentium-mmx
-
+cflags-$(CONFIG_MGEODE_LX)	+= $(call cc-option,-march=geode,-march=pentium-mmx)
 # add at the end to overwrite eventual tuning options from earlier
 # cpu entries
 cflags-$(CONFIG_X86_GENERIC) 	+= $(call tune,generic,$(call tune,i686))
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 7e2b6ba..5bef931 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -247,8 +247,8 @@ do {                                                            \
 #ifdef CONFIG_SMP
 int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
-void rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs);
-void wrmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs);
+void rdmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs);
+void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs);
 int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
 int rdmsr_safe_regs_on_cpu(unsigned int cpu, u32 regs[8]);
@@ -264,12 +264,12 @@ static inline int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 	wrmsr(msr_no, l, h);
 	return 0;
 }
-static inline void rdmsr_on_cpus(const cpumask_t *m, u32 msr_no,
+static inline void rdmsr_on_cpus(const struct cpumask *m, u32 msr_no,
 				struct msr *msrs)
 {
        rdmsr_on_cpu(0, msr_no, &(msrs[0].l), &(msrs[0].h));
 }
-static inline void wrmsr_on_cpus(const cpumask_t *m, u32 msr_no,
+static inline void wrmsr_on_cpus(const struct cpumask *m, u32 msr_no,
 				struct msr *msrs)
 {
        wrmsr_on_cpu(0, msr_no, msrs[0].l, msrs[0].h);
diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index b07af88..48e8e65 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -116,21 +116,16 @@ static int cpuid_open(struct inode *inode, struct file *file)
 {
 	unsigned int cpu;
 	struct cpuinfo_x86 *c;
-	int ret = 0;
-
-	lock_kernel();
 
 	cpu = iminor(file->f_path.dentry->d_inode);
-	if (cpu >= nr_cpu_ids || !cpu_online(cpu)) {
-		ret = -ENXIO;	/* No such CPU */
-		goto out;
-	}
+	if (cpu >= nr_cpu_ids || !cpu_online(cpu))
+		return -ENXIO;	/* No such CPU */
+
 	c = &cpu_data(cpu);
 	if (c->cpuid_level < 0)
-		ret = -EIO;	/* CPUID not supported */
-out:
-	unlock_kernel();
-	return ret;
+		return -EIO;	/* CPUID not supported */
+
+	return 0;
 }
 
 /*
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 7dd9500..c006109 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -174,21 +174,17 @@ static int msr_open(struct inode *inode, struct file *file)
 {
 	unsigned int cpu = iminor(file->f_path.dentry->d_inode);
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	int ret = 0;
 
-	lock_kernel();
 	cpu = iminor(file->f_path.dentry->d_inode);
 
-	if (cpu >= nr_cpu_ids || !cpu_online(cpu)) {
-		ret = -ENXIO;	/* No such CPU */
-		goto out;
-	}
+	if (cpu >= nr_cpu_ids || !cpu_online(cpu))
+		return -ENXIO;	/* No such CPU */
+
 	c = &cpu_data(cpu);
 	if (!cpu_has(c, X86_FEATURE_MSR))
-		ret = -EIO;	/* MSR not supported */
-out:
-	unlock_kernel();
-	return ret;
+		return -EIO;	/* MSR not supported */
+
+	return 0;
 }
 
 /*
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index 33a1e3c..41628b1 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -71,14 +71,9 @@ int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 }
 EXPORT_SYMBOL(wrmsr_on_cpu);
 
-/* rdmsr on a bunch of CPUs
- *
- * @mask:       which CPUs
- * @msr_no:     which MSR
- * @msrs:       array of MSR values
- *
- */
-void rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
+static void __rwmsr_on_cpus(const struct cpumask *mask, u32 msr_no,
+			    struct msr *msrs,
+			    void (*msr_func) (void *info))
 {
 	struct msr_info rv;
 	int this_cpu;
@@ -92,11 +87,23 @@ void rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
 	this_cpu = get_cpu();
 
 	if (cpumask_test_cpu(this_cpu, mask))
-		__rdmsr_on_cpu(&rv);
+		msr_func(&rv);
 
-	smp_call_function_many(mask, __rdmsr_on_cpu, &rv, 1);
+	smp_call_function_many(mask, msr_func, &rv, 1);
 	put_cpu();
 }
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
 EXPORT_SYMBOL(rdmsr_on_cpus);
 
 /*
@@ -107,24 +114,9 @@ EXPORT_SYMBOL(rdmsr_on_cpus);
  * @msrs:       array of MSR values
  *
  */
-void wrmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
+void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs)
 {
-	struct msr_info rv;
-	int this_cpu;
-
-	memset(&rv, 0, sizeof(rv));
-
-	rv.off    = cpumask_first(mask);
-	rv.msrs   = msrs;
-	rv.msr_no = msr_no;
-
-	this_cpu = get_cpu();
-
-	if (cpumask_test_cpu(this_cpu, mask))
-		__wrmsr_on_cpu(&rv);
-
-	smp_call_function_many(mask, __wrmsr_on_cpu, &rv, 1);
-	put_cpu();
+	__rwmsr_on_cpus(mask, msr_no, msrs, __wrmsr_on_cpu);
 }
 EXPORT_SYMBOL(wrmsr_on_cpus);
 
