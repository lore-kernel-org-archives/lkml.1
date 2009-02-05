Return-Path: <linux-kernel-owner+w=401wt.eu-S1760817AbZBESPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760817AbZBESPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760719AbZBESO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:14:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36886 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760651AbZBESOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:14:54 -0500
Date: Thu, 5 Feb 2009 16:14:13 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 2/2] tracing: Introduce
	trace_buffer_{lock_reserve,unlock_commit}
Message-ID: <20090205181413.GI17653@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: new API

These new functions do what previously was being open coded, reducing
the number of details ftrace plugin writers have to worry about.

It also standardizes the handling of stacktrace, userstacktrace and
other trace options we may introduce in the future.

With this patch, for instance, the blk tracer (and some others already
in the tree) can use the "userstacktrace" /d/tracing/trace_options
facility.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 block/blktrace.c                 |   21 ++------
 kernel/trace/kmemtrace.c         |   19 ++-----
 kernel/trace/trace.c             |   94 +++++++++++++++++++++----------------
 kernel/trace/trace.h             |   11 ++++
 kernel/trace/trace_boot.c        |   20 ++------
 kernel/trace/trace_branch.c      |    7 +--
 kernel/trace/trace_hw_branches.c |    7 +--
 kernel/trace/trace_mmiotrace.c   |   20 +++-----
 kernel/trace/trace_power.c       |   20 ++------
 9 files changed, 102 insertions(+), 117 deletions(-)

$ codiff /tmp/vmlinux.before /tmp/vmlinux.after
linux-2.6-tip/kernel/trace/trace.c:
  trace_vprintk              |   -5
  trace_graph_return         |  -22
  trace_graph_entry          |  -26
  trace_function             |  -45
  __ftrace_trace_stack       |  -27
  ftrace_trace_userstack     |  -29
  tracing_sched_switch_trace |  -66
  tracing_stop               |   +1
  trace_seq_to_user          |   -1
  ftrace_trace_special       |  -63
  ftrace_special             |   +1
  tracing_sched_wakeup_trace |  -70
  tracing_reset_online_cpus  |   -1
 13 functions changed, 2 bytes added, 355 bytes removed, diff: -353

linux-2.6-tip/block/blktrace.c:
  __blk_add_trace |  -58
 1 function changed, 58 bytes removed, diff: -58

linux-2.6-tip/kernel/trace/trace.c:
  trace_buffer_lock_reserve  |  +88
  trace_buffer_unlock_commit |  +86
 2 functions changed, 174 bytes added, diff: +174

/tmp/vmlinux.after:
 16 functions changed, 176 bytes added, 413 bytes removed, diff: -237

diff --git a/block/blktrace.c b/block/blktrace.c
index 8e52f24..834cd84 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -187,19 +187,15 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	cpu = raw_smp_processor_id();
 
 	if (blk_tr) {
-		struct trace_entry *ent;
 		tracing_record_cmdline(current);
 
-		event = ring_buffer_lock_reserve(blk_tr->buffer,
-						 sizeof(*t) + pdu_len);
+		pc = preempt_count();
+		event = trace_buffer_lock_reserve(blk_tr, TRACE_BLK,
+						  sizeof(*t) + pdu_len,
+						  0, pc);
 		if (!event)
 			return;
-
-		ent = ring_buffer_event_data(event);
-		t = (struct blk_io_trace *)ent;
-		pc = preempt_count();
-		tracing_generic_entry_update(ent, 0, pc);
-		ent->type = TRACE_BLK;
+		t = ring_buffer_event_data(event);
 		goto record_it;
 	}
 
@@ -241,12 +237,7 @@ record_it:
 			memcpy((void *) t + sizeof(*t), pdu_data, pdu_len);
 
 		if (blk_tr) {
-			ring_buffer_unlock_commit(blk_tr->buffer, event);
-			if (pid != 0 &&
-			    !(blk_tracer_flags.val & TRACE_BLK_OPT_CLASSIC) &&
-			    (trace_flags & TRACE_ITER_STACKTRACE) != 0)
-				__trace_stack(blk_tr, 0, 5, pc);
-			trace_wake_up();
+			trace_buffer_unlock_commit(blk_tr, event, 0, pc);
 			return;
 		}
 	}
diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 256749d..ae201b3 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -276,13 +276,12 @@ void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
 	if (!kmem_tracing_enabled)
 		return;
 
-	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
+	event = trace_buffer_lock_reserve(tr, TRACE_KMEM_ALLOC,
+					  sizeof(*entry), 0, 0);
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, 0, 0);
 
-	entry->ent.type = TRACE_KMEM_ALLOC;
 	entry->call_site = call_site;
 	entry->ptr = ptr;
 	entry->bytes_req = bytes_req;
@@ -290,9 +289,7 @@ void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
 	entry->gfp_flags = gfp_flags;
 	entry->node	=	node;
 
-	ring_buffer_unlock_commit(tr->buffer, event);
-
-	trace_wake_up();
+	trace_buffer_unlock_commit(tr, event, 0, 0);
 }
 EXPORT_SYMBOL(kmemtrace_mark_alloc_node);
 
@@ -307,20 +304,16 @@ void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
 	if (!kmem_tracing_enabled)
 		return;
 
-	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
+	event = trace_buffer_lock_reserve(tr, TRACE_KMEM_FREE,
+					  sizeof(*entry), 0, 0);
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, 0, 0);
-
-	entry->ent.type = TRACE_KMEM_FREE;
 	entry->type_id	= type_id;
 	entry->call_site = call_site;
 	entry->ptr = ptr;
 
-	ring_buffer_unlock_commit(tr->buffer, event);
-
-	trace_wake_up();
+	trace_buffer_unlock_commit(tr, event, 0, 0);
 }
 EXPORT_SYMBOL(kmemtrace_mark_free);
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index eb453a2..8fad377 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -776,6 +776,39 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 		(need_resched() ? TRACE_FLAG_NEED_RESCHED : 0);
 }
 
+struct ring_buffer_event *trace_buffer_lock_reserve(struct trace_array *tr,
+						    unsigned char type,
+						    unsigned long len,
+						    unsigned long flags, int pc)
+{
+	struct ring_buffer_event *event;
+
+	event = ring_buffer_lock_reserve(tr->buffer, len);
+	if (event != NULL) {
+		struct trace_entry *ent = ring_buffer_event_data(event);
+
+		tracing_generic_entry_update(ent, flags, pc);
+		ent->type = type;
+	}
+
+	return event;
+}
+static void ftrace_trace_stack(struct trace_array *tr,
+			       unsigned long flags, int skip, int pc);
+static void ftrace_trace_userstack(struct trace_array *tr,
+				   unsigned long flags, int pc);
+
+void trace_buffer_unlock_commit(struct trace_array *tr,
+				struct ring_buffer_event *event,
+				unsigned long flags, int pc)
+{
+	ring_buffer_unlock_commit(tr->buffer, event);
+
+	ftrace_trace_stack(tr, flags, 6, pc);
+	ftrace_trace_userstack(tr, flags, pc);
+	trace_wake_up();
+}
+
 void
 trace_function(struct trace_array *tr,
 	       unsigned long ip, unsigned long parent_ip, unsigned long flags,
@@ -788,12 +821,11 @@ trace_function(struct trace_array *tr,
 	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
 		return;
 
-	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
+	event = trace_buffer_lock_reserve(tr, TRACE_FN, sizeof(*entry),
+					  flags, pc);
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, flags, pc);
-	entry->ent.type			= TRACE_FN;
 	entry->ip			= ip;
 	entry->parent_ip		= parent_ip;
 	ring_buffer_unlock_commit(tr->buffer, event);
@@ -811,12 +843,11 @@ static void __trace_graph_entry(struct trace_array *tr,
 	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
 		return;
 
-	event = ring_buffer_lock_reserve(global_trace.buffer, sizeof(*entry));
+	event = trace_buffer_lock_reserve(&global_trace, TRACE_GRAPH_ENT,
+					  sizeof(*entry), flags, pc);
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, flags, pc);
-	entry->ent.type			= TRACE_GRAPH_ENT;
 	entry->graph_ent			= *trace;
 	ring_buffer_unlock_commit(global_trace.buffer, event);
 }
@@ -832,12 +863,11 @@ static void __trace_graph_return(struct trace_array *tr,
 	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
 		return;
 
-	event = ring_buffer_lock_reserve(global_trace.buffer, sizeof(*entry));
+	event = trace_buffer_lock_reserve(&global_trace, TRACE_GRAPH_RET,
+					  sizeof(*entry), flags, pc);
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, flags, pc);
-	entry->ent.type			= TRACE_GRAPH_RET;
 	entry->ret				= *trace;
 	ring_buffer_unlock_commit(global_trace.buffer, event);
 }
@@ -861,13 +891,11 @@ static void __ftrace_trace_stack(struct trace_array *tr,
 	struct stack_entry *entry;
 	struct stack_trace trace;
 
-	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
+	event = trace_buffer_lock_reserve(tr, TRACE_STACK,
+					  sizeof(*entry), flags, pc);
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, flags, pc);
-	entry->ent.type		= TRACE_STACK;
-
 	memset(&entry->caller, 0, sizeof(entry->caller));
 
 	trace.nr_entries	= 0;
@@ -908,12 +936,11 @@ static void ftrace_trace_userstack(struct trace_array *tr,
 	if (!(trace_flags & TRACE_ITER_USERSTACKTRACE))
 		return;
 
-	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
+	event = trace_buffer_lock_reserve(tr, TRACE_USER_STACK,
+					  sizeof(*entry), flags, pc);
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, flags, pc);
-	entry->ent.type		= TRACE_USER_STACK;
 
 	memset(&entry->caller, 0, sizeof(entry->caller));
 
@@ -941,20 +968,15 @@ ftrace_trace_special(void *__tr,
 	struct trace_array *tr = __tr;
 	struct special_entry *entry;
 
-	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
+	event = trace_buffer_lock_reserve(tr, TRACE_SPECIAL,
+					  sizeof(*entry), 0, pc);
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, 0, pc);
-	entry->ent.type			= TRACE_SPECIAL;
 	entry->arg1			= arg1;
 	entry->arg2			= arg2;
 	entry->arg3			= arg3;
-	ring_buffer_unlock_commit(tr->buffer, event);
-	ftrace_trace_stack(tr, 0, 4, pc);
-	ftrace_trace_userstack(tr, 0, pc);
-
-	trace_wake_up();
+	trace_buffer_unlock_commit(tr, event, 0, pc);
 }
 
 void
@@ -973,12 +995,11 @@ tracing_sched_switch_trace(struct trace_array *tr,
 	struct ring_buffer_event *event;
 	struct ctx_switch_entry *entry;
 
-	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
+	event = trace_buffer_lock_reserve(tr, TRACE_CTX,
+					  sizeof(*entry), flags, pc);
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, flags, pc);
-	entry->ent.type			= TRACE_CTX;
 	entry->prev_pid			= prev->pid;
 	entry->prev_prio		= prev->prio;
 	entry->prev_state		= prev->state;
@@ -986,9 +1007,7 @@ tracing_sched_switch_trace(struct trace_array *tr,
 	entry->next_prio		= next->prio;
 	entry->next_state		= next->state;
 	entry->next_cpu	= task_cpu(next);
-	ring_buffer_unlock_commit(tr->buffer, event);
-	ftrace_trace_stack(tr, flags, 5, pc);
-	ftrace_trace_userstack(tr, flags, pc);
+	trace_buffer_unlock_commit(tr, event, flags, pc);
 }
 
 void
@@ -1000,12 +1019,11 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 	struct ring_buffer_event *event;
 	struct ctx_switch_entry *entry;
 
-	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
+	event = trace_buffer_lock_reserve(tr, TRACE_WAKE,
+					  sizeof(*entry), flags, pc);
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, flags, pc);
-	entry->ent.type			= TRACE_WAKE;
 	entry->prev_pid			= curr->pid;
 	entry->prev_prio		= curr->prio;
 	entry->prev_state		= curr->state;
@@ -1013,11 +1031,7 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 	entry->next_prio		= wakee->prio;
 	entry->next_state		= wakee->state;
 	entry->next_cpu			= task_cpu(wakee);
-	ring_buffer_unlock_commit(tr->buffer, event);
-	ftrace_trace_stack(tr, flags, 6, pc);
-	ftrace_trace_userstack(tr, flags, pc);
-
-	trace_wake_up();
+	trace_buffer_unlock_commit(tr, event, flags, pc);
 }
 
 void
@@ -2825,12 +2839,10 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
 	trace_buf[len] = 0;
 
 	size = sizeof(*entry) + len + 1;
-	event = ring_buffer_lock_reserve(tr->buffer, size);
+	event = trace_buffer_lock_reserve(tr, TRACE_PRINT, size, irq_flags, pc);
 	if (!event)
 		goto out_unlock;
 	entry = ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, irq_flags, pc);
-	entry->ent.type			= TRACE_PRINT;
 	entry->ip			= ip;
 	entry->depth			= depth;
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index df627a9..e03f157 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -403,6 +403,17 @@ int tracing_open_generic(struct inode *inode, struct file *filp);
 struct dentry *tracing_init_dentry(void);
 void init_tracer_sysprof_debugfs(struct dentry *d_tracer);
 
+struct ring_buffer_event;
+
+struct ring_buffer_event *trace_buffer_lock_reserve(struct trace_array *tr,
+						    unsigned char type,
+						    unsigned long len,
+						    unsigned long flags,
+						    int pc);
+void trace_buffer_unlock_commit(struct trace_array *tr,
+				struct ring_buffer_event *event,
+				unsigned long flags, int pc);
+
 struct trace_entry *tracing_get_trace_entry(struct trace_array *tr,
 						struct trace_array_cpu *data);
 
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index 4e08deb..7a30fc4 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -143,17 +143,13 @@ void trace_boot_call(struct boot_trace_call *bt, initcall_t fn)
 	sprint_symbol(bt->func, (unsigned long)fn);
 	preempt_disable();
 
-	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
+	event = trace_buffer_lock_reserve(tr, TRACE_BOOT_CALL,
+					  sizeof(*entry), 0, 0);
 	if (!event)
 		goto out;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, 0, 0);
-	entry->ent.type = TRACE_BOOT_CALL;
 	entry->boot_call = *bt;
-	ring_buffer_unlock_commit(tr->buffer, event);
-
-	trace_wake_up();
-
+	trace_buffer_unlock_commit(tr, event, 0, 0);
  out:
 	preempt_enable();
 }
@@ -170,17 +166,13 @@ void trace_boot_ret(struct boot_trace_ret *bt, initcall_t fn)
 	sprint_symbol(bt->func, (unsigned long)fn);
 	preempt_disable();
 
-	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
+	event = trace_buffer_lock_reserve(tr, TRACE_BOOT_RET,
+					  sizeof(*entry), 0, 0);
 	if (!event)
 		goto out;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, 0, 0);
-	entry->ent.type = TRACE_BOOT_RET;
 	entry->boot_ret = *bt;
-	ring_buffer_unlock_commit(tr->buffer, event);
-
-	trace_wake_up();
-
+	trace_buffer_unlock_commit(tr, event, 0, 0);
  out:
 	preempt_enable();
 }
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 770e52a..48b2196 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -52,14 +52,13 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 	if (atomic_inc_return(&tr->data[cpu]->disabled) != 1)
 		goto out;
 
-	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
+	pc = preempt_count();
+	event = trace_buffer_lock_reserve(tr, TRACE_BRANCH,
+					  sizeof(*entry), flags, pc);
 	if (!event)
 		goto out;
 
-	pc = preempt_count();
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, flags, pc);
-	entry->ent.type		= TRACE_BRANCH;
 
 	/* Strip off the path, only save the file */
 	p = f->file + strlen(f->file);
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index e720c00..2aa1c9f 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -189,16 +189,15 @@ void trace_hw_branch(u64 from, u64 to)
 	if (atomic_inc_return(&tr->data[cpu]->disabled) != 1)
 		goto out;
 
-	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
+	event = trace_buffer_lock_reserve(tr, TRACE_HW_BRANCHES,
+					  sizeof(*entry), 0, 0);
 	if (!event)
 		goto out;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, 0, from);
-	entry->ent.type = TRACE_HW_BRANCHES;
 	entry->ent.cpu = cpu;
 	entry->from = from;
 	entry->to   = to;
-	ring_buffer_unlock_commit(tr->buffer, event);
+	trace_buffer_unlock_commit(tr, event, 0, 0);
 
  out:
 	atomic_dec(&tr->data[cpu]->disabled);
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 104ddeb..c401b90 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -307,19 +307,17 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
 {
 	struct ring_buffer_event *event;
 	struct trace_mmiotrace_rw *entry;
+	int pc = preempt_count();
 
-	event	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
+	event = trace_buffer_lock_reserve(tr, TRACE_MMIO_RW,
+					  sizeof(*entry), 0, pc);
 	if (!event) {
 		atomic_inc(&dropped_count);
 		return;
 	}
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, 0, preempt_count());
-	entry->ent.type			= TRACE_MMIO_RW;
 	entry->rw			= *rw;
-	ring_buffer_unlock_commit(tr->buffer, event);
-
-	trace_wake_up();
+	trace_buffer_unlock_commit(tr, event, 0, pc);
 }
 
 void mmio_trace_rw(struct mmiotrace_rw *rw)
@@ -335,19 +333,17 @@ static void __trace_mmiotrace_map(struct trace_array *tr,
 {
 	struct ring_buffer_event *event;
 	struct trace_mmiotrace_map *entry;
+	int pc = preempt_count();
 
-	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
+	event = trace_buffer_lock_reserve(tr, TRACE_MMIO_MAP,
+					  sizeof(*entry), 0, pc);
 	if (!event) {
 		atomic_inc(&dropped_count);
 		return;
 	}
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, 0, preempt_count());
-	entry->ent.type			= TRACE_MMIO_MAP;
 	entry->map			= *map;
-	ring_buffer_unlock_commit(tr->buffer, event);
-
-	trace_wake_up();
+	trace_buffer_unlock_commit(tr, event, 0, pc);
 }
 
 void mmio_trace_mapping(struct mmiotrace_map *map)
diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
index 3b1a292..bfc21f8 100644
--- a/kernel/trace/trace_power.c
+++ b/kernel/trace/trace_power.c
@@ -124,17 +124,13 @@ void trace_power_end(struct power_trace *it)
 	it->end = ktime_get();
 	data = tr->data[smp_processor_id()];
 
-	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
+	event = trace_buffer_lock_reserve(tr, TRACE_POWER,
+					  sizeof(*entry), 0, 0);
 	if (!event)
 		goto out;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, 0, 0);
-	entry->ent.type = TRACE_POWER;
 	entry->state_data = *it;
-	ring_buffer_unlock_commit(tr->buffer, event);
-
-	trace_wake_up();
-
+	trace_buffer_unlock_commit(tr, event, 0, 0);
  out:
 	preempt_enable();
 }
@@ -159,17 +155,13 @@ void trace_power_mark(struct power_trace *it, unsigned int type,
 	it->end = it->stamp;
 	data = tr->data[smp_processor_id()];
 
-	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
+	event = trace_buffer_lock_reserve(tr, TRACE_POWER,
+					  sizeof(*entry), 0, 0);
 	if (!event)
 		goto out;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, 0, 0);
-	entry->ent.type = TRACE_POWER;
 	entry->state_data = *it;
-	ring_buffer_unlock_commit(tr->buffer, event);
-
-	trace_wake_up();
-
+	trace_buffer_unlock_commit(tr, event, 0, 0);
  out:
 	preempt_enable();
 }
-- 
1.6.0.6

