Return-Path: <linux-kernel-owner+w=401wt.eu-S1764959AbXEUTy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764959AbXEUTy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934075AbXEUT3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:29:49 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52692 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934132AbXEUT3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:29:46 -0400
Message-Id: <20070521191720.589945000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:34 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Michael Chan" <mchan@broadcom.com>,
       David S Miller <davem@davemloft.net>
Subject: [patch 22/69] TG3: Remove reset during MAC address changes.
Content-Disposition: inline; filename=tg3-remove-reset-during-mac-address-changes.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From:  <mchan@broadcom.com>

The reset was added a while back so that ASF could re-init whatever
MAC address it wanted to use after the MAC address was changed.
Instead of resetting, we can just keep MAC address 1 unchanged during
MAC address changes if MAC address 1 is different from MAC address 0.

This fixes 2 problems:

1. Bonding calls set_mac_address in contexts that cannot sleep.
It no longer sleeps with the chip reset removed.

2. When ASF shares the same MAC address as the NIC, it needs to
always do that even when the MAC address is changed.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

---
 drivers/net/tg3.c |   35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

--- linux-2.6.21.1.orig/drivers/net/tg3.c
+++ linux-2.6.21.1/drivers/net/tg3.c
@@ -5934,7 +5934,7 @@ static int tg3_load_tso_firmware(struct 
 
 
 /* tp->lock is held. */
-static void __tg3_set_mac_addr(struct tg3 *tp)
+static void __tg3_set_mac_addr(struct tg3 *tp, int skip_mac_1)
 {
 	u32 addr_high, addr_low;
 	int i;
@@ -5946,6 +5946,8 @@ static void __tg3_set_mac_addr(struct tg
 		    (tp->dev->dev_addr[4] <<  8) |
 		    (tp->dev->dev_addr[5] <<  0));
 	for (i = 0; i < 4; i++) {
+		if (i == 1 && skip_mac_1)
+			continue;
 		tw32(MAC_ADDR_0_HIGH + (i * 8), addr_high);
 		tw32(MAC_ADDR_0_LOW + (i * 8), addr_low);
 	}
@@ -5972,7 +5974,7 @@ static int tg3_set_mac_addr(struct net_d
 {
 	struct tg3 *tp = netdev_priv(dev);
 	struct sockaddr *addr = p;
-	int err = 0;
+	int err = 0, skip_mac_1 = 0;
 
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EINVAL;
@@ -5983,22 +5985,21 @@ static int tg3_set_mac_addr(struct net_d
 		return 0;
 
 	if (tp->tg3_flags & TG3_FLAG_ENABLE_ASF) {
-		/* Reset chip so that ASF can re-init any MAC addresses it
-		 * needs.
-		 */
-		tg3_netif_stop(tp);
-		tg3_full_lock(tp, 1);
+		u32 addr0_high, addr0_low, addr1_high, addr1_low;
 
-		tg3_halt(tp, RESET_KIND_SHUTDOWN, 1);
-		err = tg3_restart_hw(tp, 0);
-		if (!err)
-			tg3_netif_start(tp);
-		tg3_full_unlock(tp);
-	} else {
-		spin_lock_bh(&tp->lock);
-		__tg3_set_mac_addr(tp);
-		spin_unlock_bh(&tp->lock);
+		addr0_high = tr32(MAC_ADDR_0_HIGH);
+		addr0_low = tr32(MAC_ADDR_0_LOW);
+		addr1_high = tr32(MAC_ADDR_1_HIGH);
+		addr1_low = tr32(MAC_ADDR_1_LOW);
+
+		/* Skip MAC addr 1 if ASF is using it. */
+		if ((addr0_high != addr1_high || addr0_low != addr1_low) &&
+		    !(addr1_high == 0 && addr1_low == 0))
+			skip_mac_1 = 1;
 	}
+	spin_lock_bh(&tp->lock);
+	__tg3_set_mac_addr(tp, skip_mac_1);
+	spin_unlock_bh(&tp->lock);
 
 	return err;
 }
@@ -6315,7 +6316,7 @@ static int tg3_reset_hw(struct tg3 *tp, 
 		     tp->rx_jumbo_ptr);
 
 	/* Initialize MAC address and backoff seed. */
-	__tg3_set_mac_addr(tp);
+	__tg3_set_mac_addr(tp, 0);
 
 	/* MTU + ethernet header + FCS + optional VLAN tag */
 	tw32(MAC_RX_MTU_SIZE, tp->dev->mtu + ETH_HLEN + 8);

-- 
