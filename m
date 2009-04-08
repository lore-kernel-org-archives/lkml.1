Return-Path: <linux-kernel-owner+w=401wt.eu-S932068AbZDHNH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbZDHNH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765312AbZDHNDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:03:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:48871 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765344AbZDHNDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:03:34 -0400
Message-Id: <20090408130408.891867663@chello.nl>
References: <20090408130124.715559390@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 08 Apr 2009 15:01:27 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/9] perf_counter: use misc field to widen type
Content-Disposition: inline; filename=perf_counter-header-overflow.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Push the PERF_EVENT_COUNTER_OVERFLOW bit into the misc field so that
we can have the full 32bit for PERF_RECORD_ bits.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |   28 ++++++++++------------------
 kernel/perf_counter.c        |   15 ++++++++-------
 2 files changed, 18 insertions(+), 25 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -201,8 +201,9 @@ struct perf_counter_mmap_page {
 	__u32   data_head;		/* head in the data section */
 };
 
-#define PERF_EVENT_MISC_KERNEL	(1 << 0)
-#define PERF_EVENT_MISC_USER	(1 << 1)
+#define PERF_EVENT_MISC_KERNEL		(1 << 0)
+#define PERF_EVENT_MISC_USER		(1 << 1)
+#define PERF_EVENT_MISC_OVERFLOW	(1 << 2)
 
 struct perf_event_header {
 	__u32	type;
@@ -230,36 +231,27 @@ enum perf_event_type {
 	PERF_EVENT_MUNMAP		= 2,
 
 	/*
-	 * Half the event type space is reserved for the counter overflow
-	 * bitfields, as found in hw_event.record_type.
-	 *
-	 * These events will have types of the form:
-	 *   PERF_EVENT_COUNTER_OVERFLOW { | __PERF_EVENT_* } *
+	 * When header.misc & PERF_EVENT_MISC_OVERFLOW the event_type field
+	 * will be PERF_RECORD_*
 	 *
 	 * struct {
 	 * 	struct perf_event_header	header;
 	 *
-	 * 	{ u64			ip;	  } && __PERF_EVENT_IP
-	 * 	{ u32			pid, tid; } && __PERF_EVENT_TID
+	 * 	{ u64			ip;	  } && PERF_RECORD_IP
+	 * 	{ u32			pid, tid; } && PERF_RECORD_TID
 	 *
 	 * 	{ u64			nr;
-	 * 	  { u64 event, val; } 	cnt[nr];  } && __PERF_EVENT_GROUP
+	 * 	  { u64 event, val; } 	cnt[nr];  } && PERF_RECORD_GROUP
 	 *
 	 * 	{ u16			nr,
 	 * 				hv,
 	 * 				kernel,
 	 * 				user;
-	 * 	  u64			ips[nr];  } && __PERF_EVENT_CALLCHAIN
+	 * 	  u64			ips[nr];  } && PERF_RECORD_CALLCHAIN
 	 *
-	 * 	{ u64			time;     } && __PERF_EVENT_TIME
+	 * 	{ u64			time;     } && PERF_RECORD_TIME
 	 * };
 	 */
-	PERF_EVENT_COUNTER_OVERFLOW	= 1UL << 31,
-	__PERF_EVENT_IP			= PERF_RECORD_IP,
-	__PERF_EVENT_TID		= PERF_RECORD_TID,
-	__PERF_EVENT_GROUP		= PERF_RECORD_GROUP,
-	__PERF_EVENT_CALLCHAIN		= PERF_RECORD_CALLCHAIN,
-	__PERF_EVENT_TIME		= PERF_RECORD_TIME,
 };
 
 #ifdef __KERNEL__
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1828,15 +1828,16 @@ static void perf_counter_output(struct p
 	int callchain_size = 0;
 	u64 time;
 
-	header.type = PERF_EVENT_COUNTER_OVERFLOW;
+	header.type = 0;
 	header.size = sizeof(header);
 
-	header.misc = user_mode(regs) ?
+	header.misc = PERF_EVENT_MISC_OVERFLOW;
+	header.misc |= user_mode(regs) ?
 		PERF_EVENT_MISC_USER : PERF_EVENT_MISC_KERNEL;
 
 	if (record_type & PERF_RECORD_IP) {
 		ip = instruction_pointer(regs);
-		header.type |= __PERF_EVENT_IP;
+		header.type |= PERF_RECORD_IP;
 		header.size += sizeof(ip);
 	}
 
@@ -1845,12 +1846,12 @@ static void perf_counter_output(struct p
 		tid_entry.pid = current->group_leader->pid;
 		tid_entry.tid = current->pid;
 
-		header.type |= __PERF_EVENT_TID;
+		header.type |= PERF_RECORD_TID;
 		header.size += sizeof(tid_entry);
 	}
 
 	if (record_type & PERF_RECORD_GROUP) {
-		header.type |= __PERF_EVENT_GROUP;
+		header.type |= PERF_RECORD_GROUP;
 		header.size += sizeof(u64) +
 			counter->nr_siblings * sizeof(group_entry);
 	}
@@ -1861,7 +1862,7 @@ static void perf_counter_output(struct p
 		if (callchain) {
 			callchain_size = (1 + callchain->nr) * sizeof(u64);
 
-			header.type |= __PERF_EVENT_CALLCHAIN;
+			header.type |= PERF_RECORD_CALLCHAIN;
 			header.size += callchain_size;
 		}
 	}
@@ -1872,7 +1873,7 @@ static void perf_counter_output(struct p
 		 */
 		time = sched_clock();
 
-		header.type |= __PERF_EVENT_TIME;
+		header.type |= PERF_RECORD_TIME;
 		header.size += sizeof(u64);
 	}
 

-- 

