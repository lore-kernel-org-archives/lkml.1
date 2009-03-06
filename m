Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbZCFDUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbZCFDUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 22:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbZCFDTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 22:19:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34609 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbZCFDTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 22:19:44 -0500
Message-Id: <20090306031942.065288566@goodmis.org>
References: <20090306031857.686507907@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 22:19:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/3] tracing: add format files for ftrace default entries
Content-Disposition: inline; filename=0003-tracing-add-format-files-for-ftrace-default-entries.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: allow user apps to read binary format of basic ftrace entries

Currently, only defined raw events export their formats so a binary
reader can parse them. There's no reason that the default ftrace entries
can't export their formats.

This patch adds a subsystem called "ftrace" in the events directory
that includes the ftrace entries for basic ftrace recorded items.

These only have three files in the events directory:

 type             : printf
 available_types  : printf
 format           : format for the event entry

For example:

 # cat /debug/tracing/events/ftrace/wakeup/format
name: wakeup
ID: 3
format:
        field:unsigned char type;       offset:0;       size:1;
        field:unsigned char flags;      offset:1;       size:1;
        field:unsigned char preempt_count;      offset:2;       size:1;
        field:int pid;  offset:4;       size:4;
        field:int tgid; offset:8;       size:4;

        field:unsigned int prev_pid;    offset:12;      size:4;
        field:unsigned char prev_prio;  offset:16;      size:1;
        field:unsigned char prev_state; offset:17;      size:1;
        field:unsigned int next_pid;    offset:20;      size:4;
        field:unsigned char next_prio;  offset:24;      size:1;
        field:unsigned char next_state; offset:25;      size:1;
        field:unsigned int next_cpu;    offset:28;      size:4;

print fmt: "%u:%u:%u  ==+ %u:%u:%u [%03u]"

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/Makefile            |    1 +
 kernel/trace/trace_event_types.h |  165 ++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_events.c      |   12 ++-
 kernel/trace/trace_export.c      |   81 +++++++++++++++++++
 kernel/trace/trace_format.h      |    2 +-
 5 files changed, 255 insertions(+), 6 deletions(-)
 create mode 100644 kernel/trace/trace_event_types.h
 create mode 100644 kernel/trace/trace_export.c

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index c931fe0..f44736c 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -41,5 +41,6 @@ obj-$(CONFIG_WORKQUEUE_TRACER) += trace_workqueue.o
 obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
 obj-$(CONFIG_EVENT_TRACER) += trace_events.o
 obj-$(CONFIG_EVENT_TRACER) += events.o
+obj-$(CONFIG_EVENT_TRACER) += trace_export.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
new file mode 100644
index 0000000..fb4eba1
--- /dev/null
+++ b/kernel/trace/trace_event_types.h
@@ -0,0 +1,165 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM	ftrace
+
+/*
+ * We cheat and use the proto type field as the ID
+ * and args as the entry type (minus 'struct')
+ */
+TRACE_EVENT_FORMAT(function, TRACE_FN, ftrace_entry, ignore,
+	TRACE_STRUCT(
+		TRACE_FIELD(unsigned long, ip, ip)
+		TRACE_FIELD(unsigned long, parent_ip, parent_ip)
+	),
+	TPRAWFMT(" %lx <-- %lx")
+);
+
+TRACE_EVENT_FORMAT(funcgraph_entry, TRACE_GRAPH_ENT,
+		   ftrace_graph_ent_entry, ignore,
+	TRACE_STRUCT(
+		TRACE_FIELD(unsigned long, graph_ent.func, func)
+		TRACE_FIELD(int, graph_ent.depth, depth)
+	),
+	TPRAWFMT("--> %lx (%d)")
+);
+
+TRACE_EVENT_FORMAT(funcgraph_exit, TRACE_GRAPH_RET,
+		   ftrace_graph_ret_entry, ignore,
+	TRACE_STRUCT(
+		TRACE_FIELD(unsigned long, ret.func, func)
+		TRACE_FIELD(int, ret.depth, depth)
+	),
+	TPRAWFMT("<-- %lx (%d)")
+);
+
+TRACE_EVENT_FORMAT(wakeup, TRACE_WAKE, ctx_switch_entry, ignore,
+	TRACE_STRUCT(
+		TRACE_FIELD(unsigned int, prev_pid, prev_pid)
+		TRACE_FIELD(unsigned char, prev_prio, prev_prio)
+		TRACE_FIELD(unsigned char, prev_state, prev_state)
+		TRACE_FIELD(unsigned int, next_pid, next_pid)
+		TRACE_FIELD(unsigned char, next_prio, next_prio)
+		TRACE_FIELD(unsigned char, next_state, next_state)
+		TRACE_FIELD(unsigned int, next_cpu, next_cpu)
+	),
+	TPRAWFMT("%u:%u:%u  ==+ %u:%u:%u [%03u]")
+);
+
+TRACE_EVENT_FORMAT(context_switch, TRACE_CTX, ctx_switch_entry, ignore,
+	TRACE_STRUCT(
+		TRACE_FIELD(unsigned int, prev_pid, prev_pid)
+		TRACE_FIELD(unsigned char, prev_prio, prev_prio)
+		TRACE_FIELD(unsigned char, prev_state, prev_state)
+		TRACE_FIELD(unsigned int, next_pid, next_pid)
+		TRACE_FIELD(unsigned char, next_prio, next_prio)
+		TRACE_FIELD(unsigned char, next_state, next_state)
+		TRACE_FIELD(unsigned int, next_cpu, next_cpu)
+	),
+	TPRAWFMT("%u:%u:%u  ==+ %u:%u:%u [%03u]")
+);
+
+TRACE_EVENT_FORMAT(special, TRACE_SPECIAL, special_entry, ignore,
+	TRACE_STRUCT(
+		TRACE_FIELD(unsigned long, arg1, arg1)
+		TRACE_FIELD(unsigned long, arg2, arg2)
+		TRACE_FIELD(unsigned long, arg3, arg3)
+	),
+	TPRAWFMT("(%08lx) (%08lx) (%08lx)")
+);
+
+/*
+ * Stack-trace entry:
+ */
+
+/* #define FTRACE_STACK_ENTRIES   8 */
+
+TRACE_EVENT_FORMAT(kernel_stack, TRACE_STACK, stack_entry, ignore,
+	TRACE_STRUCT(
+		TRACE_FIELD(unsigned long, caller[0], stack0)
+		TRACE_FIELD(unsigned long, caller[1], stack1)
+		TRACE_FIELD(unsigned long, caller[2], stack2)
+		TRACE_FIELD(unsigned long, caller[3], stack3)
+		TRACE_FIELD(unsigned long, caller[4], stack4)
+		TRACE_FIELD(unsigned long, caller[5], stack5)
+		TRACE_FIELD(unsigned long, caller[6], stack6)
+		TRACE_FIELD(unsigned long, caller[7], stack7)
+	),
+	TPRAWFMT("\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n"
+		 "\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n")
+);
+
+TRACE_EVENT_FORMAT(user_stack, TRACE_USER_STACK, userstack_entry, ignore,
+	TRACE_STRUCT(
+		TRACE_FIELD(unsigned long, caller[0], stack0)
+		TRACE_FIELD(unsigned long, caller[1], stack1)
+		TRACE_FIELD(unsigned long, caller[2], stack2)
+		TRACE_FIELD(unsigned long, caller[3], stack3)
+		TRACE_FIELD(unsigned long, caller[4], stack4)
+		TRACE_FIELD(unsigned long, caller[5], stack5)
+		TRACE_FIELD(unsigned long, caller[6], stack6)
+		TRACE_FIELD(unsigned long, caller[7], stack7)
+	),
+	TPRAWFMT("\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n"
+		 "\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n")
+);
+
+TRACE_EVENT_FORMAT(print, TRACE_PRINT, print_entry, ignore,
+	TRACE_STRUCT(
+		TRACE_FIELD(unsigned long, ip, ip)
+		TRACE_FIELD(unsigned int, depth, depth)
+		TRACE_FIELD_ZERO_CHAR(buf)
+	),
+	TPRAWFMT("%08lx (%d) %s")
+);
+
+TRACE_EVENT_FORMAT(branch, TRACE_BRANCH, trace_branch, ignore,
+	TRACE_STRUCT(
+		TRACE_FIELD(unsigned int, line, line)
+		TRACE_FIELD_SPECIAL(char func[TRACE_FUNC_SIZE+1], func, func)
+		TRACE_FIELD_SPECIAL(char file[TRACE_FUNC_SIZE+1], file, file)
+		TRACE_FIELD(char, correct, correct)
+	),
+	TPRAWFMT("%u:%s:%s (%u)")
+);
+
+TRACE_EVENT_FORMAT(hw_branch, TRACE_HW_BRANCHES, hw_branch_entry, ignore,
+	TRACE_STRUCT(
+		TRACE_FIELD(u64, from, from)
+		TRACE_FIELD(u64, to, to)
+	),
+	TPRAWFMT("from: %llx to: %llx")
+);
+
+TRACE_EVENT_FORMAT(power, TRACE_POWER, trace_power, ignore,
+	TRACE_STRUCT(
+		TRACE_FIELD(ktime_t, state_data.stamp, stamp)
+		TRACE_FIELD(ktime_t, state_data.end, end)
+		TRACE_FIELD(int, state_data.type, type)
+		TRACE_FIELD(int, state_data.state, state)
+	),
+	TPRAWFMT("%llx->%llx type:%u state:%u")
+);
+
+TRACE_EVENT_FORMAT(kmem_alloc, TRACE_KMEM_ALLOC, kmemtrace_alloc_entry, ignore,
+	TRACE_STRUCT(
+		TRACE_FIELD(enum kmemtrace_type_id, type_id, type_id)
+		TRACE_FIELD(unsigned long, call_site, call_site)
+		TRACE_FIELD(const void *, ptr, ptr)
+		TRACE_FIELD(size_t, bytes_req, bytes_req)
+		TRACE_FIELD(size_t, bytes_alloc, bytes_alloc)
+		TRACE_FIELD(gfp_t, gfp_flags, gfp_flags)
+		TRACE_FIELD(int, node, node)
+	),
+	TPRAWFMT("type:%u call_site:%lx ptr:%p req:%lu alloc:%lu"
+		 " flags:%x node:%d")
+);
+
+TRACE_EVENT_FORMAT(kmem_free, TRACE_KMEM_FREE, kmemtrace_free_entry, ignore,
+	TRACE_STRUCT(
+		TRACE_FIELD(enum kmemtrace_type_id, type_id, type_id)
+		TRACE_FIELD(unsigned long, call_site, call_site)
+		TRACE_FIELD(const void *, ptr, ptr)
+	),
+	TPRAWFMT("type:%u call_site:%lx ptr:%p")
+);
+
+#undef TRACE_SYSTEM
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 210e71f..4488d90 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -656,11 +656,13 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 		return -1;
 	}
 
-	entry = debugfs_create_file("enable", 0644, call->dir, call,
-				    &ftrace_enable_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'%s/enable' entry\n", call->name);
+	if (call->regfunc) {
+		entry = debugfs_create_file("enable", 0644, call->dir, call,
+					    &ftrace_enable_fops);
+		if (!entry)
+			pr_warning("Could not create debugfs "
+				   "'%s/enable' entry\n", call->name);
+	}
 
 	/* Only let type be writable, if we can change it */
 	entry = debugfs_create_file("type",
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
new file mode 100644
index 0000000..0fb7be7
--- /dev/null
+++ b/kernel/trace/trace_export.c
@@ -0,0 +1,81 @@
+/*
+ * trace_export.c - export basic ftrace utilities to user space
+ *
+ * Copyright (C) 2009 Steven Rostedt <srostedt@redhat.com>
+ */
+#include <linux/stringify.h>
+#include <linux/kallsyms.h>
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/ftrace.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+
+#include "trace_output.h"
+
+#include "trace_format.h"
+
+#undef TRACE_FIELD_ZERO_CHAR
+#define TRACE_FIELD_ZERO_CHAR(item)				\
+	ret = trace_seq_printf(s, "\tfield: char " #item ";\t"	\
+			       "offset:%lu;\tsize:0;\n",	\
+			       offsetof(typeof(field), item));	\
+	if (!ret)						\
+		return 0;
+
+
+#undef TPRAWFMT
+#define TPRAWFMT(args...) args
+
+#undef TRACE_EVENT_FORMAT
+#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
+static int								\
+ftrace_format_##call(struct trace_seq *s)				\
+{									\
+	struct args field;						\
+	int ret;							\
+									\
+	tstruct;							\
+									\
+	trace_seq_printf(s, "\nprint fmt: \"%s\"\n", tpfmt);		\
+									\
+	return ret;							\
+}
+
+#include "trace_event_types.h"
+
+#undef TRACE_ZERO_CHAR
+#define TRACE_ZERO_CHAR(arg)
+
+#undef TRACE_FIELD
+#define TRACE_FIELD(type, item, assign)\
+	entry->item = assign;
+
+#undef TRACE_FIELD
+#define TRACE_FIELD(type, item, assign)\
+	entry->item = assign;
+
+#undef TPCMD
+#define TPCMD(cmd...)	cmd
+
+#undef TRACE_ENTRY
+#define TRACE_ENTRY	entry
+
+#undef TRACE_FIELD_SPECIAL
+#define TRACE_FIELD_SPECIAL(type_item, item, cmd) \
+	cmd;
+
+#undef TRACE_EVENT_FORMAT
+#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
+									\
+static struct ftrace_event_call __used					\
+__attribute__((__aligned__(4)))						\
+__attribute__((section("_ftrace_events"))) event_##call = {		\
+	.name 			= #call,				\
+	.id			= proto,				\
+	.system			= __stringify(TRACE_SYSTEM),		\
+	.show_format		= ftrace_format_##call,			\
+}
+#include "trace_event_types.h"
diff --git a/kernel/trace/trace_format.h b/kernel/trace/trace_format.h
index 53a6b13..03f9a4c 100644
--- a/kernel/trace/trace_format.h
+++ b/kernel/trace/trace_format.h
@@ -40,7 +40,7 @@
 
 #undef TRACE_EVENT_FORMAT
 #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
-int									\
+static int								\
 ftrace_format_##call(struct trace_seq *s)				\
 {									\
 	struct ftrace_raw_##call field;					\
-- 
1.6.1.3

-- 
