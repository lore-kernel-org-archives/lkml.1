Return-Path: <linux-kernel-owner+w=401wt.eu-S935135AbYETWiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935135AbYETWiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934901AbYETWgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:36:00 -0400
Received: from mx1.suse.de ([195.135.220.2]:53326 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935012AbYETWf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:35:57 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH 06/13] LEDS: fix race in device_create
Date: Tue, 20 May 2008 15:34:53 -0700
Message-Id: <1211322900-12705-6-git-send-email-gregkh@suse.de>
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
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/leds/led-class.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index b3c54be..559a408 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -103,13 +103,11 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 {
 	int rc;
 
-	led_cdev->dev = device_create(leds_class, parent, 0, "%s",
-					    led_cdev->name);
+	led_cdev->dev = device_create_drvdata(leds_class, parent, 0, led_cdev,
+					      "%s", led_cdev->name);
 	if (IS_ERR(led_cdev->dev))
 		return PTR_ERR(led_cdev->dev);
 
-	dev_set_drvdata(led_cdev->dev, led_cdev);
-
 	/* register the attributes */
 	rc = device_create_file(led_cdev->dev, &dev_attr_brightness);
 	if (rc)
-- 
1.5.5.1

