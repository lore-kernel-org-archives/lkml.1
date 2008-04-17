Return-Path: <linux-kernel-owner+w=401wt.eu-S932263AbYDUNZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbYDUNZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760115AbYDUNTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:19:13 -0400
Received: from el-out-1112.google.com ([209.85.162.178]:25621 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760017AbYDUNTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:19:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=SglVnHR7e+uwAt8hufYj5FmjarucpsEZycmZ3ucMQjGbHAvHG0f4HDFVR1PRYkwImwCAYf27pMLHZo73AIhb8XrAPQDGKCgUfyySzgK3BSyayglRweDkwVSj750KS7UGM8N9ZuCcpENqrs4KNW62Hu1odHszZFu7y2aqYi+5zcI=
Message-Id: <d808fbe5b404854374917bd0d1db937a0a524665.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Thu, 17 Apr 2008 09:24:39 -0400
Subject: [PATCH 30/37] Input: wm97xx-core - only schedule interrupt handler if not already scheduled
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: Mark Brown <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As well as clarifying the fact that the driver can cope if a second
interrupt occurs before the IRQ work is scheduled this also ensures
that calls to the machine irq_enable() are balanced, making that easier
to implement.  Normally this is redundant due to the interrupt disabling
but some unusal board configurations can trigger it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
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
1.5.5.rc2.6.gf58d


