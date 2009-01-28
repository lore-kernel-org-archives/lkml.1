Return-Path: <linux-kernel-owner+w=401wt.eu-S1753090AbZA1WBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbZA1WBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbZA1V7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:59:32 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:38544 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbZA1V73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:59:29 -0500
From: Alex Chiang <achiang@hp.com>
Subject: [RFC PATCH 04/10] PCI: Introduce /sys/bus/pci/devices/.../remove
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trent Piepho <xyzzy@speakeasy.org>, djwong@us.ibm.com,
       Alex Chiang <achiang@hp.com>
Date: Wed, 28 Jan 2009 14:59:23 -0700
Message-ID: <20090128215923.28003.18686.stgit@bob.kio>
In-Reply-To: <20090128213814.28003.34634.stgit@bob.kio>
References: <20090128213814.28003.34634.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an attribute named "remove" to a PCI device's sysfs
directory.  Writing a non-zero value to this attribute will remove the PCI
device and any of its children.

Code was originally written by Trent Piepho, with a small cleanup and
additional documentation from me.

Cc: Trent Piepho <xyzzy@speakeasy.org>
Cc: djwong@us.ibm.com
Reviewed-by: James Cameron <qz@hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 Documentation/ABI/testing/sysfs-bus-pci |    8 ++++++++
 drivers/pci/pci-sysfs.c                 |   30 ++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index ceddcff..faa21de 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -1,3 +1,11 @@
+What:		/sys/bus/pci/devices/.../remove
+Date:		January 2009
+Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
+Description:
+		Writing a non-zero value to this attribute will
+		hot-remove the PCI device and any of its children.
+		Depends on CONFIG_HOTPLUG.
+
 What:		/sys/bus/pci/devices/.../vpd
 Date:		February 2008
 Contact:	Ben Hutchings <bhutchings@solarflare.com>
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index db7ec14..603a32d 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -219,6 +219,33 @@ msi_bus_store(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
+#ifdef CONFIG_HOTPLUG
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
+#endif
+
 struct device_attribute pci_dev_attrs[] = {
 	__ATTR_RO(resource),
 	__ATTR_RO(vendor),
@@ -237,6 +264,9 @@ struct device_attribute pci_dev_attrs[] = {
 	__ATTR(broken_parity_status,(S_IRUGO|S_IWUSR),
 		broken_parity_status_show,broken_parity_status_store),
 	__ATTR(msi_bus, 0644, msi_bus_show, msi_bus_store),
+#ifdef CONFIG_HOTPLUG
+	__ATTR(remove, S_IWUSR, NULL, remove_store),
+#endif
 	__ATTR_NULL,
 };
 

