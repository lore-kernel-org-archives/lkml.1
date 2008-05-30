Return-Path: <linux-kernel-owner+w=401wt.eu-S1759488AbYE3EF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488AbYE3EF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbYE3EAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:00:42 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56623 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752804AbYE3EAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:22 -0400
Message-Id: <20080530040017.610106257@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:39 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 19/41] cpu alloc: Convert loopback statistics
Content-Disposition: inline; filename=cpu_alloc_loopback_statistics_conversion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert loopback statistics to cpu alloc.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 drivers/net/loopback.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/net/loopback.c
===================================================================
--- linux-2.6.orig/drivers/net/loopback.c	2008-05-28 22:02:18.000000000 -0700
+++ linux-2.6/drivers/net/loopback.c	2008-05-28 23:14:11.000000000 -0700
@@ -132,7 +132,7 @@
  */
 static int loopback_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	struct pcpu_lstats *pcpu_lstats, *lb_stats;
+	struct pcpu_lstats *pcpu_lstats;
 
 	skb_orphan(skb);
 
@@ -152,11 +152,10 @@
 #endif
 	dev->last_rx = jiffies;
 
-	/* it's OK to use per_cpu_ptr() because BHs are off */
+	/* it's OK to use __xxx cpu operations because BHs are off */
 	pcpu_lstats = netdev_priv(dev);
-	lb_stats = per_cpu_ptr(pcpu_lstats, smp_processor_id());
-	lb_stats->bytes += skb->len;
-	lb_stats->packets++;
+	__CPU_ADD(pcpu_lstats->bytes, skb->len);
+	__CPU_INC(pcpu_lstats->packets);
 
 	netif_rx(skb);
 
@@ -175,7 +174,7 @@
 	for_each_possible_cpu(i) {
 		const struct pcpu_lstats *lb_stats;
 
-		lb_stats = per_cpu_ptr(pcpu_lstats, i);
+		lb_stats = CPU_PTR(pcpu_lstats, i);
 		bytes   += lb_stats->bytes;
 		packets += lb_stats->packets;
 	}
@@ -203,7 +202,7 @@
 {
 	struct pcpu_lstats *lstats;
 
-	lstats = alloc_percpu(struct pcpu_lstats);
+	lstats = CPU_ALLOC(struct pcpu_lstats, GFP_KERNEL | __GFP_ZERO);
 	if (!lstats)
 		return -ENOMEM;
 
@@ -215,7 +214,7 @@
 {
 	struct pcpu_lstats *lstats = netdev_priv(dev);
 
-	free_percpu(lstats);
+	CPU_FREE(lstats);
 	free_netdev(dev);
 }
 

-- 
