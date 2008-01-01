Return-Path: <linux-kernel-owner+w=401wt.eu-S1755031AbYAACMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbYAACMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 21:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbYAACGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 21:06:01 -0500
Received: from fmailhost03.isp.att.net ([207.115.11.53]:43882 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbYAACFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 21:05:41 -0500
X-Originating-IP: [68.222.90.230]
From: jacliburn@bellsouth.net
To: jeff@garzik.org
Cc: csnook@redhat.com, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net, Jay Cliburn <jacliburn@bellsouth.net>
Subject: [PATCH 16/26] atl1: modernize check link function
Date: Mon, 31 Dec 2007 19:59:54 -0600
Message-Id: <1199152804-3889-17-git-send-email-jacliburn@bellsouth.net>
X-Mailer: git-send-email 1.5.3.3
In-Reply-To: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
References: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Cliburn <jacliburn@bellsouth.net>

Update atl1_check_link() to conform with the current vendor driver version
1.2.40.2.  Clean up vertical spacing, indentation, and remove dead code.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---
 drivers/net/atlx/atl1.c |   65 +++++++++++++++-------------------------------
 drivers/net/atlx/atl1.h |    1 +
 2 files changed, 22 insertions(+), 44 deletions(-)

diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index db6e76c..abed547 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -1094,6 +1094,7 @@ static void atl1_setup_mac_ctrl(struct atl1_adapter *adapter)
 	u32 value;
 	struct atl1_hw *hw = &adapter->hw;
 	struct net_device *netdev = adapter->netdev;
+
 	/* Config MAC CTRL Register */
 	value = MAC_CTRL_TX_EN | MAC_CTRL_RX_EN;
 	/* duplex */
@@ -1101,8 +1102,8 @@ static void atl1_setup_mac_ctrl(struct atl1_adapter *adapter)
 		value |= MAC_CTRL_DUPLX;
 	/* speed */
 	value |= ((u32) ((SPEED_1000 == adapter->link_speed) ?
-			 MAC_CTRL_SPEED_1000 : MAC_CTRL_SPEED_10_100) <<
-		  MAC_CTRL_SPEED_SHIFT);
+		MAC_CTRL_SPEED_1000 : MAC_CTRL_SPEED_10_100) <<
+		MAC_CTRL_SPEED_SHIFT);
 	/* flow control */
 	value |= (MAC_CTRL_TX_FLOW | MAC_CTRL_RX_FLOW);
 	/* PAD & CRC */
@@ -1113,10 +1114,6 @@ static void atl1_setup_mac_ctrl(struct atl1_adapter *adapter)
 	/* vlan */
 	if (adapter->vlgrp)
 		value |= MAC_CTRL_RMV_VLAN;
-	/* rx checksum
-	   if (adapter->rx_csum)
-	   value |= MAC_CTRL_RX_CHKSUM_EN;
-	 */
 	/* filter mode */
 	value |= MAC_CTRL_BC_EN;
 	if (netdev->flags & IFF_PROMISC)
@@ -1131,7 +1128,7 @@ static u32 atl1_check_link(struct atl1_adapter *adapter)
 {
 	struct atl1_hw *hw = &adapter->hw;
 	struct net_device *netdev = adapter->netdev;
-	u32 ret_val;
+	u32 val, retval;
 	u16 speed, duplex, phy_data;
 	int reconfig = 0;
 
@@ -1143,6 +1140,10 @@ static u32 atl1_check_link(struct atl1_adapter *adapter)
 		if (netif_carrier_ok(netdev)) {
 			/* old link state: Up */
 			dev_info(&adapter->pdev->dev, "link is down\n");
+			val = ioread32(hw->hw_addr + REG_MAC_CTRL);
+			val &= ~MAC_CTRL_RX_EN;
+			iowrite32(val, hw->hw_addr + REG_MAC_CTRL);
+			ioread32(hw->hw_addr + REG_MAC_CTRL);
 			adapter->link_speed = SPEED_0;
 			netif_carrier_off(netdev);
 			netif_stop_queue(netdev);
@@ -1151,15 +1152,12 @@ static u32 atl1_check_link(struct atl1_adapter *adapter)
 	}
 
 	/* Link Up */
-	ret_val = atl1_get_speed_and_duplex(hw, &speed, &duplex);
-	if (ret_val)
-		return ret_val;
+	retval = atl1_get_speed_and_duplex(hw, &speed, &duplex);
+	clear_bit(0, &hw->force_ps);
+	if (retval)
+		return retval;
 
 	switch (hw->media_type) {
-	case MEDIA_TYPE_1000M_FULL:
-		if (speed != SPEED_1000 || duplex != FULL_DUPLEX)
-			reconfig = 1;
-		break;
 	case MEDIA_TYPE_100M_FULL:
 		if (speed != SPEED_100 || duplex != FULL_DUPLEX)
 			reconfig = 1;
@@ -1180,8 +1178,8 @@ static u32 atl1_check_link(struct atl1_adapter *adapter)
 
 	/* link result is our setting */
 	if (!reconfig) {
-		if (adapter->link_speed != speed
-		    || adapter->link_duplex != duplex) {
+		if (adapter->link_speed != speed ||
+			adapter->link_duplex != duplex) {
 			adapter->link_speed = speed;
 			adapter->link_duplex = duplex;
 			atl1_setup_mac_ctrl(adapter);
@@ -1201,39 +1199,18 @@ static u32 atl1_check_link(struct atl1_adapter *adapter)
 
 	/* change original link status */
 	if (netif_carrier_ok(netdev)) {
+		val = ioread32(hw->hw_addr + REG_MAC_CTRL);
+		val &= ~MAC_CTRL_RX_EN;
 		adapter->link_speed = SPEED_0;
+		iowrite32(val, hw->hw_addr + REG_MAC_CTRL);
+		ioread32(hw->hw_addr + REG_MAC_CTRL);
 		netif_carrier_off(netdev);
 		netif_stop_queue(netdev);
 	}
 
-	if (hw->media_type != MEDIA_TYPE_AUTO_SENSOR &&
-	    hw->media_type != MEDIA_TYPE_1000M_FULL) {
-		switch (hw->media_type) {
-		case MEDIA_TYPE_100M_FULL:
-			phy_data = MII_CR_FULL_DUPLEX | MII_CR_SPEED_100 |
-			           MII_CR_RESET;
-			break;
-		case MEDIA_TYPE_100M_HALF:
-			phy_data = MII_CR_SPEED_100 | MII_CR_RESET;
-			break;
-		case MEDIA_TYPE_10M_FULL:
-			phy_data =
-			    MII_CR_FULL_DUPLEX | MII_CR_SPEED_10 | MII_CR_RESET;
-			break;
-		default:
-			/* MEDIA_TYPE_10M_HALF: */
-			phy_data = MII_CR_SPEED_10 | MII_CR_RESET;
-			break;
-		}
-		atl1_write_phy_reg(hw, MII_BMCR, phy_data);
-		return 0;
-	}
-
-	/* auto-neg, insert timer to re-config phy */
-	if (!adapter->phy_timer_pending) {
-		adapter->phy_timer_pending = true;
-		mod_timer(&adapter->phy_config_timer, jiffies + 3 * HZ);
-	}
+	/* autoneg, insert timer to reconfig phy */
+	if (!test_and_set_bit(0, &adapter->cfg_phy))
+		mod_timer(&adapter->phy_config_timer, jiffies + 5 * HZ);
 
 	return 0;
 }
diff --git a/drivers/net/atlx/atl1.h b/drivers/net/atlx/atl1.h
index 3db9a34..1f245e0 100644
--- a/drivers/net/atlx/atl1.h
+++ b/drivers/net/atlx/atl1.h
@@ -791,6 +791,7 @@ struct atl1_adapter {
 	struct timer_list watchdog_timer;
 	struct timer_list phy_config_timer;
 	bool phy_timer_pending;
+	unsigned long cfg_phy;
 
 	/* all descriptor rings' memory */
 	struct atl1_ring_header ring_header;
-- 
1.5.3.3

