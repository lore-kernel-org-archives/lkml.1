Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776Ab0A0AEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab0A0AEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687Ab0A0ADq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:03:46 -0500
Received: from kroah.org ([198.145.64.141]:35145 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106Ab0AZXnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:15 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:23 2010
Message-Id: <20100126233923.487128431@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jie Yang <jie.yang@atheros.com>,
       "David S. Miller" <davem@davemloft.net>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: [20/98] atl1c:use common_task instead of reset_task and link_chg_task
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jie Yang <jie.yang@atheros.com>

commit cb19054697e92a793f336380fd72c588521178ff upstream.

use common_task instead of reset_task and link_chg_task, so it fix "call cancel_work_sync
from the work itself".

Signed-off-by: Jie Yang <jie.yang@atheros.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/atl1c/atl1c.h      |    6 ++-
 drivers/net/atl1c/atl1c_main.c |   72 ++++++++++++++++++-----------------------
 2 files changed, 37 insertions(+), 41 deletions(-)

--- a/drivers/net/atl1c/atl1c.h
+++ b/drivers/net/atl1c/atl1c.h
@@ -534,6 +534,9 @@ struct atl1c_adapter {
 #define __AT_TESTING        0x0001
 #define __AT_RESETTING      0x0002
 #define __AT_DOWN           0x0003
+	u8 work_event;
+#define ATL1C_WORK_EVENT_RESET 		0x01
+#define ATL1C_WORK_EVENT_LINK_CHANGE	0x02
 	u32 msg_enable;
 
 	bool have_msi;
@@ -545,8 +548,7 @@ struct atl1c_adapter {
 	spinlock_t tx_lock;
 	atomic_t irq_sem;
 
-	struct work_struct reset_task;
-	struct work_struct link_chg_task;
+	struct work_struct common_task;
 	struct timer_list watchdog_timer;
 	struct timer_list phy_config_timer;
 
--- a/drivers/net/atl1c/atl1c_main.c
+++ b/drivers/net/atl1c/atl1c_main.c
@@ -198,27 +198,12 @@ static void atl1c_phy_config(unsigned lo
 
 void atl1c_reinit_locked(struct atl1c_adapter *adapter)
 {
-
 	WARN_ON(in_interrupt());
 	atl1c_down(adapter);
 	atl1c_up(adapter);
 	clear_bit(__AT_RESETTING, &adapter->flags);
 }
 
-static void atl1c_reset_task(struct work_struct *work)
-{
-	struct atl1c_adapter *adapter;
-	struct net_device *netdev;
-
-	adapter = container_of(work, struct atl1c_adapter, reset_task);
-	netdev = adapter->netdev;
-
-	netif_device_detach(netdev);
-	atl1c_down(adapter);
-	atl1c_up(adapter);
-	netif_device_attach(netdev);
-}
-
 static void atl1c_check_link_status(struct atl1c_adapter *adapter)
 {
 	struct atl1c_hw *hw = &adapter->hw;
@@ -275,18 +260,6 @@ static void atl1c_check_link_status(stru
 	}
 }
 
-/*
- * atl1c_link_chg_task - deal with link change event Out of interrupt context
- * @netdev: network interface device structure
- */
-static void atl1c_link_chg_task(struct work_struct *work)
-{
-	struct atl1c_adapter *adapter;
-
-	adapter = container_of(work, struct atl1c_adapter, link_chg_task);
-	atl1c_check_link_status(adapter);
-}
-
 static void atl1c_link_chg_event(struct atl1c_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
@@ -311,20 +284,40 @@ static void atl1c_link_chg_event(struct 
 			adapter->link_speed = SPEED_0;
 		}
 	}
-	schedule_work(&adapter->link_chg_task);
+
+	adapter->work_event |= ATL1C_WORK_EVENT_LINK_CHANGE;
+	schedule_work(&adapter->common_task);
 }
 
-static void atl1c_del_timer(struct atl1c_adapter *adapter)
+static void atl1c_common_task(struct work_struct *work)
 {
-	del_timer_sync(&adapter->phy_config_timer);
+	struct atl1c_adapter *adapter;
+	struct net_device *netdev;
+
+	adapter = container_of(work, struct atl1c_adapter, common_task);
+	netdev = adapter->netdev;
+
+	if (adapter->work_event & ATL1C_WORK_EVENT_RESET) {
+		netif_device_detach(netdev);
+		atl1c_down(adapter);
+		atl1c_up(adapter);
+		netif_device_attach(netdev);
+		return;
+	}
+
+	if (adapter->work_event & ATL1C_WORK_EVENT_LINK_CHANGE)
+		atl1c_check_link_status(adapter);
+
+	return;
 }
 
-static void atl1c_cancel_work(struct atl1c_adapter *adapter)
+
+static void atl1c_del_timer(struct atl1c_adapter *adapter)
 {
-	cancel_work_sync(&adapter->reset_task);
-	cancel_work_sync(&adapter->link_chg_task);
+	del_timer_sync(&adapter->phy_config_timer);
 }
 
+
 /*
  * atl1c_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
@@ -334,7 +327,8 @@ static void atl1c_tx_timeout(struct net_
 	struct atl1c_adapter *adapter = netdev_priv(netdev);
 
 	/* Do the reset outside of interrupt context */
-	schedule_work(&adapter->reset_task);
+	adapter->work_event |= ATL1C_WORK_EVENT_RESET;
+	schedule_work(&adapter->common_task);
 }
 
 /*
@@ -1536,7 +1530,8 @@ static irqreturn_t atl1c_intr(int irq, v
 			/* reset MAC */
 			hw->intr_mask &= ~ISR_ERROR;
 			AT_WRITE_REG(hw, REG_IMR, hw->intr_mask);
-			schedule_work(&adapter->reset_task);
+			adapter->work_event |= ATL1C_WORK_EVENT_RESET;
+			schedule_work(&adapter->common_task);
 			break;
 		}
 
@@ -2200,8 +2195,7 @@ void atl1c_down(struct atl1c_adapter *ad
 	struct net_device *netdev = adapter->netdev;
 
 	atl1c_del_timer(adapter);
-	atl1c_cancel_work(adapter);
-
+	adapter->work_event = 0; /* clear all event */
 	/* signal that we're down so the interrupt handler does not
 	 * reschedule our watchdog timer */
 	set_bit(__AT_DOWN, &adapter->flags);
@@ -2601,8 +2595,8 @@ static int __devinit atl1c_probe(struct 
 			adapter->hw.mac_addr[4], adapter->hw.mac_addr[5]);
 
 	atl1c_hw_set_mac_addr(&adapter->hw);
-	INIT_WORK(&adapter->reset_task, atl1c_reset_task);
-	INIT_WORK(&adapter->link_chg_task, atl1c_link_chg_task);
+	INIT_WORK(&adapter->common_task, atl1c_common_task);
+	adapter->work_event = 0;
 	err = register_netdev(netdev);
 	if (err) {
 		dev_err(&pdev->dev, "register netdevice failed\n");


