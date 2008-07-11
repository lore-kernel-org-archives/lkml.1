Return-Path: <linux-kernel-owner+w=401wt.eu-S1761422AbYGKNxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761422AbYGKNxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759478AbYGKNsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:48:11 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34983 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759419AbYGKNr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:57 -0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 11/30] W1: w1_slave_read_id read bug, use device_attribute
Date: Fri, 11 Jul 2008 17:51:26 +0400
Message-Id: <12157843064048-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
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
index 4bf2001..67b4b99 100644
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
 
@@ -641,7 +626,7 @@ static int __w1_attach_slave_device(struct w1_slave *sl)
 	}
 
 	/* Create "id" entry */
-	err = sysfs_create_bin_file(&sl->dev.kobj, &w1_slave_attr_bin_id);
+	err = device_create_file(&sl->dev, &w1_slave_attr_id);
 	if (err < 0) {
 		dev_err(&sl->dev,
 			"sysfs file creation for [%s] failed. err=%d\n",
@@ -663,7 +648,7 @@ static int __w1_attach_slave_device(struct w1_slave *sl)
 	return 0;
 
 out_rem2:
-	sysfs_remove_bin_file(&sl->dev.kobj, &w1_slave_attr_bin_id);
+	device_remove_file(&sl->dev, &w1_slave_attr_id);
 out_rem1:
 	device_remove_file(&sl->dev, &w1_slave_attr_name);
 out_unreg:
@@ -745,7 +730,7 @@ void w1_slave_detach(struct w1_slave *sl)
 	msg.type = W1_SLAVE_REMOVE;
 	w1_netlink_send(sl->master, &msg);
 
-	sysfs_remove_bin_file(&sl->dev.kobj, &w1_slave_attr_bin_id);
+	device_remove_file(&sl->dev, &w1_slave_attr_id);
 	device_remove_file(&sl->dev, &w1_slave_attr_name);
 	device_unregister(&sl->dev);
 
-- 
1.4.4.4

