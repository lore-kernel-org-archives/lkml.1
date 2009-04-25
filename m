Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbZDYE05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbZDYE05 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 00:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbZDYE0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 00:26:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37153 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbZDYE0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 00:26:31 -0400
Message-Id: <20090425042629.332398282@goodmis.org>
References: <20090425042030.431477667@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 25 Apr 2009 00:20:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 1/5] tracing/lockdep: convert lockdep to use TRACE_EVENT macro
Content-Disposition: inline; filename=0001-tracing-lockdep-convert-lockdep-to-use-TRACE_EVENT.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The TRACE_FORMAT will soon be deprecated. This patch converts it to
the TRACE_EVENT macro.

Note, this change should also speed up the tracing.

[ Impact: remove a user of deprecated TRACE_FORMAT ]

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/lockdep.h |   56 ++++++++++++++++++++++++++++++++-------
 1 files changed, 46 insertions(+), 10 deletions(-)

diff --git a/include/trace/events/lockdep.h b/include/trace/events/lockdep.h
index 3ca315c..0e956c9 100644
--- a/include/trace/events/lockdep.h
+++ b/include/trace/events/lockdep.h
@@ -9,28 +9,64 @@
 
 #ifdef CONFIG_LOCKDEP
 
-TRACE_FORMAT(lock_acquire,
+TRACE_EVENT(lock_acquire,
+
 	TP_PROTO(struct lockdep_map *lock, unsigned int subclass,
 		int trylock, int read, int check,
 		struct lockdep_map *next_lock, unsigned long ip),
+
 	TP_ARGS(lock, subclass, trylock, read, check, next_lock, ip),
-	TP_FMT("%s%s%s", trylock ? "try " : "",
-		read ? "read " : "", lock->name)
-	);
 
-TRACE_FORMAT(lock_release,
+	TP_STRUCT__entry(
+		__field(unsigned int, flags)
+		__string(name, lock->name)
+	),
+
+	TP_fast_assign(
+		__entry->flags = (trylock ? 1 : 0) | (read ? 2 : 0);
+		__assign_str(name, lock->name);
+	),
+
+	TP_printk("%s%s%s", (__entry->flags & 1) ? "try " : "",
+		  (__entry->flags & 2) ? "read " : "",
+		  __get_str(name))
+);
+
+TRACE_EVENT(lock_release,
+
 	TP_PROTO(struct lockdep_map *lock, int nested, unsigned long ip),
+
 	TP_ARGS(lock, nested, ip),
-	TP_FMT("%s", lock->name)
-	);
+
+	TP_STRUCT__entry(
+		__string(name, lock->name)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, lock->name);
+	),
+
+	TP_printk("%s", __get_str(name))
+);
 
 #ifdef CONFIG_LOCK_STAT
 
-TRACE_FORMAT(lock_contended,
+TRACE_EVENT(lock_contended,
+
 	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
+
 	TP_ARGS(lock, ip),
-	TP_FMT("%s", lock->name)
-	);
+
+	TP_STRUCT__entry(
+		__string(name, lock->name)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, lock->name);
+	),
+
+	TP_printk("%s", __get_str(name))
+);
 
 TRACE_EVENT(lock_acquired,
 	TP_PROTO(struct lockdep_map *lock, unsigned long ip, s64 waittime),
-- 
1.6.2.1

-- 
