Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab0BCJPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 04:15:00 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:47625 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab0BCJOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 04:14:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ddygrAFYm5gnNcdnJLs/pQlSiHlStRJwBt1LvMkRefujtzWl9hb9n7eAxBWCiWgtjn
         26PXM6bumIUlIKLipZR+oLnZbyfEcjAm2MaCIAk4WilKtcnJ2oCf3iLbLahrdPIh3MM2
         ZHzE7kAFfB710Uh8DkzfUYRj20+1l6/zqmUq8=
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
Subject: [PATCH 09/11] tracing: Remove the lock name from most lock events
Date: Wed,  3 Feb 2010 10:14:33 +0100
Message-Id: <1265188475-23509-10-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the lock name copy from every lock events but
lock_class_init. We don't need it anymore now that we can
resolve the name from the lock class id.

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
 include/trace/events/lock.h |   23 +++++------------------
 1 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
index 3c4a5c1..ced4ceb 100644
--- a/include/trace/events/lock.h
+++ b/include/trace/events/lock.h
@@ -50,23 +50,20 @@ TRACE_EVENT(lock_acquire,
 
 	TP_STRUCT__entry(
 		__field(unsigned int, flags)
-		__string(name, lock->name)
 		__field(void *, lockdep_addr)
 		__field(void *, class_id)
 	),
 
 	TP_fast_assign(
 		__entry->flags = (trylock ? 1 : 0) | (read ? 2 : 0);
-		__assign_str(name, lock->name);
 		__entry->lockdep_addr = lock;
 		__entry->class_id = (void *)lock->name;
 	),
 
-	TP_printk("%p %p %s%s%s", __entry->lockdep_addr,
+	TP_printk("%p %p %s%s", __entry->lockdep_addr,
 		  __entry->class_id,
 		  (__entry->flags & 1) ? "try " : "",
-		  (__entry->flags & 2) ? "read " : "",
-		  __get_str(name))
+		  (__entry->flags & 2) ? "read " : "")
 );
 
 TRACE_EVENT(lock_release,
@@ -76,17 +73,14 @@ TRACE_EVENT(lock_release,
 	TP_ARGS(lock, nested, ip),
 
 	TP_STRUCT__entry(
-		__string(name, lock->name)
 		__field(void *, lockdep_addr)
 	),
 
 	TP_fast_assign(
-		__assign_str(name, lock->name);
 		__entry->lockdep_addr = lock;
 	),
 
-	TP_printk("%p %s",
-		  __entry->lockdep_addr, __get_str(name))
+	TP_printk("%p", __entry->lockdep_addr)
 );
 
 #ifdef CONFIG_LOCK_STAT
@@ -98,17 +92,14 @@ TRACE_EVENT(lock_contended,
 	TP_ARGS(lock, ip),
 
 	TP_STRUCT__entry(
-		__string(name, lock->name)
 		__field(void *, lockdep_addr)
 	),
 
 	TP_fast_assign(
-		__assign_str(name, lock->name);
 		__entry->lockdep_addr = lock;
 	),
 
-	TP_printk("%p %s",
-		  __entry->lockdep_addr, __get_str(name))
+	TP_printk("%p", __entry->lockdep_addr)
 );
 
 TRACE_EVENT(lock_acquired,
@@ -117,19 +108,15 @@ TRACE_EVENT(lock_acquired,
 	TP_ARGS(lock, ip, waittime),
 
 	TP_STRUCT__entry(
-		__string(name, lock->name)
 		__field(s64, wait_nsec)
 		__field(void *, lockdep_addr)
 	),
 
 	TP_fast_assign(
-		__assign_str(name, lock->name);
 		__entry->wait_nsec = waittime;
 		__entry->lockdep_addr = lock;
 	),
-	TP_printk("%p %s (%llu ns)", __entry->lockdep_addr,
-		  __get_str(name),
-		  __entry->wait_nsec)
+	TP_printk("%p (%llu ns)", __entry->lockdep_addr, __entry->wait_nsec)
 );
 
 #endif
-- 
1.6.2.3

