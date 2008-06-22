Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbYFVVQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbYFVVQA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 17:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756867AbYFVVON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 17:14:13 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:57513 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756815AbYFVVOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 17:14:12 -0400
Message-Id: <20080622211406.050319454@fluff.org.uk>
References: <20080622211247.734979275@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Sun, 22 Jun 2008 22:12:50 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: arnaud.patard@rtp-net.org, akpm@linux-foundation.org,
       Ben Dooks <ben-linux@fluff.org>, Arnaud Patard <apatard@mandriva.com>
Subject: [patch 3/4] SM501: GPIO dynamic registration for PCI devices
Content-Disposition: inline; filename=thirdparty/rtp-sm501-pci-gpio.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaud Patard <apatard@mandriva.com>

The SM501 PCI card requires a dyanmic gpio allocation as
the number of cards is not known at compile time. Fixup
the platform data and registration to deal with this.

Acked-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Arnaud Patard <apatard@mandriva.com>

Index: linux-2.6.26-rc6-quilt3/drivers/mfd/sm501.c
===================================================================
--- linux-2.6.26-rc6-quilt3.orig/drivers/mfd/sm501.c	2008-06-20 16:34:02.000000000 +0100
+++ linux-2.6.26-rc6-quilt3/drivers/mfd/sm501.c	2008-06-20 16:35:11.000000000 +0100
@@ -996,12 +996,13 @@ static int __devinit sm501_gpio_register
 {
 	struct sm501_platdata *pdata = sm->platdata;
 	struct gpio_chip *gchip = &chip->gpio;
-	unsigned base = pdata->gpio_base;
+	int base = pdata->gpio_base;
 
 	memcpy(chip, &gpio_chip_template, sizeof(struct gpio_chip));
 
 	if (chip == &gpio->high) {
-		base += 32;
+		if (base > 0)
+			base += 32;
 		chip->regbase = gpio->regs + SM501_GPIO_DATA_HIGH;
 		gchip->label  = "SM501-HIGH";
 	} else {
@@ -1452,6 +1453,7 @@ static struct sm501_platdata_fb sm501_fb
 static struct sm501_platdata sm501_pci_platdata = {
 	.init		= &sm501_pci_initdata,
 	.fb		= &sm501_fb_pdata,
+	.gpio_base	= -1,
 };
 
 static int sm501_pci_probe(struct pci_dev *dev,
Index: linux-2.6.26-rc6-quilt3/include/linux/sm501.h
===================================================================
--- linux-2.6.26-rc6-quilt3.orig/include/linux/sm501.h	2008-06-20 16:34:02.000000000 +0100
+++ linux-2.6.26-rc6-quilt3/include/linux/sm501.h	2008-06-20 16:35:11.000000000 +0100
@@ -156,7 +156,7 @@ struct sm501_platdata {
 	struct sm501_platdata_fb	*fb;
 
 	int				 flags;
-	unsigned			 gpio_base;
+	int				 gpio_base;
 
 	int	(*get_power)(struct device *dev);
 	int	(*set_power)(struct device *dev, unsigned int on);

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
