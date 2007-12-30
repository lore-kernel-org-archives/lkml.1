Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbXL3VZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbXL3VZq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756965AbXL3VZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:25:39 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:44151 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720AbXL3VZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:25:38 -0500
Date: Sun, 30 Dec 2007 13:30:19 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: fix section warning about enable_IO_APIC and
 setup_local_APIC
In-reply-to: <20071230145115.GR16946@elte.hu>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200712301330.19396.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200712291952.20455.yinghai.lu@sun.com>
 <20071230145115.GR16946@elte.hu>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: fix section warning about enable_IO_APIC and setup_local_APIC

clear IO_APIC before enabing apic error vector cause link warning

use function call in setup_local_APIC to avoid that.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/kernel/smpboot_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot_64.c
+++ linux-2.6/arch/x86/kernel/smpboot_64.c
@@ -211,7 +211,7 @@ void __cpuinit smp_callin(void)
 	 */
 
 	Dprintk("CALLIN, before setup_local_APIC().\n");
-	setup_local_APIC();
+	setup_local_APIC(NULL);
 
 	/*
 	 * Get our bogomips.
@@ -867,6 +867,8 @@ void __init smp_set_apicids(void)
  */
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
+	void (*extra_call)(void) = NULL;
+
 	nmi_watchdog_default();
 	current_cpu_data = boot_cpu_data;
 	current_thread_info()->cpu = 0;  /* needed? */
@@ -883,7 +885,10 @@ void __init smp_prepare_cpus(unsigned in
 	/*
 	 * Switch from PIC to APIC mode.
 	 */
-	setup_local_APIC();
+	if (!skip_ioapic_setup && nr_ioapics)
+		extra_call = enable_IO_APIC;
+
+	setup_local_APIC(extra_call);
 
 	if (GET_APIC_ID(apic_read(APIC_ID)) != boot_cpu_id) {
 		panic("Boot APIC ID in local APIC unexpected (%d vs %d)",
Index: linux-2.6/include/asm-x86/apic_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/apic_64.h
+++ linux-2.6/include/asm-x86/apic_64.h
@@ -74,7 +74,7 @@ extern int verify_local_APIC (void);
 extern void cache_APIC_registers (void);
 extern void sync_Arb_IDs (void);
 extern void init_bsp_APIC (void);
-extern void setup_local_APIC (void);
+extern void setup_local_APIC (void (*extra_call)(void));
 extern void init_apic_mappings (void);
 extern void smp_local_timer_interrupt (void);
 extern void setup_boot_APIC_clock (void);
Index: linux-2.6/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic_64.c
+++ linux-2.6/arch/x86/kernel/apic_64.c
@@ -418,7 +418,7 @@ void __init init_bsp_APIC(void)
 	apic_write(APIC_LVT1, value);
 }
 
-void __cpuinit setup_local_APIC (void)
+void __cpuinit setup_local_APIC (void (*extra_call)(void))
 {
 	unsigned int value, maxlvt;
 	int i, j;
@@ -521,9 +521,8 @@ void __cpuinit setup_local_APIC (void)
 	 * Now enable IO-APICs, actually call clear_IO_APIC
 	 * We need clear_IO_APIC before enabling vector on BP
 	 */
-	if (!smp_processor_id())
-	if (!skip_ioapic_setup && nr_ioapics)
-		enable_IO_APIC();
+	if (extra_call)
+		(*extra_call)();
 
 	{
 		unsigned oldvalue;
@@ -1206,6 +1205,8 @@ int disable_apic;
  */
 int __init APIC_init_uniprocessor (void)
 {
+	void (*extra_call)(void) = NULL;
+
 	if (disable_apic) {
 		printk(KERN_INFO "Apic disabled\n");
 		return -1;
@@ -1221,7 +1222,10 @@ int __init APIC_init_uniprocessor (void)
 	phys_cpu_present_map = physid_mask_of_physid(boot_cpu_id);
 	apic_write(APIC_ID, SET_APIC_ID(boot_cpu_id));
 
-	setup_local_APIC();
+	if (!skip_ioapic_setup && nr_ioapics)
+		extra_call = enable_IO_APIC;
+
+	setup_local_APIC(extra_call);
 
 	if (smp_found_config && !skip_ioapic_setup && nr_ioapics)
 		setup_IO_APIC();
