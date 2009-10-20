Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbZJTRHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbZJTRHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 13:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbZJTRHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 13:07:19 -0400
Received: from gateway-1237.mvista.com ([206.112.117.35]:50548 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751855AbZJTRHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 13:07:18 -0400
X-Greylist: delayed 1918 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Oct 2009 13:07:07 EDT
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
To: linux-kernel@vger.kernel.org
Subject: [PATCH] gpiolib: fix device_create() result check
Date: Tue, 20 Oct 2009 20:35:23 +0400
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Cc: david-b@pacbell.net, akpm@linux-foundation.org
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910202035.23981.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of failure, device_create() returns not NULL but the error code.
The current code checks for non-NULL though which causes kernel oops in
sysfs_create_group() when device_create() fails.  Check for error using
IS_ERR() and propagate the error value using PTR_ERR() instead of fixed
-ENODEV code returned now...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

 drivers/gpio/gpiolib.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/gpio/gpiolib.c
===================================================================
--- linux-2.6.orig/drivers/gpio/gpiolib.c
+++ linux-2.6/drivers/gpio/gpiolib.c
@@ -661,7 +661,7 @@ int gpio_export(unsigned gpio, bool dire
 
 		dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
 				desc, ioname ? ioname : "gpio%d", gpio);
-		if (dev) {
+		if (!IS_ERR(dev)) {
 			if (direction_may_change)
 				status = sysfs_create_group(&dev->kobj,
 						&gpio_attr_group);
@@ -679,7 +679,7 @@ int gpio_export(unsigned gpio, bool dire
 			if (status != 0)
 				device_unregister(dev);
 		} else
-			status = -ENODEV;
+			status = PTR_ERR(dev);
 		if (status == 0)
 			set_bit(FLAG_EXPORT, &desc->flags);
 	}
@@ -800,11 +800,11 @@ static int gpiochip_export(struct gpio_c
 	mutex_lock(&sysfs_lock);
 	dev = device_create(&gpio_class, chip->dev, MKDEV(0, 0), chip,
 				"gpiochip%d", chip->base);
-	if (dev) {
+	if (!IS_ERR(dev)) {
 		status = sysfs_create_group(&dev->kobj,
 				&gpiochip_attr_group);
 	} else
-		status = -ENODEV;
+		status = PTR_ERR(dev);
 	chip->exported = (status == 0);
 	mutex_unlock(&sysfs_lock);
 

