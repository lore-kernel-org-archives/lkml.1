Return-Path: <linux-kernel-owner+w=401wt.eu-S1762947AbYF0SDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762947AbYF0SDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757117AbYF0SBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:01:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:27054 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758971AbYF0SBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:01:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,716,1204531200"; 
   d="scan'208";a="300315766"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [NET-NEXT PATCH 09/18] igb: update ethtool stats to support multiqueue
To: jeff@garzik.org, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net
Date: Fri, 27 Jun 2008 11:00:56 -0700
Message-ID: <20080627180052.22428.22203.stgit@localhost.localdomain>
In-Reply-To: <20080627175921.22428.52767.stgit@localhost.localdomain>
References: <20080627175921.22428.52767.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jun 2008 18:00:56.0762 (UTC) FILETIME=[BFA2C1A0:01C8D87F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@intel.com>

Addesses problems seen earlier with igb driver not correctly reporting rx
and tx stats.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---

 drivers/net/igb/igb.h         |    1 +
 drivers/net/igb/igb_ethtool.c |   13 +++++++++----
 drivers/net/igb/igb_main.c    |    2 ++
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/igb/igb.h b/drivers/net/igb/igb.h
index 4534283..0551a63 100644
--- a/drivers/net/igb/igb.h
+++ b/drivers/net/igb/igb.h
@@ -158,6 +158,7 @@ struct igb_ring {
 	union {
 		/* TX */
 		struct {
+			struct igb_queue_stats tx_stats;
 			bool detect_tx_hung;
 		};
 		/* RX */
diff --git a/drivers/net/igb/igb_ethtool.c b/drivers/net/igb/igb_ethtool.c
index 0447f9b..ed756c1 100644
--- a/drivers/net/igb/igb_ethtool.c
+++ b/drivers/net/igb/igb_ethtool.c
@@ -96,10 +96,8 @@ static const struct igb_stats igb_gstrings_stats[] = {
 };
 
 #define IGB_QUEUE_STATS_LEN \
-	((((((struct igb_adapter *)netdev->priv)->num_rx_queues > 1) ? \
-	  ((struct igb_adapter *)netdev->priv)->num_rx_queues : 0) + \
-	 (((((struct igb_adapter *)netdev->priv)->num_tx_queues > 1) ? \
-	  ((struct igb_adapter *)netdev->priv)->num_tx_queues : 0))) * \
+	((((struct igb_adapter *)netdev->priv)->num_rx_queues + \
+	 ((struct igb_adapter *)netdev->priv)->num_tx_queues) * \
 	(sizeof(struct igb_queue_stats) / sizeof(u64)))
 #define IGB_GLOBAL_STATS_LEN	\
 	sizeof(igb_gstrings_stats) / sizeof(struct igb_stats)
@@ -1842,6 +1840,13 @@ static void igb_get_ethtool_stats(struct net_device *netdev,
 		data[i] = (igb_gstrings_stats[i].sizeof_stat ==
 			sizeof(u64)) ? *(u64 *)p : *(u32 *)p;
 	}
+	for (j = 0; j < adapter->num_tx_queues; j++) {
+		int k;
+		queue_stat = (u64 *)&adapter->tx_ring[j].tx_stats;
+		for (k = 0; k < stat_count; k++)
+			data[i + k] = queue_stat[k];
+		i += k;
+	}
 	for (j = 0; j < adapter->num_rx_queues; j++) {
 		int k;
 		queue_stat = (u64 *)&adapter->rx_ring[j].rx_stats;
diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index 3699cf0..5fcc043 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -3404,6 +3404,8 @@ done_cleaning:
 	}
 	tx_ring->total_bytes += total_bytes;
 	tx_ring->total_packets += total_packets;
+	tx_ring->tx_stats.bytes += total_bytes;
+	tx_ring->tx_stats.packets += total_packets;
 	adapter->net_stats.tx_bytes += total_bytes;
 	adapter->net_stats.tx_packets += total_packets;
 	return retval;

