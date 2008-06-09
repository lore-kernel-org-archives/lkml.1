Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbYFIBc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbYFIBc7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 21:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYFIBcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 21:32:50 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:4977 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbYFIBct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 21:32:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=gzoHU+PvUtZJjmdsKGyX00LA0wafkxc/pU2edptw+YdL6RlV6u2ADqcnldXv4SpdBf
         lAoudf+em76434LviGKj77YzZAUY6mP2F3PxEAHU9XuAjnvvqgWqtzUEZT5CHO7H73qW
         /Gua27hJTPkFbrU7UWbZvu449oqBInuy5Bq8w=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: introduce max_physical_apicid for bigsmp switching
Date: Sun, 8 Jun 2008 18:29:22 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806050309.11197.yhlu.kernel@gmail.com> <200806061441.59984.yhlu.kernel@gmail.com> <200806070031.35322.yhlu.kernel@gmail.com>
In-Reply-To: <200806070031.35322.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806081829.22866.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


one multi-sockets system with 3 or 4 ioapics, when 4 dualcore cpus or 2 quadcore cpus
installed, need to switch to bigsmp or physflat. because cpu apic id is [4,11]
instead of [0,7], and we need to check max apic id instead of cpu numbers.

also add check for 32 bit when acpi is not compiled in or acpi=off

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic_32.c
+++ linux-2.6/arch/x86/kernel/apic_32.c
@@ -1520,6 +1520,9 @@ void __cpuinit generic_processor_info(in
 		 */
 		cpu = 0;
 
+	if (apicid > max_physical_apicid)
+		max_physical_apicid = apicid;
+
 	/*
 	 * Would be preferable to switch to bigsmp when CONFIG_HOTPLUG_CPU=y
 	 * but we need to work other dependencies like SMP_SUSPEND etc
@@ -1527,7 +1530,7 @@ void __cpuinit generic_processor_info(in
 	 * if (CPU_HOTPLUG_ENABLED || num_processors > 8)
 	 *       - Ashok Raj <ashok.raj@intel.com>
 	 */
-	if (num_processors > 8) {
+	if (max_physical_apicid >= 8) {
 		switch (boot_cpu_data.x86_vendor) {
 		case X86_VENDOR_INTEL:
 			if (!APIC_XAPIC(version)) {
Index: linux-2.6/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic_64.c
+++ linux-2.6/arch/x86/kernel/apic_64.c
@@ -1092,6 +1092,9 @@ void __cpuinit generic_processor_info(in
 		 */
 		cpu = 0;
 	}
+	if (apicid > max_physical_apicid)
+		max_physical_apicid = apicid;
+
 	/* are we being called early in kernel startup? */
 	if (early_per_cpu_ptr(x86_cpu_to_apicid)) {
 		u16 *cpu_to_apicid = early_per_cpu_ptr(x86_cpu_to_apicid);
Index: linux-2.6/arch/x86/kernel/genapic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genapic_64.c
+++ linux-2.6/arch/x86/kernel/genapic_64.c
@@ -51,7 +51,7 @@ void __init setup_apic_routing(void)
 	else
 #endif
 
-	if (num_possible_cpus() <= 8)
+	if (max_physical_apicid < 8)
 		genapic = &apic_flat;
 	else
 		genapic = &apic_physflat;
Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -473,6 +473,11 @@ static int __init smp_read_mpc(struct mp
 		++mpc_record;
 #endif
 	}
+
+#ifdef CONFIG_X86_GENERICARCH
+       generic_bigsmp_probe();
+#endif
+
 	setup_apic_routing();
 	if (!num_processors)
 		printk(KERN_ERR "MPTABLE: no processors registered!\n");
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -17,6 +17,7 @@ unsigned int num_processors;
 unsigned disabled_cpus __cpuinitdata;
 /* Processor that is doing the boot up */
 unsigned int boot_cpu_physical_apicid = -1U;
+unsigned int max_physical_apicid;
 EXPORT_SYMBOL(boot_cpu_physical_apicid);
 
 /* Bitmask of physically existing CPUs */
Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -838,18 +838,17 @@ void __init setup_arch(char **cmdline_p)
 
 #ifdef CONFIG_ACPI
 	acpi_boot_init();
-
+#endif
+#if defined(CONFIG_X86_MPPARSE) || defined(CONFIG_X86_VISWS)
+	if (smp_found_config)
+		get_smp_config();
+#endif
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_PC)
 	if (def_to_bigsmp)
 		printk(KERN_WARNING "More than 8 CPUs detected and "
 			"CONFIG_X86_PC cannot handle it.\nUse "
 			"CONFIG_X86_GENERICARCH or CONFIG_X86_BIGSMP.\n");
 #endif
-#endif
-#if defined(CONFIG_X86_MPPARSE) || defined(CONFIG_X86_VISWS)
-	if (smp_found_config)
-		get_smp_config();
-#endif
 
 	e820_setup_gap();
 	e820_mark_nosave_regions(max_low_pfn);
Index: linux-2.6/arch/x86/mach-generic/bigsmp.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-generic/bigsmp.c
+++ linux-2.6/arch/x86/mach-generic/bigsmp.c
@@ -48,7 +48,7 @@ static const struct dmi_system_id bigsmp
 static int probe_bigsmp(void)
 {
 	if (def_to_bigsmp)
-	dmi_bigsmp = 1;
+		dmi_bigsmp = 1;
 	else
 		dmi_check_system(bigsmp_dmi_table);
 	return dmi_bigsmp;
Index: linux-2.6/include/asm-x86/mpspec.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mpspec.h
+++ linux-2.6/include/asm-x86/mpspec.h
@@ -33,6 +33,7 @@ extern int mp_bus_id_to_type[MAX_MP_BUSS
 extern DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
 
 extern unsigned int boot_cpu_physical_apicid;
+extern unsigned int max_physical_apicid;
 extern int smp_found_config;
 extern int mpc_default_type;
 extern unsigned long mp_lapic_addr;
