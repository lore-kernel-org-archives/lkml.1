Return-Path: <linux-kernel-owner+w=401wt.eu-S1752804AbZCKIzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbZCKIzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 04:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbZCKIy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 04:54:27 -0400
Received: from mga10.intel.com ([192.55.52.92]:52370 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754600AbZCKIyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 04:54:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,341,1233561600"; 
   d="scan'208";a="437969704"
Subject: [RFC v2: Patch 3/3] net: hand off skb list to other cpu to submit
	to upper layer
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: herbert@gondor.apana.org.au, jesse.brandeburg@intel.com,
       shemminger@vyatta.com, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Mar 2009 16:53:53 +0800
Message-Id: <1236761633.2567.444.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 3rd patch is totally example on ixgbe driver. Pls. doesn't apply
it. It's just for a demo.
﻿
NIC driver could use this capability like below steps:
1) Call ﻿alloc_etherdev_rxtx_mq when probe the NIC to initiate;

In NAPI RX cleanup function:
2) Initiate a local var struct sk_buff_head skb_head;
3) get the cpu number by calling netif_rx_processing_cpu;
4) In the packet collection loop, just calls __skb_queue_tail(skb_head, skb)
to add skb to the list;
5) Before exiting, calls raise_netif_irq to submit the skb list to the specific cpu.

We can add another step after 3) to check input_pkt_alien_queue.qlen. If qlen is
bigger than ﻿netdev_max_backlog, exit the function instead of collecting packets,
so NIC hardware could drop packets. It's better than dropping packets by ﻿software.

Below _SAMPLE_ patch (has some garbage codes) is against the latest IXGBE driver.

---

--- ixgbe-1.3.58_route/src/ixgbe_main.c	2009-03-03 08:09:35.000000000 +0800
+++ ixgbe-1.3.58_route_backlog/src/ixgbe_main.c	2009-03-10 08:01:06.000000000 +0800
@@ -443,7 +443,8 @@ static int __ixgbe_notify_dca(struct dev
 static void ixgbe_receive_skb(struct ixgbe_adapter *adapter,
                               struct sk_buff *skb, u8 status,
                               struct ixgbe_ring *ring,
-                              union ixgbe_adv_rx_desc *rx_desc)
+                              union ixgbe_adv_rx_desc *rx_desc,
+                              struct sk_buff_head *skb_head)
 {
 	int ret;
 	bool is_vlan = (status & IXGBE_RXD_STAT_VP);
@@ -469,7 +470,9 @@ static void ixgbe_receive_skb(struct ixg
 			if (adapter->vlgrp && is_vlan && (tag != 0))
 				vlan_hwaccel_receive_skb(skb, adapter->vlgrp, tag);
 			else
-				netif_receive_skb(skb);
+				__skb_queue_tail(skb_head, skb);
+				//netif_rx_queue(skb, skb_head);
+				//YMZHANG netif_receive_skb(skb);
 #else
 			netif_receive_skb(skb);
 #endif
@@ -664,7 +667,8 @@ static void ixgbe_lro_ring_flush(struct 
                                  struct ixgbe_adapter *adapter,
                                  struct ixgbe_lro_desc *lrod, u8 status,
                                  struct ixgbe_ring *rx_ring,
-                                 union ixgbe_adv_rx_desc *rx_desc)
+                                 union ixgbe_adv_rx_desc *rx_desc,
+                                 struct sk_buff_head *skb_head)
 {
 	struct iphdr *iph;
 	struct tcphdr *th;
@@ -701,7 +705,7 @@ static void ixgbe_lro_ring_flush(struct 
 #ifdef NETIF_F_TSO
 	skb_shinfo(skb)->gso_size = lrod->mss;
 #endif
-	ixgbe_receive_skb(adapter, skb, status, rx_ring, rx_desc);
+	ixgbe_receive_skb(adapter, skb, status, rx_ring, rx_desc, skb_head);
 
 	netdev->last_rx = jiffies;
 	lro_data->stats.coal += lrod->append_cnt + 1;
@@ -718,14 +722,15 @@ static void ixgbe_lro_ring_flush(struct 
 static void ixgbe_lro_ring_flush_all(struct ixgbe_lro_list *lrolist,
                                      struct ixgbe_adapter *adapter, u8 status,
                                      struct ixgbe_ring *rx_ring,
-                                     union ixgbe_adv_rx_desc *rx_desc)
+                                     union ixgbe_adv_rx_desc *rx_desc,
+                                     struct sk_buff_head *skb_head)
 {
 	struct ixgbe_lro_desc *lrod;
 	struct hlist_node *node, *node2;
 
 	hlist_for_each_entry_safe(lrod, node, node2, &lrolist->active, lro_node)
 		ixgbe_lro_ring_flush(lrolist, adapter, lrod, status, rx_ring,
-		                     rx_desc);
+		                     rx_desc, skb_head);
 }
 
 /*
@@ -855,14 +860,14 @@ static int ixgbe_lro_ring_queue(struct i
 
 			if (!header_ok) {
 				ixgbe_lro_ring_flush(lrolist, adapter, lrod,
-				                     status, rx_ring, rx_desc);
+				                     status, rx_ring, rx_desc, skb_head);
 				return -1;
 			}
 
 			if (seq != lrod->next_seq) {
 				/* out of order packet */
 				ixgbe_lro_ring_flush(lrolist, adapter, lrod,
-				                     status, rx_ring, rx_desc);
+				                     status, rx_ring, rx_desc, skb_head);
 				return -1;
 			}
 
@@ -872,7 +877,7 @@ static int ixgbe_lro_ring_queue(struct i
 				if (lrod->tsval > tsval || *(ts_ptr + 2) == 0) {
 					ixgbe_lro_ring_flush(lrolist, adapter,
 					                     lrod, status,
-					                     rx_ring, rx_desc);
+					                     rx_ring, rx_desc, skb_head);
 					return -1;
 				}
 				lrod->tsval = tsval;
@@ -911,13 +916,13 @@ static int ixgbe_lro_ring_queue(struct i
 				(struct tcphdr *)(lro_skb->data + sizeof(*iph));
 				header_th->psh |= th->psh;
 				ixgbe_lro_ring_flush(lrolist, adapter, lrod,
-				                     status, rx_ring, rx_desc);
+				                     status, rx_ring, rx_desc, skb_head);
 				return 0;
 			}
 
 			if (lrod->append_cnt >= lro_data->max)
 				ixgbe_lro_ring_flush(lrolist, adapter, lrod,
-				                     status, rx_ring, rx_desc);
+				                     status, rx_ring, rx_desc, skb_head);
 
 			return 0;
 		} /*End of if*/
@@ -1001,13 +1006,14 @@ static void ixgbe_lro_ring_init(struct i
 
 #endif /* IXGBE_NO_LRO */
 
+
 #ifdef CONFIG_IXGBE_NAPI
 static bool ixgbe_clean_rx_irq(struct ixgbe_adapter *adapter,
-                               struct ixgbe_ring *rx_ring,
-                               int *work_done, int work_to_do)
+		struct ixgbe_ring *rx_ring,
+		int *work_done, int work_to_do)
 #else
 static bool ixgbe_clean_rx_irq(struct ixgbe_adapter *adapter,
-                               struct ixgbe_ring *rx_ring)
+		struct ixgbe_ring *rx_ring)
 #endif
 {
 	struct pci_dev *pdev = adapter->pdev;
@@ -1019,12 +1025,17 @@ static bool ixgbe_clean_rx_irq(struct ix
 	u16 hdr_info;
 	bool cleaned = false;
 	int cleaned_count = 0;
+	struct sk_buff_head skb_head;
+	int cpu = netif_rx_processing_cpu(adapter->netdev, rx_ring->queue_index);
+
 #ifndef CONFIG_IXGBE_NAPI
 	int work_to_do = rx_ring->work_limit, local_work_done = 0;
 	int *work_done = &local_work_done;
 #endif
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
 
+	skb_queue_head_init(&skb_head);
+
 	i = rx_ring->next_to_clean;
 	rx_desc = IXGBE_RX_DESC_ADV(*rx_ring, i);
 	staterr = le32_to_cpu(rx_desc->wb.upper.status_error);
@@ -1135,7 +1146,7 @@ static bool ixgbe_clean_rx_irq(struct ix
 			goto next_desc;
 		}
 #endif
-		ixgbe_receive_skb(adapter, skb, staterr, rx_ring, rx_desc);
+		ixgbe_receive_skb(adapter, skb, staterr, rx_ring, rx_desc, &skb_head);
 		adapter->netdev->last_rx = jiffies;
 
 next_desc:
@@ -1157,7 +1168,7 @@ next_desc:
 	rx_ring->next_to_clean = i;
 #ifndef IXGBE_NO_LRO
 	ixgbe_lro_ring_flush_all(rx_ring->lrolist, adapter,
-                            staterr, rx_ring, rx_desc);
+                            staterr, rx_ring, rx_desc, skb_head);
 #endif /* IXGBE_NO_LRO */
 	cleaned_count = IXGBE_DESC_UNUSED(rx_ring);
 #ifndef IXGBE_NO_INET_LRO
@@ -1180,6 +1191,9 @@ next_desc:
 	if (*work_done >= work_to_do)
 		IXGBE_WRITE_REG(&adapter->hw, IXGBE_EICS, rx_ring->v_idx);
 #endif
+
+	raise_netif_irq(cpu, &skb_head);
+
 	return cleaned;
 }
 
@@ -4103,6 +4117,8 @@ void ixgbe_napi_add_all(struct ixgbe_ada
 	for (q_idx = 0; q_idx < q_vectors; q_idx++) {
 		struct ixgbe_q_vector *q_vector = &adapter->q_vector[q_idx];
 		netif_napi_add(adapter->netdev, &q_vector->napi, (*poll), 64);
+		/*YMZ*/
+		//netif_napi_add(adapter->netdev, &q_vector->napi, (*poll), 32);
 	}
 }
 
@@ -4998,7 +5014,7 @@ static int __devinit ixgbe_probe(struct 
 	pci_set_master(pdev);
 
 #ifdef HAVE_TX_MQ
-	netdev = alloc_etherdev_mq(sizeof(struct ixgbe_adapter), MAX_TX_QUEUES);
+	netdev = alloc_etherdev_rxtx_mq(sizeof(struct ixgbe_adapter), MAX_RX_QUEUES, MAX_TX_QUEUES);
 #else
 	netdev = alloc_etherdev(sizeof(struct ixgbe_adapter));
 #endif


