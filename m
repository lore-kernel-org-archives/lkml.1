Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbZHBNKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbZHBNKh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbZHBNKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:10:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:34006 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbZHBNKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:10:35 -0400
Date: Sun, 2 Aug 2009 13:10:00 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Collapse inherit on read()
Message-ID: <tip-e53c0994709166b111fbe9162d1a16ece7dfc45b@git.kernel.org>
Git-Commit-ID: e53c0994709166b111fbe9162d1a16ece7dfc45b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 02 Aug 2009 13:10:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e53c0994709166b111fbe9162d1a16ece7dfc45b
Gitweb:     http://git.kernel.org/tip/e53c0994709166b111fbe9162d1a16ece7dfc45b
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 24 Jul 2009 14:42:10 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 2 Aug 2009 13:47:54 +0200

perf_counter: Collapse inherit on read()

Currently the counter value returned by read() is the value of
the parent counter, to which child counters are only fed back
on child exit.

Thus read() can return rather erratic (and meaningless) numbers
depending on the state of the child processes.

Change this by always iterating the full child hierarchy on
read() and sum all counters.

Suggested-by: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 9509310..48471d7 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1688,6 +1688,18 @@ static int perf_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static u64 perf_counter_read_tree(struct perf_counter *counter)
+{
+	struct perf_counter *child;
+	u64 total = 0;
+
+	total += perf_counter_read(counter);
+	list_for_each_entry(child, &counter->child_list, child_list)
+		total += perf_counter_read(child);
+
+	return total;
+}
+
 /*
  * Read the performance counter - simple non blocking version for now
  */
@@ -1707,7 +1719,7 @@ perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
 
 	WARN_ON_ONCE(counter->ctx->parent_ctx);
 	mutex_lock(&counter->child_mutex);
-	values[0] = perf_counter_read(counter);
+	values[0] = perf_counter_read_tree(counter);
 	n = 1;
 	if (counter->attr.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
 		values[n++] = counter->total_time_enabled +
