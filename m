Return-Path: <linux-kernel-owner+w=401wt.eu-S1757826AbZDQHlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826AbZDQHlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 03:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZDQHlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 03:41:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46897 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbZDQHlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 03:41:09 -0400
Subject: Re: [PATCH 2/2] tracing/events/lockdep: move tracepoints within
 recursive protection
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <alpine.DEB.2.00.0904162319010.20429@gandalf.stny.rr.com>
References: <20090416161543.199331330@goodmis.org>
	 <20090416161746.831882528@goodmis.org> <1239900469.23397.3128.camel@laptop>
	 <alpine.DEB.2.00.0904161343110.20429@gandalf.stny.rr.com>
	 <1239904428.23397.3278.camel@laptop>
	 <alpine.DEB.2.00.0904162254270.20429@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.0904162319010.20429@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 09:40:49 +0200
Message-Id: <1239954049.23397.4156.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 23:24 -0400, Steven Rostedt wrote:

> > Either there's a bug in the vbin_printf, or we have some crazy lock->name?
> > 
> > TRACE_FORMAT(lock_acquire,
> >         TP_PROTO(struct lockdep_map *lock, unsigned int subclass,
> >                 int trylock, int read, int check,
> >                 struct lockdep_map *next_lock, unsigned long ip),
> >         TP_ARGS(lock, subclass, trylock, read, check, next_lock, ip),
> >         TP_FMT("%s%s%s", trylock ? "try " : "",
> >                 read ? "read " : "", lock->name)
> >         );
> > 
> > I'll continue to look into this, and perhaps reboot and see what other 
> > nasties I hit.
> 
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
Something like the below ought to do I guess:

---
Subject: lockdep: more robust lockdep_map init sequence

Ensure we at least initialize the trivial entries of the depmap so that
they can be relied upon, even when lockdep itself decided to pack up and
go home.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index c4582a6..4516e5b 100644
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


