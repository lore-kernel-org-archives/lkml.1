Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbYJBXeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbYJBXeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbYJBXd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:33:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:14561 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159AbYJBXd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:33:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,353,1220252400"; 
   d="scan'208";a="446393133"
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH 2.6.27-rc8 2/6] e1000e: do not ever sleep in interrupt context
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, tglx@linutronix.de,
       arjan@linux.intel.com, airlied@gmail.com, davem@davemloft.net,
       jeff@garzik.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 02 Oct 2008 16:33:25 -0700
Message-ID: <20081002233325.12556.74382.stgit@jbrandeb-bw.jf.intel.com>
In-Reply-To: <20081002233314.12556.49143.stgit@jbrandeb-bw.jf.intel.com>
References: <20081002233314.12556.49143.stgit@jbrandeb-bw.jf.intel.com>
User-Agent: StGIT/0.14.3.163.g06f9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Oct 2008 23:33:25.0155 (UTC) FILETIME=[43DFB730:01C924E7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

e1000e was apparently calling two functions that attempted to reserve
the SWFLAG bit for exclusive (to hardware and firmware) access to
the PHY and NVM (aka eeprom).  These accesses could possibly call
msleep to wait for the resource which is not allowed from interrupt
context.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>
---

 drivers/net/e1000e/e1000.h  |    2 ++
 drivers/net/e1000e/netdev.c |   31 ++++++++++++++++++++++++++++---
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/net/e1000e/e1000.h b/drivers/net/e1000e/e1000.h
index f0c48a2..8087bda 100644
--- a/drivers/net/e1000e/e1000.h
+++ b/drivers/net/e1000e/e1000.h
@@ -284,6 +284,8 @@ struct e1000_adapter {
 	unsigned long led_status;
 
 	unsigned int flags;
+	struct work_struct downshift_task;
+	struct work_struct update_phy_task;
 };
 
 struct e1000_info {
diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index 1f767fe..803545b 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -1115,6 +1115,14 @@ static void e1000_clean_rx_ring(struct e1000_adapter *adapter)
 	writel(0, adapter->hw.hw_addr + rx_ring->tail);
 }
 
+static void e1000e_downshift_workaround(struct work_struct *work)
+{
+	struct e1000_adapter *adapter = container_of(work,
+					struct e1000_adapter, downshift_task);
+
+	e1000e_gig_downshift_workaround_ich8lan(&adapter->hw);
+}
+
 /**
  * e1000_intr_msi - Interrupt Handler
  * @irq: interrupt number
@@ -1139,7 +1147,7 @@ static irqreturn_t e1000_intr_msi(int irq, void *data)
 		 */
 		if ((adapter->flags & FLAG_LSC_GIG_SPEED_DROP) &&
 		    (!(er32(STATUS) & E1000_STATUS_LU)))
-			e1000e_gig_downshift_workaround_ich8lan(hw);
+			schedule_work(&adapter->downshift_task);
 
 		/*
 		 * 80003ES2LAN workaround-- For packet buffer work-around on
@@ -1205,7 +1213,7 @@ static irqreturn_t e1000_intr(int irq, void *data)
 		 */
 		if ((adapter->flags & FLAG_LSC_GIG_SPEED_DROP) &&
 		    (!(er32(STATUS) & E1000_STATUS_LU)))
-			e1000e_gig_downshift_workaround_ich8lan(hw);
+			schedule_work(&adapter->downshift_task);
 
 		/*
 		 * 80003ES2LAN workaround--
@@ -2912,6 +2920,21 @@ static int e1000_set_mac(struct net_device *netdev, void *p)
 	return 0;
 }
 
+/**
+ * e1000e_update_phy_task - work thread to update phy
+ * @work: pointer to our work struct
+ *
+ * this worker thread exists because we must acquire a
+ * semaphore to read the phy, which we could msleep while
+ * waiting for it, and we can't msleep in a timer.
+ **/
+static void e1000e_update_phy_task(struct work_struct *work)
+{
+	struct e1000_adapter *adapter = container_of(work,
+					struct e1000_adapter, update_phy_task);
+	e1000_get_phy_info(&adapter->hw);
+}
+
 /*
  * Need to wait a few seconds after link up to get diagnostic information from
  * the phy
@@ -2919,7 +2942,7 @@ static int e1000_set_mac(struct net_device *netdev, void *p)
 static void e1000_update_phy_info(unsigned long data)
 {
 	struct e1000_adapter *adapter = (struct e1000_adapter *) data;
-	e1000_get_phy_info(&adapter->hw);
+	schedule_work(&adapter->update_phy_task);
 }
 
 /**
@@ -4578,6 +4601,8 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 
 	INIT_WORK(&adapter->reset_task, e1000_reset_task);
 	INIT_WORK(&adapter->watchdog_task, e1000_watchdog_task);
+	INIT_WORK(&adapter->downshift_task, e1000e_downshift_workaround);
+	INIT_WORK(&adapter->update_phy_task, e1000e_update_phy_task);
 
 	/* Initialize link parameters. User can change them with ethtool */
 	adapter->hw.mac.autoneg = 1;

