Return-Path: <linux-kernel-owner+w=401wt.eu-S1760470AbYGaCv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760470AbYGaCv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 22:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbYGaCtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:49:14 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:60542 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231AbYGaCtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:49:13 -0400
Date: Wed, 30 Jul 2008 21:49:04 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/30] W1: w1_slave_read_id read bug, use device_attribute
Message-ID: <20080731024904.GL12181@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net> <20080729161356.2de456fb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729161356.2de456fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Wed, 30 Jul 2008 21:49:05 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix bug reading the id sysfs file.  If less than the full 8 bytes were
read, the next read would start at the first byte instead of
continuing.  It needed the offset added to memcpy, or the better
solution was to replace it with the device attribute instead of bin
attribute.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/w1.c |   35 ++++++++++-------------------------
 1 files changed, 10 insertions(+), 25 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index cd5bd23..3b15c57 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -103,35 +103,20 @@ static ssize_t w1_slave_read_name(struct device *dev, struct device_attribute *a
 	return sprintf(buf, "%s\n", sl->name);
 }
 
-static ssize_t w1_slave_read_id(struct kobject *kobj,
-				struct bin_attribute *bin_attr,
-				char *buf, loff_t off, size_t count)
+static ssize_t w1_slave_read_id(struct device *dev,
+	struct device_attribute *attr, char *buf)
 {
-	struct w1_slave *sl = kobj_to_w1_slave(kobj);
-
-	if (off > 8) {
-		count = 0;
-	} else {
-		if (off + count > 8)
-			count = 8 - off;
-
-		memcpy(buf, (u8 *)&sl->reg_num, count);
-	}
+	struct w1_slave *sl = dev_to_w1_slave(dev);
+	ssize_t count = sizeof(sl->reg_num);
 
+	memcpy(buf, (u8 *)&sl->reg_num, count);
 	return count;
 }
 
 static struct device_attribute w1_slave_attr_name =
 	__ATTR(name, S_IRUGO, w1_slave_read_name, NULL);
-
-static struct bin_attribute w1_slave_attr_bin_id = {
-      .attr = {
-              .name = "id",
-              .mode = S_IRUGO,
-      },
-      .size = 8,
-      .read = w1_slave_read_id,
-};
+static struct device_attribute w1_slave_attr_id =
+	__ATTR(id, S_IRUGO, w1_slave_read_id, NULL);
 
 /* Default family */
 
@@ -649,7 +634,7 @@ static int __w1_attach_slave_device(struct w1_slave *sl)
 	}
 
 	/* Create "id" entry */
-	err = sysfs_create_bin_file(&sl->dev.kobj, &w1_slave_attr_bin_id);
+	err = device_create_file(&sl->dev, &w1_slave_attr_id);
 	if (err < 0) {
 		dev_err(&sl->dev,
 			"sysfs file creation for [%s] failed. err=%d\n",
@@ -671,7 +656,7 @@ static int __w1_attach_slave_device(struct w1_slave *sl)
 	return 0;
 
 out_rem2:
-	sysfs_remove_bin_file(&sl->dev.kobj, &w1_slave_attr_bin_id);
+	device_remove_file(&sl->dev, &w1_slave_attr_id);
 out_rem1:
 	device_remove_file(&sl->dev, &w1_slave_attr_name);
 out_unreg:
@@ -753,7 +738,7 @@ void w1_slave_detach(struct w1_slave *sl)
 	msg.type = W1_SLAVE_REMOVE;
 	w1_netlink_send(sl->master, &msg);
 
-	sysfs_remove_bin_file(&sl->dev.kobj, &w1_slave_attr_bin_id);
+	device_remove_file(&sl->dev, &w1_slave_attr_id);
 	device_remove_file(&sl->dev, &w1_slave_attr_name);
 	device_unregister(&sl->dev);
 
-- 
1.4.4.4
