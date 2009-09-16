Return-Path: <linux-kernel-owner+w=401wt.eu-S1758881AbZIPMhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881AbZIPMhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbZIPMhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:37:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:54212 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911AbZIPMhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:37:00 -0400
Date: Wed, 16 Sep 2009 12:36:42 GMT
From: tip-bot for Feng Tang <feng.tang@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, feng.tang@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, feng.tang@intel.com
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: Move get/set_wallclock to x86_platform_ops
Message-ID: <tip-7bd867dfb4e0357e06a3211ab2bd0e714110def3@git.kernel.org>
Git-Commit-ID: 7bd867dfb4e0357e06a3211ab2bd0e714110def3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 12:36:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7bd867dfb4e0357e06a3211ab2bd0e714110def3
Gitweb:     http://git.kernel.org/tip/7bd867dfb4e0357e06a3211ab2bd0e714110def3
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Thu, 10 Sep 2009 10:48:56 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 16 Sep 2009 14:34:50 +0200

x86: Move get/set_wallclock to x86_platform_ops

get/set_wallclock() have already a set of platform dependent
implementations (default, EFI, paravirt). MRST will add another
variant.

Moving them to platform ops simplifies the existing code and minimizes
the effort to integrate new variants.

Signed-off-by: Feng Tang <feng.tang@intel.com>
LKML-Reference: <new-submission>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 arch/x86/include/asm/paravirt.h       |   10 ------
 arch/x86/include/asm/paravirt_types.h |    4 --
 arch/x86/include/asm/time.h           |   50 ---------------------------------
 arch/x86/include/asm/x86_init.h       |    4 ++
 arch/x86/kernel/efi.c                 |    4 ++
 arch/x86/kernel/kvmclock.c            |    4 +-
 arch/x86/kernel/paravirt.c            |    2 -
 arch/x86/kernel/rtc.c                 |   12 ++-----
 arch/x86/kernel/vmi_32.c              |    4 +-
 arch/x86/kernel/x86_init.c            |    2 +
 arch/x86/lguest/boot.c                |    4 +--
 arch/x86/xen/enlighten.c              |    4 +-
 12 files changed, 21 insertions(+), 83 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 1e458a5..a69ae87 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -24,16 +24,6 @@ static inline void load_sp0(struct tss_struct *tss,
 	PVOP_VCALL2(pv_cpu_ops.load_sp0, tss, thread);
 }
 
-static inline unsigned long get_wallclock(void)
-{
-	return PVOP_CALL0(unsigned long, pv_time_ops.get_wallclock);
-}
-
-static inline int set_wallclock(unsigned long nowtime)
-{
-	return PVOP_CALL1(int, pv_time_ops.set_wallclock, nowtime);
-}
-
 /* The paravirtualized CPUID instruction. */
 static inline void __cpuid(unsigned int *eax, unsigned int *ebx,
 			   unsigned int *ecx, unsigned int *edx)
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 0d812e5..c25d5e3 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -88,10 +88,6 @@ struct pv_lazy_ops {
 };
 
 struct pv_time_ops {
-	/* Set and set time of day */
-	unsigned long (*get_wallclock)(void);
-	int (*set_wallclock)(unsigned long);
-
 	unsigned long long (*sched_clock)(void);
 	unsigned long (*get_tsc_khz)(void);
 };
diff --git a/arch/x86/include/asm/time.h b/arch/x86/include/asm/time.h
index 9c5608b..7bdec4e 100644
--- a/arch/x86/include/asm/time.h
+++ b/arch/x86/include/asm/time.h
@@ -4,57 +4,7 @@
 extern void hpet_time_init(void);
 
 #include <asm/mc146818rtc.h>
-#ifdef CONFIG_X86_32
-#include <linux/efi.h>
-
-static inline unsigned long native_get_wallclock(void)
-{
-	unsigned long retval;
-
-	if (efi_enabled)
-		retval = efi_get_time();
-	else
-		retval = mach_get_cmos_time();
-
-	return retval;
-}
-
-static inline int native_set_wallclock(unsigned long nowtime)
-{
-	int retval;
-
-	if (efi_enabled)
-		retval = efi_set_rtc_mmss(nowtime);
-	else
-		retval = mach_set_rtc_mmss(nowtime);
-
-	return retval;
-}
-
-#else
-extern void native_time_init_hook(void);
-
-static inline unsigned long native_get_wallclock(void)
-{
-	return mach_get_cmos_time();
-}
-
-static inline int native_set_wallclock(unsigned long nowtime)
-{
-	return mach_set_rtc_mmss(nowtime);
-}
-
-#endif
 
 extern void time_init(void);
 
-#ifdef CONFIG_PARAVIRT
-#include <asm/paravirt.h>
-#else /* !CONFIG_PARAVIRT */
-
-#define get_wallclock() native_get_wallclock()
-#define set_wallclock(x) native_set_wallclock(x)
-
-#endif /* CONFIG_PARAVIRT */
-
 #endif /* _ASM_X86_TIME_H */
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index b6c8942..2c756fd 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -114,9 +114,13 @@ struct x86_cpuinit_ops {
 /**
  * struct x86_platform_ops - platform specific runtime functions
  * @calibrate_tsc:		calibrate TSC
+ * @get_wallclock:		get time from HW clock like RTC etc.
+ * @set_wallclock:		set time back to HW clock
  */
 struct x86_platform_ops {
 	unsigned long (*calibrate_tsc)(void);
+	unsigned long (*get_wallclock)(void);
+	int (*set_wallclock)(unsigned long nowtime);
 };
 
 extern struct x86_init_ops x86_init;
diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index fe26ba3..ad5bd98 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -42,6 +42,7 @@
 #include <asm/time.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
+#include <asm/x86_init.h>
 
 #define EFI_DEBUG	1
 #define PFX 		"EFI: "
@@ -453,6 +454,9 @@ void __init efi_init(void)
 	if (add_efi_memmap)
 		do_add_efi_memmap();
 
+	x86_platform.get_wallclock = efi_get_time;
+	x86_platform.set_wallclock = efi_set_rtc_mmss;
+
 	/* Setup for EFI runtime service */
 	reboot_type = BOOT_EFI;
 
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 75a21b6..59ab94d 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -184,10 +184,10 @@ void __init kvmclock_init(void)
 	if (kvmclock && kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE)) {
 		if (kvm_register_clock("boot clock"))
 			return;
-		pv_time_ops.get_wallclock = kvm_get_wallclock;
-		pv_time_ops.set_wallclock = kvm_set_wallclock;
 		pv_time_ops.sched_clock = kvm_clock_read;
 		x86_platform.calibrate_tsc = kvm_get_tsc_khz;
+		x86_platform.get_wallclock = kvm_get_wallclock;
+		x86_platform.set_wallclock = kvm_set_wallclock;
 #ifdef CONFIG_X86_LOCAL_APIC
 		x86_cpuinit.setup_percpu_clockev =
 			kvm_setup_secondary_clock;
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 7cbf898..c0fb85a 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -306,8 +306,6 @@ struct pv_init_ops pv_init_ops = {
 };
 
 struct pv_time_ops pv_time_ops = {
-	.get_wallclock = native_get_wallclock,
-	.set_wallclock = native_set_wallclock,
 	.sched_clock = native_sched_clock,
 };
 
diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 5d465b2..b8652f2 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -8,6 +8,7 @@
 #include <linux/pnp.h>
 
 #include <asm/vsyscall.h>
+#include <asm/x86_init.h>
 #include <asm/time.h>
 
 #ifdef CONFIG_X86_32
@@ -165,13 +166,13 @@ void rtc_cmos_write(unsigned char val, unsigned char addr)
 }
 EXPORT_SYMBOL(rtc_cmos_write);
 
-static int set_rtc_mmss(unsigned long nowtime)
+int update_persistent_clock(struct timespec now)
 {
 	unsigned long flags;
 	int retval;
 
 	spin_lock_irqsave(&rtc_lock, flags);
-	retval = set_wallclock(nowtime);
+	retval = x86_platform.set_wallclock(now.tv_sec);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
 	return retval;
@@ -183,17 +184,12 @@ unsigned long read_persistent_clock(void)
 	unsigned long retval, flags;
 
 	spin_lock_irqsave(&rtc_lock, flags);
-	retval = get_wallclock();
+	retval = x86_platform.get_wallclock();
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
 	return retval;
 }
 
-int update_persistent_clock(struct timespec now)
-{
-	return set_rtc_mmss(now.tv_sec);
-}
-
 unsigned long long native_read_tsc(void)
 {
 	return __native_read_tsc();
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 052ae81..31e6f6c 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -818,14 +818,14 @@ static inline int __init activate_vmi(void)
 		vmi_timer_ops.cancel_alarm =
 			 vmi_get_function(VMI_CALL_CancelAlarm);
 		x86_init.timers.timer_init = vmi_time_init;
-		pv_time_ops.get_wallclock = vmi_get_wallclock;
-		pv_time_ops.set_wallclock = vmi_set_wallclock;
 #ifdef CONFIG_X86_LOCAL_APIC
 		x86_init.timers.setup_percpu_clockev = vmi_time_bsp_init;
 		x86_cpuinit.setup_percpu_clockev = vmi_time_ap_init;
 #endif
 		pv_time_ops.sched_clock = vmi_sched_clock;
 		x86_platform.calibrate_tsc = vmi_tsc_khz;
+		x86_platform.get_wallclock = vmi_get_wallclock;
+		x86_platform.set_wallclock = vmi_set_wallclock;
 
 		/* We have true wallclock functions; disable CMOS clock sync */
 		no_sync_cmos_clock = 1;
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 68824c7..4449a4a 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -70,4 +70,6 @@ struct x86_cpuinit_ops x86_cpuinit __cpuinitdata = {
 
 struct x86_platform_ops x86_platform = {
 	.calibrate_tsc			= native_calibrate_tsc,
+	.get_wallclock			= mach_get_cmos_time,
+	.set_wallclock			= mach_set_rtc_mmss,
 };
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index fabe745..4cb7d5d 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -1318,13 +1318,11 @@ __init void lguest_init(void)
 	set_lguest_basic_apic_ops();
 #endif
 
-	/* Time operations */
-	pv_time_ops.get_wallclock = lguest_get_wallclock;
-
 	x86_init.resources.memory_setup = lguest_memory_setup;
 	x86_init.irqs.intr_init = lguest_init_IRQ;
 	x86_init.timers.timer_init = lguest_time_init;
 	x86_platform.calibrate_tsc = lguest_tsc_khz;
+	x86_platform.get_wallclock =  lguest_get_wallclock;
 
 	/*
 	 * Now is a good time to look at the implementations of these functions
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index ee8cac7..b5bf8b9 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -842,8 +842,6 @@ static const struct pv_init_ops xen_init_ops __initdata = {
 };
 
 static const struct pv_time_ops xen_time_ops __initdata = {
-	.set_wallclock = xen_set_wallclock,
-	.get_wallclock = xen_get_wallclock,
 	.sched_clock = xen_sched_clock,
 };
 
@@ -980,6 +978,8 @@ asmlinkage void __init xen_start_kernel(void)
 	x86_cpuinit.setup_percpu_clockev = x86_init_noop;
 
 	x86_platform.calibrate_tsc = xen_tsc_khz;
+	x86_platform.get_wallclock = xen_get_wallclock;
+	x86_platform.set_wallclock = xen_set_wallclock;
 
 #ifdef CONFIG_X86_64
 	/*
