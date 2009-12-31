Return-Path: <linux-kernel-owner+w=401wt.eu-S1751631AbZLaMjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbZLaMjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 07:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbZLaMjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 07:39:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39142 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731AbZLaMjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 07:39:23 -0500
Date: Thu, 31 Dec 2009 13:39:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL, v2] perf fixes
Message-ID: <20091231123909.GA6738@elte.hu>
References: <20091231120050.GA22162@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091231120050.GA22162@elte.hu>
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

Please pull the latest perf-fixes-for-linus-2 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus-2

I missed two fixes. (v1 and v2 pull request can be pulled separately as 
together as well.)

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (3):
      perf diff: Fix usage array, it must end with a NULL entry
      perf record: We should fork only if a program was specified to run
      perf tools: Add missing header files to LIB_H Makefile variable

Frederic Weisbecker (1):
      perf: Pass appropriate frame pointer to dump_trace()

Heiko Carstens (1):
      kprobes: Fix distinct type warning

Peter Zijlstra (1):
      perf: Fix NULL deref in inheritance code

Tim Blechmann (1):
      perf: Rename perf_event_hw_event in design document

Wenji Huang (1):
      perf kmem: Fix statistics typo


 arch/x86/kernel/cpu/perf_event.c  |    2 +-
 kernel/kprobes.c                  |    2 +-
 kernel/perf_event.c               |    5 ++---
 tools/perf/Makefile               |    8 ++++++++
 tools/perf/builtin-buildid-list.c |    2 +-
 tools/perf/builtin-diff.c         |    3 ++-
 tools/perf/builtin-kmem.c         |    4 ++--
 tools/perf/builtin-record.c       |   14 ++++++++------
 tools/perf/builtin-report.c       |    3 +--
 tools/perf/builtin-trace.c        |    4 ++--
 tools/perf/design.txt             |    8 ++++----
 11 files changed, 32 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c223b7e..d616c06 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2347,7 +2347,7 @@ perf_callchain_kernel(struct pt_regs *regs, struct perf_callchain_entry *entry)
 	callchain_store(entry, PERF_CONTEXT_KERNEL);
 	callchain_store(entry, regs->ip);
 
-	dump_trace(NULL, regs, NULL, 0, &backtrace_ops, entry);
+	dump_trace(NULL, regs, NULL, regs->bp, &backtrace_ops, entry);
 }
 
 /*
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index e5342a3..b7df302 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1035,7 +1035,7 @@ int __kprobes register_kretprobe(struct kretprobe *rp)
 	/* Pre-allocate memory for max kretprobe instances */
 	if (rp->maxactive <= 0) {
 #ifdef CONFIG_PREEMPT
-		rp->maxactive = max(10, 2 * num_possible_cpus());
+		rp->maxactive = max_t(unsigned int, 10, 2*num_possible_cpus());
 #else
 		rp->maxactive = num_possible_cpus();
 #endif
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 03cc061..58ed1da 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5148,7 +5148,7 @@ int perf_event_init_task(struct task_struct *child)
 					    GFP_KERNEL);
 			if (!child_ctx) {
 				ret = -ENOMEM;
-				goto exit;
+				break;
 			}
 
 			__perf_event_init_context(child_ctx, child);
@@ -5164,7 +5164,7 @@ int perf_event_init_task(struct task_struct *child)
 		}
 	}
 
-	if (inherited_all) {
+	if (child_ctx && inherited_all) {
 		/*
 		 * Mark the child context as a clone of the parent
 		 * context, or of whatever the parent is a clone of.
@@ -5184,7 +5184,6 @@ int perf_event_init_task(struct task_struct *child)
 		get_ctx(child_ctx->parent_ctx);
 	}
 
-exit:
 	mutex_unlock(&parent_ctx->mutex);
 
 	perf_unpin_context(parent_ctx);
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4390d22..652a470 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -343,13 +343,18 @@ LIB_H += util/include/linux/string.h
 LIB_H += util/include/linux/types.h
 LIB_H += util/include/asm/asm-offsets.h
 LIB_H += util/include/asm/bitops.h
+LIB_H += util/include/asm/bug.h
 LIB_H += util/include/asm/byteorder.h
 LIB_H += util/include/asm/swab.h
 LIB_H += util/include/asm/system.h
 LIB_H += util/include/asm/uaccess.h
 LIB_H += perf.h
+LIB_H += util/cache.h
+LIB_H += util/callchain.h
+LIB_H += util/debug.h
 LIB_H += util/debugfs.h
 LIB_H += util/event.h
+LIB_H += util/exec_cmd.h
 LIB_H += util/types.h
 LIB_H += util/levenshtein.h
 LIB_H += util/parse-options.h
@@ -362,6 +367,7 @@ LIB_H += util/session.h
 LIB_H += util/strbuf.h
 LIB_H += util/string.h
 LIB_H += util/strlist.h
+LIB_H += util/svghelper.h
 LIB_H += util/run-command.h
 LIB_H += util/sigchain.h
 LIB_H += util/symbol.h
@@ -370,6 +376,8 @@ LIB_H += util/values.h
 LIB_H += util/sort.h
 LIB_H += util/hist.h
 LIB_H += util/thread.h
+LIB_H += util/trace-event.h
+LIB_H += util/trace-event-perl.h
 LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
 
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index e693e67..1e99ac8 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -17,7 +17,7 @@
 static char const *input_name = "perf.data";
 static int force;
 
-static const char *const buildid_list_usage[] = {
+static const char * const buildid_list_usage[] = {
 	"perf buildid-list [<options>]",
 	NULL
 };
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 4d33b55..bd71b8c 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -189,8 +189,9 @@ out_delete:
 	return ret;
 }
 
-static const char *const diff_usage[] = {
+static const char * const diff_usage[] = {
 	"perf diff [<options>] [old_file] [new_file]",
+	NULL,
 };
 
 static const struct option options[] = {
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index fc21ad7..7ceb741 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -137,7 +137,7 @@ static void insert_alloc_stat(unsigned long call_site, unsigned long ptr,
 	if (data && data->ptr == ptr) {
 		data->hit++;
 		data->bytes_req += bytes_req;
-		data->bytes_alloc += bytes_req;
+		data->bytes_alloc += bytes_alloc;
 	} else {
 		data = malloc(sizeof(*data));
 		if (!data)
@@ -177,7 +177,7 @@ static void insert_caller_stat(unsigned long call_site,
 	if (data && data->call_site == call_site) {
 		data->hit++;
 		data->bytes_req += bytes_req;
-		data->bytes_alloc += bytes_req;
+		data->bytes_alloc += bytes_alloc;
 	} else {
 		data = malloc(sizeof(*data));
 		if (!data)
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 63136d0..2654253 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -402,7 +402,7 @@ static void atexit_header(void)
 	perf_header__write(&session->header, output, true);
 }
 
-static int __cmd_record(int argc __used, const char **argv)
+static int __cmd_record(int argc, const char **argv)
 {
 	int i, counter;
 	struct stat st;
@@ -411,6 +411,7 @@ static int __cmd_record(int argc __used, const char **argv)
 	int err;
 	unsigned long waking = 0;
 	int child_ready_pipe[2], go_pipe[2];
+	const bool forks = target_pid == -1 && argc > 0;
 	char buf;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
@@ -422,7 +423,7 @@ static int __cmd_record(int argc __used, const char **argv)
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 
-	if (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0) {
+	if (forks && (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0)) {
 		perror("failed to create pipes");
 		exit(-1);
 	}
@@ -483,7 +484,7 @@ static int __cmd_record(int argc __used, const char **argv)
 
 	atexit(atexit_header);
 
-	if (target_pid == -1) {
+	if (forks) {
 		pid = fork();
 		if (pid < 0) {
 			perror("failed to fork");
@@ -550,7 +551,7 @@ static int __cmd_record(int argc __used, const char **argv)
 			return err;
 	}
 
-	if (!system_wide)
+	if (!system_wide && profile_cpu == -1)
 		event__synthesize_thread(pid, process_synthesized_event,
 					 session);
 	else
@@ -569,7 +570,8 @@ static int __cmd_record(int argc __used, const char **argv)
 	/*
 	 * Let the child rip
 	 */
-	close(go_pipe[1]);
+	if (forks)
+		close(go_pipe[1]);
 
 	for (;;) {
 		int hits = samples;
@@ -667,7 +669,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
-	if (!argc && target_pid == -1 && (!system_wide || profile_cpu == -1))
+	if (!argc && target_pid == -1 && !system_wide && profile_cpu == -1)
 		usage_with_options(record_usage, options);
 
 	symbol__init();
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 5c2ab53..db10c0e 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -294,8 +294,7 @@ setup:
 	return 0;
 }
 
-//static const char * const report_usage[] = {
-const char * const report_usage[] = {
+static const char * const report_usage[] = {
 	"perf report [<options>] <command>",
 	NULL
 };
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index e2285e2..574a215 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -512,7 +512,7 @@ static char *get_script_path(const char *script_root, const char *suffix)
 	return path;
 }
 
-static const char * const annotate_usage[] = {
+static const char * const trace_usage[] = {
 	"perf trace [<options>] <command>",
 	NULL
 };
@@ -581,7 +581,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 
 	setup_scripting();
 
-	argc = parse_options(argc, argv, options, annotate_usage,
+	argc = parse_options(argc, argv, options, trace_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
 
 	if (symbol__init() < 0)
diff --git a/tools/perf/design.txt b/tools/perf/design.txt
index f000c30..8d0de51 100644
--- a/tools/perf/design.txt
+++ b/tools/perf/design.txt
@@ -21,7 +21,7 @@ There's one file descriptor per virtual counter used.
 The special file descriptor is opened via the perf_event_open()
 system call:
 
-   int sys_perf_event_open(struct perf_event_hw_event *hw_event_uptr,
+   int sys_perf_event_open(struct perf_event_attr *hw_event_uptr,
 			     pid_t pid, int cpu, int group_fd,
 			     unsigned long flags);
 
@@ -32,9 +32,9 @@ can be used to set the blocking mode, etc.
 Multiple counters can be kept open at a time, and the counters
 can be poll()ed.
 
-When creating a new counter fd, 'perf_event_hw_event' is:
+When creating a new counter fd, 'perf_event_attr' is:
 
-struct perf_event_hw_event {
+struct perf_event_attr {
         /*
          * The MSB of the config word signifies if the rest contains cpu
          * specific (raw) counter configuration data, if unset, the next
@@ -399,7 +399,7 @@ Notification of new events is possible through poll()/select()/epoll() and
 fcntl() managing signals.
 
 Normally a notification is generated for every page filled, however one can
-additionally set perf_event_hw_event.wakeup_events to generate one every
+additionally set perf_event_attr.wakeup_events to generate one every
 so many counter overflow events.
 
 Future work will include a splice() interface to the ring-buffer.

