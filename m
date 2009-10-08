Return-Path: <linux-kernel-owner+w=401wt.eu-S932249AbZJHNs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbZJHNs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 09:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758563AbZJHNs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 09:48:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:34439 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758511AbZJHNs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 09:48:27 -0400
Date: Thu, 8 Oct 2009 13:47:31 GMT
From: tip-bot for Zhenwen Xu <helight.xu@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, helight.xu@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, helight.xu@gmail.com
In-Reply-To: <20091008012146.GA4170@helight>
References: <20091008012146.GA4170@helight>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: fix warning on kernel/trace/trace_branch.c andtrace_hw_branches.c
Message-ID: <tip-c8647b28726b09b087155417bb698e7b3789f8a0@git.kernel.org>
Git-Commit-ID: c8647b28726b09b087155417bb698e7b3789f8a0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 08 Oct 2009 13:47:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c8647b28726b09b087155417bb698e7b3789f8a0
Gitweb:     http://git.kernel.org/tip/c8647b28726b09b087155417bb698e7b3789f8a0
Author:     Zhenwen Xu <helight.xu@gmail.com>
AuthorDate: Thu, 8 Oct 2009 09:21:46 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 7 Oct 2009 21:52:03 -0400

tracing: fix warning on kernel/trace/trace_branch.c andtrace_hw_branches.c

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
