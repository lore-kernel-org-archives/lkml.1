Return-Path: <linux-kernel-owner+w=401wt.eu-S1759359AbZCWUsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359AbZCWUsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758778AbZCWUsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:48:04 -0400
Received: from 130.120.124.202.static.snap.net.nz ([202.124.120.130]:38569
	"EHLO hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758892AbZCWUsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:48:01 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Mar 2009 16:48:01 EDT
Message-ID: <49C7F446.50803@bluewatersys.com>
Date: Tue, 24 Mar 2009 09:42:46 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: arm kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] Use gpiochip label for sysfs entries
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least on the ep93xx, the gpio banks have names (A, B, etc), which are
used for gpiochip->label. However, banks C and F are swapped which makes
the names of the gpiochip directories in /sys/class/gpio confusing. For
many SoC chips, it would be useful to have the gpio label on the sysfs
entries.

The following patch registers the gpiochip devices using
gpiochip->label. If label is not set, or the registration fails, it
falls back to using gpiochip->base.

Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>

---

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 42fb2fd..698481c 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -536,7 +536,7 @@ EXPORT_SYMBOL_GPL(gpio_unexport);
 static int gpiochip_export(struct gpio_chip *chip)
 {
 	int		status;
-	struct device	*dev;
+	struct device	*dev = NULL;
 
 	/* Many systems register gpio chips for SOC support very early,
 	 * before driver model support is available.  In those cases we
@@ -546,10 +546,16 @@ static int gpiochip_export(struct gpio_chip *chip)
 	if (!gpio_class.p)
 		return 0;
 
-	/* use chip->base for the ID; it's already known to be unique */
 	mutex_lock(&sysfs_lock);
-	dev = device_create(&gpio_class, chip->dev, MKDEV(0, 0), chip,
-				"gpiochip%d", chip->base);
+	if (chip->label) 
+		/* Attempt to register the device using the gpiochip label */
+		dev = device_create(&gpio_class, chip->dev, MKDEV(0, 0), chip,
+				    "gpiochip-%s", chip->label);
+	
+	if (!dev) 
+		/* Use chip->base for the ID; it's already known to be unique */
+		dev = device_create(&gpio_class, chip->dev, MKDEV(0, 0), chip,
+				    "gpiochip%d", chip->base);
 	if (dev) {
 		status = sysfs_create_group(&dev->kobj,
 				&gpiochip_attr_group);

