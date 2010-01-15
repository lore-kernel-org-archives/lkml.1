Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab0AONQR (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 08:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755421Ab0AONQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 08:16:16 -0500
Received: from mail.windriver.com ([147.11.1.11]:53927 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab0AONQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 08:16:15 -0500
Message-ID: <4B506A88.9030906@windriver.com>
Date: Fri, 15 Jan 2010 07:15:52 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        mingo@elte.hu
Subject: Re: [PATCH 40/40] ftrace,kdb: Extend kdb to be able to dump the ftrace
 buffer
References: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com> <1263481176-1897-41-git-send-email-jason.wessel@windriver.com> <1263514466.28171.3965.camel@gandalf.stny.rr.com>
In-Reply-To: <1263514466.28171.3965.camel@gandalf.stny.rr.com>
Content-Type: multipart/mixed;
 boundary="------------080401070309030909000205"
X-OriginalArrivalTime: 15 Jan 2010 13:15:53.0182 (UTC) FILETIME=[DD53CFE0:01CA95E4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080401070309030909000205
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Steven Rostedt wrote:
> On Thu, 2010-01-14 at 08:59 -0600, Jason Wessel wrote:
>   
>> Add in a helper function to allow the kdb shell to dump the ftrace
>> buffer.
>>
>>     
>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
>
>
> If this is the final version, I could queue it up in my tree for 34, and
> push it off to Ingo.
>   

Attached is the final version.  I moved the minor doc update and folded
it into the main docs patch.  There are no code changes, and now the
patch should cleanly apply independent of anything else.  The patch will
be dropped from kgdb-next as of today.

Please, let me know where the tree lives that contains this patch and I
will continue to pull it into my local testing aimed for merging in 2.6.34.

Thanks,
Jason.

--------------080401070309030909000205
Content-Type: text/x-diff;
 name="ftrace_kdb.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ftrace_kdb.patch"

From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] ftrace,kdb: Extend kdb to be able to dump the ftrace buffer

Add in a helper function to allow the kdb shell to dump the ftrace
buffer.

Modify trace.c to expose the capability to iterate over the ftrace
buffer in a read only capacity.

CC: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 kernel/trace/Makefile    |    3 +
 kernel/trace/trace.c     |   48 ++++++++-----------
 kernel/trace/trace.h     |   17 ++++++
 kernel/trace/trace_kdb.c |  116 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 158 insertions(+), 26 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -100,14 +100,11 @@ static inline void ftrace_enable_cpu(voi
 	preempt_enable();
 }
 
-static cpumask_var_t __read_mostly	tracing_buffer_mask;
+cpumask_var_t __read_mostly	tracing_buffer_mask;
 
 /* Define which cpu buffers are currently read in trace_pipe */
 static cpumask_var_t			tracing_reader_cpumask;
 
-#define for_each_tracing_cpu(cpu)	\
-	for_each_cpu(cpu, tracing_buffer_mask)
-
 /*
  * ftrace_dump_on_oops - variable to dump ftrace buffer on oops
  *
@@ -1409,11 +1406,6 @@ int trace_vprintk(unsigned long ip, cons
 }
 EXPORT_SYMBOL_GPL(trace_vprintk);
 
-enum trace_file_type {
-	TRACE_FILE_LAT_FMT	= 1,
-	TRACE_FILE_ANNOTATE	= 2,
-};
-
 static void trace_iterator_increment(struct trace_iterator *iter)
 {
 	/* Don't allow ftrace to trace into the ring buffers */
@@ -1503,7 +1495,7 @@ struct trace_entry *trace_find_next_entr
 }
 
 /* Find the next real entry, and increment the iterator to the next entry */
-static void *find_next_entry_inc(struct trace_iterator *iter)
+void *trace_find_next_entry_inc(struct trace_iterator *iter)
 {
 	iter->ent = __find_next_entry(iter, &iter->cpu, &iter->ts);
 
@@ -1536,12 +1528,12 @@ static void *s_next(struct seq_file *m, 
 		return NULL;
 
 	if (iter->idx < 0)
-		ent = find_next_entry_inc(iter);
+		ent = trace_find_next_entry_inc(iter);
 	else
 		ent = iter;
 
 	while (ent && iter->idx < i)
-		ent = find_next_entry_inc(iter);
+		ent = trace_find_next_entry_inc(iter);
 
 	iter->pos = *pos;
 
@@ -1878,7 +1870,7 @@ static enum print_line_t print_bin_fmt(s
 	return event ? event->binary(iter, 0) : TRACE_TYPE_HANDLED;
 }
 
-static int trace_empty(struct trace_iterator *iter)
+int trace_empty(struct trace_iterator *iter)
 {
 	int cpu;
 
@@ -1909,7 +1901,7 @@ static int trace_empty(struct trace_iter
 }
 
 /*  Called with trace_event_read_lock() held. */
-static enum print_line_t print_trace_line(struct trace_iterator *iter)
+enum print_line_t print_trace_line(struct trace_iterator *iter)
 {
 	enum print_line_t ret;
 
@@ -3074,7 +3066,7 @@ waitagain:
 	iter->pos = -1;
 
 	trace_event_read_lock();
-	while (find_next_entry_inc(iter) != NULL) {
+	while (trace_find_next_entry_inc(iter) != NULL) {
 		enum print_line_t ret;
 		int len = iter->seq.len;
 
@@ -3156,7 +3148,7 @@ tracing_fill_pipe_page(size_t rem, struc
 		if (ret != TRACE_TYPE_NO_CONSUME)
 			trace_consume(iter);
 		rem -= count;
-		if (!find_next_entry_inc(iter))	{
+		if (!trace_find_next_entry_inc(iter))	{
 			rem = 0;
 			iter->ent = NULL;
 			break;
@@ -3209,7 +3201,7 @@ static ssize_t tracing_splice_read_pipe(
 	if (ret <= 0)
 		goto out_err;
 
-	if (!iter->ent && !find_next_entry_inc(iter)) {
+	if (!iter->ent && !trace_find_next_entry_inc(iter)) {
 		ret = -EFAULT;
 		goto out_err;
 	}
@@ -4262,7 +4254,7 @@ static struct notifier_block trace_die_n
  */
 #define KERN_TRACE		KERN_EMERG
 
-static void
+void
 trace_printk_seq(struct trace_seq *s)
 {
 	/* Probably should print a warning here. */
@@ -4277,6 +4269,13 @@ trace_printk_seq(struct trace_seq *s)
 	trace_seq_init(s);
 }
 
+void trace_init_global_iter(struct trace_iterator *iter)
+{
+	iter->tr = &global_trace;
+	iter->trace = current_trace;
+	iter->cpu_file = TRACE_PIPE_ALL_CPU;
+}
+
 static void __ftrace_dump(bool disable_tracing)
 {
 	static arch_spinlock_t ftrace_dump_lock =
@@ -4301,8 +4300,10 @@ static void __ftrace_dump(bool disable_t
 	if (disable_tracing)
 		ftrace_kill();
 
+	trace_init_global_iter(&iter);
+
 	for_each_tracing_cpu(cpu) {
-		atomic_inc(&global_trace.data[cpu]->disabled);
+		atomic_inc(&iter.tr->data[cpu]->disabled);
 	}
 
 	old_userobj = trace_flags & TRACE_ITER_SYM_USEROBJ;
@@ -4312,11 +4313,6 @@ static void __ftrace_dump(bool disable_t
 
 	printk(KERN_TRACE "Dumping ftrace buffer:\n");
 
-	/* Simulate the iterator */
-	iter.tr = &global_trace;
-	iter.trace = current_trace;
-	iter.cpu_file = TRACE_PIPE_ALL_CPU;
-
 	/*
 	 * We need to stop all tracing on all CPUS to read the
 	 * the next buffer. This is a bit expensive, but is
@@ -4338,7 +4334,7 @@ static void __ftrace_dump(bool disable_t
 		iter.iter_flags |= TRACE_FILE_LAT_FMT;
 		iter.pos = -1;
 
-		if (find_next_entry_inc(&iter) != NULL) {
+		if (trace_find_next_entry_inc(&iter) != NULL) {
 			int ret;
 
 			ret = print_trace_line(&iter);
@@ -4359,7 +4355,7 @@ static void __ftrace_dump(bool disable_t
 		trace_flags |= old_userobj;
 
 		for_each_tracing_cpu(cpu) {
-			atomic_dec(&global_trace.data[cpu]->disabled);
+			atomic_dec(&iter.tr->data[cpu]->disabled);
 		}
 		tracing_on();
 	}
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -56,5 +56,8 @@ obj-$(CONFIG_EVENT_TRACING) += trace_eve
 obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
 obj-$(CONFIG_KSYM_TRACER) += trace_ksym.o
 obj-$(CONFIG_EVENT_TRACING) += power-traces.o
+ifeq ($(CONFIG_TRACING),y)
+obj-$(CONFIG_KGDB_KDB) += trace_kdb.o
+endif
 
 libftrace-y := ftrace.o
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -352,6 +352,12 @@ struct trace_entry *tracing_get_trace_en
 struct trace_entry *trace_find_next_entry(struct trace_iterator *iter,
 					  int *ent_cpu, u64 *ent_ts);
 
+int trace_empty(struct trace_iterator *iter);
+
+void *trace_find_next_entry_inc(struct trace_iterator *iter);
+
+void trace_init_global_iter(struct trace_iterator *iter);
+
 void default_wait_pipe(struct trace_iterator *iter);
 void poll_wait_pipe(struct trace_iterator *iter);
 
@@ -391,6 +397,15 @@ void tracing_start_sched_switch_record(v
 int register_tracer(struct tracer *type);
 void unregister_tracer(struct tracer *type);
 int is_tracing_stopped(void);
+enum trace_file_type {
+	TRACE_FILE_LAT_FMT	= 1,
+	TRACE_FILE_ANNOTATE	= 2,
+};
+
+extern cpumask_var_t __read_mostly tracing_buffer_mask;
+
+#define for_each_tracing_cpu(cpu)	\
+	for_each_cpu(cpu, tracing_buffer_mask)
 
 extern int process_new_ksym_entry(char *ksymname, int op, unsigned long addr);
 
@@ -483,6 +498,8 @@ trace_array_vprintk(struct trace_array *
 		    unsigned long ip, const char *fmt, va_list args);
 int trace_array_printk(struct trace_array *tr,
 		       unsigned long ip, const char *fmt, ...);
+void trace_printk_seq(struct trace_seq *s);
+enum print_line_t print_trace_line(struct trace_iterator *iter);
 
 extern unsigned long trace_flags;
 
--- /dev/null
+++ b/kernel/trace/trace_kdb.c
@@ -0,0 +1,116 @@
+/*
+ * kdb helper for dumping the ftrace buffer
+ *
+ * Copyright (C) 2010 Jason Wessel <jason.wessel@windriver.com>
+ *
+ * ftrace_dump_buf based on ftrace_dump:
+ * Copyright (C) 2007-2008 Steven Rostedt <srostedt@redhat.com>
+ * Copyright (C) 2008 Ingo Molnar <mingo@redhat.com>
+ *
+ */
+#include <linux/init.h>
+#include <linux/kgdb.h>
+#include <linux/kdb.h>
+#include <linux/ftrace.h>
+
+#include "../debug/kdb/kdb_private.h"
+#include "trace.h"
+#include "trace_output.h"
+
+static void ftrace_dump_buf(int skip_lines)
+{
+	/* use static because iter can be a bit big for the stack */
+	static struct trace_iterator iter;
+	unsigned int old_userobj;
+	int cnt = 0, cpu;
+
+	trace_init_global_iter(&iter);
+
+	for_each_tracing_cpu(cpu) {
+		atomic_inc(&iter.tr->data[cpu]->disabled);
+	}
+
+	old_userobj = trace_flags;
+
+	/* don't look at user memory in panic mode */
+	trace_flags &= ~TRACE_ITER_SYM_USEROBJ;
+
+	kdb_printf("Dumping ftrace buffer:\n");
+
+	/* reset all but tr, trace, and overruns */
+	memset(&iter.seq, 0,
+		   sizeof(struct trace_iterator) -
+		   offsetof(struct trace_iterator, seq));
+	iter.iter_flags |= TRACE_FILE_LAT_FMT;
+	iter.pos = -1;
+
+	for_each_tracing_cpu(cpu)
+		iter.buffer_iter[cpu] =
+			ring_buffer_read_start(iter.tr->buffer, cpu);
+
+	if (!trace_empty(&iter))
+		trace_find_next_entry_inc(&iter);
+	while (!trace_empty(&iter)) {
+		if (!cnt)
+			kdb_printf("---------------------------------\n");
+		cnt++;
+
+		if (trace_find_next_entry_inc(&iter) != NULL && !skip_lines)
+			print_trace_line(&iter);
+		if (!skip_lines)
+			trace_printk_seq(&iter.seq);
+		else
+			skip_lines--;
+		if (KDB_FLAG(CMD_INTERRUPT))
+			goto out;
+	}
+
+	if (!cnt)
+		kdb_printf("   (ftrace buffer empty)\n");
+	else
+		kdb_printf("---------------------------------\n");
+
+out:
+	trace_flags = old_userobj;
+
+	for_each_tracing_cpu(cpu) {
+		atomic_dec(&iter.tr->data[cpu]->disabled);
+	}
+
+	for_each_tracing_cpu(cpu)
+		if (iter.buffer_iter[cpu])
+			ring_buffer_read_finish(iter.buffer_iter[cpu]);
+}
+
+/*
+ * kdb_ftdump - Dump the ftrace log buffer
+ */
+static int kdb_ftdump(int argc, const char **argv)
+{
+	int skip_lines = 0;
+	char *cp;
+
+	if (argc > 1)
+		return KDB_ARGCOUNT;
+
+	if (argc) {
+		skip_lines = simple_strtol(argv[1], &cp, 0);
+		if (*cp)
+			skip_lines = 0;
+	}
+
+	kdb_trap_printk++;
+	ftrace_dump_buf(skip_lines);
+	kdb_trap_printk--;
+
+	return 0;
+}
+
+static __init int kdb_ftrace_register(void)
+{
+	kdb_register_repeat("ftdump", kdb_ftdump, "", "Dump ftrace log",
+			    0, KDB_REPEAT_NONE);
+	return 0;
+}
+
+late_initcall(kdb_ftrace_register);

--------------080401070309030909000205--
