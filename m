Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbZA1WAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbZA1WAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZA1V7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:59:31 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:19980 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbZA1V73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:59:29 -0500
From: Alex Chiang <achiang@hp.com>
Subject: [RFC PATCH 05/10] PCI: Introduce /sys/bus/pci/rescan
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trent Piepho <xyzzy@speakeasy.org>, djwong@us.ibm.com,
       Alex Chiang <achiang@hp.com>
Date: Wed, 28 Jan 2009 14:59:28 -0700
Message-ID: <20090128215928.28003.23920.stgit@bob.kio>
In-Reply-To: <20090128213814.28003.34634.stgit@bob.kio>
References: <20090128213814.28003.34634.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This interface allows the user to force a rescan of all PCI buses
in system, and rediscover devices that have been removed earlier.

Cc: Trent Piepho <xyzzy@speakeasy.org>
Cc: djwong@us.ibm.com
Reviewed-by: James Cameron <qz@hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 Documentation/ABI/testing/sysfs-bus-pci |    9 +++++++++
 drivers/pci/pci-sysfs.c                 |   28 ++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index faa21de..8c0abc7 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -1,3 +1,12 @@
+What:		/sys/bus/pci/rescan
+Date:		January 2009
+Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
+Description:
+		Writing a non-zero value to this attribute will
+		force a rescan of all PCI buses in the system, and
+		re-discover previously removed devices.
+		Depends on CONFIG_HOTPLUG.
+
 What:		/sys/bus/pci/devices/.../remove
 Date:		January 2009
 Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 603a32d..c300242 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -986,12 +986,40 @@ void pci_remove_sysfs_dev_files(struct pci_dev *pdev)
 	}
 }
 
+#ifdef CONFIG_HOTPLUG
+static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf, size_t count)
+{
+	unsigned long val;
+	struct pci_bus *b = NULL;
+
+	if (strict_strtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (val)
+		while ((b = pci_find_next_bus(b)) != NULL) {
+			pci_scan_child_bus(b);
+			pci_bus_add_devices(b);
+		}
+
+	return count;
+}
+static BUS_ATTR(rescan, S_IWUSR, NULL, bus_rescan_store);
+#endif
+
 static int __init pci_sysfs_init(void)
 {
 	struct pci_dev *pdev = NULL;
 	int retval;
 
 	sysfs_initialized = 1;
+#ifdef CONFIG_HOTPLUG
+	retval = bus_create_file(&pci_bus_type, &bus_attr_rescan);
+	if (retval)
+		return retval;
+#endif
 	for_each_pci_dev(pdev) {
 		retval = pci_create_sysfs_dev_files(pdev);
 		if (retval) {

