Return-Path: <linux-kernel-owner+w=401wt.eu-S1757027AbZFXJ1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027AbZFXJ1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756298AbZFXJ1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:27:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:4082 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbZFXJ1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:27:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=gndPnaVjUpouztR0cbwhwYBSX29CgkXlTWU1+rpEghVmtxcCIIUpN/IsAQG+6blIIy
         rb3sHej9rlluBQg4X8VgWvGjyZSQfF5sO+zqF4Si+RY3RuzRcqxdgwSPWhEv3pS/NMmu
         xFRinDDHYHqz+zobeBEH55S/76sRSP8QNTO/U=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, pavel@ucw.cz, hskinnemoen@atmel.com, anemo@mba.ocn.ne.jp,
       linux-usb@vger.kernel.org, akpm@linux-foundation.org, rjw@sisk.pl,
       stern@rowland.harvard.edu, ben-linux@fluff.org,
       Magnus Damm <magnus.damm@gmail.com>, linux-omap@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, felipe.balbi@nokia.com
Date: Wed, 24 Jun 2009 18:24:00 +0900
Message-Id: <20090624092400.14276.94490.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090624092306.14276.127.sendpatchset@rx1.opensource.se>
References: <20090624092306.14276.127.sendpatchset@rx1.opensource.se>
Subject: [PATCH 06/07] usb: rework musb suspend()/resume_early()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch reworks platform driver power management code
for musb from legacy callbacks to dev_pm_ops.

The callbacks are converted for CONFIG_SUSPEND like this:
  suspend() -> suspend()
  resume_early() -> resume_noirq()

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Untested but compiles fine.

 drivers/i2c/busses/i2c-pxa.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- 0001/drivers/usb/musb/musb_core.c
+++ work/drivers/usb/musb/musb_core.c	2009-06-01 15:27:12.000000000 +0900
@@ -2168,8 +2168,9 @@ static int __devexit musb_remove(struct 
 
 #ifdef	CONFIG_PM
 
-static int musb_suspend(struct platform_device *pdev, pm_message_t message)
+static int musb_suspend(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	unsigned long	flags;
 	struct musb	*musb = dev_to_musb(&pdev->dev);
 
@@ -2196,8 +2197,9 @@ static int musb_suspend(struct platform_
 	return 0;
 }
 
-static int musb_resume_early(struct platform_device *pdev)
+static int musb_resume_noirq(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct musb	*musb = dev_to_musb(&pdev->dev);
 
 	if (!musb->clock)
@@ -2215,9 +2217,14 @@ static int musb_resume_early(struct plat
 	return 0;
 }
 
+static struct dev_pm_ops musb_dev_pm_ops = {
+	.suspend	= musb_suspend,
+	.resume_noirq	= musb_resume_noirq,
+};
+
+#define MUSB_DEV_PM_OPS (&musb_dev_pm_ops)
 #else
-#define	musb_suspend	NULL
-#define	musb_resume_early	NULL
+#define	MUSB_DEV_PM_OPS	NULL
 #endif
 
 static struct platform_driver musb_driver = {
@@ -2225,11 +2232,10 @@ static struct platform_driver musb_drive
 		.name		= (char *)musb_driver_name,
 		.bus		= &platform_bus_type,
 		.owner		= THIS_MODULE,
+		.pm		= MUSB_DEV_PM_OPS,
 	},
 	.remove		= __devexit_p(musb_remove),
 	.shutdown	= musb_shutdown,
-	.suspend	= musb_suspend,
-	.resume_early	= musb_resume_early,
 };
 
 /*-------------------------------------------------------------------------*/
