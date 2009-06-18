Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbZFRHWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbZFRHWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 03:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZFRHWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 03:22:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:50716 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497AbZFRHWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 03:22:35 -0400
Date: Thu, 18 Jun 2009 07:21:54 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Add validation of call-chain entries
Message-ID: <tip-7522060c95395f479ee4a6af3bbf9e097e92e48f@git.kernel.org>
Git-Commit-ID: 7522060c95395f479ee4a6af3bbf9e097e92e48f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 18 Jun 2009 07:21:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7522060c95395f479ee4a6af3bbf9e097e92e48f
Gitweb:     http://git.kernel.org/tip/7522060c95395f479ee4a6af3bbf9e097e92e48f
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 18 Jun 2009 08:00:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Jun 2009 08:15:47 +0200

perf report: Add validation of call-chain entries

Add boundary checks for call-chain events. In case of corrupted
entries we could crash otherwise.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   20 ++++++------
 tools/perf/builtin-report.c  |   74 ++++++++++++++++++++++++++----------------
 2 files changed, 56 insertions(+), 38 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index eccae43..a7d3a61 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -337,6 +337,16 @@ enum perf_event_type {
 	 */
 };
 
+#define MAX_STACK_DEPTH			255
+
+struct perf_callchain_entry {
+	__u16				nr;
+	__u16				hv;
+	__u16				kernel;
+	__u16				user;
+	__u64				ip[MAX_STACK_DEPTH];
+};
+
 #ifdef __KERNEL__
 /*
  * Kernel-internal data types and definitions:
@@ -652,16 +662,6 @@ extern void perf_counter_fork(struct task_struct *tsk);
 
 extern void perf_counter_task_migration(struct task_struct *task, int cpu);
 
-#define MAX_STACK_DEPTH			255
-
-struct perf_callchain_entry {
-	u16				nr;
-	u16				hv;
-	u16				kernel;
-	u16				user;
-	u64				ip[MAX_STACK_DEPTH];
-};
-
 extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
 
 extern int sysctl_perf_counter_paranoid;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 9868346..e14e986 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -39,6 +39,8 @@ static int		dump_trace = 0;
 #define cdprintf(x...)	do { if (dump_trace) color_fprintf(stdout, color, x); } while (0)
 
 static int		verbose;
+#define eprintf(x...)	do { if (verbose) fprintf(stderr, x); } while (0)
+
 static int		full_paths;
 
 static unsigned long	page_size;
@@ -47,14 +49,6 @@ static unsigned long	mmap_window = 32;
 static char		*parent_pattern = "^sys_|^do_page_fault";
 static regex_t		parent_regex;
 
-struct ip_chain_event {
-	__u16 nr;
-	__u16 hv;
-	__u16 kernel;
-	__u16 user;
-	__u64 ips[];
-};
-
 struct ip_event {
 	struct perf_event_header header;
 	__u64 ip;
@@ -131,15 +125,11 @@ static struct dso *dsos__findnew(const char *name)
 
 	nr = dso__load(dso, NULL, verbose);
 	if (nr < 0) {
-		if (verbose)
-			fprintf(stderr, "Failed to open: %s\n", name);
+		eprintf("Failed to open: %s\n", name);
 		goto out_delete_dso;
 	}
-	if (!nr && verbose) {
-		fprintf(stderr,
-		"No symbols found in: %s, maybe install a debug package?\n",
-				name);
-	}
+	if (!nr)
+		eprintf("No symbols found in: %s, maybe install a debug package?\n", name);
 
 	dsos__add(dso);
 
@@ -844,7 +834,7 @@ static struct symbol *call__match(struct symbol *sym)
 
 static int
 hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
-		struct symbol *sym, __u64 ip, struct ip_chain_event *chain,
+		struct symbol *sym, __u64 ip, struct perf_callchain_entry *chain,
 		char level, __u64 count)
 {
 	struct rb_node **p = &hist.rb_node;
@@ -868,7 +858,7 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 		__u64 ip;
 
 		for (i = 0; i < chain->kernel; i++) {
-			ip = chain->ips[nr + i];
+			ip = chain->ip[nr + i];
 			dso = kernel_dso;
 			sym = resolve_symbol(thread, NULL, &dso, &ip);
 			entry.parent = call__match(sym);
@@ -878,7 +868,7 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 		nr += i;
 
 		for (i = 0; i < chain->user; i++) {
-			ip = chain->ips[nr + i];
+			ip = chain->ip[nr + i];
 			sym = resolve_symbol(thread, NULL, NULL, &ip);
 			entry.parent = call__match(sym);
 			if (entry.parent)
@@ -1080,6 +1070,30 @@ static unsigned long total = 0,
 		     total_fork = 0,
 		     total_unknown = 0;
 
+static int validate_chain(struct perf_callchain_entry *chain, event_t *event)
+{
+	unsigned int chain_size;
+
+	if (chain->nr > MAX_STACK_DEPTH)
+		return -1;
+	if (chain->hv > MAX_STACK_DEPTH)
+		return -1;
+	if (chain->kernel > MAX_STACK_DEPTH)
+		return -1;
+	if (chain->user > MAX_STACK_DEPTH)
+		return -1;
+	if (chain->hv + chain->kernel + chain->user != chain->nr)
+		return -1;
+
+	chain_size = event->header.size;
+	chain_size -= (unsigned long)&event->ip.__more_data - (unsigned long)event;
+
+	if (chain->nr*sizeof(__u64) > chain_size)
+		return -1;
+
+	return 0;
+}
+
 static int
 process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 {
@@ -1091,7 +1105,7 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 	__u64 period = 1;
 	struct map *map = NULL;
 	void *more_data = event->ip.__more_data;
-	struct ip_chain_event *chain = NULL;
+	struct perf_callchain_entry *chain = NULL;
 
 	if (event->header.type & PERF_SAMPLE_PERIOD) {
 		period = *(__u64 *)more_data;
@@ -1111,21 +1125,26 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 
 		chain = (void *)more_data;
 
-		if (dump_trace) {
-			dprintf("... chain: u:%d, k:%d, nr:%d\n",
-				chain->user,
-				chain->kernel,
-				chain->nr);
+		dprintf("... chain: u:%d, k:%d, nr:%d\n",
+			chain->user,
+			chain->kernel,
+			chain->nr);
 
+		if (validate_chain(chain, event) < 0) {
+			eprintf("call-chain problem with event, skipping it.\n");
+			return 0;
+		}
+
+		if (dump_trace) {
 			for (i = 0; i < chain->nr; i++)
-				dprintf("..... %2d: %016Lx\n", i, chain->ips[i]);
+				dprintf("..... %2d: %016Lx\n", i, chain->ip[i]);
 		}
 	}
 
 	dprintf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
 	if (thread == NULL) {
-		fprintf(stderr, "problem processing %d event, skipping it.\n",
+		eprintf("problem processing %d event, skipping it.\n",
 			event->header.type);
 		return -1;
 	}
@@ -1153,8 +1172,7 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 		struct symbol *sym = resolve_symbol(thread, &map, &dso, &ip);
 
 		if (hist_entry__add(thread, map, dso, sym, ip, chain, level, period)) {
-			fprintf(stderr,
-		"problem incrementing symbol count, skipping event\n");
+			eprintf("problem incrementing symbol count, skipping event\n");
 			return -1;
 		}
 	}
