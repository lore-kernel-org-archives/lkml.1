Return-Path: <linux-kernel-owner+w=401wt.eu-S1756350AbZKTVcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbZKTVcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756310AbZKTVcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:32:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:48332 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494AbZKTV21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:28:27 -0500
Message-Id: <20091120212509.153379276@chello.nl>
References: <20091120211942.676891948@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 20 Nov 2009 22:19:55 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/15] perf: fix event scaling for inherited counters
Content-Disposition: inline; filename=perf-time-6.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly account the full hierarchy of counters for both the count
(we already did so) and the scale times (new).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |    3 +-
 kernel/perf_event.c        |   48 ++++++++++++++++++++++++---------------------
 2 files changed, 28 insertions(+), 23 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1774,14 +1774,25 @@ static int perf_event_read_size(struct p
 	return size;
 }
 
-u64 perf_event_read_value(struct perf_event *event)
+u64 perf_event_read_value(struct perf_event *event, u64 *enabled, u64 *running)
 {
 	struct perf_event *child;
 	u64 total = 0;
 
+	*enabled = 0;
+	*running = 0;
+
 	total += perf_event_read(event);
-	list_for_each_entry(child, &event->child_list, child_list)
+	*enabled += event->total_time_enabled +
+			atomic64_read(&event->child_total_time_enabled);
+	*running += event->total_time_running +
+			atomic64_read(&event->child_total_time_running);
+
+	list_for_each_entry(child, &event->child_list, child_list) {
 		total += perf_event_read(child);
+		*enabled += child->total_time_enabled;
+		*running += child->total_time_running;
+	}
 
 	return total;
 }
@@ -1793,19 +1804,15 @@ static int perf_event_read_group(struct 
 	struct perf_event *leader = event->group_leader, *sub;
 	int n = 0, size = 0, ret = 0;
 	u64 values[5];
-	u64 count;
+	u64 count, enabled, running;
 
-	count = perf_event_read_value(leader);
+	count = perf_event_read_value(leader, &enabled, &running);
 
 	values[n++] = 1 + leader->nr_siblings;
-	if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED) {
-		values[n++] = leader->total_time_enabled +
-			atomic64_read(&leader->child_total_time_enabled);
-	}
-	if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING) {
-		values[n++] = leader->total_time_running +
-			atomic64_read(&leader->child_total_time_running);
-	}
+	if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
+		values[n++] = enabled;
+	if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
+		values[n++] = running;
 	values[n++] = count;
 	if (read_format & PERF_FORMAT_ID)
 		values[n++] = primary_event_id(leader);
@@ -1820,7 +1827,7 @@ static int perf_event_read_group(struct 
 	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
 		n = 0;
 
-		values[n++] = perf_event_read_value(sub);
+		values[n++] = perf_event_read_value(sub, &enabled, &running);
 		if (read_format & PERF_FORMAT_ID)
 			values[n++] = primary_event_id(sub);
 
@@ -1838,18 +1845,15 @@ static int perf_event_read_group(struct 
 static int perf_event_read_one(struct perf_event *event,
 				 u64 read_format, char __user *buf)
 {
+	u64 enabled, running;
 	u64 values[4];
 	int n = 0;
 
-	values[n++] = perf_event_read_value(event);
-	if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED) {
-		values[n++] = event->total_time_enabled +
-			atomic64_read(&event->child_total_time_enabled);
-	}
-	if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING) {
-		values[n++] = event->total_time_running +
-			atomic64_read(&event->child_total_time_running);
-	}
+	values[n++] = perf_event_read_value(event, &enabled, &running);
+	if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
+		values[n++] = enabled;
+	if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
+		values[n++] = running;
 	if (read_format & PERF_FORMAT_ID)
 		values[n++] = primary_event_id(event);
 
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -782,7 +782,8 @@ perf_event_create_kernel_counter(struct 
 				int cpu,
 				pid_t pid,
 				perf_callback_t callback);
-extern u64 perf_event_read_value(struct perf_event *event);
+extern u64 perf_event_read_value(struct perf_event *event,
+				 u64 *enabled, u64 *running);
 
 struct perf_sample_data {
 	u64				type;

-- 

