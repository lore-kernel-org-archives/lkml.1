Return-Path: <linux-kernel-owner+w=401wt.eu-S1758329AbXKFT7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329AbXKFT7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757511AbXKFTwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:34 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45406 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756045AbXKFTwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:03 -0500
Message-Id: <20071106195202.228274344@sgi.com>
References: <20071106195144.983665861@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 11:52:04 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 20/28] cpu alloc: dmaengine conversion
Content-Disposition: inline; filename=cpu_alloc_dmaengine
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 drivers/dma/dmaengine.c   |   27 ++++++++++++++-------------
 include/linux/dmaengine.h |    5 +++--
 2 files changed, 17 insertions(+), 15 deletions(-)

Index: linux-2.6/drivers/dma/dmaengine.c
===================================================================
--- linux-2.6.orig/drivers/dma/dmaengine.c	2007-11-04 19:31:08.000000000 -0800
+++ linux-2.6/drivers/dma/dmaengine.c	2007-11-04 19:34:09.000000000 -0800
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
@@ -227,7 +227,7 @@ static void dma_chan_free_rcu(struct rcu
 	int bias = 0x7FFFFFFF;
 	int i;
 	for_each_possible_cpu(i)
-		bias -= local_read(&per_cpu_ptr(chan->local, i)->refcount);
+		bias -= local_read(&CPU_PTR(chan->local, i)->refcount);
 	atomic_sub(bias, &chan->refcount.refcount);
 	kref_put(&chan->refcount, dma_chan_cleanup);
 }
@@ -379,7 +379,8 @@ int dma_async_device_register(struct dma
 
 	/* represent channels in sysfs. Probably want devs too */
 	list_for_each_entry(chan, &device->channels, device_node) {
-		chan->local = alloc_percpu(typeof(*chan->local));
+		chan->local = CPU_ALLOC(typeof(*chan->local),
+					GFP_KERNEL | __GFP_ZERO);
 		if (chan->local == NULL)
 			continue;
 
@@ -392,7 +393,7 @@ int dma_async_device_register(struct dma
 		rc = class_device_register(&chan->class_dev);
 		if (rc) {
 			chancnt--;
-			free_percpu(chan->local);
+			CPU_FREE(chan->local);
 			chan->local = NULL;
 			goto err_out;
 		}
@@ -418,7 +419,7 @@ err_out:
 		kref_put(&device->refcount, dma_async_device_cleanup);
 		class_device_unregister(&chan->class_dev);
 		chancnt--;
-		free_percpu(chan->local);
+		CPU_FREE(chan->local);
 	}
 	return rc;
 }
@@ -494,8 +495,8 @@ dma_async_memcpy_buf_to_buf(struct dma_c
 	cookie = tx->tx_submit(tx);
 
 	cpu = get_cpu();
-	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
-	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
+	CPU_PTR(chan->local, cpu)->bytes_transferred += len;
+	CPU_PTR(chan->local, cpu)->memcpy_count++;
 	put_cpu();
 
 	return cookie;
@@ -538,8 +539,8 @@ dma_async_memcpy_buf_to_pg(struct dma_ch
 	cookie = tx->tx_submit(tx);
 
 	cpu = get_cpu();
-	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
-	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
+	CPU_PTR(chan->local, cpu)->bytes_transferred += len;
+	CPU_PTR(chan->local, cpu)->memcpy_count++;
 	put_cpu();
 
 	return cookie;
@@ -584,8 +585,8 @@ dma_async_memcpy_pg_to_pg(struct dma_cha
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
--- linux-2.6.orig/include/linux/dmaengine.h	2007-11-04 19:31:08.000000000 -0800
+++ linux-2.6/include/linux/dmaengine.h	2007-11-04 19:35:07.000000000 -0800
@@ -27,6 +27,7 @@
 #include <linux/completion.h>
 #include <linux/rcupdate.h>
 #include <linux/dma-mapping.h>
+#include <linux/cpu_alloc.h>
 
 /**
  * enum dma_state - resource PNP/power managment state
@@ -150,7 +151,7 @@ static inline void dma_chan_get(struct d
 	if (unlikely(chan->slow_ref))
 		kref_get(&chan->refcount);
 	else {
-		local_inc(&(per_cpu_ptr(chan->local, get_cpu())->refcount));
+		local_inc(&CPU_PTR(chan->local, get_cpu())->refcount);
 		put_cpu();
 	}
 }
@@ -160,7 +161,7 @@ static inline void dma_chan_put(struct d
 	if (unlikely(chan->slow_ref))
 		kref_put(&chan->refcount, dma_chan_cleanup);
 	else {
-		local_dec(&(per_cpu_ptr(chan->local, get_cpu())->refcount));
+		local_dec(&CPU_PTR(chan->local, get_cpu())->refcount);
 		put_cpu();
 	}
 }

-- 
