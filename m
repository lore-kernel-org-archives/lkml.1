Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbZCYLju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbZCYLju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759580AbZCYLix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:38:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47124 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759122AbZCYLis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:38:48 -0400
Message-Id: <20090325113316.831607932@chello.nl>
References: <20090325113021.781490788@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 25 Mar 2009 12:30:23 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/6] perf_counter: output objects
Content-Disposition: inline; filename=perf_counter-output-obj.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a {type,size} header for each output entry.

This should provide extensible output, and the ability to mix multiple streams.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |   11 ++++++++
 kernel/perf_counter.c        |   55 ++++++++++++++++++++++++++++++++-----------
 2 files changed, 53 insertions(+), 13 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
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
 
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -75,8 +75,10 @@ list_add_counter(struct perf_counter *co
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
@@ -89,6 +91,9 @@ list_del_counter(struct perf_counter *co
 	list_del_init(&counter->list_entry);
 	list_del_rcu(&counter->event_entry);
 
+	if (counter->group_leader != counter)
+		counter->group_leader->nr_siblings--;
+
 	/*
 	 * If this was a group counter with sibling counters then
 	 * upgrade the siblings to singleton counters by adding them
@@ -381,9 +386,11 @@ static int is_software_only_group(struct
 
 	if (!is_software_counter(leader))
 		return 0;
+
 	list_for_each_entry(counter, &leader->sibling_list, list_entry)
 		if (!is_software_counter(counter))
 			return 0;
+
 	return 1;
 }
 
@@ -1473,6 +1480,9 @@ static void perf_output_copy(struct perf
 	handle->offset = offset;
 }
 
+#define perf_output_put(handle, x) \
+	perf_output_copy((handle), &(x), sizeof(x))
+
 static void perf_output_end(struct perf_output_handle *handle, int nmi)
 {
 	if (handle->wakeup) {
@@ -1507,34 +1517,53 @@ out:
 static void perf_output_simple(struct perf_counter *counter,
 			       int nmi, struct pt_regs *regs)
 {
-	u64 entry;
+	struct {
+		struct perf_event_header header;
+		u64 ip;
+	} event;
+
+	event.header.type = PERF_EVENT_IP;
+	event.header.size = sizeof(event);
+	event.ip = instruction_pointer(regs);
 
-	entry = instruction_pointer(regs);
-
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

-- 

