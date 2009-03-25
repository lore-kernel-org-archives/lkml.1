Return-Path: <linux-kernel-owner+w=401wt.eu-S1760347AbZCYLkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760347AbZCYLkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759525AbZCYLiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:38:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47120 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758864AbZCYLis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:38:48 -0400
Message-Id: <20090325113317.013775235@chello.nl>
References: <20090325113021.781490788@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 25 Mar 2009 12:30:25 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/6] perf_counter: optionally provide the pid/tid of the sampled task
Content-Disposition: inline; filename=perf_counter-tid.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow cpu wide counters to profile userspace by providing what process
the sample belongs to.

This raises the first issue with the output type, lots of these
options: group, tid, callchain, etc.. are non-exclusive and could be
combined, suggesting a bitfield.

However, things like the mmap() data stream doesn't fit in that.

How to split the type field...

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    5 ++++-
 kernel/perf_counter.c        |   18 ++++++++++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -127,8 +127,9 @@ struct perf_counter_hw_event {
 				exclude_kernel :  1, /* ditto kernel          */
 				exclude_hv     :  1, /* ditto hypervisor      */
 				exclude_idle   :  1, /* don't count when idle */
+				include_tid    :  1, /* include the tid */
 
-				__reserved_1   : 55;
+				__reserved_1   : 54;
 
 	__u32			extra_config_len;
 	__u32			__reserved_4;
@@ -164,6 +165,8 @@ struct perf_event_header {
 enum perf_event_type {
 	PERF_EVENT_IP		= 0,
 	PERF_EVENT_GROUP	= 1,
+
+	__PERF_EVENT_TID	= 0x100,
 };
 
 #ifdef __KERNEL__
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1521,16 +1521,30 @@ out:
 static void perf_output_simple(struct perf_counter *counter,
 			       int nmi, struct pt_regs *regs)
 {
+	unsigned int size;
 	struct {
 		struct perf_event_header header;
 		u64 ip;
+		u32 pid, tid;
 	} event;
 
 	event.header.type = PERF_EVENT_IP;
-	event.header.size = sizeof(event);
 	event.ip = instruction_pointer(regs);
 
-	perf_output_write(counter, nmi, &event, sizeof(event));
+	size = sizeof(event);
+
+	if (counter->hw_event.include_tid) {
+		/* namespace issues */
+		event.pid = current->group_leader->pid;
+		event.tid = current->pid;
+
+		event.header.type |= __PERF_EVENT_TID;
+	} else
+		size -= sizeof(u64);
+
+	event.header.size = size;
+
+	perf_output_write(counter, nmi, &event, size);
 }
 
 static void perf_output_group(struct perf_counter *counter, int nmi)

-- 

