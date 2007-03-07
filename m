Return-Path: <linux-kernel-owner+w=401wt.eu-S1422808AbXCGRmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422808AbXCGRmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:42:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422812AbXCGRPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:15:38 -0500
Received: from ns2.suse.de ([195.135.220.15]:43183 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422809AbXCGRPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:15:06 -0500
Message-Id: <20070307171328.970380681@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: [patch 040/101] sky2: transmit timeout deadlock
Content-Disposition: inline; filename=sky2-tx-timeout-deadlock.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>

The code in transmit timeout incorrectly assumed that netif_tx_lock
was not set.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/sky2.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- linux-2.6.20.1.orig/drivers/net/sky2.c
+++ linux-2.6.20.1/drivers/net/sky2.c
@@ -1796,6 +1796,7 @@ out:
 
 /* Transmit timeout is only called if we are running, carries is up
  * and tx queue is full (stopped).
+ * Called with netif_tx_lock held.
  */
 static void sky2_tx_timeout(struct net_device *dev)
 {
@@ -1821,17 +1822,14 @@ static void sky2_tx_timeout(struct net_d
 		sky2_write8(hw, STAT_TX_TIMER_CTRL, TIM_START);
 	} else if (report != sky2->tx_cons) {
 		printk(KERN_INFO PFX "status report lost?\n");
-
-		netif_tx_lock_bh(dev);
 		sky2_tx_complete(sky2, report);
-		netif_tx_unlock_bh(dev);
 	} else {
 		printk(KERN_INFO PFX "hardware hung? flushing\n");
 
 		sky2_write32(hw, Q_ADDR(txq, Q_CSR), BMU_STOP);
 		sky2_write32(hw, Y2_QADDR(txq, PREF_UNIT_CTRL), PREF_UNIT_RST_SET);
 
-		sky2_tx_clean(dev);
+		sky2_tx_complete(sky2, sky2->tx_prod);
 
 		sky2_qset(hw, txq);
 		sky2_prefetch_init(hw, txq, sky2->tx_le_map, TX_RING_SIZE - 1);

--
