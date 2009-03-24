Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbZCXNHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbZCXNHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbZCXNH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:07:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:41341 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbZCXNH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:07:27 -0400
Date: Tue, 24 Mar 2009 13:06:29 GMT
From: Peter Zijlstra <peterz@infradead.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       peterz@infradead.org, arjan@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       peterz@infradead.org, efault@gmx.de, arjan@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237897096.24918.181.camel@twins>
References: <1237897096.24918.181.camel@twins>
Subject: [tip:perfcounters/core] perf_counter: fix perf_poll()
Message-ID: <tip-47a6aae483f6b98509a4565ad2d8916de77ee078@git.kernel.org>
Git-Commit-ID: 47a6aae483f6b98509a4565ad2d8916de77ee078
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 13:06:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47a6aae483f6b98509a4565ad2d8916de77ee078
Gitweb:     http://git.kernel.org/tip/47a6aae483f6b98509a4565ad2d8916de77ee078
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 24 Mar 2009 13:18:16 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Mar 2009 13:28:56 +0100

perf_counter: fix perf_poll()

Impact: fix kerneltop 100% CPU usage

Only return a poll event when there's actually been one, poll_wait()
doesn't actually wait for the waitq you pass it, it only enqueues
you on it.

Only once all FDs have been iterated and none of thm returned a
poll-event will it schedule().

Also make it return POLL_HUP when there's not mmap() area to read from.

Further, fix a silly bug in the write code.

Reported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arjan van de Ven <arjan@infradead.org>
LKML-Reference: <1237897096.24918.181.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
@@ -1161,7 +1161,16 @@ perf_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
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
 
@@ -1425,7 +1434,7 @@ static int perf_output_write(struct perf_counter *counter, int nmi,
 
 	do {
 		offset = head = atomic_read(&data->head);
-		head += sizeof(u64);
+		head += size;
 	} while (atomic_cmpxchg(&data->head, offset, head) != offset);
 
 	wakeup = (offset >> PAGE_SHIFT) != (head >> PAGE_SHIFT);
@@ -1446,6 +1455,7 @@ static int perf_output_write(struct perf_counter *counter, int nmi,
 	 * generate a poll() wakeup for every page boundary crossed
 	 */
 	if (wakeup) {
+		atomic_xchg(&data->wakeup, POLL_IN);
 		__perf_counter_update_userpage(counter, data);
 		if (nmi) {
 			counter->wakeup_pending = 1;
