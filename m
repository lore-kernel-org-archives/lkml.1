Return-Path: <linux-kernel-owner+w=401wt.eu-S934500AbZDHRB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934500AbZDHRB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934431AbZDHQ7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:59:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:60402 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934425AbZDHQ7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:59:44 -0400
Date: Wed, 8 Apr 2009 16:57:57 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090408130408.891867663@chello.nl>
References: <20090408130408.891867663@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: use misc field to widen type
Message-ID: <tip-6b6e5486b3a168f0328c82a8d4376caf901472b1@git.kernel.org>
Git-Commit-ID: 6b6e5486b3a168f0328c82a8d4376caf901472b1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 16:57:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6b6e5486b3a168f0328c82a8d4376caf901472b1
Gitweb:     http://git.kernel.org/tip/6b6e5486b3a168f0328c82a8d4376caf901472b1
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 8 Apr 2009 15:01:27 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 18:53:28 +0200

perf_counter: use misc field to widen type

Push the PERF_EVENT_COUNTER_OVERFLOW bit into the misc field so that
we can have the full 32bit for PERF_RECORD_ bits.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090408130408.891867663@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   28 ++++++++++------------------
 kernel/perf_counter.c        |   15 ++++++++-------
 2 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 5bd8817..4809ae1 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
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
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 4af98f9..bf12df6 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1828,15 +1828,16 @@ static void perf_counter_output(struct perf_counter *counter,
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
 
@@ -1845,12 +1846,12 @@ static void perf_counter_output(struct perf_counter *counter,
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
@@ -1861,7 +1862,7 @@ static void perf_counter_output(struct perf_counter *counter,
 		if (callchain) {
 			callchain_size = (1 + callchain->nr) * sizeof(u64);
 
-			header.type |= __PERF_EVENT_CALLCHAIN;
+			header.type |= PERF_RECORD_CALLCHAIN;
 			header.size += callchain_size;
 		}
 	}
@@ -1872,7 +1873,7 @@ static void perf_counter_output(struct perf_counter *counter,
 		 */
 		time = sched_clock();
 
-		header.type |= __PERF_EVENT_TIME;
+		header.type |= PERF_RECORD_TIME;
 		header.size += sizeof(u64);
 	}
 
