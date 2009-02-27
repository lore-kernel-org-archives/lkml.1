Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbZB0JDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbZB0JDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 04:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbZB0JBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 04:01:33 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:56027 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbZB0JBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 04:01:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=sA+p0uYyPme697BWvW3EiInh5CRi9JJxPd17G2FipdHXm1Sny4MO5+YO7LLw8gYkWw
         50GvOjfvK6aJyBxfUhvqa9tIro+vx7f+OufaouYRd9aAGDjZB+feF0WSETAXbLIsBMbb
         ZzdOCuo3/jzSNc8nHMTHIf2cexvbN10O1qCXo=
Subject: [PATCH 4/4] zedtrace: use workqueue tracepoints
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 03:01:09 -0600
Message-Id: <1235725269.8512.90.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the workqueue tracepoints.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

---
 kernel/trace/trace_binary/Makefile        |    3 +-
 kernel/trace/trace_binary/zed.c           |    7 ++
 kernel/trace/trace_binary/zed.h           |    5 ++
 kernel/trace/trace_binary/zed_workqueue.c |   97 +++++++++++++++++++++++++++++
 kernel/trace/trace_binary/zed_workqueue.h |   43 +++++++++++++
 5 files changed, 154 insertions(+), 1 deletions(-)
 create mode 100644 kernel/trace/trace_binary/zed_workqueue.c
 create mode 100644 kernel/trace/trace_binary/zed_workqueue.h

diff --git a/kernel/trace/trace_binary/Makefile b/kernel/trace/trace_binary/Makefile
index 89fceba..146528e 100644
--- a/kernel/trace/trace_binary/Makefile
+++ b/kernel/trace/trace_binary/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_ZEDTRACE) += zedtrace.o
 
-zedtrace-objs := zed.o zed_filter.o zed_sched.o zed_block.o
+zedtrace-objs := zed.o zed_filter.o zed_sched.o zed_block.o zed_workqueue.o
+
diff --git a/kernel/trace/trace_binary/zed.c b/kernel/trace/trace_binary/zed.c
index 5fb61dc..54a3d70 100644
--- a/kernel/trace/trace_binary/zed.c
+++ b/kernel/trace/trace_binary/zed.c
@@ -25,6 +25,7 @@
 #include <linux/debugfs.h>
 #include <trace/sched.h>
 #include <trace/block.h>
+#include <trace/workqueue.h>
 #include "zed.h"
 #include "zed_filter.h"
 
@@ -992,6 +993,10 @@ static int zed_enable_tracepoints(void)
 		printk(KERN_ERR "Couldn't register block tracepoints.\n");
 		goto fail;
 	}
+	if (zed_enable_workqueue_tracepoints()) {
+		printk(KERN_ERR "Couldn't register workqueue tracepoints.\n");
+		goto fail;
+	}
 	return 0;
 fail:
 	return -1;
@@ -1001,12 +1006,14 @@ static void zed_disable_tracepoints(void)
 {
 	zed_disable_sched_tracepoints();
 	zed_disable_block_tracepoints();
+	zed_disable_workqueue_tracepoints();
 }
 
 static void zed_init_subsystems(void)
 {
 	zed_sched_init();
 	zed_block_init();
+	zed_workqueue_init();
 }
 
 /**
diff --git a/kernel/trace/trace_binary/zed.h b/kernel/trace/trace_binary/zed.h
index 7f86f3b..d6d9746 100644
--- a/kernel/trace/trace_binary/zed.h
+++ b/kernel/trace/trace_binary/zed.h
@@ -73,9 +73,14 @@
 	EVENT(block, unplug_timer_trace) sep \
 	EVENT(block, split_trace) sep \
 	EVENT(block, remap_trace) sep \
+	EVENT(workqueue, insertion_trace) sep \
+	EVENT(workqueue, execution_trace) sep \
+	EVENT(workqueue, creation_trace) sep \
+	EVENT(workqueue, destruction_trace) sep \
 
 #include "zed_sched.h"
 #include "zed_block.h"
+#include "zed_workqueue.h"
 
 /* magic or'ed with version, last byte of magic should be 00 */
 #define ZED_TRACE_MAGIC		0x26F82100
diff --git a/kernel/trace/trace_binary/zed_workqueue.c b/kernel/trace/trace_binary/zed_workqueue.c
new file mode 100644
index 0000000..b1bdb43
--- /dev/null
+++ b/kernel/trace/trace_binary/zed_workqueue.c
@@ -0,0 +1,97 @@
+/*
+ * zedtrace "workqueue" subsys event definitions
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) 2008-2009 Tom Zanussi <tzanussi@gmail.com>
+ */
+
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/jhash.h>
+#include <linux/vmalloc.h>
+#include <linux/debugfs.h>
+#include <trace/workqueue.h>
+#include "zed.h"
+
+EVENTS(EXTERN_TRACE_FLAG, SEMICOLON);
+
+ZED_TRACEPOINT_ENTER(workqueue_insertion,
+		     TPPROTO(struct task_struct *wq_thread,
+			     struct work_struct *work))
+{
+	zed_event->pid = wq_thread->pid;
+}
+ZED_TRACEPOINT_EXIT(workqueue_insertion)
+
+ZED_TRACEPOINT_ENTER(workqueue_execution,
+		     TPPROTO(struct task_struct *wq_thread,
+			     struct work_struct *work))
+{
+	zed_event->pid = wq_thread->pid;
+}
+ZED_TRACEPOINT_EXIT(workqueue_execution)
+
+ZED_TRACEPOINT_ENTER(workqueue_creation,
+		     TPPROTO(struct task_struct *wq_thread, int cpu))
+{
+	zed_event->pid = wq_thread->pid;
+	zed_event->wq_cpu = cpu;
+}
+ZED_TRACEPOINT_EXIT(workqueue_creation)
+
+ZED_TRACEPOINT_ENTER(workqueue_destruction,
+		     TPPROTO(struct task_struct *wq_thread))
+{
+	zed_event->pid = wq_thread->pid;
+}
+ZED_TRACEPOINT_EXIT(workqueue_destruction)
+
+int zed_enable_workqueue_tracepoints(void)
+{
+	if (register_trace_workqueue_insertion(workqueue_insertion_tracepoint)) {
+		printk(KERN_ERR "Couldn't register workqueue_insertion tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_workqueue_execution(workqueue_execution_tracepoint)) {
+		printk(KERN_ERR "Couldn't register workqueue_execution tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_workqueue_creation(workqueue_creation_tracepoint)) {
+		printk(KERN_ERR "Couldn't register workqueue_creation tracepoint.\n");
+		goto fail;
+	}
+	if (register_trace_workqueue_destruction(workqueue_destruction_tracepoint)) {
+		printk(KERN_ERR "Couldn't register workqueue_destruction tracepoint.\n");
+		goto fail;
+	}
+
+	return 0;
+fail:
+	return -1;
+}
+
+void zed_disable_workqueue_tracepoints(void)
+{
+	unregister_trace_workqueue_insertion(workqueue_insertion_tracepoint);
+	unregister_trace_workqueue_execution(workqueue_execution_tracepoint);
+	unregister_trace_workqueue_creation(workqueue_creation_tracepoint);
+	unregister_trace_workqueue_destruction(workqueue_destruction_tracepoint);
+}
+
+void zed_workqueue_init(void)
+{
+}
+
diff --git a/kernel/trace/trace_binary/zed_workqueue.h b/kernel/trace/trace_binary/zed_workqueue.h
new file mode 100644
index 0000000..ea0dabf
--- /dev/null
+++ b/kernel/trace/trace_binary/zed_workqueue.h
@@ -0,0 +1,43 @@
+/*
+ * zedtrace "workqueue" subsys event declarations
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) 2008-2009 Tom Zanussi <tzanussi@gmail.com>
+ */
+
+/* convention: name[0] of u8 = var data, name[0] of char = string */
+
+#ifndef _ZED_WORKQUEUE_H
+#define _ZED_WORKQUEUE_H
+
+#define workqueue_insertion_trace_fields(subsys, event_name, FIELD) \
+	FIELD(subsys, event_name, pid, pid_t)			\
+
+#define workqueue_execution_trace_fields(subsys, event_name, FIELD) \
+	FIELD(subsys, event_name, pid, pid_t)			\
+
+#define workqueue_creation_trace_fields(subsys, event_name, FIELD) \
+	FIELD(subsys, event_name, pid, pid_t)			\
+	FIELD(subsys, event_name, wq_cpu, int)			\
+
+#define workqueue_destruction_trace_fields(subsys, event_name, FIELD) \
+	FIELD(subsys, event_name, pid, pid_t)			\
+
+extern void zed_workqueue_init(void);
+extern int zed_enable_workqueue_tracepoints(void);
+extern void zed_disable_workqueue_tracepoints(void);
+
+#endif /* _ZED_WORKQUEUE_H */
-- 
1.5.6.3



