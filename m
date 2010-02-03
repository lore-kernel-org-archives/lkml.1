Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab0BCJP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 04:15:59 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:57321 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781Ab0BCJOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 04:14:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DzF5IywLt/AYKYf2UxQxVXa92UJd/Z2hgQqMwDxq0tLd5ZY9GIKaZWHfrO2ahV39sr
         KATxgPxjPWBzJrav+ldvrKabsPxxYH8fKKzAWFs33FyybtPbHeVCgNZJL9TErXsW3FX/
         uOhRLjkp9i7Z91EmOyXj///s86eo3mEqpoUPg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 10/11] tracing/perf: Fix lock events recursions in the fast path
Date: Wed,  3 Feb 2010 10:14:34 +0100
Message-Id: <1265188475-23509-11-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are rcu locked read side areas in the path where we submit
a trace events. And these rcu_read_(un)lock() trigger lock events,
which create recursive events.

One pair in do_perf_sw_event:

__lock_acquire
      |
      |--96.11%-- lock_acquire
      |          |
      |          |--27.21%-- do_perf_sw_event
      |          |          perf_tp_event
      |          |          |
      |          |          |--49.62%-- ftrace_profile_lock_release
      |          |          |          lock_release
      |          |          |          |
      |          |          |          |--33.85%-- _raw_spin_unlock

Another pair in perf_output_begin/end:

__lock_acquire
      |--23.40%-- perf_output_begin
      |          |          __perf_event_overflow
      |          |          perf_swevent_overflow
      |          |          perf_swevent_add
      |          |          perf_swevent_ctx_event
      |          |          do_perf_sw_event
      |          |          perf_tp_event
      |          |          |
      |          |          |--55.37%-- ftrace_profile_lock_acquire
      |          |          |          lock_acquire
      |          |          |          |
      |          |          |          |--37.31%-- _raw_spin_lock

The problem is not that much the trace recursion itself, as we have a
recursion protection already (though it's always wasteful to recurse).
But the trace events are outside the lockdep recursion protection, then
each lockdep event triggers a lock trace, which will trigger two
other lockdep events. Here the recursive lock trace event won't
be taken because of the trace recursion, so the recursion stops there
but lockdep will still analyse these new events:

To sum up, for each lockdep events we have:

	lock_*()
	     |
             trace lock_acquire
                  |
                  ----- rcu_read_lock()
                  |          |
                  |          lock_acquire()
                  |          |
                  |          trace_lock_acquire() (stopped)
                  |          |
		  |          lockdep analyze
                  |
                  ----- rcu_read_unlock()
                             |
                             lock_release
                             |
                             trace_lock_release() (stopped)
                             |
                             lockdep analyze

And you can repeat the above two times as we have two rcu read side
sections when we submit an event.

This is fixed in this pacth by using the non-lockdep versions of
rcu_read_(un)lock.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 kernel/perf_event.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 280ae44..98fd360 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2986,7 +2986,7 @@ int perf_output_begin(struct perf_output_handle *handle,
 		u64			 lost;
 	} lost_event;
 
-	rcu_read_lock();
+	__rcu_read_lock();
 	/*
 	 * For inherited events we send all the output towards the parent.
 	 */
@@ -3051,7 +3051,7 @@ fail:
 	atomic_inc(&data->lost);
 	perf_output_unlock(handle);
 out:
-	rcu_read_unlock();
+	__rcu_read_unlock();
 
 	return -ENOSPC;
 }
@@ -3072,7 +3072,7 @@ void perf_output_end(struct perf_output_handle *handle)
 	}
 
 	perf_output_unlock(handle);
-	rcu_read_unlock();
+	__rcu_read_unlock();
 }
 
 static u32 perf_event_pid(struct perf_event *event, struct task_struct *p)
@@ -4116,7 +4116,7 @@ static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
 	struct perf_event_context *ctx;
 
 	cpuctx = &__get_cpu_var(perf_cpu_context);
-	rcu_read_lock();
+	__rcu_read_lock();
 	perf_swevent_ctx_event(&cpuctx->ctx, type, event_id,
 				 nr, nmi, data, regs);
 	/*
@@ -4126,7 +4126,7 @@ static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
 	ctx = rcu_dereference(current->perf_event_ctxp);
 	if (ctx)
 		perf_swevent_ctx_event(ctx, type, event_id, nr, nmi, data, regs);
-	rcu_read_unlock();
+	__rcu_read_unlock();
 }
 
 void __perf_sw_event(u32 event_id, u64 nr, int nmi,
-- 
1.6.2.3

