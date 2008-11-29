Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbYK2TfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbYK2TfO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 14:35:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbYK2TfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 14:35:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34786 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbYK2Te7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 14:34:59 -0500
Date: Sat, 29 Nov 2008 20:34:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [git pull] tracing fixes
Message-ID: <20081129193447.GA26074@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
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
Lai Jiangshan (1):
      ftrace: prevent recursion

Liming Wang (1):
      function tracing: fix wrong position computing of stack_trace

Pekka Paalanen (2):
      x86, mmiotrace: fix buffer overrun detection
      tracing, doc: update mmiotrace documentation


 Documentation/tracers/mmiotrace.txt |    6 ++++--
 kernel/trace/ring_buffer.c          |    2 +-
 kernel/trace/trace_mmiotrace.c      |   16 +++++++---------
 kernel/trace/trace_stack.c          |   24 +++++++++++++++---------
 4 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/Documentation/tracers/mmiotrace.txt b/Documentation/tracers/mmiotrace.txt
index 5bbbe20..cde23b4 100644
--- a/Documentation/tracers/mmiotrace.txt
+++ b/Documentation/tracers/mmiotrace.txt
@@ -37,7 +37,7 @@ $ echo mmiotrace > /debug/tracing/current_tracer
 $ cat /debug/tracing/trace_pipe > mydump.txt &
 Start X or whatever.
 $ echo "X is up" > /debug/tracing/trace_marker
-$ echo none > /debug/tracing/current_tracer
+$ echo nop > /debug/tracing/current_tracer
 Check for lost events.
 
 
@@ -66,7 +66,7 @@ which action. It is recommended to place descriptive markers about what you
 do.
 
 Shut down mmiotrace (requires root privileges):
-$ echo none > /debug/tracing/current_tracer
+$ echo nop > /debug/tracing/current_tracer
 The 'cat' process exits. If it does not, kill it by issuing 'fg' command and
 pressing ctrl+c.
 
@@ -81,7 +81,9 @@ are:
 $ cat /debug/tracing/trace_entries
 gives you a number. Approximately double this number and write it back, for
 instance:
+$ echo 0 > /debug/tracing/tracing_enabled
 $ echo 128000 > /debug/tracing/trace_entries
+$ echo 1 > /debug/tracing/tracing_enabled
 Then start again from the top.
 
 If you are doing a trace for a driver project, e.g. Nouveau, you should also
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index f780e95..668bbb5 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1215,7 +1215,7 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer,
 
  out:
 	if (resched)
-		preempt_enable_notrace();
+		preempt_enable_no_resched_notrace();
 	else
 		preempt_enable_notrace();
 	return NULL;
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index f284846..e62cbf7 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -18,12 +18,14 @@ struct header_iter {
 
 static struct trace_array *mmio_trace_array;
 static bool overrun_detected;
+static unsigned long prev_overruns;
 
 static void mmio_reset_data(struct trace_array *tr)
 {
 	int cpu;
 
 	overrun_detected = false;
+	prev_overruns = 0;
 	tr->time_start = ftrace_now(tr->cpu);
 
 	for_each_online_cpu(cpu)
@@ -128,16 +130,12 @@ static void mmio_close(struct trace_iterator *iter)
 
 static unsigned long count_overruns(struct trace_iterator *iter)
 {
-	int cpu;
 	unsigned long cnt = 0;
-/* FIXME: */
-#if 0
-	for_each_online_cpu(cpu) {
-		cnt += iter->overrun[cpu];
-		iter->overrun[cpu] = 0;
-	}
-#endif
-	(void)cpu;
+	unsigned long over = ring_buffer_overruns(iter->tr->buffer);
+
+	if (over > prev_overruns)
+		cnt = over - prev_overruns;
+	prev_overruns = over;
 	return cnt;
 }
 
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index be682b6..3bdb44b 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -184,11 +184,16 @@ static struct file_operations stack_max_size_fops = {
 static void *
 t_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	long i = (long)m->private;
+	long i;
 
 	(*pos)++;
 
-	i++;
+	if (v == SEQ_START_TOKEN)
+		i = 0;
+	else {
+		i = *(long *)v;
+		i++;
+	}
 
 	if (i >= max_stack_trace.nr_entries ||
 	    stack_dump_trace[i] == ULONG_MAX)
@@ -201,12 +206,15 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 
 static void *t_start(struct seq_file *m, loff_t *pos)
 {
-	void *t = &m->private;
+	void *t = SEQ_START_TOKEN;
 	loff_t l = 0;
 
 	local_irq_disable();
 	__raw_spin_lock(&max_stack_lock);
 
+	if (*pos == 0)
+		return SEQ_START_TOKEN;
+
 	for (; t && l < *pos; t = t_next(m, t, &l))
 		;
 
@@ -235,10 +243,10 @@ static int trace_lookup_stack(struct seq_file *m, long i)
 
 static int t_show(struct seq_file *m, void *v)
 {
-	long i = *(long *)v;
+	long i;
 	int size;
 
-	if (i < 0) {
+	if (v == SEQ_START_TOKEN) {
 		seq_printf(m, "        Depth   Size      Location"
 			   "    (%d entries)\n"
 			   "        -----   ----      --------\n",
@@ -246,6 +254,8 @@ static int t_show(struct seq_file *m, void *v)
 		return 0;
 	}
 
+	i = *(long *)v;
+
 	if (i >= max_stack_trace.nr_entries ||
 	    stack_dump_trace[i] == ULONG_MAX)
 		return 0;
@@ -275,10 +285,6 @@ static int stack_trace_open(struct inode *inode, struct file *file)
 	int ret;
 
 	ret = seq_open(file, &stack_trace_seq_ops);
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-		m->private = (void *)-1;
-	}
 
 	return ret;
 }
