Return-Path: <linux-kernel-owner+w=401wt.eu-S1757745AbZFXJdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745AbZFXJdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757454AbZFXJcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:32:50 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:43378 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341AbZFXJcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:32:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=IsRKLDanttsbut0Z/2arCr3jkhcS4CJGeEbrOvOVMHwfsKeRZ+6jnWXdQzuk2TPytk
         4rbxfLXANT634kUYOxPVSOExsU3oql+PD6g1AF6lGpR84BrIABZXICKJTuxHheKAsuq9
         oPDo+rIXX36PaSNDqAxCXeda9DWpPPvVD8NRI=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, pavel@ucw.cz, hskinnemoen@atmel.com, anemo@mba.ocn.ne.jp,
       linux-usb@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
       rjw@sisk.pl, stern@rowland.harvard.edu, ben-linux@fluff.org,
       linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
       akpm@linux-foundation.org, felipe.balbi@nokia.com
Date: Wed, 24 Jun 2009 18:23:24 +0900
Message-Id: <20090624092324.14276.5263.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090624092306.14276.127.sendpatchset@rx1.opensource.se>
References: <20090624092306.14276.127.sendpatchset@rx1.opensource.se>
Subject: [PATCH 02/07] dma: rework dw_dmac suspend_late()/resume_early()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch reworks platform driver power management code
for dw_dmac from legacy late/early callbacks to dev_pm_ops.

The callbacks are converted for CONFIG_SUSPEND like this:
  suspend_late() -> suspend_noirq()
  resume_early() -> resume_noirq()

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Untested and not test compiled due to lack of cross compiler.

 drivers/dma/dw_dmac.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- 0001/drivers/dma/dw_dmac.c
+++ work/drivers/dma/dw_dmac.c	2009-06-01 16:31:34.000000000 +0900
@@ -1399,8 +1399,9 @@ static void dw_shutdown(struct platform_
 	clk_disable(dw->clk);
 }
 
-static int dw_suspend_late(struct platform_device *pdev, pm_message_t mesg)
+static int dw_suspend_noirq(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct dw_dma	*dw = platform_get_drvdata(pdev);
 
 	dw_dma_off(platform_get_drvdata(pdev));
@@ -1408,23 +1409,27 @@ static int dw_suspend_late(struct platfo
 	return 0;
 }
 
-static int dw_resume_early(struct platform_device *pdev)
+static int dw_resume_noirq(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct dw_dma	*dw = platform_get_drvdata(pdev);
 
 	clk_enable(dw->clk);
 	dma_writel(dw, CFG, DW_CFG_DMA_EN);
 	return 0;
-
 }
 
+static struct dev_pm_ops dw_dev_pm_ops = {
+	.suspend_noirq = dw_suspend_noirq,
+	.resume_noirq = dw_resume_noirq,
+};
+
 static struct platform_driver dw_driver = {
 	.remove		= __exit_p(dw_remove),
 	.shutdown	= dw_shutdown,
-	.suspend_late	= dw_suspend_late,
-	.resume_early	= dw_resume_early,
 	.driver = {
 		.name	= "dw_dmac",
+		.pm	= &dw_dev_pm_ops,
 	},
 };
 
