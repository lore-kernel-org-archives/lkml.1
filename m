Return-Path: <linux-kernel-owner+w=401wt.eu-S936069AbXKPXVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936069AbXKPXVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 18:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934932AbXKPXLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 18:11:49 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51798 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762057AbXKPXLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:11:08 -0500
Message-Id: <20071116231107.581149723@sgi.com>
References: <20071116230920.278761667@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 16 Nov 2007 15:09:42 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [patch 22/30] cpu alloc: convert loopback statistics
Content-Disposition: inline; filename=0032-cpu-alloc-convert-loopback-statistics.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 drivers/net/loopback.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/net/loopback.c
===================================================================
--- linux-2.6.orig/drivers/net/loopback.c	2007-11-15 21:17:24.067154382 -0800
+++ linux-2.6/drivers/net/loopback.c	2007-11-15 21:25:36.006154068 -0800
@@ -156,7 +156,7 @@ static int loopback_xmit(struct sk_buff 
 
 	/* it's OK to use per_cpu_ptr() because BHs are off */
 	pcpu_lstats = netdev_priv(dev);
-	lb_stats = per_cpu_ptr(pcpu_lstats, smp_processor_id());
+	lb_stats = THIS_CPU(pcpu_lstats);
 	lb_stats->bytes += skb->len;
 	lb_stats->packets++;
 
@@ -177,7 +177,7 @@ static struct net_device_stats *get_stat
 	for_each_possible_cpu(i) {
 		const struct pcpu_lstats *lb_stats;
 
-		lb_stats = per_cpu_ptr(pcpu_lstats, i);
+		lb_stats = CPU_PTR(pcpu_lstats, i);
 		bytes   += lb_stats->bytes;
 		packets += lb_stats->packets;
 	}
@@ -205,7 +205,7 @@ static int loopback_dev_init(struct net_
 {
 	struct pcpu_lstats *lstats;
 
-	lstats = alloc_percpu(struct pcpu_lstats);
+	lstats = CPU_ALLOC(struct pcpu_lstats, GFP_KERNEL | __GFP_ZERO);
 	if (!lstats)
 		return -ENOMEM;
 
@@ -217,7 +217,7 @@ static void loopback_dev_free(struct net
 {
 	struct pcpu_lstats *lstats = netdev_priv(dev);
 
-	free_percpu(lstats);
+	CPU_FREE(lstats);
 	free_netdev(dev);
 }
 

-- 
