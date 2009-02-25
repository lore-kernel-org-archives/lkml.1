Return-Path: <linux-kernel-owner+w=401wt.eu-S1762665AbZBYPOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762665AbZBYPOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756583AbZBYPJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:09:10 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:58559 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804AbZBYPIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:08:41 -0500
Message-Id: <20090225150834.724805310@de.ibm.com>
References: <20090225150622.529143164@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 25 Feb 2009 16:06:49 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Sebastian Ott <sebott@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch/s390 27/46] cio: ccw device online store - report rc from ccw driver.
Content-Disposition: inline; filename=126-cio-online-rc.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Ott <sebott@linux.vnet.ibm.com>

In case the ccw driver refuses to set a device offline, we should
transmit the return code to the caller.

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/device.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

Index: quilt-2.6/drivers/s390/cio/device.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/device.c
+++ quilt-2.6/drivers/s390/cio/device.c
@@ -457,12 +457,13 @@ int ccw_device_set_online(struct ccw_dev
 	return (ret == 0) ? -ENODEV : ret;
 }
 
-static void online_store_handle_offline(struct ccw_device *cdev)
+static int online_store_handle_offline(struct ccw_device *cdev)
 {
 	if (cdev->private->state == DEV_STATE_DISCONNECTED)
 		ccw_device_remove_disconnected(cdev);
-	else if (cdev->drv && cdev->drv->set_offline)
-		ccw_device_set_offline(cdev);
+	else if (cdev->online && cdev->drv && cdev->drv->set_offline)
+		return ccw_device_set_offline(cdev);
+	return 0;
 }
 
 static int online_store_recog_and_online(struct ccw_device *cdev)
@@ -530,13 +531,10 @@ static ssize_t online_store (struct devi
 		goto out;
 	switch (i) {
 	case 0:
-		online_store_handle_offline(cdev);
-		ret = count;
+		ret = online_store_handle_offline(cdev);
 		break;
 	case 1:
 		ret = online_store_handle_online(cdev, force);
-		if (!ret)
-			ret = count;
 		break;
 	default:
 		ret = -EINVAL;
@@ -545,7 +543,7 @@ out:
 	if (cdev->drv)
 		module_put(cdev->drv->owner);
 	atomic_set(&cdev->private->onoff, 0);
-	return ret;
+	return (ret < 0) ? ret : count;
 }
 
 static ssize_t

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

