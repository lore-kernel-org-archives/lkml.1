Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbZLAVf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbZLAVf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 16:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbZLAVf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 16:35:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:58271 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbZLAVf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 16:35:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,322,1257148800"; 
   d="scan'208";a="574735133"
Date: Tue, 1 Dec 2009 13:35:32 -0800
From: mark gross <mgross@linux.intel.com>
To: linux-pm <linux-pm@lists.linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: [PATCH]PM_QOS-to-use-handle-based-requests-wireless-update 4/5
Message-ID: <20091201213532.GD19688@linux.intel.com>
Reply-To: mgross@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updates to wireless clients to pm_qos associeated with api change to use
handles.

--mgross

Signed-off-by: mark gross <mgross@linux.intel.com>


>From 64fdd9afd7d705368448548c8c3555c014fb318a Mon Sep 17 00:00:00 2001
From: mark gross <mgross@mgross-hp8510w.(none)>
Date: Tue, 1 Dec 2009 13:00:31 -0800
Subject: [PATCH 4/5] PM_QOS to use handle based requests wireless update

---
 drivers/net/wireless/ipw2x00/ipw2100.c |   11 ++++++-----
 net/mac80211/mlme.c                    |    2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index 6e2fc0c..6fe87f0 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -174,6 +174,8 @@ that only one external action is invoked at a time.
 #define DRV_DESCRIPTION	"Intel(R) PRO/Wireless 2100 Network Driver"
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2006 Intel Corporation"
 
+struct pm_qos_request_list *ipw2100_pm_qos_req;
+
 /* Debugging stuff */
 #ifdef CONFIG_IPW2100_DEBUG
 #define IPW2100_RX_DEBUG	/* Reception debugging */
@@ -1708,7 +1710,7 @@ static int ipw2100_up(struct ipw2100_priv *priv, int deferred)
 	/* the ipw2100 hardware really doesn't want power management delays
 	 * longer than 175usec
 	 */
-	pm_qos_update_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100", 175);
+	pm_qos_update_request(ipw2100_pm_qos_req, 175);
 
 	/* If the interrupt is enabled, turn it off... */
 	spin_lock_irqsave(&priv->low_lock, flags);
@@ -1863,8 +1865,7 @@ static void ipw2100_down(struct ipw2100_priv *priv)
 	ipw2100_disable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->low_lock, flags);
 
-	pm_qos_update_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100",
-			PM_QOS_DEFAULT_VALUE);
+	pm_qos_update_request(ipw2100_pm_qos_req, PM_QOS_DEFAULT_VALUE);
 
 	/* We have to signal any supplicant if we are disassociating */
 	if (associated)
@@ -6572,7 +6573,7 @@ static int __init ipw2100_init(void)
 	if (ret)
 		goto out;
 
-	pm_qos_add_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100",
+	ipw2100_pm_qos_req = pm_qos_add_request(PM_QOS_CPU_DMA_LATENCY,
 			PM_QOS_DEFAULT_VALUE);
 #ifdef CONFIG_IPW2100_DEBUG
 	ipw2100_debug_level = debug;
@@ -6595,7 +6596,7 @@ static void __exit ipw2100_exit(void)
 			   &driver_attr_debug_level);
 #endif
 	pci_unregister_driver(&ipw2100_pci_driver);
-	pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100");
+	pm_qos_remove_request(ipw2100_pm_qos_req);
 }
 
 module_init(ipw2100_init);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index dc5049d..ed1d2dd 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -696,7 +696,7 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 		s32 beaconint_us;
 
 		if (latency < 0)
-			latency = pm_qos_requirement(PM_QOS_NETWORK_LATENCY);
+			latency = pm_qos_request(PM_QOS_NETWORK_LATENCY);
 
 		beaconint_us = ieee80211_tu_to_usec(
 					found->vif.bss_conf.beacon_int);
-- 
1.6.3.3

