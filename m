Return-Path: <linux-kernel-owner+w=401wt.eu-S935153AbYETWgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935153AbYETWgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934985AbYETWfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:35:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:39696 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763870AbYETWfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:35:46 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       James Simmons <jsimmons@infradead.org>
Subject: [PATCH 03/13] fbdev: fix race in device_create
Date: Tue, 20 May 2008 15:34:50 -0700
Message-Id: <1211322900-12705-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080520223237.GA12383@suse.de>
References: <20080520223237.GA12383@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race from when a device is created with device_create() and
then the drvdata is set with a call to dev_set_drvdata() in which a
sysfs file could be open, yet the drvdata will be NULL, causing all
sorts of bad things to happen.

This patch fixes the problem by using the new function,
device_create_drvdata().

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Simmons <jsimmons@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/video/display/display-sysfs.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/video/display/display-sysfs.c b/drivers/video/display/display-sysfs.c
index 3547717..6ef800b 100644
--- a/drivers/video/display/display-sysfs.c
+++ b/drivers/video/display/display-sysfs.c
@@ -26,6 +26,7 @@
 #include <linux/ctype.h>
 #include <linux/idr.h>
 #include <linux/err.h>
+#include <linux/kdev_t.h>
 
 static ssize_t display_show_name(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -152,10 +153,13 @@ struct display_device *display_device_register(struct display_driver *driver,
 		mutex_unlock(&allocated_dsp_lock);
 
 		if (!ret) {
-			new_dev->dev = device_create(display_class, parent, 0,
-						"display%d", new_dev->idx);
+			new_dev->dev = device_create_drvdata(display_class,
+							     parent,
+							     MKDEV(0,0),
+							     new_dev,
+							     "display%d",
+							     new_dev->idx);
 			if (!IS_ERR(new_dev->dev)) {
-				dev_set_drvdata(new_dev->dev, new_dev);
 				new_dev->parent = parent;
 				new_dev->driver = driver;
 				mutex_init(&new_dev->lock);
-- 
1.5.5.1

