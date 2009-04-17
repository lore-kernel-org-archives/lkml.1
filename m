Return-Path: <linux-kernel-owner+w=401wt.eu-S1759885AbZDQQFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885AbZDQQFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757188AbZDQQFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:05:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:42765 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756631AbZDQQFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:05:04 -0400
Date: Fri, 17 Apr 2009 16:03:33 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1239954049.23397.4156.camel@laptop>
References: <1239954049.23397.4156.camel@laptop>
Subject: [tip:core/urgent] lockdep: more robust lockdep_map init sequence
Message-ID: <tip-c8a250058656495be02c00de61e26b017c86ef00@git.kernel.org>
Git-Commit-ID: c8a250058656495be02c00de61e26b017c86ef00
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Apr 2009 16:03:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c8a250058656495be02c00de61e26b017c86ef00
Gitweb:     http://git.kernel.org/tip/c8a250058656495be02c00de61e26b017c86ef00
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 17 Apr 2009 09:40:49 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Apr 2009 18:00:00 +0200

lockdep: more robust lockdep_map init sequence

Steven Rostedt reported:

> OK, I think I figured this bug out. This is a lockdep issue with respect
> to tracepoints.
>
> The trace points in lockdep are called all the time. Outside the lockdep
> logic. But if lockdep were to trigger an error / warning (which this run
> did) we might be in trouble. For new locks, like the dentry->d_lock, that
> are created, they will not get a name:
>
> void lockdep_init_map(struct lockdep_map *lock, const char *name,
>                       struct lock_class_key *key, int subclass)
> {
>         if (unlikely(!debug_locks))
>                 return;
>
> When a problem is found by lockdep, debug_locks becomes false. Thus we
> stop allocating names for locks. This dentry->d_lock I had, now has no
> name. Worse yet, I have CONFIG_DEBUG_VM set, that scrambles non
> initialized memory. Thus, when the trace point was hit, it had junk for
> the lock->name, and the machine crashed.

Ah, nice catch. I think we should put at least the name in regardless.

Ensure we at least initialize the trivial entries of the depmap so that
they can be relied upon, even when lockdep itself decided to pack up and
go home.

[ Impact: fix lock tracing after lockdep warnings. ]

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1239954049.23397.4156.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index b0f0118..accb40c 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2490,13 +2490,20 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 void lockdep_init_map(struct lockdep_map *lock, const char *name,
 		      struct lock_class_key *key, int subclass)
 {
-	if (unlikely(!debug_locks))
+	lock->class_cache = NULL;
+#ifdef CONFIG_LOCK_STAT
+	lock->cpu = raw_smp_processor_id();
+#endif
+
+	if (DEBUG_LOCKS_WARN_ON(!name)) {
+		lock->name = "NULL";
 		return;
+	}
+
+	lock->name = name;
 
 	if (DEBUG_LOCKS_WARN_ON(!key))
 		return;
-	if (DEBUG_LOCKS_WARN_ON(!name))
-		return;
 	/*
 	 * Sanity check, the lock-class key must be persistent:
 	 */
@@ -2505,12 +2512,11 @@ void lockdep_init_map(struct lockdep_map *lock, const char *name,
 		DEBUG_LOCKS_WARN_ON(1);
 		return;
 	}
-	lock->name = name;
 	lock->key = key;
-	lock->class_cache = NULL;
-#ifdef CONFIG_LOCK_STAT
-	lock->cpu = raw_smp_processor_id();
-#endif
+
+	if (unlikely(!debug_locks))
+		return;
+
 	if (subclass)
 		register_lock_class(lock, subclass, 1);
 }
