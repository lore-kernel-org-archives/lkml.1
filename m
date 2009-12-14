Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbZLNKec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbZLNKec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 05:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbZLNKcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 05:32:31 -0500
Received: from smtp.nokia.com ([192.100.122.233]:30194 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbZLNKcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 05:32:24 -0500
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
Subject: [RFC/PATCH 1/4] input: keyboard: twl4030: move to request_threaded_irq
Date: Mon, 14 Dec 2009 12:30:51 +0200
Message-Id: <1260786654-13294-2-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.6.6.rc0
In-Reply-To: <20091212183410.GF3092@sirena.org.uk>
References: <20091212183410.GF3092@sirena.org.uk>
X-OriginalArrivalTime: 14 Dec 2009 10:31:29.0044 (UTC) FILETIME=[989FCD40:01CA7CA8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move to request_threaded_irq() on twl4030 children.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 drivers/input/keyboard/twl4030_keypad.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/input/keyboard/twl4030_keypad.c b/drivers/input/keyboard/twl4030_keypad.c
index 9a2977c..753a693 100644
--- a/drivers/input/keyboard/twl4030_keypad.c
+++ b/drivers/input/keyboard/twl4030_keypad.c
@@ -253,14 +253,6 @@ static irqreturn_t do_kp_irq(int irq, void *_kp)
 	u8 reg;
 	int ret;
 
-#ifdef CONFIG_LOCKDEP
-	/* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
-	 * we don't want and can't tolerate.  Although it might be
-	 * friendlier not to borrow this thread context...
-	 */
-	local_irq_enable();
-#endif
-
 	/* Read & Clear TWL4030 pending interrupt */
 	ret = twl4030_kpread(kp, &reg, KEYP_ISR1, 1);
 
@@ -403,7 +395,8 @@ static int __devinit twl4030_kp_probe(struct platform_device *pdev)
 	 *
 	 * NOTE:  we assume this host is wired to TWL4040 INT1, not INT2 ...
 	 */
-	error = request_irq(kp->irq, do_kp_irq, 0, pdev->name, kp);
+	error = request_threaded_irq(kp->irq, NULL, do_kp_irq,
+			0, pdev->name, kp);
 	if (error) {
 		dev_info(kp->dbg_dev, "request_irq failed for irq no=%d\n",
 			kp->irq);
-- 
1.6.6.rc0

