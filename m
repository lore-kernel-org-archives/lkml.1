Return-Path: <linux-kernel-owner+w=401wt.eu-S932392AbZHDCZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbZHDCZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 22:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932250AbZHDCZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 22:25:18 -0400
Received: from mail.atheros.com ([12.36.123.2]:11049 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932166AbZHDCZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 22:25:10 -0400
From: <jie.yang@atheros.com>
To: <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       jie yang <jie.yang@atheros.com>
Subject: [PATCH]atl1c:set MAX_TX_OFFLOAD_THRESH to 6k from 9k and fix spelling error
Date: Tue, 4 Aug 2009 10:25:03 +0800
Message-ID: <12493527032639-git-send-email-jie.yang@atheros.com>
X-Mailer: git-send-email 1.5.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Set MAX_TX_OFFLOAD_THRESH to 6k from 9k, when mtu large then MAX_TX_OFFLOAD_THRESH
    just disable NETIF_F_TSO6, NETIF_F_TSO, NETIF_F_HW_CSUM.

2. Fix spelling error, change REG_TWSI_CTRL to REG_TXQ_CTRL.

Signed-off-by: jie yang <jie.yang@atheros.com>
---

diff --git a/drivers/net/atl1c/atl1c.h b/drivers/net/atl1c/atl1c.h
index 2a1120a..07b2880 100644
--- a/drivers/net/atl1c/atl1c.h
+++ b/drivers/net/atl1c/atl1c.h
@@ -74,7 +74,7 @@
 
 #define AT_RX_BUF_SIZE     (ETH_FRAME_LEN + VLAN_HLEN + ETH_FCS_LEN)
 #define MAX_JUMBO_FRAME_SIZE   (9*1024)
-#define MAX_TX_OFFLOAD_THRESH  (9*1024)
+#define MAX_TX_OFFLOAD_THRESH  (6*1024)
 
 #define AT_MAX_RECEIVE_QUEUE    4
 #define AT_DEF_RECEIVE_QUEUE   1
diff --git a/drivers/net/atl1c/atl1c_main.c b/drivers/net/atl1c/atl1c_main.c
index 1d601ce..13cb551 100644
--- a/drivers/net/atl1c/atl1c_main.c
+++ b/drivers/net/atl1c/atl1c_main.c
@@ -474,15 +474,19 @@ static int atl1c_change_mtu(struct net_device *netdev, int new_mtu)
        netdev->mtu = new_mtu;
        adapter->hw.max_frame_size = new_mtu;
        atl1c_set_rxbufsize(adapter, netdev);
+       if (max_frame >= MAX_TX_OFFLOAD_THRESH)
+           netdev->features &= ~(NETIF_F_TSO6 | NETIF_F_TSO | NETIF_F_HW_CSUM);
+       else
+           netdev->features |= (NETIF_F_TSO6 | NETIF_F_TSO | NETIF_F_HW_CSUM);
        atl1c_down(adapter);
        atl1c_up(adapter);
        clear_bit(__AT_RESETTING, &adapter->flags);
        if (adapter->hw.ctrl_flags & ATL1C_FPGA_VERSION) {
            u32 phy_data;
 
-           AT_READ_REG(&adapter->hw, 0x1414, &phy_data);
-           phy_data |= 0x10000000;
-           AT_WRITE_REG(&adapter->hw, 0x1414, phy_data);
+           AT_READ_REG(&adapter->hw, REG_MDIO_CTRL, &phy_data);
+           phy_data |= MDIO_AP_EN;
+           AT_WRITE_REG(&adapter->hw, REG_MDIO_CTRL, phy_data);
        }
 
    }
@@ -1132,7 +1136,7 @@ static int atl1c_stop_mac(struct atl1c_hw *hw)
 
    AT_READ_REG(hw, REG_TXQ_CTRL, &data);
    data &= ~TXQ_CTRL_EN;
-   AT_WRITE_REG(hw, REG_TWSI_CTRL, data);
+   AT_WRITE_REG(hw, REG_TXQ_CTRL, data);
 
    atl1c_wait_until_idle(hw);
 
@@ -1265,8 +1269,9 @@ static void atl1c_set_aspm(struct atl1c_hw *hw, bool linkup)
        else
            pm_ctrl_data &= ~PM_CTRL_ASPM_L1_EN;
    }
-
    AT_WRITE_REG(hw, REG_PM_CTRL, pm_ctrl_data);
+
+   return;
 }
 
 static void atl1c_setup_mac_ctrl(struct atl1c_adapter *adapter)

