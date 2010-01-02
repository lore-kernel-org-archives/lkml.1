Return-Path: <linux-kernel-owner+w=401wt.eu-S1752346Ab0ABV5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab0ABV5L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 16:57:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685Ab0ABV5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 16:57:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49478 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab0ABV5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 16:57:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI: Clean up build for CONFIG_PCI_QUIRKS unset
Date: Sat, 2 Jan 2010 22:57:24 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001022257.24701.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Currently, drivers/pci/quirks.c is built unconditionally, but if
CONFIG_PCI_QUIRKS is unset, the only things actually built in this
file are definitions of global variables and empty functions (due to
the #ifdef CONFIG_PCI_QUIRKS embracing all of the code inside the
file).  This is not particularly nice and if someone overlooks
the #ifdef CONFIG_PCI_QUIRKS, build errors are introduced.

To clean that up, move the definitions of the global variables in
quirks.c that are always built to pci.c, move the definitions of
the empty functions (compiled when CONFIG_PCI_QUIRKS is unset) to
headers (additionally make these functions static inline) and modify
drivers/pci/Makefile so that quirks.c is only built if
CONFIG_PCI_QUIRKS is set.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

I thought it might be useful to do something like this.

Please let me know what you think.

Rafael

---
 drivers/pci/Makefile |    4 +++-
 drivers/pci/pci.c    |    7 ++++++-
 drivers/pci/pci.h    |    7 +++++++
 drivers/pci/quirks.c |   14 ++------------
 include/linux/pci.h  |    6 +++++-
 5 files changed, 23 insertions(+), 15 deletions(-)

Index: linux-2.6/drivers/pci/Makefile
===================================================================
--- linux-2.6.orig/drivers/pci/Makefile
+++ linux-2.6/drivers/pci/Makefile
@@ -2,12 +2,14 @@
 # Makefile for the PCI bus specific drivers.
 #
 
-obj-y		+= access.o bus.o probe.o remove.o pci.o quirks.o \
+obj-y		+= access.o bus.o probe.o remove.o pci.o \
 			pci-driver.o search.o pci-sysfs.o rom.o setup-res.o \
 			irq.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_SYSFS) += slot.o
 
+obj-$(CONFIG_PCI_QUIRKS) += quirks.o
+
 obj-$(CONFIG_PCI_LEGACY) += legacy.o
 CFLAGS_legacy.o += -Wno-deprecated-declarations
 
Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -19,7 +19,6 @@
 #include <linux/pci-aspm.h>
 #include <linux/pm_wakeup.h>
 #include <linux/interrupt.h>
-#include <asm/dma.h>	/* isa_dma_bridge_buggy */
 #include <linux/device.h>
 #include <linux/pm_runtime.h>
 #include <asm/setup.h>
@@ -30,6 +29,12 @@ const char *pci_power_names[] = {
 };
 EXPORT_SYMBOL_GPL(pci_power_names);
 
+int isa_dma_bridge_buggy;
+EXPORT_SYMBOL(isa_dma_bridge_buggy);
+
+int pci_pci_problems;
+EXPORT_SYMBOL(pci_pci_problems);
+
 unsigned int pci_pm_d3_delay;
 
 static void pci_dev_d3_sleep(struct pci_dev *dev)
Index: linux-2.6/drivers/pci/quirks.c
===================================================================
--- linux-2.6.orig/drivers/pci/quirks.c
+++ linux-2.6/drivers/pci/quirks.c
@@ -25,14 +25,9 @@
 #include <linux/dmi.h>
 #include <linux/pci-aspm.h>
 #include <linux/ioport.h>
+#include <asm/dma.h>	/* isa_dma_bridge_buggy */
 #include "pci.h"
 
-int isa_dma_bridge_buggy;
-EXPORT_SYMBOL(isa_dma_bridge_buggy);
-int pci_pci_problems;
-EXPORT_SYMBOL(pci_pci_problems);
-
-#ifdef CONFIG_PCI_QUIRKS
 /*
  * This quirk function disables memory decoding and releases memory resources
  * of the device specified by kernel's boot parameter 'pci=resource_alignment='.
@@ -2595,6 +2590,7 @@ void pci_fixup_device(enum pci_fixup_pas
 	}
 	pci_do_fixups(dev, start, end);
 }
+EXPORT_SYMBOL(pci_fixup_device);
 
 static int __init pci_apply_final_quirks(void)
 {
@@ -2706,9 +2702,3 @@ int pci_dev_specific_reset(struct pci_de
 
 	return -ENOTTY;
 }
-
-#else
-void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev) {}
-int pci_dev_specific_reset(struct pci_dev *dev, int probe) { return -ENOTTY; }
-#endif
-EXPORT_SYMBOL(pci_fixup_device);
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -1246,8 +1246,12 @@ enum pci_fixup_pass {
 	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_suspend,			\
 			suspend##vendor##device##hook, vendor, device, hook)
 
-
+#ifdef CONFIG_PCI_QUIRKS
 void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev);
+#else
+static inline void pci_fixup_device(enum pci_fixup_pass pass,
+				    struct pci_dev *dev) {}
+#endif
 
 void __iomem *pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen);
 void pcim_iounmap(struct pci_dev *pdev, void __iomem *addr);
Index: linux-2.6/drivers/pci/pci.h
===================================================================
--- linux-2.6.orig/drivers/pci/pci.h
+++ linux-2.6/drivers/pci/pci.h
@@ -328,6 +328,13 @@ struct pci_dev_reset_methods {
 	int (*reset)(struct pci_dev *dev, int probe);
 };
 
+#ifdef CONFIG_PCI_QUIRKS
 extern int pci_dev_specific_reset(struct pci_dev *dev, int probe);
+#else
+static inline int pci_dev_specific_reset(struct pci_dev *dev, int probe)
+{
+	return -ENOTTY;
+}
+#endif
 
 #endif /* DRIVERS_PCI_H */
