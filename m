Return-Path: <linux-kernel-owner+w=401wt.eu-S1760053AbZCTU7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053AbZCTU7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 16:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbZCTU4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 16:56:44 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:39133 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759519AbZCTU4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 16:56:42 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v5 10/13] PCI: Introduce /sys/bus/pci/devices/.../rescan
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trent Piepho <xyzzy@speakeasy.org>, Alex Chiang <achiang@hp.com>
Date: Fri, 20 Mar 2009 14:56:41 -0600
Message-ID: <20090320205641.12275.37784.stgit@bob.kio>
In-Reply-To: <20090320204327.12275.43010.stgit@bob.kio>
References: <20090320204327.12275.43010.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This interface allows the user to force a rescan of the device's
parent bus and all subordinate buses, and rediscover devices removed
earlier from this part of the device tree.

Cc: Trent Piepho <xyzzy@speakeasy.org>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 Documentation/ABI/testing/sysfs-bus-pci |   10 ++++++++++
 drivers/pci/pci-sysfs.c                 |   19 +++++++++++++++++++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 1350fa6..ba0f0e7 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -74,6 +74,16 @@ Description:
 		hot-remove the PCI device and any of its children.
 		Depends on CONFIG_HOTPLUG.
 
+What:		/sys/bus/pci/devices/.../rescan
+Date:		January 2009
+Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
+Description:
+		Writing a non-zero value to this attribute will
+		force a rescan of the device's parent bus and all
+		child buses, and re-discover devices removed earlier
+		from this part of the device tree.
+		Depends on CONFIG_HOTPLUG.
+
 What:		/sys/bus/pci/devices/.../vpd
 Date:		February 2008
 Contact:	Ben Hutchings <bhutchings@solarflare.com>
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index e16990e..e9a8706 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -244,6 +244,24 @@ struct bus_attribute pci_bus_attrs[] = {
 	__ATTR_NULL
 };
 
+static ssize_t
+dev_rescan_store(struct device *dev, struct device_attribute *attr,
+		 const char *buf, size_t count)
+{
+	unsigned long val;
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (strict_strtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	if (val) {
+		mutex_lock(&pci_remove_rescan_mutex);
+		pci_rescan_bus(pdev->bus);
+		mutex_unlock(&pci_remove_rescan_mutex);
+	}
+	return count;
+}
+
 static void remove_callback(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -298,6 +316,7 @@ struct device_attribute pci_dev_attrs[] = {
 	__ATTR(msi_bus, 0644, msi_bus_show, msi_bus_store),
 #ifdef CONFIG_HOTPLUG
 	__ATTR(remove, (S_IWUSR|S_IWGRP), NULL, remove_store),
+	__ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, dev_rescan_store),
 #endif
 	__ATTR_NULL,
 };

