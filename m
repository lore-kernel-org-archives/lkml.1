Return-Path: <linux-kernel-owner+w=401wt.eu-S932517AbZE0Twb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517AbZE0Twb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760464AbZE0TwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:52:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:51405 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759196AbZE0TwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:52:19 -0400
Date: Wed, 27 May 2009 19:51:45 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20090527182100.796410098@chello.nl>
References: <20090527182100.796410098@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: tools: report: Rework histogram code
Message-ID: <tip-e7fb08b1d06a6b37263c765205de5614a2273aeb@git.kernel.org>
Git-Commit-ID: e7fb08b1d06a6b37263c765205de5614a2273aeb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 19:51:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7fb08b1d06a6b37263c765205de5614a2273aeb
Gitweb:     http://git.kernel.org/tip/e7fb08b1d06a6b37263c765205de5614a2273aeb
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 27 May 2009 20:20:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 May 2009 21:44:13 +0200

perf_counter: tools: report: Rework histogram code

In preparation for configurable sorting, rework the histgram code a bit.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20090527182100.796410098@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |  294 +++++++++++++--------------
 1 files changed, 143 insertions(+), 151 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 3e87cbd..2762564 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -597,71 +597,9 @@ struct thread;
 
 static const char *thread__name(struct thread *self, char *bf, size_t size);
 
-struct symhist {
-	struct rb_node	 rb_node;
-	struct dso	 *dso;
-	struct symbol	 *sym;
-	struct thread	 *thread;
-	uint64_t	 ip;
-	uint32_t	 count;
-	char		 level;
-};
-
-static struct symhist *symhist__new(struct symbol *sym, uint64_t ip,
-				    struct thread *thread, struct dso *dso,
-				    char level)
-{
-	struct symhist *self = malloc(sizeof(*self));
-
-	if (self != NULL) {
-		self->sym    = sym;
-		self->thread = thread;
-		self->ip     = ip;
-		self->dso    = dso;
-		self->level  = level;
-		self->count  = 1;
-	}
-
-	return self;
-}
-
-static void symhist__inc(struct symhist *self)
-{
-	++self->count;
-}
-
-static size_t
-symhist__fprintf(struct symhist *self, uint64_t total_samples, FILE *fp)
-{
-	char bf[32];
-	size_t ret;
-
-	if (total_samples)
-		ret = fprintf(fp, "%5.2f%% ", (self->count * 100.0) / total_samples);
-	else
-		ret = fprintf(fp, "%12d ", self->count);
-
-	ret += fprintf(fp, "%14s [%c] ",
-		       thread__name(self->thread, bf, sizeof(bf)),
-		       self->level);
-
-	if (verbose)
-		ret += fprintf(fp, "%#018llx ", (unsigned long long)self->ip);
-
-	if (self->level != '.')
-		ret += fprintf(fp, "%s\n",
-			       self->sym ? self->sym->name : "<unknown>");
-	else
-		ret += fprintf(fp, "%s: %s\n",
-			       self->dso ? self->dso->name : "<unknown>",
-			       self->sym ? self->sym->name : "<unknown>");
-	return ret;
-}
-
 struct thread {
 	struct rb_node	 rb_node;
 	struct list_head maps;
-	struct rb_root	 symhists;
 	pid_t		 pid;
 	char		 *comm;
 };
@@ -683,67 +621,17 @@ static struct thread *thread__new(pid_t pid)
 		self->pid = pid;
 		self->comm = NULL;
 		INIT_LIST_HEAD(&self->maps);
-		self->symhists = RB_ROOT;
 	}
 
 	return self;
 }
 
-static int thread__symbol_incnew(struct thread *self, struct symbol *sym,
-				 uint64_t ip, struct dso *dso, char level)
-{
-	struct rb_node **p = &self->symhists.rb_node;
-	struct rb_node *parent = NULL;
-	struct symhist *sh;
-
-	while (*p != NULL) {
-		uint64_t start;
-
-		parent = *p;
-		sh = rb_entry(parent, struct symhist, rb_node);
-
-		if (sh->sym == sym || ip == sh->ip) {
-			symhist__inc(sh);
-			return 0;
-		}
-
-		/* Handle unresolved symbols too */
-		start = !sh->sym ? sh->ip : sh->sym->start;
-
-		if (ip < start)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	sh = symhist__new(sym, ip, self, dso, level);
-	if (sh == NULL)
-		return -ENOMEM;
-	rb_link_node(&sh->rb_node, parent, p);
-	rb_insert_color(&sh->rb_node, &self->symhists);
-	return 0;
-}
-
 static int thread__set_comm(struct thread *self, const char *comm)
 {
 	self->comm = strdup(comm);
 	return self->comm ? 0 : -ENOMEM;
 }
 
-static size_t thread__fprintf(struct thread *self, FILE *fp)
-{
-	int ret = fprintf(fp, "thread: %d %s\n", self->pid, self->comm);
-	struct rb_node *nd;
-
-	for (nd = rb_first(&self->symhists); nd; nd = rb_next(nd)) {
-		struct symhist *pos = rb_entry(nd, struct symhist, rb_node);
-
-		ret += symhist__fprintf(pos, 0, fp);
-	}
-
-	return ret;
-}
-
 static struct rb_root threads;
 
 static struct thread *threads__findnew(pid_t pid)
@@ -792,70 +680,172 @@ static struct map *thread__find_map(struct thread *self, uint64_t ip)
 	return NULL;
 }
 
-static void threads__fprintf(FILE *fp)
+/*
+ * histogram, sorted on item, collects counts
+ */
+
+static struct rb_root hist;
+
+struct hist_entry {
+	struct rb_node	 rb_node;
+
+	struct thread	 *thread;
+	struct map	 *map;
+	struct dso	 *dso;
+	struct symbol	 *sym;
+	uint64_t	 ip;
+	char		 level;
+
+	uint32_t	 count;
+};
+
+static int64_t
+hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	uint64_t ip_l, ip_r;
+	int cmp = right->thread->pid - left->thread->pid;
+
+	if (cmp)
+		return cmp;
+
+	if (left->sym == right->sym)
+		return 0;
+
+	ip_l = left->sym ? left->sym->start : left->ip;
+	ip_r = right->sym ? right->sym->start : right->ip;
+
+	return (int64_t)(ip_r - ip_l);
+}
+
+static int
+hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
+		struct symbol *sym, uint64_t ip, char level)
 {
-	struct rb_node *nd;
-	for (nd = rb_first(&threads); nd; nd = rb_next(nd)) {
-		struct thread *pos = rb_entry(nd, struct thread, rb_node);
-		thread__fprintf(pos, fp);
+	struct rb_node **p = &hist.rb_node;
+	struct rb_node *parent = NULL;
+	struct hist_entry *he;
+	struct hist_entry entry = {
+		.thread	= thread,
+		.map	= map,
+		.dso	= dso,
+		.sym	= sym,
+		.ip	= ip,
+		.level	= level,
+		.count	= 1,
+	};
+	int cmp;
+
+	while (*p != NULL) {
+		parent = *p;
+		he = rb_entry(parent, struct hist_entry, rb_node);
+
+		cmp = hist_entry__cmp(&entry, he);
+
+		if (!cmp) {
+			he->count++;
+			return 0;
+		}
+
+		if (cmp < 0)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
 	}
+
+	he = malloc(sizeof(*he));
+	if (!he)
+		return -ENOMEM;
+	*he = entry;
+	rb_link_node(&he->rb_node, parent, p);
+	rb_insert_color(&he->rb_node, &hist);
+
+	return 0;
 }
 
-static struct rb_root global_symhists;
+static size_t
+hist_entry__fprintf(FILE *fp, struct hist_entry *self, uint64_t total_samples)
+{
+	char bf[32];
+	size_t ret;
+
+	if (total_samples) {
+		ret = fprintf(fp, "%5.2f%% ",
+				(self->count * 100.0) / total_samples);
+	} else
+		ret = fprintf(fp, "%12d ", self->count);
 
-static void threads__insert_symhist(struct symhist *sh)
+	ret += fprintf(fp, "%14s [%c] ",
+		       thread__name(self->thread, bf, sizeof(bf)),
+		       self->level);
+
+	if (verbose)
+		ret += fprintf(fp, "%#018llx ", (unsigned long long)self->ip);
+
+	if (self->level != '.')
+		ret += fprintf(fp, "%s\n",
+			       self->sym ? self->sym->name : "<unknown>");
+	else
+		ret += fprintf(fp, "%s: %s\n",
+			       self->dso ? self->dso->name : "<unknown>",
+			       self->sym ? self->sym->name : "<unknown>");
+	return ret;
+}
+
+/*
+ * reverse the map, sort on count.
+ */
+
+static struct rb_root output_hists;
+
+static void output__insert_entry(struct hist_entry *he)
 {
-	struct rb_node **p = &global_symhists.rb_node;
+	struct rb_node **p = &output_hists.rb_node;
 	struct rb_node *parent = NULL;
-	struct symhist *iter;
+	struct hist_entry *iter;
 
 	while (*p != NULL) {
 		parent = *p;
-		iter = rb_entry(parent, struct symhist, rb_node);
+		iter = rb_entry(parent, struct hist_entry, rb_node);
 
-		/* Reverse order */
-		if (sh->count > iter->count)
+		if (he->count > iter->count)
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
 	}
 
-	rb_link_node(&sh->rb_node, parent, p);
-	rb_insert_color(&sh->rb_node, &global_symhists);
+	rb_link_node(&he->rb_node, parent, p);
+	rb_insert_color(&he->rb_node, &output_hists);
 }
 
-static void threads__sort_symhists(void)
+static void output__resort(void)
 {
-	struct rb_node *nd;
-
-	for (nd = rb_first(&threads); nd; nd = rb_next(nd)) {
-		struct thread *thread = rb_entry(nd, struct thread, rb_node);
-		struct rb_node *next = rb_first(&thread->symhists);
+	struct rb_node *next = rb_first(&hist);
+	struct hist_entry *n;
 
-		while (next) {
-			struct symhist *n = rb_entry(next, struct symhist,
-						     rb_node);
-			next = rb_next(&n->rb_node);
-			rb_erase(&n->rb_node, &thread->symhists);
-			threads__insert_symhist(n);
-		}
+	while (next) {
+		n = rb_entry(next, struct hist_entry, rb_node);
+		next = rb_next(&n->rb_node);
 
+		rb_erase(&n->rb_node, &hist);
+		output__insert_entry(n);
 	}
 }
 
-static size_t threads__symhists_fprintf(uint64_t total_samples, FILE *fp)
+static size_t output__fprintf(FILE *fp, uint64_t total_samples)
 {
+	struct hist_entry *pos;
 	struct rb_node *nd;
 	size_t ret = 0;
 
-	for (nd = rb_first(&global_symhists); nd; nd = rb_next(nd)) {
-		struct symhist *pos = rb_entry(nd, struct symhist, rb_node);
-		ret += symhist__fprintf(pos, total_samples, fp);
+	for (nd = rb_first(&output_hists); nd; nd = rb_next(nd)) {
+		pos = rb_entry(nd, struct hist_entry, rb_node);
+		ret += hist_entry__fprintf(fp, pos, total_samples);
 	}
 
 	return ret;
 }
 
+
 static int __cmd_report(void)
 {
 	unsigned long offset = 0;
@@ -926,6 +916,7 @@ more:
 		struct dso *dso = NULL;
 		struct thread *thread = threads__findnew(event->ip.pid);
 		uint64_t ip = event->ip.ip;
+		struct map *map = NULL;
 
 		if (dump_trace) {
 			fprintf(stderr, "%p [%p]: PERF_EVENT (IP, %d): %d: %p\n",
@@ -945,9 +936,10 @@ more:
 		if (event->header.misc & PERF_EVENT_MISC_KERNEL) {
 			show = SHOW_KERNEL;
 			level = 'k';
+
 			dso = kernel_dso;
+
 		} else if (event->header.misc & PERF_EVENT_MISC_USER) {
-			struct map *map;
 
 			show = SHOW_USER;
 			level = '.';
@@ -957,6 +949,7 @@ more:
 				dso = map->dso;
 				ip -= map->start + map->pgoff;
 			}
+
 		} else {
 			show = SHOW_HV;
 			level = 'H';
@@ -965,8 +958,9 @@ more:
 		if (show & show_mask) {
 			struct symbol *sym = dso__find_symbol(dso, ip);
 
-			if (thread__symbol_incnew(thread, sym, ip, dso, level)) {
-				fprintf(stderr, "problem incrementing symbol count, bailing out\n");
+			if (hist_entry__add(thread, map, dso, sym, ip, level)) {
+				fprintf(stderr,
+		"problem incrementing symbol count, bailing out\n");
 				goto done;
 			}
 		}
@@ -1050,13 +1044,11 @@ done:
 		return 0;
 	}
 
-	if (verbose >= 2) {
+	if (verbose >= 2)
 		dsos__fprintf(stdout);
-		threads__fprintf(stdout);
-	}
 
-	threads__sort_symhists();
-	threads__symhists_fprintf(total, stdout);
+	output__resort();
+	output__fprintf(stdout, total);
 
 	return rc;
 }
