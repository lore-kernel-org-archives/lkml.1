Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbZEEGWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbZEEGWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 02:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758378AbZEEGWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 02:22:12 -0400
Received: from mga10.intel.com ([192.55.52.92]:53173 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758153AbZEEGWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 02:22:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,295,1239001200"; 
   d="scan'208";a="454151977"
Subject: [PATCH 3/3] pci: Provide Multiple Error Received support on AER
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Tue, 05 May 2009 14:22:33 +0800
Message-Id: <1241504553.27664.47.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿When root ports receive the same errors more than once before kernel
 process them, the Multiple Error Messages Received flags are set by
hardware. Because root port could only save one kind of correctable
error source id and another uncorrectable error source id at the same
time, so the second message sender id is lost if the 2 messages are
sent from 2 different devices. Below patch searches all devices under
the root port when multiple messages are received.

﻿﻿﻿﻿Signed-off-by: ﻿Zhang Yanmin <yanmin.zhang@linux.intel.com>

---

--- linux-2.6.30-rc3_aernoeid/drivers/pci/pcie/aer/aerdrv_core.c	2009-05-05 11:15:52.000000000 +0800
+++ linux-2.6.30-rc3_aermultierror/drivers/pci/pcie/aer/aerdrv_core.c	2009-05-05 11:17:56.000000000 +0800
@@ -141,6 +141,15 @@ static void set_downstream_devices_error
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
 static int find_device_iter(struct pci_dev *dev, void *data)
 {
 	int pos;
@@ -153,9 +162,11 @@ static int find_device_iter(struct pci_d
 		/*
 		 * Device ID match
 		 */
-		e_info->dev = dev;
-		return 1;
-	} else if (e_info->id != 0)
+		add_error_device(e_info, dev);
+		goto added;
+	}
+	if ((e_info->id != 0) &&
+		!(e_info->flags & AER_MULTI_ERROR_VALID_FLAG))
 		return 0;
 
 	/*
@@ -190,8 +201,8 @@ static int find_device_iter(struct pci_d
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
@@ -201,12 +212,18 @@ static int find_device_iter(struct pci_d
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
@@ -687,6 +704,30 @@ static int get_device_error_info(struct 
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
+	for (i = 0; i < AER_MAX_MULTI_ERR_DEVICES; i ++) {
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
@@ -729,18 +770,7 @@ static void aer_isr_one_error(struct pci
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
--- linux-2.6.30-rc3_aernoeid/drivers/pci/pcie/aer/aerdrv.h	2009-04-29 12:44:36.000000000 +0800
+++ linux-2.6.30-rc3_aermultierror/drivers/pci/pcie/aer/aerdrv.h	2009-05-05 11:17:56.000000000 +0800
@@ -56,8 +56,10 @@ struct header_log_regs {
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


