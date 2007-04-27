Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbXD0OPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbXD0OPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755858AbXD0OFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:05:53 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:31115 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862AbXD0OEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:04:55 -0400
Message-Id: <20070427140513.365580530@de.ibm.com>
References: <20070427140503.087958775@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Apr 2007 16:05:10 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 07/38] cio: Clean up online_store.
Content-Disposition: inline; filename=105-cio-cleanup-online.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Detangle the online_store code and make it more readable.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/device.c |  109 ++++++++++++++++++++++++++--------------------
 1 files changed, 62 insertions(+), 47 deletions(-)

Index: quilt-2.6/drivers/s390/cio/device.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/device.c	2007-04-27 16:01:49.000000000 +0200
+++ quilt-2.6/drivers/s390/cio/device.c	2007-04-27 16:04:53.000000000 +0200
@@ -413,11 +413,60 @@
 	return (ret == 0) ? -ENODEV : ret;
 }
 
-static ssize_t
-online_store (struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
+static void online_store_handle_offline(struct ccw_device *cdev)
+{
+	if (cdev->private->state == DEV_STATE_DISCONNECTED)
+		ccw_device_remove_disconnected(cdev);
+	else if (cdev->drv && cdev->drv->set_offline)
+		ccw_device_set_offline(cdev);
+}
+
+static int online_store_recog_and_online(struct ccw_device *cdev)
+{
+	int ret;
+
+	/* Do device recognition, if needed. */
+	if (cdev->id.cu_type == 0) {
+		ret = ccw_device_recognition(cdev);
+		if (ret) {
+			printk(KERN_WARNING"Couldn't start recognition "
+			       "for device %s (ret=%d)\n",
+			       cdev->dev.bus_id, ret);
+			return ret;
+		}
+		wait_event(cdev->private->wait_q,
+			   cdev->private->flags.recog_done);
+	}
+	if (cdev->drv && cdev->drv->set_online)
+		ccw_device_set_online(cdev);
+	return 0;
+}
+static void online_store_handle_online(struct ccw_device *cdev, int force)
+{
+	int ret;
+
+	ret = online_store_recog_and_online(cdev);
+	if (ret)
+		return;
+	if (force && cdev->private->state == DEV_STATE_BOXED) {
+		ret = ccw_device_stlck(cdev);
+		if (ret) {
+			printk(KERN_WARNING"ccw_device_stlck for device %s "
+			       "returned %d!\n", cdev->dev.bus_id, ret);
+			return;
+		}
+		if (cdev->id.cu_type == 0)
+			cdev->private->state = DEV_STATE_NOT_OPER;
+		online_store_recog_and_online(cdev);
+	}
+
+}
+
+static ssize_t online_store (struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t count)
 {
 	struct ccw_device *cdev = to_ccwdev(dev);
-	int i, force, ret;
+	int i, force;
 	char *tmp;
 
 	if (atomic_cmpxchg(&cdev->private->onoff, 0, 1) != 0)
@@ -434,51 +483,17 @@
 		force = 0;
 		i = simple_strtoul(buf, &tmp, 16);
 	}
-	if (i == 1) {
-		/* Do device recognition, if needed. */
-		if (cdev->id.cu_type == 0) {
-			ret = ccw_device_recognition(cdev);
-			if (ret) {
-				printk(KERN_WARNING"Couldn't start recognition "
-				       "for device %s (ret=%d)\n",
-				       cdev->dev.bus_id, ret);
-				goto out;
-			}
-			wait_event(cdev->private->wait_q,
-				   cdev->private->flags.recog_done);
-		}
-		if (cdev->drv && cdev->drv->set_online)
-			ccw_device_set_online(cdev);
-	} else if (i == 0) {
-		if (cdev->private->state == DEV_STATE_DISCONNECTED)
-			ccw_device_remove_disconnected(cdev);
-		else if (cdev->drv && cdev->drv->set_offline)
-			ccw_device_set_offline(cdev);
-	}
-	if (force && cdev->private->state == DEV_STATE_BOXED) {
-		ret = ccw_device_stlck(cdev);
-		if (ret) {
-			printk(KERN_WARNING"ccw_device_stlck for device %s "
-			       "returned %d!\n", cdev->dev.bus_id, ret);
-			goto out;
-		}
-		/* Do device recognition, if needed. */
-		if (cdev->id.cu_type == 0) {
-			cdev->private->state = DEV_STATE_NOT_OPER;
-			ret = ccw_device_recognition(cdev);
-			if (ret) {
-				printk(KERN_WARNING"Couldn't start recognition "
-				       "for device %s (ret=%d)\n",
-				       cdev->dev.bus_id, ret);
-				goto out;
-			}
-			wait_event(cdev->private->wait_q,
-				   cdev->private->flags.recog_done);
-		}
-		if (cdev->drv && cdev->drv->set_online)
-			ccw_device_set_online(cdev);
+
+	switch (i) {
+	case 0:
+		online_store_handle_offline(cdev);
+		break;
+	case 1:
+		online_store_handle_online(cdev, force);
+		break;
+	default:
+		count = -EINVAL;
 	}
-	out:
 	if (cdev->drv)
 		module_put(cdev->drv->owner);
 	atomic_set(&cdev->private->onoff, 0);

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

