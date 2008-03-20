Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbYCTHmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbYCTHmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 03:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbYCTHmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 03:42:07 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:47813 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbYCTHmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 03:42:06 -0400
Date: Thu, 20 Mar 2008 00:41:16 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>, Andi Kleen <ak@suse.de>,
       shai@scalex86.org
Subject: [patch 2/4] x86: Fix build breakage when PCI is define and PARAVIRT is not
Message-ID: <20080320074116.GC9414@localdomain>
References: <20080320073740.GA9414@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320073740.GA9414@localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Fix the the build breakage when PARAVIRT is defined
  but PCI is not
  This fixes problem reported at:
	http://marc.info/?l=linux-kernel&m=120525966600698&w=2
- Make is_vsmp_box() available even when PARAVIRT is not defined.
  This is needed to determine if tsc's are reliable as a time source
  even when PARAVIRT is not defined.
- split vsmp_init to use is_vsmp_box() and set_vsmp_pv_ops()
  set_vsmp_pv_ops will do nothing if PCI is not enabled in the config.

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>

Index: linux.git.trees/arch/x86/kernel/Makefile
===================================================================
--- linux.git.trees.orig/arch/x86/kernel/Makefile	2008-03-19 13:39:29.000000000 -0700
+++ linux.git.trees/arch/x86/kernel/Makefile	2008-03-19 13:46:14.400935607 -0700
@@ -60,7 +60,7 @@ obj-$(CONFIG_KEXEC)		+= relocate_kernel_
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 obj-$(CONFIG_X86_SUMMIT_NUMA)	+= summit_32.o
-obj-$(CONFIG_PARAVIRT)		+= vsmp_64.o
+obj-y				+= vsmp_64.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_MODULES)		+= module_$(BITS).o
 obj-$(CONFIG_ACPI_SRAT) 	+= srat_32.o
Index: linux.git.trees/arch/x86/kernel/setup_64.c
===================================================================
--- linux.git.trees.orig/arch/x86/kernel/setup_64.c	2008-03-19 13:39:29.000000000 -0700
+++ linux.git.trees/arch/x86/kernel/setup_64.c	2008-03-19 13:57:43.951337318 -0700
@@ -353,9 +353,7 @@ void __init setup_arch(char **cmdline_p)
 	if (efi_enabled)
 		efi_init();
 
-#ifdef	CONFIG_PARAVIRT
 	vsmp_init();
-#endif
 
 	dmi_scan_machine();
 
Index: linux.git.trees/arch/x86/kernel/vsmp_64.c
===================================================================
--- linux.git.trees.orig/arch/x86/kernel/vsmp_64.c	2008-03-19 13:39:50.000000000 -0700
+++ linux.git.trees/arch/x86/kernel/vsmp_64.c	2008-03-19 20:53:34.267707163 -0700
@@ -19,6 +19,7 @@
 #include <asm/io.h>
 #include <asm/paravirt.h>
 
+#if defined CONFIG_PCI && defined CONFIG_PARAVIRT
 /*
  * Interrupt control on vSMPowered systems:
  * ~AC is a shadow of IF.  If IF is 'on' AC should be 'off'
@@ -72,39 +73,11 @@ static unsigned __init vsmp_patch(u8 typ
 
 }
 
-static int vsmp = -1;
-
-int is_vsmp_box(void)
-{
-	if (vsmp != -1)
-		return vsmp;
-
-	vsmp = 0;
-	if (!early_pci_allowed())
-		return vsmp;
-
-	/* Check if we are running on a ScaleMP vSMP box */
-	if ((read_pci_config_16(0, 0x1f, 0, PCI_VENDOR_ID) ==
-	     PCI_VENDOR_ID_SCALEMP) &&
-	    (read_pci_config_16(0, 0x1f, 0, PCI_DEVICE_ID) ==
-	    PCI_DEVICE_ID_SCALEMP_VSMP_CTL))
-		vsmp = 1;
-
-	return vsmp;
-}
-
-void __init vsmp_init(void)
+static void __init set_vsmp_pv_ops(void)
 {
 	void *address;
 	unsigned int cap, ctl, cfg;
 
-	if (!is_vsmp_box())
-		return;
-
-	if (!early_pci_allowed())
-		return;
-
-	/* If we are, use the distinguished irq functions */
 	pv_irq_ops.irq_disable = vsmp_irq_disable;
 	pv_irq_ops.irq_enable  = vsmp_irq_enable;
 	pv_irq_ops.save_fl  = vsmp_save_fl;
@@ -127,5 +100,46 @@ void __init vsmp_init(void)
 	}
 
 	early_iounmap(address, 8);
+}
+#else
+static void __init set_vsmp_pv_ops(void)
+{
+}
+#endif
+
+#ifdef CONFIG_PCI
+static int vsmp = -1;
+
+int is_vsmp_box(void)
+{
+	if (vsmp != -1)
+		return vsmp;
+
+	vsmp = 0;
+	if (!early_pci_allowed())
+		return vsmp;
+
+	/* Check if we are running on a ScaleMP vSMP box */
+	if ((read_pci_config_16(0, 0x1f, 0, PCI_VENDOR_ID) ==
+	     PCI_VENDOR_ID_SCALEMP) &&
+	    (read_pci_config_16(0, 0x1f, 0, PCI_DEVICE_ID) ==
+	    PCI_DEVICE_ID_SCALEMP_VSMP_CTL))
+		vsmp = 1;
+
+	return vsmp;
+}
+#else
+int is_vsmp_box(void)
+{
+	return 0;
+}
+#endif
+
+void __init vsmp_init(void)
+{
+	if (!is_vsmp_box())
+		return;
+
+	set_vsmp_pv_ops();
 	return;
 }
Index: linux.git.trees/include/asm-x86/apic.h
===================================================================
--- linux.git.trees.orig/include/asm-x86/apic.h	2008-03-19 13:39:29.000000000 -0700
+++ linux.git.trees/include/asm-x86/apic.h	2008-03-19 13:57:14.550893819 -0700
@@ -51,19 +51,16 @@ extern unsigned boot_cpu_id;
  */
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
-extern int is_vsmp_box(void);
 #else
 #define apic_write native_apic_write
 #define apic_write_atomic native_apic_write_atomic
 #define apic_read native_apic_read
 #define setup_boot_clock setup_boot_APIC_clock
 #define setup_secondary_clock setup_secondary_APIC_clock
-static int inline is_vsmp_box(void)
-{
-	return 0;
-}
 #endif
 
+extern int is_vsmp_box(void);
+
 static inline void native_apic_write(unsigned long reg, u32 v)
 {
 	*((volatile u32 *)(APIC_BASE + reg)) = v;
