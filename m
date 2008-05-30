Return-Path: <linux-kernel-owner+w=401wt.eu-S1759765AbYE3EFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765AbYE3EFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754360AbYE3EAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:00:41 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56616 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752632AbYE3EAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:21 -0400
Message-Id: <20080530040017.363831817@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:38 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 18/41] cpu alloc: Dmaengine conversion
Content-Disposition: inline; filename=cpu_alloc_dmaengine_conversion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert DMA engine to use CPU_xx operations. This also removes the use of local_t
from the dmaengine.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 drivers/dma/dmaengine.c   |   38 ++++++++++++++------------------------
 include/linux/dmaengine.h |   16 ++++++----------
 2 files changed, 20 insertions(+), 34 deletions(-)

Index: linux-2.6/drivers/dma/dmaengine.c
===================================================================
--- linux-2.6.orig/drivers/dma/dmaengine.c	2008-04-29 14:55:49.000000000 -0700
+++ linux-2.6/drivers/dma/dmaengine.c	2008-05-21 21:48:25.000000000 -0700
@@ -84,7 +84,7 @@
 	int i;
 
 	for_each_possible_cpu(i)
-		count += per_cpu_ptr(chan->local, i)->memcpy_count;
+		count += CPU_PTR(chan->local, i)->memcpy_count;
 
 	return sprintf(buf, "%lu\n", count);
 }
@@ -97,7 +97,7 @@
 	int i;
 
 	for_each_possible_cpu(i)
-		count += per_cpu_ptr(chan->local, i)->bytes_transferred;
+		count += CPU_PTR(chan->local, i)->bytes_transferred;
 
 	return sprintf(buf, "%lu\n", count);
 }
@@ -111,10 +111,8 @@
 		atomic_read(&chan->refcount.refcount) > 1)
 		in_use = 1;
 	else {
-		if (local_read(&(per_cpu_ptr(chan->local,
-			get_cpu())->refcount)) > 0)
+		if (_CPU_READ(chan->local->refcount) > 0)
 			in_use = 1;
-		put_cpu();
 	}
 
 	return sprintf(buf, "%d\n", in_use);
@@ -227,7 +225,7 @@
 	int bias = 0x7FFFFFFF;
 	int i;
 	for_each_possible_cpu(i)
-		bias -= local_read(&per_cpu_ptr(chan->local, i)->refcount);
+		bias -= _CPU_READ(chan->local->refcount);
 	atomic_sub(bias, &chan->refcount.refcount);
 	kref_put(&chan->refcount, dma_chan_cleanup);
 }
@@ -372,7 +370,8 @@
 
 	/* represent channels in sysfs. Probably want devs too */
 	list_for_each_entry(chan, &device->channels, device_node) {
-		chan->local = alloc_percpu(typeof(*chan->local));
+		chan->local = CPU_ALLOC(typeof(*chan->local),
+					GFP_KERNEL | __GFP_ZERO);
 		if (chan->local == NULL)
 			continue;
 
@@ -385,7 +384,7 @@
 		rc = device_register(&chan->dev);
 		if (rc) {
 			chancnt--;
-			free_percpu(chan->local);
+			CPU_FREE(chan->local);
 			chan->local = NULL;
 			goto err_out;
 		}
@@ -413,7 +412,7 @@
 		kref_put(&device->refcount, dma_async_device_cleanup);
 		device_unregister(&chan->dev);
 		chancnt--;
-		free_percpu(chan->local);
+		CPU_FREE(chan->local);
 	}
 	return rc;
 }
@@ -490,11 +489,8 @@
 	tx->callback = NULL;
 	cookie = tx->tx_submit(tx);
 
-	cpu = get_cpu();
-	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
-	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
-	put_cpu();
-
+	__CPU_ADD(chan->local->bytes_transferred, len);
+	__CPU_INC(chan->local->memcpy_count);
 	return cookie;
 }
 EXPORT_SYMBOL(dma_async_memcpy_buf_to_buf);
@@ -536,11 +532,8 @@
 	tx->callback = NULL;
 	cookie = tx->tx_submit(tx);
 
-	cpu = get_cpu();
-	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
-	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
-	put_cpu();
-
+	_CPU_ADD(chan->local->bytes_transferred, len);
+	_CPU_INC(chan->local->memcpy_count);
 	return cookie;
 }
 EXPORT_SYMBOL(dma_async_memcpy_buf_to_pg);
@@ -585,11 +578,8 @@
 	tx->callback = NULL;
 	cookie = tx->tx_submit(tx);
 
-	cpu = get_cpu();
-	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
-	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
-	put_cpu();
-
+	_CPU_ADD(chan->local->bytes_transferred, len);
+	_CPU_INC(chan->local->memcpy_count);
 	return cookie;
 }
 EXPORT_SYMBOL(dma_async_memcpy_pg_to_pg);
Index: linux-2.6/include/linux/dmaengine.h
===================================================================
--- linux-2.6.orig/include/linux/dmaengine.h	2008-04-29 14:55:54.000000000 -0700
+++ linux-2.6/include/linux/dmaengine.h	2008-05-21 21:48:25.000000000 -0700
@@ -116,13 +116,13 @@
 
 /**
  * struct dma_chan_percpu - the per-CPU part of struct dma_chan
- * @refcount: local_t used for open-coded "bigref" counting
+ * @refcount: int used for open-coded "bigref" counting
  * @memcpy_count: transaction counter
  * @bytes_transferred: byte counter
  */
 
 struct dma_chan_percpu {
-	local_t refcount;
+	int refcount;
 	/* stats */
 	unsigned long memcpy_count;
 	unsigned long bytes_transferred;
@@ -164,20 +164,16 @@
 {
 	if (unlikely(chan->slow_ref))
 		kref_get(&chan->refcount);
-	else {
-		local_inc(&(per_cpu_ptr(chan->local, get_cpu())->refcount));
-		put_cpu();
-	}
+	else
+		_CPU_INC(chan->local->refcount);
 }
 
 static inline void dma_chan_put(struct dma_chan *chan)
 {
 	if (unlikely(chan->slow_ref))
 		kref_put(&chan->refcount, dma_chan_cleanup);
-	else {
-		local_dec(&(per_cpu_ptr(chan->local, get_cpu())->refcount));
-		put_cpu();
-	}
+	else
+		_CPU_DEC(chan->local->refcount);
 }
 
 /*

-- 
