Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbZGBTnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbZGBTnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 15:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbZGBTnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 15:43:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:46456 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509AbZGBTnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 15:43:15 -0400
Date: Thu, 2 Jul 2009 19:42:44 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, anton@samba.org,
       paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, anton@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1246558475-10624-2-git-send-email-fweisbec@gmail.com>
References: <1246558475-10624-2-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/urgent] perf_counter tools: Provide helper to print percents color
Message-ID: <tip-1e11fd82d247e4e48a1d6c49402214434538d3fd@git.kernel.org>
Git-Commit-ID: 1e11fd82d247e4e48a1d6c49402214434538d3fd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Jul 2009 19:42:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e11fd82d247e4e48a1d6c49402214434538d3fd
Gitweb:     http://git.kernel.org/tip/1e11fd82d247e4e48a1d6c49402214434538d3fd
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 2 Jul 2009 20:14:34 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 2 Jul 2009 21:38:37 +0200

perf_counter tools: Provide helper to print percents color

Among perf annotate, perf report and perf top, we can find the
common colored printing of percents according to the following
rules:

    High overhead =  > 5%, colored in red
    Mid overhead =  > 0.5%, colored in green
    Low overhead =  < 0.5%, default color

Factorize these multiple checks in a single function named
percent_color_fprintf() and also provide a get_percent_color()
for sites which print percentages and other things at the same
time.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1246558475-10624-2-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-annotate.c |   26 ++------------------------
 tools/perf/builtin-report.c   |   21 +++------------------
 tools/perf/builtin-top.c      |   15 +--------------
 tools/perf/util/color.c       |   27 +++++++++++++++++++++++++++
 tools/perf/util/color.h       |    5 +++++
 5 files changed, 38 insertions(+), 56 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 08ea6c5..5f9eefe 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -25,10 +25,6 @@
 #define SHOW_USER	2
 #define SHOW_HV		4
 
-#define MIN_GREEN		0.5
-#define MIN_RED		5.0
-
-
 static char		const *input_name = "perf.data";
 static char		*vmlinux = "vmlinux";
 
@@ -1047,24 +1043,6 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	return 0;
 }
 
-static char *get_color(double percent)
-{
-	char *color = PERF_COLOR_NORMAL;
-
-	/*
-	 * We color high-overhead entries in red, mid-overhead
-	 * entries in green - and keep the low overhead places
-	 * normal:
-	 */
-	if (percent >= MIN_RED)
-		color = PERF_COLOR_RED;
-	else {
-		if (percent > MIN_GREEN)
-			color = PERF_COLOR_GREEN;
-	}
-	return color;
-}
-
 static int
 parse_line(FILE *file, struct symbol *sym, u64 start, u64 len)
 {
@@ -1126,7 +1104,7 @@ parse_line(FILE *file, struct symbol *sym, u64 start, u64 len)
 		} else if (sym->hist_sum)
 			percent = 100.0 * hits / sym->hist_sum;
 
-		color = get_color(percent);
+		color = get_percent_color(percent);
 
 		/*
 		 * Also color the filename and line if needed, with
@@ -1262,7 +1240,7 @@ static void print_summary(char *filename)
 
 		sym_ext = rb_entry(node, struct sym_ext, node);
 		percent = sym_ext->percent;
-		color = get_color(percent);
+		color = get_percent_color(percent);
 		path = sym_ext->path;
 
 		color_fprintf(stdout, color, " %7.2f %s", percent, path);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index e8c9817..c9dbe33 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -947,25 +947,10 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, u64 total_samples)
 	if (exclude_other && !self->parent)
 		return 0;
 
-	if (total_samples) {
-		double percent = self->count * 100.0 / total_samples;
-		char *color = PERF_COLOR_NORMAL;
-
-		/*
-		 * We color high-overhead entries in red, mid-overhead
-		 * entries in green - and keep the low overhead places
-		 * normal:
-		 */
-		if (percent >= 5.0) {
-			color = PERF_COLOR_RED;
-		} else {
-			if (percent >= 0.5)
-				color = PERF_COLOR_GREEN;
-		}
-
-		ret = color_fprintf(fp, color, "   %6.2f%%",
+	if (total_samples)
+		ret = percent_color_fprintf(fp, "   %6.2f%%",
 				(self->count * 100.0) / total_samples);
-	} else
+	else
 		ret = fprintf(fp, "%12Ld ", self->count);
 
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index aa044ea..95d5c0a 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -239,7 +239,6 @@ static void print_sym_table(void)
 	for (nd = rb_first(&tmp); nd; nd = rb_next(nd)) {
 		struct sym_entry *syme = rb_entry(nd, struct sym_entry, rb_node);
 		struct symbol *sym = (struct symbol *)(syme + 1);
-		char *color = PERF_COLOR_NORMAL;
 		double pcnt;
 
 		if (++printed > print_entries || syme->snap_count < count_filter)
@@ -248,24 +247,12 @@ static void print_sym_table(void)
 		pcnt = 100.0 - (100.0 * ((sum_ksamples - syme->snap_count) /
 					 sum_ksamples));
 
-		/*
-		 * We color high-overhead entries in red, mid-overhead
-		 * entries in green - and keep the low overhead places
-		 * normal:
-		 */
-		if (pcnt >= 5.0) {
-			color = PERF_COLOR_RED;
-		} else {
-			if (pcnt >= 0.5)
-				color = PERF_COLOR_GREEN;
-		}
-
 		if (nr_counters == 1)
 			printf("%20.2f - ", syme->weight);
 		else
 			printf("%9.1f %10ld - ", syme->weight, syme->snap_count);
 
-		color_fprintf(stdout, color, "%4.1f%%", pcnt);
+		percent_color_fprintf(stdout, "%4.1f%%", pcnt);
 		printf(" - %016llx : %s", sym->start, sym->name);
 		if (sym->module)
 			printf("\t[%s]", sym->module->name);
diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
index 26f8231..90a044d 100644
--- a/tools/perf/util/color.c
+++ b/tools/perf/util/color.c
@@ -242,4 +242,31 @@ int color_fwrite_lines(FILE *fp, const char *color,
 	return 0;
 }
 
+char *get_percent_color(double percent)
+{
+	char *color = PERF_COLOR_NORMAL;
+
+	/*
+	 * We color high-overhead entries in red, mid-overhead
+	 * entries in green - and keep the low overhead places
+	 * normal:
+	 */
+	if (percent >= MIN_RED)
+		color = PERF_COLOR_RED;
+	else {
+		if (percent > MIN_GREEN)
+			color = PERF_COLOR_GREEN;
+	}
+	return color;
+}
 
+int percent_color_fprintf(FILE *fp, const char *fmt, double percent)
+{
+	int r;
+	char *color;
+
+	color = get_percent_color(percent);
+	r = color_fprintf(fp, color, fmt, percent);
+
+	return r;
+}
diff --git a/tools/perf/util/color.h b/tools/perf/util/color.h
index 5abfd37..706cec5 100644
--- a/tools/perf/util/color.h
+++ b/tools/perf/util/color.h
@@ -15,6 +15,9 @@
 #define PERF_COLOR_CYAN		"\033[36m"
 #define PERF_COLOR_BG_RED	"\033[41m"
 
+#define MIN_GREEN	0.5
+#define MIN_RED		5.0
+
 /*
  * This variable stores the value of color.ui
  */
@@ -32,5 +35,7 @@ void color_parse_mem(const char *value, int len, const char *var, char *dst);
 int color_fprintf(FILE *fp, const char *color, const char *fmt, ...);
 int color_fprintf_ln(FILE *fp, const char *color, const char *fmt, ...);
 int color_fwrite_lines(FILE *fp, const char *color, size_t count, const char *buf);
+int percent_color_fprintf(FILE *fp, const char *fmt, double percent);
+char *get_percent_color(double percent);
 
 #endif /* COLOR_H */
