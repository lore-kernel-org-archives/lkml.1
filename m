Return-Path: <linux-kernel-owner+w=401wt.eu-S1755744AbXIFPAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbXIFPAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 11:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbXIFO7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 10:59:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:40963 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbXIFO7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 10:59:53 -0400
From: Andi Kleen <ak@suse.de>
References: <20070906459.839970000@suse.de>
In-Reply-To: <20070906459.839970000@suse.de>
To: eranian@hpl.hp.com, patches@x86-64.org, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
Subject: [PATCH for 2.6.23] [1/3] i386: Fix perfctr watchdog on core duo
Message-Id: <20070906145951.EDEE914EE9@wotan.suse.de>
Date: Thu,  6 Sep 2007 16:59:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Stephane Eranian <eranian@hpl.hp.com>

Fix the NMI watchdog on Intel CoreDuo processor where the
kernel would get stuck during boot. The issue is related to
errata AE49, where the PERFEVTSEL1 counter does not have a
working enable bit. Thus it is not possible to use it for NMI.
The patch creates a dedicated wd_ops for CoreDuo which falls
back to using PERFEVTSEL0. The other Intel processors supporting
the architectural PMU will keep on using PERFEVTSEL1 as this
allows other subsystems, such as perfmon, to use PERFEVTSEL0 for
PEBS monitoring in particular.
Bug initially reported by Daniel Walker.

AK: Added comments

Signed-off-by: Stephane Eranian <eranian@hpl.hp.com>
Signed-off-by: Andi Kleen <ak@suse.de>


---
 arch/i386/kernel/cpu/perfctr-watchdog.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

Index: linux/arch/i386/kernel/cpu/perfctr-watchdog.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/perfctr-watchdog.c
+++ linux/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -263,8 +263,8 @@ static int setup_k7_watchdog(unsigned nm
 	unsigned int evntsel;
 	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
 
-	perfctr_msr = MSR_K7_PERFCTR0;
-	evntsel_msr = MSR_K7_EVNTSEL0;
+	perfctr_msr = wd_ops->perfctr;
+	evntsel_msr = wd_ops->evntsel;
 
 	wrmsrl(perfctr_msr, 0UL);
 
@@ -343,8 +343,8 @@ static int setup_p6_watchdog(unsigned nm
 	unsigned int evntsel;
 	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
 
-	perfctr_msr = MSR_P6_PERFCTR0;
-	evntsel_msr = MSR_P6_EVNTSEL0;
+	perfctr_msr = wd_ops->perfctr;
+	evntsel_msr = wd_ops->evntsel;
 
 	/* KVM doesn't implement this MSR */
 	if (wrmsr_safe(perfctr_msr, 0, 0) < 0)
@@ -569,8 +569,8 @@ static int setup_intel_arch_watchdog(uns
 	    (ebx & ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT))
 		return 0;
 
-	perfctr_msr = MSR_ARCH_PERFMON_PERFCTR1;
-	evntsel_msr = MSR_ARCH_PERFMON_EVENTSEL1;
+	perfctr_msr = wd_ops->perfctr;
+	evntsel_msr = wd_ops->evntsel;
 
 	wrmsrl(perfctr_msr, 0UL);
 
@@ -605,6 +605,16 @@ static struct wd_ops intel_arch_wd_ops =
 	.evntsel = MSR_ARCH_PERFMON_EVENTSEL1,
 };
 
+static struct wd_ops coreduo_wd_ops = {
+	.reserve = single_msr_reserve,
+	.unreserve = single_msr_unreserve,
+	.setup = setup_intel_arch_watchdog,
+	.rearm = p6_rearm,
+	.stop = single_msr_stop_watchdog,
+	.perfctr = MSR_ARCH_PERFMON_PERFCTR0,
+	.evntsel = MSR_ARCH_PERFMON_EVENTSEL0,
+};
+
 static void probe_nmi_watchdog(void)
 {
 	switch (boot_cpu_data.x86_vendor) {
@@ -615,6 +625,12 @@ static void probe_nmi_watchdog(void)
 		wd_ops = &k7_wd_ops;
 		break;
 	case X86_VENDOR_INTEL:
+		/* Work around Core Duo (Yonah) errata AE49 where perfctr1
+		   doesn't have a working enable bit. */
+		if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 14) {
+			wd_ops = &coreduo_wd_ops;
+			break;
+		}
 		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
 			wd_ops = &intel_arch_wd_ops;
 			break;
