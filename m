Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbZAIM01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbZAIM01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 07:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbZAIM0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 07:26:13 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:59377 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753287AbZAIM0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 07:26:11 -0500
Subject: SM501: Ensure GPIO pin mode is GPIO when configured
Message-Id: <20090109122609.972538637@fluff.org.uk>
User-Agent: quilt/0.46-1
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, sameo@openedhand.com
Cc: Ben Dooks <ben-linux@fluff.org>
Content-Disposition: inline; filename=simtec/simtec-drivers-mfd-sm501-gpio-setmode.patch
Date: Fri, 09 Jan 2009 12:26:10 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When setting an GPIO to either input or output, we
should ensure that the pin configuration elsewhere
in the chip is set to GPIO in-case the initial
setup has not been done correctly.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc8-quilt3/drivers/mfd/sm501.c
===================================================================
--- linux-2.6.26-rc8-quilt3.orig/drivers/mfd/sm501.c	2008-07-02 15:33:23.000000000 +0100
+++ linux-2.6.26-rc8-quilt3/drivers/mfd/sm501.c	2008-07-02 16:42:59.000000000 +0100
@@ -41,6 +41,7 @@ struct sm501_gpio_chip {
 	struct gpio_chip	gpio;
 	struct sm501_gpio	*ourgpio;	/* to get back to parent. */
 	void __iomem		*regbase;
+	void __iomem		*control;	/* address of control reg. */
 };
 
 struct sm501_gpio {
@@ -908,6 +909,25 @@ static int sm501_gpio_get(struct gpio_ch
 	return result & 1UL;
 }
 
+static void sm501_gpio_ensure_gpio(struct sm501_gpio_chip *smchip,
+				   unsigned long bit)
+{
+	unsigned long ctrl;
+
+	/* check and modify if this pin is not set as gpio. */
+
+	if (readl(smchip->control) & bit) {
+		dev_info(sm501_gpio_to_dev(smchip->ourgpio)->dev,
+			 "changing mode of gpio, bit %08lx\n", bit);
+
+		ctrl = readl(smchip->control);
+		ctrl &= ~bit;
+		writel(ctrl, smchip->control);
+
+		sm501_sync_regs(sm501_gpio_to_dev(smchip->ourgpio));
+	}
+}
+
 static void sm501_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 
 {
@@ -929,6 +949,8 @@ static void sm501_gpio_set(struct gpio_c
 	writel(val, regs);
 
 	sm501_sync_regs(sm501_gpio_to_dev(smgpio));
+	sm501_gpio_ensure_gpio(smchip, bit);
+
 	spin_unlock_irqrestore(&smgpio->lock, save);
 }
 
@@ -941,8 +963,8 @@ static int sm501_gpio_input(struct gpio_
 	unsigned long save;
 	unsigned long ddr;
 
-	dev_info(sm501_gpio_to_dev(smgpio)->dev, "%s(%p,%d)\n",
-		 __func__, chip, offset);
+	dev_dbg(sm501_gpio_to_dev(smgpio)->dev, "%s(%p,%d)\n",
+		__func__, chip, offset);
 
 	spin_lock_irqsave(&smgpio->lock, save);
 
@@ -950,6 +972,8 @@ static int sm501_gpio_input(struct gpio_
 	writel(ddr & ~bit, regs + SM501_GPIO_DDR_LOW);
 
 	sm501_sync_regs(sm501_gpio_to_dev(smgpio));
+	sm501_gpio_ensure_gpio(smchip, bit);
+
 	spin_unlock_irqrestore(&smgpio->lock, save);
 
 	return 0;
@@ -1012,9 +1036,11 @@ static int __devinit sm501_gpio_register
 		if (base > 0)
 			base += 32;
 		chip->regbase = gpio->regs + SM501_GPIO_DATA_HIGH;
+		chip->control = sm->regs + SM501_GPIO63_32_CONTROL;
 		gchip->label  = "SM501-HIGH";
 	} else {
 		chip->regbase = gpio->regs + SM501_GPIO_DATA_LOW;
+		chip->control = sm->regs + SM501_GPIO31_0_CONTROL;
 		gchip->label  = "SM501-LOW";
 	}
 

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
