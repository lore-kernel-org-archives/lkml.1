Return-Path: <linux-kernel-owner+w=401wt.eu-S1756115AbZLNKcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbZLNKcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 05:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbZLNKcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 05:32:33 -0500
Received: from smtp.nokia.com ([192.100.122.230]:31215 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbZLNKc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 05:32:28 -0500
From: Felipe Balbi <felipe.balbi@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       Aaro Koskinen <aaro.koskinen@nokia.com>,
       David Brownell <david-b@pacbell.net>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@openedhand.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [RFC/PATCH 2/4] input: misc: twl4030: move to request_threaded_irq
Date: Mon, 14 Dec 2009 12:30:52 +0200
Message-Id: <1260786654-13294-3-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.6.6.rc0
In-Reply-To: <20091212183410.GF3092@sirena.org.uk>
References: <20091212183410.GF3092@sirena.org.uk>
X-OriginalArrivalTime: 14 Dec 2009 10:31:32.0642 (UTC) FILETIME=[9AC4D020:01CA7CA8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move to request_threaded_irq() on twl4030 children.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 drivers/input/misc/twl4030-pwrbutton.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/twl4030-pwrbutton.c
index f5fc997..cd47d9e 100644
--- a/drivers/input/misc/twl4030-pwrbutton.c
+++ b/drivers/input/misc/twl4030-pwrbutton.c
@@ -39,16 +39,6 @@ static irqreturn_t powerbutton_irq(int irq, void *_pwr)
 	int err;
 	u8 value;
 
-#ifdef CONFIG_LOCKDEP
-	/* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
-	 * we don't want and can't tolerate since this is a threaded
-	 * IRQ and can sleep due to the i2c reads it has to issue.
-	 * Although it might be friendlier not to borrow this thread
-	 * context...
-	 */
-	local_irq_enable();
-#endif
-
 	err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &value,
 				  STS_HW_CONDITIONS);
 	if (!err)  {
@@ -80,7 +70,7 @@ static int __devinit twl4030_pwrbutton_probe(struct platform_device *pdev)
 	pwr->phys = "twl4030_pwrbutton/input0";
 	pwr->dev.parent = &pdev->dev;
 
-	err = request_irq(irq, powerbutton_irq,
+	err = request_threaded_irq(irq, NULL, powerbutton_irq,
 			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
 			"twl4030_pwrbutton", pwr);
 	if (err < 0) {
-- 
1.6.6.rc0

