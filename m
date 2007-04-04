Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbXDDSbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbXDDSbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbXDDSay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:30:54 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:37733 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318AbXDDSJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:09:58 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>
Subject: [PATCH 41/90] ARM: OMAP: Avoid updating system time for sub-jiffy interrupts
Date: Wed,  4 Apr 2007 14:05:20 -0400
Message-Id: <11757100811771-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757100781275-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com>
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

diff --git a/arch/arm/plat-omap/timer32k.c b/arch/arm/plat-omap/timer32k.c
index 2653106..c37d7b4 100644
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

