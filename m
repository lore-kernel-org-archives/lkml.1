Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbZDBMEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbZDBMEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbZDBME2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:04:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:51743 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbZDBME1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:04:27 -0400
Date: Thu, 2 Apr 2009 12:03:37 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090402091319.151921176@chello.nl>
References: <20090402091319.151921176@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: move the event overflow output bits to record_type
Message-ID: <tip-59f479bfec417dc9b532d4670d77d53d1a16766b@git.kernel.org>
Git-Commit-ID: 59f479bfec417dc9b532d4670d77d53d1a16766b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 12:03:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  59f479bfec417dc9b532d4670d77d53d1a16766b
Gitweb:     http://git.kernel.org/tip/59f479bfec417dc9b532d4670d77d53d1a16766b
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 2 Apr 2009 11:11:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 2 Apr 2009 13:52:59 +0200

perf_counter: move the event overflow output bits to record_type

Per suggestion from Paul, move the event overflow bits to record_type
and sanitize the enums a bit.

Breaks the ABI -- again ;-)

Suggested-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090402091319.151921176@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   50 ++++++++++++---------
 kernel/perf_counter.c        |  101 ++++++++++++++++-------------------------
 2 files changed, 68 insertions(+), 83 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 43083af..06a6fba 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -73,15 +73,6 @@ enum sw_event_ids {
 	PERF_SW_EVENTS_MAX		= 7,
 };
 
-/*
- * IRQ-notification data record type:
- */
-enum perf_counter_record_type {
-	PERF_RECORD_SIMPLE		= 0,
-	PERF_RECORD_IRQ			= 1,
-	PERF_RECORD_GROUP		= 2,
-};
-
 #define __PERF_COUNTER_MASK(name) 			\
 	(((1ULL << PERF_COUNTER_##name##_BITS) - 1) <<	\
 	 PERF_COUNTER_##name##_SHIFT)
@@ -103,6 +94,17 @@ enum perf_counter_record_type {
 #define PERF_COUNTER_EVENT_MASK		__PERF_COUNTER_MASK(EVENT)
 
 /*
+ * Bits that can be set in hw_event.record_type to request information
+ * in the overflow packets.
+ */
+enum perf_counter_record_format {
+	PERF_RECORD_IP		= 1U << 0,
+	PERF_RECORD_TID		= 1U << 1,
+	PERF_RECORD_GROUP	= 1U << 2,
+	PERF_RECORD_CALLCHAIN	= 1U << 3,
+};
+
+/*
  * Bits that can be set in hw_event.read_format to request that
  * reads on the counter should return the indicated quantities,
  * in increasing order of bit value, after the counter value.
@@ -125,8 +127,8 @@ struct perf_counter_hw_event {
 	__u64			config;
 
 	__u64			irq_period;
-	__u64			record_type;
-	__u64			read_format;
+	__u32			record_type;
+	__u32			read_format;
 
 	__u64			disabled       :  1, /* off by default        */
 				nmi	       :  1, /* NMI sampling          */
@@ -137,12 +139,10 @@ struct perf_counter_hw_event {
 				exclude_kernel :  1, /* ditto kernel          */
 				exclude_hv     :  1, /* ditto hypervisor      */
 				exclude_idle   :  1, /* don't count when idle */
-				include_tid    :  1, /* include the tid       */
 				mmap           :  1, /* include mmap data     */
 				munmap         :  1, /* include munmap data   */
-				callchain      :  1, /* add callchain data    */
 
-				__reserved_1   : 51;
+				__reserved_1   : 53;
 
 	__u32			extra_config_len;
 	__u32			__reserved_4;
@@ -212,15 +212,21 @@ struct perf_event_header {
 
 enum perf_event_type {
 
-	PERF_EVENT_GROUP	= 1,
-
-	PERF_EVENT_MMAP		= 2,
-	PERF_EVENT_MUNMAP	= 3,
+	PERF_EVENT_MMAP			= 1,
+	PERF_EVENT_MUNMAP		= 2,
 
-	PERF_EVENT_OVERFLOW	= 1UL << 31,
-	__PERF_EVENT_IP		= 1UL << 30,
-	__PERF_EVENT_TID	= 1UL << 29,
-	__PERF_EVENT_CALLCHAIN  = 1UL << 28,
+	/*
+	 * Half the event type space is reserved for the counter overflow
+	 * bitfields, as found in hw_event.record_type.
+	 *
+	 * These events will have types of the form:
+	 *   PERF_EVENT_COUNTER_OVERFLOW { | __PERF_EVENT_* } *
+	 */
+	PERF_EVENT_COUNTER_OVERFLOW	= 1UL << 31,
+	__PERF_EVENT_IP			= PERF_RECORD_IP,
+	__PERF_EVENT_TID		= PERF_RECORD_TID,
+	__PERF_EVENT_GROUP		= PERF_RECORD_GROUP,
+	__PERF_EVENT_CALLCHAIN		= PERF_RECORD_CALLCHAIN,
 };
 
 #ifdef __KERNEL__
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 860cdc2..995063d 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1765,27 +1765,34 @@ static void perf_output_end(struct perf_output_handle *handle)
 	rcu_read_unlock();
 }
 
-static void perf_output_simple(struct perf_counter *counter,
-			       int nmi, struct pt_regs *regs)
+void perf_counter_output(struct perf_counter *counter,
+			 int nmi, struct pt_regs *regs)
 {
 	int ret;
+	u64 record_type = counter->hw_event.record_type;
 	struct perf_output_handle handle;
 	struct perf_event_header header;
 	u64 ip;
 	struct {
 		u32 pid, tid;
 	} tid_entry;
+	struct {
+		u64 event;
+		u64 counter;
+	} group_entry;
 	struct perf_callchain_entry *callchain = NULL;
 	int callchain_size = 0;
 
-	header.type = PERF_EVENT_OVERFLOW;
+	header.type = PERF_EVENT_COUNTER_OVERFLOW;
 	header.size = sizeof(header);
 
-	ip = instruction_pointer(regs);
-	header.type |= __PERF_EVENT_IP;
-	header.size += sizeof(ip);
+	if (record_type & PERF_RECORD_IP) {
+		ip = instruction_pointer(regs);
+		header.type |= __PERF_EVENT_IP;
+		header.size += sizeof(ip);
+	}
 
-	if (counter->hw_event.include_tid) {
+	if (record_type & PERF_RECORD_TID) {
 		/* namespace issues */
 		tid_entry.pid = current->group_leader->pid;
 		tid_entry.tid = current->pid;
@@ -1794,7 +1801,13 @@ static void perf_output_simple(struct perf_counter *counter,
 		header.size += sizeof(tid_entry);
 	}
 
-	if (counter->hw_event.callchain) {
+	if (record_type & PERF_RECORD_GROUP) {
+		header.type |= __PERF_EVENT_GROUP;
+		header.size += sizeof(u64) +
+			counter->nr_siblings * sizeof(group_entry);
+	}
+
+	if (record_type & PERF_RECORD_CALLCHAIN) {
 		callchain = perf_callchain(regs);
 
 		if (callchain) {
@@ -1810,69 +1823,35 @@ static void perf_output_simple(struct perf_counter *counter,
 		return;
 
 	perf_output_put(&handle, header);
-	perf_output_put(&handle, ip);
 
-	if (counter->hw_event.include_tid)
-		perf_output_put(&handle, tid_entry);
+	if (record_type & PERF_RECORD_IP)
+		perf_output_put(&handle, ip);
 
-	if (callchain)
-		perf_output_copy(&handle, callchain, callchain_size);
-
-	perf_output_end(&handle);
-}
-
-static void perf_output_group(struct perf_counter *counter, int nmi)
-{
-	struct perf_output_handle handle;
-	struct perf_event_header header;
-	struct perf_counter *leader, *sub;
-	unsigned int size;
-	struct {
-		u64 event;
-		u64 counter;
-	} entry;
-	int ret;
-
-	size = sizeof(header) + counter->nr_siblings * sizeof(entry);
+	if (record_type & PERF_RECORD_TID)
+		perf_output_put(&handle, tid_entry);
 
-	ret = perf_output_begin(&handle, counter, size, nmi);
-	if (ret)
-		return;
+	if (record_type & PERF_RECORD_GROUP) {
+		struct perf_counter *leader, *sub;
+		u64 nr = counter->nr_siblings;
 
-	header.type = PERF_EVENT_GROUP;
-	header.size = size;
+		perf_output_put(&handle, nr);
 
-	perf_output_put(&handle, header);
+		leader = counter->group_leader;
+		list_for_each_entry(sub, &leader->sibling_list, list_entry) {
+			if (sub != counter)
+				sub->hw_ops->read(sub);
 
-	leader = counter->group_leader;
-	list_for_each_entry(sub, &leader->sibling_list, list_entry) {
-		if (sub != counter)
-			sub->hw_ops->read(sub);
+			group_entry.event = sub->hw_event.config;
+			group_entry.counter = atomic64_read(&sub->count);
 
-		entry.event = sub->hw_event.config;
-		entry.counter = atomic64_read(&sub->count);
-
-		perf_output_put(&handle, entry);
+			perf_output_put(&handle, group_entry);
+		}
 	}
 
-	perf_output_end(&handle);
-}
-
-void perf_counter_output(struct perf_counter *counter,
-			 int nmi, struct pt_regs *regs)
-{
-	switch (counter->hw_event.record_type) {
-	case PERF_RECORD_SIMPLE:
-		return;
-
-	case PERF_RECORD_IRQ:
-		perf_output_simple(counter, nmi, regs);
-		break;
+	if (callchain)
+		perf_output_copy(&handle, callchain, callchain_size);
 
-	case PERF_RECORD_GROUP:
-		perf_output_group(counter, nmi);
-		break;
-	}
+	perf_output_end(&handle);
 }
 
 /*
