Return-Path: <linux-kernel-owner+w=401wt.eu-S1758916AbXKFT6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbXKFT6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757493AbXKFTwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:30 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45386 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754321AbXKFTwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:04 -0500
Message-Id: <20071106195203.825244760@sgi.com>
References: <20071106195144.983665861@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 11:52:11 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 27/28] cpu alloc: Use in the crypto subsystem.
Content-Disposition: inline; filename=cpu_alloc_crypto
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 crypto/async_tx/async_tx.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

Index: linux-2.6/crypto/async_tx/async_tx.c
===================================================================
--- linux-2.6.orig/crypto/async_tx/async_tx.c	2007-11-05 09:46:04.000000000 -0800
+++ linux-2.6/crypto/async_tx/async_tx.c	2007-11-05 09:49:56.000000000 -0800
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
