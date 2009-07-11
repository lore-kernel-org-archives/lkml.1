Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbZGKR0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbZGKR0V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 13:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbZGKRZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 13:25:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:39239 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbZGKRZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 13:25:51 -0400
Date: Sat, 11 Jul 2009 17:25:19 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1247325517-12272-3-git-send-email-acme@redhat.com>
References: <1247325517-12272-3-git-send-email-acme@redhat.com>
Subject: [tip:perfcounters/core] perf report: Make the output more compact
Message-ID: <tip-021191b35cdfb1b5ee6e78ed5ae010114a40902c@git.kernel.org>
Git-Commit-ID: 021191b35cdfb1b5ee6e78ed5ae010114a40902c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 11 Jul 2009 17:25:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  021191b35cdfb1b5ee6e78ed5ae010114a40902c
Gitweb:     http://git.kernel.org/tip/021191b35cdfb1b5ee6e78ed5ae010114a40902c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 11 Jul 2009 12:18:35 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 11 Jul 2009 19:20:26 +0200

perf report: Make the output more compact

When we filter by column content we may end up with a column
that has the same value for all the lines. So remove that
column and tell its unique value on the top, as a comment.

Example:

  [acme@doppio pahole]$  perf report --sort comm,dso,symbol -d ./build/libdwarves.so.1.0.0 -C pahole | head -15
  # dso: ./build/libdwarves.so.1.0.0
  # comm: pahole
  # Samples: 58409
  #
  # Overhead  Symbol
  # ........  ......
  #
      20.93%  [.] tag__recode_dwarf_type
      14.94%  [.] namespace__recode_dwarf_types
      10.38%  [.] cu__table_add_tag
       6.69%  [.] __die__process_tag
       5.05%  [.] die__process_function
       4.70%  [.] list__for_all_tags
       3.68%  [.] tag__init
       3.48%  [.] die__create_new_parameter
  [acme@doppio pahole]$

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1247325517-12272-3-git-send-email-acme@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |   36 +++++++++++++++++++++---------------
 1 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 617f4cb..f342212 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -583,6 +583,7 @@ struct sort_entry {
 	int64_t (*collapse)(struct hist_entry *, struct hist_entry *);
 	size_t	(*print)(FILE *fp, struct hist_entry *, unsigned int width);
 	unsigned int *width;
+	bool	elide;
 };
 
 static int64_t cmp_null(void *l, void *r)
@@ -1024,7 +1025,7 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, u64 total_samples)
 		ret = fprintf(fp, field_sep ? "%lld" : "%12lld ", self->count);
 
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (exclude_other && (se == &sort_parent))
+		if (se->elide)
 			continue;
 
 		fprintf(fp, "%s", field_sep ?: "  ");
@@ -1079,7 +1080,7 @@ resolve_symbol(struct thread *thread, struct map **mapp,
 		 * with no symbol hit that has a name longer than
 		 * the ones with symbols sampled.
 		 */
-		if (!map->dso->slen_calculated)
+		if (!sort_dso.elide && !map->dso->slen_calculated)
 			dso__calc_col_width(map->dso);
 
 		if (mapp)
@@ -1356,14 +1357,12 @@ static size_t output__fprintf(FILE *fp, u64 total_samples)
 	unsigned int width;
 	char *col_width = col_width_list_str;
 
-	fprintf(fp, "\n");
-	fprintf(fp, "#\n");
-	fprintf(fp, "# (%Ld samples)\n", (u64)total_samples);
+	fprintf(fp, "# Samples: %Ld\n", (u64)total_samples);
 	fprintf(fp, "#\n");
 
 	fprintf(fp, "# Overhead");
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (exclude_other && (se == &sort_parent))
+		if (se->elide)
 			continue;
 		if (field_sep) {
 			fprintf(fp, "%c%s", *field_sep, se->header);
@@ -1392,7 +1391,7 @@ static size_t output__fprintf(FILE *fp, u64 total_samples)
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		unsigned int i;
 
-		if (exclude_other && (se == &sort_parent))
+		if (se->elide)
 			continue;
 
 		fprintf(fp, "  ");
@@ -2022,7 +2021,8 @@ static void setup_sorting(void)
 }
 
 static void setup_list(struct strlist **list, const char *list_str,
-		       const char *list_name)
+		       struct sort_entry *se, const char *list_name,
+		       FILE *fp)
 {
 	if (list_str) {
 		*list = strlist__new(true, list_str);
@@ -2031,6 +2031,11 @@ static void setup_list(struct strlist **list, const char *list_str,
 				list_name);
 			exit(129);
 		}
+		if (strlist__nr_entries(*list) == 1) {
+			fprintf(fp, "# %s: %s\n", list_name,
+				strlist__entry(*list, 0)->s);
+			se->elide = true;
+		}
 	}
 }
 
@@ -2044,9 +2049,10 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 
 	setup_sorting();
 
-	if (parent_pattern != default_parent_pattern)
+	if (parent_pattern != default_parent_pattern) {
 		sort_dimension__add("parent");
-	else
+		sort_parent.elide = 1;
+	} else
 		exclude_other = 0;
 
 	/*
@@ -2055,9 +2061,11 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	if (argc)
 		usage_with_options(report_usage, options);
 
-	setup_list(&dso_list, dso_list_str, "dso");
-	setup_list(&comm_list, comm_list_str, "comm");
-	setup_list(&sym_list, sym_list_str, "symbol");
+	setup_pager();
+
+	setup_list(&dso_list, dso_list_str, &sort_dso, "dso", stdout);
+	setup_list(&comm_list, comm_list_str, &sort_comm, "comm", stdout);
+	setup_list(&sym_list, sym_list_str, &sort_sym, "symbol", stdout);
 
 	if (field_sep && *field_sep == '.') {
 		fputs("'.' is the only non valid --field-separator argument\n",
@@ -2065,7 +2073,5 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 		exit(129);
 	}
 
-	setup_pager();
-
 	return __cmd_report();
 }
