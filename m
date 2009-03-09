Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbZCIFvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbZCIFvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 01:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbZCIFtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 01:49:09 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:46953 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbZCIFtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 01:49:07 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v3 06/11] PCI: Introduce /sys/bus/pci/rescan
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trent Piepho <xyzzy@speakeasy.org>, djwong@us.ibm.com,
       Alex Chiang <achiang@hp.com>
Date: Sun, 08 Mar 2009 23:49:06 -0600
Message-ID: <20090309054906.3918.51833.stgit@bob.kio>
In-Reply-To: <20090309052933.3918.86601.stgit@bob.kio>
References: <20090309052933.3918.86601.stgit@bob.kio>
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
 drivers/pci/pci-sysfs.c                 |   26 ++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index e638e15..ea4aee2 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -41,6 +41,15 @@ Description:
 		for the device and attempt to bind to it.  For example:
 		# echo "8086 10f5" > /sys/bus/pci/drivers/foo/new_id
 
+What:		/sys/bus/pci/rescan
+Date:		January 2009
+Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
+Description:
+		Writing a non-zero value to this attribute will
+		force a rescan of all PCI buses in the system, and
+		re-discover previously removed devices.
+		Depends on CONFIG_HOTPLUG.
+
 What:		/sys/bus/pci/devices/.../vpd
 Date:		February 2008
 Contact:	Ben Hutchings <bhutchings@solarflare.com>
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 1c89298..a29fc3b 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -971,12 +971,38 @@ void pci_remove_sysfs_dev_files(struct pci_dev *pdev)
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
+		while ((b = pci_find_next_bus(b)) != NULL)
+			pci_do_scan_bus(b);
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

