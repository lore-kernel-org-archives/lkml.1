Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760AbZGJQZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbZGJQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 12:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbZGJQZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 12:25:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60434 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbZGJQZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 12:25:13 -0400
Date: Fri, 10 Jul 2009 18:25:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] tracing fixes
Message-ID: <20090710162503.GA25705@elte.hu>
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
Lai Jiangshan (1):
      trace_export: Repair missed fields

Li Zefan (2):
      tracing: Fix stack tracer sysctl handling
      tracing/fastboot: Document the need of initcall_debug

Masami Hiramatsu (1):
      kprobes: No need to unlock kprobe_insn_mutex

Xiao Guangrong (1):
      tracing: Fix trace_print_seq()


 kernel/kprobes.c                 |    6 +-----
 kernel/trace/Kconfig             |    6 +++---
 kernel/trace/ftrace.c            |    4 ++--
 kernel/trace/trace_event_types.h |    3 +++
 kernel/trace/trace_output.c      |    3 +--
 kernel/trace/trace_stack.c       |    4 ++--
 6 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index c0fa54b..16b5739 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -237,13 +237,9 @@ static int __kprobes collect_garbage_slots(void)
 {
 	struct kprobe_insn_page *kip;
 	struct hlist_node *pos, *next;
-	int safety;
 
 	/* Ensure no-one is preepmted on the garbages */
-	mutex_unlock(&kprobe_insn_mutex);
-	safety = check_safety();
-	mutex_lock(&kprobe_insn_mutex);
-	if (safety != 0)
+	if (check_safety())
 		return -EAGAIN;
 
 	hlist_for_each_entry_safe(kip, pos, next, &kprobe_insn_pages, hlist) {
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 1551f47..019f380 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -226,13 +226,13 @@ config BOOT_TRACER
 	  the timings of the initcalls and traces key events and the identity
 	  of tasks that can cause boot delays, such as context-switches.
 
-	  Its aim is to be parsed by the /scripts/bootgraph.pl tool to
+	  Its aim is to be parsed by the scripts/bootgraph.pl tool to
 	  produce pretty graphics about boot inefficiencies, giving a visual
 	  representation of the delays during initcalls - but the raw
 	  /debug/tracing/trace text output is readable too.
 
-	  You must pass in ftrace=initcall to the kernel command line
-	  to enable this on bootup.
+	  You must pass in initcall_debug and ftrace=initcall to the kernel
+	  command line to enable this on bootup.
 
 config TRACE_BRANCH_PROFILING
 	bool
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f3716bf..bce9e01 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3160,10 +3160,10 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 
 	ret  = proc_dointvec(table, write, file, buffer, lenp, ppos);
 
-	if (ret || !write || (last_ftrace_enabled == ftrace_enabled))
+	if (ret || !write || (last_ftrace_enabled == !!ftrace_enabled))
 		goto out;
 
-	last_ftrace_enabled = ftrace_enabled;
+	last_ftrace_enabled = !!ftrace_enabled;
 
 	if (ftrace_enabled) {
 
diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
index 5e32e37..6db005e 100644
--- a/kernel/trace/trace_event_types.h
+++ b/kernel/trace/trace_event_types.h
@@ -26,6 +26,9 @@ TRACE_EVENT_FORMAT(funcgraph_exit, TRACE_GRAPH_RET,
 		   ftrace_graph_ret_entry, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(unsigned long, ret.func, func)
+		TRACE_FIELD(unsigned long long, ret.calltime, calltime)
+		TRACE_FIELD(unsigned long long, ret.rettime, rettime)
+		TRACE_FIELD(unsigned long, ret.overrun, overrun)
 		TRACE_FIELD(int, ret.depth, depth)
 	),
 	TP_RAW_FMT("<-- %lx (%d)")
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 7938f3a..e0c2545 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -27,8 +27,7 @@ void trace_print_seq(struct seq_file *m, struct trace_seq *s)
 {
 	int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
 
-	s->buffer[len] = 0;
-	seq_puts(m, s->buffer);
+	seq_write(m, s->buffer, len);
 
 	trace_seq_init(s);
 }
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 2d7aebd..e644af9 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -326,10 +326,10 @@ stack_trace_sysctl(struct ctl_table *table, int write,
 	ret = proc_dointvec(table, write, file, buffer, lenp, ppos);
 
 	if (ret || !write ||
-	    (last_stack_tracer_enabled == stack_tracer_enabled))
+	    (last_stack_tracer_enabled == !!stack_tracer_enabled))
 		goto out;
 
-	last_stack_tracer_enabled = stack_tracer_enabled;
+	last_stack_tracer_enabled = !!stack_tracer_enabled;
 
 	if (stack_tracer_enabled)
 		register_ftrace_function(&trace_ops);
