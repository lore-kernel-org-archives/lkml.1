Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbXLGIJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbXLGIJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 03:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbXLGIJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 03:09:38 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:39621 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbXLGIJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 03:09:37 -0500
Date: Fri, 7 Dec 2007 09:02:52 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Guillaume Chazarain" <guichaz@yahoo.fr>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Stefano Brivio" <stefano.brivio@polimi.it>,
       "Ingo Molnar" <mingo@elte.hu>, "Robert Love" <rml@tech9.net>,
       linux-kernel@vger.kernel.org, "Dave Jones" <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Michael Buesch" <mb@bu3sch.de>,
       "Andrew Morton"@pimp.vs19.net
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Message-ID: <20071207090252.1caf1509@inria.fr>
In-Reply-To: <3d8471ca0712062318j483f8be6h256778752a13639a@mail.gmail.com>
References: <20071207021952.6f0ac922@morte>
 <alpine.LFD.0.99999.0712070646210.3221@localhost.localdomain>
 <3d8471ca0712062318j483f8be6h256778752a13639a@mail.gmail.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Guillaume Chazarain" <guichaz@yahoo.fr> wrote:

> On Dec 7, 2007 6:51 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Hmrpf. sched_clock() is used for the time stamp of the printks. We
> > need to find some better solution other than killing off the tsc
> > access completely.
> 
> Something like http://lkml.org/lkml/2007/3/16/291 that would need some refresh?

And here is a refreshed one just for testing with 2.6-git. The 64 bit
part is a shamelessly untested copy/paste as I cannot test it.

diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
index 9ebc0da..d561b2f 100644
--- a/arch/x86/kernel/tsc_32.c
+++ b/arch/x86/kernel/tsc_32.c
@@ -5,6 +5,7 @@
 #include <linux/jiffies.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
+#include <linux/percpu.h>
 
 #include <asm/delay.h>
 #include <asm/tsc.h>
@@ -78,15 +79,32 @@ EXPORT_SYMBOL_GPL(check_tsc_unstable);
  *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
  *  (mathieu.desnoyers@polymtl.ca)
  *
+ *  ns += offset to avoid sched_clock jumps with cpufreq
+ *
  *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
  */
-unsigned long cyc2ns_scale __read_mostly;
 
 #define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
 
-static inline void set_cyc2ns_scale(unsigned long cpu_khz)
+DEFINE_PER_CPU(struct cyc2ns_params, cyc2ns) __read_mostly;
+
+static void set_cyc2ns_scale(unsigned long cpu_khz)
 {
-	cyc2ns_scale = (1000000 << CYC2NS_SCALE_FACTOR)/cpu_khz;
+	struct cyc2ns_params *params;
+	unsigned long flags;
+	unsigned long long tsc_now, ns_now;
+
+	rdtscll(tsc_now);
+	params = &get_cpu_var(cyc2ns);
+
+	local_irq_save(flags);
+	ns_now = __cycles_2_ns(params, tsc_now);
+
+	params->scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
+	params->offset += ns_now - __cycles_2_ns(params, tsc_now);
+	local_irq_restore(flags);
+
+	put_cpu_var(cyc2ns);
 }
 
 /*
diff --git a/arch/x86/kernel/tsc_64.c b/arch/x86/kernel/tsc_64.c
index 9c70af4..93e7a06 100644
--- a/arch/x86/kernel/tsc_64.c
+++ b/arch/x86/kernel/tsc_64.c
@@ -10,6 +10,7 @@
 
 #include <asm/hpet.h>
 #include <asm/timex.h>
+#include <asm/timer.h>
 
 static int notsc __initdata = 0;
 
@@ -18,16 +19,25 @@ EXPORT_SYMBOL(cpu_khz);
 unsigned int tsc_khz;
 EXPORT_SYMBOL(tsc_khz);
 
-static unsigned int cyc2ns_scale __read_mostly;
+DEFINE_PER_CPU(struct cyc2ns_params, cyc2ns) __read_mostly;
 
-static inline void set_cyc2ns_scale(unsigned long khz)
+static void set_cyc2ns_scale(unsigned long cpu_khz)
 {
-	cyc2ns_scale = (NSEC_PER_MSEC << NS_SCALE) / khz;
-}
+	struct cyc2ns_params *params;
+	unsigned long flags;
+	unsigned long long tsc_now, ns_now;
 
-static unsigned long long cycles_2_ns(unsigned long long cyc)
-{
-	return (cyc * cyc2ns_scale) >> NS_SCALE;
+	rdtscll(tsc_now);
+	params = &get_cpu_var(cyc2ns);
+
+	local_irq_save(flags);
+	ns_now = __cycles_2_ns(params, tsc_now);
+
+	params->scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
+	params->offset += ns_now - __cycles_2_ns(params, tsc_now);
+	local_irq_restore(flags);
+
+	put_cpu_var(cyc2ns);
 }
 
 unsigned long long sched_clock(void)
diff --git a/include/asm-x86/timer.h b/include/asm-x86/timer.h
index 0db7e99..ff4f2a3 100644
--- a/include/asm-x86/timer.h
+++ b/include/asm-x86/timer.h
@@ -2,6 +2,7 @@
 #define _ASMi386_TIMER_H
 #include <linux/init.h>
 #include <linux/pm.h>
+#include <linux/percpu.h>
 
 #define TICK_SIZE (tick_nsec / 1000)
 
@@ -16,7 +17,7 @@ extern int recalibrate_cpu_khz(void);
 #define calculate_cpu_khz() native_calculate_cpu_khz()
 #endif
 
-/* Accellerators for sched_clock()
+/* Accelerators for sched_clock()
  * convert from cycles(64bits) => nanoseconds (64bits)
  *  basic equation:
  *		ns = cycles / (freq / ns_per_sec)
@@ -31,20 +32,44 @@ extern int recalibrate_cpu_khz(void);
  *	And since SC is a constant power of two, we can convert the div
  *  into a shift.
  *
- *  We can use khz divisor instead of mhz to keep a better percision, since
+ *  We can use khz divisor instead of mhz to keep a better precision, since
  *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
  *  (mathieu.desnoyers@polymtl.ca)
  *
+ *  ns += offset to avoid sched_clock jumps with cpufreq
+ *
  *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
  */
-extern unsigned long cyc2ns_scale __read_mostly;
+
+struct cyc2ns_params {
+	unsigned long scale;
+	unsigned long long offset;
+};
+
+DECLARE_PER_CPU(struct cyc2ns_params, cyc2ns) __read_mostly;
 
 #define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
 
-static inline unsigned long long cycles_2_ns(unsigned long long cyc)
+static inline unsigned long long __cycles_2_ns(struct cyc2ns_params *params,
+					       unsigned long long cyc)
 {
-	return (cyc * cyc2ns_scale) >> CYC2NS_SCALE_FACTOR;
+	return ((cyc * params->scale) >> CYC2NS_SCALE_FACTOR) + params->offset;
 }
 
+static inline unsigned long long cycles_2_ns(unsigned long long cyc)
+{
+	struct cyc2ns_params *params;
+	unsigned long flags;
+	unsigned long long ns;
+
+	params = &get_cpu_var(cyc2ns);
+
+	local_irq_save(flags);
+	ns = __cycles_2_ns(params, cyc);
+	local_irq_restore(flags);
+
+	put_cpu_var(cyc2ns);
+	return ns;
+}
 
 #endif


-- 
Guillaume
