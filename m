Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbZJFAvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbZJFAvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 20:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbZJFAvC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 20:51:02 -0400
Received: from claw.goop.org ([74.207.240.146]:35249 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797AbZJFAuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 20:50:55 -0400
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
To: Xen-devel <xen-devel@lists.xensource.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kurt.hackel@oracle.com, Dan Magenheimer <dan.magenheimer@oracle.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 3/5] x86/pvclock: add vsyscall implementation
Date: Mon,  5 Oct 2009 17:50:09 -0700
Message-Id: <1254790211-15416-4-git-send-email-jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows the pvclock mechanism to be used in usermode.  To
do this, we map an extra page into usermode containing an array of
pvclock_vcpu_time_info structures which give the information required
to compute a global system clock from the tsc.  With this, we can
implement pvclock_clocksource_vread().

One complication is that usermode is subject to two levels of scheduling:
kernel scheduling of tasks onto vcpus, and hypervisor scheduling of
vcpus onto pcpus.  In either case the underlying pcpu changed, and with
it, the correct set of parameters to compute tsc->system clock.  To
address this we install a preempt notifier on sched_out to increment
that vcpu's version number.  Usermode can then check the version number
is unchanged while computing the time and retry if it has (the only
difference from the kernel's version of the algorithm is that the vcpu
may have changed, so we may need to switch pvclock_vcpu_time_info
structures.

To use this feature, hypervisor-specific code is required
to call pvclock_init_vsyscall(), and if successful:
 - cause the pvclock_vcpu_time_info structure at
   pvclock_get_vsyscall_time_info(cpu) to be updated appropriately for
   each vcpu.
 - use pvclock_clocksource_vread as the implementation of clocksource
   .vread.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Keir Fraser <keir.fraser@eu.citrix.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Glauber Costa <gcosta@redhat.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
---
 arch/x86/Kconfig                |    4 +
 arch/x86/include/asm/fixmap.h   |    3 +
 arch/x86/include/asm/pvclock.h  |    6 ++
 arch/x86/include/asm/vsyscall.h |    3 +
 arch/x86/kernel/Makefile        |    2 +
 arch/x86/kernel/pvclock.c       |  152 ++++++++++++++++++++++++++++++++++++---
 6 files changed, 160 insertions(+), 10 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 13ffa5d..93346ff 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -518,6 +518,10 @@ config PARAVIRT_CLOCK
 	bool
 	default n
 
+config PARAVIRT_CLOCK_VSYSCALL
+       bool
+       depends on PARAVIRT_CLOCK && PREEMPT_NOTIFIERS
+
 endif
 
 config PARAVIRT_DEBUG
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 7b2d71d..ff3cffa 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -80,6 +80,9 @@ enum fixed_addresses {
 			    + ((VSYSCALL_END-VSYSCALL_START) >> PAGE_SHIFT) - 1,
 	VSYSCALL_HPET,
 #endif
+#ifdef CONFIG_PARAVIRT_CLOCK_VSYSCALL
+	FIX_PVCLOCK_TIME_INFO,
+#endif
 	FIX_DBGP_BASE,
 	FIX_EARLYCON_MEM_BASE,
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclock.h
index 53235fd..d2402b3 100644
--- a/arch/x86/include/asm/pvclock.h
+++ b/arch/x86/include/asm/pvclock.h
@@ -3,6 +3,7 @@
 
 #include <linux/clocksource.h>
 #include <asm/pvclock-abi.h>
+#include <asm/vsyscall.h>
 
 /* some helper functions for xen and kvm pv clock sources */
 cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src);
@@ -11,4 +12,9 @@ void pvclock_read_wallclock(struct pvclock_wall_clock *wall,
 			    struct pvclock_vcpu_time_info *vcpu,
 			    struct timespec *ts);
 
+int __init pvclock_init_vsyscall(void);
+struct pvclock_vcpu_time_info *pvclock_get_vsyscall_time_info(int cpu);
+
+cycle_t __vsyscall_fn pvclock_clocksource_vread(void);
+
 #endif /* _ASM_X86_PVCLOCK_H */
diff --git a/arch/x86/include/asm/vsyscall.h b/arch/x86/include/asm/vsyscall.h
index d0983d2..df5fb43 100644
--- a/arch/x86/include/asm/vsyscall.h
+++ b/arch/x86/include/asm/vsyscall.h
@@ -33,6 +33,9 @@ enum vsyscall_num {
 extern int __vgetcpu_mode;
 extern volatile unsigned long __jiffies;
 
+struct getcpu_cache;
+extern long vgetcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache);
+
 /* kernel space (writeable) */
 extern int vgetcpu_mode;
 extern struct timezone sys_tz;
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 430d5b2..97d2e88 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -24,10 +24,12 @@ CFLAGS_vsyscall_64.o	:= $(PROFILING) -g0 $(nostackp)
 CFLAGS_hpet.o		:= $(nostackp)
 CFLAGS_tsc.o		:= $(nostackp)
 CFLAGS_paravirt.o	:= $(nostackp)
+CFLAGS_pvclock.o	:= $(nostackp)
 GCOV_PROFILE_vsyscall_64.o	:= n
 GCOV_PROFILE_hpet.o		:= n
 GCOV_PROFILE_tsc.o		:= n
 GCOV_PROFILE_paravirt.o		:= n
+GCOV_PROFILE_pvclock.o		:= n
 
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 5ecce7f..14de7f3 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -17,7 +17,9 @@
 
 #include <linux/kernel.h>
 #include <linux/percpu.h>
+
 #include <asm/pvclock.h>
+#include <asm/vsyscall.h>
 
 /*
  * These are perodically updated
@@ -71,9 +73,10 @@ static inline u64 scale_delta(u64 delta, u32 mul_frac, int shift)
 	return product;
 }
 
-static u64 pvclock_get_nsec_offset(struct pvclock_shadow_time *shadow)
+static __always_inline
+u64 pvclock_get_nsec_offset(struct pvclock_shadow_time *shadow)
 {
-	u64 delta = native_read_tsc() - shadow->tsc_timestamp;
+	u64 delta = __native_read_tsc() - shadow->tsc_timestamp;
 	return scale_delta(delta, shadow->tsc_to_nsec_mul, shadow->tsc_shift);
 }
 
@@ -81,8 +84,9 @@ static u64 pvclock_get_nsec_offset(struct pvclock_shadow_time *shadow)
  * Reads a consistent set of time-base values from hypervisor,
  * into a shadow data area.
  */
-static unsigned pvclock_get_time_values(struct pvclock_shadow_time *dst,
-					struct pvclock_vcpu_time_info *src)
+static __always_inline
+unsigned pvclock_get_time_values(struct pvclock_shadow_time *dst,
+				 const struct pvclock_vcpu_time_info *src)
 {
 	do {
 		dst->version = src->version;
@@ -109,18 +113,31 @@ unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src)
 	return pv_tsc_khz;
 }
 
-cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
+static __always_inline
+unsigned __pvclock_read_cycles(const struct pvclock_vcpu_time_info *src,
+			       cycle_t *cycles)
 {
 	struct pvclock_shadow_time shadow;
 	unsigned version;
 	cycle_t ret, offset;
 
+	version = pvclock_get_time_values(&shadow, src);
+	rdtsc_barrier();
+	offset = pvclock_get_nsec_offset(&shadow);
+	ret = shadow.system_timestamp + offset;
+	rdtsc_barrier();
+
+	*cycles = ret;
+	return version;
+}
+
+cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
+{
+	unsigned version;
+	cycle_t ret;
+
 	do {
-		version = pvclock_get_time_values(&shadow, src);
-		rdtsc_barrier();
-		offset = pvclock_get_nsec_offset(&shadow);
-		ret = shadow.system_timestamp + offset;
-		rdtsc_barrier();
+		version = __pvclock_read_cycles(src, &ret);
 	} while (version != src->version);
 
 	return ret;
@@ -151,3 +168,118 @@ void pvclock_read_wallclock(struct pvclock_wall_clock *wall_clock,
 
 	set_normalized_timespec(ts, now.tv_sec, now.tv_nsec);
 }
+
+#ifdef CONFIG_PARAVIRT_CLOCK_VSYSCALL
+
+static struct pvclock_vcpu_time_info *pvclock_vsyscall_time_info;
+
+struct pvclock_vcpu_time_info *pvclock_get_vsyscall_time_info(int cpu)
+{
+	if (pvclock_vsyscall_time_info == NULL)
+		return NULL;
+
+	return &pvclock_vsyscall_time_info[cpu];
+}
+
+static void vti_inc_version(struct pvclock_vcpu_time_info *pvti)
+{
+	/*
+	 * This increments the version in an interrupt-atomic way.
+	 * We're not concerned about global bus (inter-cpu) atomicity,
+	 * but we just need to make sure the update can't be
+	 * interrupted by the hypervisor preempting us.
+	 */
+#ifdef CONFIG_X86
+	asm("add $2, %0\n" : "+m" (pvti->version));
+#else
+#error FIXME
+#endif
+}
+
+/*
+ * Increment version when switching away from a task so that it can
+ * tell if it has switched vcpus (hypervisor's update of the version
+ * will tell it if it switches pcpus).
+ */
+static void pvclock_vsyscall_sched_out(struct preempt_notifier *pn,
+				       struct task_struct *next)
+{
+	int cpu = smp_processor_id();
+	struct pvclock_vcpu_time_info *pvti;
+
+	pvti = pvclock_get_vsyscall_time_info(cpu);
+	if (pvti)
+		vti_inc_version(pvti);
+}
+
+/* Don't care about scheduling in */
+static void pvclock_vsyscall_sched_in(struct preempt_notifier *notifier, int cpu)
+{
+}
+
+static struct preempt_notifier pvclock_vsyscall_notifier;
+static struct preempt_ops pvclock_vsyscall_preempt_ops = {
+	.sched_in = pvclock_vsyscall_sched_in,
+	.sched_out = pvclock_vsyscall_sched_out,
+};
+
+cycle_t __vsyscall_fn pvclock_clocksource_vread(void)
+{
+	const struct pvclock_vcpu_time_info *pvti_base;
+	const struct pvclock_vcpu_time_info *pvti;
+	cycle_t ret;
+	u32 version;
+
+	pvti_base = (struct pvclock_vcpu_time_info *)fix_to_virt(FIX_PVCLOCK_TIME_INFO);
+
+	/*
+	 * When looping to get a consistent (time-info, tsc) pair, we
+	 * also need to deal with the possibility we can switch vcpus,
+	 * so make sure we always re-fetch time-info for the current vcpu.
+	 */
+	do {
+		unsigned cpu;
+
+		vgetcpu(&cpu, NULL, NULL);
+		pvti = &pvti_base[cpu];
+
+		version = __pvclock_read_cycles(pvti, &ret);
+	} while (unlikely(pvti->version != version));
+
+	return ret;
+}
+
+/*
+ * Initialize the generic pvclock vsyscall state.  This will allocate
+ * a/some page(s) for the per-vcpu pvclock information, set up a
+ * fixmap mapping for the page(s)
+ */
+int __init pvclock_init_vsyscall(void)
+{
+	int cpu;
+
+	/* Just one page for now */
+	if (nr_cpu_ids * sizeof(struct vcpu_time_info) > PAGE_SIZE) {
+		printk(KERN_WARNING "pvclock_vsyscall: too many CPUs to fit time_info into a single page\n");
+		return -ENOSPC;
+	}
+
+	pvclock_vsyscall_time_info =
+		(struct pvclock_vcpu_time_info *)get_zeroed_page(GFP_KERNEL);
+	if (pvclock_vsyscall_time_info == NULL)
+		return -ENOMEM;
+
+	for (cpu = 0; cpu < nr_cpu_ids; cpu++)
+		pvclock_vsyscall_time_info[cpu].version = ~0;
+
+	__set_fixmap(FIX_PVCLOCK_TIME_INFO, __pa(pvclock_vsyscall_time_info),
+		     PAGE_KERNEL_VSYSCALL);
+
+	preempt_notifier_init(&pvclock_vsyscall_notifier,
+			      &pvclock_vsyscall_preempt_ops);
+	preempt_notifier_register(&pvclock_vsyscall_notifier);
+
+	return 0;
+}
+
+#endif	/* CONFIG_PARAVIRT_CLOCK_VSYSCALL */
-- 
1.6.2.5

