Return-Path: <linux-kernel-owner+w=401wt.eu-S1759811AbZCYLjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759811AbZCYLjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759350AbZCYLiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:38:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:39781 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759165AbZCYLit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:38:49 -0400
Message-Id: <20090325113316.740550870@chello.nl>
References: <20090325113021.781490788@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 25 Mar 2009 12:30:22 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/6] perf_counter: more elaborate write API
Content-Disposition: inline; filename=perf_counter-write-api.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a begin, copy, end interface to the output buffer.

begin() reserves the space,
copy()  copies the data over, considering page boundaries,
end()   finalizes the event and does the wakeup.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |   96 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 65 insertions(+), 31 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1411,16 +1411,20 @@ static const struct file_operations perf
  * Output
  */
 
-static int perf_output_write(struct perf_counter *counter, int nmi,
-			     void *buf, ssize_t size)
+struct perf_output_handle {
+	struct perf_counter *counter;
+	struct perf_mmap_data *data;
+	unsigned int offset;
+	int wakeup;
+};
+
+static int perf_output_begin(struct perf_output_handle *handle,
+			     struct perf_counter *counter, unsigned int size)
 {
 	struct perf_mmap_data *data;
-	unsigned int offset, head, nr;
-	unsigned int len;
-	int ret, wakeup;
+	unsigned int offset, head;
 
 	rcu_read_lock();
-	ret = -ENOSPC;
 	data = rcu_dereference(counter->data);
 	if (!data)
 		goto out;
@@ -1428,45 +1432,75 @@ static int perf_output_write(struct perf
 	if (!data->nr_pages)
 		goto out;
 
-	ret = -EINVAL;
-	if (size > PAGE_SIZE)
-		goto out;
-
 	do {
 		offset = head = atomic_read(&data->head);
 		head += size;
 	} while (atomic_cmpxchg(&data->head, offset, head) != offset);
 
-	wakeup = (offset >> PAGE_SHIFT) != (head >> PAGE_SHIFT);
+	handle->counter = counter;
+	handle->data = data;
+	handle->offset = offset;
+	handle->wakeup = (offset >> PAGE_SHIFT) != (head >> PAGE_SHIFT);
 
-	nr = (offset >> PAGE_SHIFT) & (data->nr_pages - 1);
-	offset &= PAGE_SIZE - 1;
+	return 0;
 
-	len = min_t(unsigned int, PAGE_SIZE - offset, size);
-	memcpy(data->data_pages[nr] + offset, buf, len);
-	size -= len;
-
-	if (size) {
-		nr = (nr + 1) & (data->nr_pages - 1);
-		memcpy(data->data_pages[nr], buf + len, size);
-	}
+out:
+	rcu_read_unlock();
+	return -ENOSPC;
+}
 
-	/*
-	 * generate a poll() wakeup for every page boundary crossed
-	 */
-	if (wakeup) {
-		atomic_xchg(&data->wakeup, POLL_IN);
-		__perf_counter_update_userpage(counter, data);
+static void perf_output_copy(struct perf_output_handle *handle,
+			     void *buf, unsigned int len)
+{
+	unsigned int offset = handle->offset;
+	unsigned int pages_mask = handle->data->nr_pages - 1;
+	unsigned int size;
+	void **pages = handle->data->data_pages;
+
+	do {
+		unsigned int page_offset;
+		int nr;
+
+		nr = (offset >> PAGE_SHIFT) & pages_mask;
+		page_offset = offset & (PAGE_SIZE - 1);
+		size = min_t(unsigned int, PAGE_SIZE - page_offset, len);
+		memcpy(pages[nr] + page_offset, buf, size);
+		len -= size;
+		buf += size;
+		offset += size;
+	} while (len);
+
+	handle->offset = offset;
+}
+
+static void perf_output_end(struct perf_output_handle *handle, int nmi)
+{
+	if (handle->wakeup) {
+		(void)atomic_xchg(&handle->data->wakeup, POLL_IN);
+		__perf_counter_update_userpage(handle->counter, handle->data);
 		if (nmi) {
-			counter->wakeup_pending = 1;
+			handle->counter->wakeup_pending = 1;
 			set_perf_counter_pending();
 		} else
-			wake_up(&counter->waitq);
+			wake_up(&handle->counter->waitq);
 	}
-	ret = 0;
-out:
 	rcu_read_unlock();
+}
+
+static int perf_output_write(struct perf_counter *counter, int nmi,
+			     void *buf, ssize_t size)
+{
+	struct perf_output_handle handle;
+	int ret;
+
+	ret = perf_output_begin(&handle, counter, size);
+	if (ret)
+		goto out;
 
+	perf_output_copy(&handle, buf, size);
+	perf_output_end(&handle, nmi);
+
+out:
 	return ret;
 }
 

-- 

