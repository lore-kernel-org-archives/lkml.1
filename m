Return-Path: <linux-kernel-owner+w=401wt.eu-S932258AbZHCQzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbZHCQzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 12:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932160AbZHCQzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 12:55:49 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:56672 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754808AbZHCQzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 12:55:49 -0400
Subject: gpiolib: add names file in gpio chip sysfs.
Message-Id: <20090803165536.345974601@fluff.org>
User-Agent: quilt/0.46-1
From: ben@fluff.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: David Brownell <dbrownell@users.sourceforge.net>
Content-Disposition: inline; filename=gpio-export-names.patch
Date: Mon, 03 Aug 2009 17:55:36 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a 'names' file to the sysfs entries for each chip to show which
have names.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
CC: David Brownell <dbrownell@users.sourceforge.net>

---
 drivers/gpio/gpiolib.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

Index: b/drivers/gpio/gpiolib.c
===================================================================
--- a/drivers/gpio/gpiolib.c	2009-08-03 17:51:40.000000000 +0100
+++ b/drivers/gpio/gpiolib.c	2009-08-03 17:53:04.000000000 +0100
@@ -303,6 +303,7 @@ static const struct attribute_group gpio
  *   /base ... matching gpio_chip.base (N)
  *   /label ... matching gpio_chip.label
  *   /ngpio ... matching gpio_chip.ngpio
+ *   /names ... matching gpio_chip.names
  */
 
 static ssize_t chip_base_show(struct device *dev,
@@ -332,10 +333,30 @@ static ssize_t chip_ngpio_show(struct de
 }
 static DEVICE_ATTR(ngpio, 0444, chip_ngpio_show, NULL);
 
+static ssize_t chip_names_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	const struct gpio_chip*chip = dev_get_drvdata(dev);
+	char **names = chip->names;
+	int ptr = 0;
+	int name;
+
+	if (!names)
+		return -EINVAL;
+
+	for (name = 0; name < chip->ngpio && ptr < PAGE_SIZE; name++)
+		ptr += snprintf(buf + ptr, PAGE_SIZE - ptr,
+				"%s\n", names[name] ? names[name] : "");
+
+	return ptr;
+}
+DEVICE_ATTR(names, 0444, chip_names_show, NULL);
+
 static const struct attribute *gpiochip_attrs[] = {
 	&dev_attr_base.attr,
 	&dev_attr_label.attr,
 	&dev_attr_ngpio.attr,
+	&dev_attr_names.attr,
 	NULL,
 };
 

-- 
