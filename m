Return-Path: <linux-kernel-owner+w=401wt.eu-S935539AbZLGRGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935539AbZLGRGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935536AbZLGRGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:06:21 -0500
Received: from mga07.intel.com ([143.182.124.22]:38195 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935517AbZLGRGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:06:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="219727455"
Date: Mon, 7 Dec 2009 09:06:23 -0800
From: mark gross <mgross@linux.intel.com>
To: linux-pm <linux-pm@lists.linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, aili@codeaurora.org,
       e1000-devel@lists.sourceforge.net, bruce.w.allan@intel.com,
       linux-wireless@vger.kernel.org, alsa-devel@alsa-project.org,
       tiwai@suse.de
Subject: [PATCH]PM_QOS-to-use-handle-based-requests-network-update 3/5
Message-ID: <20091207170623.GD5463@linux.intel.com>
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
 drivers/net/e1000e/netdev.c |   22 ++++++++++++----------
 drivers/net/igbvf/netdev.c  |    6 ++++--
 include/linux/netdevice.h   |    4 ++++
 3 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index c3105c5..939f8f9 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -2518,12 +2518,12 @@ static void e1000_configure_rx(struct e1000_adapter *adapter)
 			 * excessive C-state transition latencies result in
 			 * dropped transactions.
 			 */
-			pm_qos_update_requirement(PM_QOS_CPU_DMA_LATENCY,
-						  adapter->netdev->name, 55);
+			pm_qos_update_request(
+				adapter->netdev->pm_qos_req, 55);
 		} else {
-			pm_qos_update_requirement(PM_QOS_CPU_DMA_LATENCY,
-						  adapter->netdev->name,
-						  PM_QOS_DEFAULT_VALUE);
+			pm_qos_update_request(
+				adapter->netdev->pm_qos_req,
+				PM_QOS_DEFAULT_VALUE);
 		}
 	}
 
@@ -2833,8 +2833,8 @@ int e1000e_up(struct e1000_adapter *adapter)
 
 	/* DMA latency requirement to workaround early-receive/jumbo issue */
 	if (adapter->flags & FLAG_HAS_ERT)
-		pm_qos_add_requirement(PM_QOS_CPU_DMA_LATENCY,
-		                       adapter->netdev->name,
+		adapter->netdev->pm_qos_req =
+			pm_qos_add_request(PM_QOS_CPU_DMA_LATENCY,
 				       PM_QOS_DEFAULT_VALUE);
 
 	/* hardware has been reset, we need to reload some things */
@@ -2897,9 +2897,11 @@ void e1000e_down(struct e1000_adapter *adapter)
 	e1000_clean_tx_ring(adapter);
 	e1000_clean_rx_ring(adapter);
 
-	if (adapter->flags & FLAG_HAS_ERT)
-		pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY,
-		                          adapter->netdev->name);
+	if (adapter->flags & FLAG_HAS_ERT) {
+		pm_qos_remove_request(
+			      adapter->netdev->pm_qos_req);
+		adapter->netdev->pm_qos_req = NULL;
+	}
 
 	/*
 	 * TODO: for power management, we could drop the link and
diff --git a/drivers/net/igbvf/netdev.c b/drivers/net/igbvf/netdev.c
index a127620..6751da8 100644
--- a/drivers/net/igbvf/netdev.c
+++ b/drivers/net/igbvf/netdev.c
@@ -47,6 +47,7 @@
 #define DRV_VERSION "1.0.0-k0"
 char igbvf_driver_name[] = "igbvf";
 const char igbvf_driver_version[] = DRV_VERSION;
+struct pm_qos_request_list *igbvf_driver_pm_qos_req;
 static const char igbvf_driver_string[] =
 				"Intel(R) Virtual Function Network Driver";
 static const char igbvf_copyright[] = "Copyright (c) 2009 Intel Corporation.";
@@ -2912,7 +2913,7 @@ static int __init igbvf_init_module(void)
 	printk(KERN_INFO "%s\n", igbvf_copyright);
 
 	ret = pci_register_driver(&igbvf_driver);
-	pm_qos_add_requirement(PM_QOS_CPU_DMA_LATENCY, igbvf_driver_name,
+	igbvf_driver_pm_qos_req = pm_qos_add_request(PM_QOS_CPU_DMA_LATENCY,
 	                       PM_QOS_DEFAULT_VALUE);
 
 	return ret;
@@ -2928,7 +2929,8 @@ module_init(igbvf_init_module);
 static void __exit igbvf_exit_module(void)
 {
 	pci_unregister_driver(&igbvf_driver);
-	pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY, igbvf_driver_name);
+	pm_qos_remove_request(igbvf_driver_pm_qos_req);
+	igbvf_driver_pm_qos_req = NULL;
 }
 module_exit(igbvf_exit_module);
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index daf13d3..4437eb5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -30,6 +30,7 @@
 #include <linux/if_packet.h>
 
 #ifdef __KERNEL__
+#include <linux/pm_qos_params.h>
 #include <linux/timer.h>
 #include <linux/delay.h>
 #include <linux/mm.h>
@@ -693,6 +694,9 @@ struct net_device {
 	 * the interface.
 	 */
 	char			name[IFNAMSIZ];
+
+	struct pm_qos_request_list *pm_qos_req;
+
 	/* device name hash chain */
 	struct hlist_node	name_hlist;
 	/* snmp alias */
-- 
1.6.3.3

