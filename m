Return-Path: <linux-kernel-owner+w=401wt.eu-S932627AbZDJLIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627AbZDJLIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 07:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762925AbZDJLIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 07:08:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:45262 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758335AbZDJLIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 07:08:19 -0400
Date: Fri, 10 Apr 2009 11:07:35 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1238975373-15739-1-git-send-email-fweisbec@gmail.com>
References: <1238975373-15739-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/core] tracing/lockdep: report the time waited for a lock
Message-ID: <tip-2062501ae6505dbc5bff3a792246c2661d114050@git.kernel.org>
Git-Commit-ID: 2062501ae6505dbc5bff3a792246c2661d114050
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 11:07:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2062501ae6505dbc5bff3a792246c2661d114050
Gitweb:     http://git.kernel.org/tip/2062501ae6505dbc5bff3a792246c2661d114050
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 6 Apr 2009 01:49:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 12:50:56 +0200

tracing/lockdep: report the time waited for a lock

While trying to optimize the new lock on reiserfs to replace
the bkl, I find the lock tracing very useful though it lacks
something important for performance (and latency) instrumentation:
the time a task waits for a lock.

That's what this patch implements:

  bash-4816  [000]   202.652815: lock_contended: lock_contended: &sb->s_type->i_mutex_key
  bash-4816  [000]   202.652819: lock_acquired: &rq->lock (0.000 us)
 <...>-4787  [000]   202.652825: lock_acquired: &rq->lock (0.000 us)
 <...>-4787  [000]   202.652829: lock_acquired: &rq->lock (0.000 us)
  bash-4816  [000]   202.652833: lock_acquired: &sb->s_type->i_mutex_key (16.005 us)

As shown above, the "lock acquired" field is followed by the time
it has been waiting for the lock. Usually, a lock contended entry
is followed by a near lock_acquired entry with a non-zero time waited.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1238975373-15739-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/trace/lockdep_event_types.h |   23 ++++++++++++++++++-----
 kernel/lockdep.c                    |    8 ++++----
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/trace/lockdep_event_types.h b/include/trace/lockdep_event_types.h
index adccfcd..863f1e4 100644
--- a/include/trace/lockdep_event_types.h
+++ b/include/trace/lockdep_event_types.h
@@ -32,11 +32,24 @@ TRACE_FORMAT(lock_contended,
 	TP_FMT("%s", lock->name)
 	);
 
-TRACE_FORMAT(lock_acquired,
-	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
-	TP_ARGS(lock, ip),
-	TP_FMT("%s", lock->name)
-	);
+TRACE_EVENT(lock_acquired,
+	TP_PROTO(struct lockdep_map *lock, unsigned long ip, s64 waittime),
+
+	TP_ARGS(lock, ip, waittime),
+
+	TP_STRUCT__entry(
+		__field(const char *, name)
+		__field(unsigned long, wait_usec)
+		__field(unsigned long, wait_nsec_rem)
+	),
+	TP_fast_assign(
+		__entry->name = lock->name;
+		__entry->wait_nsec_rem = do_div(waittime, NSEC_PER_USEC);
+		__entry->wait_usec = (unsigned long) waittime;
+	),
+	TP_printk("%s (%lu.%03lu us)", __entry->name, __entry->wait_usec,
+				       __entry->wait_nsec_rem)
+);
 
 #endif
 #endif
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index b0f0118..c4582a6 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3061,6 +3061,8 @@ found_it:
 	put_lock_stats(stats);
 }
 
+DEFINE_TRACE(lock_acquired);
+
 static void
 __lock_acquired(struct lockdep_map *lock, unsigned long ip)
 {
@@ -3099,6 +3101,8 @@ found_it:
 		hlock->holdtime_stamp = now;
 	}
 
+	trace_lock_acquired(lock, ip, waittime);
+
 	stats = get_lock_stats(hlock_class(hlock));
 	if (waittime) {
 		if (hlock->read)
@@ -3137,14 +3141,10 @@ void lock_contended(struct lockdep_map *lock, unsigned long ip)
 }
 EXPORT_SYMBOL_GPL(lock_contended);
 
-DEFINE_TRACE(lock_acquired);
-
 void lock_acquired(struct lockdep_map *lock, unsigned long ip)
 {
 	unsigned long flags;
 
-	trace_lock_acquired(lock, ip);
-
 	if (unlikely(!lock_stat))
 		return;
 
