Return-Path: <linux-kernel-owner+w=401wt.eu-S933290AbZJIOYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290AbZJIOYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 10:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbZJIOYC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 10:24:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:42813 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112AbZJIOYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 10:24:00 -0400
Date: Fri, 9 Oct 2009 14:22:51 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1254818502.21044.112.camel@laptop>
References: <1254818502.21044.112.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] lockdep: Use cpu_clock() for lockstat
Message-ID: <tip-3365e7798760dc6c190a9bbb0945a38f02625438@git.kernel.org>
Git-Commit-ID: 3365e7798760dc6c190a9bbb0945a38f02625438
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 09 Oct 2009 14:22:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3365e7798760dc6c190a9bbb0945a38f02625438
Gitweb:     http://git.kernel.org/tip/3365e7798760dc6c190a9bbb0945a38f02625438
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 9 Oct 2009 10:12:41 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 9 Oct 2009 15:56:44 +0200

lockdep: Use cpu_clock() for lockstat

Some tracepoint magic (TRACE_EVENT(lock_acquired)) relies on
the fact that lock hold times are positive and uses div64 on
that. That triggered a build warning on MIPS, and probably
causes bad output in certain circumstances as well.

Make it truly positive.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1254818502.21044.112.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 3815ac1..9af5672 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -142,6 +142,11 @@ static inline struct lock_class *hlock_class(struct held_lock *hlock)
 #ifdef CONFIG_LOCK_STAT
 static DEFINE_PER_CPU(struct lock_class_stats[MAX_LOCKDEP_KEYS], lock_stats);
 
+static inline u64 lockstat_clock(void)
+{
+	return cpu_clock(smp_processor_id());
+}
+
 static int lock_point(unsigned long points[], unsigned long ip)
 {
 	int i;
@@ -158,7 +163,7 @@ static int lock_point(unsigned long points[], unsigned long ip)
 	return i;
 }
 
-static void lock_time_inc(struct lock_time *lt, s64 time)
+static void lock_time_inc(struct lock_time *lt, u64 time)
 {
 	if (time > lt->max)
 		lt->max = time;
@@ -234,12 +239,12 @@ static void put_lock_stats(struct lock_class_stats *stats)
 static void lock_release_holdtime(struct held_lock *hlock)
 {
 	struct lock_class_stats *stats;
-	s64 holdtime;
+	u64 holdtime;
 
 	if (!lock_stat)
 		return;
 
-	holdtime = sched_clock() - hlock->holdtime_stamp;
+	holdtime = lockstat_clock() - hlock->holdtime_stamp;
 
 	stats = get_lock_stats(hlock_class(hlock));
 	if (hlock->read)
@@ -2792,7 +2797,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	hlock->references = references;
 #ifdef CONFIG_LOCK_STAT
 	hlock->waittime_stamp = 0;
-	hlock->holdtime_stamp = sched_clock();
+	hlock->holdtime_stamp = lockstat_clock();
 #endif
 
 	if (check == 2 && !mark_irqflags(curr, hlock))
@@ -3322,7 +3327,7 @@ found_it:
 	if (hlock->instance != lock)
 		return;
 
-	hlock->waittime_stamp = sched_clock();
+	hlock->waittime_stamp = lockstat_clock();
 
 	contention_point = lock_point(hlock_class(hlock)->contention_point, ip);
 	contending_point = lock_point(hlock_class(hlock)->contending_point,
@@ -3345,8 +3350,7 @@ __lock_acquired(struct lockdep_map *lock, unsigned long ip)
 	struct held_lock *hlock, *prev_hlock;
 	struct lock_class_stats *stats;
 	unsigned int depth;
-	u64 now;
-	s64 waittime = 0;
+	u64 now, waittime = 0;
 	int i, cpu;
 
 	depth = curr->lockdep_depth;
@@ -3374,7 +3378,7 @@ found_it:
 
 	cpu = smp_processor_id();
 	if (hlock->waittime_stamp) {
-		now = sched_clock();
+		now = lockstat_clock();
 		waittime = now - hlock->waittime_stamp;
 		hlock->holdtime_stamp = now;
 	}
