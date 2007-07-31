Return-Path: <linux-kernel-owner+w=401wt.eu-S935282AbXGaElW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935282AbXGaElW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939743AbXGaEdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:33:05 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34789 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968318AbXGaEdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:33:03 -0400
Date: Mon, 30 Jul 2007 21:33:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Chris Wright <chrisw@sous-sol.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 24/26] sky2: workaround for lost IRQ
Message-ID: <20070731043354.GY3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sky2-workaround-for-lost-irq.patch"
In-Reply-To: <20070731043047.GA3975@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

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
 1 file changed, 8 insertions(+), 1 deletion(-)

--- linux-2.6.21.6.orig/drivers/net/sky2.c
+++ linux-2.6.21.6/drivers/net/sky2.c
@@ -95,7 +95,7 @@ static int disable_msi = 0;
 module_param(disable_msi, int, 0);
 MODULE_PARM_DESC(disable_msi, "Disable Message Signaled Interrupt (MSI)");
 
-static int idle_timeout = 0;
+static int idle_timeout = 100;
 module_param(idle_timeout, int, 0);
 MODULE_PARM_DESC(idle_timeout, "Watchdog timer for lost interrupts (ms)");
 
@@ -2433,6 +2433,13 @@ static int sky2_poll(struct net_device *
 
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
