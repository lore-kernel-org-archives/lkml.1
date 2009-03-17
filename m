Return-Path: <linux-kernel-owner+w=401wt.eu-S1762677AbZCQDuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762677AbZCQDuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 23:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758956AbZCQDtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 23:49:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39233 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbZCQDtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 23:49:31 -0400
Message-Id: <20090317034929.016125439@goodmis.org>
References: <20090317034820.400357912@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 16 Mar 2009 23:48:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/3] tracing: stop comm recording on tracing off
Content-Disposition: inline; filename=0003-tracing-stop-comm-recording-on-tracing-off.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix for losing comms in trace

The command lines of tasks are cached at sched switch to not need
to record them at every trace point.  Disabling the tracing on stops
the recording of traces, but does not stop the caching of command lines.
When the tracing is off the cache may overflow and cause the tracing
to show incorrect tasks matching the PIDs.

This patch disables prevents updates to the comm cache when the ring buffer
is off.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2796bd2..8f89690 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -797,7 +797,7 @@ void trace_find_cmdline(int pid, char comm[])
 
 void tracing_record_cmdline(struct task_struct *tsk)
 {
-	if (atomic_read(&trace_record_cmdline_disabled))
+	if (atomic_read(&trace_record_cmdline_disabled) || !tracing_is_on())
 		return;
 
 	trace_save_cmdline(tsk);
-- 
1.6.2

-- 
