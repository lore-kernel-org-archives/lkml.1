Return-Path: <linux-kernel-owner+w=401wt.eu-S1763547AbYF0SIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763547AbYF0SIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762364AbYF0SCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:02:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:45640 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762341AbYF0SCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:02:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,716,1204531200"; 
   d="scan'208";a="3660004"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [NET-NEXT PATCH 18/18] igb: update suspend resume
To: jeff@garzik.org, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net
Date: Fri, 27 Jun 2008 11:02:11 -0700
Message-ID: <20080627180208.22428.8436.stgit@localhost.localdomain>
In-Reply-To: <20080627175921.22428.52767.stgit@localhost.localdomain>
References: <20080627175921.22428.52767.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jun 2008 18:02:11.0526 (UTC) FILETIME=[EC32D660:01C8D87F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@intel.com>

Updates the suspend and resume to better handle the possibility of MSIX
vector changes.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---

 drivers/net/igb/igb_main.c |   46 ++++++++++++++++++++++++++++----------------
 1 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index c43f287..eb90bf8 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -272,6 +272,17 @@ static int igb_alloc_queues(struct igb_adapter *adapter)
 	return 0;
 }
 
+static void igb_free_queues(struct igb_adapter *adapter)
+{
+	int i;
+
+	for (i = 0; i < adapter->num_rx_queues; i++)
+		netif_napi_del(&adapter->rx_ring[i].napi);
+
+	kfree(adapter->tx_ring);
+	kfree(adapter->rx_ring);
+}
+
 #define IGB_N0_QUEUE -1
 static void igb_assign_vector(struct igb_adapter *adapter, int rx_queue,
 			      int tx_queue, int msix_vector)
@@ -1295,8 +1306,7 @@ err_eeprom:
 		iounmap(hw->flash_address);
 
 	igb_remove_device(hw);
-	kfree(adapter->tx_ring);
-	kfree(adapter->rx_ring);
+	igb_free_queues(adapter);
 err_sw_init:
 err_hw_init:
 	iounmap(hw->hw_addr);
@@ -1354,8 +1364,7 @@ static void __devexit igb_remove(struct pci_dev *pdev)
 	igb_remove_device(&adapter->hw);
 	igb_reset_interrupt_capability(adapter);
 
-	kfree(adapter->tx_ring);
-	kfree(adapter->rx_ring);
+	igb_free_queues(adapter);
 
 	iounmap(adapter->hw.hw_addr);
 	if (adapter->hw.flash_address)
@@ -4299,11 +4308,12 @@ static int igb_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	netif_device_detach(netdev);
 
-	if (netif_running(netdev)) {
-		WARN_ON(test_bit(__IGB_RESETTING, &adapter->state));
-		igb_down(adapter);
-		igb_free_irq(adapter);
-	}
+	if (netif_running(netdev))
+		igb_close(netdev);
+
+	igb_reset_interrupt_capability(adapter);
+
+	igb_free_queues(adapter);
 
 #ifdef CONFIG_PM
 	retval = pci_save_state(pdev);
@@ -4386,10 +4396,11 @@ static int igb_resume(struct pci_dev *pdev)
 	pci_enable_wake(pdev, PCI_D3hot, 0);
 	pci_enable_wake(pdev, PCI_D3cold, 0);
 
-	if (netif_running(netdev)) {
-		err = igb_request_irq(adapter);
-		if (err)
-			return err;
+	igb_set_interrupt_capability(adapter);
+
+	if (igb_alloc_queues(adapter)) {
+		dev_err(&pdev->dev, "Unable to allocate memory for queues\n");
+		return -ENOMEM;
 	}
 
 	/* e1000_power_up_phy(adapter); */
@@ -4397,10 +4408,11 @@ static int igb_resume(struct pci_dev *pdev)
 	igb_reset(adapter);
 	wr32(E1000_WUS, ~0);
 
-	igb_init_manageability(adapter);
-
-	if (netif_running(netdev))
-		igb_up(adapter);
+	if (netif_running(netdev)) {
+		err = igb_open(netdev);
+		if (err)
+			return err;
+	}
 
 	netif_device_attach(netdev);
 

