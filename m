Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYAACJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYAACJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 21:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYAACFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 21:05:52 -0500
Received: from fmailhost04.isp.att.net ([207.115.11.54]:59464 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbYAACFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 21:05:34 -0500
X-Originating-IP: [68.222.90.230]
From: jacliburn@bellsouth.net
To: jeff@garzik.org
Cc: csnook@redhat.com, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net, Jay Cliburn <jacliburn@bellsouth.net>
Subject: [PATCH 23/26] atl1: update shutdown and remove functions
Date: Mon, 31 Dec 2007 20:00:01 -0600
Message-Id: <1199152804-3889-24-git-send-email-jacliburn@bellsouth.net>
X-Mailer: git-send-email 1.5.3.3
In-Reply-To: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
References: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Cliburn <jacliburn@bellsouth.net>

Update shutdown and remove functions to conform with the current vendor
driver version 1.2.40.2.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---
 drivers/net/atlx/atl1.c |   31 +++++++++++++++++++++++--------
 1 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index f09928d..b89201e 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -2591,6 +2591,16 @@ static int atl1_close(struct net_device *netdev)
 	return 0;
 }
 
+static void atl1_force_ps(struct atl1_hw *hw)
+{
+	atl1_write_phy_reg(hw, MII_DBG_ADDR, 0);
+	atl1_write_phy_reg(hw, MII_DBG_DATA, 0x124E);
+	atl1_write_phy_reg(hw, MII_DBG_ADDR, 2);
+	atl1_write_phy_reg(hw, MII_DBG_DATA, 0x3000);
+	atl1_write_phy_reg(hw, MII_DBG_ADDR, 3);
+	atl1_write_phy_reg(hw, MII_DBG_DATA, 0);
+}
+
 #ifdef CONFIG_PM
 static int atl1_suspend(struct pci_dev *pdev, pm_message_t state)
 {
@@ -2878,12 +2888,7 @@ err_request_regions:
 static void __devexit atl1_remove(struct pci_dev *pdev)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
-	struct atl1_adapter *adapter;
-	/* Device not available. Return. */
-	if (!netdev)
-		return;
-
-	adapter = netdev_priv(netdev);
+	struct atl1_adapter *adapter = netdev_priv(netdev);
 
 	/*
 	 * Some atl1 boards lack persistent storage for their MAC, and get it
@@ -2896,21 +2901,31 @@ static void __devexit atl1_remove(struct pci_dev *pdev)
 		atl1_set_mac_addr(&adapter->hw);
 	}
 
-	iowrite16(0, adapter->hw.hw_addr + REG_PHY_ENABLE);
+	set_bit(__ATL1_DOWN, &adapter->flags);
+	del_timer_sync(&adapter->watchdog_timer);
+	del_timer_sync(&adapter->phy_config_timer);
+	flush_scheduled_work();
 	unregister_netdev(netdev);
+	atl1_force_ps(&adapter->hw);
 	pci_iounmap(pdev, adapter->hw.hw_addr);
 	pci_release_regions(pdev);
 	free_netdev(netdev);
 	pci_disable_device(pdev);
 }
 
+static void atl1_shutdown(struct pci_dev *pdev)
+{
+	atl1_suspend(pdev, PMSG_SUSPEND);
+}
+
 static struct pci_driver atl1_driver = {
 	.name = ATLX_DRIVER_NAME,
 	.id_table = atl1_pci_tbl,
 	.probe = atl1_probe,
 	.remove = __devexit_p(atl1_remove),
 	.suspend = atl1_suspend,
-	.resume = atl1_resume
+	.resume = atl1_resume,
+	.shutdown = atl1_shutdown
 };
 
 /*
-- 
1.5.3.3

