Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbYKCSDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbYKCSDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 13:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbYKCSDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 13:03:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50330 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbYKCSDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 13:03:41 -0500
Date: Mon, 3 Nov 2008 19:03:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [git pull] tracing fixes
Message-ID: <20081103180328.GA20434@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Al Viro (1):
      tracing, alpha: undefined reference to `save_stack_trace'

Steven Rostedt (2):
      ftrace: use kretprobe trampoline name to test in output
      tracing, ring-buffer: add paranoid checks for loops


 kernel/trace/Kconfig       |    2 +-
 kernel/trace/ring_buffer.c |   56 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.c       |   41 ++++++++++++++++++--------------
 3 files changed, 80 insertions(+), 19 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index b58f43b..33dbefd 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -25,7 +25,7 @@ config TRACING
 	bool
 	select DEBUG_FS
 	select RING_BUFFER
-	select STACKTRACE
+	select STACKTRACE if STACKTRACE_SUPPORT
 	select TRACEPOINTS
 	select NOP_TRACER
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index cedf4e2..3f33806 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1022,8 +1022,23 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 	struct ring_buffer_event *event;
 	u64 ts, delta;
 	int commit = 0;
+	int nr_loops = 0;
 
  again:
+	/*
+	 * We allow for interrupts to reenter here and do a trace.
+	 * If one does, it will cause this original code to loop
+	 * back here. Even with heavy interrupts happening, this
+	 * should only happen a few times in a row. If this happens
+	 * 1000 times in a row, there must be either an interrupt
+	 * storm or we have something buggy.
+	 * Bail!
+	 */
+	if (unlikely(++nr_loops > 1000)) {
+		RB_WARN_ON(cpu_buffer, 1);
+		return NULL;
+	}
+
 	ts = ring_buffer_time_stamp(cpu_buffer->cpu);
 
 	/*
@@ -1532,10 +1547,23 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	struct buffer_page *reader = NULL;
 	unsigned long flags;
+	int nr_loops = 0;
 
 	spin_lock_irqsave(&cpu_buffer->lock, flags);
 
  again:
+	/*
+	 * This should normally only loop twice. But because the
+	 * start of the reader inserts an empty page, it causes
+	 * a case where we will loop three times. There should be no
+	 * reason to loop four times (that I know of).
+	 */
+	if (unlikely(++nr_loops > 3)) {
+		RB_WARN_ON(cpu_buffer, 1);
+		reader = NULL;
+		goto out;
+	}
+
 	reader = cpu_buffer->reader_page;
 
 	/* If there's more to read, return this page */
@@ -1665,6 +1693,7 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
 	struct buffer_page *reader;
+	int nr_loops = 0;
 
 	if (!cpu_isset(cpu, buffer->cpumask))
 		return NULL;
@@ -1672,6 +1701,19 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	cpu_buffer = buffer->buffers[cpu];
 
  again:
+	/*
+	 * We repeat when a timestamp is encountered. It is possible
+	 * to get multiple timestamps from an interrupt entering just
+	 * as one timestamp is about to be written. The max times
+	 * that this can happen is the number of nested interrupts we
+	 * can have.  Nesting 10 deep of interrupts is clearly
+	 * an anomaly.
+	 */
+	if (unlikely(++nr_loops > 10)) {
+		RB_WARN_ON(cpu_buffer, 1);
+		return NULL;
+	}
+
 	reader = rb_get_reader_page(cpu_buffer);
 	if (!reader)
 		return NULL;
@@ -1722,6 +1764,7 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 	struct ring_buffer *buffer;
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
+	int nr_loops = 0;
 
 	if (ring_buffer_iter_empty(iter))
 		return NULL;
@@ -1730,6 +1773,19 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 	buffer = cpu_buffer->buffer;
 
  again:
+	/*
+	 * We repeat when a timestamp is encountered. It is possible
+	 * to get multiple timestamps from an interrupt entering just
+	 * as one timestamp is about to be written. The max times
+	 * that this can happen is the number of nested interrupts we
+	 * can have. Nesting 10 deep of interrupts is clearly
+	 * an anomaly.
+	 */
+	if (unlikely(++nr_loops > 10)) {
+		RB_WARN_ON(cpu_buffer, 1);
+		return NULL;
+	}
+
 	if (rb_per_cpu_empty(cpu_buffer))
 		return NULL;
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8a499e2..9f3b478 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -705,6 +705,7 @@ static void ftrace_trace_stack(struct trace_array *tr,
 			       unsigned long flags,
 			       int skip, int pc)
 {
+#ifdef CONFIG_STACKTRACE
 	struct ring_buffer_event *event;
 	struct stack_entry *entry;
 	struct stack_trace trace;
@@ -730,6 +731,7 @@ static void ftrace_trace_stack(struct trace_array *tr,
 
 	save_stack_trace(&trace);
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+#endif
 }
 
 void __trace_stack(struct trace_array *tr,
@@ -1086,17 +1088,20 @@ static void s_stop(struct seq_file *m, void *p)
 	mutex_unlock(&trace_types_lock);
 }
 
-#define KRETPROBE_MSG "[unknown/kretprobe'd]"
-
 #ifdef CONFIG_KRETPROBES
-static inline int kretprobed(unsigned long addr)
+static inline const char *kretprobed(const char *name)
 {
-	return addr == (unsigned long)kretprobe_trampoline;
+	static const char tramp_name[] = "kretprobe_trampoline";
+	int size = sizeof(tramp_name);
+
+	if (strncmp(tramp_name, name, size) == 0)
+		return "[unknown/kretprobe'd]";
+	return name;
 }
 #else
-static inline int kretprobed(unsigned long addr)
+static inline const char *kretprobed(const char *name)
 {
-	return 0;
+	return name;
 }
 #endif /* CONFIG_KRETPROBES */
 
@@ -1105,10 +1110,13 @@ seq_print_sym_short(struct trace_seq *s, const char *fmt, unsigned long address)
 {
 #ifdef CONFIG_KALLSYMS
 	char str[KSYM_SYMBOL_LEN];
+	const char *name;
 
 	kallsyms_lookup(address, NULL, NULL, NULL, str);
 
-	return trace_seq_printf(s, fmt, str);
+	name = kretprobed(str);
+
+	return trace_seq_printf(s, fmt, name);
 #endif
 	return 1;
 }
@@ -1119,9 +1127,12 @@ seq_print_sym_offset(struct trace_seq *s, const char *fmt,
 {
 #ifdef CONFIG_KALLSYMS
 	char str[KSYM_SYMBOL_LEN];
+	const char *name;
 
 	sprint_symbol(str, address);
-	return trace_seq_printf(s, fmt, str);
+	name = kretprobed(str);
+
+	return trace_seq_printf(s, fmt, name);
 #endif
 	return 1;
 }
@@ -1375,10 +1386,7 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 
 		seq_print_ip_sym(s, field->ip, sym_flags);
 		trace_seq_puts(s, " (");
-		if (kretprobed(field->parent_ip))
-			trace_seq_puts(s, KRETPROBE_MSG);
-		else
-			seq_print_ip_sym(s, field->parent_ip, sym_flags);
+		seq_print_ip_sym(s, field->parent_ip, sym_flags);
 		trace_seq_puts(s, ")\n");
 		break;
 	}
@@ -1494,12 +1502,9 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 			ret = trace_seq_printf(s, " <-");
 			if (!ret)
 				return TRACE_TYPE_PARTIAL_LINE;
-			if (kretprobed(field->parent_ip))
-				ret = trace_seq_puts(s, KRETPROBE_MSG);
-			else
-				ret = seq_print_ip_sym(s,
-						       field->parent_ip,
-						       sym_flags);
+			ret = seq_print_ip_sym(s,
+					       field->parent_ip,
+					       sym_flags);
 			if (!ret)
 				return TRACE_TYPE_PARTIAL_LINE;
 		}
