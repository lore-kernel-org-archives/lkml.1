Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab0BCJOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 04:14:43 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:38151 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab0BCJOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 04:14:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=x1v+w5EKdGLtotuIQUPXl7QVTL61V2cVdIpd5mTaWzlxfV4OAiaLo3GC5P3e0sPW+b
         q2bgrqDoCs1QXqjbJmUSTZY4MtJIFungU/+unhG7GEWW8fJyS9h6wkwAKAAbpxSufodO
         e6Fzc+F7XtzRAYCO9GhJ9tm2oDdfYZ8mCwqTM=
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
Subject: [PATCH 01/11] tracing: Add lock_class_init event
Date: Wed,  3 Feb 2010 10:14:25 +0100
Message-Id: <1265188475-23509-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a lock_class_init event that brings informations about a
new lock class that gets created.

This event is required for the following plans:

- We want to get rid of the lock name copy from each high freq
  lock events.
- But we want to be able to retrieve it from post-processing
- We also want to be able to map the lock instances to their
  corresponding lock classes. Instrumenting the locks can
  make sense in both class and instance level, depending on
  the desired level of details.

This new event will make us able to map a lock class to its name.
It is also planned to drop the name from the other lock events
but to keep the lock instance id and to add the lock class id
to the lock_acquire event (which marks the beginning of a lock
scenario).

With such layout, we can basically retrieve the lock instance,
class and name from every locking sequence.

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
 include/trace/events/lock.h |   24 ++++++++++++++++++++++++
 kernel/lockdep.c            |    4 ++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
index 5c1dcfc..90af03c 100644
--- a/include/trace/events/lock.h
+++ b/include/trace/events/lock.h
@@ -9,6 +9,30 @@
 
 #ifdef CONFIG_LOCKDEP
 
+TRACE_EVENT(lock_class_init,
+
+	TP_PROTO(struct lock_class *class),
+
+	TP_ARGS(class),
+
+	TP_STRUCT__entry(
+		__string(class_name, class->name)
+		__field(void *, class_id)
+	),
+
+	/*
+	 * The pointer to the class name is shared between a lock instance
+	 * (lockdep_map) and its lock class. So we can use the name pointer
+	 * as a class id and as a link between an instance and its class.
+	 */
+	TP_fast_assign(
+		__assign_str(class_name, class->name);
+		__entry->class_id = (void *)class->name;
+	),
+
+	TP_printk("%p %s", __entry->class_id, __get_str(class_name))
+);
+
 TRACE_EVENT(lock_acquire,
 
 	TP_PROTO(struct lockdep_map *lock, unsigned int subclass,
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 5feaddc..43758dd 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -757,6 +757,7 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 		dump_stack();
 		return NULL;
 	}
+
 	class = lock_classes + nr_lock_classes++;
 	debug_atomic_inc(&nr_unused_locks);
 	class->key = key;
@@ -766,6 +767,9 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 	INIT_LIST_HEAD(&class->locks_before);
 	INIT_LIST_HEAD(&class->locks_after);
 	class->name_version = count_matching_names(class);
+
+	trace_lock_class_init(class);
+
 	/*
 	 * We use RCU's safe list-add method to make
 	 * parallel walking of the hash-list safe:
-- 
1.6.2.3

