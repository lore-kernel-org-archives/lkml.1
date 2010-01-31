Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175Ab0AaIc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab0AaIc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 03:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485Ab0AaIcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 03:32:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:51296 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937Ab0AaIcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 03:32:21 -0500
Date: Sun, 31 Jan 2010 08:31:43 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1264851813-8413-11-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1264851813-8413-11-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf lock: Enhance information of lock trace events
Message-ID: <tip-c965be10ca3cb0bdd04016c852764afaf8e647c8@git.kernel.org>
Git-Commit-ID: c965be10ca3cb0bdd04016c852764afaf8e647c8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 31 Jan 2010 08:31:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c965be10ca3cb0bdd04016c852764afaf8e647c8
Gitweb:     http://git.kernel.org/tip/c965be10ca3cb0bdd04016c852764afaf8e647c8
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Sat, 30 Jan 2010 20:43:32 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 31 Jan 2010 09:08:23 +0100

perf lock: Enhance information of lock trace events

Add wait time and lock identification details.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1264851813-8413-11-git-send-email-mitake@dcl.info.waseda.ac.jp>
[ removed the file/line bits as we can do that better via IPs ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/events/lock.h |   29 ++++++++++++++++++++---------
 1 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
index a870ba1..5c1dcfc 100644
--- a/include/trace/events/lock.h
+++ b/include/trace/events/lock.h
@@ -20,14 +20,17 @@ TRACE_EVENT(lock_acquire,
 	TP_STRUCT__entry(
 		__field(unsigned int, flags)
 		__string(name, lock->name)
+		__field(void *, lockdep_addr)
 	),
 
 	TP_fast_assign(
 		__entry->flags = (trylock ? 1 : 0) | (read ? 2 : 0);
 		__assign_str(name, lock->name);
+		__entry->lockdep_addr = lock;
 	),
 
-	TP_printk("%s%s%s", (__entry->flags & 1) ? "try " : "",
+	TP_printk("%p %s%s%s", __entry->lockdep_addr,
+		  (__entry->flags & 1) ? "try " : "",
 		  (__entry->flags & 2) ? "read " : "",
 		  __get_str(name))
 );
@@ -40,13 +43,16 @@ TRACE_EVENT(lock_release,
 
 	TP_STRUCT__entry(
 		__string(name, lock->name)
+		__field(void *, lockdep_addr)
 	),
 
 	TP_fast_assign(
 		__assign_str(name, lock->name);
+		__entry->lockdep_addr = lock;
 	),
 
-	TP_printk("%s", __get_str(name))
+	TP_printk("%p %s",
+		  __entry->lockdep_addr, __get_str(name))
 );
 
 #ifdef CONFIG_LOCK_STAT
@@ -59,13 +65,16 @@ TRACE_EVENT(lock_contended,
 
 	TP_STRUCT__entry(
 		__string(name, lock->name)
+		__field(void *, lockdep_addr)
 	),
 
 	TP_fast_assign(
 		__assign_str(name, lock->name);
+		__entry->lockdep_addr = lock;
 	),
 
-	TP_printk("%s", __get_str(name))
+	TP_printk("%p %s",
+		  __entry->lockdep_addr, __get_str(name))
 );
 
 TRACE_EVENT(lock_acquired,
@@ -75,16 +84,18 @@ TRACE_EVENT(lock_acquired,
 
 	TP_STRUCT__entry(
 		__string(name, lock->name)
-		__field(unsigned long, wait_usec)
-		__field(unsigned long, wait_nsec_rem)
+		__field(s64, wait_nsec)
+		__field(void *, lockdep_addr)
 	),
+
 	TP_fast_assign(
 		__assign_str(name, lock->name);
-		__entry->wait_nsec_rem = do_div(waittime, NSEC_PER_USEC);
-		__entry->wait_usec = (unsigned long) waittime;
+		__entry->wait_nsec = waittime;
+		__entry->lockdep_addr = lock;
 	),
-	TP_printk("%s (%lu.%03lu us)", __get_str(name), __entry->wait_usec,
-				       __entry->wait_nsec_rem)
+	TP_printk("%p %s (%llu ns)", __entry->lockdep_addr,
+		  __get_str(name),
+		  __entry->wait_nsec)
 );
 
 #endif
