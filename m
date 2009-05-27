Return-Path: <linux-kernel-owner+w=401wt.eu-S1759732AbZE0UsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732AbZE0UsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756842AbZE0Ur0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:47:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:52753 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757473AbZE0UrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:47:23 -0400
Date: Wed, 27 May 2009 20:46:44 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20090527182101.229504802@chello.nl>
References: <20090527182101.229504802@chello.nl>
Subject: [tip:perfcounters/core] pref_counter: tools: report: Add header printout & prettify
Message-ID: <tip-2d65537ee7cd4a0818ea80a97ab7932368fff5cd@git.kernel.org>
Git-Commit-ID: 2d65537ee7cd4a0818ea80a97ab7932368fff5cd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 20:46:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2d65537ee7cd4a0818ea80a97ab7932368fff5cd
Gitweb:     http://git.kernel.org/tip/2d65537ee7cd4a0818ea80a97ab7932368fff5cd
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 27 May 2009 21:36:22 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 May 2009 21:40:47 +0200

pref_counter: tools: report: Add header printout & prettify

Old default output:

 3.12%    perf-report [.] ./perf-report:       dsos__find
 2.44%    perf-report [k] kernel:              kallsyms_expand_symbol
 2.28%          :4483 [.] <unknown>:           <unknown>
 2.05%          :4174 [k] kernel:              _spin_lock_irqsave
 2.01%    perf-report [k] kernel:              vsnprintf
 1.92%    perf-report [k] kernel:              format_decode
 1.92%          :4438 [k] kernel:              _spin_lock

New default output:

 #
 # Overhead          Command       File: Symbol
 # ........          .......       ............
 #
      6.54%             perf  [k]  kernel: kallsyms_expand_symbol
      6.26%             perf  [.]  /home/mingo/tip/Documentation/perf_counter/perf: dso__insert_symbol
      4.76%             perf  [.]  /home/mingo/tip/Documentation/perf_counter/perf: hex2long
      4.55%             perf  [k]  kernel: number
      4.48%             perf  [k]  kernel: format_decode
      4.09%             perf  [k]  kernel: vsnprintf

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20090527182101.229504802@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |   40 ++++++++++++++++++++-------
 1 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 30e12c7..6df95c2 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -708,6 +708,7 @@ struct sort_entry {
 	struct list_head list;
 
 	int64_t (*cmp)(struct hist_entry *, struct hist_entry *);
+	size_t (*print_header)(FILE *fp);
 	size_t	(*print)(FILE *fp, struct hist_entry *);
 };
 
@@ -722,7 +723,7 @@ sort__thread_print(FILE *fp, struct hist_entry *self)
 {
 	char bf[32];
 
-	return fprintf(fp, "%14s ",
+	return fprintf(fp, " %16s",
 			thread__name(self->thread, bf, sizeof(bf)));
 }
 
@@ -752,7 +753,7 @@ sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
 static size_t
 sort__comm_print(FILE *fp, struct hist_entry *self)
 {
-	return fprintf(fp, "%20s ", self->thread->comm ?: "<unknown>");
+	return fprintf(fp, " %16s", self->thread->comm ?: "<unknown>");
 }
 
 static struct sort_entry sort_comm = {
@@ -781,7 +782,7 @@ sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
 static size_t
 sort__dso_print(FILE *fp, struct hist_entry *self)
 {
-	return fprintf(fp, "%64s ", self->dso ? self->dso->name : "<unknown>");
+	return fprintf(fp, " %64s", self->dso ? self->dso->name : "<unknown>");
 }
 
 static struct sort_entry sort_dso = {
@@ -803,21 +804,33 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 	return (int64_t)(ip_r - ip_l);
 }
 
+static size_t sort__sym_print_header(FILE *fp)
+{
+	size_t ret = 0;
+
+	ret += fprintf(fp, "#\n");
+	ret += fprintf(fp, "# Overhead          Command       File: Symbol\n");
+	ret += fprintf(fp, "# ........          .......       ............\n");
+	ret += fprintf(fp, "#\n");
+
+	return ret;
+}
+
 static size_t
 sort__sym_print(FILE *fp, struct hist_entry *self)
 {
 	size_t ret = 0;
 
-	ret += fprintf(fp, "[%c] ", self->level);
+	ret += fprintf(fp, "  [%c] ", self->level);
 
 	if (verbose)
-		ret += fprintf(fp, "%#018llx ", (unsigned long long)self->ip);
+		ret += fprintf(fp, " %#018llx", (unsigned long long)self->ip);
 
 	if (self->level != '.')
-		ret += fprintf(fp, "%s ",
+		ret += fprintf(fp, " kernel: %s",
 			       self->sym ? self->sym->name : "<unknown>");
 	else
-		ret += fprintf(fp, "%s: %s ",
+		ret += fprintf(fp, " %s: %s",
 			       self->dso ? self->dso->name : "<unknown>",
 			       self->sym ? self->sym->name : "<unknown>");
 
@@ -825,8 +838,9 @@ sort__sym_print(FILE *fp, struct hist_entry *self)
 }
 
 static struct sort_entry sort_sym = {
-	.cmp	= sort__sym_cmp,
-	.print	= sort__sym_print,
+	.cmp		= sort__sym_cmp,
+	.print_header	= sort__sym_print_header,
+	.print		= sort__sym_print,
 };
 
 struct sort_dimension {
@@ -898,7 +912,7 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, uint64_t total_samples)
 	size_t ret;
 
 	if (total_samples) {
-		ret = fprintf(fp, "%5.2f%% ",
+		ret = fprintf(fp, "    %5.2f%%",
 				(self->count * 100.0) / total_samples);
 	} else
 		ret = fprintf(fp, "%12d ", self->count);
@@ -1003,9 +1017,15 @@ static void output__resort(void)
 static size_t output__fprintf(FILE *fp, uint64_t total_samples)
 {
 	struct hist_entry *pos;
+	struct sort_entry *se;
 	struct rb_node *nd;
 	size_t ret = 0;
 
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (se->print_header)
+			ret += se->print_header(fp);
+	}
+
 	for (nd = rb_first(&output_hists); nd; nd = rb_next(nd)) {
 		pos = rb_entry(nd, struct hist_entry, rb_node);
 		ret += hist_entry__fprintf(fp, pos, total_samples);
