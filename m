Return-Path: <linux-kernel-owner+w=401wt.eu-S1752165AbZL1LFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbZL1LFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 06:05:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZL1LFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 06:05:07 -0500
Received: from smtp.nokia.com ([192.100.122.233]:61158 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbZL1LFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 06:05:06 -0500
From: Felipe Balbi <felipe.balbi@nokia.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 2/4] input: misc: twl4030: move to request_threaded_irq
Date: Mon, 28 Dec 2009 13:02:49 +0200
Message-Id: <1261998172-29760-2-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.6.6.rc0
In-Reply-To: <1261998172-29760-1-git-send-email-felipe.balbi@nokia.com>
References: <1261998172-29760-1-git-send-email-felipe.balbi@nokia.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Patchwork-Id: 67250
X-OriginalArrivalTime: 28 Dec 2009 11:04:31.0881 (UTC) FILETIME=[88453790:01CA87AD]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move to request_threaded_irq() on twl4030 children.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>

---

resending because it wasn't applied before

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
