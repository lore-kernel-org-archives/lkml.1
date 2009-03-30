Return-Path: <linux-kernel-owner+w=401wt.eu-S1757398AbZC3ROZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398AbZC3ROZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbZC3RL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:11:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:49745 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbZC3RLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:11:24 -0400
Message-Id: <20090330171023.959404268@chello.nl>
References: <20090330170701.856843742@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 30 Mar 2009 19:07:11 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 10/15] perf_counter: small cleanup of the output routines
Content-Disposition: inline; filename=perf_counter-cleanup-output.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the nmi argument to the _begin() function, so that _end() only needs the
handle. This allows the _begin() function to generate a wakeup on event loss.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |   42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1663,10 +1663,20 @@ struct perf_output_handle {
 	unsigned int		offset;
 	unsigned int		head;
 	int			wakeup;
+	int			nmi;
 };
 
+static inline void __perf_output_wakeup(struct perf_output_handle *handle)
+{
+	if (handle->nmi)
+		perf_pending_queue(handle->counter);
+	else
+		perf_counter_wakeup(handle->counter);
+}
+
 static int perf_output_begin(struct perf_output_handle *handle,
-			     struct perf_counter *counter, unsigned int size)
+			     struct perf_counter *counter, unsigned int size,
+			     int nmi)
 {
 	struct perf_mmap_data *data;
 	unsigned int offset, head;
@@ -1676,15 +1686,17 @@ static int perf_output_begin(struct perf
 	if (!data)
 		goto out;
 
+	handle->counter	= counter;
+	handle->nmi	= nmi;
+
 	if (!data->nr_pages)
-		goto out;
+		goto fail;
 
 	do {
 		offset = head = atomic_read(&data->head);
 		head += size;
 	} while (atomic_cmpxchg(&data->head, offset, head) != offset);
 
-	handle->counter	= counter;
 	handle->data	= data;
 	handle->offset	= offset;
 	handle->head	= head;
@@ -1692,6 +1704,8 @@ static int perf_output_begin(struct perf
 
 	return 0;
 
+fail:
+	__perf_output_wakeup(handle);
 out:
 	rcu_read_unlock();
 
@@ -1733,14 +1747,10 @@ static void perf_output_copy(struct perf
 #define perf_output_put(handle, x) \
 	perf_output_copy((handle), &(x), sizeof(x))
 
-static void perf_output_end(struct perf_output_handle *handle, int nmi)
+static void perf_output_end(struct perf_output_handle *handle)
 {
-	if (handle->wakeup) {
-		if (nmi)
-			perf_pending_queue(handle->counter);
-		else
-			perf_counter_wakeup(handle->counter);
-	}
+	if (handle->wakeup)
+		__perf_output_wakeup(handle);
 	rcu_read_unlock();
 }
 
@@ -1750,12 +1760,12 @@ static int perf_output_write(struct perf
 	struct perf_output_handle handle;
 	int ret;
 
-	ret = perf_output_begin(&handle, counter, size);
+	ret = perf_output_begin(&handle, counter, size, nmi);
 	if (ret)
 		goto out;
 
 	perf_output_copy(&handle, buf, size);
-	perf_output_end(&handle, nmi);
+	perf_output_end(&handle);
 
 out:
 	return ret;
@@ -1804,7 +1814,7 @@ static void perf_output_group(struct per
 
 	size = sizeof(header) + counter->nr_siblings * sizeof(entry);
 
-	ret = perf_output_begin(&handle, counter, size);
+	ret = perf_output_begin(&handle, counter, size, nmi);
 	if (ret)
 		return;
 
@@ -1824,7 +1834,7 @@ static void perf_output_group(struct per
 		perf_output_put(&handle, entry);
 	}
 
-	perf_output_end(&handle, nmi);
+	perf_output_end(&handle);
 }
 
 void perf_counter_output(struct perf_counter *counter,
@@ -1869,7 +1879,7 @@ static void perf_counter_mmap_output(str
 {
 	struct perf_output_handle handle;
 	int size = mmap_event->event.header.size;
-	int ret = perf_output_begin(&handle, counter, size);
+	int ret = perf_output_begin(&handle, counter, size, 0);
 
 	if (ret)
 		return;
@@ -1877,7 +1887,7 @@ static void perf_counter_mmap_output(str
 	perf_output_put(&handle, mmap_event->event);
 	perf_output_copy(&handle, mmap_event->file_name,
 				   mmap_event->file_size);
-	perf_output_end(&handle, 0);
+	perf_output_end(&handle);
 }
 
 static int perf_counter_mmap_match(struct perf_counter *counter,

-- 

