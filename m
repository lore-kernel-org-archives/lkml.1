Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290AbYJ3JqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbYJ3JqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 05:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbYJ3JqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 05:46:08 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:3517 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbYJ3JqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 05:46:07 -0400
X-IronPort-AV: E=Sophos;i="4.33,513,1220241600"; 
   d="scan'208";a="61832946"
From: Bryan Wu <cooloney@kernel.org>
To: dtor@mail.ru, akpm@linux-foundation.org
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] input: AD7877 driver fixup
Date: Thu, 30 Oct 2008 17:46:50 +0800
Message-Id: <1225360010-20176-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

 - Test flag with spinlock hold

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/input/touchscreen/ad7877.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/input/touchscreen/ad7877.c b/drivers/input/touchscreen/ad7877.c
index aaf88c9..6615bcd 100644
--- a/drivers/input/touchscreen/ad7877.c
+++ b/drivers/input/touchscreen/ad7877.c
@@ -388,10 +388,11 @@ static irqreturn_t ad7877_irq(int irq, void *handle)
 	 * doesn't get issued twice while in work.
 	 */
 
-	if (ts->pending)
-		return IRQ_HANDLED;
-
 	spin_lock_irqsave(&ts->lock, flags);
+	if (ts->pending) {
+		spin_unlock_irqrestore(&ts->lock, flags);
+		return IRQ_HANDLED;
+	}
 	ts->pending = 1;
 	spin_unlock_irqrestore(&ts->lock, flags);
 
@@ -420,10 +421,12 @@ static void ad7877_disable(struct ad7877 *ts)
 {
 	unsigned long flags;
 
-	if (ts->disabled)
+	spin_lock_irqsave(&ts->lock, flags);
+	if (ts->disabled) {
+		spin_unlock_irqrestore(&ts->lock, flags);
 		return;
+	}
 
-	spin_lock_irqsave(&ts->lock, flags);
 	ts->disabled = 1;
 	disable_irq(ts->spi->irq);
 	spin_unlock_irqrestore(&ts->lock, flags);
@@ -443,10 +446,11 @@ static void ad7877_enable(struct ad7877 *ts)
 {
 	unsigned long flags;
 
-	if (!ts->disabled)
-		return;
-
 	spin_lock_irqsave(&ts->lock, flags);
+	if (ts->disabled) {
+		spin_unlock_irqrestore(&ts->lock, flags);
+		return;
+	}
 	ts->disabled = 0;
 	enable_irq(ts->spi->irq);
 	spin_unlock_irqrestore(&ts->lock, flags);
-- 
1.5.6
