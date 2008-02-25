Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbYBYF17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbYBYF17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 00:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbYBYF1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 00:27:50 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57045 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbYBYF1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 00:27:49 -0500
Date: Sun, 24 Feb 2008 21:36:28 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: for apic_is_clustered_box for vsmp v2
In-reply-to: <200802241832.37850.yinghai.lu@sun.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kiran@scalemp.com, shai@scalemp.com
Message-id: <200802242136.28744.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802210258.45011.yinghai.lu@sun.com>
 <200802241500.52860.yinghai.lu@sun.com> <200802241832.37850.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


quad core 8 socket system will have apic id lifting.the apic id range could
be [4, 0x23]. and apic_is_clustered_box will think that need to three clusters
and that is large than 2. So it is treated as clustered_box.

and will get

Marking TSC unstable due to TSCs unsynchronized

even the CPUs have X86_FEATURE_CONSTANT_TSC set.

quick fixwill check if the cpu is from AMD.

but vsmp still need that checking...

this patch is fix to make sure that vsmp not to be passed.

and need to be applied after
	x86_64: make amd quad core 8 socket system not be clustered_box v2
in x86/testing

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic_64.c
+++ linux-2.6/arch/x86/kernel/apic_64.c
@@ -1206,9 +1206,9 @@ __cpuinit int apic_is_clustered_box(void
 	 * there is not this kind of box with AMD CPU yet.
 	 * Some AMD box with quadcore cpu and 8 sockets apicid
 	 * will be [4, 0x23] or [8, 0x27] could be thought to
-	 * have three apic_clusters. So go out early.
+	 * vsmp box still need checking...
 	 */
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+	if (!is_vsmp_box() && (boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
 		return 0;
 
 	bios_cpu_apicid = x86_bios_cpu_apicid_early_ptr;
Index: linux-2.6/arch/x86/kernel/vsmp_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vsmp_64.c
+++ linux-2.6/arch/x86/kernel/vsmp_64.c
@@ -72,19 +72,34 @@ static unsigned __init vsmp_patch(u8 typ
 
 }
 
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
+	if (read_pci_config(0, 0x1f, 0, PCI_VENDOR_ID) ==
+	     (PCI_VENDOR_ID_SCALEMP || (PCI_DEVICE_ID_SCALEMP_VSMP_CTL << 16)))
+		vsmp = 1;
+
+	return vsmp;
+}
+
 void __init vsmp_init(void)
 {
 	void *address;
 	unsigned int cap, ctl, cfg;
 
-	if (!early_pci_allowed())
+	if (!is_vsmp_box())
 		return;
 
-	/* Check if we are running on a ScaleMP vSMP box */
-	if ((read_pci_config_16(0, 0x1f, 0, PCI_VENDOR_ID) !=
-	     PCI_VENDOR_ID_SCALEMP) ||
-	    (read_pci_config_16(0, 0x1f, 0, PCI_DEVICE_ID) !=
-	     PCI_DEVICE_ID_SCALEMP_VSMP_CTL))
+	if (!early_pci_allowed())
 		return;
 
 	/* If we are, use the distinguished irq functions */
Index: linux-2.6/include/asm-x86/apic.h
===================================================================
--- linux-2.6.orig/include/asm-x86/apic.h
+++ linux-2.6/include/asm-x86/apic.h
@@ -51,12 +51,17 @@ extern unsigned boot_cpu_id;
  */
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
+extern int is_vsmp_box(void);
 #else
 #define apic_write native_apic_write
 #define apic_write_atomic native_apic_write_atomic
 #define apic_read native_apic_read
 #define setup_boot_clock setup_boot_APIC_clock
 #define setup_secondary_clock setup_secondary_APIC_clock
+static int inline is_vsmp_box(void)
+{
+	return 0;
+}
 #endif
 
 static inline void native_apic_write(unsigned long reg, u32 v)
