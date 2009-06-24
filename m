Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbZFXJc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbZFXJc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbZFXJcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:32:10 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:50174 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbZFXJcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:32:08 -0400
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jun 2009 05:31:50 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Q99TVZ17K6OyerLJ+uNkagOXIpC/VMGWc5jDf8hiXfPWsFiz0P3H+4aoQ8iM+X5AF2
         eY5ib/PO5TloP1hpEc2zgtbEZKOmqs6neFgcDm2/3eNz7oV5YtagFhzIHL2xJNI9Tm4E
         6o8rE+/GaLKeEZBW0UQucdIycji4ORC/lggIo=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, ben-linux@fluff.org, hskinnemoen@atmel.com,
       anemo@mba.ocn.ne.jp, linux-usb@vger.kernel.org,
       akpm@linux-foundation.org, rjw@sisk.pl, stern@rowland.harvard.edu,
       pavel@ucw.cz, Magnus Damm <magnus.damm@gmail.com>,
       linux-omap@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       felipe.balbi@nokia.com
Date: Wed, 24 Jun 2009 18:23:33 +0900
Message-Id: <20090624092333.14276.13222.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090624092306.14276.127.sendpatchset@rx1.opensource.se>
References: <20090624092306.14276.127.sendpatchset@rx1.opensource.se>
Subject: [PATCH 03/07] dma: rework txx9dmac suspend_late()/resume_early()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch reworks platform driver power management code
for txx9dmac from legacy late/early callbacks to dev_pm_ops.

The callbacks are converted for CONFIG_SUSPEND like this:
  suspend_late() -> suspend_noirq()
  resume_early() -> resume_noirq()

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Untested but compiles fine.

 drivers/dma/txx9dmac.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- 0001/drivers/dma/txx9dmac.c
+++ work/drivers/dma/txx9dmac.c	2009-06-01 16:34:23.000000000 +0900
@@ -1287,17 +1287,18 @@ static void txx9dmac_shutdown(struct pla
 	txx9dmac_off(ddev);
 }
 
-static int txx9dmac_suspend_late(struct platform_device *pdev,
-				 pm_message_t mesg)
+static int txx9dmac_suspend_noirq(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct txx9dmac_dev *ddev = platform_get_drvdata(pdev);
 
 	txx9dmac_off(ddev);
 	return 0;
 }
 
-static int txx9dmac_resume_early(struct platform_device *pdev)
+static int txx9dmac_resume_noirq(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct txx9dmac_dev *ddev = platform_get_drvdata(pdev);
 	struct txx9dmac_platform_data *pdata = pdev->dev.platform_data;
 	u32 mcr;
@@ -1310,6 +1311,11 @@ static int txx9dmac_resume_early(struct 
 
 }
 
+static struct dev_pm_ops txx9dmac_dev_pm_ops = {
+	.suspend_noirq = txx9dmac_suspend_noirq,
+	.resume_noirq = txx9dmac_resume_noirq,
+};
+
 static struct platform_driver txx9dmac_chan_driver = {
 	.remove		= __exit_p(txx9dmac_chan_remove),
 	.driver = {
@@ -1320,10 +1326,9 @@ static struct platform_driver txx9dmac_c
 static struct platform_driver txx9dmac_driver = {
 	.remove		= __exit_p(txx9dmac_remove),
 	.shutdown	= txx9dmac_shutdown,
-	.suspend_late	= txx9dmac_suspend_late,
-	.resume_early	= txx9dmac_resume_early,
 	.driver = {
 		.name	= "txx9dmac",
+		.pm	= &txx9dmac_dev_pm_ops,
 	},
 };
 
