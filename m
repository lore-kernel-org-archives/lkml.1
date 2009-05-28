Return-Path: <linux-kernel-owner+w=401wt.eu-S1759115AbZE1KCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115AbZE1KCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 06:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756764AbZE1KBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 06:01:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:40251 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759468AbZE1KBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 06:01:48 -0400
Date: Thu, 28 May 2009 10:00:33 GMT
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
Subject: [tip:perfcounters/core] perf_counter tools: report: Implement header output for --sort variants
Message-ID: <tip-ca8cdeef9ca2ff89ee8a21d6f6ff3dfb60286041@git.kernel.org>
Git-Commit-ID: ca8cdeef9ca2ff89ee8a21d6f6ff3dfb60286041
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 May 2009 10:00:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca8cdeef9ca2ff89ee8a21d6f6ff3dfb60286041
Gitweb:     http://git.kernel.org/tip/ca8cdeef9ca2ff89ee8a21d6f6ff3dfb60286041
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 28 May 2009 11:08:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 28 May 2009 11:47:02 +0200

perf_counter tools: report: Implement header output for --sort variants

Implement this style of header:

 #
 # Overhead          Command       File: Symbol
 # ........          .......       ............
 #

for the various --sort variants as well.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |   70 +++++++++++----------------
 1 files changed, 28 insertions(+), 42 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 5993c12..506cde4 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -596,8 +596,6 @@ out_delete:
 
 struct thread;
 
-static const char *thread__name(struct thread *self, char *bf, size_t size);
-
 struct thread {
 	struct rb_node	 rb_node;
 	struct list_head maps;
@@ -605,15 +603,6 @@ struct thread {
 	char		 *comm;
 };
 
-static const char *thread__name(struct thread *self, char *bf, size_t size)
-{
-	if (self->comm)
-		return self->comm;
-
-	snprintf(bf, sizeof(bf), ":%u", self->pid);
-	return bf;
-}
-
 static struct thread *thread__new(pid_t pid)
 {
 	struct thread *self = malloc(sizeof(*self));
@@ -707,8 +696,9 @@ struct hist_entry {
 struct sort_entry {
 	struct list_head list;
 
+	char *header;
+
 	int64_t (*cmp)(struct hist_entry *, struct hist_entry *);
-	size_t (*print_header)(FILE *fp);
 	size_t	(*print)(FILE *fp, struct hist_entry *);
 };
 
@@ -721,13 +711,11 @@ sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
 static size_t
 sort__thread_print(FILE *fp, struct hist_entry *self)
 {
-	char bf[32];
-
-	return fprintf(fp, " %16s",
-			thread__name(self->thread, bf, sizeof(bf)));
+	return fprintf(fp, " %16s:%5d", self->thread->comm ?: "", self->thread->pid);
 }
 
 static struct sort_entry sort_thread = {
+	.header = "         Command: Pid ",
 	.cmp	= sort__thread_cmp,
 	.print	= sort__thread_print,
 };
@@ -757,6 +745,7 @@ sort__comm_print(FILE *fp, struct hist_entry *self)
 }
 
 static struct sort_entry sort_comm = {
+	.header = "         Command",
 	.cmp	= sort__comm_cmp,
 	.print	= sort__comm_print,
 };
@@ -786,6 +775,7 @@ sort__dso_print(FILE *fp, struct hist_entry *self)
 }
 
 static struct sort_entry sort_dso = {
+	.header = "                                                    Shared Object",
 	.cmp	= sort__dso_cmp,
 	.print	= sort__dso_print,
 };
@@ -804,43 +794,25 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 	return (int64_t)(ip_r - ip_l);
 }
 
-static size_t sort__sym_print_header(FILE *fp)
-{
-	size_t ret = 0;
-
-	ret += fprintf(fp, "#\n");
-	ret += fprintf(fp, "# Overhead          Command       File: Symbol\n");
-	ret += fprintf(fp, "# ........          .......       ............\n");
-	ret += fprintf(fp, "#\n");
-
-	return ret;
-}
-
 static size_t
 sort__sym_print(FILE *fp, struct hist_entry *self)
 {
 	size_t ret = 0;
 
-	ret += fprintf(fp, "  [%c] ", self->level);
-
 	if (verbose)
 		ret += fprintf(fp, " %#018llx", (unsigned long long)self->ip);
 
-	if (self->level != '.')
-		ret += fprintf(fp, " kernel: %s",
-			       self->sym ? self->sym->name : "<unknown>");
-	else
-		ret += fprintf(fp, " %s: %s",
-			       self->dso ? self->dso->name : "<unknown>",
-			       self->sym ? self->sym->name : "<unknown>");
+	ret += fprintf(fp, " %s: %s",
+			self->dso ? self->dso->name : "<unknown>",
+			self->sym ? self->sym->name : "<unknown>");
 
 	return ret;
 }
 
 static struct sort_entry sort_sym = {
-	.cmp		= sort__sym_cmp,
-	.print_header	= sort__sym_print_header,
-	.print		= sort__sym_print,
+	.header = "Shared Object: Symbol",
+	.cmp	= sort__sym_cmp,
+	.print	= sort__sym_print,
 };
 
 struct sort_dimension {
@@ -1021,10 +993,24 @@ static size_t output__fprintf(FILE *fp, uint64_t total_samples)
 	struct rb_node *nd;
 	size_t ret = 0;
 
+	fprintf(fp, "#\n");
+
+	fprintf(fp, "# Overhead");
+	list_for_each_entry(se, &hist_entry__sort_list, list)
+		fprintf(fp, " %s", se->header);
+	fprintf(fp, "\n");
+
+	fprintf(fp, "# ........");
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (se->print_header)
-			ret += se->print_header(fp);
+		int i;
+
+		fprintf(fp, " ");
+		for (i = 0; i < strlen(se->header); i++)
+			fprintf(fp, ".");
 	}
+	fprintf(fp, "\n");
+
+	fprintf(fp, "#\n");
 
 	for (nd = rb_first(&output_hists); nd; nd = rb_next(nd)) {
 		pos = rb_entry(nd, struct hist_entry, rb_node);
