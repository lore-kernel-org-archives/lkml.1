Return-Path: <linux-kernel-owner+w=401wt.eu-S1758945AbYEBDEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945AbYEBDEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 23:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbYEBDEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 23:04:32 -0400
Received: from ausxipps301.us.dell.com ([143.166.148.223]:21218 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYEBDEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 23:04:31 -0400
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 May 2008 23:04:31 EDT
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns;
  h=X-IronPort-AV:Date:From:To:Cc:Subject:Message-ID:
   Mime-Version:Content-Type:Content-Disposition:User-Agent;
  b=hl+8pIyQwgOF9n2RfWr4ETMOhvNn0L+HuFDRpJSL7BpGFJMvPTwvlUEv
   MVcrG6fey3jfWDvCLR36FS8OdEyeaqBiauVU2JXSSh4S4OvGXww3UISHG
   0jOuOHd2nVnRS5M;
X-IronPort-AV: E=Sophos;i="4.27,424,1204524000"; 
   d="scan'208";a="34675159"
Date: Thu, 1 May 2008 21:54:27 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: akpm@linux-foundation.org
Cc: jgarzik@pobox.com, muli@il.ibm.com, davej@redhat.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, bunk@kernel.org, linux-bugs@dell.com,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: [PATCH] fix x86 DMI checks for PCI quirks
Message-ID: <20080502025427.GA23757@auslistsprd01.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix x86 DMI checks for PCI quirks

http://bugzilla.kernel.org/show_bug.cgi?id=10583
https://bugzilla.redhat.com/show_bug.cgi?id=444791

Since git commit 08f1c192c3c32797068bfe97738babb3295bbf42 (between
kernels 2.6.22 and 2.6.23), arch/x86/pci/acpi.c has not called
pcibios_scan_root(), which would have called
arch/x86/pci/common.c:dmi_check_system().  This has prevented the
quirks listed in pciprobe_dmi_table[] from being checked and
appropriate action taken.

This manifests itself in several Dell and HP servers not automatically
having the pci=bfsort option be applied, as well as Samsung X20 and
Compaq EVO N800c systems needing pci=assign-all-busses was no longer
automatically applied.

This patch moves the DMI tests into its own file, arch/x86/pci/dmi.c,
and invokes them via subsys_initcall() before pci_acpi_init(),
pci_legacy_init(), and pcibios_init() are called, which may rely upon
these tests having been executed.

Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>
---
 arch/x86/pci/Makefile_32 |    1 +
 arch/x86/pci/Makefile_64 |    1 +
 arch/x86/pci/common.c    |  219 +--------------------------------------------
 arch/x86/pci/dmi.c       |  228 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/pci/pci.h       |    1 +
 5 files changed, 232 insertions(+), 218 deletions(-)
 create mode 100644 arch/x86/pci/dmi.c

diff --git a/arch/x86/pci/Makefile_32 b/arch/x86/pci/Makefile_32
index cdd6828..d5232ee 100644
--- a/arch/x86/pci/Makefile_32
+++ b/arch/x86/pci/Makefile_32
@@ -5,6 +5,7 @@ obj-$(CONFIG_PCI_MMCONFIG)	+= mmconfig_32.o direct.o mmconfig-shared.o
 obj-$(CONFIG_PCI_DIRECT)	+= direct.o
 
 pci-y				:= fixup.o
+pci-y				+= dmi.o
 pci-$(CONFIG_ACPI)		+= acpi.o
 pci-y				+= legacy.o irq.o
 
diff --git a/arch/x86/pci/Makefile_64 b/arch/x86/pci/Makefile_64
index 7d8c467..654568f 100644
--- a/arch/x86/pci/Makefile_64
+++ b/arch/x86/pci/Makefile_64
@@ -8,6 +8,7 @@ EXTRA_CFLAGS += -Iarch/x86/pci
 obj-y		:= i386.o
 obj-$(CONFIG_PCI_DIRECT)+= direct.o
 obj-y		+= fixup.o init.o
+obj-y			+= dmi.o
 obj-$(CONFIG_ACPI)	+= acpi.o
 obj-y			+= legacy.o irq.o common.o early.o
 # mmconfig has a 64bit special
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 7b6e3bb..dfc4d6b 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -8,7 +8,6 @@
 #include <linux/pci.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
-#include <linux/dmi.h>
 
 #include <asm/acpi.h>
 #include <asm/segment.h>
@@ -19,8 +18,7 @@
 
 unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2 |
 				PCI_PROBE_MMCONF;
-
-static int pci_bf_sort;
+int pci_bf_sort;
 int pci_routeirq;
 int pcibios_last_bus = -1;
 unsigned long pirq_table_addr;
@@ -158,227 +156,12 @@ void __devinit  pcibios_fixup_bus(struct pci_bus *b)
 		pcibios_fixup_device_resources(dev);
 }
 
-/*
- * Only use DMI information to set this if nothing was passed
- * on the kernel command line (which was parsed earlier).
- */
-
-static int __devinit set_bf_sort(const struct dmi_system_id *d)
-{
-	if (pci_bf_sort == pci_bf_sort_default) {
-		pci_bf_sort = pci_dmi_bf;
-		printk(KERN_INFO "PCI: %s detected, enabling pci=bfsort.\n", d->ident);
-	}
-	return 0;
-}
-
-/*
- * Enable renumbering of PCI bus# ranges to reach all PCI busses (Cardbus)
- */
-#ifdef __i386__
-static int __devinit assign_all_busses(const struct dmi_system_id *d)
-{
-	pci_probe |= PCI_ASSIGN_ALL_BUSSES;
-	printk(KERN_INFO "%s detected: enabling PCI bus# renumbering"
-			" (pci=assign-busses)\n", d->ident);
-	return 0;
-}
-#endif
-
-static struct dmi_system_id __devinitdata pciprobe_dmi_table[] = {
-#ifdef __i386__
-/*
- * Laptops which need pci=assign-busses to see Cardbus cards
- */
-	{
-		.callback = assign_all_busses,
-		.ident = "Samsung X20 Laptop",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Samsung Electronics"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "SX20S"),
-		},
-	},
-#endif		/* __i386__ */
-	{
-		.callback = set_bf_sort,
-		.ident = "Dell PowerEdge 1950",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 1950"),
-		},
-	},
-	{
-		.callback = set_bf_sort,
-		.ident = "Dell PowerEdge 1955",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 1955"),
-		},
-	},
-	{
-		.callback = set_bf_sort,
-		.ident = "Dell PowerEdge 2900",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 2900"),
-		},
-	},
-	{
-		.callback = set_bf_sort,
-		.ident = "Dell PowerEdge 2950",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 2950"),
-		},
-	},
-	{
-		.callback = set_bf_sort,
-		.ident = "Dell PowerEdge R900",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R900"),
-		},
-	},
-	{
-		.callback = set_bf_sort,
-		.ident = "HP ProLiant BL20p G3",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL20p G3"),
-		},
-	},
-	{
-		.callback = set_bf_sort,
-		.ident = "HP ProLiant BL20p G4",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL20p G4"),
-		},
-	},
-	{
-		.callback = set_bf_sort,
-		.ident = "HP ProLiant BL30p G1",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL30p G1"),
-		},
-	},
-	{
-		.callback = set_bf_sort,
-		.ident = "HP ProLiant BL25p G1",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL25p G1"),
-		},
-	},
-	{
-		.callback = set_bf_sort,
-		.ident = "HP ProLiant BL35p G1",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL35p G1"),
-		},
-	},
-	{
-		.callback = set_bf_sort,
-		.ident = "HP ProLiant BL45p G1",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL45p G1"),
-		},
-	},
-	{
-		.callback = set_bf_sort,
-		.ident = "HP ProLiant BL45p G2",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL45p G2"),
-		},
-	},
-	{
-		.callback = set_bf_sort,
-		.ident = "HP ProLiant BL460c G1",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL460c G1"),
-		},
-	},
-	{
-		.callback = set_bf_sort,
-		.ident = "HP ProLiant BL465c G1",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL465c G1"),
-		},
-	},
-	{
-		.callback = set_bf_sort,
-		.ident = "HP ProLiant BL480c G1",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL480c G1"),
-		},
-	},
-	{
-		.callback = set_bf_sort,
-		.ident = "HP ProLiant BL685c G1",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL685c G1"),
-		},
-	},
-	{
-		.callback = set_bf_sort,
-		.ident = "HP ProLiant DL385 G2",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL385 G2"),
-		},
-	},
-	{
-		.callback = set_bf_sort,
-		.ident = "HP ProLiant DL585 G2",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL585 G2"),
-		},
-	},
-#ifdef __i386__
-	{
-		.callback = assign_all_busses,
-		.ident = "Compaq EVO N800c",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Compaq"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "EVO N800c"),
-		},
-	},
-#endif
-	{
-		.callback = set_bf_sort,
-		.ident = "HP ProLiant DL385 G2",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL385 G2"),
-		},
-	},
-	{
-		.callback = set_bf_sort,
-		.ident = "HP ProLiant DL585 G2",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL585 G2"),
-		},
-	},
-	{}
-};
 
 struct pci_bus * __devinit pcibios_scan_root(int busnum)
 {
 	struct pci_bus *bus = NULL;
 	struct pci_sysdata *sd;
 
-	dmi_check_system(pciprobe_dmi_table);
-
 	while ((bus = pci_find_next_bus(bus)) != NULL) {
 		if (bus->number == busnum) {
 			/* Already scanned */
diff --git a/arch/x86/pci/dmi.c b/arch/x86/pci/dmi.c
new file mode 100644
index 0000000..46ad227
--- /dev/null
+++ b/arch/x86/pci/dmi.c
@@ -0,0 +1,228 @@
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/dmi.h>
+#include "pci.h"
+
+/*
+ * Only use DMI information to set this if nothing was passed
+ * on the kernel command line (which was parsed earlier).
+ */
+
+static int __devinit set_bf_sort(const struct dmi_system_id *d)
+{
+	if (pci_bf_sort == pci_bf_sort_default) {
+		pci_bf_sort = pci_dmi_bf;
+		printk(KERN_INFO "PCI: %s detected, enabling pci=bfsort.\n", d->ident);
+	}
+	return 0;
+}
+
+/*
+ * Enable renumbering of PCI bus# ranges to reach all PCI busses (Cardbus)
+ */
+#ifdef __i386__
+static int __devinit assign_all_busses(const struct dmi_system_id *d)
+{
+	pci_probe |= PCI_ASSIGN_ALL_BUSSES;
+	printk(KERN_INFO "%s detected: enabling PCI bus# renumbering"
+			" (pci=assign-busses)\n", d->ident);
+	return 0;
+}
+#endif
+
+static struct dmi_system_id __devinitdata pciprobe_dmi_table[] = {
+#ifdef __i386__
+/*
+ * Laptops which need pci=assign-busses to see Cardbus cards
+ */
+	{
+		.callback = assign_all_busses,
+		.ident = "Samsung X20 Laptop",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Samsung Electronics"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "SX20S"),
+		},
+	},
+#endif		/* __i386__ */
+	{
+		.callback = set_bf_sort,
+		.ident = "Dell PowerEdge 1950",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 1950"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "Dell PowerEdge 1955",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 1955"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "Dell PowerEdge 2900",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 2900"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "Dell PowerEdge 2950",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 2950"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "Dell PowerEdge R900",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R900"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL20p G3",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL20p G3"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL20p G4",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL20p G4"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL30p G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL30p G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL25p G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL25p G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL35p G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL35p G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL45p G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL45p G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL45p G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL45p G2"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL460c G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL460c G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL465c G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL465c G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL480c G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL480c G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL685c G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL685c G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant DL385 G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL385 G2"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant DL585 G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL585 G2"),
+		},
+	},
+#ifdef __i386__
+	{
+		.callback = assign_all_busses,
+		.ident = "Compaq EVO N800c",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Compaq"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "EVO N800c"),
+		},
+	},
+#endif
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant DL385 G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL385 G2"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant DL585 G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL585 G2"),
+		},
+	},
+	{}
+};
+
+
+static int __init pciprobe_dmi_init(void)
+{
+	dmi_check_system(pciprobe_dmi_table);
+	return 0;
+}
+
+subsys_initcall(pciprobe_dmi_init);
+
diff --git a/arch/x86/pci/pci.h b/arch/x86/pci/pci.h
index 3431518..98fc872 100644
--- a/arch/x86/pci/pci.h
+++ b/arch/x86/pci/pci.h
@@ -31,6 +31,7 @@
 
 extern unsigned int pci_probe;
 extern unsigned long pirq_table_addr;
+extern int pci_bf_sort;
 
 enum pci_bf_sort_state {
 	pci_bf_sort_default,
-- 
1.5.2.4


-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
