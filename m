Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbYEZGQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbYEZGQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 02:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYEZGQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 02:16:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53135 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbYEZGQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 02:16:35 -0400
Message-ID: <483A5517.5080204@cn.fujitsu.com>
Date: Mon, 26 May 2008 14:13:43 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Markus Lidel <Markus.Lidel@shadowconnect.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] I2O: Take care of the fail of sysfs_create_link()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile warning:
ignoring return value of `sysfs_create_link', declared with attribute warn_unused_result.

If sysfs_create_link failed, take care of the return value and do some error
handle after the fail.
Since sysfs_remove_link() will check whether a link exists, when remove the
link in error path, we don't need to care whether a link was created.

Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
---
 drivers/message/i2o/device.c |   54 ++++++++++++++++++++++++++++++++---------
 1 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/drivers/message/i2o/device.c b/drivers/message/i2o/device.c
index 489d7c5..8774c67 100644
--- a/drivers/message/i2o/device.c
+++ b/drivers/message/i2o/device.c
@@ -243,29 +243,41 @@ static int i2o_device_add(struct i2o_controller *c, i2o_lct_entry *entry)
 
 	/* create user entries for this device */
 	tmp = i2o_iop_find_device(i2o_dev->iop, i2o_dev->lct_data.user_tid);
-	if (tmp && (tmp != i2o_dev))
-		sysfs_create_link(&i2o_dev->device.kobj, &tmp->device.kobj,
-				  "user");
+	if (tmp && (tmp != i2o_dev)) {
+		rc = sysfs_create_link(&i2o_dev->device.kobj,
+				       &tmp->device.kobj, "user");
+		if (rc)
+			goto unreg_dev;
+	}
 
 	/* create user entries refering to this device */
 	list_for_each_entry(tmp, &c->devices, list)
 	    if ((tmp->lct_data.user_tid == i2o_dev->lct_data.tid)
-		&& (tmp != i2o_dev))
-		sysfs_create_link(&tmp->device.kobj,
-				  &i2o_dev->device.kobj, "user");
+		&& (tmp != i2o_dev)) {
+		rc = sysfs_create_link(&tmp->device.kobj,
+				       &i2o_dev->device.kobj, "user");
+		if (rc)
+			goto rmlink1;
+	}
 
 	/* create parent entries for this device */
 	tmp = i2o_iop_find_device(i2o_dev->iop, i2o_dev->lct_data.parent_tid);
-	if (tmp && (tmp != i2o_dev))
-		sysfs_create_link(&i2o_dev->device.kobj, &tmp->device.kobj,
-				  "parent");
+	if (tmp && (tmp != i2o_dev)) {
+		rc = sysfs_create_link(&i2o_dev->device.kobj,
+				       &tmp->device.kobj, "parent");
+		if (rc)
+			goto rmlink1;
+	}
 
 	/* create parent entries refering to this device */
 	list_for_each_entry(tmp, &c->devices, list)
 	    if ((tmp->lct_data.parent_tid == i2o_dev->lct_data.tid)
-		&& (tmp != i2o_dev))
-		sysfs_create_link(&tmp->device.kobj,
-				  &i2o_dev->device.kobj, "parent");
+		&& (tmp != i2o_dev)) {
+		rc = sysfs_create_link(&tmp->device.kobj,
+				       &i2o_dev->device.kobj, "parent");
+		if (rc)
+			goto rmlink2;
+	}
 
 	i2o_driver_notify_device_add_all(i2o_dev);
 
@@ -273,6 +285,24 @@ static int i2o_device_add(struct i2o_controller *c, i2o_lct_entry *entry)
 
 	return 0;
 
+rmlink2:
+	/* If link creating failed halfway, we loop whole list to cleanup.
+	 * And we don't care wrong removing of link, because sysfs_remove_link
+	 * will take care of it.
+	 */
+	list_for_each_entry(tmp, &c->devices, list) {
+		if (tmp->lct_data.parent_tid == i2o_dev->lct_data.tid)
+			sysfs_remove_link(&tmp->device.kobj, "parent");
+	}
+	sysfs_remove_link(&i2o_dev->device.kobj, "parent");
+rmlink1:
+	list_for_each_entry(tmp, &c->devices, list)
+		if (tmp->lct_data.user_tid == i2o_dev->lct_data.tid)
+			sysfs_remove_link(&tmp->device.kobj, "user");
+	sysfs_remove_link(&i2o_dev->device.kobj, "user");
+unreg_dev:
+	list_del(&i2o_dev->list);
+	device_unregister(&i2o_dev->device);
 err:
 	kfree(i2o_dev);
 	return rc;
-- 
1.5.3.4

