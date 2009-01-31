Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbZAaOss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbZAaOss (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 09:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbZAaOsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 09:48:41 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:6610 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbZAaOsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 09:48:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=JX20iqkGbQt0bN89xWm2z4wK4D4MdnUnAVKamhzqXGwrrcerbmcMuXybHFH84vMbHA
         za/CMZDUG1VnlwCrBqqgqJrpDvKp20r+m7C+zrAZmO/q16OK+hOfpxr6vlPaWf3hFmNU
         t5T8LzrKj/fAPdFNdgxys7yPEeTkfURNzLvA0=
Message-ID: <49846490.1040302@gmail.com>
Date: Sat, 31 Jan 2009 22:47:44 +0800
From: Eric Miao <eric.y.miao@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 1/2 RESEND] platform: make better use of to_platform_{device,driver}()
 macros
Content-Type: multipart/mixed;
 boundary="------------070109080404030703090900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070109080404030703090900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


--------------070109080404030703090900
Content-Type: text/x-diff;
 name="0001-platform-make-better-use-of-to_platform_-device-dri.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-platform-make-better-use-of-to_platform_-device-dri.pat";
 filename*1="ch"

>From 03b31ce7cc204353e73b39a2c0f3aba68ab07883 Mon Sep 17 00:00:00 2001
From: Eric Miao <eric.miao@marvell.com>
Date: Tue, 30 Dec 2008 13:49:17 +0800
Subject: platform: make better use of to_platform_{device,driver}() macros

This helps the code look more consistent and cleaner.

Signed-off-by: Eric Miao <eric.miao@marvell.com>
---
 drivers/base/platform.c            |   21 +++++++++------------
 drivers/block/floppy.c             |    3 +--
 drivers/isdn/gigaset/ser-gigaset.c |    3 +--
 3 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index dfcbfe5..d0591f0 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -606,9 +606,8 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
  */
 static int platform_match(struct device *dev, struct device_driver *drv)
 {
-	struct platform_device *pdev;
+	struct platform_device *pdev = to_platform_device(dev);
 
-	pdev = container_of(dev, struct platform_device, dev);
 	return (strncmp(pdev->name, drv->name, BUS_ID_SIZE) == 0);
 }
 
@@ -626,26 +625,24 @@ static int platform_legacy_suspend(struct device *dev, pm_message_t mesg)
 
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
index cf29cc4..9c3c5c7 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4133,10 +4133,9 @@ static int have_no_fdc = -ENODEV;
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
1.6.0.4


--------------070109080404030703090900--
