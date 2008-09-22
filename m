Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbYIVRN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbYIVRN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 13:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbYIVRNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 13:13:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59557 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbYIVRNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 13:13:47 -0400
Date: Mon, 22 Sep 2008 13:13:59 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, dzickus@redhat.com, prarit@redhat.com,
       vgoyal@redhat.com
Subject: [PATCH] NMI watchdog: setup before enabling NMI watchdog
Message-ID: <20080922171347.GI16840@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a small window when NMI watchdog is being set up that if any NMIs
are triggered, the NMI code will make make use of not initalized wd_ops
elements:
	void setup_apic_nmi_watchdog(void *unused)
	{       
		if (__get_cpu_var(wd_enabled))
			return;

		/* cheap hack to support suspend/resume */
		/* if cpu0 is not active neither should the other cpus */
		if (smp_processor_id() != 0 && atomic_read(&nmi_active) <= 0)
			return;

		switch (nmi_watchdog) {
		case NMI_LOCAL_APIC:
			/* enable it before to avoid race with handler */
-->			__get_cpu_var(wd_enabled) = 1;
-->			if (lapic_watchdog_init(nmi_hz) < 0) {
(...)
	asmlinkage notrace __kprobes void default_do_nmi(struct pt_regs *regs)
	{       
	(...)
			if (nmi_watchdog_tick(regs, reason))
				return;
(...)
	notrace __kprobes int
	nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
	{       
	(...)
		if (!__get_cpu_var(wd_enabled))
			return rc;
		switch (nmi_watchdog) {
		case NMI_LOCAL_APIC:
			rc |= lapic_wd_event(nmi_hz);
(...)
int lapic_wd_event(unsigned nmi_hz)
{       
	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
	u64 ctr;

-->	rdmsrl(wd->perfctr_msr, ctr);

and wd->*_msr will be initialized on each processor type specific setup, after
enabling NMIs for PMIs. Since the counter was just set, the chances of an
performance counter generated NMI is minimal, but any other unknown NMI would
trigger the problem. This patch fixes the problem by setting everything up
before enabling performance counter generated NMIs and will set wd_enabled
using a callback function.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Acked-by: Prarit Bhargava <prarit@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>

---
 arch/x86/kernel/cpu/perfctr-watchdog.c |   45 ++++++++++++++++++++++++---------
 arch/x86/kernel/nmi.c                  |   11 ++++++--
 include/asm-x86/nmi.h                  |    1 
 3 files changed, 43 insertions(+), 14 deletions(-)

--- linus-2.6.orig/arch/x86/kernel/cpu/perfctr-watchdog.c	2008-09-19 15:38:16.000000000 -0400
+++ linus-2.6/arch/x86/kernel/cpu/perfctr-watchdog.c	2008-09-22 10:53:22.000000000 -0400
@@ -295,13 +295,19 @@ static int setup_k7_watchdog(unsigned nm
 	/* setup the timer */
 	wrmsr(evntsel_msr, evntsel, 0);
 	write_watchdog_counter(perfctr_msr, "K7_PERFCTR0",nmi_hz);
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	evntsel |= K7_EVNTSEL_ENABLE;
-	wrmsr(evntsel_msr, evntsel, 0);
 
+	/* initialize the wd struct before enabling */
 	wd->perfctr_msr = perfctr_msr;
 	wd->evntsel_msr = evntsel_msr;
 	wd->cccr_msr = 0;  /* unused */
+
+	/* ok, everything is initialized, announce that we're set */
+	cpu_nmi_set_wd_enabled();
+
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+	evntsel |= K7_EVNTSEL_ENABLE;
+	wrmsr(evntsel_msr, evntsel, 0);
+
 	return 1;
 }
 
@@ -379,13 +385,19 @@ static int setup_p6_watchdog(unsigned nm
 	wrmsr(evntsel_msr, evntsel, 0);
 	nmi_hz = adjust_for_32bit_ctr(nmi_hz);
 	write_watchdog_counter32(perfctr_msr, "P6_PERFCTR0",nmi_hz);
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	evntsel |= P6_EVNTSEL0_ENABLE;
-	wrmsr(evntsel_msr, evntsel, 0);
 
+	/* initialize the wd struct before enabling */
 	wd->perfctr_msr = perfctr_msr;
 	wd->evntsel_msr = evntsel_msr;
 	wd->cccr_msr = 0;  /* unused */
+
+	/* ok, everything is initialized, announce that we're set */
+	cpu_nmi_set_wd_enabled();
+
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+	evntsel |= P6_EVNTSEL0_ENABLE;
+	wrmsr(evntsel_msr, evntsel, 0);
+
 	return 1;
 }
 
@@ -499,12 +511,17 @@ static int setup_p4_watchdog(unsigned nm
 	wrmsr(evntsel_msr, evntsel, 0);
 	wrmsr(cccr_msr, cccr_val, 0);
 	write_watchdog_counter(perfctr_msr, "P4_IQ_COUNTER0", nmi_hz);
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	cccr_val |= P4_CCCR_ENABLE;
-	wrmsr(cccr_msr, cccr_val, 0);
+
 	wd->perfctr_msr = perfctr_msr;
 	wd->evntsel_msr = evntsel_msr;
 	wd->cccr_msr = cccr_msr;
+
+	/* ok, everything is initialized, announce that we're set */
+	cpu_nmi_set_wd_enabled();
+
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+	cccr_val |= P4_CCCR_ENABLE;
+	wrmsr(cccr_msr, cccr_val, 0);
 	return 1;
 }
 
@@ -620,13 +637,17 @@ static int setup_intel_arch_watchdog(uns
 	wrmsr(evntsel_msr, evntsel, 0);
 	nmi_hz = adjust_for_32bit_ctr(nmi_hz);
 	write_watchdog_counter32(perfctr_msr, "INTEL_ARCH_PERFCTR0", nmi_hz);
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	evntsel |= ARCH_PERFMON_EVENTSEL0_ENABLE;
-	wrmsr(evntsel_msr, evntsel, 0);
 
 	wd->perfctr_msr = perfctr_msr;
 	wd->evntsel_msr = evntsel_msr;
 	wd->cccr_msr = 0;  /* unused */
+
+	/* ok, everything is initialized, announce that we're set */
+	cpu_nmi_set_wd_enabled();
+
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+	evntsel |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+	wrmsr(evntsel_msr, evntsel, 0);
 	intel_arch_wd_ops.checkbit = 1ULL << (eax.split.bit_width - 1);
 	return 1;
 }
--- linus-2.6.orig/arch/x86/kernel/nmi.c	2008-09-11 16:24:42.000000000 -0400
+++ linus-2.6/arch/x86/kernel/nmi.c	2008-09-22 10:53:42.000000000 -0400
@@ -299,6 +299,15 @@ void acpi_nmi_disable(void)
 		on_each_cpu(__acpi_nmi_disable, NULL, 1);
 }
 
+/*
+ * This function is called as soon the LAPIC NMI watchdog driver has everything
+ * in place and it's ready to check if the NMIs belong to the NMI watchdog
+ */
+void cpu_nmi_set_wd_enabled(void)
+{
+	__get_cpu_var(wd_enabled) = 1;
+}
+
 void setup_apic_nmi_watchdog(void *unused)
 {
 	if (__get_cpu_var(wd_enabled))
@@ -311,8 +320,6 @@ void setup_apic_nmi_watchdog(void *unuse
 
 	switch (nmi_watchdog) {
 	case NMI_LOCAL_APIC:
-		 /* enable it before to avoid race with handler */
-		__get_cpu_var(wd_enabled) = 1;
 		if (lapic_watchdog_init(nmi_hz) < 0) {
 			__get_cpu_var(wd_enabled) = 0;
 			return;
--- linus-2.6.orig/include/asm-x86/nmi.h	2008-09-19 15:38:16.000000000 -0400
+++ linus-2.6/include/asm-x86/nmi.h	2008-09-22 10:52:46.000000000 -0400
@@ -34,6 +34,7 @@ extern void stop_apic_nmi_watchdog(void 
 extern void disable_timer_nmi_watchdog(void);
 extern void enable_timer_nmi_watchdog(void);
 extern int nmi_watchdog_tick(struct pt_regs *regs, unsigned reason);
+extern void cpu_nmi_set_wd_enabled(void);
 
 extern atomic_t nmi_active;
 extern unsigned int nmi_watchdog;

