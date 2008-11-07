Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbYKGTVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbYKGTVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYKGTVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:21:00 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57346 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbYKGTU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:20:59 -0500
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] igb: Reinitialize tx/rx ring count on resume
To: "Darrick J. Wong" <djwong@us.ibm.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       e1000-devel@lists.sourceforge.net
Date: Fri, 07 Nov 2008 11:20:56 -0800
Message-ID: <20081107192056.13464.7315.stgit@elm3a70.beaverton.ibm.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When suspending the device, adapter->[tr]x_ring structures are freed.  Upon
resume, these two pointers are reallocated but adapter->[tr]x_ring->count is
not set to any value.  This causes igb_setup_tx_resources to fail on zero-sized
buffers and thus the NIC doesn't come back up.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/net/igb/igb_main.c |   28 +++++++++++++++++++++-------
 1 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index 1f397cd..6df8d1d 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -951,6 +951,21 @@ static int igb_is_need_ioport(struct pci_dev *pdev)
 }
 
 /**
+ * igb_set_num_queues - Initialize default queue counts for RX/TX rings
+ * @adapter: Adapter to set queue counts
+ **/
+static void igb_set_num_queues(struct igb_adapter *adapter)
+{
+	int i;
+	adapter->tx_ring->count = 256;
+	for (i = 0; i < adapter->num_tx_queues; i++)
+		adapter->tx_ring[i].count = adapter->tx_ring->count;
+	adapter->rx_ring->count = 256;
+	for (i = 0; i < adapter->num_rx_queues; i++)
+		adapter->rx_ring[i].count = adapter->rx_ring->count;
+}
+
+/**
  * igb_probe - Device Initialization Routine
  * @pdev: PCI device information struct
  * @ent: entry in igb_pci_tbl
@@ -970,7 +985,7 @@ static int __devinit igb_probe(struct pci_dev *pdev,
 	struct pci_dev *us_dev;
 	const struct e1000_info *ei = igb_info_tbl[ent->driver_data];
 	unsigned long mmio_start, mmio_len;
-	int i, err, pci_using_dac, pos;
+	int err, pci_using_dac, pos;
 	u16 eeprom_data = 0, state = 0;
 	u16 eeprom_apme_mask = IGB_EEPROM_APME;
 	u32 part_num;
@@ -1192,12 +1207,7 @@ static int __devinit igb_probe(struct pci_dev *pdev,
 	INIT_WORK(&adapter->watchdog_task, igb_watchdog_task);
 
 	/* Initialize link & ring properties that are user-changeable */
-	adapter->tx_ring->count = 256;
-	for (i = 0; i < adapter->num_tx_queues; i++)
-		adapter->tx_ring[i].count = adapter->tx_ring->count;
-	adapter->rx_ring->count = 256;
-	for (i = 0; i < adapter->num_rx_queues; i++)
-		adapter->rx_ring[i].count = adapter->rx_ring->count;
+	igb_set_num_queues(adapter);
 
 	adapter->fc_autoneg = true;
 	hw->mac.autoneg = true;
@@ -1552,9 +1562,11 @@ int igb_setup_tx_resources(struct igb_adapter *adapter,
 	int size;
 
 	size = sizeof(struct igb_buffer) * tx_ring->count;
+	WARN_ON(!size);
 	tx_ring->buffer_info = vmalloc(size);
 	if (!tx_ring->buffer_info)
 		goto err;
+
 	memset(tx_ring->buffer_info, 0, size);
 
 	/* round up to nearest 4K */
@@ -4388,6 +4400,8 @@ static int igb_resume(struct pci_dev *pdev)
 		return -ENOMEM;
 	}
 
+	igb_set_num_queues(adapter);
+
 	/* e1000_power_up_phy(adapter); */
 
 	igb_reset(adapter);

