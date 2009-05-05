Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbZEEGWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbZEEGWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 02:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbZEEGVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 02:21:51 -0400
Received: from mga05.intel.com ([192.55.52.89]:28934 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754122AbZEEGVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 02:21:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,295,1239001200"; 
   d="scan'208";a="687539957"
Subject: [PATCH 1/3] pci: Provide Multiple Error Received and no error
	source id support on AER
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Tue, 05 May 2009 14:22:12 +0800
Message-Id: <1241504532.27664.45.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on PCI Express AER specs, a root port might receive multiple
TLP errors while it could only save a correctable error source id
and an uncorrectable error source id at the same time. In addition,
some root port hardware might be unable to provide a correct source
id, i.e., the source id provided by root port might be equal to 0.

The patchset implements the support in kernel by searching the device
tree under the root port.

Patch 1 changes parameter cb of function pci_walk_bus to return a value.
When cb return non-zero, pci_walk_bus stops more searching on the
device tree.

﻿﻿﻿Signed-off-by: ﻿Zhang Yanmin <yanmin.zhang@linux.intel.com>

---

--- linux-2.6.30-rc3/arch/powerpc/platforms/pseries/eeh_driver.c	2009-04-27 15:48:28.000000000 +0800
+++ linux-2.6.30-rc3_pciwalk/arch/powerpc/platforms/pseries/eeh_driver.c	2009-04-29 10:39:41.000000000 +0800
@@ -122,7 +122,7 @@ static void eeh_enable_irq(struct pci_de
  * passed back in "userdata".
  */
 
-static void eeh_report_error(struct pci_dev *dev, void *userdata)
+static int eeh_report_error(struct pci_dev *dev, void *userdata)
 {
 	enum pci_ers_result rc, *res = userdata;
 	struct pci_driver *driver = dev->driver;
@@ -130,19 +130,21 @@ static void eeh_report_error(struct pci_
 	dev->error_state = pci_channel_io_frozen;
 
 	if (!driver)
-		return;
+		return 0;
 
 	eeh_disable_irq(dev);
 
 	if (!driver->err_handler ||
 	    !driver->err_handler->error_detected)
-		return;
+		return 0;
 
 	rc = driver->err_handler->error_detected (dev, pci_channel_io_frozen);
 
 	/* A driver that needs a reset trumps all others */
 	if (rc == PCI_ERS_RESULT_NEED_RESET) *res = rc;
 	if (*res == PCI_ERS_RESULT_NONE) *res = rc;
+
+	return 0;
 }
 
 /**
@@ -153,7 +155,7 @@ static void eeh_report_error(struct pci_
  * Cumulative response passed back in "userdata".
  */
 
-static void eeh_report_mmio_enabled(struct pci_dev *dev, void *userdata)
+static int eeh_report_mmio_enabled(struct pci_dev *dev, void *userdata)
 {
 	enum pci_ers_result rc, *res = userdata;
 	struct pci_driver *driver = dev->driver;
@@ -161,26 +163,28 @@ static void eeh_report_mmio_enabled(stru
 	if (!driver ||
 	    !driver->err_handler ||
 	    !driver->err_handler->mmio_enabled)
-		return;
+		return 0;
 
 	rc = driver->err_handler->mmio_enabled (dev);
 
 	/* A driver that needs a reset trumps all others */
 	if (rc == PCI_ERS_RESULT_NEED_RESET) *res = rc;
 	if (*res == PCI_ERS_RESULT_NONE) *res = rc;
+
+	return 0;
 }
 
 /**
  * eeh_report_reset - tell device that slot has been reset
  */
 
-static void eeh_report_reset(struct pci_dev *dev, void *userdata)
+static int eeh_report_reset(struct pci_dev *dev, void *userdata)
 {
 	enum pci_ers_result rc, *res = userdata;
 	struct pci_driver *driver = dev->driver;
 
 	if (!driver)
-		return;
+		return 0;
 
 	dev->error_state = pci_channel_io_normal;
 
@@ -188,35 +192,39 @@ static void eeh_report_reset(struct pci_
 
 	if (!driver->err_handler ||
 	    !driver->err_handler->slot_reset)
-		return;
+		return 0;
 
 	rc = driver->err_handler->slot_reset(dev);
 	if ((*res == PCI_ERS_RESULT_NONE) ||
 	    (*res == PCI_ERS_RESULT_RECOVERED)) *res = rc;
 	if (*res == PCI_ERS_RESULT_DISCONNECT &&
 	     rc == PCI_ERS_RESULT_NEED_RESET) *res = rc;
+
+	return 0;
 }
 
 /**
  * eeh_report_resume - tell device to resume normal operations
  */
 
-static void eeh_report_resume(struct pci_dev *dev, void *userdata)
+static int eeh_report_resume(struct pci_dev *dev, void *userdata)
 {
 	struct pci_driver *driver = dev->driver;
 
 	dev->error_state = pci_channel_io_normal;
 
 	if (!driver)
-		return;
+		return 0;
 
 	eeh_enable_irq(dev);
 
 	if (!driver->err_handler ||
 	    !driver->err_handler->resume)
-		return;
+		return 0;
 
 	driver->err_handler->resume(dev);
+
+	return 0;
 }
 
 /**
@@ -226,22 +234,24 @@ static void eeh_report_resume(struct pci
  * dead, and that no further recovery attempts will be made on it.
  */
 
-static void eeh_report_failure(struct pci_dev *dev, void *userdata)
+static int eeh_report_failure(struct pci_dev *dev, void *userdata)
 {
 	struct pci_driver *driver = dev->driver;
 
 	dev->error_state = pci_channel_io_perm_failure;
 
 	if (!driver)
-		return;
+		return 0;
 
 	eeh_disable_irq(dev);
 
 	if (!driver->err_handler ||
 	    !driver->err_handler->error_detected)
-		return;
+		return 0;
 
 	driver->err_handler->error_detected(dev, pci_channel_io_perm_failure);
+
+	return 0;
 }
 
 /* ------------------------------------------------------- */
--- linux-2.6.30-rc3/drivers/pci/bus.c	2009-04-27 15:48:31.000000000 +0800
+++ linux-2.6.30-rc3_pciwalk/drivers/pci/bus.c	2009-05-05 14:10:36.000000000 +0800
@@ -201,13 +201,18 @@ void pci_enable_bridges(struct pci_bus *
  *  Walk the given bus, including any bridged devices
  *  on buses under this bus.  Call the provided callback
  *  on each device found.
+ *
+ *  We check the return of @cb each time. If it returns anything
+ *  other than 0, we break out.
+ *
  */
-void pci_walk_bus(struct pci_bus *top, void (*cb)(struct pci_dev *, void *),
+void pci_walk_bus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
 		  void *userdata)
 {
 	struct pci_dev *dev;
 	struct pci_bus *bus;
 	struct list_head *next;
+	int retval;
 
 	bus = top;
 	down_read(&pci_bus_sem);
@@ -231,8 +236,10 @@ void pci_walk_bus(struct pci_bus *top, v
 
 		/* Run device routines with the device locked */
 		down(&dev->dev.sem);
-		cb(dev, userdata);
+		retval = cb(dev, userdata);
 		up(&dev->dev.sem);
+		if (retval)
+			break;
 	}
 	up_read(&pci_bus_sem);
 }
--- linux-2.6.30-rc3/drivers/pci/pcie/aer/aerdrv_core.c	2009-04-27 15:48:31.000000000 +0800
+++ linux-2.6.30-rc3_pciwalk/drivers/pci/pcie/aer/aerdrv_core.c	2009-04-29 10:37:16.000000000 +0800
@@ -109,19 +109,21 @@ int pci_cleanup_aer_correct_error_status
 #endif  /*  0  */
 
 
-static void set_device_error_reporting(struct pci_dev *dev, void *data)
+static int set_device_error_reporting(struct pci_dev *dev, void *data)
 {
 	bool enable = *((bool *)data);
 
 	if (dev->pcie_type != PCIE_RC_PORT &&
 	    dev->pcie_type != PCIE_SW_UPSTREAM_PORT &&
 	    dev->pcie_type != PCIE_SW_DOWNSTREAM_PORT)
-		return;
+		return 0;
 
 	if (enable)
 		pci_enable_pcie_error_reporting(dev);
 	else
 		pci_disable_pcie_error_reporting(dev);
+
+	return 0;
 }
 
 /**
@@ -205,7 +207,7 @@ static struct device* find_source_device
 	return NULL;
 }
 
-static void report_error_detected(struct pci_dev *dev, void *data)
+static int report_error_detected(struct pci_dev *dev, void *data)
 {
 	pci_ers_result_t vote;
 	struct pci_error_handlers *err_handler;
@@ -230,16 +232,16 @@ static void report_error_detected(struct
 				   dev->driver ?
 				   "no AER-aware driver" : "no driver");
 		}
-		return;
+		return 0;
 	}
 
 	err_handler = dev->driver->err_handler;
 	vote = err_handler->error_detected(dev, result_data->state);
 	result_data->result = merge_result(result_data->result, vote);
-	return;
+	return 0;
 }
 
-static void report_mmio_enabled(struct pci_dev *dev, void *data)
+static int report_mmio_enabled(struct pci_dev *dev, void *data)
 {
 	pci_ers_result_t vote;
 	struct pci_error_handlers *err_handler;
@@ -249,15 +251,15 @@ static void report_mmio_enabled(struct p
 	if (!dev->driver ||
 		!dev->driver->err_handler ||
 		!dev->driver->err_handler->mmio_enabled)
-		return;
+		return 0;
 
 	err_handler = dev->driver->err_handler;
 	vote = err_handler->mmio_enabled(dev);
 	result_data->result = merge_result(result_data->result, vote);
-	return;
+	return 0;
 }
 
-static void report_slot_reset(struct pci_dev *dev, void *data)
+static int report_slot_reset(struct pci_dev *dev, void *data)
 {
 	pci_ers_result_t vote;
 	struct pci_error_handlers *err_handler;
@@ -267,15 +269,15 @@ static void report_slot_reset(struct pci
 	if (!dev->driver ||
 		!dev->driver->err_handler ||
 		!dev->driver->err_handler->slot_reset)
-		return;
+		return 0;
 
 	err_handler = dev->driver->err_handler;
 	vote = err_handler->slot_reset(dev);
 	result_data->result = merge_result(result_data->result, vote);
-	return;
+	return 0;
 }
 
-static void report_resume(struct pci_dev *dev, void *data)
+static int report_resume(struct pci_dev *dev, void *data)
 {
 	struct pci_error_handlers *err_handler;
 
@@ -284,11 +286,11 @@ static void report_resume(struct pci_dev
 	if (!dev->driver ||
 		!dev->driver->err_handler ||
 		!dev->driver->err_handler->resume)
-		return;
+		return 0;
 
 	err_handler = dev->driver->err_handler;
 	err_handler->resume(dev);
-	return;
+	return 0;
 }
 
 /**
@@ -305,7 +307,7 @@ static void report_resume(struct pci_dev
 static pci_ers_result_t broadcast_error_message(struct pci_dev *dev,
 	enum pci_channel_state state,
 	char *error_mesg,
-	void (*cb)(struct pci_dev *, void *))
+	int (*cb)(struct pci_dev *, void *))
 {
 	struct aer_broadcast_data result_data;
 
--- linux-2.6.30-rc3/include/linux/pci.h	2009-04-27 15:48:33.000000000 +0800
+++ linux-2.6.30-rc3_pciwalk/include/linux/pci.h	2009-04-29 10:31:58.000000000 +0800
@@ -790,7 +790,7 @@ const struct pci_device_id *pci_match_id
 int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 		    int pass);
 
-void pci_walk_bus(struct pci_bus *top, void (*cb)(struct pci_dev *, void *),
+void pci_walk_bus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
 		  void *userdata);
 int pci_cfg_space_size_ext(struct pci_dev *dev);
 int pci_cfg_space_size(struct pci_dev *dev);


