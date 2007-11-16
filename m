Return-Path: <linux-kernel-owner+w=401wt.eu-S936014AbXKPXVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936014AbXKPXVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 18:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763721AbXKPXLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 18:11:48 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51810 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761874AbXKPXLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:11:07 -0500
Message-Id: <20071116231107.350452102@sgi.com>
References: <20071116230920.278761667@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 16 Nov 2007 15:09:41 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [patch 21/30] cpu alloc: dmaengine conversion
Content-Disposition: inline; filename=0031-cpu-alloc-dmaengine-conversion.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 drivers/dma/dmaengine.c   |   27 ++++++++++++++-------------
 include/linux/dmaengine.h |    4 ++--
 2 files changed, 16 insertions(+), 15 deletions(-)

Index: linux-2.6/drivers/dma/dmaengine.c
===================================================================
--- linux-2.6.orig/drivers/dma/dmaengine.c	2007-11-15 21:17:24.127154620 -0800
+++ linux-2.6/drivers/dma/dmaengine.c	2007-11-15 21:25:35.354654191 -0800
@@ -84,7 +84,7 @@ static ssize_t show_memcpy_count(struct 
 	int i;
 
 	for_each_possible_cpu(i)
-		count += per_cpu_ptr(chan->local, i)->memcpy_count;
+		count += CPU_PTR(chan->local, i)->memcpy_count;
 
 	return sprintf(buf, "%lu\n", count);
 }
@@ -96,7 +96,7 @@ static ssize_t show_bytes_transferred(st
 	int i;
 
 	for_each_possible_cpu(i)
-		count += per_cpu_ptr(chan->local, i)->bytes_transferred;
+		count += CPU_PTR(chan->local, i)->bytes_transferred;
 
 	return sprintf(buf, "%lu\n", count);
 }
@@ -110,7 +110,7 @@ static ssize_t show_in_use(struct class_
 		atomic_read(&chan->refcount.refcount) > 1)
 		in_use = 1;
 	else {
-		if (local_read(&(per_cpu_ptr(chan->local,
+		if (local_read(&(CPU_PTR(chan->local,
 			get_cpu())->refcount)) > 0)
 			in_use = 1;
 		put_cpu();
@@ -226,7 +226,7 @@ static void dma_chan_free_rcu(struct rcu
 	int bias = 0x7FFFFFFF;
 	int i;
 	for_each_possible_cpu(i)
-		bias -= local_read(&per_cpu_ptr(chan->local, i)->refcount);
+		bias -= local_read(&CPU_PTR(chan->local, i)->refcount);
 	atomic_sub(bias, &chan->refcount.refcount);
 	kref_put(&chan->refcount, dma_chan_cleanup);
 }
@@ -372,7 +372,8 @@ int dma_async_device_register(struct dma
 
 	/* represent channels in sysfs. Probably want devs too */
 	list_for_each_entry(chan, &device->channels, device_node) {
-		chan->local = alloc_percpu(typeof(*chan->local));
+		chan->local = CPU_ALLOC(typeof(*chan->local),
+					GFP_KERNEL | __GFP_ZERO);
 		if (chan->local == NULL)
 			continue;
 
@@ -385,7 +386,7 @@ int dma_async_device_register(struct dma
 		rc = class_device_register(&chan->class_dev);
 		if (rc) {
 			chancnt--;
-			free_percpu(chan->local);
+			CPU_FREE(chan->local);
 			chan->local = NULL;
 			goto err_out;
 		}
@@ -413,7 +414,7 @@ err_out:
 		kref_put(&device->refcount, dma_async_device_cleanup);
 		class_device_unregister(&chan->class_dev);
 		chancnt--;
-		free_percpu(chan->local);
+		CPU_FREE(chan->local);
 	}
 	return rc;
 }
@@ -489,8 +490,8 @@ dma_async_memcpy_buf_to_buf(struct dma_c
 	cookie = tx->tx_submit(tx);
 
 	cpu = get_cpu();
-	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
-	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
+	CPU_PTR(chan->local, cpu)->bytes_transferred += len;
+	CPU_PTR(chan->local, cpu)->memcpy_count++;
 	put_cpu();
 
 	return cookie;
@@ -533,8 +534,8 @@ dma_async_memcpy_buf_to_pg(struct dma_ch
 	cookie = tx->tx_submit(tx);
 
 	cpu = get_cpu();
-	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
-	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
+	CPU_PTR(chan->local, cpu)->bytes_transferred += len;
+	CPU_PTR(chan->local, cpu)->memcpy_count++;
 	put_cpu();
 
 	return cookie;
@@ -579,8 +580,8 @@ dma_async_memcpy_pg_to_pg(struct dma_cha
 	cookie = tx->tx_submit(tx);
 
 	cpu = get_cpu();
-	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
-	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
+	CPU_PTR(chan->local, cpu)->bytes_transferred += len;
+	CPU_PTR(chan->local, cpu)->memcpy_count++;
 	put_cpu();
 
 	return cookie;
Index: linux-2.6/include/linux/dmaengine.h
===================================================================
--- linux-2.6.orig/include/linux/dmaengine.h	2007-11-15 21:17:24.135154570 -0800
+++ linux-2.6/include/linux/dmaengine.h	2007-11-15 21:25:35.358654166 -0800
@@ -150,7 +150,7 @@ static inline void dma_chan_get(struct d
 	if (unlikely(chan->slow_ref))
 		kref_get(&chan->refcount);
 	else {
-		local_inc(&(per_cpu_ptr(chan->local, get_cpu())->refcount));
+		local_inc(&CPU_PTR(chan->local, get_cpu())->refcount);
 		put_cpu();
 	}
 }
@@ -160,7 +160,7 @@ static inline void dma_chan_put(struct d
 	if (unlikely(chan->slow_ref))
 		kref_put(&chan->refcount, dma_chan_cleanup);
 	else {
-		local_dec(&(per_cpu_ptr(chan->local, get_cpu())->refcount));
+		local_dec(&CPU_PTR(chan->local, get_cpu())->refcount);
 		put_cpu();
 	}
 }

-- 
