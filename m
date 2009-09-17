Return-Path: <linux-kernel-owner+w=401wt.eu-S1760328AbZIQSsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760328AbZIQSsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760284AbZIQSsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:48:00 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:27514 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760274AbZIQSr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:47:57 -0400
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 19/20] cciss: Add usage_count attribute to each logical drive
	in /sys
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       andrew.patterson@hp.com, mikem@beardog.cce.hp.com,
       scameron@beardog.cce.hp.com
Date: Thu, 17 Sep 2009 13:48:26 -0500
Message-ID: <20090917184826.15105.47523.stgit@beardog.cce.hp.com>
In-Reply-To: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
References: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add usage_count attribute to each logical drive at
/sys/devices/<dev>/ccissX/cXdY/usage_count for controller X,
logical drive Y.  The usage count is the number of times
the device has currently been opened.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 .../ABI/testing/sysfs-bus-pci-devices-cciss        |    7 +++++++
 drivers/block/cciss.c                              |   20 ++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss b/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
index 8d02602..4f29e5f 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
+++ b/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
@@ -52,3 +52,10 @@ Kernel Version: 2.6.31
 Contact:	iss_storagedev@hp.com
 Description:	Displays the RAID level of logical drive Y of
 		controller X.
+
+Where:		/sys/bus/pci/devices/<dev>/ccissX/cXdY/usage_count
+Date:		August 2009
+Kernel Version: 2.6.31
+Contact:	iss_storagedev@hp.com
+Description:	Displays the usage count (number of opens) of logical drive Y
+		of controller X.
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index dc3461e..f3f30c5 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -625,6 +625,25 @@ static ssize_t cciss_show_raid_level(struct device *dev,
 }
 DEVICE_ATTR(raid_level, S_IRUGO, cciss_show_raid_level, NULL);
 
+static ssize_t cciss_show_usage_count(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	drive_info_struct *drv = dev_get_drvdata(dev);
+	struct ctlr_info *h = to_hba(drv->dev->parent);
+	unsigned long flags;
+	int count;
+
+	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	if (h->busy_configuring) {
+		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		return -EBUSY;
+	}
+	count = drv->usage_count;
+	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	return snprintf(buf, 20, "%d\n", count);
+}
+DEVICE_ATTR(usage_count, S_IRUGO, cciss_show_usage_count, NULL);
+
 static struct attribute *cciss_host_attrs[] = {
 	&dev_attr_rescan.attr,
 	NULL
@@ -652,6 +671,7 @@ static struct attribute *cciss_dev_attrs[] = {
 	&dev_attr_rev.attr,
 	&dev_attr_lunid.attr,
 	&dev_attr_raid_level.attr,
+	&dev_attr_usage_count.attr,
 	NULL
 };
 

