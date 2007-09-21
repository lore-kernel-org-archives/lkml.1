Return-Path: <linux-kernel-owner+w=401wt.eu-S1765107AbXIUWgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765107AbXIUWgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763324AbXIUWcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763347AbXIUWcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:12 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [12/50] x86_64: Untable __init references between IO data
Message-Id: <20070921223210.AD1FD13DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Earlier patch added IO APIC setup into local APIC setup. This caused
modpost warnings. Fix them by untangling setup_local_APIC() and splitting
it into smaller functions. The IO APIC initialization is only called
for the BP init.

Also removed some outdated debugging code and minor cleanup.
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/apic.c    |   46 ++++++++++++++++++++-----------------------
 arch/x86_64/kernel/smpboot.c |    8 +++++++
 include/asm-x86_64/apic.h    |    1 
 3 files changed, 31 insertions(+), 24 deletions(-)

Index: linux/arch/x86_64/kernel/apic.c
===================================================================
--- linux.orig/arch/x86_64/kernel/apic.c
+++ linux/arch/x86_64/kernel/apic.c
@@ -323,7 +323,7 @@ void __init init_bsp_APIC(void)
 
 void __cpuinit setup_local_APIC (void)
 {
-	unsigned int value, maxlvt;
+	unsigned int value;
 	int i, j;
 
 	value = apic_read(APIC_LVR);
@@ -417,33 +417,22 @@ void __cpuinit setup_local_APIC (void)
 	else
 		value = APIC_DM_NMI | APIC_LVT_MASKED;
 	apic_write(APIC_LVT1, value);
+}
 
+void __cpuinit lapic_setup_esr(void)
+{
+	unsigned maxlvt = get_maxlvt();
+	apic_write(APIC_LVTERR, ERROR_APIC_VECTOR);
 	/*
-	 * Now enable IO-APICs, actually call clear_IO_APIC
-	 * We need clear_IO_APIC before enabling vector on BP
+	 * spec says clear errors after enabling vector.
 	 */
-	if (!smp_processor_id())
-	if (!skip_ioapic_setup && nr_ioapics)
-		enable_IO_APIC();
-
-	{
-		unsigned oldvalue;
-		maxlvt = get_maxlvt();
-		oldvalue = apic_read(APIC_ESR);
-		value = ERROR_APIC_VECTOR;      // enables sending errors
-		apic_write(APIC_LVTERR, value);
-		/*
-		 * spec says clear errors after enabling vector.
-		 */
-		if (maxlvt > 3)
-			apic_write(APIC_ESR, 0);
-		value = apic_read(APIC_ESR);
-		if (value != oldvalue)
-			apic_printk(APIC_VERBOSE,
-			"ESR value after enabling vector: %08x, after %08x\n",
-			oldvalue, value);
-	}
+	if (maxlvt > 3)
+		apic_write(APIC_ESR, 0);
+}
 
+void __cpuinit end_local_APIC_setup(void)
+{
+	lapic_setup_esr();
 	nmi_watchdog_default();
 	setup_apic_nmi_watchdog(NULL);
 	apic_pm_activate();
@@ -1178,6 +1167,15 @@ int __init APIC_init_uniprocessor (void)
 
 	setup_local_APIC();
 
+	/*
+	 * Now enable IO-APICs, actually call clear_IO_APIC
+	 * We need clear_IO_APIC before enabling vector on BP
+	 */
+	if (!skip_ioapic_setup && nr_ioapics)
+		enable_IO_APIC();
+
+	end_local_APIC_setup();
+
 	if (smp_found_config && !skip_ioapic_setup && nr_ioapics)
 		setup_IO_APIC();
 	else
Index: linux/arch/x86_64/kernel/smpboot.c
===================================================================
--- linux.orig/arch/x86_64/kernel/smpboot.c
+++ linux/arch/x86_64/kernel/smpboot.c
@@ -211,6 +211,7 @@ void __cpuinit smp_callin(void)
 
 	Dprintk("CALLIN, before setup_local_APIC().\n");
 	setup_local_APIC();
+	end_local_APIC_setup();
 
 	/*
 	 * Get our bogomips.
@@ -870,6 +871,13 @@ void __init smp_prepare_cpus(unsigned in
 	 */
 	setup_local_APIC();
 
+	/*
+	 * Enable IO APIC before setting up error vector
+	 */
+	if (!skip_ioapic_setup && nr_ioapics)
+		enable_IO_APIC();
+	end_local_APIC_setup();
+
 	if (GET_APIC_ID(apic_read(APIC_ID)) != boot_cpu_id) {
 		panic("Boot APIC ID in local APIC unexpected (%d vs %d)",
 		      GET_APIC_ID(apic_read(APIC_ID)), boot_cpu_id);
Index: linux/include/asm-x86_64/apic.h
===================================================================
--- linux.orig/include/asm-x86_64/apic.h
+++ linux/include/asm-x86_64/apic.h
@@ -73,6 +73,7 @@ extern void cache_APIC_registers (void);
 extern void sync_Arb_IDs (void);
 extern void init_bsp_APIC (void);
 extern void setup_local_APIC (void);
+extern void end_local_APIC_setup(void);
 extern void init_apic_mappings (void);
 extern void smp_local_timer_interrupt (void);
 extern void setup_boot_APIC_clock (void);
