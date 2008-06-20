Return-Path: <linux-kernel-owner+w=401wt.eu-S1757726AbYFTXK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726AbYFTXK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 19:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbYFTXKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 19:10:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:19015 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbYFTXKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 19:10:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=qxy2Mx4f+wpE9/9G1Pddlo43XPuT2jyD/jY8dAO0x2quVsDa6cjupJ5kmfL8H84+8e
         /NmRG7EsJQ4K3K1uq1KmTS+8NXpYODms+fPRvosRytbbB+Atoi7NBHalw/sK6asYhzEe
         uzuUlME4ZWfkrYrhN2ZlYkraOyyqIUIUWpLqc=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: [PATCH] x86: check command line when CONFIG_X86_MPPARSE is not set v2
Date: Fri, 20 Jun 2008 16:11:20 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805041823.57198.yhlu.kernel@gmail.com> <200806191215.01538.yhlu.kernel@gmail.com> <200806200742.36226.yhlu.kernel@gmail.com>
In-Reply-To: <200806200742.36226.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806201611.21198.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


if acpi=off, acpi=noirq and pci=noacpi, we need to disable apic

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/acpi/boot.c |   14 ++++++++++++++
 arch/x86/kernel/apic_32.c   |    2 +-
 arch/x86/kernel/setup.c     |    4 ++++
 arch/x86/kernel/setup_32.c  |    5 +++++
 arch/x86/kernel/setup_64.c  |    9 +++++++++
 include/asm-x86/apic.h      |    6 +++++-
 include/linux/acpi.h        |    6 ++++++
 7 files changed, 44 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -1740,6 +1740,20 @@ static int __init parse_pci(char *arg)
 }
 early_param("pci", parse_pci);
 
+int __init acpi_mps_check(void)
+{
+#if defined(CONFIG_X86_LOCAL_APIC) && !defined(CONFIG_X86_MPPARSE)
+/* mptable code is not built-in*/
+	if (acpi_disabled || acpi_noirq) {
+		printk(KERN_WARNING "MPS support code is not built-in.\n"
+		       "Using acpi=off or acpi=noirq or pci=noacpi "
+		       "may have problem\n");
+		return 1;
+	}
+#endif
+	return 0;
+}
+
 #ifdef CONFIG_X86_IO_APIC
 static int __init parse_acpi_skip_timer_override(char *arg)
 {
Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -689,6 +689,11 @@ void __init setup_arch(char **cmdline_p)
 		early_dump_pci_devices();
 #endif
 
+	if (acpi_mps_check()){
+		enable_local_apic = -1;
+		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
+	}
+
 	finish_e820_parsing();
 
 	probe_roms();
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -319,6 +319,11 @@ void __init setup_arch(char **cmdline_p)
 		early_dump_pci_devices();
 #endif
 
+	if (acpi_mps_check()) {
+		disable_apic = 1;
+		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
+	}
+
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	if (init_ohci1394_dma_early)
 		init_ohci1394_dma_on_all_controllers();
@@ -740,6 +745,10 @@ static void __cpuinit early_identify_cpu
 		cpu_devs[c->x86_vendor]->c_early_init(c);
 
 	validate_pat_support(c);
+
+	/* early_param could clear that, but recall get it set again */
+	if (disable_apic)
+		clear_cpu_cap(c, X86_FEATURE_APIC);
 }
 
 /*
Index: linux-2.6/include/linux/acpi.h
===================================================================
--- linux-2.6.orig/include/linux/acpi.h
+++ linux-2.6/include/linux/acpi.h
@@ -82,6 +82,7 @@ char * __acpi_map_table (unsigned long p
 int early_acpi_boot_init(void);
 int acpi_boot_init (void);
 int acpi_boot_table_init (void);
+int acpi_mps_check (void);
 int acpi_numa_init (void);
 
 int acpi_table_init (void);
@@ -250,6 +251,11 @@ static inline int acpi_boot_table_init(v
 	return 0;
 }
 
+static inline int acpi_mps_check(void)
+{
+	return 0;
+}
+
 static inline int acpi_check_resource_conflict(struct resource *res)
 {
 	return 0;
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -161,6 +161,10 @@ void __init setup_per_cpu_areas(void)
 	char *ptr;
 	int cpu;
 
+	/* no processor from mptable or madt */
+	if (!num_processors)
+		num_processors = 1;
+
 #ifdef CONFIG_HOTPLUG_CPU
 	prefill_possible_map();
 #else
Index: linux-2.6/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic_32.c
+++ linux-2.6/arch/x86/kernel/apic_32.c
@@ -57,7 +57,7 @@ unsigned long mp_lapic_addr;
  *
  * -1=force-disable, +1=force-enable
  */
-static int enable_local_apic __initdata;
+int enable_local_apic;
 
 /* Local APIC timer verification ok */
 static int local_apic_timer_verify_ok;
Index: linux-2.6/include/asm-x86/apic.h
===================================================================
--- linux-2.6.orig/include/asm-x86/apic.h
+++ linux-2.6/include/asm-x86/apic.h
@@ -39,8 +39,12 @@ extern int apic_verbosity;
 extern int local_apic_timer_c2_ok;
 
 extern int ioapic_force;
-extern int disable_apic;
 
+#ifdef CONFIG_X86_64
+extern int disable_apic;
+#else
+extern int enable_local_apic;
+#endif
 /*
  * Basic functions accessing APICs.
  */
