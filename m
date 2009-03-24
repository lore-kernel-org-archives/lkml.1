Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbZCXMSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbZCXMSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbZCXMSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:18:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59835 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbZCXMSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:18:38 -0400
Subject: [PATCH] perf_counter: fix perf_poll()
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1237892368.24918.160.camel@twins>
References: <18888.29986.340328.540512@cargo.ozlabs.ibm.com>
	 <1237875063.7530.11.camel@marge.simson.net>
	 <1237875580.7827.3.camel@marge.simson.net>
	 <1237877884.8754.2.camel@marge.simson.net>
	 <18888.38308.223722.602357@cargo.ozlabs.ibm.com>
	 <1237888224.24918.159.camel@twins>
	 <1237891863.13862.27.camel@marge.simson.net>
	 <1237892368.24918.160.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 24 Mar 2009 13:18:16 +0100
Message-Id: <1237897096.24918.181.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The below does seem to fix things (along with the previous kerneltop.c
patch),.. however now kerneltop is going splat like:

# ./kerneltop -e 1:2 -c 10
KernelTop refresh period: 2 seconds
ret: 1
 left: 0000000080200000
   ip: 000000008038d4ad
right: 00000000ffffffff
kerneltop: kerneltop.c:985: record_ip: Assertion `left <= ip && ip <= right' failed.
Aborted

Which isn't making much sense..

---
Only return a poll event when there's actually been one, poll_wait()
doesn't actually wait for the waitq you pass it, it only enqueues you on
it.

Only once all FDs have been iterated and non returned a poll-event will
it schedule().

Also make it return POLL_HUP when there's not mmap() area to read from.

Further, fix a silly bug in the write code.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    1 +
 kernel/perf_counter.c        |   14 ++++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 2b5e66d..48212c1 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -246,6 +246,7 @@ struct file;
 struct perf_mmap_data {
 	struct rcu_head			rcu_head;
 	int				nr_pages;
+	atomic_t			wakeup;
 	atomic_t			head;
 	struct perf_counter_mmap_page   *user_page;
 	void 				*data_pages[0];
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 0dfe910..affe227 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1161,7 +1161,16 @@ perf_read(struct file *file, char __user *buf,
size_t count, loff_t *ppos)
 static unsigned int perf_poll(struct file *file, poll_table *wait)
 {
 	struct perf_counter *counter = file->private_data;
-	unsigned int events = POLLIN;
+	struct perf_mmap_data *data;
+	unsigned int events;
+
+	rcu_read_lock();
+	data = rcu_dereference(counter->data);
+	if (data)
+		events = atomic_xchg(&data->wakeup, 0);
+	else
+		events = POLL_HUP;
+	rcu_read_unlock();
 
 	poll_wait(file, &counter->waitq, wait);
 
@@ -1425,7 +1434,7 @@ static int perf_output_write(struct perf_counter
*counter, int nmi,
 
 	do {
 		offset = head = atomic_read(&data->head);
-		head += sizeof(u64);
+		head += size;
 	} while (atomic_cmpxchg(&data->head, offset, head) != offset);
 
 	wakeup = (offset >> PAGE_SHIFT) != (head >> PAGE_SHIFT);
@@ -1446,6 +1455,7 @@ static int perf_output_write(struct perf_counter
*counter, int nmi,
 	 * generate a poll() wakeup for every page boundary crossed
 	 */
 	if (wakeup) {
+		atomic_xchg(&data->wakeup, POLL_IN);
 		__perf_counter_update_userpage(counter, data);
 		if (nmi) {
 			counter->wakeup_pending = 1;

