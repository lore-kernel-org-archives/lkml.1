Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbYIZCLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbYIZCLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 22:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754987AbYIZCKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 22:10:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:22925 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556AbYIZCKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 22:10:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,310,1220252400"; 
   d="scan'208";a="443798079"
Date: Thu, 25 Sep 2008 19:10:51 -0700 (Pacific Daylight Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       agospoda@redhat.com, "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, kkiel@suse.de,
       tglx@linutronix.de, chris.jones@canonical.com, arjan@linux.jf.intel.com
Subject: Re: e1000e NVM corruption issue status
In-Reply-To: <Pine.WNT.4.63.0809251857360.1736@jbrandeb-desk.amr.corp.intel.com>
Message-ID: <Pine.WNT.4.63.0809251910380.1736@jbrandeb-desk.amr.corp.intel.com>
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

e1000e: fix lockdep issues

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

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
index 1756be4..235c014 100644
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
