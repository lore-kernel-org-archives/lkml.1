Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbYI3DVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbYI3DVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbYI3DTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:19:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:13616 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbYI3DTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:19:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,334,1220252400"; 
   d="scan'208";a="53008341"
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [RFC PATCH 05/12] e1000e: fix lockdep issues
To: linux-kernel@vger.kernel.org
Cc: linux-netdev@vger.kernel.org, kkeil@suse.de, agospoda@redhat.com,
       arjan@linux.intel.com, david.graham@intel.com, bruce.w.allan@intel.com,
       jkosina@suse.cz, john.ronciak@intel.com, tglx@linutronix.de,
       chris.jones@canonical.com, tim.gardner@intel.com, airlied@gmail.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Date: Mon, 29 Sep 2008 20:19:42 -0700
Message-ID: <20080930031942.22950.36069.stgit@jbrandeb-bw.jf.intel.com>
In-Reply-To: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
User-Agent: StGIT/0.14.3.163.g06f9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Sep 2008 03:19:42.0747 (UTC) FILETIME=[618296B0:01C922AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks to tglx, we're finding some interesting lockdep issues.
The good news is that this patch fixes all the ones I
could find, without damaging any functionality.

CC: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---

 drivers/net/e1000e/ethtool.c |    6 +++++-
 drivers/net/e1000e/netdev.c  |   13 -------------
 2 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/net/e1000e/ethtool.c b/drivers/net/e1000e/ethtool.c
index e21c9e0..f3b49f6 100644
--- a/drivers/net/e1000e/ethtool.c
+++ b/drivers/net/e1000e/ethtool.c
@@ -432,6 +432,10 @@ static void e1000_get_regs(struct net_device *netdev,
 	regs_buff[11] = er32(TIDV);
 
 	regs_buff[12] = adapter->hw.phy.type;  /* PHY type (IGP=1, M88=0) */
+
+	/* ethtool doesn't use anything past this point, so all this
+	 * code is likely legacy junk for apps that may or may not
+	 * exist */
 	if (hw->phy.type == e1000_phy_m88) {
 		e1e_rphy(hw, M88E1000_PHY_SPEC_STATUS, &phy_data);
 		regs_buff[13] = (u32)phy_data; /* cable length */
@@ -447,7 +451,7 @@ static void e1000_get_regs(struct net_device *netdev,
 		regs_buff[22] = adapter->phy_stats.receive_errors;
 		regs_buff[23] = regs_buff[13]; /* mdix mode */
 	}
-	regs_buff[21] = adapter->phy_stats.idle_errors;  /* phy idle errors */
+	regs_buff[21] = 0; /* was idle_errors */
 	e1e_rphy(hw, PHY_1000T_STATUS, &phy_data);
 	regs_buff[24] = (u32)phy_data;  /* phy local receiver status */
 	regs_buff[25] = regs_buff[24];  /* phy remote receiver status */
diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index f8c6c32..44ce120 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -2954,9 +2954,6 @@ void e1000e_update_stats(struct e1000_adapter *adapter)
 	struct e1000_hw *hw = &adapter->hw;
 	struct pci_dev *pdev = adapter->pdev;
 	unsigned long irq_flags;
-	u16 phy_tmp;
-
-#define PHY_IDLE_ERROR_COUNT_MASK 0x00FF
 
 	/*
 	 * Prevent stats update while adapter is being reset, or if the pci
@@ -3045,15 +3042,6 @@ void e1000e_update_stats(struct e1000_adapter *adapter)
 
 	/* Tx Dropped needs to be maintained elsewhere */
 
-	/* Phy Stats */
-	if (hw->phy.media_type == e1000_media_type_copper) {
-		if ((adapter->link_speed == SPEED_1000) &&
-		   (!e1e_rphy(hw, PHY_1000T_STATUS, &phy_tmp))) {
-			phy_tmp &= PHY_IDLE_ERROR_COUNT_MASK;
-			adapter->phy_stats.idle_errors += phy_tmp;
-		}
-	}
-
 	/* Management Stats */
 	adapter->stats.mgptc += er32(MGTPTC);
 	adapter->stats.mgprc += er32(MGTPRC);
@@ -3073,7 +3061,6 @@ static void e1000_phy_read_status(struct e1000_adapter *adapter)
 	int ret_val;
 	unsigned long irq_flags;
 
-
 	spin_lock_irqsave(&adapter->stats_lock, irq_flags);
 
 	if ((er32(STATUS) & E1000_STATUS_LU) &&

