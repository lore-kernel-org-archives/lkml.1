Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbZFXJ11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbZFXJ11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZFXJ1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:27:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:4082 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbZFXJ1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:27:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Bkri88bZ/H3PilFDq86vduGL3LpsC9miPao+dH99nc5rGRA2pbY0ji7aA4iKBFEYTj
         wjjb6wiJUiOxeC3nD4Qpjx30C2ruLSNb2p5Sy5s+VFG4SX+qdohF3pijXWPDF3w0OYN9
         GaoCR/SFAave2Xfz/AHwfSWT10hD9pkx8/k68=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, pavel@ucw.cz, hskinnemoen@atmel.com, anemo@mba.ocn.ne.jp,
       linux-usb@vger.kernel.org, rjw@sisk.pl, stern@rowland.harvard.edu,
       ben-linux@fluff.org, linux-pm@lists.linux-foundation.org,
       akpm@linux-foundation.org, linux-omap@vger.kernel.org,
       Magnus Damm <magnus.damm@gmail.com>, felipe.balbi@nokia.com
Date: Wed, 24 Jun 2009 18:23:42 +0900
Message-Id: <20090624092342.14276.2946.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090624092306.14276.127.sendpatchset@rx1.opensource.se>
References: <20090624092306.14276.127.sendpatchset@rx1.opensource.se>
Subject: [PATCH 04/07] i2c: rework i2c-pxa suspend_late()/resume_early()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch reworks platform driver power management code
for i2c-pxa from legacy late/early callbacks to dev_pm_ops.

The callbacks are converted for CONFIG_SUSPEND like this:
  suspend_late() -> suspend_noirq()
  resume_early() -> resume_noirq()

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Untested but compiles fine.

 drivers/i2c/busses/i2c-pxa.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- 0001/drivers/i2c/busses/i2c-pxa.c
+++ work/drivers/i2c/busses/i2c-pxa.c	2009-06-01 15:26:06.000000000 +0900
@@ -1135,35 +1135,44 @@ static int __exit i2c_pxa_remove(struct 
 }
 
 #ifdef CONFIG_PM
-static int i2c_pxa_suspend_late(struct platform_device *dev, pm_message_t state)
+static int i2c_pxa_suspend_noirq(struct device *dev)
 {
-	struct pxa_i2c *i2c = platform_get_drvdata(dev);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct pxa_i2c *i2c = platform_get_drvdata(pdev);
+
 	clk_disable(i2c->clk);
+
 	return 0;
 }
 
-static int i2c_pxa_resume_early(struct platform_device *dev)
+static int i2c_pxa_resume_noirq(struct device *dev)
 {
-	struct pxa_i2c *i2c = platform_get_drvdata(dev);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct pxa_i2c *i2c = platform_get_drvdata(pdev);
 
 	clk_enable(i2c->clk);
 	i2c_pxa_reset(i2c);
 
 	return 0;
 }
+
+static struct dev_pm_ops i2c_pxa_dev_pm_ops = {
+	.suspend_noirq = i2c_pxa_suspend_noirq,
+	.resume_noirq = i2c_pxa_resume_noirq,
+};
+
+#define I2C_PXA_DEV_PM_OPS (&i2c_pxa_dev_pm_ops)
 #else
-#define i2c_pxa_suspend_late NULL
-#define i2c_pxa_resume_early NULL
+#define I2C_PXA_DEV_PM_OPS NULL
 #endif
 
 static struct platform_driver i2c_pxa_driver = {
 	.probe		= i2c_pxa_probe,
 	.remove		= __exit_p(i2c_pxa_remove),
-	.suspend_late	= i2c_pxa_suspend_late,
-	.resume_early	= i2c_pxa_resume_early,
 	.driver		= {
 		.name	= "pxa2xx-i2c",
 		.owner	= THIS_MODULE,
+		.pm	= I2C_PXA_DEV_PM_OPS,
 	},
 	.id_table	= i2c_pxa_id_table,
 };
