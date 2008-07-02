Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbYGBVT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbYGBVT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757059AbYGBVSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:18:23 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:23166 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799AbYGBVSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:18:22 -0400
X-BigFish: VPS29(zz225amzz10d3izzz32i87il43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3EDU2-01-1X2-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 11/11] x86/pci: Removing subsys_initcall ordering dependencies
Date: Wed, 2 Jul 2008 22:50:29 +0200
Message-ID: <1215031829-29124-12-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
References: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 02 Jul 2008 21:17:56.0630 (UTC) FILETIME=[18E43B60:01C8DC89]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far subsys_initcalls has been executed in this order depending on
the object order in the Makefile:

arch/x86/pci/visws.c:subsys_initcall(pcibios_init);
arch/x86/pci/numa.c:subsys_initcall(pci_numa_init);
arch/x86/pci/acpi.c:subsys_initcall(pci_acpi_init);
arch/x86/pci/legacy.c:subsys_initcall(pci_legacy_init);
arch/x86/pci/irq.c:subsys_initcall(pcibios_irq_init);
arch/x86/pci/common.c:subsys_initcall(pcibios_init);

This patch removes the ordering dependency. There is now only one
subsys_initcall function that contains subsystem initialization code
with a defined order.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/pci/Makefile |    4 ----
 arch/x86/pci/acpi.c   |    3 +--
 arch/x86/pci/common.c |    4 +---
 arch/x86/pci/init.c   |    4 ++--
 arch/x86/pci/irq.c    |    5 +----
 arch/x86/pci/legacy.c |   11 ++++++++++-
 arch/x86/pci/numa.c   |    8 +++++++-
 arch/x86/pci/pci.h    |   11 ++++++++---
 arch/x86/pci/visws.c  |    7 ++++++-
 9 files changed, 36 insertions(+), 21 deletions(-)

diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index c92dc6f..a071be2 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -6,10 +6,6 @@ obj-$(CONFIG_PCI_DIRECT)	+= direct.o
 obj-$(CONFIG_PCI_OLPC)		+= olpc.o
 
 pci-y				:= fixup.o
-
-# Do not change the ordering here. There is a nasty init function
-# ordering dependency which breaks when you move acpi.o below
-# legacy/irq.o
 pci-$(CONFIG_ACPI)		+= acpi.o
 pci-y				+= legacy.o irq.o
 
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index d95de2f..2e85b4e 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -219,7 +219,7 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int do
 }
 
 extern int pci_routeirq;
-static int __init pci_acpi_init(void)
+int __init pci_acpi_init(void)
 {
 	struct pci_dev *dev = NULL;
 
@@ -253,4 +253,3 @@ static int __init pci_acpi_init(void)
 
 	return 0;
 }
-subsys_initcall(pci_acpi_init);
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 940185e..1d58bbe 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -384,7 +384,7 @@ struct pci_bus * __devinit pcibios_scan_root(int busnum)
 
 extern u8 pci_cache_line_size;
 
-static int __init pcibios_init(void)
+int __init pcibios_init(void)
 {
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 
@@ -411,8 +411,6 @@ static int __init pcibios_init(void)
 	return 0;
 }
 
-subsys_initcall(pcibios_init);
-
 char * __devinit  pcibios_setup(char *str)
 {
 	if (!strcmp(str, "off")) {
diff --git a/arch/x86/pci/init.c b/arch/x86/pci/init.c
index b821f44..d6c950f 100644
--- a/arch/x86/pci/init.c
+++ b/arch/x86/pci/init.c
@@ -4,7 +4,7 @@
 
 /* arch_initcall has too random ordering, so call the initializers
    in the right sequence from here. */
-static __init int pci_access_init(void)
+static __init int pci_arch_init(void)
 {
 #ifdef CONFIG_PCI_DIRECT
 	int type = 0;
@@ -40,4 +40,4 @@ static __init int pci_access_init(void)
 
 	return 0;
 }
-arch_initcall(pci_access_init);
+arch_initcall(pci_arch_init);
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index ca8df9c..4debf53 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -1118,7 +1118,7 @@ static struct dmi_system_id __initdata pciirq_dmi_table[] = {
 	{ }
 };
 
-static int __init pcibios_irq_init(void)
+int __init pcibios_irq_init(void)
 {
 	DBG(KERN_DEBUG "PCI: IRQ init\n");
 
@@ -1153,9 +1153,6 @@ static int __init pcibios_irq_init(void)
 	return 0;
 }
 
-subsys_initcall(pcibios_irq_init);
-
-
 static void pirq_penalize_isa_irq(int irq, int active)
 {
 	/*
diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index a67921c..3c1d795 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -55,4 +55,13 @@ static int __init pci_legacy_init(void)
 	return 0;
 }
 
-subsys_initcall(pci_legacy_init);
+int __init pci_subsys_init(void)
+{
+#ifdef CONFIG_ACPI
+	pci_acpi_init();
+#endif
+	pci_legacy_init();
+	pcibios_irq_init();
+	pcibios_init();
+}
+subsys_initcall(pci_subsys_init);
diff --git a/arch/x86/pci/numa.c b/arch/x86/pci/numa.c
index d9afbae..a50c2a5 100644
--- a/arch/x86/pci/numa.c
+++ b/arch/x86/pci/numa.c
@@ -198,4 +198,10 @@ static int __init pci_numa_init(void)
 	return 0;
 }
 
-subsys_initcall(pci_numa_init);
+static __init int pci_subsys_init(void)
+{
+	pci_numa_init();
+	pcibios_irq_init();
+	pcibios_init();
+}
+subsys_initcall(pci_subsys_init);
diff --git a/arch/x86/pci/pci.h b/arch/x86/pci/pci.h
index ba263e6..5824174 100644
--- a/arch/x86/pci/pci.h
+++ b/arch/x86/pci/pci.h
@@ -39,9 +39,6 @@ enum pci_bf_sort_state {
 	pci_dmi_bf,
 };
 
-extern void __init dmi_check_pciprobe(void);
-extern void __init dmi_check_skip_isa_align(void);
-
 /* pci-i386.c */
 
 extern unsigned int pcibios_max_latency;
@@ -99,10 +96,18 @@ extern struct pci_raw_ops *raw_pci_ext_ops;
 
 extern struct pci_raw_ops pci_direct_conf1;
 
+/* arch_initcall level */
 extern int pci_direct_probe(void);
 extern void pci_direct_init(int type);
 extern void pci_pcbios_init(void);
 extern int pci_olpc_init(void);
+extern void __init dmi_check_pciprobe(void);
+extern void __init dmi_check_skip_isa_align(void);
+
+/* some common used subsys_initcalls */
+extern int __init pci_acpi_init(void);
+extern int __init pcibios_irq_init(void);
+extern int __init pcibios_init(void);
 
 /* pci-mmconfig.c */
 
diff --git a/arch/x86/pci/visws.c b/arch/x86/pci/visws.c
index c3dc9f2..16e5206 100644
--- a/arch/x86/pci/visws.c
+++ b/arch/x86/pci/visws.c
@@ -105,4 +105,9 @@ static int __init pci_visws_init(void)
 	return 0;
 }
 
-subsys_initcall(pci_visws_init);
+static __init int pci_subsys_init(void)
+{
+	pci_visws_init();
+	pcibios_init();
+}
+subsys_initcall(pci_subsys_init);
-- 
1.5.5.4


