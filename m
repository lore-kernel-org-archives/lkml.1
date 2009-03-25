Return-Path: <linux-kernel-owner+w=401wt.eu-S1758790AbZCYAlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790AbZCYAlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbZCYAaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:14 -0400
Received: from kroah.org ([198.145.64.141]:54127 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756849AbZCYAaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:06 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.miao@marvell.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 33/61] platform: make better use of to_platform_{device,driver}() macros
Date: Tue, 24 Mar 2009 17:26:37 -0700
Message-Id: <1237940825-22904-33-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Miao <eric.miao@marvell.com>

This helps the code look more consistent and cleaner.

Signed-off-by: Eric Miao <eric.miao@marvell.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c            |   21 +++++++++------------
 drivers/block/floppy.c             |    3 +--
 drivers/isdn/gigaset/ser-gigaset.c |    3 +--
 3 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 349a101..62a8768 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -603,9 +603,8 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
  */
 static int platform_match(struct device *dev, struct device_driver *drv)
 {
-	struct platform_device *pdev;
+	struct platform_device *pdev = to_platform_device(dev);
 
-	pdev = container_of(dev, struct platform_device, dev);
 	return (strcmp(pdev->name, drv->name) == 0);
 }
 
@@ -623,26 +622,24 @@ static int platform_legacy_suspend(struct device *dev, pm_message_t mesg)
 
 static int platform_legacy_suspend_late(struct device *dev, pm_message_t mesg)
 {
-	struct platform_driver *drv = to_platform_driver(dev->driver);
-	struct platform_device *pdev;
+	struct platform_driver *pdrv = to_platform_driver(dev->driver);
+	struct platform_device *pdev = to_platform_device(dev);
 	int ret = 0;
 
-	pdev = container_of(dev, struct platform_device, dev);
-	if (dev->driver && drv->suspend_late)
-		ret = drv->suspend_late(pdev, mesg);
+	if (dev->driver && pdrv->suspend_late)
+		ret = pdrv->suspend_late(pdev, mesg);
 
 	return ret;
 }
 
 static int platform_legacy_resume_early(struct device *dev)
 {
-	struct platform_driver *drv = to_platform_driver(dev->driver);
-	struct platform_device *pdev;
+	struct platform_driver *pdrv = to_platform_driver(dev->driver);
+	struct platform_device *pdev = to_platform_device(dev);
 	int ret = 0;
 
-	pdev = container_of(dev, struct platform_device, dev);
-	if (dev->driver && drv->resume_early)
-		ret = drv->resume_early(pdev);
+	if (dev->driver && pdrv->resume_early)
+		ret = pdrv->resume_early(pdev);
 
 	return ret;
 }
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 83d8ed3..c2c95e6 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4135,10 +4135,9 @@ static int have_no_fdc = -ENODEV;
 static ssize_t floppy_cmos_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	struct platform_device *p;
+	struct platform_device *p = to_platform_device(dev);
 	int drive;
 
-	p = container_of(dev, struct platform_device,dev);
 	drive = p->id;
 	return sprintf(buf, "%X\n", UDP->cmos);
 }
diff --git a/drivers/isdn/gigaset/ser-gigaset.c b/drivers/isdn/gigaset/ser-gigaset.c
index ac245e7..3071a52 100644
--- a/drivers/isdn/gigaset/ser-gigaset.c
+++ b/drivers/isdn/gigaset/ser-gigaset.c
@@ -389,8 +389,7 @@ static void gigaset_freecshw(struct cardstate *cs)
 
 static void gigaset_device_release(struct device *dev)
 {
-	struct platform_device *pdev =
-		container_of(dev, struct platform_device, dev);
+	struct platform_device *pdev = to_platform_device(dev);
 
 	/* adapted from platform_device_release() in drivers/base/platform.c */
 	//FIXME is this actually necessary?
-- 
1.6.2

