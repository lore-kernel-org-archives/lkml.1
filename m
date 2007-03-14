Return-Path: <linux-kernel-owner+w=401wt.eu-S932773AbXCNTH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773AbXCNTH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 15:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932782AbXCNTH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 15:07:28 -0400
Received: from gw.goop.org ([64.81.55.164]:55680 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932773AbXCNTH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 15:07:27 -0400
Message-ID: <45F847E2.7040102@goop.org>
Date: Wed, 14 Mar 2007 12:07:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dan Hecht <dhecht@vmware.com>, Zachary Amsden <zach@vmware.com>
CC: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>
Subject: [PATCH/RFC] replace get_scheduled_cycles with sched_clock paravirt_op
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Add a sched_clock paravirt_op

The tsc-based get_scheduled_cycles interface is not a good match for
Xen's runstate accounting, which reports everything in nanoseconds.

This patch replaces this interface with a sched_clock interface, which
matches both Xen and VMI's requirements.

In order to do this, we:
   1. replace get_scheduled_cycles with sched_clock
   2. hoist cycles_2_ns into a common header
   3. update vmi accordingly

One thing to note: because sched_clock is implemented as a weak function in
kernel/sched.c, we must define a real function in order to override this weak
binding.  This means the usual paravirt_ops technique of using an inline
function won't work in this case.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Dan Hecht <dhecht@vmware.com>
Cc: john stultz <johnstul@us.ibm.com>

---
 arch/i386/kernel/paravirt.c |    2 +-
 arch/i386/kernel/tsc.c      |   23 +++++++++++++++--------
 arch/i386/kernel/vmi.c      |    2 +-
 arch/i386/kernel/vmitime.c  |    6 +++---
 include/asm-i386/paravirt.h |    7 +++++--
 include/asm-i386/timer.h    |   32 +++++++++++++++++++++++++++++++-
 include/asm-i386/vmi_time.h |    2 +-
 7 files changed, 57 insertions(+), 17 deletions(-)

===================================================================
--- a/arch/i386/kernel/paravirt.c
+++ b/arch/i386/kernel/paravirt.c
@@ -552,7 +552,7 @@ struct paravirt_ops paravirt_ops = {
 	.write_msr = native_write_msr,
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
-	.get_scheduled_cycles = native_read_tsc,
+	.sched_clock = native_sched_clock,
 	.get_cpu_khz = native_calculate_cpu_khz,
 	.load_tr_desc = native_load_tr_desc,
 	.set_ldt = native_set_ldt,
===================================================================
--- a/arch/i386/kernel/tsc.c
+++ b/arch/i386/kernel/tsc.c
@@ -81,7 +81,7 @@ static inline int check_tsc_unstable(voi
  *
  *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
  */
-static unsigned long cyc2ns_scale __read_mostly;
+unsigned long cyc2ns_scale __read_mostly;
 
 #define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
 
@@ -90,15 +90,10 @@ static inline void set_cyc2ns_scale(unsi
 	cyc2ns_scale = (1000000 << CYC2NS_SCALE_FACTOR)/cpu_khz;
 }
 
-static inline unsigned long long cycles_2_ns(unsigned long long cyc)
-{
-	return (cyc * cyc2ns_scale) >> CYC2NS_SCALE_FACTOR;
-}
-
 /*
  * Scheduler clock - returns current time in nanosec units.
  */
-unsigned long long sched_clock(void)
+unsigned long long native_sched_clock(void)
 {
 	unsigned long long this_offset;
 
@@ -110,11 +105,23 @@ unsigned long long sched_clock(void)
 		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
 
 	/* read the Time Stamp Counter: */
-	get_scheduled_cycles(this_offset);
+	rdtscll(this_offset);
 
 	/* return the value in ns */
 	return cycles_2_ns(this_offset);
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
 
 unsigned long native_calculate_cpu_khz(void)
 {
===================================================================
--- a/arch/i386/kernel/vmi.c
+++ b/arch/i386/kernel/vmi.c
@@ -871,7 +871,7 @@ static inline int __init activate_vmi(vo
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
@@ -92,7 +92,7 @@ struct paravirt_ops
 
 	u64 (*read_tsc)(void);
 	u64 (*read_pmc)(void);
- 	u64 (*get_scheduled_cycles)(void);
+ 	unsigned long long (*sched_clock)(void);
 	unsigned long (*get_cpu_khz)(void);
 
 	void (*load_tr_desc)(void);
@@ -549,7 +549,10 @@ static inline void halt(void)
 
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
@@ -17,8 +17,38 @@ extern int recalibrate_cpu_khz(void);
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
+extern unsigned long cyc2ns_scale __read_mostly;
+
+#define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
+
+static inline unsigned long long cycles_2_ns(unsigned long long cyc)
+{
+	return (cyc * cyc2ns_scale) >> CYC2NS_SCALE_FACTOR;
+}
+
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

