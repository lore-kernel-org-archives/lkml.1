Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbZKTVch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbZKTVch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755651AbZKTV22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:28:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34627 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbZKTV20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:28:26 -0500
Message-Id: <20091120212509.251030114@chello.nl>
References: <20091120211942.676891948@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 20 Nov 2009 22:19:56 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/15] perf: fix locking for PERF_FORMAT_GROUP
Content-Disposition: inline; filename=perf-time-7.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should hold event->child_mutex when iterating the inherited
counters, we should hold ctx->mutex when iterating siblings.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1782,6 +1782,7 @@ u64 perf_event_read_value(struct perf_ev
 	*enabled = 0;
 	*running = 0;
 
+	mutex_lock(&event->child_mutex);
 	total += perf_event_read(event);
 	*enabled += event->total_time_enabled +
 			atomic64_read(&event->child_total_time_enabled);
@@ -1793,6 +1794,7 @@ u64 perf_event_read_value(struct perf_ev
 		*enabled += child->total_time_enabled;
 		*running += child->total_time_running;
 	}
+	mutex_unlock(&event->child_mutex);
 
 	return total;
 }
@@ -1802,10 +1804,12 @@ static int perf_event_read_group(struct 
 				   u64 read_format, char __user *buf)
 {
 	struct perf_event *leader = event->group_leader, *sub;
-	int n = 0, size = 0, ret = 0;
+	int n = 0, size = 0, ret = -EFAULT;
+	struct perf_event_context *ctx = leader->ctx;
 	u64 values[5];
 	u64 count, enabled, running;
 
+	mutex_lock(&ctx->mutex);
 	count = perf_event_read_value(leader, &enabled, &running);
 
 	values[n++] = 1 + leader->nr_siblings;
@@ -1820,9 +1824,9 @@ static int perf_event_read_group(struct 
 	size = n * sizeof(u64);
 
 	if (copy_to_user(buf, values, size))
-		return -EFAULT;
+		goto unlock;
 
-	ret += size;
+	ret = size;
 
 	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
 		n = 0;
@@ -1833,11 +1837,15 @@ static int perf_event_read_group(struct 
 
 		size = n * sizeof(u64);
 
-		if (copy_to_user(buf + size, values, size))
-			return -EFAULT;
+		if (copy_to_user(buf + size, values, size)) {
+			ret = -EFAULT;
+			goto unlock;
+		}
 
 		ret += size;
 	}
+unlock:
+	mutex_unlock(&ctx->mutex);
 
 	return ret;
 }
@@ -1884,12 +1892,10 @@ perf_read_hw(struct perf_event *event, c
 		return -ENOSPC;
 
 	WARN_ON_ONCE(event->ctx->parent_ctx);
-	mutex_lock(&event->child_mutex);
 	if (read_format & PERF_FORMAT_GROUP)
 		ret = perf_event_read_group(event, read_format, buf);
 	else
 		ret = perf_event_read_one(event, read_format, buf);
-	mutex_unlock(&event->child_mutex);
 
 	return ret;
 }

-- 

