Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbYHSJBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbYHSJBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYHSJBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:01:45 -0400
Received: from mail.free-electrons.com ([88.191.46.45]:37118 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbYHSJBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:01:43 -0400
Date: Tue, 19 Aug 2008 10:28:24 +0200
To: jbarnes@virtuousgeek.org
Cc: thomas.petazzoni@free-electrons.com, michael@free-electrons.com,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PCI] Configure out PCI quirks
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1KVMZk-0004qG-W9@surf>
From: Thomas Petazzoni <thomas.petazzoni@enix.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PCI] Configure out PCI quirks

This patch adds the CONFIG_PCI_QUIRKS option which allows to remove
all the PCI quirks, not necessarly used on embedded systems when PCI
is working properly. As this is a size-reduction option, it depends on
CONFIG_EMBEDDED. It allows to save almost 12 kilobytes of kernel code:

   text	   data	    bss	    dec	    hex	filename
1287806	 123596	 212992	1624394	 18c94a	vmlinux.old
1275854	 123596	 212992	1612442	 189a9a	vmlinux
 -11952       0       0  -11952   -2EB0 +/-

This patch has originally been written by Zwane Mwaikambo
<zwane@arm.linux.org.uk> and is part of the Linux Tiny project.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

---
 drivers/pci/quirks.c |  177 +++++++++++++++++++++++++--------------------------
 init/Kconfig         |    8 ++
 2 files changed, 98 insertions(+), 87 deletions(-)

Index: linuxdev/drivers/pci/quirks.c
===================================================================
--- linuxdev.orig/drivers/pci/quirks.c
+++ linuxdev/drivers/pci/quirks.c
@@ -24,6 +24,14 @@
 #include <linux/kallsyms.h>
 #include "pci.h"
 
+int isa_dma_bridge_buggy;
+EXPORT_SYMBOL(isa_dma_bridge_buggy);
+int pci_pci_problems;
+EXPORT_SYMBOL(pci_pci_problems);
+int pcie_mch_quirk;
+EXPORT_SYMBOL(pcie_mch_quirk);
+
+#ifdef CONFIG_PCI_QUIRKS
 /* The Mellanox Tavor device gives false positive parity errors
  * Mark this device with a broken_parity_status, to allow
  * PCI scanning code to "skip" this now blacklisted device.
@@ -62,8 +70,6 @@
     
     This appears to be BIOS not version dependent. So presumably there is a 
     chipset level fix */
-int isa_dma_bridge_buggy;
-EXPORT_SYMBOL(isa_dma_bridge_buggy);
     
 static void __devinit quirk_isa_dma_hangs(struct pci_dev *dev)
 {
@@ -84,9 +90,6 @@
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NEC,	PCI_DEVICE_ID_NEC_CBUS_2,	quirk_isa_dma_hangs);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NEC,	PCI_DEVICE_ID_NEC_CBUS_3,	quirk_isa_dma_hangs);
 
-int pci_pci_problems;
-EXPORT_SYMBOL(pci_pci_problems);
-
 /*
  *	Chipsets where PCI->PCI transfers vanish or hang
  */
@@ -1362,9 +1365,6 @@
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_EESSC,	quirk_alder_ioapic);
 #endif
 
-int pcie_mch_quirk;
-EXPORT_SYMBOL(pcie_mch_quirk);
-
 static void __devinit quirk_pcie_mch(struct pci_dev *pdev)
 {
 	pcie_mch_quirk = 1;
@@ -1555,85 +1555,6 @@
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NCR, PCI_DEVICE_ID_NCR_53C810, fixup_rev1_53c810);
 
-static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f, struct pci_fixup *end)
-{
-	while (f < end) {
-		if ((f->vendor == dev->vendor || f->vendor == (u16) PCI_ANY_ID) &&
- 		    (f->device == dev->device || f->device == (u16) PCI_ANY_ID)) {
-#ifdef DEBUG
-			dev_dbg(&dev->dev, "calling ");
-			print_fn_descriptor_symbol("%s\n", f->hook);
-#endif
-			f->hook(dev);
-		}
-		f++;
-	}
-}
-
-extern struct pci_fixup __start_pci_fixups_early[];
-extern struct pci_fixup __end_pci_fixups_early[];
-extern struct pci_fixup __start_pci_fixups_header[];
-extern struct pci_fixup __end_pci_fixups_header[];
-extern struct pci_fixup __start_pci_fixups_final[];
-extern struct pci_fixup __end_pci_fixups_final[];
-extern struct pci_fixup __start_pci_fixups_enable[];
-extern struct pci_fixup __end_pci_fixups_enable[];
-extern struct pci_fixup __start_pci_fixups_resume[];
-extern struct pci_fixup __end_pci_fixups_resume[];
-extern struct pci_fixup __start_pci_fixups_resume_early[];
-extern struct pci_fixup __end_pci_fixups_resume_early[];
-extern struct pci_fixup __start_pci_fixups_suspend[];
-extern struct pci_fixup __end_pci_fixups_suspend[];
-
-
-void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev)
-{
-	struct pci_fixup *start, *end;
-
-	switch(pass) {
-	case pci_fixup_early:
-		start = __start_pci_fixups_early;
-		end = __end_pci_fixups_early;
-		break;
-
-	case pci_fixup_header:
-		start = __start_pci_fixups_header;
-		end = __end_pci_fixups_header;
-		break;
-
-	case pci_fixup_final:
-		start = __start_pci_fixups_final;
-		end = __end_pci_fixups_final;
-		break;
-
-	case pci_fixup_enable:
-		start = __start_pci_fixups_enable;
-		end = __end_pci_fixups_enable;
-		break;
-
-	case pci_fixup_resume:
-		start = __start_pci_fixups_resume;
-		end = __end_pci_fixups_resume;
-		break;
-
-	case pci_fixup_resume_early:
-		start = __start_pci_fixups_resume_early;
-		end = __end_pci_fixups_resume_early;
-		break;
-
-	case pci_fixup_suspend:
-		start = __start_pci_fixups_suspend;
-		end = __end_pci_fixups_suspend;
-		break;
-
-	default:
-		/* stupid compiler warning, you would think with an enum... */
-		return;
-	}
-	pci_do_fixups(dev, start, end);
-}
-EXPORT_SYMBOL(pci_fixup_device);
-
 /* Enable 1k I/O space granularity on the Intel P64H2 */
 static void __devinit quirk_p64h2_1k_io(struct pci_dev *dev)
 {
@@ -2007,3 +1928,85 @@
 			quirk_msi_intx_disable_bug);
 
 #endif /* CONFIG_PCI_MSI */
+
+static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f, struct pci_fixup *end)
+{
+	while (f < end) {
+		if ((f->vendor == dev->vendor || f->vendor == (u16) PCI_ANY_ID) &&
+ 		    (f->device == dev->device || f->device == (u16) PCI_ANY_ID)) {
+#ifdef DEBUG
+			dev_dbg(&dev->dev, "calling ");
+			print_fn_descriptor_symbol("%s\n", f->hook);
+#endif
+			f->hook(dev);
+		}
+		f++;
+	}
+}
+
+extern struct pci_fixup __start_pci_fixups_early[];
+extern struct pci_fixup __end_pci_fixups_early[];
+extern struct pci_fixup __start_pci_fixups_header[];
+extern struct pci_fixup __end_pci_fixups_header[];
+extern struct pci_fixup __start_pci_fixups_final[];
+extern struct pci_fixup __end_pci_fixups_final[];
+extern struct pci_fixup __start_pci_fixups_enable[];
+extern struct pci_fixup __end_pci_fixups_enable[];
+extern struct pci_fixup __start_pci_fixups_resume[];
+extern struct pci_fixup __end_pci_fixups_resume[];
+extern struct pci_fixup __start_pci_fixups_resume_early[];
+extern struct pci_fixup __end_pci_fixups_resume_early[];
+extern struct pci_fixup __start_pci_fixups_suspend[];
+extern struct pci_fixup __end_pci_fixups_suspend[];
+
+
+void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev)
+{
+	struct pci_fixup *start, *end;
+
+	switch(pass) {
+	case pci_fixup_early:
+		start = __start_pci_fixups_early;
+		end = __end_pci_fixups_early;
+		break;
+
+	case pci_fixup_header:
+		start = __start_pci_fixups_header;
+		end = __end_pci_fixups_header;
+		break;
+
+	case pci_fixup_final:
+		start = __start_pci_fixups_final;
+		end = __end_pci_fixups_final;
+		break;
+
+	case pci_fixup_enable:
+		start = __start_pci_fixups_enable;
+		end = __end_pci_fixups_enable;
+		break;
+
+	case pci_fixup_resume:
+		start = __start_pci_fixups_resume;
+		end = __end_pci_fixups_resume;
+		break;
+
+	case pci_fixup_resume_early:
+		start = __start_pci_fixups_resume_early;
+		end = __end_pci_fixups_resume_early;
+		break;
+
+	case pci_fixup_suspend:
+		start = __start_pci_fixups_suspend;
+		end = __end_pci_fixups_suspend;
+		break;
+
+	default:
+		/* stupid compiler warning, you would think with an enum... */
+		return;
+	}
+	pci_do_fixups(dev, start, end);
+}
+#else
+void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev) {}
+#endif
+EXPORT_SYMBOL(pci_fixup_device);
Index: linuxdev/init/Kconfig
===================================================================
--- linuxdev.orig/init/Kconfig
+++ linuxdev/init/Kconfig
@@ -733,6 +733,14 @@
 	  on EMBEDDED systems.  /proc/vmstat will only show page counts
 	  if VM event counters are disabled.
 
+config PCI_QUIRKS
+	default y
+	bool "Enable PCI quirk workarounds" if EMBEDDED && PCI
+	help
+	  This enables workarounds for various PCI chipset
+          bugs/quirks. Disable this only if your target machine is
+          unaffected by PCI quirks.
+
 config SLUB_DEBUG
 	default y
 	bool "Enable SLUB debugging support" if EMBEDDED
