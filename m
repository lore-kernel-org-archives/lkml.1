Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbZKTVbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbZKTVbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbZKTVbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:31:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34637 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686AbZKTV22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:28:28 -0500
Message-Id: <20091120212508.685559857@chello.nl>
References: <20091120211942.676891948@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 20 Nov 2009 22:19:49 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/15] perf: Fix PERF_FORMAT_GROUP scale info
Content-Disposition: inline; filename=perf-time-0.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Corey reported, the total_enabled and total_running times could
occasionally be 0, even though there were events counted.

It turns out this is because we record the times before reading the
counter while the latter updates the times.

This patch corrects that.

While looking at this code I found that there is a lot of locking
iffyness around, the following patches correct most of that.

Reported-by: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |   52 +++++++++++++++++++++-------------------------------
 1 file changed, 21 insertions(+), 31 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1784,30 +1784,15 @@ u64 perf_event_read_value(struct perf_ev
 }
 EXPORT_SYMBOL_GPL(perf_event_read_value);
 
-static int perf_event_read_entry(struct perf_event *event,
-				   u64 read_format, char __user *buf)
-{
-	int n = 0, count = 0;
-	u64 values[2];
-
-	values[n++] = perf_event_read_value(event);
-	if (read_format & PERF_FORMAT_ID)
-		values[n++] = primary_event_id(event);
-
-	count = n * sizeof(u64);
-
-	if (copy_to_user(buf, values, count))
-		return -EFAULT;
-
-	return count;
-}
-
 static int perf_event_read_group(struct perf_event *event,
 				   u64 read_format, char __user *buf)
 {
 	struct perf_event *leader = event->group_leader, *sub;
-	int n = 0, size = 0, err = -EFAULT;
-	u64 values[3];
+	int n = 0, size = 0, ret = 0;
+	u64 values[5];
+	u64 count;
+
+	count = perf_event_read_value(leader);
 
 	values[n++] = 1 + leader->nr_siblings;
 	if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED) {
@@ -1818,28 +1803,33 @@ static int perf_event_read_group(struct 
 		values[n++] = leader->total_time_running +
 			atomic64_read(&leader->child_total_time_running);
 	}
+	values[n++] = count;
+	if (read_format & PERF_FORMAT_ID)
+		values[n++] = primary_event_id(leader);
 
 	size = n * sizeof(u64);
 
 	if (copy_to_user(buf, values, size))
 		return -EFAULT;
 
-	err = perf_event_read_entry(leader, read_format, buf + size);
-	if (err < 0)
-		return err;
-
-	size += err;
+	ret += size;
 
 	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
-		err = perf_event_read_entry(sub, read_format,
-				buf + size);
-		if (err < 0)
-			return err;
+		n = 0;
 
-		size += err;
+		values[n++] = perf_event_read_value(sub);
+		if (read_format & PERF_FORMAT_ID)
+			values[n++] = primary_event_id(sub);
+
+		size = n * sizeof(u64);
+
+		if (copy_to_user(buf + size, values, size))
+			return -EFAULT;
+
+		ret += size;
 	}
 
-	return size;
+	return ret;
 }
 
 static int perf_event_read_one(struct perf_event *event,

-- 

