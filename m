Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbZJHCJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbZJHCJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 22:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756839AbZJHCI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 22:08:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45081 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597AbZJHCI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 22:08:58 -0400
Message-Id: <20091008020700.095291343@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 22:06:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhenwen Xu <helight.xu@gmail.com>
Subject: [PATCH 1/2] [PATCH 1/2] tracing: fix warning on kernel/trace/trace_branch.c andtrace_hw_branches.c
References: <20091008020625.084181867@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-fix-warning-on-kernel-trace-trace_branch.c-a.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhenwen Xu <helight.xu@gmail.com>

fix warnings that caused the API change of trace_buffer_lock_reserve()
change files: kernel/trace/trace_hw_branch.c
              kernel/trace/trace_branch.c

Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
LKML-Reference: <20091008012146.GA4170@helight>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_branch.c      |    2 +-
 kernel/trace/trace_hw_branches.c |    8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 7a7a9fd..216e2dd 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -54,7 +54,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 		goto out;
 
 	pc = preempt_count();
-	event = trace_buffer_lock_reserve(tr, TRACE_BRANCH,
+	event = trace_buffer_lock_reserve(tr->buffer, TRACE_BRANCH,
 					  sizeof(*entry), flags, pc);
 	if (!event)
 		goto out;
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index 23b6385..69543a9 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -165,6 +165,7 @@ void trace_hw_branch(u64 from, u64 to)
 	struct ftrace_event_call *call = &event_hw_branch;
 	struct trace_array *tr = hw_branch_trace;
 	struct ring_buffer_event *event;
+	struct ring_buffer *buf;
 	struct hw_branch_entry *entry;
 	unsigned long irq1;
 	int cpu;
@@ -180,7 +181,8 @@ void trace_hw_branch(u64 from, u64 to)
 	if (atomic_inc_return(&tr->data[cpu]->disabled) != 1)
 		goto out;
 
-	event = trace_buffer_lock_reserve(tr, TRACE_HW_BRANCHES,
+	buf = tr->buffer;
+	event = trace_buffer_lock_reserve(buf, TRACE_HW_BRANCHES,
 					  sizeof(*entry), 0, 0);
 	if (!event)
 		goto out;
@@ -189,8 +191,8 @@ void trace_hw_branch(u64 from, u64 to)
 	entry->ent.type = TRACE_HW_BRANCHES;
 	entry->from = from;
 	entry->to   = to;
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		trace_buffer_unlock_commit(tr, event, 0, 0);
+	if (!filter_check_discard(call, entry, buf, event))
+		trace_buffer_unlock_commit(buf, event, 0, 0);
 
  out:
 	atomic_dec(&tr->data[cpu]->disabled);
-- 
1.6.3.3


