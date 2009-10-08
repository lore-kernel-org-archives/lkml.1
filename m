Return-Path: <linux-kernel-owner+w=401wt.eu-S933062AbZJHSim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062AbZJHSim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 14:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933030AbZJHSim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 14:38:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42848 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932918AbZJHSil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 14:38:41 -0400
Date: Thu, 8 Oct 2009 20:37:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] perf events fixes
Message-ID: <20091008183752.GA11323@elte.hu>
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

Please pull the latest perf-fixes-for-linus-2 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus-2

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      perf tools: elf_sym__is_function() should accept "zero" sized functions

Chris Wilson (1):
      perf: Propagate term signal to child

Chuck Ebbert (1):
      perf_events: Make ABI definitions available to userspace

Tom Zanussi (3):
      perf trace: Remove unused code in builtin-trace.c
      perf trace: Update eval_flag() flags array to match interrupt.h
      tracing/syscalls: Use long for syscall ret format and field definitions


 include/linux/Kbuild                |    1 +
 kernel/trace/trace_syscalls.c       |    4 ++--
 tools/perf/builtin-record.c         |    6 ++++++
 tools/perf/builtin-stat.c           |    8 +++++++-
 tools/perf/builtin-trace.c          |    6 ------
 tools/perf/util/symbol.c            |    3 +--
 tools/perf/util/trace-event-parse.c |    9 +++++----
 7 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index cff4a10..3f384d4 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -126,6 +126,7 @@ header-y += nfs_mount.h
 header-y += nl80211.h
 header-y += param.h
 header-y += pci_regs.h
+header-y += perf_event.h
 header-y += pfkeyv2.h
 header-y += pg.h
 header-y += phantom.h
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 9fbce6c..527e17e 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -166,7 +166,7 @@ int syscall_exit_format(struct ftrace_event_call *call, struct trace_seq *s)
 			       "\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
 			       "\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n",
 			       SYSCALL_FIELD(int, nr),
-			       SYSCALL_FIELD(unsigned long, ret));
+			       SYSCALL_FIELD(long, ret));
 	if (!ret)
 		return 0;
 
@@ -212,7 +212,7 @@ int syscall_exit_define_fields(struct ftrace_event_call *call)
 	if (ret)
 		return ret;
 
-	ret = trace_define_field(call, SYSCALL_FIELD(unsigned long, ret), 0,
+	ret = trace_define_field(call, SYSCALL_FIELD(long, ret), 0,
 				 FILTER_OTHER);
 
 	return ret;
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a5a050a..3eeef33 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -41,6 +41,7 @@ static int			raw_samples			= 0;
 static int			system_wide			= 0;
 static int			profile_cpu			= -1;
 static pid_t			target_pid			= -1;
+static pid_t			child_pid			= -1;
 static int			inherit				= 1;
 static int			force				= 0;
 static int			append_file			= 0;
@@ -184,6 +185,9 @@ static void sig_handler(int sig)
 
 static void sig_atexit(void)
 {
+	if (child_pid != -1)
+		kill(child_pid, SIGTERM);
+
 	if (signr == -1)
 		return;
 
@@ -610,6 +614,8 @@ static int __cmd_record(int argc, const char **argv)
 				exit(-1);
 			}
 		}
+
+		child_pid = pid;
 	}
 
 	if (realtime_prio) {
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e5f6ece..3db31e7 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -69,7 +69,8 @@ static int			run_idx				=  0;
 static int			run_count			=  1;
 static int			inherit				=  1;
 static int			scale				=  1;
-static int			target_pid			= -1;
+static pid_t			target_pid			= -1;
+static pid_t			child_pid			= -1;
 static int			null_run			=  0;
 
 static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
@@ -285,6 +286,8 @@ static int run_perf_stat(int argc __used, const char **argv)
 		exit(-1);
 	}
 
+	child_pid = pid;
+
 	/*
 	 * Wait for the child to be ready to exec.
 	 */
@@ -433,6 +436,9 @@ static void skip_signal(int signo)
 
 static void sig_atexit(void)
 {
+	if (child_pid != -1)
+		kill(child_pid, SIGTERM);
+
 	if (signr == -1)
 		return;
 
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index e9d256e..0c5e4f7 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -219,10 +219,6 @@ remap:
 more:
 	event = (event_t *)(buf + head);
 
-	size = event->header.size;
-	if (!size)
-		size = 8;
-
 	if (head + event->header.size >= page_size * mmap_window) {
 		unsigned long shift = page_size * (head / page_size);
 		int res;
@@ -237,7 +233,6 @@ more:
 
 	size = event->header.size;
 
-
 	if (!size || process_event(event, offset, head) < 0) {
 
 		/*
@@ -290,7 +285,6 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 			usage_with_options(annotate_usage, options);
 	}
 
-
 	setup_pager();
 
 	return __cmd_trace();
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 559fb06..47ea060 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -324,8 +324,7 @@ static inline int elf_sym__is_function(const GElf_Sym *sym)
 {
 	return elf_sym__type(sym) == STT_FUNC &&
 	       sym->st_name != 0 &&
-	       sym->st_shndx != SHN_UNDEF &&
-	       sym->st_size != 0;
+	       sym->st_shndx != SHN_UNDEF;
 }
 
 static inline int elf_sym__is_label(const GElf_Sym *sym)
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index f6a8437..55b41b9 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1968,10 +1968,11 @@ static const struct flag flags[] = {
 	{ "NET_TX_SOFTIRQ", 2 },
 	{ "NET_RX_SOFTIRQ", 3 },
 	{ "BLOCK_SOFTIRQ", 4 },
-	{ "TASKLET_SOFTIRQ", 5 },
-	{ "SCHED_SOFTIRQ", 6 },
-	{ "HRTIMER_SOFTIRQ", 7 },
-	{ "RCU_SOFTIRQ", 8 },
+	{ "BLOCK_IOPOLL_SOFTIRQ", 5 },
+	{ "TASKLET_SOFTIRQ", 6 },
+	{ "SCHED_SOFTIRQ", 7 },
+	{ "HRTIMER_SOFTIRQ", 8 },
+	{ "RCU_SOFTIRQ", 9 },
 
 	{ "HRTIMER_NORESTART", 0 },
 	{ "HRTIMER_RESTART", 1 },
