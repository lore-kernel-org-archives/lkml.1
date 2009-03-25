Return-Path: <linux-kernel-owner+w=401wt.eu-S1760264AbZCYMHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760264AbZCYMHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbZCYMHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:07:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:57107 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbZCYMHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:07:23 -0400
Date: Wed, 25 Mar 2009 12:06:36 GMT
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
In-Reply-To: <20090325113316.831607932@chello.nl>
References: <20090325113316.831607932@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: output objects
Message-ID: <tip-cc1383cf4762fa39ba7ca6864e150422eb405a33@git.kernel.org>
Git-Commit-ID: cc1383cf4762fa39ba7ca6864e150422eb405a33
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 12:06:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc1383cf4762fa39ba7ca6864e150422eb405a33
Gitweb:     http://git.kernel.org/tip/cc1383cf4762fa39ba7ca6864e150422eb405a33
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 25 Mar 2009 12:30:23 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 13:02:51 +0100

perf_counter: output objects

Provide a {type,size} header for each output entry.

This should provide extensible output, and the ability to mix multiple streams.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
LKML-Reference: <20090325113316.831607932@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   11 ++++++++
 kernel/perf_counter.c        |   53 ++++++++++++++++++++++++++++++++---------
 2 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 48212c1..c256635 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -156,6 +156,16 @@ struct perf_counter_mmap_page {
 	__u32   data_head;		/* head in the data section */
 };
 
+struct perf_event_header {
+	__u32	type;
+	__u32	size;
+};
+
+enum perf_event_type {
+	PERF_EVENT_IP		= 0,
+	PERF_EVENT_GROUP	= 1,
+};
+
 #ifdef __KERNEL__
 /*
  * Kernel-internal data types and definitions:
@@ -260,6 +270,7 @@ struct perf_counter {
 	struct list_head		list_entry;
 	struct list_head		event_entry;
 	struct list_head		sibling_list;
+	int 				nr_siblings;
 	struct perf_counter		*group_leader;
 	const struct hw_perf_counter_ops *hw_ops;
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 0422fd9..d76e311 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -75,8 +75,10 @@ list_add_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 	 */
 	if (counter->group_leader == counter)
 		list_add_tail(&counter->list_entry, &ctx->counter_list);
-	else
+	else {
 		list_add_tail(&counter->list_entry, &group_leader->sibling_list);
+		group_leader->nr_siblings++;
+	}
 
 	list_add_rcu(&counter->event_entry, &ctx->event_list);
 }
@@ -89,6 +91,9 @@ list_del_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 	list_del_init(&counter->list_entry);
 	list_del_rcu(&counter->event_entry);
 
+	if (counter->group_leader != counter)
+		counter->group_leader->nr_siblings--;
+
 	/*
 	 * If this was a group counter with sibling counters then
 	 * upgrade the siblings to singleton counters by adding them
@@ -381,9 +386,11 @@ static int is_software_only_group(struct perf_counter *leader)
 
 	if (!is_software_counter(leader))
 		return 0;
+
 	list_for_each_entry(counter, &leader->sibling_list, list_entry)
 		if (!is_software_counter(counter))
 			return 0;
+
 	return 1;
 }
 
@@ -1480,6 +1487,9 @@ static void perf_output_copy(struct perf_output_handle *handle,
 	handle->offset = offset;
 }
 
+#define perf_output_put(handle, x) \
+	perf_output_copy((handle), &(x), sizeof(x))
+
 static void perf_output_end(struct perf_output_handle *handle, int nmi)
 {
 	if (handle->wakeup) {
@@ -1514,34 +1524,53 @@ out:
 static void perf_output_simple(struct perf_counter *counter,
 			       int nmi, struct pt_regs *regs)
 {
-	u64 entry;
+	struct {
+		struct perf_event_header header;
+		u64 ip;
+	} event;
 
-	entry = instruction_pointer(regs);
+	event.header.type = PERF_EVENT_IP;
+	event.header.size = sizeof(event);
+	event.ip = instruction_pointer(regs);
 
-	perf_output_write(counter, nmi, &entry, sizeof(entry));
+	perf_output_write(counter, nmi, &event, sizeof(event));
 }
 
-struct group_entry {
-	u64 event;
-	u64 counter;
-};
-
 static void perf_output_group(struct perf_counter *counter, int nmi)
 {
+	struct perf_output_handle handle;
+	struct perf_event_header header;
 	struct perf_counter *leader, *sub;
+	unsigned int size;
+	struct {
+		u64 event;
+		u64 counter;
+	} entry;
+	int ret;
+
+	size = sizeof(header) + counter->nr_siblings * sizeof(entry);
+
+	ret = perf_output_begin(&handle, counter, size);
+	if (ret)
+		return;
+
+	header.type = PERF_EVENT_GROUP;
+	header.size = size;
+
+	perf_output_put(&handle, header);
 
 	leader = counter->group_leader;
 	list_for_each_entry(sub, &leader->sibling_list, list_entry) {
-		struct group_entry entry;
-
 		if (sub != counter)
 			sub->hw_ops->read(sub);
 
 		entry.event = sub->hw_event.config;
 		entry.counter = atomic64_read(&sub->count);
 
-		perf_output_write(counter, nmi, &entry, sizeof(entry));
+		perf_output_put(&handle, entry);
 	}
+
+	perf_output_end(&handle, nmi);
 }
 
 void perf_counter_output(struct perf_counter *counter,
