Return-Path: <linux-kernel-owner+w=401wt.eu-S964781AbXBLHs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964781AbXBLHs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933085AbXBLHqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:46:50 -0500
Received: from mail.suse.de ([195.135.220.2]:38377 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933082AbXBLHh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:37:58 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [10/39] x86_64: Handle 32 bit PerfMon Counter writes cleanly in x86_64 nmi_watchdog
Message-Id: <20070212073756.96F7B13DA0@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:37:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>


P6 CPUs and Core/Core 2 CPUs which has 'architectural perf mon' feature,
only supports write of low 32 bits in Performance Monitoring Counters.
Bits 32..39 are sign extended based on bit 31 and bits 40..63 are reserved
and should be zero.

This patch:

Change x86_64 nmi handler to handle this case cleanly.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/nmi.c |   46 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 14 deletions(-)

Index: linux/arch/x86_64/kernel/nmi.c
===================================================================
--- linux.orig/arch/x86_64/kernel/nmi.c
+++ linux/arch/x86_64/kernel/nmi.c
@@ -214,6 +214,23 @@ static __init void nmi_cpu_busy(void *da
 }
 #endif
 
+static unsigned int adjust_for_32bit_ctr(unsigned int hz)
+{
+	unsigned int retval = hz;
+
+	/*
+	 * On Intel CPUs with ARCH_PERFMON only 32 bits in the counter
+	 * are writable, with higher bits sign extending from bit 31.
+	 * So, we can only program the counter with 31 bit values and
+	 * 32nd bit should be 1, for 33.. to be 1.
+	 * Find the appropriate nmi_hz
+	 */
+ 	if ((((u64)cpu_khz * 1000) / retval) > 0x7fffffffULL) {
+		retval = ((u64)cpu_khz * 1000) / 0x7fffffffUL + 1;
+	}
+	return retval;
+}
+
 int __init check_nmi_watchdog (void)
 {
 	int *counts;
@@ -268,17 +285,8 @@ int __init check_nmi_watchdog (void)
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
-			nmi_hz = ((u64)cpu_khz * 1000) / 0x7fffffffUL + 1;
-		}
+	 	if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0)
+			nmi_hz = adjust_for_32bit_ctr(nmi_hz);
 	}
 
 	kfree(counts);
@@ -634,7 +642,9 @@ static int setup_intel_arch_watchdog(voi
 
 	/* setup the timer */
 	wrmsr(evntsel_msr, evntsel, 0);
-	wrmsrl(perfctr_msr, -((u64)cpu_khz * 1000 / nmi_hz));
+
+	nmi_hz = adjust_for_32bit_ctr(nmi_hz);
+	wrmsr(perfctr_msr, (u32)(-((u64)cpu_khz * 1000 / nmi_hz)), 0);
 
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 	evntsel |= ARCH_PERFMON_EVENTSEL0_ENABLE;
@@ -855,15 +865,23 @@ int __kprobes nmi_watchdog_tick(struct p
 				dummy &= ~P4_CCCR_OVF;
 	 			wrmsrl(wd->cccr_msr, dummy);
 	 			apic_write(APIC_LVTPC, APIC_DM_NMI);
+				/* start the cycle over again */
+				wrmsrl(wd->perfctr_msr,
+				       -((u64)cpu_khz * 1000 / nmi_hz));
 	 		} else if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0) {
 				/*
 				 * ArchPerfom/Core Duo needs to re-unmask
 				 * the apic vector
 				 */
 				apic_write(APIC_LVTPC, APIC_DM_NMI);
+				/* ARCH_PERFMON has 32 bit counter writes */
+				wrmsr(wd->perfctr_msr,
+				     (u32)(-((u64)cpu_khz * 1000 / nmi_hz)), 0);
+			} else {
+				/* start the cycle over again */
+				wrmsrl(wd->perfctr_msr,
+				       -((u64)cpu_khz * 1000 / nmi_hz));
 			}
-			/* start the cycle over again */
-			wrmsrl(wd->perfctr_msr, -((u64)cpu_khz * 1000 / nmi_hz));
 			rc = 1;
 		} else 	if (nmi_watchdog == NMI_IO_APIC) {
 			/* don't know how to accurately check for this.
