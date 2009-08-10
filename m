Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbZHJN0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbZHJN0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 09:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbZHJN0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 09:26:21 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:25000
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753843AbZHJN0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 09:26:20 -0400
X-IronPort-AV: E=Sophos;i="4.43,353,1246831200"; 
   d="scan'208";a="44523689"
Message-ID: <4A802008.5050409@inria.fr>
Date: Mon, 10 Aug 2009 15:26:32 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf report: Add raw displaying of per-thread counters
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If --pretty=raw is given to perf report -T, it now displays
one line per-thread per-counter with the raw event id added.
    
We get:
#   PID    TID              Name  Raw    Count
  18608  18609      cache-misses  28e   416744
  18608  18609  cache-references  28f  6456792
  18608  18608      cache-misses  28e   448219
  18608  18608  cache-references  28f  7270244
instead of:
#   PID    TID  cache-misses  cache-references
  18608  18609        416744           6456792
  18608  18608        448219           7270244
    
Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 4163918..2357c66 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -57,6 +57,9 @@ static int		show_nr_samples;
 static int		show_threads;
 static struct perf_read_values	show_threads_values;
 
+static char		default_pretty_printing_style[] = "normal";
+static char		*pretty_printing_style = default_pretty_printing_style;
+
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
 
@@ -1401,6 +1404,9 @@ static size_t output__fprintf(FILE *fp, u64 total_samples)
 	size_t ret = 0;
 	unsigned int width;
 	char *col_width = col_width_list_str;
+	int raw_printing_style;
+
+	raw_printing_style = !strcmp(pretty_printing_style, "raw");
 
 	init_rem_hits();
 
@@ -1478,7 +1484,8 @@ print_entries:
 	free(rem_sq_bracket);
 
 	if (show_threads)
-		perf_read_values_display(fp, &show_threads_values);
+		perf_read_values_display(fp, &show_threads_values,
+					 raw_printing_style);
 
 	return ret;
 }
@@ -2091,6 +2098,8 @@ static const struct option options[] = {
 		    "Show a column with the number of samples"),
 	OPT_BOOLEAN('T', "threads", &show_threads,
 		    "Show per-thread event counters"),
+	OPT_STRING(0, "pretty", &pretty_printing_style, "key",
+		   "pretty printing style key: normal raw"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent"),
 	OPT_BOOLEAN('P', "full-paths", &full_paths,
diff --git a/tools/perf/util/values.c b/tools/perf/util/values.c
index 8551c0b..614cfaf 100644
--- a/tools/perf/util/values.c
+++ b/tools/perf/util/values.c
@@ -126,7 +126,8 @@ void perf_read_values_add_value(struct perf_read_values *values,
 	values->value[tindex][cindex] = value;
 }
 
-void perf_read_values_display(FILE *fp, struct perf_read_values *values)
+static void perf_read_values__display_pretty(FILE *fp,
+					     struct perf_read_values *values)
 {
 	int i, j;
 	int pidwidth, tidwidth;
@@ -169,3 +170,62 @@ void perf_read_values_display(FILE *fp, struct perf_read_values *values)
 		fprintf(fp, "\n");
 	}
 }
+
+static void perf_read_values__display_raw(FILE *fp,
+					  struct perf_read_values *values)
+{
+	int width, pidwidth, tidwidth, namewidth, rawwidth, countwidth;
+	int i, j;
+
+	tidwidth = 3; /* TID */
+	pidwidth = 3; /* PID */
+	namewidth = 4; /* "Name" */
+	rawwidth = 3; /* "Raw" */
+	countwidth = 5; /* "Count" */
+
+	for (i = 0; i < values->threads; i++) {
+		width = snprintf(NULL, 0, "%d", values->pid[i]);
+		if (width > pidwidth)
+			pidwidth = width;
+		width = snprintf(NULL, 0, "%d", values->tid[i]);
+		if (width > tidwidth)
+			tidwidth = width;
+	}
+	for (j = 0; j < values->counters; j++) {
+		width = strlen(values->countername[j]);
+		if (width > namewidth)
+			namewidth = width;
+		width = snprintf(NULL, 0, "%llx", values->counterrawid[j]);
+		if (width > rawwidth)
+			rawwidth = width;
+	}
+	for (i = 0; i < values->threads; i++) {
+		for (j = 0; j < values->counters; j++) {
+			width = snprintf(NULL, 0, "%Lu", values->value[i][j]);
+			if (width > countwidth)
+				countwidth = width;
+		}
+	}
+
+	fprintf(fp, "# %*s  %*s  %*s  %*s  %*s\n",
+		pidwidth, "PID", tidwidth, "TID",
+		namewidth, "Name", rawwidth, "Raw",
+		countwidth, "Count");
+	for (i = 0; i < values->threads; i++)
+		for (j = 0; j < values->counters; j++)
+			fprintf(fp, "  %*d  %*d  %*s  %*llx  %*Lu\n",
+				pidwidth, values->pid[i],
+				tidwidth, values->tid[i],
+				namewidth, values->countername[j],
+				rawwidth, values->counterrawid[j],
+				countwidth, values->value[i][j]);
+}
+
+void perf_read_values_display(FILE *fp, struct perf_read_values *values,
+			      int raw)
+{
+	if (raw)
+		perf_read_values__display_raw(fp, values);
+	else
+		perf_read_values__display_pretty(fp, values);
+}
diff --git a/tools/perf/util/values.h b/tools/perf/util/values.h
index e41be5e..f8960fd 100644
--- a/tools/perf/util/values.h
+++ b/tools/perf/util/values.h
@@ -21,6 +21,7 @@ void perf_read_values_add_value(struct perf_read_values *values,
 				u32 pid, u32 tid,
 				u64 rawid, char *name, u64 value);
 
-void perf_read_values_display(FILE *fp, struct perf_read_values *values);
+void perf_read_values_display(FILE *fp, struct perf_read_values *values,
+			      int raw);
 
 #endif /* _PERF_VALUES_H */


