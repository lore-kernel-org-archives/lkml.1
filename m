Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbYLLPYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbYLLPYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 10:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756857AbYLLPYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 10:24:33 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:35502 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755341AbYLLPYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 10:24:33 -0500
Subject: GPIO: Fix probe() error return in gpio driver probes
Message-Id: <20081212152426.745254309@fluff.org.uk>
User-Agent: quilt/0.46-1
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
       dbrownell@users.sourceforge.net
Cc: Ben Dooks <ben-linux@fluff.org>
Content-Disposition: inline; filename=simtec/check-gpio-driver-return-codes.patch
Date: Fri, 12 Dec 2008 15:24:27 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of drivers in drivers/gpio return -ENODEV when confronted
with missing setup parameters such as the platform data. However,
returning -ENODEV causes the driver layer to silently ignore the
driver as it assumes the probe did not find anything and was only
speculative.

To make life easier to discern why a driver is not being attached,
change to returning -EINVAL, which is a better description of the
fact that the driver data was not valid.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Index: linux.git7/drivers/gpio/max7301.c
===================================================================
--- linux.git7.orig/drivers/gpio/max7301.c	2008-12-12 13:35:42.000000000 +0000
+++ linux.git7/drivers/gpio/max7301.c	2008-12-12 13:36:12.000000000 +0000
@@ -218,7 +218,7 @@ static int __devinit max7301_probe(struc
 
 	pdata = spi->dev.platform_data;
 	if (!pdata || !pdata->base)
-		return -ENODEV;
+		return -EINVAL;
 
 	/*
 	 * bits_per_word cannot be configured in platform data
Index: linux.git7/drivers/gpio/max732x.c
===================================================================
--- linux.git7.orig/drivers/gpio/max732x.c	2008-12-12 13:36:22.000000000 +0000
+++ linux.git7/drivers/gpio/max732x.c	2008-12-12 13:36:28.000000000 +0000
@@ -268,7 +268,7 @@ static int __devinit max732x_probe(struc
 
 	pdata = client->dev.platform_data;
 	if (pdata == NULL)
-		return -ENODEV;
+		return -EINVAL;
 
 	chip = kzalloc(sizeof(struct max732x_chip), GFP_KERNEL);
 	if (chip == NULL)
Index: linux.git7/drivers/gpio/mcp23s08.c
===================================================================
--- linux.git7.orig/drivers/gpio/mcp23s08.c	2008-12-12 14:10:01.000000000 +0000
+++ linux.git7/drivers/gpio/mcp23s08.c	2008-12-12 14:11:19.000000000 +0000
@@ -311,7 +311,7 @@ static int mcp23s08_probe(struct spi_dev
 
 	pdata = spi->dev.platform_data;
 	if (!pdata || !gpio_is_valid(pdata->base))
-		return -ENODEV;
+		return -EINVAL;
 
 	for (addr = 0; addr < 4; addr++) {
 		if (!pdata->chip[addr].is_present)
Index: linux.git7/drivers/gpio/pca953x.c
===================================================================
--- linux.git7.orig/drivers/gpio/pca953x.c	2008-12-12 13:33:47.000000000 +0000
+++ linux.git7/drivers/gpio/pca953x.c	2008-12-12 13:33:55.000000000 +0000
@@ -201,7 +201,7 @@ static int __devinit pca953x_probe(struc
 
 	pdata = client->dev.platform_data;
 	if (pdata == NULL)
-		return -ENODEV;
+		return -EINVAL;
 
 	chip = kzalloc(sizeof(struct pca953x_chip), GFP_KERNEL);
 	if (chip == NULL)
Index: linux.git7/drivers/gpio/pcf857x.c
===================================================================
--- linux.git7.orig/drivers/gpio/pcf857x.c	2008-12-12 13:34:33.000000000 +0000
+++ linux.git7/drivers/gpio/pcf857x.c	2008-12-12 13:34:54.000000000 +0000
@@ -189,7 +189,7 @@ static int pcf857x_probe(struct i2c_clie
 
 	pdata = client->dev.platform_data;
 	if (!pdata)
-		return -ENODEV;
+		return -EINVAL;
 
 	/* Allocate, initialize, and register this gpio_chip. */
 	gpio = kzalloc(sizeof *gpio, GFP_KERNEL);
@@ -249,7 +249,7 @@ static int pcf857x_probe(struct i2c_clie
 			status = i2c_read_le16(client);
 
 	} else
-		status = -ENODEV;
+		status = -EINVAL;
 
 	if (status < 0)
 		goto fail;

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
