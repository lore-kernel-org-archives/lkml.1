Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbXDIVtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbXDIVtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030196AbXDIVXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:23:47 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:26873 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965931AbXDIVXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:23:25 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Dirk Behme <dirk.behme@gmail.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 10/18] ARM: OMAP: Fix warning in timer32k.c
Date: Mon,  9 Apr 2007 17:22:15 -0400
Message-Id: <1176153783637-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1176153781321-git-send-email-tony@atomide.com>
References: <11761537431635-git-send-email-tony@atomide.com> <117615374683-git-send-email-tony@atomide.com> <11761537491968-git-send-email-tony@atomide.com> <11761537522665-git-send-email-tony@atomide.com> <11761537563620-git-send-email-tony@atomide.com> <11761537613625-git-send-email-tony@atomide.com> <11761537672719-git-send-email-tony@atomide.com> <1176153771729-git-send-email-tony@atomide.com> <11761537743905-git-send-email-tony@atomide.com> <1176153781321-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Behme <dirk.behme@gmail.com>

ARM: OMAP: Fix warning in timer32k.c if CONFIG_NO_IDLE_HZ
isn't set:

arch/arm/plat-omap/timer32k.c:221: warning:
'omap_32k_timer_handler' defined but not used

Signed-off-by: Dirk Behme <dirk.behme@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/timer32k.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

--- a/arch/arm/plat-omap/timer32k.c
+++ b/arch/arm/plat-omap/timer32k.c
@@ -217,6 +217,18 @@ static inline irqreturn_t _omap_32k_timer_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t omap_32k_timer_interrupt(int irq, void *dev_id)
+{
+	unsigned long flags;
+
+	write_seqlock_irqsave(&xtime_lock, flags);
+	_omap_32k_timer_interrupt(irq, dev_id);
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	return IRQ_HANDLED;
+}
+
+#ifdef CONFIG_NO_IDLE_HZ
 static irqreturn_t omap_32k_timer_handler(int irq, void *dev_id)
 {
 	unsigned long now;
@@ -233,18 +245,6 @@ static irqreturn_t omap_32k_timer_handler(int irq, void *dev_id)
 	return _omap_32k_timer_interrupt(irq, dev_id);
 }
 
-static irqreturn_t omap_32k_timer_interrupt(int irq, void *dev_id)
-{
-	unsigned long flags;
-
-	write_seqlock_irqsave(&xtime_lock, flags);
-	_omap_32k_timer_interrupt(irq, dev_id);
-	write_sequnlock_irqrestore(&xtime_lock, flags);
-
-	return IRQ_HANDLED;
-}
-
-#ifdef CONFIG_NO_IDLE_HZ
 /*
  * Programs the next timer interrupt needed. Called when dynamic tick is
  * enabled, and to reprogram the ticks to skip from pm_idle. Note that
-- 
1.4.4.2

