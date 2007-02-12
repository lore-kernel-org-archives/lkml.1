Return-Path: <linux-kernel-owner+w=401wt.eu-S933079AbXBLHtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079AbXBLHtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933088AbXBLHqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:46:45 -0500
Received: from mail.suse.de ([195.135.220.2]:38381 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933083AbXBLHiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:02 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [11/39] i386: Handle 32 bit PerfMon Counter writes cleanly in i386 nmi_watchdog
Message-Id: <20070212073757.A6A6113DA0@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:37:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Change i386 nmi handler to handle 32 bit perfmon counter MSR writes cleanly.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/nmi.c |   64 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 48 insertions(+), 16 deletions(-)

Index: linux/arch/i386/kernel/nmi.c
===================================================================
--- linux.orig/arch/i386/kernel/nmi.c
+++ linux/arch/i386/kernel/nmi.c
@@ -216,6 +216,28 @@ static __init void nmi_cpu_busy(void *da
 }
 #endif
 
+static unsigned int adjust_for_32bit_ctr(unsigned int hz)
+{
+	u64 counter_val;
+	unsigned int retval = hz;
+
+	/*
+	 * On Intel CPUs with P6/ARCH_PERFMON only 32 bits in the counter
+	 * are writable, with higher bits sign extending from bit 31.
+	 * So, we can only program the counter with 31 bit values and
+	 * 32nd bit should be 1, for 33.. to be 1.
+	 * Find the appropriate nmi_hz
+	 */
+	counter_val = (u64)cpu_khz * 1000;
+	do_div(counter_val, retval);
+ 	if (counter_val > 0x7fffffffULL) {
+		u64 count = (u64)cpu_khz * 1000;
+		do_div(count, 0x7fffffffUL);
+		retval = count + 1;
+	}
+	return retval;
+}
+
 static int __init check_nmi_watchdog(void)
 {
 	unsigned int *prev_nmi_count;
@@ -281,18 +303,10 @@ static int __init check_nmi_watchdog(voi
 		struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
 
 		nmi_hz = 1;
-		/*
-		 * On Intel CPUs with ARCH_PERFMON only 32 bits in the counter
-		 * are writable, with higher bits sign extending from bit 31.
-		 * So, we can only program the counter with 31 bit values and
-		 * 32nd bit should be 1, for 33.. to be 1.
-		 * Find the appropriate nmi_hz
-		 */
-	 	if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0 &&
-			((u64)cpu_khz * 1000) > 0x7fffffffULL) {
-			u64 count = (u64)cpu_khz * 1000;
-			do_div(count, 0x7fffffffUL);
-			nmi_hz = count + 1;
+
+		if (wd->perfctr_msr == MSR_P6_PERFCTR0 ||
+		    wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0) {
+			nmi_hz = adjust_for_32bit_ctr(nmi_hz);
 		}
 	}
 
@@ -442,6 +456,17 @@ static void write_watchdog_counter(unsig
 	wrmsrl(perfctr_msr, 0 - count);
 }
 
+static void write_watchdog_counter32(unsigned int perfctr_msr,
+		const char *descr)
+{
+	u64 count = (u64)cpu_khz * 1000;
+
+	do_div(count, nmi_hz);
+	if(descr)
+		Dprintk("setting %s to -0x%08Lx\n", descr, count);
+	wrmsr(perfctr_msr, (u32)(-count), 0);
+}
+
 /* Note that these events don't tick when the CPU idles. This means
    the frequency varies with CPU load. */
 
@@ -531,7 +556,8 @@ static int setup_p6_watchdog(void)
 
 	/* setup the timer */
 	wrmsr(evntsel_msr, evntsel, 0);
-	write_watchdog_counter(perfctr_msr, "P6_PERFCTR0");
+	nmi_hz = adjust_for_32bit_ctr(nmi_hz);
+	write_watchdog_counter32(perfctr_msr, "P6_PERFCTR0");
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 	evntsel |= P6_EVNTSEL0_ENABLE;
 	wrmsr(evntsel_msr, evntsel, 0);
@@ -704,7 +730,8 @@ static int setup_intel_arch_watchdog(voi
 
 	/* setup the timer */
 	wrmsr(evntsel_msr, evntsel, 0);
-	write_watchdog_counter(perfctr_msr, "INTEL_ARCH_PERFCTR0");
+	nmi_hz = adjust_for_32bit_ctr(nmi_hz);
+	write_watchdog_counter32(perfctr_msr, "INTEL_ARCH_PERFCTR0");
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 	evntsel |= ARCH_PERFMON_EVENTSEL0_ENABLE;
 	wrmsr(evntsel_msr, evntsel, 0);
@@ -956,6 +983,8 @@ __kprobes int nmi_watchdog_tick(struct p
 				dummy &= ~P4_CCCR_OVF;
 	 			wrmsrl(wd->cccr_msr, dummy);
 	 			apic_write(APIC_LVTPC, APIC_DM_NMI);
+				/* start the cycle over again */
+				write_watchdog_counter(wd->perfctr_msr, NULL);
 	 		}
 			else if (wd->perfctr_msr == MSR_P6_PERFCTR0 ||
 				 wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0) {
@@ -964,9 +993,12 @@ __kprobes int nmi_watchdog_tick(struct p
 				 * other P6 variant.
 				 * ArchPerfom/Core Duo also needs this */
 				apic_write(APIC_LVTPC, APIC_DM_NMI);
+				/* P6/ARCH_PERFMON has 32 bit counter write */
+				write_watchdog_counter32(wd->perfctr_msr, NULL);
+			} else {
+				/* start the cycle over again */
+				write_watchdog_counter(wd->perfctr_msr, NULL);
 			}
-			/* start the cycle over again */
-			write_watchdog_counter(wd->perfctr_msr, NULL);
 			rc = 1;
 		} else if (nmi_watchdog == NMI_IO_APIC) {
 			/* don't know how to accurately check for this.
