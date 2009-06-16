Return-Path: <linux-kernel-owner+w=401wt.eu-S1765411AbZFPFep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765411AbZFPFep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758339AbZFPFef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:34:35 -0400
Received: from mga06.intel.com ([134.134.136.21]:65509 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759356AbZFPFee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:34:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,226,1243839600"; 
   d="scan'208";a="422272305"
Subject: [PATCH V5: 1/3] pci: Provide Multiple Error Received and no error
	source id support on AER
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 16 Jun 2009 13:34:38 +0800
Message-Id: <1245130478.2560.392.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank ﻿Andrew Patterson for his detailed comments. I revised the patches.

    Change log V5:
    	Revise patches based on Andrew Patterson's comments.
    
    Changelog V4:
    	Port the patches to Jesses' linux-next tree (mostly based on
    	2.6.30).
    
    Changelog V3:
    	1) Probe devices under the root port when the bus id of
    	the source id is equal to 0; V2 does so when device id is
    	equal to 0;
    	2) Add more comments on critical path of finding devices.
    
    Changelog V2:
    	Version 2 adds nosourceid, a boot parameter. When
    	aerdriver.nosourceid=y, aerdriver doesn't use the source
    	id saved by root port. Instead, it searches the device
    	tree under the root port to find the reporter. So if hardware
    	has errata and root port saves a bad source id, aerdriver
    	still could find the reporter.
    	There are 2 scenarios under which ﻿aerdriver searches the
    	device tree under root port:
    	1) nosourceid=n and error source id is equal to 0;
    	2) nosourceid=y.
    
    Based on PCI Express AER specs, a root port might receive multiple
    TLP errors while it could only save a correctable error source id
    and an uncorrectable error source id at the same time. In addition,
    some root port hardware might be unable to provide a correct source
    id, i.e., the source id, or the bus id part of the source id provided
    by root port might be equal to 0.
    
    The patchset implements the support in kernel by searching the device
    tree under the root port.
    
    Patch 1 changes parameter cb of function pci_walk_bus to return a value.
    When cb return non-zero, pci_walk_bus stops more searching on the
    device tree.
    
    Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

diff --git a/arch/powerpc/platforms/pseries/eeh_driver.c b/arch/powerpc/platforms/pseries/eeh_driver.c
index 9a2a6e3..0e8db67 100644
--- a/arch/powerpc/platforms/pseries/eeh_driver.c
+++ b/arch/powerpc/platforms/pseries/eeh_driver.c
@@ -122,7 +122,7 @@ static void eeh_enable_irq(struct pci_dev *dev)
  * passed back in "userdata".
  */
 
-static void eeh_report_error(struct pci_dev *dev, void *userdata)
+static int eeh_report_error(struct pci_dev *dev, void *userdata)
 {
 	enum pci_ers_result rc, *res = userdata;
 	struct pci_driver *driver = dev->driver;
@@ -130,19 +130,21 @@ static void eeh_report_error(struct pci_dev *dev, void *userdata)
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
@@ -153,7 +155,7 @@ static void eeh_report_error(struct pci_dev *dev, void *userdata)
  * Cumulative response passed back in "userdata".
  */
 
-static void eeh_report_mmio_enabled(struct pci_dev *dev, void *userdata)
+static int eeh_report_mmio_enabled(struct pci_dev *dev, void *userdata)
 {
 	enum pci_ers_result rc, *res = userdata;
 	struct pci_driver *driver = dev->driver;
@@ -161,26 +163,28 @@ static void eeh_report_mmio_enabled(struct pci_dev *dev, void *userdata)
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
 
@@ -188,35 +192,39 @@ static void eeh_report_reset(struct pci_dev *dev, void *userdata)
 
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
@@ -226,22 +234,24 @@ static void eeh_report_resume(struct pci_dev *dev, void *userdata)
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
diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 40af27f..cef28a7 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -206,13 +206,18 @@ void pci_enable_bridges(struct pci_bus *bus)
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
@@ -236,8 +241,10 @@ void pci_walk_bus(struct pci_bus *top, void (*cb)(struct pci_dev *, void *),
 
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
diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index dd3829e..a7a3919 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -109,7 +109,7 @@ int pci_cleanup_aer_correct_error_status(struct pci_dev *dev)
 #endif  /*  0  */
 
 
-static void set_device_error_reporting(struct pci_dev *dev, void *data)
+static int set_device_error_reporting(struct pci_dev *dev, void *data)
 {
 	bool enable = *((bool *)data);
 
@@ -124,6 +124,8 @@ static void set_device_error_reporting(struct pci_dev *dev, void *data)
 
 	if (enable)
 		pcie_set_ecrc_checking(dev);
+
+	return 0;
 }
 
 /**
@@ -207,7 +209,7 @@ static struct device* find_source_device(struct pci_dev *parent, u16 id)
 	return NULL;
 }
 
-static void report_error_detected(struct pci_dev *dev, void *data)
+static int report_error_detected(struct pci_dev *dev, void *data)
 {
 	pci_ers_result_t vote;
 	struct pci_error_handlers *err_handler;
@@ -232,16 +234,16 @@ static void report_error_detected(struct pci_dev *dev, void *data)
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
@@ -251,15 +253,15 @@ static void report_mmio_enabled(struct pci_dev *dev, void *data)
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
@@ -269,15 +271,15 @@ static void report_slot_reset(struct pci_dev *dev, void *data)
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
 
@@ -286,11 +288,11 @@ static void report_resume(struct pci_dev *dev, void *data)
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
@@ -307,7 +309,7 @@ static void report_resume(struct pci_dev *dev, void *data)
 static pci_ers_result_t broadcast_error_message(struct pci_dev *dev,
 	enum pci_channel_state state,
 	char *error_mesg,
-	void (*cb)(struct pci_dev *, void *))
+	int (*cb)(struct pci_dev *, void *))
 {
 	struct aer_broadcast_data result_data;
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index ea2a153..ab4bba3 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -789,7 +789,7 @@ const struct pci_device_id *pci_match_id(const struct pci_device_id *ids,
 int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 		    int pass);
 
-void pci_walk_bus(struct pci_bus *top, void (*cb)(struct pci_dev *, void *),
+void pci_walk_bus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
 		  void *userdata);
 int pci_cfg_space_size_ext(struct pci_dev *dev);
 int pci_cfg_space_size(struct pci_dev *dev);


