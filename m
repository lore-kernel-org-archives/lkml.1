Return-Path: <linux-kernel-owner+w=401wt.eu-S1762088AbZBMUV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762088AbZBMUV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 15:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbZBMUT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 15:19:27 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:47950 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759807AbZBMUTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 15:19:25 -0500
From: Alex Chiang <achiang@hp.com>
Subject: [RFC PATCH v2 06/12] PCI: Introduce /sys/bus/pci/rescan
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trent Piepho <xyzzy@speakeasy.org>, djwong@us.ibm.com,
       Alex Chiang <achiang@hp.com>
Date: Fri, 13 Feb 2009 13:19:23 -0700
Message-ID: <20090213201923.19262.84126.stgit@bob.kio>
In-Reply-To: <20090213201135.19262.67924.stgit@bob.kio>
References: <20090213201135.19262.67924.stgit@bob.kio>
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
index ceddcff..ba15e2e 100644
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
 What:		/sys/bus/pci/devices/.../vpd
 Date:		February 2008
 Contact:	Ben Hutchings <bhutchings@solarflare.com>
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index db7ec14..a2d85f6 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -956,12 +956,38 @@ void pci_remove_sysfs_dev_files(struct pci_dev *pdev)
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

