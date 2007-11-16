Return-Path: <linux-kernel-owner+w=401wt.eu-S936147AbXKPXWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936147AbXKPXWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 18:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934982AbXKPXLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 18:11:54 -0500
Received: from relay1.sgi.com ([192.48.171.29]:39575 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762299AbXKPXLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:11:08 -0500
Message-Id: <20071116231108.049324453@sgi.com>
References: <20071116230920.278761667@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 16 Nov 2007 15:09:44 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [patch 24/30] cpu alloc: Chelsio statistics conversion
Content-Disposition: inline; filename=0034-cpu-alloc-Chelsio-statistics-conversion.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 drivers/net/chelsio/sge.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/net/chelsio/sge.c
===================================================================
--- linux-2.6.orig/drivers/net/chelsio/sge.c	2007-11-15 21:17:23.927654318 -0800
+++ linux-2.6/drivers/net/chelsio/sge.c	2007-11-15 21:25:37.015154316 -0800
@@ -805,7 +805,7 @@ void t1_sge_destroy(struct sge *sge)
 	int i;
 
 	for_each_port(sge->adapter, i)
-		free_percpu(sge->port_stats[i]);
+		CPU_FREE(sge->port_stats[i]);
 
 	kfree(sge->tx_sched);
 	free_tx_resources(sge);
@@ -984,7 +984,7 @@ void t1_sge_get_port_stats(const struct 
 
 	memset(ss, 0, sizeof(*ss));
 	for_each_possible_cpu(cpu) {
-		struct sge_port_stats *st = per_cpu_ptr(sge->port_stats[port], cpu);
+		struct sge_port_stats *st = CPU_PTR(sge->port_stats[port], cpu);
 
 		ss->rx_packets += st->rx_packets;
 		ss->rx_cso_good += st->rx_cso_good;
@@ -1379,7 +1379,7 @@ static void sge_rx(struct sge *sge, stru
 	}
 	__skb_pull(skb, sizeof(*p));
 
-	st = per_cpu_ptr(sge->port_stats[p->iff], smp_processor_id());
+	st = THIS_CPU(sge->port_stats[p->iff]);
 	st->rx_packets++;
 
 	skb->protocol = eth_type_trans(skb, adapter->port[p->iff].dev);
@@ -1848,7 +1848,7 @@ int t1_start_xmit(struct sk_buff *skb, s
 {
 	struct adapter *adapter = dev->priv;
 	struct sge *sge = adapter->sge;
-	struct sge_port_stats *st = per_cpu_ptr(sge->port_stats[dev->if_port], smp_processor_id());
+	struct sge_port_stats *st = THIS_CPU(sge->port_stats[dev->if_port]);
 	struct cpl_tx_pkt *cpl;
 	struct sk_buff *orig_skb = skb;
 	int ret;
@@ -2165,7 +2165,8 @@ struct sge * __devinit t1_sge_create(str
 	sge->jumbo_fl = t1_is_T1B(adapter) ? 1 : 0;
 
 	for_each_port(adapter, i) {
-		sge->port_stats[i] = alloc_percpu(struct sge_port_stats);
+		sge->port_stats[i] = CPU_ALLOC(struct sge_port_stats,
+					GFP_KERNEL | __GFP_ZERO);
 		if (!sge->port_stats[i])
 			goto nomem_port;
 	}
@@ -2209,7 +2210,7 @@ struct sge * __devinit t1_sge_create(str
 	return sge;
 nomem_port:
 	while (i >= 0) {
-		free_percpu(sge->port_stats[i]);
+		CPU_FREE(sge->port_stats[i]);
 		--i;
 	}
 	kfree(sge);

-- 
