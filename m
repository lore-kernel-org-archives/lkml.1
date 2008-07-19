Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbYGSJIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbYGSJIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 05:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbYGSJIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 05:08:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:48755 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbYGSJIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 05:08:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=Wtc69xSuLYVUL36T50ItTnrtSfm7KKA6eXB03s0/w8UPM9BHrjWEdVCcqNca9Gvro/
         /x5bQRJB0TuP8dAB5LDH3WqxUdLV9aYuwG2zn3kqzvH4dDz5b/ixXmIVauYuN3yPQBZP
         IWUzwbqPLZAVNVaSMNwG1SAeCprJp3eFq1OZY=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: introduce x86_ops
Date: Sat, 19 Jul 2008 02:07:25 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807190207.26077.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/e820.c         |    9 +-------
 arch/x86/kernel/mpparse.c      |   17 ++++------------
 arch/x86/kernel/setup.c        |    4 +++
 arch/x86/kernel/visws_quirks.c |   42 +++++++++++++++++++----------------------
 arch/x86/mach-default/setup.c  |   24 +++++++----------------
 include/asm-x86/setup.h        |   18 ++++++++++-------
 6 files changed, 50 insertions(+), 64 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1299,11 +1299,6 @@ void __init e820_reserve_resources(void)
 	}
 }
 
-/*
- * Non-standard memory setup can be specified via this quirk:
- */
-char * (*arch_memory_setup_quirk)(void);
-
 char *__init default_machine_specific_memory_setup(void)
 {
 	char *who = "BIOS-e820";
@@ -1344,8 +1339,8 @@ char *__init default_machine_specific_me
 
 char *__init __attribute__((weak)) machine_specific_memory_setup(void)
 {
-	if (arch_memory_setup_quirk) {
-		char *who = arch_memory_setup_quirk();
+	if (x86_ops->arch_memory_setup) {
+		char *who = x86_ops->arch_memory_setup();
 
 		if (who)
 			return who;
Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -27,6 +27,7 @@
 #include <asm/bios_ebda.h>
 #include <asm/e820.h>
 #include <asm/trampoline.h>
+#include <asm/setup.h>
 
 #include <mach_apic.h>
 #ifdef CONFIG_X86_32
@@ -728,20 +729,14 @@ static inline void __init construct_defa
 static struct intel_mp_floating *mpf_found;
 
 /*
- * Machine specific quirk for finding the SMP config before other setup
- * activities destroy the table:
- */
-int (*mach_get_smp_config_quirk)(unsigned int early);
-
-/*
  * Scan the memory blocks for an SMP configuration block.
  */
 static void __init __get_smp_config(unsigned int early)
 {
 	struct intel_mp_floating *mpf = mpf_found;
 
-	if (mach_get_smp_config_quirk) {
-		if (mach_get_smp_config_quirk(early))
+	if (x86_ops->mach_get_smp_config) {
+		if (x86_ops->mach_get_smp_config(early))
 			return;
 	}
 	if (acpi_lapic && early)
@@ -901,14 +896,12 @@ static int __init smp_scan_config(unsign
 	return 0;
 }
 
-int (*mach_find_smp_config_quirk)(unsigned int reserve);
-
 static void __init __find_smp_config(unsigned int reserve)
 {
 	unsigned int address;
 
-	if (mach_find_smp_config_quirk) {
-		if (mach_find_smp_config_quirk(reserve))
+	if (x86_ops->mach_find_smp_config) {
+		if (x86_ops->mach_find_smp_config(reserve))
 			return;
 	}
 	/*
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -574,6 +574,10 @@ static int __init setup_elfcorehdr(char
 early_param("elfcorehdr", setup_elfcorehdr);
 #endif
 
+static struct x86_ops default_x86_ops __initdata;
+
+struct x86_ops *x86_ops __initdata = &default_x86_ops;
+
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
Index: linux-2.6/arch/x86/kernel/visws_quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/visws_quirks.c
+++ linux-2.6/arch/x86/kernel/visws_quirks.c
@@ -73,7 +73,7 @@ int is_visws_box(void)
 	return visws_board_type >= 0;
 }
 
-static int __init visws_time_init_quirk(void)
+static int __init visws_time_init(void)
 {
 	printk(KERN_INFO "Starting Cobalt Timer system clock\n");
 
@@ -93,7 +93,7 @@ static int __init visws_time_init_quirk(
 	return 0;
 }
 
-static int __init visws_pre_intr_init_quirk(void)
+static int __init visws_pre_intr_init(void)
 {
 	init_VISWS_APIC_irqs();
 
@@ -114,7 +114,7 @@ EXPORT_SYMBOL(sgivwfb_mem_size);
 
 long long mem_size __initdata = 0;
 
-static char * __init visws_memory_setup_quirk(void)
+static char * __init visws_memory_setup(void)
 {
 	long long gfx_mem_size = 8 * MB;
 
@@ -176,7 +176,7 @@ static void visws_machine_power_off(void
 	outl(PIIX_SPECIAL_STOP, 0xCFC);
 }
 
-static int __init visws_get_smp_config_quirk(unsigned int early)
+static int __init visws_get_smp_config(unsigned int early)
 {
 	/*
 	 * Prevent MP-table parsing by the generic code:
@@ -192,7 +192,7 @@ extern unsigned int __cpuinitdata maxcpu
  * No problem for Linux.
  */
 
-static void __init MP_processor_info (struct mpc_config_processor *m)
+static void __init MP_processor_info(struct mpc_config_processor *m)
 {
 	int ver, logical_apicid;
 	physid_mask_t apic_cpus;
@@ -232,7 +232,7 @@ static void __init MP_processor_info (st
 	apic_version[m->mpc_apicid] = ver;
 }
 
-int __init visws_find_smp_config_quirk(unsigned int reserve)
+static int __init visws_find_smp_config(unsigned int reserve)
 {
 	struct mpc_config_processor *mp = phys_to_virt(CO_CPU_TAB_PHYS);
 	unsigned short ncpus = readw(phys_to_virt(CO_CPU_NUM_PHYS));
@@ -258,7 +258,17 @@ int __init visws_find_smp_config_quirk(u
 	return 1;
 }
 
-extern int visws_trap_init_quirk(void);
+static int visws_trap_init(void);
+
+static struct x86_ops visws_x86_ops __initdata = {
+	.arch_time_init		= visws_time_init,
+	.arch_pre_intr_init	= visws_pre_intr_init,
+	.arch_memory_setup	= visws_memory_setup,
+	.arch_intr_init		= NULL,
+	.arch_trap_init		= visws_trap_init,
+	.mach_get_smp_config	= visws_get_smp_config,
+	.mach_find_smp_config	= visws_find_smp_config,
+};
 
 void __init visws_early_detect(void)
 {
@@ -272,16 +282,10 @@ void __init visws_early_detect(void)
 
 	/*
 	 * Install special quirks for timer, interrupt and memory setup:
-	 */
-	arch_time_init_quirk		= visws_time_init_quirk;
-	arch_pre_intr_init_quirk	= visws_pre_intr_init_quirk;
-	arch_memory_setup_quirk		= visws_memory_setup_quirk;
-
-	/*
 	 * Fall back to generic behavior for traps:
+	 * Override generic MP-table parsing:
 	 */
-	arch_intr_init_quirk		= NULL;
-	arch_trap_init_quirk		= visws_trap_init_quirk;
+	x86_ops = &visws_x86_ops;
 
 	/*
 	 * Install reboot quirks:
@@ -294,12 +298,6 @@ void __init visws_early_detect(void)
 	 */
 	no_broadcast = 0;
 
-	/*
-	 * Override generic MP-table parsing:
-	 */
-	mach_get_smp_config_quirk	= visws_get_smp_config_quirk;
-	mach_find_smp_config_quirk	= visws_find_smp_config_quirk;
-
 #ifdef CONFIG_X86_IO_APIC
 	/*
 	 * Turn off IO-APIC detection and initialization:
@@ -426,7 +424,7 @@ static __init void cobalt_init(void)
 		co_apic_read(CO_APIC_ID));
 }
 
-int __init visws_trap_init_quirk(void)
+static int __init visws_trap_init(void)
 {
 	lithium_init();
 	cobalt_init();
Index: linux-2.6/arch/x86/mach-default/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-default/setup.c
+++ linux-2.6/arch/x86/mach-default/setup.c
@@ -10,14 +10,6 @@
 #include <asm/e820.h>
 #include <asm/setup.h>
 
-/*
- * Any quirks to be performed to initialize timers/irqs/etc?
- */
-int (*arch_time_init_quirk)(void);
-int (*arch_pre_intr_init_quirk)(void);
-int (*arch_intr_init_quirk)(void);
-int (*arch_trap_init_quirk)(void);
-
 #ifdef CONFIG_HOTPLUG_CPU
 #define DEFAULT_SEND_IPI	(1)
 #else
@@ -37,8 +29,8 @@ int no_broadcast=DEFAULT_SEND_IPI;
  **/
 void __init pre_intr_init_hook(void)
 {
-	if (arch_pre_intr_init_quirk) {
-		if (arch_pre_intr_init_quirk())
+	if (x86_ops->arch_pre_intr_init) {
+		if (x86_ops->arch_pre_intr_init())
 			return;
 	}
 	init_ISA_irqs();
@@ -64,8 +56,8 @@ static struct irqaction irq2 = {
  **/
 void __init intr_init_hook(void)
 {
-	if (arch_intr_init_quirk) {
-		if (arch_intr_init_quirk())
+	if (x86_ops->arch_intr_init) {
+		if (x86_ops->arch_intr_init())
 			return;
 	}
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -97,8 +89,8 @@ void __init pre_setup_arch_hook(void)
  **/
 void __init trap_init_hook(void)
 {
-	if (arch_trap_init_quirk) {
-		if (arch_trap_init_quirk())
+	if (x86_ops->arch_trap_init) {
+		if (x86_ops->arch_trap_init())
 			return;
 	}
 }
@@ -119,13 +111,13 @@ static struct irqaction irq0  = {
  **/
 void __init time_init_hook(void)
 {
-	if (arch_time_init_quirk) {
+	if (x86_ops->arch_time_init) {
 		/*
 		 * A nonzero return code does not mean failure, it means
 		 * that the architecture quirk does not want any
 		 * generic (timer) setup to be performed after this:
 		 */
-		if (arch_time_init_quirk())
+		if (x86_ops->arch_time_init())
 			return;
 	}
 
Index: linux-2.6/include/asm-x86/setup.h
===================================================================
--- linux-2.6.orig/include/asm-x86/setup.h
+++ linux-2.6/include/asm-x86/setup.h
@@ -19,13 +19,17 @@ static inline int is_visws_box(void) { r
 /*
  * Any setup quirks to be performed?
  */
-extern int (*arch_time_init_quirk)(void);
-extern int (*arch_pre_intr_init_quirk)(void);
-extern int (*arch_intr_init_quirk)(void);
-extern int (*arch_trap_init_quirk)(void);
-extern char * (*arch_memory_setup_quirk)(void);
-extern int (*mach_get_smp_config_quirk)(unsigned int early);
-extern int (*mach_find_smp_config_quirk)(unsigned int reserve);
+struct x86_ops {
+	int (*arch_time_init)(void);
+	int (*arch_pre_intr_init)(void);
+	int (*arch_intr_init)(void);
+	int (*arch_trap_init)(void);
+	char * (*arch_memory_setup)(void);
+	int (*mach_get_smp_config)(unsigned int early);
+	int (*mach_find_smp_config)(unsigned int reserve);
+};
+
+extern struct x86_ops *x86_ops;
 
 #ifndef CONFIG_PARAVIRT
 #define paravirt_post_allocator_init()	do {} while (0)
