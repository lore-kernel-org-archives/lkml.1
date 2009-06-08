Return-Path: <linux-kernel-owner+w=401wt.eu-S1754343AbZFHHyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbZFHHyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 03:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZFHHy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 03:54:27 -0400
Received: from mga05.intel.com ([192.55.52.89]:46398 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751051AbZFHHy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 03:54:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,323,1241420400"; 
   d="scan'208";a="697369250"
Subject: [PATCH V2: 3/3] pci: Provide Multiple Error Received support on AER
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <1244447368.2560.193.camel@ymzhang>
References: <1244447368.2560.193.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 08 Jun 2009 15:54:35 +0800
Message-Id: <1244447675.2560.199.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-08 at 15:49 +0800, Zhang, Yanmin wrote:
> ﻿﻿When root ports receive the same errors more than once before kernel
>  process them, the Multiple Error Messages Received flags are set by
> hardware. Because root port could only save one kind of correctable
> error source id and another uncorrectable error source id at the same
> time, so the second message sender id is lost if the 2 messages are
> sent from 2 different devices. Below patch searches all devices under
> the root port when multiple messages are received.
﻿Sorry. The version number should be V2 instead of V3.

﻿﻿﻿When root ports receive the same errors more than once before kernel
 process them, the Multiple Error Messages Received flags are set by
hardware. Because root port could only save one kind of correctable
error source id and another uncorrectable error source id at the same
time, so the second message sender id is lost if the 2 messages are
sent from 2 different devices. Below patch searches all devices under
the root port when multiple messages are received.

﻿﻿﻿﻿Signed-off-by: ﻿Zhang Yanmin <yanmin.zhang@linux.intel.com>

---

--- linux-2.6.30-rc3_aernoeid/drivers/pci/pcie/aer/aerdrv_core.c	2009-06-07 14:09:19.000000000 +0800
+++ linux-2.6.30-rc3_aermultierror/drivers/pci/pcie/aer/aerdrv_core.c	2009-06-07 14:35:43.000000000 +0800
@@ -143,13 +143,22 @@ static void set_downstream_devices_error
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
 
@@ -168,8 +177,9 @@ static int find_device_iter(struct pci_d
 	if (!nosourceid) {
 		result = compare_device_id(dev, e_info);
 		if (result)
-			return 1;
-		if (e_info->id != 0)
+			goto added;
+		if ((e_info->id != 0) &&
+			!(e_info->flags & AER_MULTI_ERROR_VALID_FLAG))
 			return 0;
 	}
 
@@ -205,8 +215,8 @@ static int find_device_iter(struct pci_d
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
@@ -216,12 +226,18 @@ static int find_device_iter(struct pci_d
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
@@ -702,6 +718,30 @@ static int get_device_error_info(struct 
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
@@ -744,18 +784,7 @@ static void aer_isr_one_error(struct pci
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
+++ linux-2.6.30-rc3_aermultierror/drivers/pci/pcie/aer/aerdrv.h	2009-06-07 14:16:55.000000000 +0800
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


