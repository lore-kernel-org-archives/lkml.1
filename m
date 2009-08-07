Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbZHGLzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbZHGLzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 07:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757557AbZHGLzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 07:55:16 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:57972
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757361AbZHGLzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 07:55:13 -0400
X-IronPort-AV: E=Sophos;i="4.43,341,1246831200"; 
   d="scan'208";a="32184087"
Message-ID: <4A7C162C.1030707@inria.fr>
Date: Fri, 07 Aug 2009 13:55:24 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       paulus@samba.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf report: Display per-thread event counters
References: <20090623143601.GA13415@elte.hu> <4A40F31F.4030609@inria.fr> <20090629192913.GA29295@elte.hu> <4A7B0C02.7060704@inria.fr> <1249580428.4975.14.camel@laptop> <4A7B175B.8030000@inria.fr> <1249585061.4975.17.camel@laptop> <4A7B28EA.20903@inria.fr> <20090806195924.GA22411@elte.hu> <4A7B68C3.7040706@inria.fr> <20090807063226.GA29532@elte.hu>
In-Reply-To: <20090807063226.GA29532@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a better patch. I moved everything to utils/values.[ch] so that we may
reuse it in perf stat. But I don't see yet where I am suppose to get something
like PERF_READ_EVENT in builtin-stat.c so I haven't touched it yet.

We get something like this now:
#  PID   TID  cache-misses  cache-references
  4658  4659        495581           3238779
  4658  4662        498246           3236823
  4658  4663        499531           3243162

Then it'll be easy to add --pretty=raw to display a single line per thread/event.

By the way, -S was also used for --symbol... So I used -T/--thread here.





perf report: Add -T/--threads to display per-thread counter values
    
We get something like this now:
#  PID   TID  cache-misses  cache-references
  4658  4659        495581           3238779
  4658  4662        498246           3236823
  4658  4663        499531           3243162

Per-thread arrays of counter values are managed in utils/values.[ch]
    
Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index e72e931..370344a 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -27,6 +27,9 @@ OPTIONS
 -n
 --show-nr-samples
 	Show the number of samples for each symbol
+-T
+--threads
+	Show per-thread event counters
 -C::
 --comms=::
 	Only consider symbols in these comms. CSV that understands
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1916e44..9fc133f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -310,6 +310,7 @@ LIB_H += util/sigchain.h
 LIB_H += util/symbol.h
 LIB_H += util/module.h
 LIB_H += util/color.h
+LIB_H += util/values.h
 
 LIB_OBJS += util/abspath.o
 LIB_OBJS += util/alias.o
@@ -337,6 +338,7 @@ LIB_OBJS += util/color.o
 LIB_OBJS += util/pager.o
 LIB_OBJS += util/header.o
 LIB_OBJS += util/callchain.o
+LIB_OBJS += util/values.o
 
 BUILTIN_OBJS += builtin-annotate.o
 BUILTIN_OBJS += builtin-help.o
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index a5e2f8d..f7be85e 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -17,6 +17,7 @@
 #include "util/string.h"
 #include "util/callchain.h"
 #include "util/strlist.h"
+#include "util/values.h"
 
 #include "perf.h"
 #include "util/header.h"
@@ -53,6 +54,9 @@ static int		modules;
 static int		full_paths;
 static int		show_nr_samples;
 
+static int		show_threads;
+static struct perf_read_values	show_threads_values;
+
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
 
@@ -1432,6 +1436,9 @@ print_entries:
 	}
 	fprintf(fp, "\n");
 
+	if (show_threads)
+		perf_read_values_display(fp, &show_threads_values);
+
 	return ret;
 }
 
@@ -1717,6 +1724,16 @@ process_read_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	struct perf_counter_attr *attr = perf_header__find_attr(event->read.id);
 
+	if (show_threads) {
+		char *name = attr ? __event_name(attr->type, attr->config)
+				   : "unknown";
+		perf_read_values_add_value(&show_threads_values,
+					   event->read.pid, event->read.tid,
+					   event->read.id,
+					   name,
+					   event->read.value);
+	}
+
 	dprintf("%p [%p]: PERF_EVENT_READ: %d %d %s %Lu\n",
 			(void *)(offset + head),
 			(void *)(long)(event->header.size),
@@ -1798,6 +1815,9 @@ static int __cmd_report(void)
 
 	register_idle_thread();
 
+	if (show_threads)
+		perf_read_values_init(&show_threads_values);
+
 	input = open(input_name, O_RDONLY);
 	if (input < 0) {
 		fprintf(stderr, " failed to open file: %s", input_name);
@@ -1945,6 +1965,9 @@ done:
 	output__resort(total);
 	output__fprintf(stdout, total);
 
+	if (show_threads)
+		perf_read_values_destroy(&show_threads_values);
+
 	return rc;
 }
 
@@ -2011,6 +2034,8 @@ static const struct option options[] = {
 		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
 	OPT_BOOLEAN('n', "show-nr-samples", &show_nr_samples,
 		    "Show a column with the number of samples"),
+	OPT_BOOLEAN('T', "threads", &show_threads,
+		    "Show per-thread event counters"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent"),
 	OPT_BOOLEAN('P', "full-paths", &full_paths,
diff --git a/tools/perf/util/values.c b/tools/perf/util/values.c
new file mode 100644
index 0000000..8551c0b
--- /dev/null
+++ b/tools/perf/util/values.c
@@ -0,0 +1,171 @@
+#include <stdlib.h>
+
+#include "util.h"
+#include "values.h"
+
+void perf_read_values_init(struct perf_read_values *values)
+{
+	values->threads_max = 16;
+	values->pid = malloc(values->threads_max * sizeof(*values->pid));
+	values->tid = malloc(values->threads_max * sizeof(*values->tid));
+	values->value = malloc(values->threads_max * sizeof(*values->value));
+	if (!values->pid || !values->tid || !values->value)
+		die("failed to allocate read_values threads arrays");
+	values->threads = 0;
+
+	values->counters_max = 16;
+	values->counterrawid = malloc(values->counters_max
+				      * sizeof(*values->counterrawid));
+	values->countername = malloc(values->counters_max
+				     * sizeof(*values->countername));
+	if (!values->counterrawid || !values->countername)
+		die("failed to allocate read_values counters arrays");
+	values->counters = 0;
+}
+
+void perf_read_values_destroy(struct perf_read_values *values)
+{
+	int i;
+
+	if (!values->threads_max || !values->counters_max)
+		return;
+
+	for (i = 0; i < values->threads; i++)
+		free(values->value[i]);
+	free(values->pid);
+	free(values->tid);
+	free(values->counterrawid);
+	for (i = 0; i < values->counters; i++)
+		free(values->countername[i]);
+	free(values->countername);
+}
+
+static void perf_read_values__enlarge_threads(struct perf_read_values *values)
+{
+	values->threads_max *= 2;
+	values->pid = realloc(values->pid,
+			      values->threads_max * sizeof(*values->pid));
+	values->tid = realloc(values->tid,
+			      values->threads_max * sizeof(*values->tid));
+	values->value = realloc(values->value,
+				values->threads_max * sizeof(*values->value));
+	if (!values->pid || !values->tid || !values->value)
+		die("failed to enlarge read_values threads arrays");
+}
+
+static int perf_read_values__findnew_thread(struct perf_read_values *values,
+					    u32 pid, u32 tid)
+{
+	int i;
+
+	for (i = 0; i < values->threads; i++)
+		if (values->pid[i] == pid && values->tid[i] == tid)
+			return i;
+
+	if (values->threads == values->threads_max)
+		perf_read_values__enlarge_threads(values);
+
+	i = values->threads++;
+	values->pid[i] = pid;
+	values->tid[i] = tid;
+	values->value[i] = malloc(values->counters_max * sizeof(**values->value));
+	if (!values->value[i])
+		die("failed to allocate read_values counters array");
+
+	return i;
+}
+
+static void perf_read_values__enlarge_counters(struct perf_read_values *values)
+{
+	int i;
+
+	values->counters_max *= 2;
+	values->counterrawid = realloc(values->counterrawid,
+				       values->counters_max * sizeof(*values->counterrawid));
+	values->countername = realloc(values->countername,
+				      values->counters_max * sizeof(*values->countername));
+	if (!values->counterrawid || !values->countername)
+		die("failed to enlarge read_values counters arrays");
+
+	for (i = 0; i < values->threads; i++) {
+		values->value[i] = realloc(values->value[i],
+					   values->counters_max * sizeof(**values->value));
+		if (!values->value[i])
+			die("failed to enlarge read_values counters arrays");
+	}
+}
+
+static int perf_read_values__findnew_counter(struct perf_read_values *values,
+					     u64 rawid, char *name)
+{
+	int i;
+
+	for (i = 0; i < values->counters; i++)
+		if (values->counterrawid[i] == rawid)
+			return i;
+
+	if (values->counters == values->counters_max)
+		perf_read_values__enlarge_counters(values);
+
+	i = values->counters++;
+	values->counterrawid[i] = rawid;
+	values->countername[i] = strdup(name);
+
+	return i;
+}
+
+void perf_read_values_add_value(struct perf_read_values *values,
+				u32 pid, u32 tid,
+				u64 rawid, char *name, u64 value)
+{
+	int tindex, cindex;
+
+	tindex = perf_read_values__findnew_thread(values, pid, tid);
+	cindex = perf_read_values__findnew_counter(values, rawid, name);
+
+	values->value[tindex][cindex] = value;
+}
+
+void perf_read_values_display(FILE *fp, struct perf_read_values *values)
+{
+	int i, j;
+	int pidwidth, tidwidth;
+	int *counterwidth;
+
+	counterwidth = malloc(values->counters * sizeof(*counterwidth));
+	if (!counterwidth)
+		die("failed to allocate counterwidth array");
+	tidwidth = 3;
+	pidwidth = 3;
+	for (j = 0; j < values->counters; j++)
+		counterwidth[j] = strlen(values->countername[j]);
+	for (i = 0; i < values->threads; i++) {
+		int width;
+
+		width = snprintf(NULL, 0, "%d", values->pid[i]);
+		if (width > pidwidth)
+			pidwidth = width;
+		width = snprintf(NULL, 0, "%d", values->tid[i]);
+		if (width > tidwidth)
+			tidwidth = width;
+		for (j = 0; j < values->counters; j++) {
+			width = snprintf(NULL, 0, "%Lu", values->value[i][j]);
+			if (width > counterwidth[j])
+				counterwidth[j] = width;
+		}
+	}
+
+	fprintf(fp, "# %*s  %*s", pidwidth, "PID", tidwidth, "TID");
+	for (j = 0; j < values->counters; j++)
+		fprintf(fp, "  %*s", counterwidth[j], values->countername[j]);
+	fprintf(fp, "\n");
+
+	for (i = 0; i < values->threads; i++) {
+		fprintf(fp, "  %*d  %*d", pidwidth, values->pid[i],
+			tidwidth, values->tid[i]);
+		for (j = 0; j < values->counters; j++)
+			fprintf(fp, "  %*Lu",
+				counterwidth[j], values->value[i][j]);
+		fprintf(fp, "\n");
+	}
+}
diff --git a/tools/perf/util/values.h b/tools/perf/util/values.h
new file mode 100644
index 0000000..e41be5e
--- /dev/null
+++ b/tools/perf/util/values.h
@@ -0,0 +1,26 @@
+#ifndef _PERF_VALUES_H
+#define _PERF_VALUES_H
+
+#include "types.h"
+
+struct perf_read_values {
+	int threads;
+	int threads_max;
+	u32 *pid, *tid;
+	int counters;
+	int counters_max;
+	u64 *counterrawid;
+	char **countername;
+	u64 **value;
+};
+
+void perf_read_values_init(struct perf_read_values *values);
+void perf_read_values_destroy(struct perf_read_values *values);
+
+void perf_read_values_add_value(struct perf_read_values *values,
+				u32 pid, u32 tid,
+				u64 rawid, char *name, u64 value);
+
+void perf_read_values_display(FILE *fp, struct perf_read_values *values);
+
+#endif /* _PERF_VALUES_H */


