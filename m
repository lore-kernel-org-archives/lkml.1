Return-Path: <linux-kernel-owner+w=401wt.eu-S965521AbXAWWHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965521AbXAWWHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965514AbXAWWBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:01:17 -0500
Received: from www.osadl.org ([213.239.205.134]:35856 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933156AbXAWWBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:01:00 -0500
Message-Id: <20070123211205.698829000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 19/46] Mark TSC on GeodeLX reliable
Content-Disposition: inline;
	filename=clocksource-i386-tsc-mark-reliable-on-geode.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <marcelo@kvack.org>

>From what I can tell the Geode can safely use the TSC for highres, since:

1) Does not support frequency scaling,
2) The TSC _does_ count when the CPU is halted. Furthermore, the Geode
supports a mode called "suspension on halt", where Suspend mode (which
interacts with the power management states) is entered. TSC counting
during suspend mode is controlled by bit 8 of the Bus Controller
Configuration Register #0 (thanks Tom!).
3) no SMP :)

Check if "RTSC counts during suspension" and remove the requirement for
verification, so the clocksource code can safely select it as an timesource
for the highres timers subsystem.

Signed-off-by: Marcelo Tosatti <marcelo@kvack.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---

 arch/i386/kernel/tsc.c |   20 ++++++++++++++++++++
 include/asm-i386/msr.h |    3 +++
 2 files changed, 23 insertions(+)

Index: linux-2.6.20-rc4-mm1-bo/arch/i386/kernel/tsc.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/arch/i386/kernel/tsc.c
+++ linux-2.6.20-rc4-mm1-bo/arch/i386/kernel/tsc.c
@@ -364,6 +364,25 @@ __cpuinit int unsynchronized_tsc(void)
 	return tsc_unstable;
 }
 
+/*
+ * Geode_LX - the OLPC CPU has a possibly a very reliable TSC
+ */
+#ifdef CONFIG_MGEODE_LX
+/* RTSC counts during suspend */
+#define RTSC_SUSP 0x100
+
+static void __init check_geode_tsc_reliable(void)
+{
+	unsigned long val;
+
+	rdmsrl(MSR_GEODE_BUSCONT_CONF0, val);
+	if ((val & RTSC_SUSP))
+		clocksource_tsc.flags &= ~CLOCK_SOURCE_MUST_VERIFY;
+}
+#else
+static inline void check_geode_tsc_reliable(void) { }
+#endif
+
 static int __init init_tsc_clocksource(void)
 {
 
@@ -372,6 +391,7 @@ static int __init init_tsc_clocksource(v
 		dmi_check_system(bad_tsc_dmi_table);
 
 		unsynchronized_tsc();
+		check_geode_tsc_reliable();
 		current_tsc_khz = tsc_khz;
 		clocksource_tsc.mult = clocksource_khz2mult(current_tsc_khz,
 							clocksource_tsc.shift);
Index: linux-2.6.20-rc4-mm1-bo/include/asm-i386/msr.h
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/include/asm-i386/msr.h
+++ linux-2.6.20-rc4-mm1-bo/include/asm-i386/msr.h
@@ -307,4 +307,7 @@ static inline void wrmsrl (unsigned long
 #define MSR_CORE_PERF_GLOBAL_CTRL	0x38f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x390
 
+/* Geode defined MSRs */
+#define MSR_GEODE_BUSCONT_CONF0         0x1900
+
 #endif /* __ASM_MSR_H */

--

