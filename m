Return-Path: <linux-kernel-owner+w=401wt.eu-S934533AbZLPD2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934533AbZLPD2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 22:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934481AbZLPD2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 22:28:47 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:56720 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760404AbZLPD2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 22:28:38 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] perf lock: Fix output of tracing lock events
Date: Wed, 16 Dec 2009 12:28:25 +0900
Message-Id: <1260934105-4472-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1260934105-4472-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1260934105-4472-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds address of lockdep_map to each lock events.
perf lock uses these addresses as IDs of lock instances.

And this removes waittime from output of lock_acquired event.
The value will be caliculated in userspace based on timestamp.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/trace/events/lock.h |   27 ++++++++++++++++++---------
 kernel/lockdep.c            |    2 +-
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
index a870ba1..2f94e25 100644
--- a/include/trace/events/lock.h
+++ b/include/trace/events/lock.h
@@ -18,16 +18,19 @@ TRACE_EVENT(lock_acquire,
 	TP_ARGS(lock, subclass, trylock, read, check, next_lock, ip),
 
 	TP_STRUCT__entry(
+		__field(struct lockdep_map *, lockdep_addr)
 		__field(unsigned int, flags)
 		__string(name, lock->name)
 	),
 
 	TP_fast_assign(
+		__entry->lockdep_addr = lock;
 		__entry->flags = (trylock ? 1 : 0) | (read ? 2 : 0);
 		__assign_str(name, lock->name);
 	),
 
-	TP_printk("%s%s%s", (__entry->flags & 1) ? "try " : "",
+	TP_printk("%p %s%s%s", __entry->lockdep_addr,
+		  (__entry->flags & 1) ? "try " : "",
 		  (__entry->flags & 2) ? "read " : "",
 		  __get_str(name))
 );
@@ -39,14 +42,16 @@ TRACE_EVENT(lock_release,
 	TP_ARGS(lock, nested, ip),
 
 	TP_STRUCT__entry(
+		__field(struct lockdep_map *, lockdep_addr)
 		__string(name, lock->name)
 	),
 
 	TP_fast_assign(
+		__entry->lockdep_addr = lock;
 		__assign_str(name, lock->name);
 	),
 
-	TP_printk("%s", __get_str(name))
+	TP_printk("%p %s", __entry->lockdep_addr, __get_str(name))
 );
 
 #ifdef CONFIG_LOCK_STAT
@@ -58,33 +63,37 @@ TRACE_EVENT(lock_contended,
 	TP_ARGS(lock, ip),
 
 	TP_STRUCT__entry(
+		__field(struct lockdep_map *, lockdep_addr)
 		__string(name, lock->name)
 	),
 
 	TP_fast_assign(
+		__entry->lockdep_addr = lock;
 		__assign_str(name, lock->name);
 	),
 
-	TP_printk("%s", __get_str(name))
+	TP_printk("%p %s", __entry->lockdep_addr, __get_str(name))
 );
 
 TRACE_EVENT(lock_acquired,
-	TP_PROTO(struct lockdep_map *lock, unsigned long ip, s64 waittime),
+	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
 
-	TP_ARGS(lock, ip, waittime),
+	TP_ARGS(lock, ip),
 
 	TP_STRUCT__entry(
+		__field(struct lockdep_map *, lockdep_addr)
 		__string(name, lock->name)
 		__field(unsigned long, wait_usec)
 		__field(unsigned long, wait_nsec_rem)
 	),
+
 	TP_fast_assign(
+		__entry->lockdep_addr = lock;
 		__assign_str(name, lock->name);
-		__entry->wait_nsec_rem = do_div(waittime, NSEC_PER_USEC);
-		__entry->wait_usec = (unsigned long) waittime;
 	),
-	TP_printk("%s (%lu.%03lu us)", __get_str(name), __entry->wait_usec,
-				       __entry->wait_nsec_rem)
+
+	TP_printk("%p %s", __entry->lockdep_addr,
+		  __get_str(name))
 );
 
 #endif
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index f5dcd36..d6c30a9 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3383,7 +3383,7 @@ found_it:
 		hlock->holdtime_stamp = now;
 	}
 
-	trace_lock_acquired(lock, ip, waittime);
+	trace_lock_acquired(lock, ip);
 
 	stats = get_lock_stats(hlock_class(hlock));
 	if (waittime) {
-- 
1.6.5.2

