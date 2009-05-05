Return-Path: <linux-kernel-owner+w=401wt.eu-S1758496AbZEEGW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496AbZEEGW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 02:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755218AbZEEGWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 02:22:09 -0400
Received: from mga06.intel.com ([134.134.136.21]:28974 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757963AbZEEGWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 02:22:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,295,1239001200"; 
   d="scan'208";a="512570471"
Subject: [PATCH 2/3] pci: Provide no error source id support on AER
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Tue, 05 May 2009 14:22:29 +0800
Message-Id: <1241504549.27664.46.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When error source id is equal to 0, kernel checks the
AER status registersof all devices under the root port
to find the initial error reporter.

﻿﻿﻿Signed-off-by: ﻿Zhang Yanmin <yanmin.zhang@linux.intel.com>

---

--- linux-2.6.30-rc3_pciwalk/drivers/pci/pcie/aer/aerdrv_core.c	2009-04-29 10:37:16.000000000 +0800
+++ linux-2.6.30-rc3_aernoeid/drivers/pci/pcie/aer/aerdrv_core.c	2009-05-05 11:15:52.000000000 +0800
@@ -141,34 +141,68 @@ static void set_downstream_devices_error
 	pci_walk_bus(dev->subordinate, set_device_error_reporting, &enable);
 }
 
-static int find_device_iter(struct device *device, void *data)
+static int find_device_iter(struct pci_dev *dev, void *data)
 {
-	struct pci_dev *dev;
-	u16 id = *(unsigned long *)data;
-	u8 secondary, subordinate, d_bus = id >> 8;
-
-	if (device->bus == &pci_bus_type) {
-		dev = to_pci_dev(device);
-		if (id == ((dev->bus->number << 8) | dev->devfn)) {
-			/*
-			 * Device ID match
-			 */
-			*(unsigned long*)data = (unsigned long)device;
-			return 1;
-		}
+	int pos;
+	u32 status;
+	u32 mask;
+	u16 reg16;
+	struct aer_err_info *e_info = (struct aer_err_info *)data;
 
+	if (e_info->id == ((dev->bus->number << 8) | dev->devfn)) {
 		/*
-		 * If device is P2P, check if it is an upstream?
+		 * Device ID match
 		 */
-		if (dev->hdr_type & PCI_HEADER_TYPE_BRIDGE) {
-			pci_read_config_byte(dev, PCI_SECONDARY_BUS,
-				&secondary);
-			pci_read_config_byte(dev, PCI_SUBORDINATE_BUS,
-				&subordinate);
-			if (d_bus >= secondary && d_bus <= subordinate) {
-				*(unsigned long*)data = (unsigned long)device;
-				return 1;
-			}
+		e_info->dev = dev;
+		return 1;
+	} else if (e_info->id != 0)
+		return 0;
+
+	/*
+	 * Next is to check when id is equal to 0.
+	 * Some ports might lose error source id. We check AER
+	 * status registers to find the initial reporter.
+	 */
+	if (atomic_read(&dev->enable_cnt) == 0)
+		return 0;
+	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
+	if (!pos)
+		return 0;
+	/* Check if AER is enabled */
+	pci_read_config_word(dev, pos+PCI_EXP_DEVCTL, &reg16);
+	if (!(reg16 & (
+		PCI_EXP_DEVCTL_CERE |
+		PCI_EXP_DEVCTL_NFERE |
+		PCI_EXP_DEVCTL_FERE |
+		PCI_EXP_DEVCTL_URRE)))
+		return 0;
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
+	if (!pos)
+		return 0;
+
+	status = 0;
+	mask = 0;
+	if (e_info->severity == AER_CORRECTABLE) {
+		pci_read_config_dword(dev,
+				pos + PCI_ERR_COR_STATUS,
+				&status);
+		pci_read_config_dword(dev,
+				pos + PCI_ERR_COR_MASK,
+				&mask);
+		if (status & ERR_CORRECTABLE_ERROR_MASK & ~mask) {
+			e_info->dev = dev;
+			return 1;
+		}
+	} else {
+		pci_read_config_dword(dev,
+				pos + PCI_ERR_UNCOR_STATUS,
+				&status);
+		pci_read_config_dword(dev,
+				pos + PCI_ERR_UNCOR_MASK,
+				&mask);
+		if (status & ERR_UNCORRECTABLE_ERROR_MASK & ~mask) {
+			e_info->dev = dev;
+			return 1;
 		}
 	}
 
@@ -178,33 +212,23 @@ static int find_device_iter(struct devic
 /**
  * find_source_device - search through device hierarchy for source device
  * @parent: pointer to Root Port pci_dev data structure
- * @id: device ID of agent who sends an error message to this Root Port
+ * @err_info: including detailed error information such like id
  *
  * Invoked when error is detected at the Root Port.
  */
-static struct device* find_source_device(struct pci_dev *parent, u16 id)
+static void find_source_device(struct pci_dev *parent,
+		struct aer_err_info *e_info)
 {
 	struct pci_dev *dev = parent;
-	struct device *device;
-	unsigned long device_addr;
-	int status;
+	int result;
 
 	/* Is Root Port an agent that sends error message? */
-	if (id == ((dev->bus->number << 8) | dev->devfn))
-		return &dev->dev;
+	result = find_device_iter(dev, e_info);
+	if (result)
+		return;
 
-	do {
-		device_addr = id;
- 		if ((status = device_for_each_child(&dev->dev,
-			&device_addr, find_device_iter))) {
-			device = (struct device*)device_addr;
-			dev = to_pci_dev(device);
-			if (id == ((dev->bus->number << 8) | dev->devfn))
-				return device;
-		}
- 	}while (status);
-
-	return NULL;
+	pci_walk_bus(parent->subordinate, find_device_iter, e_info);
+	return;
 }
 
 static int report_error_detected(struct pci_dev *dev, void *data)
@@ -499,12 +523,12 @@ static pci_ers_result_t do_recovery(stru
  */
 static void handle_error_source(struct pcie_device * aerdev,
 	struct pci_dev *dev,
-	struct aer_err_info info)
+	struct aer_err_info *info)
 {
 	pci_ers_result_t status = 0;
 	int pos;
 
-	if (info.severity == AER_CORRECTABLE) {
+	if (info->severity == AER_CORRECTABLE) {
 		/*
 		 * Correctable error does not need software intevention.
 		 * No need to go through error recovery process.
@@ -512,9 +536,9 @@ static void handle_error_source(struct p
 		pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
 		if (pos)
 			pci_write_config_dword(dev, pos + PCI_ERR_COR_STATUS,
-					info.status);
+					info->status);
 	} else {
-		status = do_recovery(aerdev, dev, info.severity);
+		status = do_recovery(aerdev, dev, info->severity);
 		if (status == PCI_ERS_RESULT_RECOVERED) {
 			dev_printk(KERN_DEBUG, &dev->dev, "AER driver "
 				   "successfully recovered\n");
@@ -671,10 +695,13 @@ static int get_device_error_info(struct 
 static void aer_isr_one_error(struct pcie_device *p_device,
 		struct aer_err_source *e_src)
 {
-	struct device *s_device;
-	struct aer_err_info e_info = {0, 0, 0,};
+	struct aer_err_info *e_info;
 	int i;
-	u16 id;
+
+	/* struct aer_err_info might be big, so we allocate it with slab */
+	e_info = kmalloc(sizeof(struct aer_err_info), GFP_KERNEL);
+	if (e_info == NULL)
+		return;
 
 	/*
 	 * There is a possibility that both correctable error and
@@ -686,31 +713,37 @@ static void aer_isr_one_error(struct pci
 		if (!(e_src->status & i))
 			continue;
 
+		memset(e_info, 0, sizeof(struct aer_err_info));
+
 		/* Init comprehensive error information */
 		if (i & PCI_ERR_ROOT_COR_RCV) {
-			id = ERR_COR_ID(e_src->id);
-			e_info.severity = AER_CORRECTABLE;
+			e_info->id = ERR_COR_ID(e_src->id);
+			e_info->severity = AER_CORRECTABLE;
 		} else {
-			id = ERR_UNCOR_ID(e_src->id);
-			e_info.severity = ((e_src->status >> 6) & 1);
+			e_info->id = ERR_UNCOR_ID(e_src->id);
+			e_info->severity = ((e_src->status >> 6) & 1);
 		}
 		if (e_src->status &
 			(PCI_ERR_ROOT_MULTI_COR_RCV |
 			 PCI_ERR_ROOT_MULTI_UNCOR_RCV))
-			e_info.flags |= AER_MULTI_ERROR_VALID_FLAG;
-		if (!(s_device = find_source_device(p_device->port, id))) {
+			e_info->flags |= AER_MULTI_ERROR_VALID_FLAG;
+
+		find_source_device(p_device->port, e_info);
+		if (e_info->dev == NULL) {
 			printk(KERN_DEBUG "%s->can't find device of ID%04x\n",
-				__func__, id);
+				__func__, e_info->id);
 			continue;
 		}
-		if (get_device_error_info(to_pci_dev(s_device), &e_info) ==
+		if (get_device_error_info(e_info->dev, e_info) ==
 				AER_SUCCESS) {
-			aer_print_error(to_pci_dev(s_device), &e_info);
+			aer_print_error(e_info->dev, e_info);
 			handle_error_source(p_device,
-				to_pci_dev(s_device),
+				e_info->dev,
 				e_info);
 		}
 	}
+
+	kfree(e_info);
 }
 
 /**
--- linux-2.6.30-rc3_pciwalk/drivers/pci/pcie/aer/aerdrv.h	2009-04-29 10:29:35.000000000 +0800
+++ linux-2.6.30-rc3_aernoeid/drivers/pci/pcie/aer/aerdrv.h	2009-04-29 12:44:36.000000000 +0800
@@ -57,6 +57,8 @@ struct header_log_regs {
 };
 
 struct aer_err_info {
+	struct pci_dev *dev;
+	u16 id;
 	int severity;			/* 0:NONFATAL | 1:FATAL | 2:COR */
 	int flags;
 	unsigned int status;		/* COR/UNCOR Error Status */


