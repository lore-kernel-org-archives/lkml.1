Return-Path: <linux-kernel-owner+w=401wt.eu-S935069AbYETWlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935069AbYETWlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935139AbYETWgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:36:48 -0400
Received: from ns.suse.de ([195.135.220.2]:53617 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935039AbYETWgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:36:47 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Sean Young <sean@mess.org>
Subject: [PATCH 11/13] USB: Phidget: fix race in device_create
Date: Tue, 20 May 2008 15:34:58 -0700
Message-Id: <1211322900-12705-11-git-send-email-gregkh@suse.de>
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
device_create_drvdata().  It fixes all 3 phidget drivers, which all have
the same problem.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Sean Young <sean@mess.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/misc/phidgetkit.c          |    6 +++---
 drivers/usb/misc/phidgetmotorcontrol.c |    7 +++----
 drivers/usb/misc/phidgetservo.c        |    6 +++---
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/misc/phidgetkit.c b/drivers/usb/misc/phidgetkit.c
index 24230c6..4cfa25b 100644
--- a/drivers/usb/misc/phidgetkit.c
+++ b/drivers/usb/misc/phidgetkit.c
@@ -595,14 +595,14 @@ static int interfacekit_probe(struct usb_interface *intf, const struct usb_devic
         } while(value);
         kit->dev_no = bit;
 
-        kit->dev = device_create(phidget_class, &kit->udev->dev, 0,
-               		"interfacekit%d", kit->dev_no);
+	kit->dev = device_create_drvdata(phidget_class, &kit->udev->dev,
+					MKDEV(0, 0), kit,
+					"interfacekit%d", kit->dev_no);
         if (IS_ERR(kit->dev)) {
                 rc = PTR_ERR(kit->dev);
                 kit->dev = NULL;
                 goto out;
         }
-	dev_set_drvdata(kit->dev, kit);
 
 	if (usb_submit_urb(kit->irq, GFP_KERNEL)) {
 		rc = -EIO;
diff --git a/drivers/usb/misc/phidgetmotorcontrol.c b/drivers/usb/misc/phidgetmotorcontrol.c
index f0113c1..9b4696f 100644
--- a/drivers/usb/misc/phidgetmotorcontrol.c
+++ b/drivers/usb/misc/phidgetmotorcontrol.c
@@ -365,16 +365,15 @@ static int motorcontrol_probe(struct usb_interface *intf, const struct usb_devic
 	} while(value);
 	mc->dev_no = bit;
 
-	mc->dev = device_create(phidget_class, &mc->udev->dev, 0,
-				"motorcontrol%d", mc->dev_no);
+	mc->dev = device_create_drvdata(phidget_class, &mc->udev->dev,
+					MKDEV(0, 0), mc,
+					"motorcontrol%d", mc->dev_no);
 	if (IS_ERR(mc->dev)) {
 		rc = PTR_ERR(mc->dev);
 		mc->dev = NULL;
 		goto out;
 	}
 
-	dev_set_drvdata(mc->dev, mc);
-
 	if (usb_submit_urb(mc->irq, GFP_KERNEL)) {
 		rc = -EIO;
 		goto out;
diff --git a/drivers/usb/misc/phidgetservo.c b/drivers/usb/misc/phidgetservo.c
index 7d590c0..1ca7ddb 100644
--- a/drivers/usb/misc/phidgetservo.c
+++ b/drivers/usb/misc/phidgetservo.c
@@ -275,14 +275,14 @@ servo_probe(struct usb_interface *interface, const struct usb_device_id *id)
         } while (value);
 	dev->dev_no = bit;
 
-	dev->dev = device_create(phidget_class, &dev->udev->dev, 0,
-				 "servo%d", dev->dev_no);
+	dev->dev = device_create_drvdata(phidget_class, &dev->udev->dev,
+					 MKDEV(0, 0), dev,
+					 "servo%d", dev->dev_no);
 	if (IS_ERR(dev->dev)) {
 		rc = PTR_ERR(dev->dev);
 		dev->dev = NULL;
 		goto out;
 	}
-	dev_set_drvdata(dev->dev, dev);
 
 	servo_count = dev->type & SERVO_COUNT_QUAD ? 4 : 1;
 
-- 
1.5.5.1

