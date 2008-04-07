Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbYDGTip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbYDGTip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 15:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbYDGTii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 15:38:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39010 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbYDGTih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 15:38:37 -0400
Date: Mon, 7 Apr 2008 21:38:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20080407193824.GA27323@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest x86 fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git for-linus

Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      revert "x86: tsc prevent time going backwards"

Karsten Wiese (1):
      x86: fix call to set_cyc2ns_scale() from time_cpufreq_notifier()

Suresh Siddha (1):
      x86: fix 64-bit asm NOPS for CONFIG_GENERIC_CPU

 arch/x86/kernel/tsc_32.c |   19 ++-----------------
 arch/x86/kernel/tsc_64.c |   27 ++++-----------------------
 include/asm-x86/nops.h   |   20 ++++++++++----------
 3 files changed, 16 insertions(+), 50 deletions(-)

diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
index d7498b3..c2241e0 100644
--- a/arch/x86/kernel/tsc_32.c
+++ b/arch/x86/kernel/tsc_32.c
@@ -256,9 +256,7 @@ time_cpufreq_notifier(struct notifier_block *nb, unsigned long val, void *data)
 						ref_freq, freq->new);
 			if (!(freq->flags & CPUFREQ_CONST_LOOPS)) {
 				tsc_khz = cpu_khz;
-				preempt_disable();
-				set_cyc2ns_scale(cpu_khz, smp_processor_id());
-				preempt_enable();
+				set_cyc2ns_scale(cpu_khz, freq->cpu);
 				/*
 				 * TSC based sched_clock turns
 				 * to junk w/ cpufreq
@@ -287,27 +285,14 @@ core_initcall(cpufreq_tsc);
 /* clock source code */
 
 static unsigned long current_tsc_khz = 0;
-static struct clocksource clocksource_tsc;
 
-/*
- * We compare the TSC to the cycle_last value in the clocksource
- * structure to avoid a nasty time-warp issue. This can be observed in
- * a very small window right after one CPU updated cycle_last under
- * xtime lock and the other CPU reads a TSC value which is smaller
- * than the cycle_last reference value due to a TSC which is slighty
- * behind. This delta is nowhere else observable, but in that case it
- * results in a forward time jump in the range of hours due to the
- * unsigned delta calculation of the time keeping core code, which is
- * necessary to support wrapping clocksources like pm timer.
- */
 static cycle_t read_tsc(void)
 {
 	cycle_t ret;
 
 	rdtscll(ret);
 
-	return ret >= clocksource_tsc.cycle_last ?
-		ret : clocksource_tsc.cycle_last;
+	return ret;
 }
 
 static struct clocksource clocksource_tsc = {
diff --git a/arch/x86/kernel/tsc_64.c b/arch/x86/kernel/tsc_64.c
index 01fc9f0..d3bebaa 100644
--- a/arch/x86/kernel/tsc_64.c
+++ b/arch/x86/kernel/tsc_64.c
@@ -11,7 +11,6 @@
 #include <asm/hpet.h>
 #include <asm/timex.h>
 #include <asm/timer.h>
-#include <asm/vgtod.h>
 
 static int notsc __initdata = 0;
 
@@ -149,9 +148,7 @@ static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 			mark_tsc_unstable("cpufreq changes");
 	}
 
-	preempt_disable();
-	set_cyc2ns_scale(tsc_khz_ref, smp_processor_id());
-	preempt_enable();
+	set_cyc2ns_scale(tsc_khz_ref, freq->cpu);
 
 	return 0;
 }
@@ -291,34 +288,18 @@ int __init notsc_setup(char *s)
 
 __setup("notsc", notsc_setup);
 
-static struct clocksource clocksource_tsc;
 
-/*
- * We compare the TSC to the cycle_last value in the clocksource
- * structure to avoid a nasty time-warp. This can be observed in a
- * very small window right after one CPU updated cycle_last under
- * xtime/vsyscall_gtod lock and the other CPU reads a TSC value which
- * is smaller than the cycle_last reference value due to a TSC which
- * is slighty behind. This delta is nowhere else observable, but in
- * that case it results in a forward time jump in the range of hours
- * due to the unsigned delta calculation of the time keeping core
- * code, which is necessary to support wrapping clocksources like pm
- * timer.
- */
+/* clock source code: */
 static cycle_t read_tsc(void)
 {
 	cycle_t ret = (cycle_t)get_cycles();
-
-	return ret >= clocksource_tsc.cycle_last ?
-		ret : clocksource_tsc.cycle_last;
+	return ret;
 }
 
 static cycle_t __vsyscall_fn vread_tsc(void)
 {
 	cycle_t ret = (cycle_t)vget_cycles();
-
-	return ret >= __vsyscall_gtod_data.clock.cycle_last ?
-		ret : __vsyscall_gtod_data.clock.cycle_last;
+	return ret;
 }
 
 static struct clocksource clocksource_tsc = {
diff --git a/include/asm-x86/nops.h b/include/asm-x86/nops.h
index e3b2bce..b3930ae 100644
--- a/include/asm-x86/nops.h
+++ b/include/asm-x86/nops.h
@@ -73,16 +73,7 @@
 #define P6_NOP7	".byte 0x0f,0x1f,0x80,0,0,0,0\n"
 #define P6_NOP8	".byte 0x0f,0x1f,0x84,0x00,0,0,0,0\n"
 
-#if defined(CONFIG_MK8)
-#define ASM_NOP1 K8_NOP1
-#define ASM_NOP2 K8_NOP2
-#define ASM_NOP3 K8_NOP3
-#define ASM_NOP4 K8_NOP4
-#define ASM_NOP5 K8_NOP5
-#define ASM_NOP6 K8_NOP6
-#define ASM_NOP7 K8_NOP7
-#define ASM_NOP8 K8_NOP8
-#elif defined(CONFIG_MK7)
+#if defined(CONFIG_MK7)
 #define ASM_NOP1 K7_NOP1
 #define ASM_NOP2 K7_NOP2
 #define ASM_NOP3 K7_NOP3
@@ -100,6 +91,15 @@
 #define ASM_NOP6 P6_NOP6
 #define ASM_NOP7 P6_NOP7
 #define ASM_NOP8 P6_NOP8
+#elif defined(CONFIG_X86_64)
+#define ASM_NOP1 K8_NOP1
+#define ASM_NOP2 K8_NOP2
+#define ASM_NOP3 K8_NOP3
+#define ASM_NOP4 K8_NOP4
+#define ASM_NOP5 K8_NOP5
+#define ASM_NOP6 K8_NOP6
+#define ASM_NOP7 K8_NOP7
+#define ASM_NOP8 K8_NOP8
 #else
 #define ASM_NOP1 GENERIC_NOP1
 #define ASM_NOP2 GENERIC_NOP2
