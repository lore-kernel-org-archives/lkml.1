Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbZEKTH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbZEKTH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZEKTHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:07:11 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:57669 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbZEKTHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:07:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=SJkDuc0lVN/MOkCZ6lob5TNyXI1e1HTB5N8x1xHQrlvb3GL7aK9bDEnpDg+68nJ7rc
         JxIesE2yQtA61oEUvgFatejFsaTZPZr2v9J3Kl9uxhKRtyoPtGSkPblDrsWpeN//A3QR
         OIHdYWCZ/IsLqcGfLTkBZiwyIBb3A3D8OuF/U=
Message-ID: <4A08775C.20305@gmail.com>
Date: Mon, 11 May 2009 21:07:08 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: jeremy@xensource.com
CC: virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen pvfb: remove driver_data direct access of struct device
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid direct access to the driver_data pointer in struct device, the
functions dev_get_drvdata() and dev_set_drvdata() should be used.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index 928d2ed..b115726 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -114,7 +114,7 @@ static int __devinit xenkbd_probe(struct xenbus_device *dev,
 		xenbus_dev_fatal(dev, -ENOMEM, "allocating info structure");
 		return -ENOMEM;
 	}
-	dev->dev.driver_data = info;
+	dev_set_drvdata(&dev->dev, info);
 	info->xbdev = dev;
 	info->irq = -1;
 	snprintf(info->phys, sizeof(info->phys), "xenbus/%s", dev->nodename);
@@ -186,7 +186,7 @@ static int __devinit xenkbd_probe(struct xenbus_device *dev,
 
 static int xenkbd_resume(struct xenbus_device *dev)
 {
-	struct xenkbd_info *info = dev->dev.driver_data;
+	struct xenkbd_info *info = dev_get_drvdata(&dev->dev);
 
 	xenkbd_disconnect_backend(info);
 	memset(info->page, 0, PAGE_SIZE);
@@ -195,7 +195,7 @@ static int xenkbd_resume(struct xenbus_device *dev)
 
 static int xenkbd_remove(struct xenbus_device *dev)
 {
-	struct xenkbd_info *info = dev->dev.driver_data;
+	struct xenkbd_info *info = dev_get_drvdata(&dev->dev);
 
 	xenkbd_disconnect_backend(info);
 	if (info->kbd)
@@ -266,7 +266,7 @@ static void xenkbd_disconnect_backend(struct xenkbd_info *info)
 static void xenkbd_backend_changed(struct xenbus_device *dev,
 				   enum xenbus_state backend_state)
 {
-	struct xenkbd_info *info = dev->dev.driver_data;
+	struct xenkbd_info *info = dev_get_drvdata(&dev->dev);
 	int ret, val;
 
 	switch (backend_state) {
