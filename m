Return-Path: <linux-kernel-owner+w=401wt.eu-S965964AbXDIV0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965964AbXDIV0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030241AbXDIVXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:23:51 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:26754 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965854AbXDIVXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:23:19 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>
Subject: [PATCH 7/18] ARM: OMAP: Avoid updating system time for sub-jiffy interrupts
Date: Mon,  9 Apr 2007 17:22:12 -0400
Message-Id: <1176153771729-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761537672719-git-send-email-tony@atomide.com>
References: <11761537431635-git-send-email-tony@atomide.com> <117615374683-git-send-email-tony@atomide.com> <11761537491968-git-send-email-tony@atomide.com> <11761537522665-git-send-email-tony@atomide.com> <11761537563620-git-send-email-tony@atomide.com> <11761537613625-git-send-email-tony@atomide.com> <11761537672719-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Updating system time and reprogramming timer can cause latency
issues on busy systems with lots of interrupts with constant
updating of time and reprogramming the system timer.

If a non-timer dyntick interrupt happens within a jiffy from
the last interrupt, updating time and reprogramming the timer
is unnecessary as we will get a timer interrupt soon anyways.

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/timer32k.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

--- a/arch/arm/plat-omap/timer32k.c
+++ b/arch/arm/plat-omap/timer32k.c
@@ -219,6 +219,17 @@ static inline irqreturn_t _omap_32k_timer_interrupt(int irq, void *dev_id)
 
 static irqreturn_t omap_32k_timer_handler(int irq, void *dev_id)
 {
+	unsigned long now;
+
+	now = omap_32k_sync_timer_read();
+
+	/* Don't bother reprogramming timer if last tick was before next
+	 * jiffie. We will get another interrupt when previously programmed
+	 * timer expires. This cuts down interrupt load quite a bit.
+	 */
+	if (now - omap_32k_last_tick < OMAP_32K_TICKS_PER_HZ)
+		return IRQ_HANDLED;
+
 	return _omap_32k_timer_interrupt(irq, dev_id);
 }
 
-- 
1.4.4.2

