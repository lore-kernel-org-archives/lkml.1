Return-Path: <linux-kernel-owner+w=401wt.eu-S932419AbZFLDIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbZFLDIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 23:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932173AbZFLDIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 23:08:38 -0400
Received: from mga12.intel.com ([143.182.124.36]:58976 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932419AbZFLDId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 23:08:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,206,1243839600"; 
   d="scan'208";a="153421804"
Subject: [PATCH V4: 3/3] pci: Provide Multiple Error Received support on AER
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 12 Jun 2009 11:08:38 +0800
Message-Id: <1244776118.2560.321.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿﻿﻿﻿﻿When a root port receive the same errors more than once before kernel
 process them, the Multiple Error Messages Received flags are set by
hardware. Because root port could only save one kind of correctable
error source id and another uncorrectable error source id at the same
time, so the second message sender id is lost if the 2 messages are
sent from 2 different devices. Below patch searches all devices under
the root port when multiple messages are received.

﻿﻿﻿﻿Signed-off-by: ﻿Zhang Yanmin <yanmin.zhang@linux.intel.com>

---

diff -Nraup linux-2.6_next_aernoid/drivers/pci/pcie/aer/aerdrv_core.c linux-2.6_next_aermultierror/drivers/pci/pcie/aer/aerdrv_core.c
--- linux-2.6_next_aernoid/drivers/pci/pcie/aer/aerdrv_core.c	2009-06-12 05:39:24.000000000 +0800
+++ linux-2.6_next_aermultierror/drivers/pci/pcie/aer/aerdrv_core.c	2009-06-12 05:45:15.000000000 +0800
@@ -145,13 +145,22 @@ static void set_downstream_devices_error
 	pci_walk_bus(dev->subordinate, set_device_error_reporting, &enable);
 }
 
+static int add_error_device(struct aer_err_info *e_info, struct pci_dev *dev)
+{
+	if (e_info->error_dev_num < AER_MAX_MULTI_ERR_DEVICES) {
+		e_info->dev[e_info->error_dev_num ++] = dev;
+		return 1;
+	} else
+		return 0;
+}
+
 static int compare_device_id(struct pci_dev *dev, struct aer_err_info *e_info)
 {
 	if (e_info->id == ((dev->bus->number << 8) | dev->devfn)) {
 		/*
 		 * Device ID match
 		 */
-		e_info->dev = dev;
+		add_error_device(e_info, dev);
 		return 1;
 	}
 
@@ -166,20 +175,38 @@ static int find_device_iter(struct pci_d
 	u32 status;
 	u32 mask;
 	u16 reg16;
+	int result;
 	struct aer_err_info *e_info = (struct aer_err_info *)data;
 
 	/*
 	 * When bus id is equal to 0, it might be a bad id
 	 * reported by root port.
 	 */
-	if (!nosourceid && (PCI_BUS(e_info->id) != 0))
-		return compare_device_id(dev, e_info);
+	if (!nosourceid && (PCI_BUS(e_info->id) != 0)) {
+		result = compare_device_id(dev, e_info);
+		/*
+		 * If there is no multiple error, we stop
+		 * or continue based on the id comparing.
+		 */
+		if (!(e_info->flags & AER_MULTI_ERROR_VALID_FLAG))
+			return result;
+
+		/*
+		 * If there are multiple errors and id does match,
+		 * We need continue to search other devices under
+		 * the root port. Return 0 means that.
+		 */
+		if (result)
+			return 0;
+	}
 
 	/*
-	 * Next is to check when bus id is equal to 0 or
-	 * nosourceid==y. Some ports might lose the bus
-	 * id of error source id. We check AER status
-	 * registers to find the initial reporter.
+	 * When either
+	 * 	1) nosourceid==y;
+	 * 	2) bus id is equal to 0. Some ports might lose the bus
+	 * 		id of error source id;
+	 * 	3) There are multiple errors and prior id comparing fails;
+	 * We check AER status registers to find the initial reporter.
 	 */
 	if (atomic_read(&dev->enable_cnt) == 0)
 		return 0;
@@ -208,8 +235,8 @@ static int find_device_iter(struct pci_d
 				pos + PCI_ERR_COR_MASK,
 				&mask);
 		if (status & ERR_CORRECTABLE_ERROR_MASK & ~mask) {
-			e_info->dev = dev;
-			return 1;
+			add_error_device(e_info, dev);
+			goto added;
 		}
 	} else {
 		pci_read_config_dword(dev,
@@ -219,12 +246,18 @@ static int find_device_iter(struct pci_d
 				pos + PCI_ERR_UNCOR_MASK,
 				&mask);
 		if (status & ERR_UNCORRECTABLE_ERROR_MASK & ~mask) {
-			e_info->dev = dev;
-			return 1;
+			add_error_device(e_info, dev);
+			goto added;
 		}
 	}
 
 	return 0;
+
+added:
+	if (e_info->flags & AER_MULTI_ERROR_VALID_FLAG) {
+		return 0;
+	} else
+		return 1;
 }
 
 /**
@@ -705,6 +738,30 @@ static int get_device_error_info(struct 
 	return AER_SUCCESS;
 }
 
+static inline void aer_process_err_devices(struct pcie_device *p_device,
+			struct aer_err_info *e_info)
+{
+	int i;
+
+	if (e_info->dev[0] == NULL) {
+		printk(KERN_DEBUG "%s->can't find device of ID%04x\n",
+				__func__, e_info->id);
+	}
+
+	for (i = 0; i < e_info->error_dev_num; i ++) {
+		if (e_info->dev[i] == NULL)
+			break;
+
+		if (get_device_error_info(e_info->dev[i], e_info) ==
+				AER_SUCCESS) {
+			aer_print_error(e_info->dev[i], e_info);
+			handle_error_source(p_device,
+					e_info->dev[i],
+					e_info);
+		}
+	}
+}
+
 /**
  * aer_isr_one_error - consume an error detected by root port
  * @p_device: pointer to error root port service device
@@ -747,18 +804,7 @@ static void aer_isr_one_error(struct pci
 			e_info->flags |= AER_MULTI_ERROR_VALID_FLAG;
 
 		find_source_device(p_device->port, e_info);
-		if (e_info->dev == NULL) {
-			printk(KERN_DEBUG "%s->can't find device of ID%04x\n",
-				__func__, e_info->id);
-			continue;
-		}
-		if (get_device_error_info(e_info->dev, e_info) ==
-				AER_SUCCESS) {
-			aer_print_error(e_info->dev, e_info);
-			handle_error_source(p_device,
-				e_info->dev,
-				e_info);
-		}
+		aer_process_err_devices(p_device, e_info);
 	}
 
 	kfree(e_info);
diff -Nraup linux-2.6_next_aernoid/drivers/pci/pcie/aer/aerdrv.h linux-2.6_next_aermultierror/drivers/pci/pcie/aer/aerdrv.h
--- linux-2.6_next_aernoid/drivers/pci/pcie/aer/aerdrv.h	2009-06-12 05:39:24.000000000 +0800
+++ linux-2.6_next_aermultierror/drivers/pci/pcie/aer/aerdrv.h	2009-06-12 05:45:15.000000000 +0800
@@ -57,8 +57,10 @@ struct header_log_regs {
 	unsigned int dw3;
 };
 
+#define AER_MAX_MULTI_ERR_DEVICES	5
 struct aer_err_info {
-	struct pci_dev *dev;
+	struct pci_dev *dev[AER_MAX_MULTI_ERR_DEVICES];
+	int error_dev_num;
 	u16 id;
 	int severity;			/* 0:NONFATAL | 1:FATAL | 2:COR */
 	int flags;


