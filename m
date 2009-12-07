Return-Path: <linux-kernel-owner+w=401wt.eu-S935555AbZLGRGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935555AbZLGRGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964800AbZLGRG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:06:28 -0500
Received: from mga05.intel.com ([192.55.52.89]:8786 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935536AbZLGRGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:06:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,356,1257148800"; 
   d="scan'208";a="520530866"
Date: Mon, 7 Dec 2009 09:06:30 -0800
From: mark gross <mgross@linux.intel.com>
To: linux-pm <linux-pm@lists.linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, aili@codeaurora.org,
       e1000-devel@lists.sourceforge.net, bruce.w.allan@intel.com,
       linux-wireless@vger.kernel.org, alsa-devel@alsa-project.org,
       tiwai@suse.de
Subject: [PATCH]PM_QOS-to-use-handle-based-requests-wireless-update 4/5
Message-ID: <20091207170630.GE5463@linux.intel.com>
Reply-To: mgross@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: mark gross <mgross@linux.intel.com>
---
 drivers/net/wireless/ipw2x00/ipw2100.c |   11 ++++++-----
 net/mac80211/mlme.c                    |    2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index 39d7b7c..0a6a653 100644
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
@@ -1739,7 +1741,7 @@ static int ipw2100_up(struct ipw2100_priv *priv, int deferred)
 	/* the ipw2100 hardware really doesn't want power management delays
 	 * longer than 175usec
 	 */
-	pm_qos_update_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100", 175);
+	pm_qos_update_request(ipw2100_pm_qos_req, 175);
 
 	/* If the interrupt is enabled, turn it off... */
 	spin_lock_irqsave(&priv->low_lock, flags);
@@ -1887,8 +1889,7 @@ static void ipw2100_down(struct ipw2100_priv *priv)
 	ipw2100_disable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->low_lock, flags);
 
-	pm_qos_update_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100",
-			PM_QOS_DEFAULT_VALUE);
+	pm_qos_update_request(ipw2100_pm_qos_req, PM_QOS_DEFAULT_VALUE);
 
 	/* We have to signal any supplicant if we are disassociating */
 	if (associated)
@@ -6658,7 +6659,7 @@ static int __init ipw2100_init(void)
 	if (ret)
 		goto out;
 
-	pm_qos_add_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100",
+	ipw2100_pm_qos_req = pm_qos_add_request(PM_QOS_CPU_DMA_LATENCY,
 			PM_QOS_DEFAULT_VALUE);
 #ifdef CONFIG_IPW2100_DEBUG
 	ipw2100_debug_level = debug;
@@ -6681,7 +6682,7 @@ static void __exit ipw2100_exit(void)
 			   &driver_attr_debug_level);
 #endif
 	pci_unregister_driver(&ipw2100_pci_driver);
-	pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100");
+	pm_qos_remove_request(ipw2100_pm_qos_req);
 }
 
 module_init(ipw2100_init);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6dc7b5a..b8c5caf 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -707,7 +707,7 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 		s32 beaconint_us;
 
 		if (latency < 0)
-			latency = pm_qos_requirement(PM_QOS_NETWORK_LATENCY);
+			latency = pm_qos_request(PM_QOS_NETWORK_LATENCY);
 
 		beaconint_us = ieee80211_tu_to_usec(
 					found->vif.bss_conf.beacon_int);
-- 
1.6.3.3

