Return-Path: <linux-kernel-owner+w=401wt.eu-S1765969AbXHKTFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765969AbXHKTFD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762722AbXHKS6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:58:35 -0400
Received: from 1wt.eu ([62.212.114.60]:1577 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762650AbXHKS63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:58:29 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184900.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:48:20 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Chris Wright <chrisw@sous-sol.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 28/28] sky2: workaround for lost IRQ
Content-Disposition: inline; filename=0028-sky2-workaround-for-lost-IRQ.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch restores a couple of workarounds from 2.6.16:
 * restart transmit moderation timer in case it expires during IRQ routine
 * default to having 10 HZ watchdog timer.
At this point it more important not to hang than to worry about the
power cost.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/sky2.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index 38e75cf..aec8c59 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -95,7 +95,7 @@ static int disable_msi = 0;
 module_param(disable_msi, int, 0);
 MODULE_PARM_DESC(disable_msi, "Disable Message Signaled Interrupt (MSI)");
 
-static int idle_timeout = 0;
+static int idle_timeout = 100;
 module_param(idle_timeout, int, 0);
 MODULE_PARM_DESC(idle_timeout, "Watchdog timer for lost interrupts (ms)");
 
@@ -2341,6 +2341,13 @@ static int sky2_poll(struct net_device *dev0, int *budget)
 
 	work_done = sky2_status_intr(hw, work_limit);
 	if (work_done < work_limit) {
+		/* Bug/Errata workaround?
+		 * Need to kick the TX irq moderation timer.
+		 */
+		if (sky2_read8(hw, STAT_TX_TIMER_CTRL) == TIM_START) {
+			sky2_write8(hw, STAT_TX_TIMER_CTRL, TIM_STOP);
+			sky2_write8(hw, STAT_TX_TIMER_CTRL, TIM_START);
+		}
 		netif_rx_complete(dev0);
 
 		sky2_read32(hw, B0_Y2_SP_LISR);
-- 
1.5.2.4

-- 
