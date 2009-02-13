Return-Path: <linux-kernel-owner+w=401wt.eu-S1762260AbZBMUV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762260AbZBMUV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 15:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761502AbZBMUTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 15:19:36 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:2454 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761476AbZBMUTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 15:19:35 -0500
From: Alex Chiang <achiang@hp.com>
Subject: [RFC PATCH v2 08/12] PCI: Introduce /sys/bus/pci/devices/.../rescan
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trent Piepho <xyzzy@speakeasy.org>, djwong@us.ibm.com,
       Alex Chiang <achiang@hp.com>
Date: Fri, 13 Feb 2009 13:19:34 -0700
Message-ID: <20090213201933.19262.8952.stgit@bob.kio>
In-Reply-To: <20090213201135.19262.67924.stgit@bob.kio>
References: <20090213201135.19262.67924.stgit@bob.kio>
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
Cc: djwong@us.ibm.com
Reviewed-by: James Cameron <qz@hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 Documentation/ABI/testing/sysfs-bus-pci |   10 ++++++++++
 drivers/pci/pci-sysfs.c                 |   20 ++++++++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 8c0abc7..f59e963 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -15,6 +15,16 @@ Description:
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
index e4d2c0d..6e5f141 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -220,6 +220,25 @@ msi_bus_store(struct device *dev, struct device_attribute *attr,
 }
 
 #ifdef CONFIG_HOTPLUG
+static ssize_t
+dev_rescan_store(struct device *dev, struct device_attribute *attr,
+	      const char *buf, size_t count)
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
+		pci_do_scan_bus(pdev->bus);
+
+	return count;
+}
+
 static void remove_callback(void *data)
 {
 	struct pci_dev *pdev = (struct pci_dev *)data;
@@ -268,6 +287,7 @@ struct device_attribute pci_dev_attrs[] = {
 	__ATTR(msi_bus, 0644, msi_bus_show, msi_bus_store),
 #ifdef CONFIG_HOTPLUG
 	__ATTR(remove, S_IWUSR, NULL, remove_store),
+	__ATTR(rescan, S_IWUSR, NULL, dev_rescan_store),
 #endif
 	__ATTR_NULL,
 };

