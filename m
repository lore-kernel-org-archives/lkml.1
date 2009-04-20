Return-Path: <linux-kernel-owner+w=401wt.eu-S1759343AbZDTW3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbZDTW3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 18:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758566AbZDTWX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 18:23:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33706 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758544AbZDTWX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 18:23:27 -0400
Message-Id: <20090420222325.267573793@goodmis.org>
References: <20090420222257.267399830@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 20 Apr 2009 18:22:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] tracing: use nowakeup version of commit for function event trace tests
Content-Disposition: inline; filename=0002-tracing-use-nowakeup-version-of-commit-for-function.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The startup tests for the event tracer also runs with the function
tracer enabled. The "wakeup" version of the trace commit was used
which can grab spinlocks. If a task was preempted by an NMI
that called a function being traced, it could deadlock due to the
function tracer trying to grab the same lock.

Thanks to Frederic Weisbecker for pointing out where the bug was.

Reported-by: Ingo Molnar <mingo@elte.hu>
Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 98daf5d..672b195 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1164,7 +1164,7 @@ function_test_events_call(unsigned long ip, unsigned long parent_ip)
 	entry->ip			= ip;
 	entry->parent_ip		= parent_ip;
 
-	trace_current_buffer_unlock_commit(event, flags, pc);
+	trace_nowake_buffer_unlock_commit(event, flags, pc);
 
  out:
 	atomic_dec(&per_cpu(test_event_disable, cpu));
-- 
1.6.2.1

-- 
