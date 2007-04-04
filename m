Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbXDEASN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbXDEASN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932152AbXDEASB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:18:01 -0400
Received: from 230.sub-75-208-113.myvzw.com ([75.208.113.230]:36888 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932140AbXDEAQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:16:53 -0400
Message-Id: <20070404191206.581107728@goop.org>
References: <20070404191151.009821039@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 04 Apr 2007 12:12:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Zachary Amsden <zach@vmware.com>,
       Dan Hecht <dhecht@vmware.com>, john stultz <johnstul@us.ibm.com>
Subject: [patch 19/20] Add a sched_clock paravirt_op
Content-Disposition: inline; filename=paravirt-sched-clock.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The tsc-based get_scheduled_cycles interface is not a good match for
Xen's runstate accounting, which reports everything in nanoseconds.

This patch replaces this interface with a sched_clock interface, which
matches both Xen and VMI's requirements.

In order to do this, we:
   1. replace get_scheduled_cycles with sched_clock
   2. hoist cycles_2_ns into a common header
   3. update vmi accordingly

One thing to note: because sched_clock is implemented as a weak
function in kernel/sched.c, we must define a real function in order to
override this weak binding.  This means the usual paravirt_ops
technique of using an inline function won't work in this case.


Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Dan Hecht <dhecht@vmware.com>
Cc: john stultz <johnstul@us.ibm.com>

---
 arch/i386/kernel/paravirt.c    |    2 -
 arch/i386/kernel/sched-clock.c |   39 ++++++++++++++--------------------
 arch/i386/kernel/vmi.c         |    2 -
 arch/i386/kernel/vmitime.c     |    6 ++---
 include/asm-i386/paravirt.h    |    7 ++++--
 include/asm-i386/timer.h       |   45 +++++++++++++++++++++++++++++++++++++++-
 include/asm-i386/vmi_time.h    |    2 -
 7 files changed, 71 insertions(+), 32 deletions(-)

===================================================================
--- a/arch/i386/kernel/paravirt.c
+++ b/arch/i386/kernel/paravirt.c
@@ -269,7 +269,7 @@ struct paravirt_ops paravirt_ops = {
 	.write_msr = native_write_msr_safe,
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
-	.get_scheduled_cycles = native_read_tsc,
+	.sched_clock = native_sched_clock,
 	.get_cpu_khz = native_calculate_cpu_khz,
 	.load_tr_desc = native_load_tr_desc,
 	.set_ldt = native_set_ldt,
===================================================================
--- a/arch/i386/kernel/sched-clock.c
+++ b/arch/i386/kernel/sched-clock.c
@@ -37,26 +37,7 @@
 
 #define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
 
-struct sc_data {
-	unsigned int cyc2ns_scale;
-	unsigned char unstable;
-	unsigned long long last_tsc;
-	unsigned long long ns_base;
-};
-
-static DEFINE_PER_CPU(struct sc_data, sc_data);
-
-static inline unsigned long long cycles_2_ns(unsigned long long cyc)
-{
-	const struct sc_data *sc = &__get_cpu_var(sc_data);
-	unsigned long long ns;
-
-	cyc -= sc->last_tsc;
-	ns = (cyc * sc->cyc2ns_scale) >> CYC2NS_SCALE_FACTOR;
-	ns += sc->ns_base;
-
-	return ns;
-}
+DEFINE_PER_CPU(struct sc_data, sc_data);
 
 /*
  * Scheduler clock - returns current time in nanosec units.
@@ -66,7 +47,7 @@ static inline unsigned long long cycles_
  * [1] no attempt to stop CPU instruction reordering, which can hit
  * in a 100 instruction window or so.
  */
-unsigned long long sched_clock(void)
+unsigned long long native_sched_clock(void)
 {
 	unsigned long long r;
 	const struct sc_data *sc = &get_cpu_var(sc_data);
@@ -75,7 +56,7 @@ unsigned long long sched_clock(void)
 		/* TBD find a cheaper fallback timer than this */
 		r = ktime_to_ns(ktime_get());
 	} else {
-		get_scheduled_cycles(r);
+		rdtscll(r);
 		r = cycles_2_ns(r);
 	}
 
@@ -83,6 +64,18 @@ unsigned long long sched_clock(void)
 
 	return r;
 }
+
+/* We need to define a real function for sched_clock, to override the
+   weak default version */
+#ifdef CONFIG_PARAVIRT
+unsigned long long sched_clock(void)
+{
+	return paravirt_sched_clock();
+}
+#else
+unsigned long long sched_clock(void)
+	__attribute__((alias("native_sched_clock")));
+#endif
 
 /* Resync with new CPU frequency */
 static void resync_sc_freq(struct sc_data *sc, unsigned int newfreq)
@@ -95,7 +88,7 @@ static void resync_sc_freq(struct sc_dat
 	   because sched_clock callers should be able to tolerate small
 	   errors. */
 	sc->ns_base = ktime_to_ns(ktime_get());
-	get_scheduled_cycles(sc->last_tsc);
+	rdtscll(sc->last_tsc);
 	sc->cyc2ns_scale = (1000000 << CYC2NS_SCALE_FACTOR) / newfreq;
 	sc->unstable = 0;
 }
===================================================================
--- a/arch/i386/kernel/vmi.c
+++ b/arch/i386/kernel/vmi.c
@@ -866,7 +866,7 @@ static inline int __init activate_vmi(vo
 		paravirt_ops.setup_boot_clock = vmi_timer_setup_boot_alarm;
 		paravirt_ops.setup_secondary_clock = vmi_timer_setup_secondary_alarm;
 #endif
-		paravirt_ops.get_scheduled_cycles = vmi_get_sched_cycles;
+		paravirt_ops.sched_clock = vmi_sched_clock;
  		paravirt_ops.get_cpu_khz = vmi_cpu_khz;
 
 		/* We have true wallclock functions; disable CMOS clock sync */
===================================================================
--- a/arch/i386/kernel/vmitime.c
+++ b/arch/i386/kernel/vmitime.c
@@ -163,9 +163,9 @@ int vmi_set_wallclock(unsigned long now)
 	return -1;
 }
 
-unsigned long long vmi_get_sched_cycles(void)
-{
-	return read_available_cycles();
+unsigned long long vmi_sched_clock(void)
+{
+	return cycles_2_ns(read_available_cycles());
 }
 
 unsigned long vmi_cpu_khz(void)
===================================================================
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -88,7 +88,7 @@ struct paravirt_ops
 
 	u64 (*read_tsc)(void);
 	u64 (*read_pmc)(void);
- 	u64 (*get_scheduled_cycles)(void);
+ 	unsigned long long (*sched_clock)(void);
 	unsigned long (*get_cpu_khz)(void);
 
 	void (*load_tr_desc)(void);
@@ -529,7 +529,10 @@ static inline void halt(void)
 
 #define rdtscll(val) (val = PVOP_CALL0(u64, read_tsc))
 
-#define get_scheduled_cycles(val) (val = paravirt_ops.get_scheduled_cycles())
+static inline unsigned long long paravirt_sched_clock(void)
+{
+	return PVOP_CALL0(unsigned long long, sched_clock);
+}
 #define calculate_cpu_khz() (paravirt_ops.get_cpu_khz())
 
 #define write_tsc(val1,val2) wrmsr(0x10, val1, val2)
===================================================================
--- a/include/asm-i386/timer.h
+++ b/include/asm-i386/timer.h
@@ -15,8 +15,51 @@ extern int recalibrate_cpu_khz(void);
 extern int recalibrate_cpu_khz(void);
 
 #ifndef CONFIG_PARAVIRT
-#define get_scheduled_cycles(val) rdtscll(val)
 #define calculate_cpu_khz() native_calculate_cpu_khz()
 #endif
 
+/* Accellerators for sched_clock()
+ * convert from cycles(64bits) => nanoseconds (64bits)
+ *  basic equation:
+ *		ns = cycles / (freq / ns_per_sec)
+ *		ns = cycles * (ns_per_sec / freq)
+ *		ns = cycles * (10^9 / (cpu_khz * 10^3))
+ *		ns = cycles * (10^6 / cpu_khz)
+ *
+ *	Then we use scaling math (suggested by george@mvista.com) to get:
+ *		ns = cycles * (10^6 * SC / cpu_khz) / SC
+ *		ns = cycles * cyc2ns_scale / SC
+ *
+ *	And since SC is a constant power of two, we can convert the div
+ *  into a shift.
+ *
+ *  We can use khz divisor instead of mhz to keep a better percision, since
+ *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
+ *  (mathieu.desnoyers@polymtl.ca)
+ *
+ *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
+ */
+struct sc_data {
+	unsigned int cyc2ns_scale;
+	unsigned char unstable;
+	unsigned long long last_tsc;
+	unsigned long long ns_base;
+};
+
+DECLARE_PER_CPU(struct sc_data, sc_data);
+
+#define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
+
+static inline unsigned long long cycles_2_ns(unsigned long long cyc)
+{
+	const struct sc_data *sc = &__get_cpu_var(sc_data);
+	unsigned long long ns;
+
+	cyc -= sc->last_tsc;
+	ns = (cyc * sc->cyc2ns_scale) >> CYC2NS_SCALE_FACTOR;
+	ns += sc->ns_base;
+
+	return ns;
+}
+
 #endif
===================================================================
--- a/include/asm-i386/vmi_time.h
+++ b/include/asm-i386/vmi_time.h
@@ -49,7 +49,7 @@ extern void __init vmi_time_init(void);
 extern void __init vmi_time_init(void);
 extern unsigned long vmi_get_wallclock(void);
 extern int vmi_set_wallclock(unsigned long now);
-extern unsigned long long vmi_get_sched_cycles(void);
+extern unsigned long long vmi_sched_clock(void);
 extern unsigned long vmi_cpu_khz(void);
 
 #ifdef CONFIG_X86_LOCAL_APIC

-- 

