Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546Ab0A3Low@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab0A3Low (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 06:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315Ab0A3LoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 06:44:18 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52279 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab0A3Lnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 06:43:43 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH v2 10/11] perf lock: Enhance information of lock trace events
Date: Sat, 30 Jan 2010 20:43:32 +0900
Message-Id: <1264851813-8413-11-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1264851813-8413-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1264851813-8413-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now lock trace events have address and __FILE__ and __LINE__ of their lockdep_map.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/trace/events/lock.h |   49 ++++++++++++++++++++++++++++++++++--------
 1 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
index a870ba1..3eef226 100644
--- a/include/trace/events/lock.h
+++ b/include/trace/events/lock.h
@@ -20,16 +20,23 @@ TRACE_EVENT(lock_acquire,
 	TP_STRUCT__entry(
 		__field(unsigned int, flags)
 		__string(name, lock->name)
+		__field(void *, lockdep_addr)
+		__string(file, lock->file)
+		__field(unsigned int, line)
 	),
 
 	TP_fast_assign(
 		__entry->flags = (trylock ? 1 : 0) | (read ? 2 : 0);
 		__assign_str(name, lock->name);
+		__entry->lockdep_addr = lock;
+		__assign_str(file, lock->file);
+		__entry->line = lock->line;
 	),
 
-	TP_printk("%s%s%s", (__entry->flags & 1) ? "try " : "",
+	TP_printk("%p %s%s%s %s:%u", __entry->lockdep_addr,
+		  (__entry->flags & 1) ? "try " : "",
 		  (__entry->flags & 2) ? "read " : "",
-		  __get_str(name))
+		  __get_str(name), __get_str(file), __entry->line)
 );
 
 TRACE_EVENT(lock_release,
@@ -40,13 +47,21 @@ TRACE_EVENT(lock_release,
 
 	TP_STRUCT__entry(
 		__string(name, lock->name)
+		__field(void *, lockdep_addr)
+		__string(file, lock->file)
+		__field(unsigned int, line)
 	),
 
 	TP_fast_assign(
 		__assign_str(name, lock->name);
+		__entry->lockdep_addr = lock;
+		__assign_str(file, lock->file);
+		__entry->line = lock->line;
 	),
 
-	TP_printk("%s", __get_str(name))
+	TP_printk("%p %s %s:%u",
+		  __entry->lockdep_addr, __get_str(name),
+		  __get_str(file), __entry->line)
 );
 
 #ifdef CONFIG_LOCK_STAT
@@ -59,13 +74,21 @@ TRACE_EVENT(lock_contended,
 
 	TP_STRUCT__entry(
 		__string(name, lock->name)
+		__field(void *, lockdep_addr)
+		__string(file, lock->file)
+		__field(unsigned int, line)
 	),
 
 	TP_fast_assign(
 		__assign_str(name, lock->name);
+		__entry->lockdep_addr = lock;
+		__assign_str(file, lock->file);
+		__entry->line = lock->line;
 	),
 
-	TP_printk("%s", __get_str(name))
+	TP_printk("%p %s %s:%u",
+		  __entry->lockdep_addr, __get_str(name),
+		  __get_str(file), __entry->line)
 );
 
 TRACE_EVENT(lock_acquired,
@@ -75,16 +98,22 @@ TRACE_EVENT(lock_acquired,
 
 	TP_STRUCT__entry(
 		__string(name, lock->name)
-		__field(unsigned long, wait_usec)
-		__field(unsigned long, wait_nsec_rem)
+		__field(s64, wait_nsec)
+		__field(void *, lockdep_addr)
+		__string(file, lock->file)
+		__field(unsigned int, line)
 	),
+
 	TP_fast_assign(
 		__assign_str(name, lock->name);
-		__entry->wait_nsec_rem = do_div(waittime, NSEC_PER_USEC);
-		__entry->wait_usec = (unsigned long) waittime;
+		__entry->wait_nsec = waittime;
+		__entry->lockdep_addr = lock;
+		__assign_str(file, lock->file);
+		__entry->line = lock->line;
 	),
-	TP_printk("%s (%lu.%03lu us)", __get_str(name), __entry->wait_usec,
-				       __entry->wait_nsec_rem)
+	TP_printk("%p %s %s:%u (%llu ns)", __entry->lockdep_addr,
+		  __get_str(name), __get_str(file), __entry->line,
+		  __entry->wait_nsec)
 );
 
 #endif
-- 
1.6.5.2

