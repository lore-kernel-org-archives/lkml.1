Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbYFVVO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbYFVVO7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 17:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbYFVVOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 17:14:09 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:57490 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756089AbYFVVOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 17:14:07 -0400
Message-Id: <20080622211405.617386778@fluff.org.uk>
References: <20080622211247.734979275@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Sun, 22 Jun 2008 22:12:48 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: arnaud.patard@rtp-net.org, akpm@linux-foundation.org,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 1/4] SM501: add power control callback
Content-Disposition: inline; filename=simtec/simtec-drivers-mfd-sm501-power-callback.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add callback to get or set the power control if
the device has the sleep connected to some form
of GPIO.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc4-quilt3/include/linux/sm501.h
===================================================================
--- linux-2.6.26-rc4-quilt3.orig/include/linux/sm501.h	2008-05-29 10:54:40.000000000 +0100
+++ linux-2.6.26-rc4-quilt3/include/linux/sm501.h	2008-05-29 10:54:55.000000000 +0100
@@ -157,6 +157,8 @@ struct sm501_init_gpio {
 	struct sm501_reg_init	gpio_ddr_high;
 };
 
+#define SM501_FLAG_SUSPEND_OFF		(1<<4)
+
 /* sm501_platdata
  *
  * This is passed with the platform device to allow the board
@@ -170,6 +172,11 @@ struct sm501_platdata {
 	struct sm501_init_gpio		*init_gpiop;
 	struct sm501_platdata_fb	*fb;
 
+	int				 flags;
+
+	int	(*get_power)(struct device *dev);
+	int	(*set_power)(struct device *dev, unsigned int on);
+
 	struct sm501_platdata_gpio_i2c	*gpio_i2c;
 	unsigned int			 gpio_i2c_nr;
 };
Index: linux-2.6.26-rc4-quilt3/drivers/mfd/sm501.c
===================================================================
--- linux-2.6.26-rc4-quilt3.orig/drivers/mfd/sm501.c	2008-05-29 10:54:40.000000000 +0100
+++ linux-2.6.26-rc4-quilt3/drivers/mfd/sm501.c	2008-05-29 10:54:55.000000000 +0100
@@ -1138,8 +1138,31 @@ static int sm501_plat_probe(struct platf
 }
 
 #ifdef CONFIG_PM
+
 /* power management support */
 
+static void sm501_set_power(struct sm501_devdata *sm, int on)
+{
+	struct sm501_platdata *pd = sm->platdata;
+
+	if (pd == NULL)
+		return;
+
+	if (pd->get_power) {
+		if (pd->get_power(sm->dev) == on) {
+			dev_dbg(sm->dev, "is already %d\n", on);
+			return;
+		}
+	}
+
+	if (pd->set_power) {
+		dev_dbg(sm->dev, "setting power to %d\n", on);
+
+		pd->set_power(sm->dev, on);
+		sm501_mdelay(sm, 10);
+	}
+}
+
 static int sm501_plat_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct sm501_devdata *sm = platform_get_drvdata(pdev);
@@ -1148,6 +1171,12 @@ static int sm501_plat_suspend(struct pla
 	sm->pm_misc = readl(sm->regs + SM501_MISC_CONTROL);
 
 	sm501_dump_regs(sm);
+
+	if (sm->platdata) {
+		if (sm->platdata->flags & SM501_FLAG_SUSPEND_OFF)
+			sm501_set_power(sm, 0);
+	}
+
 	return 0;
 }
 
@@ -1155,6 +1184,8 @@ static int sm501_plat_resume(struct plat
 {
 	struct sm501_devdata *sm = platform_get_drvdata(pdev);
 
+	sm501_set_power(sm, 1);
+
 	sm501_dump_regs(sm);
 	sm501_dump_gate(sm);
 	sm501_dump_clk(sm);

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
