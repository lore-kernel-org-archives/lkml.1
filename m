Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab0BCJOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 04:14:50 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:38151 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab0BCJOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 04:14:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RDyNCTL2EmvSI48JZwpH9kChJz7xs9YefkdM6GyrBdyEN9A5WpXfjAOft2xQRLNgTY
         a7ZeB+q4EIETx81NXvK71vse0PRYUv3TjKi2Dmv0lrZVLtbuCDyb3v2PNqzcFuRDjdDF
         IA62BTwzMSjEd+L7O3Ix7M+rCtD5y9gcms4po=
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
Subject: [PATCH 03/11] tracing: Inject lock_class_init events on registration
Date: Wed,  3 Feb 2010 10:14:27 +0100
Message-Id: <1265188475-23509-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a user enables the lock_class_init event, automatically
inject the existing mapping of lock_class_id:name that
lockdep have stored.

This will help the user to retrieve the name of the lock
classes from the other lock events, once we'll remove
the name inside.

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
 include/linux/lockdep.h     |    4 ++++
 include/trace/events/lock.h |   11 +++++++++--
 kernel/lockdep.c            |   12 ++++++++++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 9ccf0e2..0b662fc 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -323,6 +323,10 @@ extern void lockdep_trace_alloc(gfp_t mask);
 
 #define lockdep_assert_held(l)	WARN_ON(debug_locks && !lockdep_is_held(l))
 
+#ifdef CONFIG_EVENT_TRACING
+extern void lock_class_init_inject_events(void);
+#endif
+
 #else /* !LOCKDEP */
 
 static inline void lockdep_off(void)
diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
index 90af03c..6999f16 100644
--- a/include/trace/events/lock.h
+++ b/include/trace/events/lock.h
@@ -9,7 +9,7 @@
 
 #ifdef CONFIG_LOCKDEP
 
-TRACE_EVENT(lock_class_init,
+TRACE_EVENT_INJECT(lock_class_init,
 
 	TP_PROTO(struct lock_class *class),
 
@@ -30,7 +30,14 @@ TRACE_EVENT(lock_class_init,
 		__entry->class_id = (void *)class->name;
 	),
 
-	TP_printk("%p %s", __entry->class_id, __get_str(class_name))
+	TP_printk("%p %s", __entry->class_id, __get_str(class_name)),
+
+	/*
+	 * On activation, we want to send an event for each lock
+	 * classes that have been recorded by lockdep, so that we
+	 * catch up with the existing class:name mappings.
+	 */
+	lock_class_init_inject_events
 );
 
 TRACE_EVENT(lock_acquire,
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 43758dd..4d9eef8 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3813,3 +3813,15 @@ void lockdep_sys_exit(void)
 		lockdep_print_held_locks(curr);
 	}
 }
+
+
+#ifdef CONFIG_EVENT_TRACING
+void lock_class_init_inject_events(void)
+{
+	struct lock_class *class;
+
+	/* Safe to be taken locklessly as it only moves forward */
+	list_for_each_entry(class, &all_lock_classes, lock_entry)
+		trace_lock_class_init(class);
+}
+#endif
-- 
1.6.2.3

