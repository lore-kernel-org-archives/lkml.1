Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbYGLG2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbYGLG2g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 02:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbYGLG21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 02:28:27 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:26424 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751653AbYGLG21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 02:28:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:To:Subject:Cc:Content-Disposition:From:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=6fcaw3J6gy1Fi6IhOEyVN9agHoeQWNlQqaUyHpYYqZbibx/5KMdO/zaKpbdtWifrUWrXHBUzzxZnSKL/zJcN9BMKGu7m/jdnibmA9+vUtnx3Ew5gAVnxdmv2bX7RwIO+OASvxdYOw9Uzf7zBgMUAQHwaVKMmqCuRjpjqr8terRc=  ;
X-YMail-OSG: RTCsyV8VM1nOWTbYXo7EZ0nIPxN4pi1VT4v4us1BmnGENoS6iX1iIRIHq5fXuouEs5gFERNcIqhJgUcwUB4qdfmCHFR6yvL3VJwfrEgWMHKcQx9V5JHrtn.aQKSd84MSi1A-
X-Yahoo-Newman-Property: ymail-3
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2.6.26-mm-latest] gpio: linux-next fixes for sysfs support
Cc: Michael Buesch <mb@bu3sch.de>, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org
Content-Disposition: inline
From: David Brownell <david-b@pacbell.net>
Date: Fri, 11 Jul 2008 23:28:20 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200807112328.20376.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cope with some backwards-incompatible driver model API changes
now in the linux-next tree:

 - device_create() is going away, even for drivers using it safely,
   in favor of device_create_drvdata().
 - class->devices is gone, but testing class->p serves the same
   purpose (non-null when class is usable with driver model calls).
 - class_find_device() needs a new argument #2 (NULL)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/gpio/gpiolib.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/drivers/gpio/gpiolib.c	2008-07-02 23:29:58.000000000 -0700
+++ b/drivers/gpio/gpiolib.c	2008-07-03 00:04:57.000000000 -0700
@@ -429,7 +429,7 @@ int gpio_export(unsigned gpio, bool dire
 	int			status = -EINVAL;
 
 	/* can't export until sysfs is available ... */
-	if (!gpio_class.devices.next) {
+	if (!gpio_class.p) {
 		pr_debug("%s: called too early!\n", __func__);
 		return -ENOENT;
 	}
@@ -453,10 +453,9 @@ int gpio_export(unsigned gpio, bool dire
 	if (status == 0) {
 		struct device	*dev;
 
-		dev = device_create(&gpio_class, desc->chip->dev, 0,
-				"gpio%d", gpio);
+		dev = device_create_drvdata(&gpio_class, desc->chip->dev, 0,
+				desc, "gpio%d", gpio);
 		if (dev) {
-			dev_set_drvdata(dev, desc);
 			if (direction_may_change)
 				status = sysfs_create_group(&dev->kobj,
 						&gpio_attr_group);
@@ -506,7 +505,7 @@ void gpio_unexport(unsigned gpio)
 	if (test_bit(FLAG_EXPORT, &desc->flags)) {
 		struct device	*dev = NULL;
 
-		dev = class_find_device(&gpio_class, desc, match_export);
+		dev = class_find_device(&gpio_class, NULL, desc, match_export);
 		if (dev) {
 			clear_bit(FLAG_EXPORT, &desc->flags);
 			put_device(dev);
@@ -533,15 +532,14 @@ static int gpiochip_export(struct gpio_c
 	 * export this later, in gpiolib_sysfs_init() ... here we just
 	 * verify that _some_ field of gpio_class got initialized.
 	 */
-	if (!gpio_class.devices.next)
+	if (!gpio_class.p)
 		return 0;
 
 	/* use chip->base for the ID; it's already known to be unique */
 	mutex_lock(&sysfs_lock);
-	dev = device_create(&gpio_class, chip->dev, 0,
+	dev = device_create_drvdata(&gpio_class, chip->dev, 0, chip,
 			"gpiochip%d", chip->base);
 	if (dev) {
-		dev_set_drvdata(dev, chip);
 		status = sysfs_create_group(&dev->kobj,
 				&gpiochip_attr_group);
 	} else
@@ -572,7 +570,7 @@ static void gpiochip_unexport(struct gpi
 	struct device		*dev;
 
 	mutex_lock(&sysfs_lock);
-	dev = class_find_device(&gpio_class, chip, match_export);
+	dev = class_find_device(&gpio_class, NULL, chip, match_export);
 	if (dev) {
 		put_device(dev);
 		device_unregister(dev);

