Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbXEHGLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbXEHGLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 02:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbXEHGLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 02:11:43 -0400
Received: from mga05.intel.com ([192.55.52.89]:29571 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754124AbXEHGLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 02:11:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,503,1170662400"; 
   d="scan'208";a="243201031"
Subject: Re: acpi_handle is intel only.
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de
In-Reply-To: <20070505202930.GA6360@aepfle.de>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
	 <20070505202930.GA6360@aepfle.de>
Content-Type: text/plain; charset=utf-8
Date: Tue, 08 May 2007 14:11:05 +0800
Message-Id: <1178604665.3014.7.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-05 at 22:29 +0200, Olaf Hering wrote:
> On Sat, May 05, Andrew Morton wrote:
> 
> > +gregkh-pci-pci-reduce-aer-init-error-information.patch
> 
> include/linux/pci-acpi.h:57: error: expected ')' before 'handle'
> make[4]: *** [drivers/pci/pcie/portdrv_pci.o] Error 1
> 
> acpi_handle is intel only.
Sorry. I didn't check CONFIG_ACPI=n. The acpi header file inclusion
is too complicated.

Below patch against 2.6.21+gregkh-pci-pci-reduce-aer-init-error-information.patch
fixes the compiling issue. I delete the acpi header file inclusion in aerdrv.h,
and move function aer_osc_setup to another file.

I tested it with both CONFIG_ACPI=y and CONFIG_ACPI=n.

Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>

---

diff -Nraup linux-2.6.21_aer/drivers/pci/pcie/aer/aerdrv_acpi.c linux-2.6.21_aer_fix/drivers/pci/pcie/aer/aerdrv_acpi.c
--- linux-2.6.21_aer/drivers/pci/pcie/aer/aerdrv_acpi.c	2007-05-09 21:00:15.000000000 +0800
+++ linux-2.6.21_aer_fix/drivers/pci/pcie/aer/aerdrv_acpi.c	1970-01-01 08:00:00.000000000 +0800
@@ -1,61 +0,0 @@
-/*
- * Access ACPI _OSC method
- *
- * Copyright (C) 2006 Intel Corp.
- *	Tom Long Nguyen (tom.l.nguyen@intel.com)
- *	Zhang Yanmin (yanmin.zhang@intel.com)
- *
- */
-
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/pm.h>
-#include <linux/suspend.h>
-#include <linux/acpi.h>
-#include <linux/pci-acpi.h>
-#include <linux/delay.h>
-#include "aerdrv.h"
-
-/**
- * aer_osc_setup - run ACPI _OSC method
- *
- * Return:
- *	Zero if success. Nonzero for otherwise.
- *
- * Invoked when PCIE bus loads AER service driver. To avoid conflict with
- * BIOS AER support requires BIOS to yield AER control to OS native driver.
- **/
-acpi_status aer_osc_setup(struct pci_dev *dev)
-{
-	acpi_status status = AE_NOT_FOUND;
-	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->dev);
-	struct pci_dev *pdev = dev;
-	struct pci_bus *parent;
-
-	while (!handle) {
-		if (!pdev || !pdev->bus->parent)
-			break;
-		parent = pdev->bus->parent;
-		if (!parent->self)
-			/* Parent must be a host bridge */
-			handle = acpi_get_pci_rootbridge_handle(
-					pci_domain_nr(parent),
-					parent->number);
-		else
-			handle = DEVICE_ACPI_HANDLE(
-					&(parent->self->dev));
-		pdev = parent->self;
-	}
-
-	if (!handle)
-		return status;
-
-	pci_osc_support_set(OSC_EXT_PCI_CONFIG_SUPPORT);
-	status = pci_osc_control_set(handle, OSC_PCI_EXPRESS_AER_CONTROL |
-		OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL);
-
-	return status;
-}
-
diff -Nraup linux-2.6.21_aer/drivers/pci/pcie/aer/aerdrv_core.c linux-2.6.21_aer_fix/drivers/pci/pcie/aer/aerdrv_core.c
--- linux-2.6.21_aer/drivers/pci/pcie/aer/aerdrv_core.c	2007-05-09 21:00:15.000000000 +0800
+++ linux-2.6.21_aer_fix/drivers/pci/pcie/aer/aerdrv_core.c	2007-05-09 21:02:14.000000000 +0800
@@ -726,6 +726,47 @@ void aer_delete_rootport(struct aer_rpc 
 }
 
 /**
+ * aer_osc_setup - run ACPI _OSC method
+ *
+ * Return:
+ *	Zero if success. Nonzero for otherwise.
+ *
+ * Invoked when PCIE bus loads AER service driver. To avoid conflict with
+ * BIOS AER support requires BIOS to yield AER control to OS native driver.
+ **/
+acpi_status aer_osc_setup(struct pci_dev *dev)
+{
+	acpi_status status = AE_NOT_FOUND;
+	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->dev);
+	struct pci_dev *pdev = dev;
+	struct pci_bus *parent;
+
+	while (!handle) {
+		if (!pdev || !pdev->bus->parent)
+			break;
+		parent = pdev->bus->parent;
+		if (!parent->self)
+			/* Parent must be a host bridge */
+			handle = acpi_get_pci_rootbridge_handle(
+					pci_domain_nr(parent),
+					parent->number);
+		else
+			handle = DEVICE_ACPI_HANDLE(
+					&(parent->self->dev));
+		pdev = parent->self;
+	}
+
+	if (!handle)
+		return status;
+
+	pci_osc_support_set(OSC_EXT_PCI_CONFIG_SUPPORT);
+	status = pci_osc_control_set(handle, OSC_PCI_EXPRESS_AER_CONTROL |
+		OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL);
+
+	return status;
+}
+
+/**
  * aer_init - provide AER initialization
  * @dev: pointer to AER pcie device
  *
diff -Nraup linux-2.6.21_aer/drivers/pci/pcie/aer/aerdrv.h linux-2.6.21_aer_fix/drivers/pci/pcie/aer/aerdrv.h
--- linux-2.6.21_aer/drivers/pci/pcie/aer/aerdrv.h	2007-05-09 21:00:15.000000000 +0800
+++ linux-2.6.21_aer_fix/drivers/pci/pcie/aer/aerdrv.h	2007-05-09 21:00:59.000000000 +0800
@@ -9,8 +9,6 @@
 #define _AERDRV_H_
 
 #include <linux/pcieport_if.h>
-#include <linux/acpi.h>
-#include <linux/pci-acpi.h>
 #include <linux/aer.h>
 
 #define AER_NONFATAL			0
@@ -118,6 +116,5 @@ extern void aer_delete_rootport(struct a
 extern int aer_init(struct pcie_device *dev);
 extern void aer_isr(struct work_struct *work);
 extern void aer_print_error(struct pci_dev *dev, struct aer_err_info *info);
-extern acpi_status aer_osc_setup(struct pci_dev *dev);
 
 #endif //_AERDRV_H_
diff -Nraup linux-2.6.21_aer/drivers/pci/pcie/aer/Makefile linux-2.6.21_aer_fix/drivers/pci/pcie/aer/Makefile
--- linux-2.6.21_aer/drivers/pci/pcie/aer/Makefile	2007-05-09 21:00:03.000000000 +0800
+++ linux-2.6.21_aer_fix/drivers/pci/pcie/aer/Makefile	2007-05-09 21:02:34.000000000 +0800
@@ -4,5 +4,5 @@
 
 obj-$(CONFIG_PCIEAER) += aerdriver.o
 
-aerdriver-objs := aerdrv_errprint.o aerdrv_core.o aerdrv.o aerdrv_acpi.o
+aerdriver-objs := aerdrv_errprint.o aerdrv_core.o aerdrv.o
 
