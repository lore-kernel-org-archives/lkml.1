Return-Path: <linux-kernel-owner+w=401wt.eu-S1760004AbZCRWmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004AbZCRWmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 18:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758513AbZCRWkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 18:40:15 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:2864 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbZCRWkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 18:40:13 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v4 09/12] PCI: Introduce /sys/bus/pci/devices/.../rescan
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trent Piepho <xyzzy@speakeasy.org>, Alex Chiang <achiang@hp.com>
Date: Wed, 18 Mar 2009 16:40:11 -0600
Message-ID: <20090318224011.887.19965.stgit@bob.kio>
In-Reply-To: <20090318222426.887.1008.stgit@bob.kio>
References: <20090318222426.887.1008.stgit@bob.kio>
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
 drivers/pci/pci-sysfs.c                 |   22 ++++++++++++++++++++++
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 5b1ddde..d33840e 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -58,6 +58,16 @@ Description:
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
index 6e2b1fd..92e7fd9 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -247,6 +247,27 @@ struct bus_attribute pci_bus_attrs[] = {
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
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
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
 	int bridge = 0;
@@ -309,6 +330,7 @@ struct device_attribute pci_dev_attrs[] = {
 	__ATTR(msi_bus, 0644, msi_bus_show, msi_bus_store),
 #ifdef CONFIG_HOTPLUG
 	__ATTR(remove, S_IWUSR, NULL, remove_store),
+	__ATTR(rescan, S_IWUSR, NULL, dev_rescan_store),
 #endif
 	__ATTR_NULL,
 };

