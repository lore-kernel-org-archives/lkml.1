Return-Path: <linux-kernel-owner+w=401wt.eu-S1752359AbZL1LFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbZL1LFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 06:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbZL1LFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 06:05:30 -0500
Received: from smtp.nokia.com ([192.100.122.233]:61202 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbZL1LF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 06:05:29 -0500
From: Felipe Balbi <felipe.balbi@nokia.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 1/4] input: keyboard: twl4030: move to request_threaded_irq
Date: Mon, 28 Dec 2009 13:02:50 +0200
Message-Id: <1261998172-29760-3-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.6.6.rc0
In-Reply-To: <1261998172-29760-1-git-send-email-felipe.balbi@nokia.com>
References: <1261998172-29760-1-git-send-email-felipe.balbi@nokia.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Patchwork-Id: 67251
X-OriginalArrivalTime: 28 Dec 2009 11:04:34.0107 (UTC) FILETIME=[8998E0B0:01CA87AD]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move to request_threaded_irq() on twl4030 children.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>

---

resending because it wasn't applied before

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
