Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbZBSRIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbZBSRIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 12:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZBSRIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 12:08:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60230 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbZBSRIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 12:08:34 -0500
Date: Thu, 19 Feb 2009 18:08:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [git pull] tracing fixes
Message-ID: <20090219170818.GA27350@elte.hu>
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
Frederic Weisbecker (1):
      tracing/function-graph-tracer: trace the idle tasks

Steven Rostedt (3):
      tracing: disable tracing while testing ring buffer
      tracing: have function trace select kallsyms
      tracing: limit the number of loops the ring buffer self test can make


 kernel/trace/Kconfig          |    2 ++
 kernel/trace/ftrace.c         |    6 +++++-
 kernel/trace/trace_selftest.c |   19 +++++++++++++++++++
 3 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 58a93fb..34e707e 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -52,6 +52,7 @@ config FUNCTION_TRACER
 	depends on HAVE_FUNCTION_TRACER
 	depends on DEBUG_KERNEL
 	select FRAME_POINTER
+	select KALLSYMS
 	select TRACING
 	select CONTEXT_SWITCH_TRACER
 	help
@@ -238,6 +239,7 @@ config STACK_TRACER
 	depends on DEBUG_KERNEL
 	select FUNCTION_TRACER
 	select STACKTRACE
+	select KALLSYMS
 	help
 	  This special tracer records the maximum stack footprint of the
 	  kernel and displays it in debugfs/tracing/stack_trace.
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9a236ff..fdf913d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2033,7 +2033,7 @@ free:
 static int start_graph_tracing(void)
 {
 	struct ftrace_ret_stack **ret_stack_list;
-	int ret;
+	int ret, cpu;
 
 	ret_stack_list = kmalloc(FTRACE_RETSTACK_ALLOC_SIZE *
 				sizeof(struct ftrace_ret_stack *),
@@ -2042,6 +2042,10 @@ static int start_graph_tracing(void)
 	if (!ret_stack_list)
 		return -ENOMEM;
 
+	/* The cpu_boot init_task->ret_stack will never be freed */
+	for_each_online_cpu(cpu)
+		ftrace_graph_init_task(idle_task(cpu));
+
 	do {
 		ret = alloc_retstack_tasklist(ret_stack_list);
 	} while (ret == -EAGAIN);
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 88c8eb7..bc8e80a 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -23,10 +23,20 @@ static int trace_test_buffer_cpu(struct trace_array *tr, int cpu)
 {
 	struct ring_buffer_event *event;
 	struct trace_entry *entry;
+	unsigned int loops = 0;
 
 	while ((event = ring_buffer_consume(tr->buffer, cpu, NULL))) {
 		entry = ring_buffer_event_data(event);
 
+		/*
+		 * The ring buffer is a size of trace_buf_size, if
+		 * we loop more than the size, there's something wrong
+		 * with the ring buffer.
+		 */
+		if (loops++ > trace_buf_size) {
+			printk(KERN_CONT ".. bad ring buffer ");
+			goto failed;
+		}
 		if (!trace_valid_entry(entry)) {
 			printk(KERN_CONT ".. invalid entry %d ",
 				entry->type);
@@ -57,11 +67,20 @@ static int trace_test_buffer(struct trace_array *tr, unsigned long *count)
 
 	cnt = ring_buffer_entries(tr->buffer);
 
+	/*
+	 * The trace_test_buffer_cpu runs a while loop to consume all data.
+	 * If the calling tracer is broken, and is constantly filling
+	 * the buffer, this will run forever, and hard lock the box.
+	 * We disable the ring buffer while we do this test to prevent
+	 * a hard lock up.
+	 */
+	tracing_off();
 	for_each_possible_cpu(cpu) {
 		ret = trace_test_buffer_cpu(tr, cpu);
 		if (ret)
 			break;
 	}
+	tracing_on();
 	__raw_spin_unlock(&ftrace_max_lock);
 	local_irq_restore(flags);
 
