Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbZFQR2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbZFQR2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758341AbZFQR2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:28:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:42087 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758704AbZFQR2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:28:07 -0400
Date: Wed, 17 Jun 2009 17:27:31 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Add --sort <call> --call <$regex>
Message-ID: <tip-6e7d6fdcbeefa9434653b5e5da12909636ea1d52@git.kernel.org>
Git-Commit-ID: 6e7d6fdcbeefa9434653b5e5da12909636ea1d52
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 17:27:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e7d6fdcbeefa9434653b5e5da12909636ea1d52
Gitweb:     http://git.kernel.org/tip/6e7d6fdcbeefa9434653b5e5da12909636ea1d52
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 17 Jun 2009 15:51:44 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Jun 2009 19:23:52 +0200

perf report: Add --sort <call> --call <$regex>

Implement sorting by callchain symbols, --sort <call>.

It will create a new column which will show a match to
--call $regex or "[unmatched]".

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |  209 ++++++++++++++++++++++++++++++++-----------
 1 files changed, 158 insertions(+), 51 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f86bb07..cd74b2e 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -40,11 +40,13 @@ static int		dump_trace = 0;
 
 static int		verbose;
 static int		full_paths;
-static int		collapse_syscalls;
 
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
 
+static char		*call = "^sys_";
+static regex_t		call_regex;
+
 struct ip_chain_event {
 	__u16 nr;
 	__u16 hv;
@@ -463,6 +465,7 @@ struct hist_entry {
 	struct map	 *map;
 	struct dso	 *dso;
 	struct symbol	 *sym;
+	struct symbol	 *call;
 	__u64		 ip;
 	char		 level;
 
@@ -483,6 +486,16 @@ struct sort_entry {
 	size_t	(*print)(FILE *fp, struct hist_entry *);
 };
 
+static int64_t cmp_null(void *l, void *r)
+{
+	if (!l && !r)
+		return 0;
+	else if (!l)
+		return -1;
+	else
+		return 1;
+}
+
 /* --sort pid */
 
 static int64_t
@@ -517,14 +530,8 @@ sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
 	char *comm_l = left->thread->comm;
 	char *comm_r = right->thread->comm;
 
-	if (!comm_l || !comm_r) {
-		if (!comm_l && !comm_r)
-			return 0;
-		else if (!comm_l)
-			return -1;
-		else
-			return 1;
-	}
+	if (!comm_l || !comm_r)
+		return cmp_null(comm_l, comm_r);
 
 	return strcmp(comm_l, comm_r);
 }
@@ -550,14 +557,8 @@ sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
 	struct dso *dso_l = left->dso;
 	struct dso *dso_r = right->dso;
 
-	if (!dso_l || !dso_r) {
-		if (!dso_l && !dso_r)
-			return 0;
-		else if (!dso_l)
-			return -1;
-		else
-			return 1;
-	}
+	if (!dso_l || !dso_r)
+		return cmp_null(dso_l, dso_r);
 
 	return strcmp(dso_l->name, dso_r->name);
 }
@@ -617,7 +618,38 @@ static struct sort_entry sort_sym = {
 	.print	= sort__sym_print,
 };
 
+/* --sort call */
+
+static int64_t
+sort__call_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	struct symbol *sym_l = left->call;
+	struct symbol *sym_r = right->call;
+
+	if (!sym_l || !sym_r)
+		return cmp_null(sym_l, sym_r);
+
+	return strcmp(sym_l->name, sym_r->name);
+}
+
+static size_t
+sort__call_print(FILE *fp, struct hist_entry *self)
+{
+	size_t ret = 0;
+
+	ret += fprintf(fp, "%-20s", self->call ? self->call->name : "[unmatched]");
+
+	return ret;
+}
+
+static struct sort_entry sort_call = {
+	.header = "Callchain symbol    ",
+	.cmp	= sort__call_cmp,
+	.print	= sort__call_print,
+};
+
 static int sort__need_collapse = 0;
+static int sort__has_call = 0;
 
 struct sort_dimension {
 	char			*name;
@@ -630,6 +662,7 @@ static struct sort_dimension sort_dimensions[] = {
 	{ .name = "comm",	.entry = &sort_comm,	},
 	{ .name = "dso",	.entry = &sort_dso,	},
 	{ .name = "symbol",	.entry = &sort_sym,	},
+	{ .name = "call",	.entry = &sort_call,	},
 };
 
 static LIST_HEAD(hist_entry__sort_list);
@@ -650,6 +683,18 @@ static int sort_dimension__add(char *tok)
 		if (sd->entry->collapse)
 			sort__need_collapse = 1;
 
+		if (sd->entry == &sort_call) {
+			int ret = regcomp(&call_regex, call, REG_EXTENDED);
+			if (ret) {
+				char err[BUFSIZ];
+
+				regerror(ret, &call_regex, err, sizeof(err));
+				fprintf(stderr, "Invalid regex: %s\n%s", call, err);
+				exit(-1);
+			}
+			sort__has_call = 1;
+		}
+
 		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
 		sd->taken = 1;
 
@@ -731,12 +776,75 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, __u64 total_samples)
 }
 
 /*
+ *
+ */
+
+static struct symbol *
+resolve_symbol(struct thread *thread, struct map **mapp,
+	       struct dso **dsop, __u64 *ipp)
+{
+	struct dso *dso = dsop ? *dsop : NULL;
+	struct map *map = mapp ? *mapp : NULL;
+	uint64_t ip = *ipp;
+
+	if (!thread)
+		return NULL;
+
+	if (dso)
+		goto got_dso;
+
+	if (map)
+		goto got_map;
+
+	map = thread__find_map(thread, ip);
+	if (map != NULL) {
+		if (mapp)
+			*mapp = map;
+got_map:
+		ip = map->map_ip(map, ip);
+		*ipp  = ip;
+
+		dso = map->dso;
+	} else {
+		/*
+		 * If this is outside of all known maps,
+		 * and is a negative address, try to look it
+		 * up in the kernel dso, as it might be a
+		 * vsyscall (which executes in user-mode):
+		 */
+		if ((long long)ip < 0)
+		dso = kernel_dso;
+	}
+	dprintf(" ...... dso: %s\n", dso ? dso->name : "<not found>");
+
+	if (dsop)
+		*dsop = dso;
+
+	if (!dso)
+		return NULL;
+got_dso:
+	return dso->find_symbol(dso, ip);
+}
+
+static struct symbol *call__match(struct symbol *sym)
+{
+	if (!sym)
+		return NULL;
+
+	if (sym->name && !regexec(&call_regex, sym->name, 0, NULL, 0))
+		return sym;
+
+	return NULL;
+}
+
+/*
  * collect histogram counts
  */
 
 static int
 hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
-		struct symbol *sym, __u64 ip, char level, __u64 count)
+		struct symbol *sym, __u64 ip, struct ip_chain_event *chain,
+	       	char level, __u64 count)
 {
 	struct rb_node **p = &hist.rb_node;
 	struct rb_node *parent = NULL;
@@ -752,6 +860,33 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 	};
 	int cmp;
 
+	if (sort__has_call && chain) {
+		int i, nr = chain->hv;
+		struct symbol *sym;
+		struct dso *dso;
+		__u64 ip;
+
+		for (i = 0; i < chain->kernel; i++) {
+			ip = chain->ips[nr + i];
+			dso = kernel_dso;
+			sym = resolve_symbol(thread, NULL, &dso, &ip);
+			entry.call = call__match(sym);
+			if (entry.call)
+				goto got_call;
+		}
+		nr += i;
+
+		for (i = 0; i < chain->user; i++) {
+			ip = chain->ips[nr + i];
+			sym = resolve_symbol(thread, NULL, NULL, &ip);
+			entry.call = call__match(sym);
+			if (entry.call)
+				goto got_call;
+		}
+		nr += i;
+	}
+got_call:
+
 	while (*p != NULL) {
 		parent = *p;
 		he = rb_entry(parent, struct hist_entry, rb_node);
@@ -955,7 +1090,7 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 	__u64 period = 1;
 	struct map *map = NULL;
 	void *more_data = event->ip.__more_data;
-	struct ip_chain_event *chain;
+	struct ip_chain_event *chain = NULL;
 
 	if (event->header.type & PERF_SAMPLE_PERIOD) {
 		period = *(__u64 *)more_data;
@@ -984,15 +1119,6 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 			for (i = 0; i < chain->nr; i++)
 				dprintf("..... %2d: %016Lx\n", i, chain->ips[i]);
 		}
-		if (collapse_syscalls) {
-			/*
-			 * Find the all-but-last kernel entry
-			 * amongst the call-chains - to get
-			 * to the level of system calls:
-			 */
-			if (chain->kernel >= 2)
-				ip = chain->ips[chain->kernel-2];
-		}
 	}
 
 	dprintf(" ... thread: %s:%d\n", thread->comm, thread->pid);
@@ -1016,22 +1142,6 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 		show = SHOW_USER;
 		level = '.';
 
-		map = thread__find_map(thread, ip);
-		if (map != NULL) {
-			ip = map->map_ip(map, ip);
-			dso = map->dso;
-		} else {
-			/*
-			 * If this is outside of all known maps,
-			 * and is a negative address, try to look it
-			 * up in the kernel dso, as it might be a
-			 * vsyscall (which executes in user-mode):
-			 */
-			if ((long long)ip < 0)
-				dso = kernel_dso;
-		}
-		dprintf(" ...... dso: %s\n", dso ? dso->name : "<not found>");
-
 	} else {
 		show = SHOW_HV;
 		level = 'H';
@@ -1039,12 +1149,9 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 	}
 
 	if (show & show_mask) {
-		struct symbol *sym = NULL;
-
-		if (dso)
-			sym = dso->find_symbol(dso, ip);
+		struct symbol *sym = resolve_symbol(thread, &map, &dso, &ip);
 
-		if (hist_entry__add(thread, map, dso, sym, ip, level, period)) {
+		if (hist_entry__add(thread, map, dso, sym, ip, chain, level, period)) {
 			fprintf(stderr,
 		"problem incrementing symbol count, skipping event\n");
 			return -1;
@@ -1353,8 +1460,8 @@ static const struct option options[] = {
 		   "sort by key(s): pid, comm, dso, symbol. Default: pid,symbol"),
 	OPT_BOOLEAN('P', "full-paths", &full_paths,
 		    "Don't shorten the pathnames taking into account the cwd"),
-	OPT_BOOLEAN('S', "syscalls", &collapse_syscalls,
-		    "show per syscall summary overhead, using call graph"),
+	OPT_STRING('c', "call", &call, "regex",
+		   "regex to use for --sort call"),
 	OPT_END()
 };
 
