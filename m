Return-Path: <linux-kernel-owner+w=401wt.eu-S1765405AbZDHNET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765405AbZDHNET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765292AbZDHND2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:03:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54108 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765304AbZDHND0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:03:26 -0400
Message-Id: <20090408130409.307926436@chello.nl>
References: <20090408130124.715559390@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 08 Apr 2009 15:01:32 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 8/9] perf_counter: move PERF_RECORD_TIME
Content-Disposition: inline; filename=perf_counter-move-time.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move PERF_RECORD_TIME so that all the fixed length items vome before
the variable length ones.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    9 ++++-----
 kernel/perf_counter.c        |   26 +++++++++++++-------------
 2 files changed, 17 insertions(+), 18 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -100,9 +100,9 @@ enum sw_event_ids {
 enum perf_counter_record_format {
 	PERF_RECORD_IP		= 1U << 0,
 	PERF_RECORD_TID		= 1U << 1,
-	PERF_RECORD_GROUP	= 1U << 2,
-	PERF_RECORD_CALLCHAIN	= 1U << 3,
-	PERF_RECORD_TIME	= 1U << 4,
+	PERF_RECORD_TIME	= 1U << 2,
+	PERF_RECORD_GROUP	= 1U << 3,
+	PERF_RECORD_CALLCHAIN	= 1U << 4,
 };
 
 /*
@@ -250,6 +250,7 @@ enum perf_event_type {
 	 *
 	 * 	{ u64			ip;	  } && PERF_RECORD_IP
 	 * 	{ u32			pid, tid; } && PERF_RECORD_TID
+	 * 	{ u64			time;     } && PERF_RECORD_TIME
 	 *
 	 * 	{ u64			nr;
 	 * 	  { u64 event, val; } 	cnt[nr];  } && PERF_RECORD_GROUP
@@ -259,8 +260,6 @@ enum perf_event_type {
 	 * 				kernel,
 	 * 				user;
 	 * 	  u64			ips[nr];  } && PERF_RECORD_CALLCHAIN
-	 *
-	 * 	{ u64			time;     } && PERF_RECORD_TIME
 	 * };
 	 */
 };
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1850,6 +1850,16 @@ static void perf_counter_output(struct p
 		header.size += sizeof(tid_entry);
 	}
 
+	if (record_type & PERF_RECORD_TIME) {
+		/*
+		 * Maybe do better on x86 and provide cpu_clock_nmi()
+		 */
+		time = sched_clock();
+
+		header.type |= PERF_RECORD_TIME;
+		header.size += sizeof(u64);
+	}
+
 	if (record_type & PERF_RECORD_GROUP) {
 		header.type |= PERF_RECORD_GROUP;
 		header.size += sizeof(u64) +
@@ -1867,16 +1877,6 @@ static void perf_counter_output(struct p
 		}
 	}
 
-	if (record_type & PERF_RECORD_TIME) {
-		/*
-		 * Maybe do better on x86 and provide cpu_clock_nmi()
-		 */
-		time = sched_clock();
-
-		header.type |= PERF_RECORD_TIME;
-		header.size += sizeof(u64);
-	}
-
 	ret = perf_output_begin(&handle, counter, header.size, nmi, 1);
 	if (ret)
 		return;
@@ -1889,6 +1889,9 @@ static void perf_counter_output(struct p
 	if (record_type & PERF_RECORD_TID)
 		perf_output_put(&handle, tid_entry);
 
+	if (record_type & PERF_RECORD_TIME)
+		perf_output_put(&handle, time);
+
 	if (record_type & PERF_RECORD_GROUP) {
 		struct perf_counter *leader, *sub;
 		u64 nr = counter->nr_siblings;
@@ -1910,9 +1913,6 @@ static void perf_counter_output(struct p
 	if (callchain)
 		perf_output_copy(&handle, callchain, callchain_size);
 
-	if (record_type & PERF_RECORD_TIME)
-		perf_output_put(&handle, time);
-
 	perf_output_end(&handle);
 }
 

-- 

