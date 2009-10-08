Return-Path: <linux-kernel-owner+w=401wt.eu-S1759562AbZJHSxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562AbZJHSxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 14:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759445AbZJHSxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 14:53:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38897 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759244AbZJHSxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 14:53:35 -0400
Date: Thu, 8 Oct 2009 20:52:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: [GIT PULL] tracing fixes
Message-ID: <20091008185251.GA13151@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (2):
      tracing: Check total refcount before releasing bufs in profile_enable failure
      tracing: Use free_percpu instead of kfree

Hiroshi Shimamoto (1):
      trace: Fix missing assignment in trace_ctxwake_*

Steven Rostedt (3):
      tracing: fix transposed numbers of lock_depth and preempt_count
      ftrace: check for failure for all conversions
      tracing: user local buffer variable for trace branch tracer

Zhenwen Xu (1):
      tracing: fix warning on kernel/trace/trace_branch.c andtrace_hw_branches.c

jolsa@redhat.com (1):
      tracing: correct module boundaries for ftrace_release


 include/linux/ftrace.h             |    2 +-
 kernel/trace/ftrace.c              |   23 +++++++----------------
 kernel/trace/trace_branch.c        |    8 +++++---
 kernel/trace/trace_event_profile.c |   15 ++++++++++-----
 kernel/trace/trace_hw_branches.c   |    8 +++++---
 kernel/trace/trace_output.c        |   18 ++++++++++--------
 6 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index cd3d2ab..0b4f97d 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -241,7 +241,7 @@ extern void ftrace_enable_daemon(void);
 # define ftrace_set_filter(buf, len, reset)	do { } while (0)
 # define ftrace_disable_daemon()		do { } while (0)
 # define ftrace_enable_daemon()			do { } while (0)
-static inline void ftrace_release(void *start, unsigned long size) { }
+static inline void ftrace_release_mod(struct module *mod) {}
 static inline int register_ftrace_command(struct ftrace_func_command *cmd)
 {
 	return -EINVAL;
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 46592fe..f136fe5 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1074,14 +1074,9 @@ static void ftrace_replace_code(int enable)
 		failed = __ftrace_replace_code(rec, enable);
 		if (failed) {
 			rec->flags |= FTRACE_FL_FAILED;
-			if ((system_state == SYSTEM_BOOTING) ||
-			    !core_kernel_text(rec->ip)) {
-				ftrace_free_rec(rec);
-				} else {
-				ftrace_bug(failed, rec->ip);
-					/* Stop processing */
-					return;
-				}
+			ftrace_bug(failed, rec->ip);
+			/* Stop processing */
+			return;
 		}
 	} while_for_each_ftrace_rec();
 }
@@ -2658,19 +2653,17 @@ static int ftrace_convert_nops(struct module *mod,
 }
 
 #ifdef CONFIG_MODULES
-void ftrace_release(void *start, void *end)
+void ftrace_release_mod(struct module *mod)
 {
 	struct dyn_ftrace *rec;
 	struct ftrace_page *pg;
-	unsigned long s = (unsigned long)start;
-	unsigned long e = (unsigned long)end;
 
-	if (ftrace_disabled || !start || start == end)
+	if (ftrace_disabled)
 		return;
 
 	mutex_lock(&ftrace_lock);
 	do_for_each_ftrace_rec(pg, rec) {
-		if ((rec->ip >= s) && (rec->ip < e)) {
+		if (within_module_core(rec->ip, mod)) {
 			/*
 			 * rec->ip is changed in ftrace_free_rec()
 			 * It should not between s and e if record was freed.
@@ -2702,9 +2695,7 @@ static int ftrace_module_notify(struct notifier_block *self,
 				   mod->num_ftrace_callsites);
 		break;
 	case MODULE_STATE_GOING:
-		ftrace_release(mod->ftrace_callsites,
-			       mod->ftrace_callsites +
-			       mod->num_ftrace_callsites);
+		ftrace_release_mod(mod);
 		break;
 	}
 
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 7a7a9fd..4a194f0 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -34,6 +34,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 	struct trace_array *tr = branch_tracer;
 	struct ring_buffer_event *event;
 	struct trace_branch *entry;
+	struct ring_buffer *buffer;
 	unsigned long flags;
 	int cpu, pc;
 	const char *p;
@@ -54,7 +55,8 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 		goto out;
 
 	pc = preempt_count();
-	event = trace_buffer_lock_reserve(tr, TRACE_BRANCH,
+	buffer = tr->buffer;
+	event = trace_buffer_lock_reserve(buffer, TRACE_BRANCH,
 					  sizeof(*entry), flags, pc);
 	if (!event)
 		goto out;
@@ -74,8 +76,8 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 	entry->line = f->line;
 	entry->correct = val == expect;
 
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, buffer, event))
+		ring_buffer_unlock_commit(buffer, event);
 
  out:
 	atomic_dec(&tr->data[cpu]->disabled);
diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index dd44b87..8d5c171 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -31,7 +31,7 @@ static int ftrace_profile_enable_event(struct ftrace_event_call *event)
 	if (atomic_inc_return(&event->profile_count))
 		return 0;
 
-	if (!total_profile_count++) {
+	if (!total_profile_count) {
 		buf = (char *)alloc_percpu(profile_buf_t);
 		if (!buf)
 			goto fail_buf;
@@ -46,14 +46,19 @@ static int ftrace_profile_enable_event(struct ftrace_event_call *event)
 	}
 
 	ret = event->profile_enable();
-	if (!ret)
+	if (!ret) {
+		total_profile_count++;
 		return 0;
+	}
 
-	kfree(trace_profile_buf_nmi);
 fail_buf_nmi:
-	kfree(trace_profile_buf);
+	if (!total_profile_count) {
+		free_percpu(trace_profile_buf_nmi);
+		free_percpu(trace_profile_buf);
+		trace_profile_buf_nmi = NULL;
+		trace_profile_buf = NULL;
+	}
 fail_buf:
-	total_profile_count--;
 	atomic_dec(&event->profile_count);
 
 	return ret;
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index 23b6385..69543a9 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -165,6 +165,7 @@ void trace_hw_branch(u64 from, u64 to)
 	struct ftrace_event_call *call = &event_hw_branch;
 	struct trace_array *tr = hw_branch_trace;
 	struct ring_buffer_event *event;
+	struct ring_buffer *buf;
 	struct hw_branch_entry *entry;
 	unsigned long irq1;
 	int cpu;
@@ -180,7 +181,8 @@ void trace_hw_branch(u64 from, u64 to)
 	if (atomic_inc_return(&tr->data[cpu]->disabled) != 1)
 		goto out;
 
-	event = trace_buffer_lock_reserve(tr, TRACE_HW_BRANCHES,
+	buf = tr->buffer;
+	event = trace_buffer_lock_reserve(buf, TRACE_HW_BRANCHES,
 					  sizeof(*entry), 0, 0);
 	if (!event)
 		goto out;
@@ -189,8 +191,8 @@ void trace_hw_branch(u64 from, u64 to)
 	entry->ent.type = TRACE_HW_BRANCHES;
 	entry->from = from;
 	entry->to   = to;
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		trace_buffer_unlock_commit(tr, event, 0, 0);
+	if (!filter_check_discard(call, entry, buf, event))
+		trace_buffer_unlock_commit(buf, event, 0, 0);
 
  out:
 	atomic_dec(&tr->data[cpu]->disabled);
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index f572f44..ed17565 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -486,16 +486,18 @@ int trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
 				hardirq ? 'h' : softirq ? 's' : '.'))
 		return 0;
 
-	if (entry->lock_depth < 0)
-		ret = trace_seq_putc(s, '.');
+	if (entry->preempt_count)
+		ret = trace_seq_printf(s, "%x", entry->preempt_count);
 	else
-		ret = trace_seq_printf(s, "%d", entry->lock_depth);
+		ret = trace_seq_putc(s, '.');
+
 	if (!ret)
 		return 0;
 
-	if (entry->preempt_count)
-		return trace_seq_printf(s, "%x", entry->preempt_count);
-	return trace_seq_putc(s, '.');
+	if (entry->lock_depth < 0)
+		return trace_seq_putc(s, '.');
+
+	return trace_seq_printf(s, "%d", entry->lock_depth);
 }
 
 static int
@@ -883,7 +885,7 @@ static int trace_ctxwake_raw(struct trace_iterator *iter, char S)
 	trace_assign_type(field, iter->ent);
 
 	if (!S)
-		task_state_char(field->prev_state);
+		S = task_state_char(field->prev_state);
 	T = task_state_char(field->next_state);
 	if (!trace_seq_printf(&iter->seq, "%d %d %c %d %d %d %c\n",
 			      field->prev_pid,
@@ -918,7 +920,7 @@ static int trace_ctxwake_hex(struct trace_iterator *iter, char S)
 	trace_assign_type(field, iter->ent);
 
 	if (!S)
-		task_state_char(field->prev_state);
+		S = task_state_char(field->prev_state);
 	T = task_state_char(field->next_state);
 
 	SEQ_PUT_HEX_FIELD_RET(s, field->prev_pid);
