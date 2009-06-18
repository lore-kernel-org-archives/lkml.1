Return-Path: <linux-kernel-owner+w=401wt.eu-S1760047AbZFRG2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbZFRG2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 02:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758152AbZFRG2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 02:28:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:56972 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbZFRG2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 02:28:10 -0400
Date: Thu, 18 Jun 2009 06:27:33 GMT
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
Subject: [tip:perfcounters/core] perf report: Tidy up the "--parent <regex>" and "--sort parent" call-chain features
Message-ID: <tip-b25bcf2f133b1e6216c3d40be394756107d3880f@git.kernel.org>
Git-Commit-ID: b25bcf2f133b1e6216c3d40be394756107d3880f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 18 Jun 2009 06:27:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b25bcf2f133b1e6216c3d40be394756107d3880f
Gitweb:     http://git.kernel.org/tip/b25bcf2f133b1e6216c3d40be394756107d3880f
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 18 Jun 2009 07:01:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Jun 2009 07:21:54 +0200

perf report: Tidy up the "--parent <regex>" and "--sort parent" call-chain features

Instead of the ambigious 'call' naming use the much more
specific 'parent' naming:

 - rename --call <regex> to --parent <regex>

 - rename --sort call to --sort parent

 - rename [unmatched] to [other] - to signal that this is not
   an error but the inverse set

Also add pagefaults to the default parent-symbol pattern too,
as it's a 'syscall overhead category' in a sense.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |   67 ++++++++++++++++++++++---------------------
 1 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 707f60c..9868346 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -44,8 +44,8 @@ static int		full_paths;
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
 
-static char		*call = "^sys_";
-static regex_t		call_regex;
+static char		*parent_pattern = "^sys_|^do_page_fault";
+static regex_t		parent_regex;
 
 struct ip_chain_event {
 	__u16 nr;
@@ -465,7 +465,7 @@ struct hist_entry {
 	struct map	 *map;
 	struct dso	 *dso;
 	struct symbol	 *sym;
-	struct symbol	 *call;
+	struct symbol	 *parent;
 	__u64		 ip;
 	char		 level;
 
@@ -618,13 +618,13 @@ static struct sort_entry sort_sym = {
 	.print	= sort__sym_print,
 };
 
-/* --sort call */
+/* --sort parent */
 
 static int64_t
-sort__call_cmp(struct hist_entry *left, struct hist_entry *right)
+sort__parent_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	struct symbol *sym_l = left->call;
-	struct symbol *sym_r = right->call;
+	struct symbol *sym_l = left->parent;
+	struct symbol *sym_r = right->parent;
 
 	if (!sym_l || !sym_r)
 		return cmp_null(sym_l, sym_r);
@@ -633,23 +633,23 @@ sort__call_cmp(struct hist_entry *left, struct hist_entry *right)
 }
 
 static size_t
-sort__call_print(FILE *fp, struct hist_entry *self)
+sort__parent_print(FILE *fp, struct hist_entry *self)
 {
 	size_t ret = 0;
 
-	ret += fprintf(fp, "%-20s", self->call ? self->call->name : "[unmatched]");
+	ret += fprintf(fp, "%-20s", self->parent ? self->parent->name : "[other]");
 
 	return ret;
 }
 
-static struct sort_entry sort_call = {
-	.header = "Callchain symbol    ",
-	.cmp	= sort__call_cmp,
-	.print	= sort__call_print,
+static struct sort_entry sort_parent = {
+	.header = "Parent symbol       ",
+	.cmp	= sort__parent_cmp,
+	.print	= sort__parent_print,
 };
 
 static int sort__need_collapse = 0;
-static int sort__has_call = 0;
+static int sort__has_parent = 0;
 
 struct sort_dimension {
 	char			*name;
@@ -662,7 +662,7 @@ static struct sort_dimension sort_dimensions[] = {
 	{ .name = "comm",	.entry = &sort_comm,	},
 	{ .name = "dso",	.entry = &sort_dso,	},
 	{ .name = "symbol",	.entry = &sort_sym,	},
-	{ .name = "call",	.entry = &sort_call,	},
+	{ .name = "parent",	.entry = &sort_parent,	},
 };
 
 static LIST_HEAD(hist_entry__sort_list);
@@ -683,16 +683,17 @@ static int sort_dimension__add(char *tok)
 		if (sd->entry->collapse)
 			sort__need_collapse = 1;
 
-		if (sd->entry == &sort_call) {
-			int ret = regcomp(&call_regex, call, REG_EXTENDED);
+		if (sd->entry == &sort_parent) {
+			int ret = regcomp(&parent_regex, parent_pattern, REG_EXTENDED);
 			if (ret) {
 				char err[BUFSIZ];
 
-				regerror(ret, &call_regex, err, sizeof(err));
-				fprintf(stderr, "Invalid regex: %s\n%s", call, err);
+				regerror(ret, &parent_regex, err, sizeof(err));
+				fprintf(stderr, "Invalid regex: %s\n%s",
+					parent_pattern, err);
 				exit(-1);
 			}
-			sort__has_call = 1;
+			sort__has_parent = 1;
 		}
 
 		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
@@ -831,7 +832,7 @@ static struct symbol *call__match(struct symbol *sym)
 	if (!sym)
 		return NULL;
 
-	if (sym->name && !regexec(&call_regex, sym->name, 0, NULL, 0))
+	if (sym->name && !regexec(&parent_regex, sym->name, 0, NULL, 0))
 		return sym;
 
 	return NULL;
@@ -844,7 +845,7 @@ static struct symbol *call__match(struct symbol *sym)
 static int
 hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 		struct symbol *sym, __u64 ip, struct ip_chain_event *chain,
-	       	char level, __u64 count)
+		char level, __u64 count)
 {
 	struct rb_node **p = &hist.rb_node;
 	struct rb_node *parent = NULL;
@@ -860,7 +861,7 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 	};
 	int cmp;
 
-	if (sort__has_call && chain) {
+	if (sort__has_parent && chain) {
 		int i, nr = chain->hv;
 		struct symbol *sym;
 		struct dso *dso;
@@ -870,22 +871,22 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 			ip = chain->ips[nr + i];
 			dso = kernel_dso;
 			sym = resolve_symbol(thread, NULL, &dso, &ip);
-			entry.call = call__match(sym);
-			if (entry.call)
-				goto got_call;
+			entry.parent = call__match(sym);
+			if (entry.parent)
+				goto got_parent;
 		}
 		nr += i;
 
 		for (i = 0; i < chain->user; i++) {
 			ip = chain->ips[nr + i];
 			sym = resolve_symbol(thread, NULL, NULL, &ip);
-			entry.call = call__match(sym);
-			if (entry.call)
-				goto got_call;
+			entry.parent = call__match(sym);
+			if (entry.parent)
+				goto got_parent;
 		}
 		nr += i;
 	}
-got_call:
+got_parent:
 
 	while (*p != NULL) {
 		parent = *p;
@@ -1457,11 +1458,11 @@ static const struct option options[] = {
 		    "dump raw trace in ASCII"),
 	OPT_STRING('k', "vmlinux", &vmlinux, "file", "vmlinux pathname"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): pid, comm, dso, symbol. Default: pid,symbol"),
+		   "sort by key(s): pid, comm, dso, symbol, parent"),
 	OPT_BOOLEAN('P', "full-paths", &full_paths,
 		    "Don't shorten the pathnames taking into account the cwd"),
-	OPT_STRING('c', "call", &call, "regex",
-		   "regex to use for --sort call"),
+	OPT_STRING('p', "parent", &parent_pattern, "regex",
+		   "regex filter to identify parent, see: '--sort parent'"),
 	OPT_END()
 };
 
