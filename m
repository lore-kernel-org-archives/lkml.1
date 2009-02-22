Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbZBVWH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbZBVWH2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 17:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbZBVWHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 17:07:15 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:36122 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbZBVWHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 17:07:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:date:subject;
        b=MpXeWmDkqOsUfo2lvSv2uxrTM6dR09mhBgEWrBQswj1ETnC213g0+UIyogDvF0xyYK
         leqJ+hCSnRWQlgcsVpmy9QvquhLp6NRnfz0BlaOmUSxtFT3Ve/OorwKR1zypYo4Vs5Ei
         Kdsaupdwn3pMD3ol8OYUwOuI3UDxEI8dtPXhs=
Message-ID: <49a1cc8f.2283420a.54d2.ffff8461@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Sun, 22 Feb 2009 22:56:08 +0100
Subject: [PATCH] tracing/ftrace: add missing wake-up on some callsites
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix unwaken pipe

Now that we use a common wakeup infrastructure, we must append a wakeup
on few callsites which lack it or tasks reading trace_pipe will not be
awaken when events come on few tracers.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c             |    2 ++
 kernel/trace/trace_branch.c      |    2 ++
 kernel/trace/trace_hw_branches.c |    2 ++
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e1f3b99..7f450b6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3055,6 +3055,8 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
  out:
 	preempt_enable_notrace();
 
+	trace_wake_up();
+
 	return len;
 }
 EXPORT_SYMBOL_GPL(trace_vprintk);
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index c2e68d4..8c8f8c0 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -78,6 +78,8 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
  out:
 	atomic_dec(&tr->data[cpu]->disabled);
 	local_irq_restore(flags);
+
+	trace_wake_up();
 }
 
 static inline
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index 3561aac..ddd87fd 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -202,6 +202,8 @@ void trace_hw_branch(u64 from, u64 to)
  out:
 	atomic_dec(&tr->data[cpu]->disabled);
 	local_irq_restore(irq1);
+
+	trace_wake_up();
 }
 
 static void trace_bts_at(const struct bts_trace *trace, void *at)
-- 
1.6.1


