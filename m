Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbXD2Kw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbXD2Kw4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbXD2Kw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:52:56 -0400
Received: from ns.suse.de ([195.135.220.2]:52026 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099AbXD2Kwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:52:55 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/48] x86_64: Use new shared sched_clock in x86-64 too
Message-Id: <20070429105250.CECDB151CB@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:52:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/Makefile |    3 ++-
 arch/x86_64/kernel/time.c   |    1 -
 arch/x86_64/kernel/tsc.c    |   28 ----------------------------
 include/asm-x86_64/timer.h  |    1 +
 include/asm-x86_64/timex.h  |    1 -
 5 files changed, 3 insertions(+), 31 deletions(-)

Index: linux/arch/x86_64/kernel/Makefile
===================================================================
--- linux.orig/arch/x86_64/kernel/Makefile
+++ linux/arch/x86_64/kernel/Makefile
@@ -8,7 +8,7 @@ obj-y	:= process.o signal.o entry.o trap
 		ptrace.o time.o ioport.o ldt.o setup.o i8259.o sys_x86_64.o \
 		x8664_ksyms.o i387.o syscall.o vsyscall.o \
 		setup64.o bootflag.o e820.o reboot.o quirks.o i8237.o \
-		pci-dma.o pci-nommu.o alternative.o hpet.o tsc.o
+		pci-dma.o pci-nommu.o alternative.o hpet.o tsc.o sched-clock.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_X86_MCE)		+= mce.o therm_throt.o
@@ -57,3 +57,4 @@ i8237-y				+= ../../i386/kernel/i8237.o
 msr-$(subst m,y,$(CONFIG_X86_MSR))  += ../../i386/kernel/msr.o
 alternative-y			+= ../../i386/kernel/alternative.o
 pcspeaker-y			+= ../../i386/kernel/pcspeaker.o
+sched-clock-y			+= ../../i386/kernel/sched-clock.o
Index: linux/arch/x86_64/kernel/tsc.c
===================================================================
--- linux.orig/arch/x86_64/kernel/tsc.c
+++ linux/arch/x86_64/kernel/tsc.c
@@ -16,32 +16,6 @@ EXPORT_SYMBOL(cpu_khz);
 unsigned int tsc_khz;
 EXPORT_SYMBOL(tsc_khz);
 
-static unsigned int cyc2ns_scale __read_mostly;
-
-void set_cyc2ns_scale(unsigned long khz)
-{
-	cyc2ns_scale = (NSEC_PER_MSEC << NS_SCALE) / khz;
-}
-
-static unsigned long long cycles_2_ns(unsigned long long cyc)
-{
-	return (cyc * cyc2ns_scale) >> NS_SCALE;
-}
-
-unsigned long long sched_clock(void)
-{
-	unsigned long a = 0;
-
-	/* Could do CPU core sync here. Opteron can execute rdtsc speculatively,
-	 * which means it is not completely exact and may not be monotonous
-	 * between CPUs. But the errors should be too small to matter for
-	 * scheduling purposes.
-	 */
-
-	rdtscll(a);
-	return cycles_2_ns(a);
-}
-
 static int tsc_unstable;
 
 static inline int check_tsc_unstable(void)
@@ -114,8 +88,6 @@ static int time_cpufreq_notifier(struct 
 			mark_tsc_unstable();
 	}
 
-	set_cyc2ns_scale(tsc_khz_ref);
-
 	return 0;
 }
 
Index: linux/include/asm-x86_64/timer.h
===================================================================
--- /dev/null
+++ linux/include/asm-x86_64/timer.h
@@ -0,0 +1 @@
+#define get_scheduled_cycles(x) rdtscll(x)
Index: linux/arch/x86_64/kernel/time.c
===================================================================
--- linux.orig/arch/x86_64/kernel/time.c
+++ linux/arch/x86_64/kernel/time.c
@@ -404,7 +404,6 @@ void __init time_init(void)
 	else
 		vgetcpu_mode = VGETCPU_LSL;
 
-	set_cyc2ns_scale(tsc_khz);
 	printk(KERN_INFO "time.c: Detected %d.%03d MHz processor.\n",
 		cpu_khz / 1000, cpu_khz % 1000);
 	init_tsc_clocksource();
Index: linux/include/asm-x86_64/timex.h
===================================================================
--- linux.orig/include/asm-x86_64/timex.h
+++ linux/include/asm-x86_64/timex.h
@@ -28,5 +28,4 @@ extern int read_current_timer(unsigned l
 #define US_SCALE        32 /* 2^32, arbitralrily chosen */
 
 extern void mark_tsc_unstable(void);
-extern void set_cyc2ns_scale(unsigned long khz);
 #endif
