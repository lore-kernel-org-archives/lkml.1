Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbZJHBYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbZJHBYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 21:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbZJHBYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 21:24:07 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:53110 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbZJHBYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 21:24:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PQQuevMCMkWynfnh6idFlj0BdXXAUSwJ7NS2OUX6ZRWpGLFsNzNZND95UtGLpu6/y7
         3xY/2sKL9gzZxo5eeshTQ7i9CcVCXiGobYV3rmk5RTV4lMWTikNG5mTtX4sQJUN9xp4N
         k3Pjzoe9yAj66vDHMOZ8n3zZviik0InI2v8/0=
Date: Thu, 8 Oct 2009 09:21:46 +0800
From: Zhenwen Xu <helight.xu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH V4] fix warning on kernel/trace/trace_branch.c
	andtrace_hw_branches.c
Message-ID: <20091008012146.GA4170@helight>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
References: <20091007113915.GA5265@helight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007113915.GA5265@helight>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix warnings that caused the API change of trace_buffer_lock_reserve()
change files: kernel/trace/trace_hw_branch.c
              kernel/trace/trace_branch.c

Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
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
index 23b6385..52a5903 100644
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
+	buf = tr->buffer
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

-- 
--------------------------------
http://zhwen.org - Open and Free
