Return-Path: <linux-kernel-owner+w=401wt.eu-S933641AbXKPXYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641AbXKPXYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 18:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934885AbXKPXMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 18:12:03 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51829 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762739AbXKPXLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:11:10 -0500
Message-Id: <20071116231109.363897484@sgi.com>
References: <20071116230920.278761667@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 16 Nov 2007 15:09:49 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [patch 29/30] cpu alloc: Use in the crypto subsystem.
Content-Disposition: inline; filename=0039-cpu-alloc-Use-in-the-crypto-subsystem.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 crypto/async_tx/async_tx.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

Index: linux-2.6/crypto/async_tx/async_tx.c
===================================================================
--- linux-2.6.orig/crypto/async_tx/async_tx.c	2007-11-15 21:17:23.610404668 -0800
+++ linux-2.6/crypto/async_tx/async_tx.c	2007-11-15 21:25:39.834904080 -0800
@@ -207,10 +207,10 @@ static void async_tx_rebalance(void)
 	for_each_dma_cap_mask(cap, dma_cap_mask_all)
 		for_each_possible_cpu(cpu) {
 			struct dma_chan_ref *ref =
-				per_cpu_ptr(channel_table[cap], cpu)->ref;
+				CPU_PTR(channel_table[cap], cpu)->ref;
 			if (ref) {
 				atomic_set(&ref->count, 0);
-				per_cpu_ptr(channel_table[cap], cpu)->ref =
+				CPU_PTR(channel_table[cap], cpu)->ref =
 									NULL;
 			}
 		}
@@ -223,7 +223,7 @@ static void async_tx_rebalance(void)
 			else
 				new = get_chan_ref_by_cap(cap, -1);
 
-			per_cpu_ptr(channel_table[cap], cpu)->ref = new;
+			CPU_PTR(channel_table[cap], cpu)->ref = new;
 		}
 
 	spin_unlock_irqrestore(&async_tx_lock, flags);
@@ -327,7 +327,8 @@ async_tx_init(void)
 	clear_bit(DMA_INTERRUPT, dma_cap_mask_all.bits);
 
 	for_each_dma_cap_mask(cap, dma_cap_mask_all) {
-		channel_table[cap] = alloc_percpu(struct chan_ref_percpu);
+		channel_table[cap] = CPU_ALLOC(struct chan_ref_percpu,
+						GFP_KERNEL | __GFP_ZERO);
 		if (!channel_table[cap])
 			goto err;
 	}
@@ -343,7 +344,7 @@ err:
 	printk(KERN_ERR "async_tx: initialization failure\n");
 
 	while (--cap >= 0)
-		free_percpu(channel_table[cap]);
+		CPU_FRE(channel_table[cap]);
 
 	return 1;
 }
@@ -356,7 +357,7 @@ static void __exit async_tx_exit(void)
 
 	for_each_dma_cap_mask(cap, dma_cap_mask_all)
 		if (channel_table[cap])
-			free_percpu(channel_table[cap]);
+			CPU_FREE(channel_table[cap]);
 
 	dma_async_client_unregister(&async_tx_dma);
 }
@@ -378,7 +379,7 @@ async_tx_find_channel(struct dma_async_t
 	else if (likely(channel_table_initialized)) {
 		struct dma_chan_ref *ref;
 		int cpu = get_cpu();
-		ref = per_cpu_ptr(channel_table[tx_type], cpu)->ref;
+		ref = CPU_PTR(channel_table[tx_type], cpu)->ref;
 		put_cpu();
 		return ref ? ref->chan : NULL;
 	} else

-- 
