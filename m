Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbZJHCJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbZJHCJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 22:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbZJHCJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 22:09:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45094 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804AbZJHCI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 22:08:58 -0400
Message-Id: <20091008020700.433266812@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 22:06:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/2] [PATCH 2/2] tracing: user local buffer variable for trace branch tracer
References: <20091008020625.084181867@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-user-local-buffer-variable-for-trace-branch-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Just using the tr->buffer for the API to trace_buffer_lock_reserve
is not good enough. This is because the tr->buffer may change, and we
do not want to commit with a different buffer that we reserved from.

This patch uses a local variable to hold the buffer that was used to
reserve and commit with.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_branch.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 216e2dd..4a194f0 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -34,6 +34,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 	struct trace_array *tr = branch_tracer;
 	struct ring_buffer_event *event;
 	struct trace_branch *entry;
+	struct ring_buffer *buffer;
 	unsigned long flags;
 	int cpu, pc;
 	const char *p;
@@ -54,7 +55,8 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 		goto out;
 
 	pc = preempt_count();
-	event = trace_buffer_lock_reserve(tr->buffer, TRACE_BRANCH,
+	buffer = tr->buffer;
+	event = trace_buffer_lock_reserve(buffer, TRACE_BRANCH,
 					  sizeof(*entry), flags, pc);
 	if (!event)
 		goto out;
@@ -74,8 +76,8 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 	entry->line = f->line;
 	entry->correct = val == expect;
 
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, buffer, event))
+		ring_buffer_unlock_commit(buffer, event);
 
  out:
 	atomic_dec(&tr->data[cpu]->disabled);
-- 
1.6.3.3


