Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbXKYDWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbXKYDWB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 22:22:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbXKYDVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 22:21:53 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:34052 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbXKYDVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 22:21:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=L59x1pHGqm/CKLSxjZqGVDd2nA+mw5MBLyik1+mr+hALLFv8rF+yS5H1WQgmx195ABHugjEpB5xr7l6dmEoIBKefWBdpBUQPEZ4O330Bvjd8rAzLC1ygCKhBS9V0tg7pCuLEXqnsWcldzzOR37k9OEhcy5JBL9fCxNVngKePw1Q=
Date: Sun, 25 Nov 2007 11:21:48 +0800
From: "peerchen" <peerchen@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "akpm" <akpm@linux-foundation.org>, "pchen" <pchen@nvidia.com>,
       "acurrid" <acurrid@nvidia.com>
Subject: [PATCH 1/2] msi: set 'En' bit of MSI Mapping Capability on HT platform
Message-ID: <200711251121445151346@gmail.com>
X-mailer: Foxmail 6, 6, 105, 21 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

According to the HyperTransport spec, 'En' indicate if the MSI Mapping is active. So it should be set when enable the MSI.

The patch base on kernel 2.6.24-rc3

Signed-off-by: Andy Currid <acurrid@nvidia.com>
Signed-off-by: Peer Chen <pchen@nvidia.com>

---
--- linux-2.6.24-rc3/drivers/pci/msi.c.orig	2007-11-23 17:28:45.000000000 -0500
+++ linux-2.6.24-rc3/drivers/pci/msi.c	2007-11-23 17:50:59.000000000 -0500
@@ -20,6 +20,8 @@
 #include <asm/errno.h>
 #include <asm/io.h>
 
+#include <asm/k8.h>
+
 #include "pci.h"
 #include "msi.h"
 
@@ -290,6 +292,99 @@ void pci_restore_msi_state(struct pci_de
 }
 #endif	/* CONFIG_PM */
 
+/*
+ * pci_enable_msi_ht_cap - Set the HT MSI mapping capability En bit of
+ * a device.
+ *
+ * @dev: pointer to the pci_dev data structure of MSI device function
+ */
+
+static int pci_enable_msi_ht_cap(struct pci_dev *dev)
+{
+	int pos;
+	u8 flags;
+
+	if ((pos = pci_find_ht_capability(dev, HT_CAPTYPE_MSI_MAPPING)) != 0)
+	{	
+		pci_read_config_byte(dev, pos + HT_MSI_FLAGS, &flags);
+		pci_write_config_byte(dev, pos + HT_MSI_FLAGS,
+						  flags | HT_MSI_FLAGS_ENABLE);
+
+		printk(KERN_INFO "PCI: %s: enabled HT MSI mapping\n", pci_name(dev));
+	}
+
+	return pos;
+}
+
+/**
+ * pci_check_msi_ht_cap - check for and enable the MSI mapping capability En bit
+ * of devices or upstream bridge on HT-base system.
+ * @dev: pointer to the pci_dev data structure of MSI device function
+ *
+ * Search if device support ht MSI mapping capability on HT-base 
+ * platform, if yes, enable the En bit. If device can't support MSI mapping,
+ * search the the upstream bridge for that capability, enable En bit find it, 
+ * otherwise disable the MSI function if device and upstream bridge can't 
+ * support MSI mapping capability.
+ **/
+
+static int pci_check_msi_ht_cap(struct pci_dev *dev)
+{
+	struct pci_dev *bridge_dev;
+	
+	if (num_k8_northbridges != 0) {	/* If the system is the HT-base */
+
+		/* Check for upstream NVIDIA host bridges */
+
+		if (((bridge_dev = pci_find_slot(0, 0)) != NULL) &&
+				 (bridge_dev->vendor == PCI_VENDOR_ID_NVIDIA)) {
+			switch (bridge_dev->device) {
+			case PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC0:
+			case PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC1:
+			case PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC2:
+			case PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC3:
+			case PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC4:
+			case PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC5:
+			case PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC6:
+			case PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC7:
+			case PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_MEMC:
+
+				pci_enable_msi_ht_cap(bridge_dev);
+
+				bridge_dev = NULL;
+				while ((bridge_dev = pci_get_device(PCI_VENDOR_ID_NVIDIA,
+					PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_MEMC, bridge_dev))
+					!= NULL) {
+					pci_enable_msi_ht_cap(bridge_dev);
+			 	}
+
+				break;
+
+			default:
+				break;
+			}
+		}
+
+
+		if (pci_enable_msi_ht_cap(dev) != 0) {
+			return 0;
+		} else {
+			/* Get upstream bridge device handle */
+
+			bridge_dev = dev->bus->self;
+			while(bridge_dev != 0) {
+				if (pci_enable_msi_ht_cap(bridge_dev) != 0) {
+					return 0;
+				} else
+					bridge_dev = bridge_dev->bus->self;
+			}
+
+			return 1;
+		}
+	}
+	return 0;
+}
+
 /**
  * msi_capability_init - configure device's MSI capability structure
  * @dev: pointer to the pci_dev data structure of MSI device function
@@ -510,6 +605,10 @@ int pci_enable_msi(struct pci_dev* dev)
 	status = pci_msi_check_device(dev, 1, PCI_CAP_ID_MSI);
 	if (status)
 		return status;
+	
+	status = pci_check_msi_ht_cap(dev);
+	if(status)
+		return status;
 
 	WARN_ON(!!dev->msi_enabled);
 
@@ -606,6 +705,10 @@ int pci_enable_msix(struct pci_dev* dev,
 	if (status)
 		return status;
 
+	status = pci_check_msi_ht_cap(dev);
+	if(status)
+		return status;
+
 	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
 	pci_read_config_word(dev, msi_control_reg(pos), &control);
 	nr_entries = multi_msix_capable(control);
-

