Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYLAOJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYLAOJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbYLAOJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:09:05 -0500
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:38879 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbYLAOJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:09:04 -0500
From: Trent Piepho <xyzzy@speakeasy.org>
To: linux-kernel@vger.kernel.org
Cc: linux-pci <linux-pci@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
       Alex Chiang <achiang@hp.com>, Trent Piepho <xyzzy@speakeasy.org>
Subject: [PATCH] PCI: Method for removing PCI devices
Date: Mon,  1 Dec 2008 06:08:09 -0800
Message-Id: <1228140490-32199-1-git-send-email-xyzzy@speakeasy.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <Pine.LNX.4.58.0812010500330.2943@shell2.speakeasy.net>
References: <Pine.LNX.4.58.0812010500330.2943@shell2.speakeasy.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an attribute named "remove" to a PCI device's sysfs
directory.  Writing a non-zero value to this attribute will remove the PCI
device and any children of it.
---
 drivers/pci/pci-sysfs.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 9a5bdc0..fe0f6a9 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -217,6 +217,31 @@ msi_bus_store(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
+static void remove_callback(void *data)
+{
+	pci_remove_bus_device((struct pci_dev *)data);
+}
+
+static ssize_t
+remove_store(struct device *dev, struct device_attribute *dummy,
+	     const char *buf, size_t count)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	unsigned long val;
+
+	if (strict_strtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (val)
+		sysfs_schedule_callback(&dev->kobj, remove_callback, pdev,
+		                        THIS_MODULE);
+
+	return count;
+}
+
 struct device_attribute pci_dev_attrs[] = {
 	__ATTR_RO(resource),
 	__ATTR_RO(vendor),
@@ -235,6 +260,7 @@ struct device_attribute pci_dev_attrs[] = {
 	__ATTR(broken_parity_status,(S_IRUGO|S_IWUSR),
 		broken_parity_status_show,broken_parity_status_store),
 	__ATTR(msi_bus, 0644, msi_bus_show, msi_bus_store),
+	__ATTR(remove, S_IWUSR, NULL, remove_store),
 	__ATTR_NULL,
 };
 
-- 
1.5.4.1

