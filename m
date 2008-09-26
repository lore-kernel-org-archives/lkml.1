Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbYIZCKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbYIZCKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 22:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbYIZCKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 22:10:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:34556 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbYIZCKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 22:10:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,310,1220252400"; 
   d="scan'208";a="443797971"
Date: Thu, 25 Sep 2008 19:10:36 -0700 (Pacific Daylight Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       agospoda@redhat.com, "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, kkiel@suse.de,
       tglx@linutronix.de, chris.jones@canonical.com, arjan@linux.jf.intel.com
Subject: Re: e1000e NVM corruption issue status
In-Reply-To: <Pine.WNT.4.63.0809251857360.1736@jbrandeb-desk.amr.corp.intel.com>
Message-ID: <Pine.WNT.4.63.0809251910130.1736@jbrandeb-desk.amr.corp.intel.com>
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

e1000e: do not ever sleep in interrupt context

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

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
index 2786754..951080f 100644
--- a/drivers/net/e1000e/e1000.h
+++ b/drivers/net/e1000e/e1000.h
@@ -285,6 +285,8 @@ struct e1000_adapter {
 	unsigned long led_status;
 
 	unsigned int flags;
+	struct work_struct downshift_task;
+	struct work_struct update_phy_task;
 };
 
 struct e1000_info {
diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index 0e51841..1756be4 100644
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
@@ -4575,6 +4598,8 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 
 	INIT_WORK(&adapter->reset_task, e1000_reset_task);
 	INIT_WORK(&adapter->watchdog_task, e1000_watchdog_task);
+	INIT_WORK(&adapter->downshift_task, e1000e_downshift_workaround);
+	INIT_WORK(&adapter->update_phy_task, e1000e_update_phy_task);
 
 	e1000e_check_options(adapter);
 
