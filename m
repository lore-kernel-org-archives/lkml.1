Return-Path: <linux-kernel-owner+w=401wt.eu-S1763605AbYDNRj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763605AbYDNRj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763269AbYDNRjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:39:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34948 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762828AbYDNRjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:39:41 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>, Dmitry Torokhov <dtor@mail.ru>,
       Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] wm97xx-core: Only schedule interrupt handler if not already scheduled
Date: Mon, 14 Apr 2008 18:39:33 +0100
Message-Id: <1208194775-4293-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <20080414173841.GA2213@rakim.wolfsonmicro.main>
References: <20080414173841.GA2213@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/input/touchscreen/wm97xx-core.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/input/touchscreen/wm97xx-core.c b/drivers/input/touchscreen/wm97xx-core.c
index 2910999..e27b1e0 100644
--- a/drivers/input/touchscreen/wm97xx-core.c
+++ b/drivers/input/touchscreen/wm97xx-core.c
@@ -328,18 +328,18 @@ static void wm97xx_pen_irq_worker(struct work_struct *work)
  *
  * We have to disable the codec interrupt in the handler because it
  * can take upto 1ms to clear the interrupt source. We schedule a task
- * in a work queue to do the actual interaction with the chip (it
- * doesn't matter if we end up reenqueing it before it is executed
- * since we don't touch the chip until it has run).  The interrupt is
- * then enabled again in the slow handler when the source has been
- * cleared.
+ * in a work queue to do the actual interaction with the chip.  The
+ * interrupt is then enabled again in the slow handler when the source
+ * has been cleared.
  */
 static irqreturn_t wm97xx_pen_interrupt(int irq, void *dev_id)
 {
 	struct wm97xx *wm = dev_id;
 
-	wm->mach_ops->irq_enable(wm, 0);
-	queue_work(wm->ts_workq, &wm->pen_event_work);
+	if (!work_pending(&wm->pen_event_work)) {
+		wm->mach_ops->irq_enable(wm, 0);
+		queue_work(wm->ts_workq, &wm->pen_event_work);
+	}
 
 	return IRQ_HANDLED;
 }
-- 
1.5.5

