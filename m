Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbYI3DWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbYI3DWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbYI3DTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:19:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:59015 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbYI3DTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:19:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,334,1220252400"; 
   d="scan'208";a="53008360"
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [RFC PATCH 06/12] e1000e: drop stats lock
To: linux-kernel@vger.kernel.org
Cc: linux-netdev@vger.kernel.org, kkeil@suse.de, agospoda@redhat.com,
       arjan@linux.intel.com, david.graham@intel.com, bruce.w.allan@intel.com,
       jkosina@suse.cz, john.ronciak@intel.com, tglx@linutronix.de,
       chris.jones@canonical.com, tim.gardner@intel.com, airlied@gmail.com,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 29 Sep 2008 20:19:47 -0700
Message-ID: <20080930031947.22950.34259.stgit@jbrandeb-bw.jf.intel.com>
In-Reply-To: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
User-Agent: StGIT/0.14.3.163.g06f9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Sep 2008 03:19:47.0872 (UTC) FILETIME=[64909A00:01C922AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the stats lock is left over from e1000, e1000e no longer
has the adjust tbi stats function that required the addition
of the stats lock to begin with.

adding a mutex to acquire_swflag helped catch this one too.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>
---

 drivers/net/e1000e/e1000.h  |    1 -
 drivers/net/e1000e/netdev.c |   18 ------------------
 2 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/drivers/net/e1000e/e1000.h b/drivers/net/e1000e/e1000.h
index ed9d974..f80e43a 100644
--- a/drivers/net/e1000e/e1000.h
+++ b/drivers/net/e1000e/e1000.h
@@ -257,7 +257,6 @@ struct e1000_adapter {
 	struct net_device *netdev;
 	struct pci_dev *pdev;
 	struct net_device_stats net_stats;
-	spinlock_t stats_lock;      /* prevent concurrent stats updates */
 
 	/* structs defined in e1000_hw.h */
 	struct e1000_hw hw;
diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index 44ce120..9aa3c79 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -2600,8 +2600,6 @@ static int __devinit e1000_sw_init(struct e1000_adapter *adapter)
 	/* Explicitly disable IRQ since the NIC can be in any state. */
 	e1000_irq_disable(adapter);
 
-	spin_lock_init(&adapter->stats_lock);
-
 	set_bit(__E1000_DOWN, &adapter->state);
 	return 0;
 
@@ -2953,7 +2951,6 @@ void e1000e_update_stats(struct e1000_adapter *adapter)
 {
 	struct e1000_hw *hw = &adapter->hw;
 	struct pci_dev *pdev = adapter->pdev;
-	unsigned long irq_flags;
 
 	/*
 	 * Prevent stats update while adapter is being reset, or if the pci
@@ -2964,14 +2961,6 @@ void e1000e_update_stats(struct e1000_adapter *adapter)
 	if (pci_channel_offline(pdev))
 		return;
 
-	spin_lock_irqsave(&adapter->stats_lock, irq_flags);
-
-	/*
-	 * these counters are modified from e1000_adjust_tbi_stats,
-	 * called from the interrupt context, so they must only
-	 * be written while holding adapter->stats_lock
-	 */
-
 	adapter->stats.crcerrs += er32(CRCERRS);
 	adapter->stats.gprc += er32(GPRC);
 	adapter->stats.gorc += er32(GORCL);
@@ -3046,8 +3035,6 @@ void e1000e_update_stats(struct e1000_adapter *adapter)
 	adapter->stats.mgptc += er32(MGTPTC);
 	adapter->stats.mgprc += er32(MGTPRC);
 	adapter->stats.mgpdc += er32(MGTPDC);
-
-	spin_unlock_irqrestore(&adapter->stats_lock, irq_flags);
 }
 
 /**
@@ -3059,9 +3046,6 @@ static void e1000_phy_read_status(struct e1000_adapter *adapter)
 	struct e1000_hw *hw = &adapter->hw;
 	struct e1000_phy_regs *phy = &adapter->phy_regs;
 	int ret_val;
-	unsigned long irq_flags;
-
-	spin_lock_irqsave(&adapter->stats_lock, irq_flags);
 
 	if ((er32(STATUS) & E1000_STATUS_LU) &&
 	    (adapter->hw.phy.media_type == e1000_media_type_copper)) {
@@ -3092,8 +3076,6 @@ static void e1000_phy_read_status(struct e1000_adapter *adapter)
 		phy->stat1000 = 0;
 		phy->estatus = (ESTATUS_1000_TFULL | ESTATUS_1000_THALF);
 	}
-
-	spin_unlock_irqrestore(&adapter->stats_lock, irq_flags);
 }
 
 static void e1000_print_link_info(struct e1000_adapter *adapter)

