Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbYIZCLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbYIZCLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 22:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754393AbYIZCLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 22:11:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:15658 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738AbYIZCLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 22:11:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,310,1220252400"; 
   d="scan'208";a="340663916"
Date: Thu, 25 Sep 2008 19:11:04 -0700 (Pacific Daylight Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       agospoda@redhat.com, "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, kkiel@suse.de,
       tglx@linutronix.de, chris.jones@canonical.com, arjan@linux.jf.intel.com
Subject: Re: e1000e NVM corruption issue status
In-Reply-To: <Pine.WNT.4.63.0809251857360.1736@jbrandeb-desk.amr.corp.intel.com>
Message-ID: <Pine.WNT.4.63.0809251910530.1736@jbrandeb-desk.amr.corp.intel.com>
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com>
 <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com>
 <Pine.WNT.4.63.0809251857360.1736@jbrandeb-desk.amr.corp.intel.com>
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: jesse.brandeburg@intel.com@imap.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

e1000e: drop stats lock

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

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
index 951080f..2a3a311 100644
--- a/drivers/net/e1000e/e1000.h
+++ b/drivers/net/e1000e/e1000.h
@@ -258,7 +258,6 @@ struct e1000_adapter {
 	struct net_device *netdev;
 	struct pci_dev *pdev;
 	struct net_device_stats net_stats;
-	spinlock_t stats_lock;      /* prevent concurrent stats updates */
 
 	/* structs defined in e1000_hw.h */
 	struct e1000_hw hw;
diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index 235c014..bd7fa13 100644
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
