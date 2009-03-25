Return-Path: <linux-kernel-owner+w=401wt.eu-S1761201AbZCYMJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761201AbZCYMJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760925AbZCYMID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:08:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:57139 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760936AbZCYMIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:08:00 -0400
Date: Wed, 25 Mar 2009 12:06:27 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       arjan@infradead.org, tglx@linutronix.de, fengguang.wu@intel.com,
       mingo@elte.hu
Reply-To: arjan@infradead.org, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       efault@gmx.de, tglx@linutronix.de, fengguang.wu@intel.com,
       mingo@elte.hu
In-Reply-To: <20090325113316.740550870@chello.nl>
References: <20090325113316.740550870@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: more elaborate write API
Message-ID: <tip-c3f81c52021ae1c90c2718aba5114fbd54db20ff@git.kernel.org>
Git-Commit-ID: c3f81c52021ae1c90c2718aba5114fbd54db20ff
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 12:06:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c3f81c52021ae1c90c2718aba5114fbd54db20ff
Gitweb:     http://git.kernel.org/tip/c3f81c52021ae1c90c2718aba5114fbd54db20ff
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 25 Mar 2009 12:30:22 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 13:02:51 +0100

perf_counter: more elaborate write API

Provide a begin, copy, end interface to the output buffer.

begin() reserves the space,
 copy() copies the data over, considering page boundaries,
  end() finalizes the event and does the wakeup.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
LKML-Reference: <20090325113316.740550870@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |  109 +++++++++++++++++++++++++++++++++---------------
 1 files changed, 75 insertions(+), 34 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index affe227..0422fd9 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/mm.h>
 #include <linux/cpu.h>
 #include <linux/smp.h>
 #include <linux/file.h>
@@ -16,15 +17,14 @@
 #include <linux/sysfs.h>
 #include <linux/ptrace.h>
 #include <linux/percpu.h>
+#include <linux/vmstat.h>
+#include <linux/hardirq.h>
+#include <linux/rculist.h>
 #include <linux/uaccess.h>
 #include <linux/syscalls.h>
 #include <linux/anon_inodes.h>
 #include <linux/kernel_stat.h>
 #include <linux/perf_counter.h>
-#include <linux/mm.h>
-#include <linux/vmstat.h>
-#include <linux/rculist.h>
-#include <linux/hardirq.h>
 
 #include <asm/irq_regs.h>
 
@@ -1411,16 +1411,20 @@ static const struct file_operations perf_fops = {
  * Output
  */
 
-static int perf_output_write(struct perf_counter *counter, int nmi,
-			     void *buf, ssize_t size)
+struct perf_output_handle {
+	struct perf_counter	*counter;
+	struct perf_mmap_data	*data;
+	unsigned int		offset;
+	int			wakeup;
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
@@ -1428,45 +1432,82 @@ static int perf_output_write(struct perf_counter *counter, int nmi,
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
+	handle->counter	= counter;
+	handle->data	= data;
+	handle->offset	= offset;
+	handle->wakeup	= (offset >> PAGE_SHIFT) != (head >> PAGE_SHIFT);
 
-	nr = (offset >> PAGE_SHIFT) & (data->nr_pages - 1);
-	offset &= PAGE_SIZE - 1;
+	return 0;
 
-	len = min_t(unsigned int, PAGE_SIZE - offset, size);
-	memcpy(data->data_pages[nr] + offset, buf, len);
-	size -= len;
+out:
+	rcu_read_unlock();
 
-	if (size) {
-		nr = (nr + 1) & (data->nr_pages - 1);
-		memcpy(data->data_pages[nr], buf + len, size);
-	}
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
+	unsigned int pages_mask;
+	unsigned int offset;
+	unsigned int size;
+	void **pages;
+
+	offset		= handle->offset;
+	pages_mask	= handle->data->nr_pages - 1;
+	pages		= handle->data->data_pages;
+
+	do {
+		unsigned int page_offset;
+		int nr;
+
+		nr	    = (offset >> PAGE_SHIFT) & pages_mask;
+		page_offset = offset & (PAGE_SIZE - 1);
+		size	    = min_t(unsigned int, PAGE_SIZE - page_offset, len);
+
+		memcpy(pages[nr] + page_offset, buf, size);
+
+		len	    -= size;
+		buf	    += size;
+		offset	    += size;
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
 
+	ret = perf_output_begin(&handle, counter, size);
+	if (ret)
+		goto out;
+
+	perf_output_copy(&handle, buf, size);
+	perf_output_end(&handle, nmi);
+
+out:
 	return ret;
 }
 
