Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbYE3EGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbYE3EGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbYE3EAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:00:43 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56630 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752916AbYE3EAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:22 -0400
Message-Id: <20080530040019.134732156@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:44 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 24/41] cpu alloc: Use in the crypto subsystem.
Content-Disposition: inline; filename=cpu_alloc_crypto_conversion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use cpu alloc for the crypto subsystem.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 crypto/async_tx/async_tx.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

Index: linux-2.6/crypto/async_tx/async_tx.c
===================================================================
--- linux-2.6.orig/crypto/async_tx/async_tx.c	2008-04-29 14:55:49.000000000 -0700
+++ linux-2.6/crypto/async_tx/async_tx.c	2008-05-21 22:01:42.000000000 -0700
@@ -221,10 +221,10 @@
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
@@ -237,7 +237,7 @@
 			else
 				new = get_chan_ref_by_cap(cap, -1);
 
-			per_cpu_ptr(channel_table[cap], cpu)->ref = new;
+			CPU_PTR(channel_table[cap], cpu)->ref = new;
 		}
 
 	spin_unlock_irqrestore(&async_tx_lock, flags);
@@ -341,7 +341,8 @@
 	clear_bit(DMA_INTERRUPT, dma_cap_mask_all.bits);
 
 	for_each_dma_cap_mask(cap, dma_cap_mask_all) {
-		channel_table[cap] = alloc_percpu(struct chan_ref_percpu);
+		channel_table[cap] = CPU_ALLOC(struct chan_ref_percpu,
+						GFP_KERNEL | __GFP_ZERO);
 		if (!channel_table[cap])
 			goto err;
 	}
@@ -357,7 +358,7 @@
 	printk(KERN_ERR "async_tx: initialization failure\n");
 
 	while (--cap >= 0)
-		free_percpu(channel_table[cap]);
+		CPU_FREE(channel_table[cap]);
 
 	return 1;
 }
@@ -370,7 +371,7 @@
 
 	for_each_dma_cap_mask(cap, dma_cap_mask_all)
 		if (channel_table[cap])
-			free_percpu(channel_table[cap]);
+			CPU_FREE(channel_table[cap]);
 
 	dma_async_client_unregister(&async_tx_dma);
 }
@@ -390,10 +391,8 @@
 		dma_has_cap(tx_type, depend_tx->chan->device->cap_mask))
 		return depend_tx->chan;
 	else if (likely(channel_table_initialized)) {
-		struct dma_chan_ref *ref;
-		int cpu = get_cpu();
-		ref = per_cpu_ptr(channel_table[tx_type], cpu)->ref;
-		put_cpu();
+		struct dma_chan_ref *ref =
+			_CPU_READ(channel_table[tx_type]->ref);
 		return ref ? ref->chan : NULL;
 	} else
 		return NULL;

-- 
