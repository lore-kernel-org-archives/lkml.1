Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbZKUNnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbZKUNnK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755167AbZKUNnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:43:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:60921 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151AbZKUNnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:43:04 -0500
Date: Sat, 21 Nov 2009 13:42:23 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20091120212508.685559857@chello.nl>
References: <20091120212508.685559857@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix PERF_FORMAT_GROUP scale info
Message-ID: <tip-abf4868b8548cae18d4fe8bbfb4e207443be01be@git.kernel.org>
Git-Commit-ID: abf4868b8548cae18d4fe8bbfb4e207443be01be
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  abf4868b8548cae18d4fe8bbfb4e207443be01be
Gitweb:     http://git.kernel.org/tip/abf4868b8548cae18d4fe8bbfb4e207443be01be
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 20 Nov 2009 22:19:49 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 21 Nov 2009 14:11:37 +0100

perf: Fix PERF_FORMAT_GROUP scale info

As Corey reported, the total_enabled and total_running times
could occasionally be 0, even though there were events counted.

It turns out this is because we record the times before reading
the counter while the latter updates the times.

This patch corrects that.

While looking at this code I found that there is a lot of
locking iffyness around, the following patches correct most of
that.

Reported-by: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20091120212508.685559857@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   52 ++++++++++++++++++++------------------------------
 1 files changed, 21 insertions(+), 31 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 68fbf4f..9a18ff2 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1784,30 +1784,15 @@ u64 perf_event_read_value(struct perf_event *event)
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
@@ -1818,28 +1803,33 @@ static int perf_event_read_group(struct perf_event *event,
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
