Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZKUNoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZKUNoe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbZKUNoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:44:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:32780 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205AbZKUNo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:44:28 -0500
Date: Sat, 21 Nov 2009 13:44:00 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091120212509.251030114@chello.nl>
References: <20091120212509.251030114@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix locking for PERF_FORMAT_GROUP
Message-ID: <tip-6f10581aeaa5543a3b7a8c7a87a064375ec357f8@git.kernel.org>
Git-Commit-ID: 6f10581aeaa5543a3b7a8c7a87a064375ec357f8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f10581aeaa5543a3b7a8c7a87a064375ec357f8
Gitweb:     http://git.kernel.org/tip/6f10581aeaa5543a3b7a8c7a87a064375ec357f8
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 20 Nov 2009 22:19:56 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 21 Nov 2009 14:11:40 +0100

perf: Fix locking for PERF_FORMAT_GROUP

We should hold event->child_mutex when iterating the inherited
counters, we should hold ctx->mutex when iterating siblings.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20091120212509.251030114@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 80f40da..3ede098 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1782,6 +1782,7 @@ u64 perf_event_read_value(struct perf_event *event, u64 *enabled, u64 *running)
 	*enabled = 0;
 	*running = 0;
 
+	mutex_lock(&event->child_mutex);
 	total += perf_event_read(event);
 	*enabled += event->total_time_enabled +
 			atomic64_read(&event->child_total_time_enabled);
@@ -1793,6 +1794,7 @@ u64 perf_event_read_value(struct perf_event *event, u64 *enabled, u64 *running)
 		*enabled += child->total_time_enabled;
 		*running += child->total_time_running;
 	}
+	mutex_unlock(&event->child_mutex);
 
 	return total;
 }
@@ -1802,10 +1804,12 @@ static int perf_event_read_group(struct perf_event *event,
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
@@ -1820,9 +1824,9 @@ static int perf_event_read_group(struct perf_event *event,
 	size = n * sizeof(u64);
 
 	if (copy_to_user(buf, values, size))
-		return -EFAULT;
+		goto unlock;
 
-	ret += size;
+	ret = size;
 
 	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
 		n = 0;
@@ -1833,11 +1837,15 @@ static int perf_event_read_group(struct perf_event *event,
 
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
@@ -1884,12 +1892,10 @@ perf_read_hw(struct perf_event *event, char __user *buf, size_t count)
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
