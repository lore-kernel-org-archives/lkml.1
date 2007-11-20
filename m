Return-Path: <linux-kernel-owner+w=401wt.eu-S1758347AbXKTBWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347AbXKTBWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbXKTBOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:14:00 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36881 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754755AbXKTBNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:38 -0500
Message-Id: <20071120011337.395678305@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:11:56 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 24/45] cpu alloc: convert loopback statistics
Content-Disposition: inline; filename=0032-cpu-alloc-convert-loopback-statistics.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 drivers/net/loopback.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/net/loopback.c
===================================================================
--- linux-2.6.orig/drivers/net/loopback.c	2007-11-18 14:38:23.621283530 -0800
+++ linux-2.6/drivers/net/loopback.c	2007-11-18 22:04:47.399082691 -0800
@@ -134,7 +134,7 @@ static void emulate_large_send_offload(s
  */
 static int loopback_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	struct pcpu_lstats *pcpu_lstats, *lb_stats;
+	struct pcpu_lstats *pcpu_lstats;
 
 	skb_orphan(skb);
 
@@ -154,11 +154,9 @@ static int loopback_xmit(struct sk_buff 
 #endif
 	dev->last_rx = jiffies;
 
-	/* it's OK to use per_cpu_ptr() because BHs are off */
 	pcpu_lstats = netdev_priv(dev);
-	lb_stats = per_cpu_ptr(pcpu_lstats, smp_processor_id());
-	lb_stats->bytes += skb->len;
-	lb_stats->packets++;
+	__CPU_ADD(pcpu_lstats->bytes, skb->len);
+	__CPU_INC(pcpu_lstats->packets);
 
 	netif_rx(skb);
 
@@ -177,7 +175,7 @@ static struct net_device_stats *get_stat
 	for_each_possible_cpu(i) {
 		const struct pcpu_lstats *lb_stats;
 
-		lb_stats = per_cpu_ptr(pcpu_lstats, i);
+		lb_stats = CPU_PTR(pcpu_lstats, i);
 		bytes   += lb_stats->bytes;
 		packets += lb_stats->packets;
 	}
@@ -205,7 +203,7 @@ static int loopback_dev_init(struct net_
 {
 	struct pcpu_lstats *lstats;
 
-	lstats = alloc_percpu(struct pcpu_lstats);
+	lstats = CPU_ALLOC(struct pcpu_lstats, GFP_KERNEL | __GFP_ZERO);
 	if (!lstats)
 		return -ENOMEM;
 
@@ -217,7 +215,7 @@ static void loopback_dev_free(struct net
 {
 	struct pcpu_lstats *lstats = netdev_priv(dev);
 
-	free_percpu(lstats);
+	CPU_FREE(lstats);
 	free_netdev(dev);
 }
 

-- 
