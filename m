Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbZJNTaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbZJNTaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933130AbZJNTaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:30:04 -0400
Received: from claw.goop.org ([74.207.240.146]:55334 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759005AbZJNT35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:29:57 -0400
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Gerd Hoffmann <kraxel@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: [PATCH 10/12] x86/pvclock: add vsyscall implementation
Date: Wed, 14 Oct 2009 12:28:34 -0700
Message-Id: <1255548516-15260-11-git-send-email-jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
References: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows the pvclock mechanism to be used in usermode.  To
do this, we map an extra page into usermode containing an array of
pvclock_vcpu_time_info structures which give the information required
to compute a global system clock from the tsc.  With this, we can
implement pvclock_clocksource_vread().

One complication is that usermode is subject to two levels of scheduling:
kernel scheduling of tasks onto vcpus, and hypervisor scheduling of vcpus
onto pcpus.  In either case the underlying pcpu changed, and with it,
the correct set of parameters to compute tsc->system clock.

To address this we install a task migration notifier to update the "old"
vcpu's "migrate_count" number (ie, vcpu has had a task migrated away
from it).  Usermode can then check the migrate_count while computing
the time and retry with a new cpu number if it has changed.

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
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
---
 arch/x86/Kconfig                |    4 +
 arch/x86/include/asm/fixmap.h   |    4 +-
 arch/x86/include/asm/pvclock.h  |    6 ++
 arch/x86/include/asm/vsyscall.h |    3 +
 arch/x86/kernel/Makefile        |    2 +
 arch/x86/kernel/pvclock.c       |  149 ++++++++++++++++++++++++++++++++++++--
 6 files changed, 159 insertions(+), 9 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7950d54..50a5771 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -522,6 +522,10 @@ config PARAVIRT_CLOCK
 	bool
 	default n
 
+config PARAVIRT_CLOCK_VSYSCALL
+       bool
+       depends on PARAVIRT_CLOCK && X86_VSYSCALL
+
 endif
 
 config PARAVIRT_DEBUG
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 3b63b57..b15c865 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -82,7 +82,9 @@ enum fixed_addresses {
 			    + ((VSYSCALL_END-VSYSCALL_START) >> PAGE_SHIFT) - 1,
 	VSYSCALL_HPET,
 #endif	/* CONFIG_X86_VSYSCALL */
-
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
index bb90047..80a027d 100644
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
index 1c9ec2f..88d51cb 100644
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
index e43cd78..0bed867 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -17,7 +17,11 @@
 
 #include <linux/kernel.h>
 #include <linux/percpu.h>
+#include <linux/sched.h>
+
 #include <asm/pvclock.h>
+#include <asm/vsyscall.h>
+#include <asm/vgtod.h>
 
 /*
  * Scale a 64-bit delta by scaling and multiplying by a 32-bit fraction,
@@ -57,9 +61,10 @@ static inline u64 scale_delta(u64 delta, u32 mul_frac, int shift)
 	return product;
 }
 
-static u64 pvclock_get_nsec_offset(const struct pvclock_vcpu_time_info *src)
+static __always_inline
+u64 pvclock_get_nsec_offset(const struct pvclock_vcpu_time_info *src)
 {
-	u64 delta = native_read_tsc() - src->tsc_timestamp;
+	u64 delta = __native_read_tsc() - src->tsc_timestamp;
 	return scale_delta(delta, src->tsc_to_system_mul, src->tsc_shift);
 }
 
@@ -75,17 +80,30 @@ unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src)
 	return pv_tsc_khz;
 }
 
-cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
+static __always_inline
+unsigned __pvclock_read_cycles(const struct pvclock_vcpu_time_info *src,
+			       cycle_t *cycles)
 {
 	unsigned version;
 	cycle_t ret, offset;
 
+	version = src->version;
+	rdtsc_barrier();
+	offset = pvclock_get_nsec_offset(src);
+	ret = src->system_time + offset;
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
-		version = src->version;
-		rdtsc_barrier();
-		offset = pvclock_get_nsec_offset(src);
-		ret = src->system_time + offset;
-		rdtsc_barrier();
+		version = __pvclock_read_cycles(src, &ret);
 	} while (version != src->version);
 
 	return ret;
@@ -116,3 +134,118 @@ void pvclock_read_wallclock(struct pvclock_wall_clock *wall_clock,
 
 	set_normalized_timespec(ts, now.tv_sec, now.tv_nsec);
 }
+
+#ifdef CONFIG_PARAVIRT_CLOCK_VSYSCALL
+
+typedef union {
+	struct pvclock_vsyscall_time_info {
+		struct pvclock_vcpu_time_info pvti;
+		u32 migrate_count;
+	} info;
+	char pad[SMP_CACHE_BYTES];
+} aligned_pvti_t ____cacheline_aligned;
+
+static aligned_pvti_t *pvclock_vsyscall_time_info;
+
+static struct pvclock_vsyscall_time_info *pvclock_get_vsyscall_user_time_info(int cpu)
+{
+	if (pvclock_vsyscall_time_info == NULL)
+		return NULL;
+
+	return &pvclock_vsyscall_time_info[cpu].info;
+}
+
+struct pvclock_vcpu_time_info *pvclock_get_vsyscall_time_info(int cpu)
+{
+	return &pvclock_get_vsyscall_user_time_info(cpu)->pvti;
+}
+
+cycle_t __vsyscall_fn pvclock_clocksource_vread(void)
+{
+	const aligned_pvti_t *pvti_base;
+	const struct pvclock_vsyscall_time_info *pvti;
+	cycle_t ret;
+	u32 version;
+	u32 migrate_count;
+	unsigned cpu, cpu1;
+
+	pvti_base = (aligned_pvti_t *)fix_to_virt(FIX_PVCLOCK_TIME_INFO);
+
+	/*
+	 * When looping to get a consistent (time-info, tsc) pair, we
+	 * also need to deal with the possibility we can switch vcpus,
+	 * so make sure we always re-fetch time-info for the current vcpu.
+	 */
+	do {
+		vgetcpu(&cpu, NULL, NULL);
+		pvti = &pvti_base[cpu].info;
+
+		migrate_count = pvti->migrate_count;
+		version = __pvclock_read_cycles(&pvti->pvti, &ret);
+
+		/*
+		 * Test we're still on the cpu as well as the version.
+		 * We could have been mograted just after the first
+		 * vgetcpu but before fetching the version, so we
+		 * wouldn't notice a version change.
+		 */
+		vgetcpu(&cpu1, NULL, NULL);
+	} while (unlikely(cpu != cpu1 ||
+			  pvti->pvti.version != version ||
+			  pvti->migrate_count != migrate_count));
+
+	return ret >= __vsyscall_gtod_data.clock.cycle_last ?
+		ret : __vsyscall_gtod_data.clock.cycle_last;
+}
+
+int pvclock_task_migrate(struct notifier_block *nb, unsigned long l, void *v)
+{
+	struct task_migration_notifier *mn = v;
+	struct pvclock_vsyscall_time_info *pvti;
+
+	pvti = pvclock_get_vsyscall_user_time_info(mn->from_cpu);
+
+	if (pvti == NULL)
+		return NOTIFY_DONE;
+
+	pvti->migrate_count++;
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block pvclock_migrate = {
+	.notifier_call = pvclock_task_migrate,
+};
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
+	if (nr_cpu_ids * sizeof(aligned_pvti_t) > PAGE_SIZE) {
+		printk(KERN_WARNING "pvclock_vsyscall: too many CPUs to fit time_info into a single page\n");
+		return -ENOSPC;
+	}
+
+	pvclock_vsyscall_time_info =
+		(aligned_pvti_t *)get_zeroed_page(GFP_KERNEL);
+	if (pvclock_vsyscall_time_info == NULL)
+		return -ENOMEM;
+
+	for (cpu = 0; cpu < nr_cpu_ids; cpu++)
+		pvclock_vsyscall_time_info[cpu].info.pvti.version = ~0;
+
+	__set_fixmap(FIX_PVCLOCK_TIME_INFO, __pa(pvclock_vsyscall_time_info),
+		     PAGE_KERNEL_VSYSCALL);
+
+	register_task_migration_notifier(&pvclock_migrate);
+
+	return 0;
+}
+
+#endif	/* CONFIG_PARAVIRT_CLOCK_VSYSCALL */
-- 
1.6.2.5

