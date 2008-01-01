Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbYAACNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbYAACNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 21:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbYAACIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 21:08:18 -0500
Received: from fmailhost01.isp.att.net ([204.127.217.101]:41382 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbYAACIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 21:08:16 -0500
X-Originating-IP: [68.222.90.230]
From: jacliburn@bellsouth.net
To: jeff@garzik.org
Cc: csnook@redhat.com, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net, Jay Cliburn <jacliburn@bellsouth.net>
Subject: [PATCH 20/26] atl1: update change mtu
Date: Mon, 31 Dec 2007 19:59:58 -0600
Message-Id: <1199152804-3889-21-git-send-email-jacliburn@bellsouth.net>
X-Mailer: git-send-email 1.5.3.3
In-Reply-To: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
References: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Cliburn <jacliburn@bellsouth.net>

Update atl1_change_mtu() to conform with the current vendor driver version
1.2.40.2.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---
 drivers/net/atlx/atl1.c |   39 ++++++++++++++++++++++-----------------
 1 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index 972de34..7d84a51 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -2438,32 +2438,37 @@ static void atl1_reset_task(struct work_struct *work)
  * atl1_change_mtu - Change the Maximum Transfer Unit
  * @netdev: network interface device structure
  * @new_mtu: new value for maximum frame size
- *
- * Returns 0 on success, negative on failure
  */
 static int atl1_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	struct atl1_adapter *adapter = netdev_priv(netdev);
-	int old_mtu = netdev->mtu;
-	int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN;
+	struct atl1_hw *hw = &adapter->hw;
 
-	if ((max_frame < ETH_ZLEN + ETH_FCS_LEN) ||
-	    (max_frame > MAX_JUMBO_FRAME_SIZE)) {
-		dev_warn(&adapter->pdev->dev, "invalid MTU setting\n");
+	if ((new_mtu < 40) || (new_mtu > (ETH_DATA_LEN + VLAN_HLEN)))
 		return -EINVAL;
-	}
 
-	adapter->hw.max_frame_size = max_frame;
-	adapter->hw.tx_jumbo_task_th = (max_frame + 7) >> 3;
-	adapter->rx_buffer_len = (max_frame + 7) & ~7;
-	adapter->hw.rx_jumbo_th = adapter->rx_buffer_len / 8;
+	if (hw->max_frame_size != new_mtu) {
+		while (test_and_set_bit(__ATL1_RESETTING, &adapter->flags))
+			msleep(1);
 
-	netdev->mtu = new_mtu;
-	if ((old_mtu != new_mtu) && netif_running(netdev)) {
-		atl1_down(adapter);
-		atl1_up(adapter);
-	}
+		if (netif_running(netdev))
+			atl1_down(adapter);
+
+		netdev->mtu = new_mtu;
+		adapter->hw.max_frame_size = new_mtu;
+		adapter->hw.tx_jumbo_task_th = (new_mtu + ETH_HLEN +
+			ETH_FCS_LEN + VLAN_HLEN + 7) >> 3;
+		adapter->rx_buffer_len = (new_mtu + ETH_HLEN +
+			ETH_FCS_LEN + VLAN_HLEN + 7) & ~7;
+		adapter->hw.rx_jumbo_th = adapter->rx_buffer_len / 8;
 
+		if (netif_running(netdev))
+			atl1_up(adapter);
+		else
+			atl1_reset(adapter);
+
+		clear_bit(__ATL1_RESETTING, &adapter->flags);
+	}
 	return 0;
 }
 
-- 
1.5.3.3

