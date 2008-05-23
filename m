Return-Path: <linux-kernel-owner+w=401wt.eu-S1759737AbYEWVuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737AbYEWVuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 17:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757577AbYEWVuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 17:50:15 -0400
Received: from www.tglx.de ([62.245.132.106]:54484 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837AbYEWVuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 17:50:12 -0400
Date: Fri, 23 May 2008 23:49:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] x86 fixes for 2.6.26
Message-ID: <alpine.LFD.1.10.0805232314540.3295@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull x86 fixes for 2.6.26 from:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git x86-fixes-for-linus

Thanks,
	tglx
---
Andi Kleen (1):
      x86: use explicit copy in vdso_gettimeofday()

Chuck Ebbert (1):
      x86: don't read maxlvt before checking if APIC is mapped

Ingo Molnar (2):
      namespacecheck: automated fixes
      x86: prevent PGE flush from interruption/preemption

Jan Beulich (1):
      x86/xen: fix arbitrary_virt_to_machine()

Thomas Gleixner (3):
      x86: fix setup of cyc2ns in tsc_64.c
      x86: distangle user disabled TSC from unstable
      x86: disable TSC for sched_clock() when calibration failed

 arch/x86/kernel/apic_64.c      |    2 +-
 arch/x86/kernel/kvmclock.c     |    4 ++--
 arch/x86/kernel/tsc_32.c       |   25 +++++++++++++++----------
 arch/x86/kernel/tsc_64.c       |    5 +++--
 arch/x86/kvm/mmu.c             |    2 +-
 arch/x86/vdso/vclock_gettime.c |    6 +++---
 arch/x86/xen/mmu.c             |    2 +-
 include/asm-x86/tlbflush.h     |   13 ++++++++++++-
 8 files changed, 38 insertions(+), 21 deletions(-)
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 5910020..0633cfd 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -534,7 +534,7 @@ int setup_profiling_timer(unsigned int multiplier)
  */
 void clear_local_APIC(void)
 {
-	int maxlvt = lapic_get_maxlvt();
+	int maxlvt;
 	u32 v;
 
 	/* APIC hasn't been mapped yet */
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 4bc1be5..08a3098 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -53,7 +53,7 @@ static cycle_t kvm_clock_read(void);
  * have elapsed since the hypervisor wrote the data. So we try to account for
  * that with system time
  */
-unsigned long kvm_get_wallclock(void)
+static unsigned long kvm_get_wallclock(void)
 {
 	u32 wc_sec, wc_nsec;
 	u64 delta;
@@ -86,7 +86,7 @@ unsigned long kvm_get_wallclock(void)
 	return ts.tv_sec + 1;
 }
 
-int kvm_set_wallclock(unsigned long now)
+static int kvm_set_wallclock(unsigned long now)
 {
 	return 0;
 }
diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
index e479072..068759d 100644
--- a/arch/x86/kernel/tsc_32.c
+++ b/arch/x86/kernel/tsc_32.c
@@ -14,7 +14,7 @@
 
 #include "mach_timer.h"
 
-static int tsc_enabled;
+static int tsc_disabled;
 
 /*
  * On some systems the TSC frequency does not
@@ -28,8 +28,8 @@ EXPORT_SYMBOL_GPL(tsc_khz);
 static int __init tsc_setup(char *str)
 {
 	printk(KERN_WARNING "notsc: Kernel compiled with CONFIG_X86_TSC, "
-				"cannot disable TSC completely.\n");
-	mark_tsc_unstable("user disabled TSC");
+	       "cannot disable TSC completely.\n");
+	tsc_disabled = 1;
 	return 1;
 }
 #else
@@ -120,7 +120,7 @@ unsigned long long native_sched_clock(void)
 	 *   very important for it to be as fast as the platform
 	 *   can achive it. )
 	 */
-	if (unlikely(!tsc_enabled && !tsc_unstable))
+	if (unlikely(tsc_disabled))
 		/* No locking but a rare wrong value is not a big deal: */
 		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
 
@@ -322,7 +322,6 @@ void mark_tsc_unstable(char *reason)
 {
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
-		tsc_enabled = 0;
 		printk("Marking TSC unstable due to: %s.\n", reason);
 		/* Can be called before registration */
 		if (clocksource_tsc.mult)
@@ -336,7 +335,7 @@ EXPORT_SYMBOL_GPL(mark_tsc_unstable);
 static int __init dmi_mark_tsc_unstable(const struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE "%s detected: marking TSC unstable.\n",
-		       d->ident);
+	       d->ident);
 	tsc_unstable = 1;
 	return 0;
 }
@@ -403,14 +402,22 @@ void __init tsc_init(void)
 {
 	int cpu;
 
-	if (!cpu_has_tsc)
+	if (!cpu_has_tsc || tsc_disabled) {
+		/* Disable the TSC in case of !cpu_has_tsc */
+		tsc_disabled = 1;
 		return;
+	}
 
 	cpu_khz = calculate_cpu_khz();
 	tsc_khz = cpu_khz;
 
 	if (!cpu_khz) {
 		mark_tsc_unstable("could not calculate TSC khz");
+		/*
+		 * We need to disable the TSC completely in this case
+		 * to prevent sched_clock() from using it.
+		 */
+		tsc_disabled = 1;
 		return;
 	}
 
@@ -441,8 +448,6 @@ void __init tsc_init(void)
 	if (check_tsc_unstable()) {
 		clocksource_tsc.rating = 0;
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
-	} else
-		tsc_enabled = 1;
-
+	}
 	clocksource_register(&clocksource_tsc);
 }
diff --git a/arch/x86/kernel/tsc_64.c b/arch/x86/kernel/tsc_64.c
index fcc16e5..1784b80 100644
--- a/arch/x86/kernel/tsc_64.c
+++ b/arch/x86/kernel/tsc_64.c
@@ -227,14 +227,14 @@ void __init tsc_calibrate(void)
 	/* hpet or pmtimer available ? */
 	if (!hpet && !pm1 && !pm2) {
 		printk(KERN_INFO "TSC calibrated against PIT\n");
-		return;
+		goto out;
 	}
 
 	/* Check, whether the sampling was disturbed by an SMI */
 	if (tsc1 == ULONG_MAX || tsc2 == ULONG_MAX) {
 		printk(KERN_WARNING "TSC calibration disturbed by SMI, "
 		       "using PIT calibration result\n");
-		return;
+		goto out;
 	}
 
 	tsc2 = (tsc2 - tsc1) * 1000000L;
@@ -255,6 +255,7 @@ void __init tsc_calibrate(void)
 
 	tsc_khz = tsc2 / tsc1;
 
+out:
 	for_each_possible_cpu(cpu)
 		set_cyc2ns_scale(tsc_khz, cpu);
 }
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 36c5406..7246b60 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1996,7 +1996,7 @@ static struct shrinker mmu_shrinker = {
 	.seeks = DEFAULT_SEEKS * 10,
 };
 
-void mmu_destroy_caches(void)
+static void mmu_destroy_caches(void)
 {
 	if (pte_chain_cache)
 		kmem_cache_destroy(pte_chain_cache);
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 23476c2..efa2ba7 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -106,9 +106,9 @@ int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 		do_realtime((struct timespec *)tv);
 		tv->tv_usec /= 1000;
 		if (unlikely(tz != NULL)) {
-			/* This relies on gcc inlining the memcpy. We'll notice
-			   if it ever fails to do so. */
-			memcpy(tz, &gtod->sys_tz, sizeof(struct timezone));
+			/* Avoid memcpy. Some old compilers fail to inline it */
+			tz->tz_minuteswest = gtod->sys_tz.tz_minuteswest;
+			tz->tz_dsttime = gtod->sys_tz.tz_dsttime;
 		}
 		return 0;
 	}
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 126766d..3525ef5 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -60,7 +60,7 @@ xmaddr_t arbitrary_virt_to_machine(unsigned long address)
 {
 	unsigned int level;
 	pte_t *pte = lookup_address(address, &level);
-	unsigned offset = address & PAGE_MASK;
+	unsigned offset = address & ~PAGE_MASK;
 
 	BUG_ON(pte == NULL);
 
diff --git a/include/asm-x86/tlbflush.h b/include/asm-x86/tlbflush.h
index 0c0674d..35c76ce 100644
--- a/include/asm-x86/tlbflush.h
+++ b/include/asm-x86/tlbflush.h
@@ -22,12 +22,23 @@ static inline void __native_flush_tlb(void)
 
 static inline void __native_flush_tlb_global(void)
 {
-	unsigned long cr4 = read_cr4();
+	unsigned long flags;
+	unsigned long cr4;
 
+	/*
+	 * Read-modify-write to CR4 - protect it from preemption and
+	 * from interrupts. (Use the raw variant because this code can
+	 * be called from deep inside debugging code.)
+	 */
+	raw_local_irq_save(flags);
+
+	cr4 = read_cr4();
 	/* clear PGE */
 	write_cr4(cr4 & ~X86_CR4_PGE);
 	/* write old PGE again and flush TLBs */
 	write_cr4(cr4);
+
+	raw_local_irq_restore(flags);
 }
 
 static inline void __native_flush_tlb_single(unsigned long addr)
