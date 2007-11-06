Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbXKFT5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbXKFT5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:57:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757456AbXKFTwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:25 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45423 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756204AbXKFTwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:04 -0500
Message-Id: <20071106195202.472057976@sgi.com>
References: <20071106195144.983665861@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 11:52:05 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 21/28] cpu alloc: convert loopback statistics
Content-Disposition: inline; filename=cpu_alloc_loopback
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 drivers/net/loopback.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/net/loopback.c
===================================================================
--- linux-2.6.orig/drivers/net/loopback.c	2007-11-04 19:15:14.000000000 -0800
+++ linux-2.6/drivers/net/loopback.c	2007-11-04 19:16:38.000000000 -0800
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
