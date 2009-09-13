Return-Path: <linux-kernel-owner+w=401wt.eu-S1755039AbZIMDql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbZIMDql (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 23:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbZIMDqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 23:46:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47332 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972AbZIMDqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 23:46:34 -0400
Message-Id: <20090913034636.761802463@goodmis.org>
References: <20090913034302.134417216@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 12 Sep 2009 23:43:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 3/6] tracing: show details of structures within the ftrace structures
Content-Disposition: inline; filename=0003-tracing-show-details-of-structures-within-the-ftrace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Some of the internal ftrace structures use structures within. The
output of a field saying it is just a structure is useless for a format
file. A binary reader of the ring buffer needs to know more about
how the fields are broken up.

This patch adds to the ftrace structure macros new fields to
describe the structures inside a structure.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h         |    9 ++++++
 kernel/trace/trace_entries.h |   64 +++++++++++++++++++++++++++++++++++++----
 2 files changed, 66 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index d308195..b0d287d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -53,9 +53,18 @@ extern struct tracer boot_tracer;
 #undef __field
 #define __field(type, item)		type	item;
 
+#undef __field_struct
+#define __field_struct(type, item)	__field(type, item)
+
+#undef __field_desc
+#define __field_desc(type, container, item)
+
 #undef __array
 #define __array(type, item, size)	type	item[size];
 
+#undef __array_desc
+#define __array_desc(type, container, item, size)
+
 #undef __dynamic_array
 #define __dynamic_array(type, item)	type	item[];
 
diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index 82c51fd..c866d34 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -26,6 +26,29 @@
  *		type	item[size];
  *	  in the structure.
  *
+ *   * for structures within structures, the format of the internal
+ *	structure is layed out. This allows the internal structure
+ *	to be deciphered for the format file. Although these macros
+ *	may become out of sync with the internal structure, they
+ *	will create a compile error if it happens. Since the
+ *	internel structures are just tracing helpers, this is not
+ *	an issue.
+ *
+ *	When an internal structure is used, it should use:
+ *
+ *	__field_struct(	type,	item	)
+ *
+ *	instead of __field. This will prevent it from being shown in
+ *	the output file. The fields in the structure should use.
+ *
+ *	__field_desc(	type,	container,	item		)
+ *	__array_desc(	type,	container,	item,	len	)
+ *
+ *	type, item and len are the same as __field and __array, but
+ *	container is added. This is the name of the item in
+ *	__field_struct that this is describing.
+ *
+ *
  * @print: the print format shown to users in the format file.
  */
 
@@ -50,7 +73,9 @@ FTRACE_ENTRY(funcgraph_entry, ftrace_graph_ent_entry,
 	TRACE_GRAPH_ENT,
 
 	F_STRUCT(
-		__field(	struct ftrace_graph_ent,	graph_ent	)
+		__field_struct(	struct ftrace_graph_ent,	graph_ent	)
+		__field_desc(	unsigned long,	graph_ent,	func		)
+		__field_desc(	int,		graph_ent,	depth		)
 	),
 
 	F_printk("--> %lx (%d)", __entry->graph_ent.func, __entry->depth)
@@ -62,7 +87,12 @@ FTRACE_ENTRY(funcgraph_exit, ftrace_graph_ret_entry,
 	TRACE_GRAPH_RET,
 
 	F_STRUCT(
-		__field(	struct ftrace_graph_ret,	ret	)
+		__field_struct(	struct ftrace_graph_ret,	ret	)
+		__field_desc(	unsigned long,	ret,		func	)
+		__field_desc(	unsigned long long, ret,	calltime)
+		__field_desc(	unsigned long long, ret,	rettime	)
+		__field_desc(	unsigned long,	ret,		overrun	)
+		__field_desc(	int,		ret,		depth	)
 	),
 
 	F_printk("<-- %lx (%d) (start: %llx  end: %llx) over: %d",
@@ -218,7 +248,13 @@ FTRACE_ENTRY(mmiotrace_rw, trace_mmiotrace_rw,
 	TRACE_MMIO_RW,
 
 	F_STRUCT(
-		__field(	struct mmiotrace_rw,	rw	)
+		__field_struct(	struct mmiotrace_rw,	rw	)
+		__field_desc(	resource_size_t, rw,	phys	)
+		__field_desc(	unsigned long,	rw,	value	)
+		__field_desc(	unsigned long,	rw,	pc	)
+		__field_desc(	int, 		rw,	map_id	)
+		__field_desc(	unsigned char,	rw,	opcode	)
+		__field_desc(	unsigned char,	rw,	width	)
 	),
 
 	F_printk("%lx %lx %lx %d %lx %lx",
@@ -231,7 +267,12 @@ FTRACE_ENTRY(mmiotrace_map, trace_mmiotrace_map,
 	TRACE_MMIO_MAP,
 
 	F_STRUCT(
-		__field(	struct mmiotrace_map,	map	)
+		__field_struct(	struct mmiotrace_map,	map	)
+		__field_desc(	resource_size_t, map,	phys	)
+		__field_desc(	unsigned long,	map,	virt	)
+		__field_desc(	unsigned long,	map,	len	)
+		__field_desc(	int, 		map,	map_id	)
+		__field_desc(	unsigned char,	map,	opcode	)
 	),
 
 	F_printk("%lx %lx %lx %d %lx",
@@ -244,7 +285,9 @@ FTRACE_ENTRY(boot_call, trace_boot_call,
 	TRACE_BOOT_CALL,
 
 	F_STRUCT(
-		__field(	struct boot_trace_call,	boot_call	)
+		__field_struct(	struct boot_trace_call,	boot_call	)
+		__field_desc(	pid_t,	boot_call,	caller		)
+		__array_desc(	char,	boot_call,	func,	KSYM_SYMBOL_LEN)
 	),
 
 	F_printk("%d  %s", __entry->caller, __entry->func)
@@ -255,7 +298,10 @@ FTRACE_ENTRY(boot_ret, trace_boot_ret,
 	TRACE_BOOT_RET,
 
 	F_STRUCT(
-		__field(	struct boot_trace_ret,	boot_ret	)
+		__field_struct(	struct boot_trace_ret,	boot_ret	)
+		__array_desc(	char,	boot_ret,	func,	KSYM_SYMBOL_LEN)
+		__field_desc(	int,	boot_ret,	result		)
+		__field_desc(	unsigned long, boot_ret, duration	)
 	),
 
 	F_printk("%s %d %lx",
@@ -298,7 +344,11 @@ FTRACE_ENTRY(power, trace_power,
 	TRACE_POWER,
 
 	F_STRUCT(
-		__field(	struct power_trace,	state_data	)
+		__field_struct(	struct power_trace,	state_data	)
+		__field_desc(	s64,	state_data,	stamp		)
+		__field_desc(	s64,	state_data,	end		)
+		__field_desc(	int,	state_data,	type		)
+		__field_desc(	int,	state_data,	state		)
 	),
 
 	F_printk("%llx->%llx type:%u state:%u",
-- 
1.6.3.3

-- 
