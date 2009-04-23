Return-Path: <linux-kernel-owner+w=401wt.eu-S1760738AbZDWIBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738AbZDWIBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 04:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757797AbZDWHhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:37:12 -0400
Received: from sous-sol.org ([216.99.217.87]:47514 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757753AbZDWHhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:37:09 -0400
Message-Id: <20090423073129.798052363@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:59 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Michal Schmidt <mschmidt@redhat.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       David S Miller <davem@davemloft.net>
Subject: [patch 099/100] skge: fix occasional BUG during MTU change
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=skge-fix-occasional-bug-during-mtu-change.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Michal Schmidt <mschmidt@redhat.com>

upstream commit: d119b3927994e3d620d6adb0dd1ea6bf24427875

The BUG_ON(skge->tx_ring.to_use != skge->tx_ring.to_clean) in skge_up()
was sometimes observed when setting MTU.

skge_down() disables the TX queue, but then reenables it by mistake via
skge_tx_clean().
Fix it by moving the waking of the queue from skge_tx_clean() to the
other caller. And to make sure start_xmit is not in progress on another
CPU, skge_down() should call netif_tx_disable().

The bug was reported to me by Jiri Jilek whose Debian system sometimes
failed to boot. He tested the patch and the bug did not happen anymore.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/skge.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/skge.c
+++ b/drivers/net/skge.c
@@ -2674,7 +2674,7 @@ static int skge_down(struct net_device *
 	if (netif_msg_ifdown(skge))
 		printk(KERN_INFO PFX "%s: disabling interface\n", dev->name);
 
-	netif_stop_queue(dev);
+	netif_tx_disable(dev);
 
 	if (hw->chip_id == CHIP_ID_GENESIS && hw->phy_type == SK_PHY_XMAC)
 		del_timer_sync(&skge->link_timer);
@@ -2881,7 +2881,6 @@ static void skge_tx_clean(struct net_dev
 	}
 
 	skge->tx_ring.to_clean = e;
-	netif_wake_queue(dev);
 }
 
 static void skge_tx_timeout(struct net_device *dev)
@@ -2893,6 +2892,7 @@ static void skge_tx_timeout(struct net_d
 
 	skge_write8(skge->hw, Q_ADDR(txqaddr[skge->port], Q_CSR), CSR_STOP);
 	skge_tx_clean(dev);
+	netif_wake_queue(dev);
 }
 
 static int skge_change_mtu(struct net_device *dev, int new_mtu)

