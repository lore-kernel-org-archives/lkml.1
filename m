Return-Path: <linux-kernel-owner+w=401wt.eu-S1756452AbZDFJp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbZDFJp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbZDFJoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:44:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34364 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbZDFJof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:44:35 -0400
Message-Id: <20090406094518.024173282@chello.nl>
References: <20090406094458.977814421@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 11:45:06 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 08/15] perf_counter: PERF_RECORD_TIME
Content-Disposition: inline; filename=perf_counter-record-time.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By popular request, provide means to log a timestamp along with the
counter overflow event.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    2 ++
 kernel/perf_counter.c        |   14 ++++++++++++++
 2 files changed, 16 insertions(+)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -102,6 +102,7 @@ enum perf_counter_record_format {
 	PERF_RECORD_TID		= 1U << 1,
 	PERF_RECORD_GROUP	= 1U << 2,
 	PERF_RECORD_CALLCHAIN	= 1U << 3,
+	PERF_RECORD_TIME	= 1U << 4,
 };
 
 /*
@@ -221,6 +222,7 @@ enum perf_event_type {
 	__PERF_EVENT_TID		= PERF_RECORD_TID,
 	__PERF_EVENT_GROUP		= PERF_RECORD_GROUP,
 	__PERF_EVENT_CALLCHAIN		= PERF_RECORD_CALLCHAIN,
+	__PERF_EVENT_TIME		= PERF_RECORD_TIME,
 };
 
 #ifdef __KERNEL__
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1823,6 +1823,7 @@ static void perf_counter_output(struct p
 	} group_entry;
 	struct perf_callchain_entry *callchain = NULL;
 	int callchain_size = 0;
+	u64 time;
 
 	header.type = PERF_EVENT_COUNTER_OVERFLOW;
 	header.size = sizeof(header);
@@ -1859,6 +1860,16 @@ static void perf_counter_output(struct p
 		}
 	}
 
+	if (record_type & PERF_RECORD_TIME) {
+		/*
+		 * Maybe do better on x86 and provide cpu_clock_nmi()
+		 */
+		time = sched_clock();
+
+		header.type |= __PERF_EVENT_TIME;
+		header.size += sizeof(u64);
+	}
+
 	ret = perf_output_begin(&handle, counter, header.size, nmi);
 	if (ret)
 		return;
@@ -1892,6 +1903,9 @@ static void perf_counter_output(struct p
 	if (callchain)
 		perf_output_copy(&handle, callchain, callchain_size);
 
+	if (record_type & PERF_RECORD_TIME)
+		perf_output_put(&handle, time);
+
 	perf_output_end(&handle);
 }
 

-- 

