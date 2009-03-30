Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbZC3RMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbZC3RMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbZC3RL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:11:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:49738 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbZC3RLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:11:22 -0400
Message-Id: <20090330171024.047961770@chello.nl>
References: <20090330170701.856843742@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 30 Mar 2009 19:07:12 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 11/15] perf_counter: re-arrange the perf_event_type
Content-Disposition: inline; filename=perf_counter-rearrange-event-types.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Breaks ABI yet again :-)

Change the event type so that [0, 2^31-1] are regular event types, but
[2^31, 2^32-1] forms a bitmask for overflow events.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    6 +++-
 kernel/perf_counter.c        |   56 +++++++++++++++++++------------------------
 2 files changed, 29 insertions(+), 33 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -210,13 +210,15 @@ struct perf_event_header {
 };
 
 enum perf_event_type {
-	PERF_EVENT_IP		= 0,
+
 	PERF_EVENT_GROUP	= 1,
 
 	PERF_EVENT_MMAP		= 2,
 	PERF_EVENT_MUNMAP	= 3,
 
-	__PERF_EVENT_TID	= 0x100,
+	PERF_EVENT_OVERFLOW	= 1UL << 31,
+	__PERF_EVENT_IP		= 1UL << 30,
+	__PERF_EVENT_TID	= 1UL << 29,
 };
 
 #ifdef __KERNEL__
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1754,50 +1754,44 @@ static void perf_output_end(struct perf_
 	rcu_read_unlock();
 }
 
-static int perf_output_write(struct perf_counter *counter, int nmi,
-			     void *buf, ssize_t size)
-{
-	struct perf_output_handle handle;
-	int ret;
-
-	ret = perf_output_begin(&handle, counter, size, nmi);
-	if (ret)
-		goto out;
-
-	perf_output_copy(&handle, buf, size);
-	perf_output_end(&handle);
-
-out:
-	return ret;
-}
-
 static void perf_output_simple(struct perf_counter *counter,
 			       int nmi, struct pt_regs *regs)
 {
-	unsigned int size;
+	int ret;
+	struct perf_output_handle handle;
+	struct perf_event_header header;
+	u64 ip;
 	struct {
-		struct perf_event_header header;
-		u64 ip;
 		u32 pid, tid;
-	} event;
+	} tid_entry;
 
-	event.header.type = PERF_EVENT_IP;
-	event.ip = instruction_pointer(regs);
+	header.type = PERF_EVENT_OVERFLOW;
+	header.size = sizeof(header);
 
-	size = sizeof(event);
+	ip = instruction_pointer(regs);
+	header.type |= __PERF_EVENT_IP;
+	header.size += sizeof(ip);
 
 	if (counter->hw_event.include_tid) {
 		/* namespace issues */
-		event.pid = current->group_leader->pid;
-		event.tid = current->pid;
+		tid_entry.pid = current->group_leader->pid;
+		tid_entry.tid = current->pid;
 
-		event.header.type |= __PERF_EVENT_TID;
-	} else
-		size -= sizeof(u64);
+		header.type |= __PERF_EVENT_TID;
+		header.size += sizeof(tid_entry);
+	}
 
-	event.header.size = size;
+	ret = perf_output_begin(&handle, counter, header.size, nmi);
+	if (ret)
+		return;
+
+	perf_output_put(&handle, header);
+	perf_output_put(&handle, ip);
+
+	if (counter->hw_event.include_tid)
+		perf_output_put(&handle, tid_entry);
 
-	perf_output_write(counter, nmi, &event, size);
+	perf_output_end(&handle);
 }
 
 static void perf_output_group(struct perf_counter *counter, int nmi)

-- 

