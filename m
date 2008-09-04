Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbYIDVtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbYIDVtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 17:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbYIDVsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 17:48:42 -0400
Received: from suva.vyatta.com ([69.59.150.140]:39264 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622AbYIDVsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 17:48:39 -0400
X-Greylist: delayed 2714 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Sep 2008 17:48:36 EDT
Message-Id: <20080904205718.708966839@vyatta.com>
References: <20080904205636.130211023@vyatta.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Sep 2008 13:56:39 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] PCI: add interface to set visible size of VPD
Content-Disposition: inline; filename=vpd-size.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VPD on all devices may not be 32K. Unfortunately, there is no
generic way to find the size, so this adds a simple API hook
to reset it.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/drivers/pci/access.c	2008-09-04 11:29:22.000000000 -0700
+++ b/drivers/pci/access.c	2008-09-04 11:38:29.000000000 -0700
@@ -332,6 +332,24 @@ int pci_vpd_pci22_init(struct pci_dev *d
 }
 
 /**
+ * pci_vpd_size - Set available Vital Product Data size
+ * @dev:	pci device struct
+ * @size:	available memory in bytes
+ *
+ * Adjust size of available VPD area.
+ */
+int pci_vpd_size(struct pci_dev *dev, size_t size)
+{
+	if (!dev->vpd)
+		return -EINVAL;
+	if (size > PCI_VPD_PCI22_SIZE)
+		return -EINVAL;
+	dev->vpd->len = size;
+	return 0;
+}
+EXPORT_SYMBOL(pci_vpd_size);
+
+/**
  * pci_block_user_cfg_access - Block userspace PCI config reads/writes
  * @dev:	pci device struct
  *
--- a/include/linux/pci.h	2008-09-04 11:28:45.000000000 -0700
+++ b/include/linux/pci.h	2008-09-04 11:29:15.000000000 -0700
@@ -653,6 +653,7 @@ int pci_bus_find_capability(struct pci_b
 /* Vital product data routines */
 int pci_read_vpd(struct pci_dev *dev, loff_t pos, size_t count, void *buf);
 int pci_write_vpd(struct pci_dev *dev, loff_t pos, size_t count, const void *buf);
+int pci_vpd_size(struct pci_dev *dev, size_t size);
 
 /* Helper functions for low-level code (drivers/pci/setup-[bus,res].c) */
 void pci_bus_assign_resources(struct pci_bus *bus);

-- 

