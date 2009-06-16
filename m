Return-Path: <linux-kernel-owner+w=401wt.eu-S933356AbZFPFfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933356AbZFPFfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758559AbZFPFfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:35:09 -0400
Received: from mga12.intel.com ([143.182.124.36]:9163 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758361AbZFPFfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:35:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,226,1243839600"; 
   d="scan'208";a="154886696"
Subject: [PATCH V5: 2/3] pci: Provide aer support when the error source id
	is bad
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 13:35:11 +0800
Message-Id: <1245130511.2560.393.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    When the bus id part of error source id is equal to 0 or nosourceid=1,
    kernel probes the AER status registers of all devices under the root port
    to find the initial error reporter.
    
    Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
    
---

diff --git a/Documentation/PCI/pcieaer-howto.txt b/Documentation/PCI/pcieaer-howto.txt
index f6b1ba7..5408b9b 100644
--- a/Documentation/PCI/pcieaer-howto.txt
+++ b/Documentation/PCI/pcieaer-howto.txt
@@ -61,6 +61,10 @@ be initiated although firmwares have no _OSC support. To enable the
 walkaround, pls. add aerdriver.forceload=y to kernel boot parameter line
 when booting kernel. Note that forceload=n by default.
 
+nosourceid, another parameter of type bool, can be used when broken
+hardware (mostly chipsets) has root ports that cannot obtain the reporting
+source ID. nosourceid=n by default.
+
 2.3 AER error output
 When a PCI-E AER error is captured, an error message will be outputed to
 console. If it's a correctable error, it is outputed as a warning.
diff --git a/drivers/pci/pcie/aer/aerdrv.h b/drivers/pci/pcie/aer/aerdrv.h
index 3a69dde..dadf492 100644
--- a/drivers/pci/pcie/aer/aerdrv.h
+++ b/drivers/pci/pcie/aer/aerdrv.h
@@ -58,6 +58,8 @@ struct header_log_regs {
 };
 
 struct aer_err_info {
+	struct pci_dev *dev;
+	u16 id;
 	int severity;			/* 0:NONFATAL | 1:FATAL | 2:COR */
 	int flags;
 	unsigned int status;		/* COR/UNCOR Error Status */
diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index a7a3919..2750e7b 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -26,7 +26,9 @@
 #include "aerdrv.h"
 
 static int forceload;
+static int nosourceid;
 module_param(forceload, bool, 0);
+module_param(nosourceid, bool, 0);
 
 int pci_enable_pcie_error_reporting(struct pci_dev *dev)
 {
@@ -143,34 +145,87 @@ static void set_downstream_devices_error_reporting(struct pci_dev *dev,
 	pci_walk_bus(dev->subordinate, set_device_error_reporting, &enable);
 }
 
-static int find_device_iter(struct device *device, void *data)
+static inline int compare_device_id(struct pci_dev *dev,
+			struct aer_err_info *e_info)
 {
-	struct pci_dev *dev;
-	u16 id = *(unsigned long *)data;
-	u8 secondary, subordinate, d_bus = id >> 8;
+	if (e_info->id == ((dev->bus->number << 8) | dev->devfn)) {
+		/*
+		 * Device ID match
+		 */
+		return 1;
+	}
 
-	if (device->bus == &pci_bus_type) {
-		dev = to_pci_dev(device);
-		if (id == ((dev->bus->number << 8) | dev->devfn)) {
-			/*
-			 * Device ID match
-			 */
-			*(unsigned long*)data = (unsigned long)device;
+	return 0;
+}
+
+#define	PCI_BUS(x)	(((x) >> 8) & 0xff)
+
+static int find_device_iter(struct pci_dev *dev, void *data)
+{
+	int pos;
+	u32 status;
+	u32 mask;
+	u16 reg16;
+	int result;
+	struct aer_err_info *e_info = (struct aer_err_info *)data;
+
+	/*
+	 * When bus id is equal to 0, it might be a bad id
+	 * reported by root port.
+	 */
+	if (!nosourceid && (PCI_BUS(e_info->id) != 0)) {
+		result = compare_device_id(dev, e_info);
+		if (result)
+			e_info->dev = dev;
+		return result;
+	}
+
+	/*
+	 * Next is to check when bus id is equal to 0 or
+	 * nosourceid==y. Some ports might lose the bus
+	 * id of error source id. We check AER status
+	 * registers to find the initial reporter.
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
 			return 1;
 		}
-
-		/*
-		 * If device is P2P, check if it is an upstream?
-		 */
-		if (dev->hdr_type & PCI_HEADER_TYPE_BRIDGE) {
-			pci_read_config_byte(dev, PCI_SECONDARY_BUS,
-				&secondary);
-			pci_read_config_byte(dev, PCI_SUBORDINATE_BUS,
-				&subordinate);
-			if (d_bus >= secondary && d_bus <= subordinate) {
-				*(unsigned long*)data = (unsigned long)device;
-				return 1;
-			}
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
 
@@ -180,33 +235,22 @@ static int find_device_iter(struct device *device, void *data)
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
-
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
+	result = find_device_iter(dev, e_info);
+	if (result)
+		return;
 
-	return NULL;
+	pci_walk_bus(parent->subordinate, find_device_iter, e_info);
 }
 
 static int report_error_detected(struct pci_dev *dev, void *data)
@@ -501,12 +545,12 @@ static pci_ers_result_t do_recovery(struct pcie_device *aerdev,
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
@@ -514,9 +558,9 @@ static void handle_error_source(struct pcie_device * aerdev,
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
@@ -673,10 +717,16 @@ static int get_device_error_info(struct pci_dev *dev, struct aer_err_info *info)
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
+	if (e_info == NULL) {
+		dev_printk(KERN_DEBUG, &p_device->port->dev,
+			"Can't allocate mem when processing AER errors\n");
+		return;
+	}
 
 	/*
 	 * There is a possibility that both correctable error and
@@ -688,31 +738,37 @@ static void aer_isr_one_error(struct pcie_device *p_device,
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


