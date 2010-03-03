Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab0CCGzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 01:55:13 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:61084 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab0CCGzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 01:55:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=N62tveimZtedbt5fLc5b/CqzVjOBhl+0c6xpA0TF0TUYgv19xb5qCVGtwF1320LP12
         xl3K5Y2etXmY4bK8Z2dkKOh1CwSR0QhLRIe1cQwevbF9Z2aUq1P6Jc/L2yZ/srmdHNkj
         VYAzmojhvyHODUEgOXmJ1LYlXDwvh/VWDxP7U=
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
Subject: [PATCH 1/3] lockdep: Move lock events under lockdep recursion protection
Date: Wed,  3 Mar 2010 07:55:00 +0100
Message-Id: <1267599302-2886-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com>
References: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are rcu locked read side areas in the path where we submit
a trace event. And these rcu_read_(un)lock() trigger lock events,
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

This is fixed in this patch by moving the lock trace event under
the lockdep recursion protection.

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
 kernel/lockdep.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index c62ec14..3de6085 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3211,8 +3211,6 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 {
 	unsigned long flags;
 
-	trace_lock_acquire(lock, subclass, trylock, read, check, nest_lock, ip);
-
 	if (unlikely(current->lockdep_recursion))
 		return;
 
@@ -3220,6 +3218,7 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	check_flags(flags);
 
 	current->lockdep_recursion = 1;
+	trace_lock_acquire(lock, subclass, trylock, read, check, nest_lock, ip);
 	__lock_acquire(lock, subclass, trylock, read, check,
 		       irqs_disabled_flags(flags), nest_lock, ip, 0);
 	current->lockdep_recursion = 0;
@@ -3232,14 +3231,13 @@ void lock_release(struct lockdep_map *lock, int nested,
 {
 	unsigned long flags;
 
-	trace_lock_release(lock, nested, ip);
-
 	if (unlikely(current->lockdep_recursion))
 		return;
 
 	raw_local_irq_save(flags);
 	check_flags(flags);
 	current->lockdep_recursion = 1;
+	trace_lock_release(lock, nested, ip);
 	__lock_release(lock, nested, ip);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
@@ -3413,8 +3411,6 @@ void lock_contended(struct lockdep_map *lock, unsigned long ip)
 {
 	unsigned long flags;
 
-	trace_lock_contended(lock, ip);
-
 	if (unlikely(!lock_stat))
 		return;
 
@@ -3424,6 +3420,7 @@ void lock_contended(struct lockdep_map *lock, unsigned long ip)
 	raw_local_irq_save(flags);
 	check_flags(flags);
 	current->lockdep_recursion = 1;
+	trace_lock_contended(lock, ip);
 	__lock_contended(lock, ip);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
-- 
1.6.2.3

