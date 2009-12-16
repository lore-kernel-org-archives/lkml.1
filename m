Return-Path: <linux-kernel-owner+w=401wt.eu-S934786AbZLPIUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934786AbZLPIUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761803AbZLPITw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:19:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:60265 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761798AbZLPITr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:19:47 -0500
Date: Wed, 16 Dec 2009 08:19:08 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1260934105-4472-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1260934105-4472-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/lock] perf lock: Fix output of tracing lock events
Message-ID: <tip-e87379ce0da06a63dc5bf7f1a9ed5c38b56e9726@git.kernel.org>
Git-Commit-ID: e87379ce0da06a63dc5bf7f1a9ed5c38b56e9726
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e87379ce0da06a63dc5bf7f1a9ed5c38b56e9726
Gitweb:     http://git.kernel.org/tip/e87379ce0da06a63dc5bf7f1a9ed5c38b56e9726
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Wed, 16 Dec 2009 12:28:25 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Dec 2009 08:48:58 +0100

perf lock: Fix output of tracing lock events

This patch adds address of lockdep_map to each lock events.
perf lock uses these addresses as IDs of lock instances.

And this removes waittime from output of lock_acquired event.
The value will be caliculated in userspace based on timestamp.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1260934105-4472-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
