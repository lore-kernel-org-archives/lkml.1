Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930Ab0AaRXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab0AaRXr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 12:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091Ab0AaRXq
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 12:23:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44077 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab0AaRXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 12:23:45 -0500
Date: Sun, 31 Jan 2010 18:23:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] tracing fixes
Message-ID: <20100131172337.GA32066@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
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
Mike Frysinger (1):
      tracing/documentation: Cover new frame pointer semantics

Steven Rostedt (3):
      tracing: Prevent kernel oops with corrupted buffer
      ring-buffer: Check if ring buffer iterator has stale data
      ring-buffer: Check for end of page in iterator

Yang Hongyang (1):
      tracing/documentation: Fix a typo in ftrace.txt


 Documentation/trace/ftrace-design.txt |   26 +++++++++++++++++++++++---
 Documentation/trace/ftrace.txt        |    2 +-
 kernel/trace/Kconfig                  |    4 +---
 kernel/trace/ring_buffer.c            |   24 +++++++++++++++++++++---
 kernel/trace/trace.c                  |    5 +++++
 5 files changed, 51 insertions(+), 10 deletions(-)

diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
index 239f14b..6a5a579 100644
--- a/Documentation/trace/ftrace-design.txt
+++ b/Documentation/trace/ftrace-design.txt
@@ -1,5 +1,6 @@
 		function tracer guts
 		====================
+		By Mike Frysinger
 
 Introduction
 ------------
@@ -173,14 +174,16 @@ void ftrace_graph_caller(void)
 
 	unsigned long *frompc = &...;
 	unsigned long selfpc = <return address> - MCOUNT_INSN_SIZE;
-	prepare_ftrace_return(frompc, selfpc);
+	/* passing frame pointer up is optional -- see below */
+	prepare_ftrace_return(frompc, selfpc, frame_pointer);
 
 	/* restore all state needed by the ABI */
 }
 #endif
 
-For information on how to implement prepare_ftrace_return(), simply look at
-the x86 version.  The only architecture-specific piece in it is the setup of
+For information on how to implement prepare_ftrace_return(), simply look at the
+x86 version (the frame pointer passing is optional; see the next section for
+more information).  The only architecture-specific piece in it is the setup of
 the fault recovery table (the asm(...) code).  The rest should be the same
 across architectures.
 
@@ -205,6 +208,23 @@ void return_to_handler(void)
 #endif
 
 
+HAVE_FUNCTION_GRAPH_FP_TEST
+---------------------------
+
+An arch may pass in a unique value (frame pointer) to both the entering and
+exiting of a function.  On exit, the value is compared and if it does not
+match, then it will panic the kernel.  This is largely a sanity check for bad
+code generation with gcc.  If gcc for your port sanely updates the frame
+pointer under different opitmization levels, then ignore this option.
+
+However, adding support for it isn't terribly difficult.  In your assembly code
+that calls prepare_ftrace_return(), pass the frame pointer as the 3rd argument.
+Then in the C version of that function, do what the x86 port does and pass it
+along to ftrace_push_return_trace() instead of a stub value of 0.
+
+Similarly, when you call ftrace_return_to_handler(), pass it the frame pointer.
+
+
 HAVE_FTRACE_NMI_ENTER
 ---------------------
 
diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 8179692..bab3040 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -1625,7 +1625,7 @@ If I am only interested in sys_nanosleep and hrtimer_interrupt:
 
  # echo sys_nanosleep hrtimer_interrupt \
 		> set_ftrace_filter
- # echo ftrace > current_tracer
+ # echo function > current_tracer
  # echo 1 > tracing_enabled
  # usleep 1
  # echo 0 > tracing_enabled
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 6c22d8a..60e2ce0 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -27,9 +27,7 @@ config HAVE_FUNCTION_GRAPH_TRACER
 config HAVE_FUNCTION_GRAPH_FP_TEST
 	bool
 	help
-	 An arch may pass in a unique value (frame pointer) to both the
-	 entering and exiting of a function. On exit, the value is compared
-	 and if it does not match, then it will panic the kernel.
+	  See Documentation/trace/ftrace-design.txt
 
 config HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	bool
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index edefe3b..8c1b2d2 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -464,6 +464,8 @@ struct ring_buffer_iter {
 	struct ring_buffer_per_cpu	*cpu_buffer;
 	unsigned long			head;
 	struct buffer_page		*head_page;
+	struct buffer_page		*cache_reader_page;
+	unsigned long			cache_read;
 	u64				read_stamp;
 };
 
@@ -2716,6 +2718,8 @@ static void rb_iter_reset(struct ring_buffer_iter *iter)
 		iter->read_stamp = cpu_buffer->read_stamp;
 	else
 		iter->read_stamp = iter->head_page->page->time_stamp;
+	iter->cache_reader_page = cpu_buffer->reader_page;
+	iter->cache_read = cpu_buffer->read;
 }
 
 /**
@@ -3060,13 +3064,22 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 	struct ring_buffer_event *event;
 	int nr_loops = 0;
 
-	if (ring_buffer_iter_empty(iter))
-		return NULL;
-
 	cpu_buffer = iter->cpu_buffer;
 	buffer = cpu_buffer->buffer;
 
+	/*
+	 * Check if someone performed a consuming read to
+	 * the buffer. A consuming read invalidates the iterator
+	 * and we need to reset the iterator in this case.
+	 */
+	if (unlikely(iter->cache_read != cpu_buffer->read ||
+		     iter->cache_reader_page != cpu_buffer->reader_page))
+		rb_iter_reset(iter);
+
  again:
+	if (ring_buffer_iter_empty(iter))
+		return NULL;
+
 	/*
 	 * We repeat when a timestamp is encountered.
 	 * We can get multiple timestamps by nested interrupts or also
@@ -3081,6 +3094,11 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 	if (rb_per_cpu_empty(cpu_buffer))
 		return NULL;
 
+	if (iter->head >= local_read(&iter->head_page->page->commit)) {
+		rb_inc_iter(iter);
+		goto again;
+	}
+
 	event = rb_iter_head_event(iter);
 
 	switch (event->type_len) {
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0df1b0f..eac6875 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -951,6 +951,11 @@ void trace_find_cmdline(int pid, char comm[])
 		return;
 	}
 
+	if (WARN_ON_ONCE(pid < 0)) {
+		strcpy(comm, "<XXX>");
+		return;
+	}
+
 	if (pid > PID_MAX_DEFAULT) {
 		strcpy(comm, "<...>");
 		return;
