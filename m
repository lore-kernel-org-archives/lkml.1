Return-Path: <linux-kernel-owner+w=401wt.eu-S1757934AbZDWHiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934AbZDWHiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756214AbZDWH3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:29:48 -0400
Received: from sous-sol.org ([216.99.217.87]:48544 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756193AbZDWH3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:29:46 -0400
Message-Id: <20090423072426.702063355@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:53 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Mallikarjuna R Chilakala <mallikarjuna.chilakala@intel.com>,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       David S Miller <davem@davemloft.net>
Subject: [patch 033/100] ixgbe: Fix potential memory leak/driver panic issue while setting up Tx & Rx ring parameters
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=ixgbe-fix-potential-memory-leak-driver-panic-issue-while-setting-up-tx-rx-ring-parameters.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Mallikarjuna R Chilakala <mallikarjuna.chilakala@intel.com>

upstream commit: f9ed88549e2ec73922b788e3865282d221233662

While setting up the ring parameters using ethtool the driver can
panic or leak memory as ixgbe_open tries to setup tx & rx resources.
The updated logic will use ixgbe_down/up after successful allocation of
tx & rx resources

Signed-off-by: Mallikarjuna R Chilakala <mallikarjuna.chilakala@intel.com>
Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: stable@kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/ixgbe/ixgbe_ethtool.c |  103 +++++++++++++++++++++-----------------
 1 file changed, 59 insertions(+), 44 deletions(-)

--- a/drivers/net/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ixgbe/ixgbe_ethtool.c
@@ -691,9 +691,10 @@ static int ixgbe_set_ringparam(struct ne
                                struct ethtool_ringparam *ring)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
-	struct ixgbe_ring *temp_ring;
+	struct ixgbe_ring *temp_tx_ring, *temp_rx_ring;
 	int i, err;
 	u32 new_rx_count, new_tx_count;
+	bool need_update = false;
 
 	if ((ring->rx_mini_pending) || (ring->rx_jumbo_pending))
 		return -EINVAL;
@@ -712,80 +713,94 @@ static int ixgbe_set_ringparam(struct ne
 		return 0;
 	}
 
-	temp_ring = kcalloc(adapter->num_tx_queues,
-	                    sizeof(struct ixgbe_ring), GFP_KERNEL);
-	if (!temp_ring)
-		return -ENOMEM;
-
 	while (test_and_set_bit(__IXGBE_RESETTING, &adapter->state))
 		msleep(1);
 
-	if (new_tx_count != adapter->tx_ring->count) {
+	temp_tx_ring = kcalloc(adapter->num_tx_queues,
+	                       sizeof(struct ixgbe_ring), GFP_KERNEL);
+	if (!temp_tx_ring) {
+		err = -ENOMEM;
+		goto err_setup;
+	}
+
+	if (new_tx_count != adapter->tx_ring_count) {
+		memcpy(temp_tx_ring, adapter->tx_ring,
+		       adapter->num_tx_queues * sizeof(struct ixgbe_ring));
 		for (i = 0; i < adapter->num_tx_queues; i++) {
-			temp_ring[i].count = new_tx_count;
-			err = ixgbe_setup_tx_resources(adapter, &temp_ring[i]);
+			temp_tx_ring[i].count = new_tx_count;
+			err = ixgbe_setup_tx_resources(adapter,
+			                               &temp_tx_ring[i]);
 			if (err) {
 				while (i) {
 					i--;
 					ixgbe_free_tx_resources(adapter,
-					                        &temp_ring[i]);
+					                        &temp_tx_ring[i]);
 				}
 				goto err_setup;
 			}
-			temp_ring[i].v_idx = adapter->tx_ring[i].v_idx;
+			temp_tx_ring[i].v_idx = adapter->tx_ring[i].v_idx;
 		}
-		if (netif_running(netdev))
-			netdev->netdev_ops->ndo_stop(netdev);
-		ixgbe_reset_interrupt_capability(adapter);
-		ixgbe_napi_del_all(adapter);
-		INIT_LIST_HEAD(&netdev->napi_list);
-		kfree(adapter->tx_ring);
-		adapter->tx_ring = temp_ring;
-		temp_ring = NULL;
-		adapter->tx_ring_count = new_tx_count;
-	}
-
-	temp_ring = kcalloc(adapter->num_rx_queues,
-	                    sizeof(struct ixgbe_ring), GFP_KERNEL);
-	if (!temp_ring) {
-		if (netif_running(netdev))
-			netdev->netdev_ops->ndo_open(netdev);
-		return -ENOMEM;
+		need_update = true;
 	}
 
-	if (new_rx_count != adapter->rx_ring->count) {
+	temp_rx_ring = kcalloc(adapter->num_rx_queues,
+	                       sizeof(struct ixgbe_ring), GFP_KERNEL);
+	if ((!temp_rx_ring) && (need_update)) {
+		for (i = 0; i < adapter->num_tx_queues; i++)
+			ixgbe_free_tx_resources(adapter, &temp_tx_ring[i]);
+		kfree(temp_tx_ring);
+		err = -ENOMEM;
+		goto err_setup;
+	}
+
+	if (new_rx_count != adapter->rx_ring_count) {
+		memcpy(temp_rx_ring, adapter->rx_ring,
+		       adapter->num_rx_queues * sizeof(struct ixgbe_ring));
 		for (i = 0; i < adapter->num_rx_queues; i++) {
-			temp_ring[i].count = new_rx_count;
-			err = ixgbe_setup_rx_resources(adapter, &temp_ring[i]);
+			temp_rx_ring[i].count = new_rx_count;
+			err = ixgbe_setup_rx_resources(adapter,
+			                               &temp_rx_ring[i]);
 			if (err) {
 				while (i) {
 					i--;
 					ixgbe_free_rx_resources(adapter,
-					                        &temp_ring[i]);
+					                      &temp_rx_ring[i]);
 				}
 				goto err_setup;
 			}
-			temp_ring[i].v_idx = adapter->rx_ring[i].v_idx;
+			temp_rx_ring[i].v_idx = adapter->rx_ring[i].v_idx;
 		}
+		need_update = true;
+	}
+
+	/* if rings need to be updated, here's the place to do it in one shot */
+	if (need_update) {
 		if (netif_running(netdev))
-			netdev->netdev_ops->ndo_stop(netdev);
-		ixgbe_reset_interrupt_capability(adapter);
-		ixgbe_napi_del_all(adapter);
-		INIT_LIST_HEAD(&netdev->napi_list);
-		kfree(adapter->rx_ring);
-		adapter->rx_ring = temp_ring;
-		temp_ring = NULL;
+			ixgbe_down(adapter);
+
+		/* tx */
+		if (new_tx_count != adapter->tx_ring_count) {
+			kfree(adapter->tx_ring);
+			adapter->tx_ring = temp_tx_ring;
+			temp_tx_ring = NULL;
+			adapter->tx_ring_count = new_tx_count;
+		}
 
-		adapter->rx_ring_count = new_rx_count;
+		/* rx */
+		if (new_rx_count != adapter->rx_ring_count) {
+			kfree(adapter->rx_ring);
+			adapter->rx_ring = temp_rx_ring;
+			temp_rx_ring = NULL;
+			adapter->rx_ring_count = new_rx_count;
+		}
 	}
 
 	/* success! */
 	err = 0;
-err_setup:
-	ixgbe_init_interrupt_scheme(adapter);
 	if (netif_running(netdev))
-		netdev->netdev_ops->ndo_open(netdev);
+		ixgbe_up(adapter);
 
+err_setup:
 	clear_bit(__IXGBE_RESETTING, &adapter->state);
 	return err;
 }

