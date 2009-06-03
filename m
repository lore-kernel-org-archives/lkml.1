Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbZFCNIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbZFCNIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 09:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757359AbZFCNHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 09:07:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:36924 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757334AbZFCNHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 09:07:42 -0400
Date: Wed, 3 Jun 2009 13:06:57 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Fix comm sorting
Message-ID: <tip-8229289b607682f90b946ad2c319526303c17700@git.kernel.org>
Git-Commit-ID: 8229289b607682f90b946ad2c319526303c17700
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Jun 2009 13:06:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8229289b607682f90b946ad2c319526303c17700
Gitweb:     http://git.kernel.org/tip/8229289b607682f90b946ad2c319526303c17700
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 3 Jun 2009 12:37:36 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 3 Jun 2009 14:14:31 +0200

perf report: Fix comm sorting

Since we can (and do) change comm strings during the collection
phase, we cannot actually sort on them to build the histogram.
Therefore add an (optional) third sorting phase to collapse the
histrogram.

Comm sorting now builds the histrogram on threads and then in
the collapse phase collects all threads with the same comm.

This collapsed histogram is then reversed and sorted on events.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |  118 +++++++++++++++++++++++++--
 1 files changed, 112 insertions(+), 6 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 0f88d9e..6d359c9 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -211,9 +211,9 @@ static struct thread *thread__new(pid_t pid)
 
 	if (self != NULL) {
 		self->pid = pid;
-		self->comm = malloc(30);
+		self->comm = malloc(32);
 		if (self->comm)
-			sprintf(self->comm, ":%d", pid);
+			snprintf(self->comm, 32, ":%d", self->pid);
 		INIT_LIST_HEAD(&self->maps);
 	}
 
@@ -222,6 +222,8 @@ static struct thread *thread__new(pid_t pid)
 
 static int thread__set_comm(struct thread *self, const char *comm)
 {
+	if (self->comm)
+		free(self->comm);
 	self->comm = strdup(comm);
 	return self->comm ? 0 : -ENOMEM;
 }
@@ -303,9 +305,12 @@ struct sort_entry {
 	char *header;
 
 	int64_t (*cmp)(struct hist_entry *, struct hist_entry *);
+	int64_t (*collapse)(struct hist_entry *, struct hist_entry *);
 	size_t	(*print)(FILE *fp, struct hist_entry *);
 };
 
+/* --sort pid */
+
 static int64_t
 sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
 {
@@ -324,9 +329,17 @@ static struct sort_entry sort_thread = {
 	.print	= sort__thread_print,
 };
 
+/* --sort comm */
+
 static int64_t
 sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
 {
+	return right->thread->pid - left->thread->pid;
+}
+
+static int64_t
+sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
+{
 	char *comm_l = left->thread->comm;
 	char *comm_r = right->thread->comm;
 
@@ -349,11 +362,14 @@ sort__comm_print(FILE *fp, struct hist_entry *self)
 }
 
 static struct sort_entry sort_comm = {
-	.header = "          Command",
-	.cmp	= sort__comm_cmp,
-	.print	= sort__comm_print,
+	.header 	= "          Command",
+	.cmp		= sort__comm_cmp,
+	.collapse	= sort__comm_collapse,
+	.print		= sort__comm_print,
 };
 
+/* --sort dso */
+
 static int64_t
 sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
 {
@@ -387,6 +403,8 @@ static struct sort_entry sort_dso = {
 	.print	= sort__dso_print,
 };
 
+/* --sort symbol */
+
 static int64_t
 sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 {
@@ -428,6 +446,8 @@ static struct sort_entry sort_sym = {
 	.print	= sort__sym_print,
 };
 
+static int sort__need_collapse = 0;
+
 struct sort_dimension {
 	char *name;
 	struct sort_entry *entry;
@@ -456,6 +476,9 @@ static int sort_dimension__add(char *tok)
 		if (strncasecmp(tok, sd->name, strlen(tok)))
 			continue;
 
+		if (sd->entry->collapse)
+			sort__need_collapse = 1;
+
 		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
 		sd->taken = 1;
 
@@ -480,6 +503,25 @@ hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
 	return cmp;
 }
 
+static int64_t
+hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
+{
+	struct sort_entry *se;
+	int64_t cmp = 0;
+
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		int64_t (*f)(struct hist_entry *, struct hist_entry *);
+
+		f = se->collapse ?: se->cmp;
+
+		cmp = f(left, right);
+		if (cmp)
+			break;
+	}
+
+	return cmp;
+}
+
 static size_t
 hist_entry__fprintf(FILE *fp, struct hist_entry *self, uint64_t total_samples)
 {
@@ -549,6 +591,64 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 	return 0;
 }
 
+static void hist_entry__free(struct hist_entry *he)
+{
+	free(he);
+}
+
+/*
+ * collapse the histogram
+ */
+
+static struct rb_root collapse_hists;
+
+static void collapse__insert_entry(struct hist_entry *he)
+{
+	struct rb_node **p = &collapse_hists.rb_node;
+	struct rb_node *parent = NULL;
+	struct hist_entry *iter;
+	int64_t cmp;
+
+	while (*p != NULL) {
+		parent = *p;
+		iter = rb_entry(parent, struct hist_entry, rb_node);
+
+		cmp = hist_entry__collapse(iter, he);
+
+		if (!cmp) {
+			iter->count += he->count;
+			hist_entry__free(he);
+			return;
+		}
+
+		if (cmp < 0)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&he->rb_node, parent, p);
+	rb_insert_color(&he->rb_node, &collapse_hists);
+}
+
+static void collapse__resort(void)
+{
+	struct rb_node *next;
+	struct hist_entry *n;
+
+	if (!sort__need_collapse)
+		return;
+
+	next = rb_first(&hist);
+	while (next) {
+		n = rb_entry(next, struct hist_entry, rb_node);
+		next = rb_next(&n->rb_node);
+
+		rb_erase(&n->rb_node, &hist);
+		collapse__insert_entry(n);
+	}
+}
+
 /*
  * reverse the map, sort on count.
  */
@@ -577,9 +677,14 @@ static void output__insert_entry(struct hist_entry *he)
 
 static void output__resort(void)
 {
-	struct rb_node *next = rb_first(&hist);
+	struct rb_node *next;
 	struct hist_entry *n;
 
+	if (sort__need_collapse)
+		next = rb_first(&collapse_hists);
+	else
+		next = rb_first(&hist);
+
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
 		next = rb_next(&n->rb_node);
@@ -859,6 +964,7 @@ broken_event:
 	if (verbose >= 2)
 		dsos__fprintf(stdout);
 
+	collapse__resort();
 	output__resort();
 	output__fprintf(stdout, total);
 
