Return-Path: <linux-kernel-owner+w=401wt.eu-S934018AbZFPFfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934018AbZFPFfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933317AbZFPFfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:35:13 -0400
Received: from mga10.intel.com ([192.55.52.92]:20579 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933354AbZFPFfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:35:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,226,1243839600"; 
   d="scan'208";a="699718686"
Subject: [PATCH V5: 3/3] pci: Provide Multiple Error Received support on AER
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 13:35:16 +0800
Message-Id: <1245130516.2560.394.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    When a root port receive the same errors more than once before kernel
     process them, the Multiple Error Messages Received flags are set by
    hardware. Because root port could only save one kind of correctable
    error source id and another uncorrectable error source id at the same
    time, so the second message sender id is lost if the 2 messages are
    sent from 2 different devices. Below patch searches all devices under
    the root port when multiple messages are received.
    
    Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

diff --git a/drivers/pci/pcie/aer/aerdrv.h b/drivers/pci/pcie/aer/aerdrv.h
index dadf492..bbd7428 100644
--- a/drivers/pci/pcie/aer/aerdrv.h
+++ b/drivers/pci/pcie/aer/aerdrv.h
@@ -57,8 +57,10 @@ struct header_log_regs {
 	unsigned int dw3;
 };
 
+#define AER_MAX_MULTI_ERR_DEVICES	5	/* Not likely to have more */
 struct aer_err_info {
-	struct pci_dev *dev;
+	struct pci_dev *dev[AER_MAX_MULTI_ERR_DEVICES];
+	int error_dev_num;
 	u16 id;
 	int severity;			/* 0:NONFATAL | 1:FATAL | 2:COR */
 	int flags;
diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index 2750e7b..3d88727 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -158,6 +158,17 @@ static inline int compare_device_id(struct pci_dev *dev,
 	return 0;
 }
 
+static int add_error_device(struct aer_err_info *e_info, struct pci_dev *dev)
+{
+	if (e_info->error_dev_num < AER_MAX_MULTI_ERR_DEVICES) {
+		e_info->dev[e_info->error_dev_num] = dev;
+		e_info->error_dev_num++;
+		return 1;
+	} else
+		return 0;
+}
+
+
 #define	PCI_BUS(x)	(((x) >> 8) & 0xff)
 
 static int find_device_iter(struct pci_dev *dev, void *data)
@@ -176,15 +187,31 @@ static int find_device_iter(struct pci_dev *dev, void *data)
 	if (!nosourceid && (PCI_BUS(e_info->id) != 0)) {
 		result = compare_device_id(dev, e_info);
 		if (result)
-			e_info->dev = dev;
-		return result;
+			add_error_device(e_info, dev);
+
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
 	}
 
 	/*
-	 * Next is to check when bus id is equal to 0 or
-	 * nosourceid==y. Some ports might lose the bus
-	 * id of error source id. We check AER status
-	 * registers to find the initial reporter.
+	 * When either
+	 *      1) nosourceid==y;
+	 *      2) bus id is equal to 0. Some ports might lose the bus
+	 *              id of error source id;
+	 *      3) There are multiple errors and prior id comparing fails;
+	 * We check AER status registers to find the initial reporter.
 	 */
 	if (atomic_read(&dev->enable_cnt) == 0)
 		return 0;
@@ -213,8 +240,8 @@ static int find_device_iter(struct pci_dev *dev, void *data)
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
@@ -224,12 +251,18 @@ static int find_device_iter(struct pci_dev *dev, void *data)
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
+	if (e_info->flags & AER_MULTI_ERROR_VALID_FLAG)
+		return 0;
+	else
+		return 1;
 }
 
 /**
@@ -709,6 +742,28 @@ static int get_device_error_info(struct pci_dev *dev, struct aer_err_info *info)
 	return AER_SUCCESS;
 }
 
+static inline void aer_process_err_devices(struct pcie_device *p_device,
+			struct aer_err_info *e_info)
+{
+	int i;
+
+	if (!e_info->dev[0]) {
+		dev_printk(KERN_DEBUG, &p_device->port->dev,
+				"can't find device of ID%04x\n",
+				e_info->id);
+	}
+
+	for (i = 0; i < e_info->error_dev_num && e_info->dev[i]; i++) {
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
@@ -754,18 +809,7 @@ static void aer_isr_one_error(struct pcie_device *p_device,
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


