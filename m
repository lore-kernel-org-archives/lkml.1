Return-Path: <linux-kernel-owner+w=401wt.eu-S1752255AbZGXJlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbZGXJlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 05:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbZGXJlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 05:41:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46280 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbZGXJlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 05:41:19 -0400
Date: Fri, 24 Jul 2009 11:41:15 +0200
From: Andi Kleen <andi@firstfloor.org>
To: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Shut off pci_find_device warnings when the deprecated pci
	functions are enabled.
Message-ID: <20090724094115.GA18450@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shut off pci_find_device warnings when the deprecated pci functions are enabled.

Shut off the long standing

linux/drivers/pci/search.c:144: warning: 'pci_find_device' is deprecated (declared at linux/drivers/pci/search.c:136)
linux/drivers/pci/search.c:144: warning: 'pci_find_device' is deprecated (declared at linux/drivers/pci/search.c:136)

warnings that appear on every build when CONFIG_PCI_LEGACY is enabled.

gcc warns for the use in EXPORT_SYMBOL

I moved these to a separate file and disabled the warning in the Makefile for that file.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/pci/Makefile |    3 +++
 drivers/pci/legacy.c |   34 ++++++++++++++++++++++++++++++++++
 drivers/pci/search.c |   31 -------------------------------
 3 files changed, 37 insertions(+), 31 deletions(-)

Index: linux-2.6.31-rc3-ak/drivers/pci/Makefile
===================================================================
--- linux-2.6.31-rc3-ak.orig/drivers/pci/Makefile
+++ linux-2.6.31-rc3-ak/drivers/pci/Makefile
@@ -8,6 +8,9 @@ obj-y		+= access.o bus.o probe.o remove.
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_SYSFS) += slot.o
 
+obj-$(CONFIG_PCI_LEGACY) += legacy.o
+CFLAGS_legacy.o += -Wno-deprecated-declarations
+
 # Build PCI Express stuff if needed
 obj-$(CONFIG_PCIEPORTBUS) += pcie/
 
Index: linux-2.6.31-rc3-ak/drivers/pci/legacy.c
===================================================================
--- /dev/null
+++ linux-2.6.31-rc3-ak/drivers/pci/legacy.c
@@ -0,0 +1,34 @@
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include "pci.h"
+
+/**
+ * pci_find_device - begin or continue searching for a PCI device by vendor/device id
+ * @vendor: PCI vendor id to match, or %PCI_ANY_ID to match all vendor ids
+ * @device: PCI device id to match, or %PCI_ANY_ID to match all device ids
+ * @from: Previous PCI device found in search, or %NULL for new search.
+ *
+ * Iterates through the list of known PCI devices.  If a PCI device is found
+ * with a matching @vendor and @device, a pointer to its device structure is
+ * returned.  Otherwise, %NULL is returned.
+ * A new search is initiated by passing %NULL as the @from argument.
+ * Otherwise if @from is not %NULL, searches continue from next device
+ * on the global list.
+ *
+ * NOTE: Do not use this function any more; use pci_get_device() instead, as
+ * the PCI device returned by this function can disappear at any moment in
+ * time.
+ */
+struct pci_dev *pci_find_device(unsigned int vendor, unsigned int device,
+				struct pci_dev *from)
+{
+	struct pci_dev *pdev;
+
+	pci_dev_get(from);
+	pdev = pci_get_subsys(vendor, device, PCI_ANY_ID, PCI_ANY_ID, from);
+	pci_dev_put(pdev);
+	return pdev;
+}
+EXPORT_SYMBOL(pci_find_device);
Index: linux-2.6.31-rc3-ak/drivers/pci/search.c
===================================================================
--- linux-2.6.31-rc3-ak.orig/drivers/pci/search.c
+++ linux-2.6.31-rc3-ak/drivers/pci/search.c
@@ -113,37 +113,6 @@ pci_find_next_bus(const struct pci_bus *
 	return b;
 }
 
-#ifdef CONFIG_PCI_LEGACY
-/**
- * pci_find_device - begin or continue searching for a PCI device by vendor/device id
- * @vendor: PCI vendor id to match, or %PCI_ANY_ID to match all vendor ids
- * @device: PCI device id to match, or %PCI_ANY_ID to match all device ids
- * @from: Previous PCI device found in search, or %NULL for new search.
- *
- * Iterates through the list of known PCI devices.  If a PCI device is found
- * with a matching @vendor and @device, a pointer to its device structure is
- * returned.  Otherwise, %NULL is returned.
- * A new search is initiated by passing %NULL as the @from argument.
- * Otherwise if @from is not %NULL, searches continue from next device
- * on the global list.
- *
- * NOTE: Do not use this function any more; use pci_get_device() instead, as
- * the PCI device returned by this function can disappear at any moment in
- * time.
- */
-struct pci_dev *pci_find_device(unsigned int vendor, unsigned int device,
-				struct pci_dev *from)
-{
-	struct pci_dev *pdev;
-
-	pci_dev_get(from);
-	pdev = pci_get_subsys(vendor, device, PCI_ANY_ID, PCI_ANY_ID, from);
-	pci_dev_put(pdev);
-	return pdev;
-}
-EXPORT_SYMBOL(pci_find_device);
-#endif /* CONFIG_PCI_LEGACY */
-
 /**
  * pci_get_slot - locate PCI device for a given PCI slot
  * @bus: PCI bus on which desired PCI device resides
