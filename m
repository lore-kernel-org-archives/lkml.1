Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbYE3EJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbYE3EJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbYE3EBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:01:01 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56622 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752611AbYE3EAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:22 -0400
Message-Id: <20080530040018.262530514@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:41 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 21/41] cpu alloc: Chelsio statistics conversion
Content-Disposition: inline; filename=cpu_alloc_chelsio_statistics_conversion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert chelsio statistics to cpu alloc.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 drivers/net/chelsio/sge.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/net/chelsio/sge.c
===================================================================
--- linux-2.6.orig/drivers/net/chelsio/sge.c	2008-05-28 22:02:18.000000000 -0700
+++ linux-2.6/drivers/net/chelsio/sge.c	2008-05-28 23:22:28.000000000 -0700
@@ -809,7 +809,7 @@
 	int i;
 
 	for_each_port(sge->adapter, i)
-		free_percpu(sge->port_stats[i]);
+		CPU_FREE(sge->port_stats[i]);
 
 	kfree(sge->tx_sched);
 	free_tx_resources(sge);
@@ -988,7 +988,7 @@
 
 	memset(ss, 0, sizeof(*ss));
 	for_each_possible_cpu(cpu) {
-		struct sge_port_stats *st = per_cpu_ptr(sge->port_stats[port], cpu);
+		struct sge_port_stats *st = CPU_PTR(sge->port_stats[port], cpu);
 
 		ss->rx_cso_good += st->rx_cso_good;
 		ss->tx_cso += st->tx_cso;
@@ -1367,7 +1367,6 @@
 	struct sk_buff *skb;
 	const struct cpl_rx_pkt *p;
 	struct adapter *adapter = sge->adapter;
-	struct sge_port_stats *st;
 
 	skb = get_packet(adapter->pdev, fl, len - sge->rx_pkt_pad);
 	if (unlikely(!skb)) {
@@ -1382,20 +1381,18 @@
 	}
 	__skb_pull(skb, sizeof(*p));
 
-	st = per_cpu_ptr(sge->port_stats[p->iff], smp_processor_id());
-
 	skb->protocol = eth_type_trans(skb, adapter->port[p->iff].dev);
 	skb->dev->last_rx = jiffies;
 	if ((adapter->flags & RX_CSUM_ENABLED) && p->csum == 0xffff &&
 	    skb->protocol == htons(ETH_P_IP) &&
 	    (skb->data[9] == IPPROTO_TCP || skb->data[9] == IPPROTO_UDP)) {
-		++st->rx_cso_good;
+		__CPU_INC(sge->port_stats[p->iff]->rx_cso_good);
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 	} else
 		skb->ip_summed = CHECKSUM_NONE;
 
 	if (unlikely(adapter->vlan_grp && p->vlan_valid)) {
-		st->vlan_xtract++;
+		__CPU_INC(sge->port_stats[p->iff]->vlan_xtract);
 #ifdef CONFIG_CHELSIO_T1_NAPI
 			vlan_hwaccel_receive_skb(skb, adapter->vlan_grp,
 						 ntohs(p->vlan));
@@ -1848,8 +1845,7 @@
 {
 	struct adapter *adapter = dev->priv;
 	struct sge *sge = adapter->sge;
-	struct sge_port_stats *st = per_cpu_ptr(sge->port_stats[dev->if_port],
-						smp_processor_id());
+	struct sge_port_stats *st = THIS_CPU(sge->port_stats[dev->if_port]);
 	struct cpl_tx_pkt *cpl;
 	struct sk_buff *orig_skb = skb;
 	int ret;
@@ -2159,7 +2155,8 @@
 	sge->jumbo_fl = t1_is_T1B(adapter) ? 1 : 0;
 
 	for_each_port(adapter, i) {
-		sge->port_stats[i] = alloc_percpu(struct sge_port_stats);
+		sge->port_stats[i] = CPU_ALLOC(struct sge_port_stats,
+					GFP_KERNEL | __GFP_ZERO);
 		if (!sge->port_stats[i])
 			goto nomem_port;
 	}
@@ -2203,7 +2200,7 @@
 	return sge;
 nomem_port:
 	while (i >= 0) {
-		free_percpu(sge->port_stats[i]);
+		CPU_FREE(sge->port_stats[i]);
 		--i;
 	}
 	kfree(sge);

-- 
