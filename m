Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbZIMDqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbZIMDqj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 23:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbZIMDqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 23:46:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47329 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbZIMDqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 23:46:34 -0400
Message-Id: <20090913034636.312738209@goodmis.org>
References: <20090913034302.134417216@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 12 Sep 2009 23:43:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/6] tracing: use macros to create internal ftrace entry ring buffer structures
Content-Disposition: inline; filename=0002-tracing-use-macros-to-create-internal-ftrace-entry-r.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The entries used by ftrace internal code (plugins) currently have their
formats manually exported to userspace. That is, the format files in
debugfs/tracing/events/ftrace/*/format are currently created by hand.
This is a maintenance nightmare, and can easily become out of sync
with what is actually shown.

This patch uses the methodology of the TRACE_EVENT macros to build
the structures so that their formats can be automated and this
will keep the structures in sync with what users can see.

This patch only changes the way the structures are created. Further
patches will build off of this to automate the format files.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h         |  160 ++++----------------
 kernel/trace/trace_entries.h |  342 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 369 insertions(+), 133 deletions(-)
 create mode 100644 kernel/trace/trace_entries.h

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 4ad4e1d..d308195 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -42,150 +42,45 @@ enum trace_type {
 	__TRACE_LAST_TYPE,
 };
 
-/*
- * Function trace entry - function address and parent function addres:
- */
-struct ftrace_entry {
-	struct trace_entry	ent;
-	unsigned long		ip;
-	unsigned long		parent_ip;
-};
-
-/* Function call entry */
-struct ftrace_graph_ent_entry {
-	struct trace_entry		ent;
-	struct ftrace_graph_ent		graph_ent;
+enum kmemtrace_type_id {
+	KMEMTRACE_TYPE_KMALLOC = 0,	/* kmalloc() or kfree(). */
+	KMEMTRACE_TYPE_CACHE,		/* kmem_cache_*(). */
+	KMEMTRACE_TYPE_PAGES,		/* __get_free_pages() and friends. */
 };
 
-/* Function return entry */
-struct ftrace_graph_ret_entry {
-	struct trace_entry		ent;
-	struct ftrace_graph_ret		ret;
-};
 extern struct tracer boot_tracer;
 
-/*
- * Context switch trace entry - which task (and prio) we switched from/to:
- */
-struct ctx_switch_entry {
-	struct trace_entry	ent;
-	unsigned int		prev_pid;
-	unsigned char		prev_prio;
-	unsigned char		prev_state;
-	unsigned int		next_pid;
-	unsigned char		next_prio;
-	unsigned char		next_state;
-	unsigned int		next_cpu;
-};
-
-/*
- * Special (free-form) trace entry:
- */
-struct special_entry {
-	struct trace_entry	ent;
-	unsigned long		arg1;
-	unsigned long		arg2;
-	unsigned long		arg3;
-};
-
-/*
- * Stack-trace entry:
- */
+#undef __field
+#define __field(type, item)		type	item;
 
-#define FTRACE_STACK_ENTRIES	8
+#undef __array
+#define __array(type, item, size)	type	item[size];
 
-struct stack_entry {
-	struct trace_entry	ent;
-	unsigned long		caller[FTRACE_STACK_ENTRIES];
-};
+#undef __dynamic_array
+#define __dynamic_array(type, item)	type	item[];
 
-struct userstack_entry {
-	struct trace_entry	ent;
-	unsigned int		tgid;
-	unsigned long		caller[FTRACE_STACK_ENTRIES];
-};
-
-/*
- * trace_printk entry:
- */
-struct bprint_entry {
-	struct trace_entry	ent;
-	unsigned long		ip;
-	const char		*fmt;
-	u32			buf[];
-};
-
-struct print_entry {
-	struct trace_entry	ent;
-	unsigned long		ip;
-	char			buf[];
-};
+#undef F_STRUCT
+#define F_STRUCT(args...)		args
 
-struct trace_mmiotrace_rw {
-	struct trace_entry	ent;
-	struct mmiotrace_rw	rw;
-};
-
-struct trace_mmiotrace_map {
-	struct trace_entry	ent;
-	struct mmiotrace_map	map;
-};
-
-struct trace_boot_call {
-	struct trace_entry	ent;
-	struct boot_trace_call boot_call;
-};
-
-struct trace_boot_ret {
-	struct trace_entry	ent;
-	struct boot_trace_ret boot_ret;
-};
-
-#define TRACE_FUNC_SIZE 30
-#define TRACE_FILE_SIZE 20
-struct trace_branch {
-	struct trace_entry	ent;
-	unsigned	        line;
-	char			func[TRACE_FUNC_SIZE+1];
-	char			file[TRACE_FILE_SIZE+1];
-	char			correct;
-};
-
-struct hw_branch_entry {
-	struct trace_entry	ent;
-	u64			from;
-	u64			to;
-};
-
-struct trace_power {
-	struct trace_entry	ent;
-	struct power_trace	state_data;
-};
+#undef FTRACE_ENTRY
+#define FTRACE_ENTRY(name, struct_name, id, tstruct, print)	\
+	struct struct_name {					\
+		struct trace_entry	ent;			\
+		tstruct						\
+	}
 
-enum kmemtrace_type_id {
-	KMEMTRACE_TYPE_KMALLOC = 0,	/* kmalloc() or kfree(). */
-	KMEMTRACE_TYPE_CACHE,		/* kmem_cache_*(). */
-	KMEMTRACE_TYPE_PAGES,		/* __get_free_pages() and friends. */
-};
+#undef TP_ARGS
+#define TP_ARGS(args...)	args
 
-struct kmemtrace_alloc_entry {
-	struct trace_entry	ent;
-	enum kmemtrace_type_id	type_id;
-	unsigned long		call_site;
-	const void		*ptr;
-	size_t			bytes_req;
-	size_t			bytes_alloc;
-	gfp_t			gfp_flags;
-	int			node;
-};
+#undef FTRACE_ENTRY_DUP
+#define FTRACE_ENTRY_DUP(name, name_struct, id, tstruct, printk)
 
-struct kmemtrace_free_entry {
-	struct trace_entry	ent;
-	enum kmemtrace_type_id	type_id;
-	unsigned long		call_site;
-	const void		*ptr;
-};
+#include "trace_entries.h"
 
+/*
+ * syscalls are special, and need special handling, this is why
+ * they are not included in trace_entries.h
+ */
 struct syscall_trace_enter {
 	struct trace_entry	ent;
 	int			nr;
@@ -198,7 +93,6 @@ struct syscall_trace_exit {
 	unsigned long		ret;
 };
 
-
 /*
  * trace_flag_type is an enumeration that holds different
  * states when a trace occurs. These are:
diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
new file mode 100644
index 0000000..82c51fd
--- /dev/null
+++ b/kernel/trace/trace_entries.h
@@ -0,0 +1,342 @@
+/*
+ * This file defines the trace event structures that go into the ring
+ * buffer directly. They are created via macros so that changes for them
+ * appear in the format file. Using macros will automate this process.
+ *
+ * The macro used to create a ftrace data structure is:
+ *
+ * FTRACE_ENTRY( name, struct_name, id, structure, print )
+ *
+ * @name: the name used the event name, as well as the name of
+ *   the directory that holds the format file.
+ *
+ * @struct_name: the name of the structure that is created.
+ *
+ * @id: The event identifier that is used to detect what event
+ *    this is from the ring buffer.
+ *
+ * @structure: the structure layout
+ *
+ *  - __field(	type,	item	)
+ *	  This is equivalent to declaring
+ *		type	item;
+ *	  in the structure.
+ *  - __array(	type,	item,	size	)
+ *	  This is equivalent to declaring
+ *		type	item[size];
+ *	  in the structure.
+ *
+ * @print: the print format shown to users in the format file.
+ */
+
+/*
+ * Function trace entry - function address and parent function addres:
+ */
+FTRACE_ENTRY(function, ftrace_entry,
+
+	TRACE_FN,
+
+	F_STRUCT(
+		__field(	unsigned long,	ip		)
+		__field(	unsigned long,	parent_ip	)
+	),
+
+	F_printk(" %lx <-- %lx", __entry->ip, __entry->parent_ip)
+);
+
+/* Function call entry */
+FTRACE_ENTRY(funcgraph_entry, ftrace_graph_ent_entry,
+
+	TRACE_GRAPH_ENT,
+
+	F_STRUCT(
+		__field(	struct ftrace_graph_ent,	graph_ent	)
+	),
+
+	F_printk("--> %lx (%d)", __entry->graph_ent.func, __entry->depth)
+);
+
+/* Function return entry */
+FTRACE_ENTRY(funcgraph_exit, ftrace_graph_ret_entry,
+
+	TRACE_GRAPH_RET,
+
+	F_STRUCT(
+		__field(	struct ftrace_graph_ret,	ret	)
+	),
+
+	F_printk("<-- %lx (%d) (start: %llx  end: %llx) over: %d",
+		 __entry->func, __entry->depth,
+		 __entry->calltime, __entry->rettim,
+		 __entrty->depth)
+);
+
+/*
+ * Context switch trace entry - which task (and prio) we switched from/to:
+ *
+ * This is used for both wakeup and context switches. We only want
+ * to create one structure, but we need two outputs for it.
+ */
+#define FTRACE_CTX_FIELDS					\
+	__field(	unsigned int,	prev_pid	)	\
+	__field(	unsigned char,	prev_prio	)	\
+	__field(	unsigned char,	prev_state	)	\
+	__field(	unsigned int,	next_pid	)	\
+	__field(	unsigned char,	next_prio	)	\
+	__field(	unsigned char,	next_state	)	\
+	__field(	unsigned int,	next_cpu	)
+
+#if 0
+FTRACE_ENTRY_STRUCT_ONLY(ctx_switch_entry,
+
+	F_STRUCT(
+		FTRACE_CTX_FIELDS
+	)
+);
+#endif
+
+FTRACE_ENTRY(context_switch, ctx_switch_entry,
+
+	TRACE_CTX,
+
+	F_STRUCT(
+		FTRACE_CTX_FIELDS
+	),
+
+	F_printk(b"%u:%u:%u  ==> %u:%u:%u [%03u]",
+		 __entry->prev_pid, __entry->prev_prio, __entry->prev_state,
+		 __entry->next_pid, __entry->next_prio, __entry->next_state,
+		 __entry->next_cpu
+		)
+);
+
+/*
+ * FTRACE_ENTRY_DUP only creates the format file, it will not
+ *  create another structure.
+ */
+FTRACE_ENTRY_DUP(wakeup, ctx_switch_entry,
+
+	TRACE_WAKE,
+
+	F_STRUCT(
+		FTRACE_CTX_FIELDS
+	),
+
+	F_printk("%u:%u:%u  ==+ %u:%u:%u [%03u]",
+		 __entry->prev_pid, __entry->prev_prio, __entry->prev_state,
+		 __entry->next_pid, __entry->next_prio, __entry->next_state,
+		 __entry->next_cpu
+		)
+);
+
+/*
+ * Special (free-form) trace entry:
+ */
+FTRACE_ENTRY(special, special_entry,
+
+	TRACE_SPECIAL,
+
+	F_STRUCT(
+		__field(	unsigned long,	arg1	)
+		__field(	unsigned long,	arg2	)
+		__field(	unsigned long,	arg3	)
+	),
+
+	F_printk("(%08lx) (%08lx) (%08lx)",
+		 __entry->arg1, __entry->arg2, __entry->arg3)
+);
+
+/*
+ * Stack-trace entry:
+ */
+
+#define FTRACE_STACK_ENTRIES	8
+
+FTRACE_ENTRY(kernel_stack, stack_entry,
+
+	TRACE_STACK,
+
+	F_STRUCT(
+		__array(	unsigned long,	caller, FTRACE_STACK_ENTRIES	)
+	),
+
+	F_printk("\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n"
+		 "\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n",
+		 __entry->caller[0], __entry->caller[1], __entry->caller[2],
+		 __entry->caller[3], __entry->caller[4], __entry->caller[5],
+		 __entry->caller[6], __entry->caller[7])
+);
+
+FTRACE_ENTRY(user_stack, userstack_entry,
+
+	TRACE_USER_STACK,
+
+	F_STRUCT(
+		__field(	unsigned int,	tgid	)
+		__array(	unsigned long,	caller, FTRACE_STACK_ENTRIES	)
+	),
+
+	F_printk("\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n"
+		 "\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n",
+		 __entry->caller[0], __entry->caller[1], __entry->caller[2],
+		 __entry->caller[3], __entry->caller[4], __entry->caller[5],
+		 __entry->caller[6], __entry->caller[7])
+);
+
+/*
+ * trace_printk entry:
+ */
+FTRACE_ENTRY(bprint, bprint_entry,
+
+	TRACE_BPRINT,
+
+	F_STRUCT(
+		__field(	unsigned long,	ip	)
+		__field(	const char *,	fmt	)
+		__dynamic_array(	u32,	buf	)
+	),
+
+	F_printk("%08lx fmt:%p",
+		 __entry->ip, __entry->fmt)
+);
+
+FTRACE_ENTRY(print, print_entry,
+
+	TRACE_PRINT,
+
+	F_STRUCT(
+		__field(	unsigned long,	ip	)
+		__dynamic_array(	char,	buf	)
+	),
+
+	F_printk("%08lx %s",
+		 __entry->ip, __entry->buf)
+);
+
+FTRACE_ENTRY(mmiotrace_rw, trace_mmiotrace_rw,
+
+	TRACE_MMIO_RW,
+
+	F_STRUCT(
+		__field(	struct mmiotrace_rw,	rw	)
+	),
+
+	F_printk("%lx %lx %lx %d %lx %lx",
+		 __entry->phs, __entry->value, __entry->pc,
+		 __entry->map_id, __entry->opcode, __entry->width)
+);
+
+FTRACE_ENTRY(mmiotrace_map, trace_mmiotrace_map,
+
+	TRACE_MMIO_MAP,
+
+	F_STRUCT(
+		__field(	struct mmiotrace_map,	map	)
+	),
+
+	F_printk("%lx %lx %lx %d %lx",
+		 __entry->phs, __entry->virt, __entry->len,
+		 __entry->map_id, __entry->opcode)
+);
+
+FTRACE_ENTRY(boot_call, trace_boot_call,
+
+	TRACE_BOOT_CALL,
+
+	F_STRUCT(
+		__field(	struct boot_trace_call,	boot_call	)
+	),
+
+	F_printk("%d  %s", __entry->caller, __entry->func)
+);
+
+FTRACE_ENTRY(boot_ret, trace_boot_ret,
+
+	TRACE_BOOT_RET,
+
+	F_STRUCT(
+		__field(	struct boot_trace_ret,	boot_ret	)
+	),
+
+	F_printk("%s %d %lx",
+		 __entry->func, __entry->result, __entry->duration)
+);
+
+#define TRACE_FUNC_SIZE 30
+#define TRACE_FILE_SIZE 20
+
+FTRACE_ENTRY(branch, trace_branch,
+
+	TRACE_BRANCH,
+
+	F_STRUCT(
+		__field(	unsigned int,	line				)
+		__array(	char,		func,	TRACE_FUNC_SIZE+1	)
+		__array(	char,		file,	TRACE_FILE_SIZE+1	)
+		__field(	char,		correct				)
+	),
+
+	F_printk("%u:%s:%s (%u)",
+		 __entry->line,
+		 __entry->func, __entry->file, __entry->correct)
+);
+
+FTRACE_ENTRY(hw_branch, hw_branch_entry,
+
+	TRACE_HW_BRANCHES,
+
+	F_STRUCT(
+		__field(	u64,	from	)
+		__field(	u64,	to	)
+	),
+
+	F_printk("from: %llx to: %llx", __entry->from, __entry->to)
+);
+
+FTRACE_ENTRY(power, trace_power,
+
+	TRACE_POWER,
+
+	F_STRUCT(
+		__field(	struct power_trace,	state_data	)
+	),
+
+	F_printk("%llx->%llx type:%u state:%u",
+		 __entry->stamp, __entry->end,
+		 __entry->type, __entry->state)
+);
+
+FTRACE_ENTRY(kmem_alloc, kmemtrace_alloc_entry,
+
+	TRACE_KMEM_ALLOC,
+
+	F_STRUCT(
+		__field(	enum kmemtrace_type_id,	type_id		)
+		__field(	unsigned long,		call_site	)
+		__field(	const void *,		ptr		)
+		__field(	size_t,			bytes_req	)
+		__field(	size_t,			bytes_alloc	)
+		__field(	gfp_t,			gfp_flags	)
+		__field(	int,			node		)
+	),
+
+	F_printk("type:%u call_site:%lx ptr:%p req:%lu alloc:%lu"
+		 " flags:%x node:%d",
+		 __entry->type_id, __entry->call_site, __entry->ptr,
+		 __entry->bytes_req, __entry->bytes_alloc,
+		 __entry->gfp_flags, __entry->node)
+);
+
+FTRACE_ENTRY(kmem_free, kmemtrace_free_entry,
+
+	TRACE_KMEM_FREE,
+
+	F_STRUCT(
+		__field(	enum kmemtrace_type_id,	type_id		)
+		__field(	unsigned long,		call_site	)
+		__field(	const void *,		ptr		)
+	),
+
+	F_printk("type:%u call_site:%lx ptr:%p",
+		 __entry->type_id, __entry->call_site, __entry->ptr)
+);
-- 
1.6.3.3

-- 
