Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbZDFQvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbZDFQvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbZDFQuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:50:32 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:51801 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbZDFQua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:50:30 -0400
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH] rtc: Make rtc_update_irq callable with irqs enabled
Date: Tue,  7 Apr 2009 01:50:31 +0900
Message-Id: <1239036633-10032-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rtc_update_irq() might be called with irqs enabled, if a interrupt
handler was registered without IRQF_DISABLED.
Use spin_lock_irqsave/spin_unlock_irqrestore instead of
spin_lock/spin_unlock.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/rtc/interface.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 4348c4b..a8641f7 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -376,14 +376,16 @@ EXPORT_SYMBOL_GPL(rtc_update_irq_enable);
 void rtc_update_irq(struct rtc_device *rtc,
 		unsigned long num, unsigned long events)
 {
-	spin_lock(&rtc->irq_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&rtc->irq_lock, flags);
 	rtc->irq_data = (rtc->irq_data + (num << 8)) | events;
-	spin_unlock(&rtc->irq_lock);
+	spin_unlock_irqrestore(&rtc->irq_lock, flags);
 
-	spin_lock(&rtc->irq_task_lock);
+	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task)
 		rtc->irq_task->func(rtc->irq_task->private_data);
-	spin_unlock(&rtc->irq_task_lock);
+	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
 
 	wake_up_interruptible(&rtc->irq_queue);
 	kill_fasync(&rtc->async_queue, SIGIO, POLL_IN);
-- 
1.5.6.3

