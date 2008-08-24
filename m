Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbYHXFhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbYHXFhB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 01:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbYHXFgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 01:36:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751705AbYHXFgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 01:36:52 -0400
Date: Sat, 23 Aug 2008 22:36:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Constantin Baranov <const@const.mimas.ru>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: [PATCH 2.6.27-rc3] led: driver for LEDs on PCEngines ALIX.2 and
 ALIX.3 boards
Message-Id: <20080823223606.79f6d4da.akpm@linux-foundation.org>
In-Reply-To: <48B044DC.5040700@const.mimas.ru>
References: <48AB019D.6080302@const.mimas.ru>
	<20080822115150.6b3907a4.akpm@linux-foundation.org>
	<48AF2ABF.8080901@const.mimas.ru>
	<20080822143143.4202f940.akpm@linux-foundation.org>
	<48B044DC.5040700@const.mimas.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Aug 2008 22:11:56 +0500 Constantin Baranov <const@const.mimas.ru> wrote:

> > For example, this?
> > 
> > static int __init alix_led_probe(struct platform_device *pdev)
> > {
> > 	int i;
> > 	int ret;
> > 
> > 	for (i = 0; i < ARRAY_SIZE(alix_leds); i++) {
> > 		ret = led_classdev_register(&pdev->dev, &alix_leds[i].cdev);
> > 		if (ret < 0)
> > 			goto fail;
> > 	}
> > 	return 0;
> > 
> > fail:
> > 	while (--i >= 0)
> > 		led_classdev_unregister(&alix_leds[i].cdev);
> > 	return ret;
> > }
> > 
> > (note there's no longer a need for a fake initalisation of `ret')
> > 
> >> Note that probe routine originates from leds-ams-delta.c.
> > 
> > That's what you get for copying stuff :(
> 
> Well, this variant looks better and correct and still works.
> Should I post again patch or fix-patch?

I already queued that as an incremental:

--- a/drivers/leds/leds-alix.c~led-driver-for-leds-on-pcengines-alix2-and-alix3-boards-fix
+++ a/drivers/leds/leds-alix.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2008 Constantin Baranov <const@tltsu.ru>
  */
 
-#include <asm/io.h>
+#include <linux/io.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/leds.h>
@@ -22,6 +22,7 @@ static void alix_led_set(struct led_clas
 {
 	struct alix_led *led_dev =
 		container_of(led_cdev, struct alix_led, cdev);
+
 	if (brightness)
 		outl(led_dev->on_value, led_dev->port);
 	else
@@ -63,6 +64,7 @@ static struct alix_led alix_leds[] = {
 static int alix_led_suspend(struct platform_device *dev, pm_message_t state)
 {
 	int i;
+
 	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
 		led_classdev_suspend(&alix_leds[i].cdev);
 	return 0;
@@ -71,6 +73,7 @@ static int alix_led_suspend(struct platf
 static int alix_led_resume(struct platform_device *dev)
 {
 	int i;
+
 	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
 		led_classdev_resume(&alix_leds[i].cdev);
 	return 0;
@@ -86,22 +89,25 @@ static int alix_led_resume(struct platfo
 static int __init alix_led_probe(struct platform_device *pdev)
 {
 	int i;
-	int ret = 0;
+	int ret;
 
-	for (i = 0; i < ARRAY_SIZE(alix_leds) && ret >= 0; i++)
+	for (i = 0; i < ARRAY_SIZE(alix_leds); i++) {
 		ret = led_classdev_register(&pdev->dev, &alix_leds[i].cdev);
-
-	if (ret < 0) {
-		for (i = i - 2; i >= 0; i--)
-			led_classdev_unregister(&alix_leds[i].cdev);
+		if (ret < 0)
+			goto fail;
 	}
+	return 0;
 
+fail:
+	while (--i >= 0)
+		led_classdev_unregister(&alix_leds[i].cdev);
 	return ret;
 }
 
 static int alix_led_remove(struct platform_device *pdev)
 {
 	int i;
+
 	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
 		led_classdev_unregister(&alix_leds[i].cdev);
 	return 0;
@@ -122,6 +128,7 @@ static struct platform_device *pdev;
 static int __init alix_led_init(void)
 {
 	int ret;
+
 	pdev = platform_device_register_simple(KBUILD_MODNAME, -1, NULL, 0);
 	if (!IS_ERR(pdev)) {
 		ret = platform_driver_probe(&alix_led_driver, alix_led_probe);
_

