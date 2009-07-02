Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbZGBSPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbZGBSPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 14:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbZGBSOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 14:14:39 -0400
Received: from mail-ew0-f215.google.com ([209.85.219.215]:37552 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbZGBSOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 14:14:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AvWM36aCZR5RI9kcJ2VKekLv3KHX6nBW78rqw5hw086B4AvukigvwXWQ9bq6Ie509H
         eaJyVQ59eQLDrsNn3x4IN0PtR/l9xvzNmH9Py1oMELh6n2B4FVgf1Ob/Aqx45VNYCAaV
         TN43VXtbrqfM6GIR8N9aRJezEoqVEm3WqkM/k=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/3] perfcounter: Provide helper to print percents color
Date: Thu,  2 Jul 2009 20:14:34 +0200
Message-Id: <1246558475-10624-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1246558475-10624-1-git-send-email-fweisbec@gmail.com>
References: <1246558475-10624-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Among perf annotate, perf report and perf top, we can find
the common colored printing of percents according to the
following rules:

High overhead =  > 5%, colored in red
Mid overhead =  > 0.5%, colored in green

Factorize these multiple checks in a single function named
percent_color_fprintf() and also provide a get_percent_color()
for sites which print percentages and other things at the same time.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/builtin-annotate.c |   26 ++------------------------
 tools/perf/builtin-report.c   |   21 +++------------------
 tools/perf/builtin-top.c      |   15 +--------------
 tools/perf/util/color.c       |   27 +++++++++++++++++++++++++++
 tools/perf/util/color.h       |    5 +++++
 5 files changed, 38 insertions(+), 56 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 132de8b..12fc52f 100644
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
 
@@ -1043,24 +1039,6 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
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
@@ -1122,7 +1100,7 @@ parse_line(FILE *file, struct symbol *sym, u64 start, u64 len)
 		} else if (sym->hist_sum)
 			percent = 100.0 * hits / sym->hist_sum;
 
-		color = get_color(percent);
+		color = get_percent_color(percent);
 
 		/*
 		 * Also color the filename and line if needed, with
@@ -1258,7 +1236,7 @@ static void print_summary(char *filename)
 
 		sym_ext = rb_entry(node, struct sym_ext, node);
 		percent = sym_ext->percent;
-		color = get_color(percent);
+		color = get_percent_color(percent);
 		path = sym_ext->path;
 
 		color_fprintf(stdout, color, " %7.2f %s", percent, path);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 0e2317d..bfca1e4 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -942,25 +942,10 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, u64 total_samples)
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
index cdc74cf..27c1625 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -238,7 +238,6 @@ static void print_sym_table(void)
 	for (nd = rb_first(&tmp); nd; nd = rb_next(nd)) {
 		struct sym_entry *syme = rb_entry(nd, struct sym_entry, rb_node);
 		struct symbol *sym = (struct symbol *)(syme + 1);
-		char *color = PERF_COLOR_NORMAL;
 		double pcnt;
 
 		if (++printed > print_entries || syme->snap_count < count_filter)
@@ -247,24 +246,12 @@ static void print_sym_table(void)
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
 		printf(" - %016llx : %s\n", sym->start, sym->name);
 	}
 }
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
-- 
1.6.2.3

