Return-Path: <linux-kernel-owner+w=401wt.eu-S1763699AbZFRNkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763699AbZFRNkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 09:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758528AbZFRNkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 09:40:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:40883 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753609AbZFRNkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 09:40:41 -0400
Date: Thu, 18 Jun 2009 13:39:50 GMT
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
Subject: [tip:perfcounters/core] perf report: Filter to parent set by default
Message-ID: <tip-b8e6d829729d1a5991a9f628205b671cac2ec06f@git.kernel.org>
Git-Commit-ID: b8e6d829729d1a5991a9f628205b671cac2ec06f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 18 Jun 2009 13:40:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b8e6d829729d1a5991a9f628205b671cac2ec06f
Gitweb:     http://git.kernel.org/tip/b8e6d829729d1a5991a9f628205b671cac2ec06f
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 18 Jun 2009 14:32:19 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Jun 2009 14:32:19 +0200

perf report: Filter to parent set by default

Make it easier to use parent filtering - default to a filtered
output. Also add the parent column so that we get collapsing but
dont display it by default.

add --no-exclude-other to override this.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Makefile         |    2 +-
 tools/perf/builtin-report.c |   30 +++++++++++++++++++++++++++---
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 714db73..672c5f0 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -164,7 +164,7 @@ endif
 
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
-CFLAGS = $(M64) -ggdb3 -Wall -Wstrict-prototypes -Wmissing-declarations -Wmissing-prototypes -std=gnu99 -Wdeclaration-after-statement -O6
+CFLAGS = $(M64) -ggdb3 -Wall -Wstrict-prototypes -Wmissing-declarations -Wmissing-prototypes -std=gnu99 -Wdeclaration-after-statement -Werror -O6
 LDFLAGS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index fe66895..86981bd 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -46,9 +46,12 @@ static int		full_paths;
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
 
-static char		*parent_pattern = "^sys_|^do_page_fault";
+static char		default_parent_pattern[] = "^sys_|^do_page_fault";
+static char		*parent_pattern = default_parent_pattern;
 static regex_t		parent_regex;
 
+static int		exclude_other = 1;
+
 struct ip_event {
 	struct perf_event_header header;
 	__u64 ip;
@@ -742,6 +745,9 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, __u64 total_samples)
 	struct sort_entry *se;
 	size_t ret;
 
+	if (exclude_other && !self->parent)
+		return 0;
+
 	if (total_samples) {
 		double percent = self->count * 100.0 / total_samples;
 		char *color = PERF_COLOR_NORMAL;
@@ -764,6 +770,9 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, __u64 total_samples)
 		ret = fprintf(fp, "%12Ld ", self->count);
 
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (exclude_other && (se == &sort_parent))
+			continue;
+
 		fprintf(fp, "  ");
 		ret += se->print(fp, self);
 	}
@@ -855,6 +864,7 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 		.ip	= ip,
 		.level	= level,
 		.count	= count,
+		.parent = NULL,
 	};
 	int cmp;
 
@@ -1029,14 +1039,20 @@ static size_t output__fprintf(FILE *fp, __u64 total_samples)
 	fprintf(fp, "#\n");
 
 	fprintf(fp, "# Overhead");
-	list_for_each_entry(se, &hist_entry__sort_list, list)
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (exclude_other && (se == &sort_parent))
+			continue;
 		fprintf(fp, "  %s", se->header);
+	}
 	fprintf(fp, "\n");
 
 	fprintf(fp, "# ........");
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		int i;
 
+		if (exclude_other && (se == &sort_parent))
+			continue;
+
 		fprintf(fp, "  ");
 		for (i = 0; i < strlen(se->header); i++)
 			fprintf(fp, ".");
@@ -1050,7 +1066,8 @@ static size_t output__fprintf(FILE *fp, __u64 total_samples)
 		ret += hist_entry__fprintf(fp, pos, total_samples);
 	}
 
-	if (!strcmp(sort_order, default_sort_order)) {
+	if (sort_order == default_sort_order &&
+			parent_pattern == default_parent_pattern) {
 		fprintf(fp, "#\n");
 		fprintf(fp, "# (For more details, try: perf report --sort comm,dso,symbol)\n");
 		fprintf(fp, "#\n");
@@ -1508,6 +1525,8 @@ static const struct option options[] = {
 		    "Don't shorten the pathnames taking into account the cwd"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
 		   "regex filter to identify parent, see: '--sort parent'"),
+	OPT_BOOLEAN('x', "exclude-other", &exclude_other,
+		    "Only display entries with parent-match"),
 	OPT_END()
 };
 
@@ -1536,6 +1555,11 @@ int cmd_report(int argc, const char **argv, const char *prefix)
 
 	setup_sorting();
 
+	if (parent_pattern != default_parent_pattern)
+		sort_dimension__add("parent");
+	else
+		exclude_other = 0;
+
 	/*
 	 * Any (unrecognized) arguments left?
 	 */
