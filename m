Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbXDJVgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbXDJVgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbXDJVgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:36:48 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:45677 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbXDJVgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:36:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:mime-version:content-type:content-transfer-encoding;
        b=SVlgvHOtg1KzAbuoeT5QKJSuBYBlKgPkAef05JqvO/QRWrQtrfQdykCjdN/P4ahM9+WjX445N9YvJ0QzIY8yWSzLKH0zoTJVojjKeOyq2iypEBjTyTwsx5CdIIB+PMSJqx0JZMnvlrX9fK5YtHAkWrzKdPnDsQtpB/FmyntnZOs=
Date: Wed, 11 Apr 2007 00:36:55 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <869542577.20070411003655@gmail.com>
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
CC: David Brownell <david-b@pacbell.net>
Subject: [RFC, PATCH 2/3] gpiodev - ARM PXA implementation
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello linux-arm-kernel,

GPIODEV API: Support for ARM PXA2xx CPU. Implementation is based on
Generic GPIO API. Generally, GPIODEV implementation should be provided
by device driver. But CPU-builtin devices in the current code are
treated is special manner ("arch devices"), so this approach is
followed for GPIODEV too.


Signed-off-by: Paul Sokolovsky <pmiscml@gmail.com>


Index: arch/arm/mach-pxa/generic.c
===================================================================
RCS file: /cvs/linux/kernel26/arch/arm/mach-pxa/generic.c,v
retrieving revision 1.39
retrieving revision 1.41
diff -u -r1.39 -r1.41
--- arch/arm/mach-pxa/generic.c 24 Feb 2007 13:14:41 -0000      1.39
+++ arch/arm/mach-pxa/generic.c 10 Apr 2007 15:35:33 -0000      1.41
@@ -24,6 +24,7 @@
 #include <linux/ioport.h>
 #include <linux/pm.h>
 #include <linux/string.h>
+#include <linux/gpiodev.h>
 
 #include <linux/sched.h>
 #include <asm/cnt32_to_63.h>
@@ -530,6 +531,41 @@
        .id             = -1,
 };
 
+
+static int pxa_gpiodev_get_value(struct device *dev, int gpio)
+{
+       return __gpio_get_value(gpio);
+}
+
+static void pxa_gpiodev_set_value(struct device *dev, int gpio, int value)
+{
+       __gpio_set_value(gpio, value);
+}
+
+static int pxa_gpiodev_to_irq(struct device *dev, int gpio)
+{
+       return IRQ_GPIO(gpio);
+}
+
+
+struct pxagpio_platform_data {
+       struct gpiodev_ops gpiodev_ops;
+} pxagpio_platform_data = {
+       .gpiodev_ops = {
+               .get = pxa_gpiodev_get_value,
+               .set = pxa_gpiodev_set_value,
+               .to_irq = pxa_gpiodev_to_irq,
+       }
+};
+
+struct platform_device pxagpio_device = {
+       .name           = "pxa2xx-gpio",
+       .id             = -1,
+       .dev            = {
+               .platform_data = &pxagpio_platform_data
+       }
+};
+
 static struct platform_device *devices[] __initdata = {
        &pxamci_device,
        &udc_device,
@@ -541,6 +580,7 @@
        &i2c_device,
        &i2s_device,
        &pxartc_device,
+       &pxagpio_device,
 };
 
 static int __init pxa_init(void)
  

-- 
Best regards,
 Paul                          mailto:pmiscml@gmail.com

