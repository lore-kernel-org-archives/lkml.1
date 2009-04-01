Return-Path: <linux-kernel-owner+w=401wt.eu-S1760722AbZDAKSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722AbZDAKSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 06:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758071AbZDAKO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 06:14:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:33956 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757689AbZDAKO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 06:14:57 -0400
Date: Wed, 1 Apr 2009 10:14:15 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090330171023.959404268@chello.nl>
References: <20090330171023.959404268@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: small cleanup of the output routines
Message-ID: <tip-8f2d296c34f94cc84bbc21e9f5bf4fde01df6c41@git.kernel.org>
Git-Commit-ID: 8f2d296c34f94cc84bbc21e9f5bf4fde01df6c41
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 10:14:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f2d296c34f94cc84bbc21e9f5bf4fde01df6c41
Gitweb:     http://git.kernel.org/tip/8f2d296c34f94cc84bbc21e9f5bf4fde01df6c41
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 30 Mar 2009 19:07:11 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Apr 2009 11:33:36 +0200

perf_counter: small cleanup of the output routines

Move the nmi argument to the _begin() function, so that _end() only needs the
handle. This allows the _begin() function to generate a wakeup on event loss.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090330171023.959404268@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   42 ++++++++++++++++++++++++++----------------
 1 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d07b452..4471e7e 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
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
@@ -1676,15 +1686,17 @@ static int perf_output_begin(struct perf_output_handle *handle,
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
@@ -1692,6 +1704,8 @@ static int perf_output_begin(struct perf_output_handle *handle,
 
 	return 0;
 
+fail:
+	__perf_output_wakeup(handle);
 out:
 	rcu_read_unlock();
 
@@ -1733,14 +1747,10 @@ static void perf_output_copy(struct perf_output_handle *handle,
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
 
@@ -1750,12 +1760,12 @@ static int perf_output_write(struct perf_counter *counter, int nmi,
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
@@ -1804,7 +1814,7 @@ static void perf_output_group(struct perf_counter *counter, int nmi)
 
 	size = sizeof(header) + counter->nr_siblings * sizeof(entry);
 
-	ret = perf_output_begin(&handle, counter, size);
+	ret = perf_output_begin(&handle, counter, size, nmi);
 	if (ret)
 		return;
 
@@ -1824,7 +1834,7 @@ static void perf_output_group(struct perf_counter *counter, int nmi)
 		perf_output_put(&handle, entry);
 	}
 
-	perf_output_end(&handle, nmi);
+	perf_output_end(&handle);
 }
 
 void perf_counter_output(struct perf_counter *counter,
@@ -1869,7 +1879,7 @@ static void perf_counter_mmap_output(struct perf_counter *counter,
 {
 	struct perf_output_handle handle;
 	int size = mmap_event->event.header.size;
-	int ret = perf_output_begin(&handle, counter, size);
+	int ret = perf_output_begin(&handle, counter, size, 0);
 
 	if (ret)
 		return;
@@ -1877,7 +1887,7 @@ static void perf_counter_mmap_output(struct perf_counter *counter,
 	perf_output_put(&handle, mmap_event->event);
 	perf_output_copy(&handle, mmap_event->file_name,
 				   mmap_event->file_size);
-	perf_output_end(&handle, 0);
+	perf_output_end(&handle);
 }
 
 static int perf_counter_mmap_match(struct perf_counter *counter,
