Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbZLAAYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbZLAAYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 19:24:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbZLAAXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 19:23:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbZLAAXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 19:23:39 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 6/9] perf probe: Move probe event utility functions to
	probe-event.c
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Mon, 30 Nov 2009 19:19:58 -0500
Message-ID: <20091201001958.10235.90243.stgit@harusame>
In-Reply-To: <20091201001912.10235.79411.stgit@harusame>
References: <20091201001912.10235.79411.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split probe event (kprobe-events and perf probe events) utility
functions from builtin-probe.c to probe-event.c.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---

 tools/perf/Makefile           |    2 
 tools/perf/builtin-probe.c    |  227 +---------------------------------
 tools/perf/util/probe-event.c |  273 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/probe-event.h |   10 ++
 4 files changed, 294 insertions(+), 218 deletions(-)
 create mode 100644 tools/perf/util/probe-event.c
 create mode 100644 tools/perf/util/probe-event.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 76e4b04..f8537cf 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -370,6 +370,7 @@ LIB_H += util/hist.h
 LIB_H += util/thread.h
 LIB_H += util/data_map.h
 LIB_H += util/probe-finder.h
+LIB_H += util/probe-event.h
 
 LIB_OBJS += util/abspath.o
 LIB_OBJS += util/alias.o
@@ -412,6 +413,7 @@ LIB_OBJS += util/svghelper.o
 LIB_OBJS += util/sort.o
 LIB_OBJS += util/hist.o
 LIB_OBJS += util/data_map.o
+LIB_OBJS += util/probe-event.o
 
 BUILTIN_OBJS += builtin-annotate.o
 
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 5f47e62..bf20df2 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -40,6 +40,7 @@
 #include "util/parse-options.h"
 #include "util/parse-events.h"	/* For debugfs_path */
 #include "util/probe-finder.h"
+#include "util/probe-event.h"
 
 /* Default vmlinux search paths */
 #define NR_SEARCH_PATH 3
@@ -51,8 +52,6 @@ const char *default_search_path[NR_SEARCH_PATH] = {
 
 #define MAX_PATH_LEN 256
 #define MAX_PROBES 128
-#define MAX_PROBE_ARGS 128
-#define PERFPROBE_GROUP "probe"
 
 /* Session management structure */
 static struct {
@@ -63,155 +62,17 @@ static struct {
 	struct probe_point probes[MAX_PROBES];
 } session;
 
-#define semantic_error(msg ...) die("Semantic error :" msg)
-
-/* Parse probe point. Return 1 if return probe */
-static void parse_probe_point(char *arg, struct probe_point *pp)
-{
-	char *ptr, *tmp;
-	char c, nc = 0;
-	/*
-	 * <Syntax>
-	 * perf probe SRC:LN
-	 * perf probe FUNC[+OFFS|%return][@SRC]
-	 */
-
-	ptr = strpbrk(arg, ":+@%");
-	if (ptr) {
-		nc = *ptr;
-		*ptr++ = '\0';
-	}
-
-	/* Check arg is function or file and copy it */
-	if (strchr(arg, '.'))	/* File */
-		pp->file = strdup(arg);
-	else			/* Function */
-		pp->function = strdup(arg);
-	DIE_IF(pp->file == NULL && pp->function == NULL);
-
-	/* Parse other options */
-	while (ptr) {
-		arg = ptr;
-		c = nc;
-		ptr = strpbrk(arg, ":+@%");
-		if (ptr) {
-			nc = *ptr;
-			*ptr++ = '\0';
-		}
-		switch (c) {
-		case ':':	/* Line number */
-			pp->line = strtoul(arg, &tmp, 0);
-			if (*tmp != '\0')
-				semantic_error("There is non-digit charactor"
-						" in line number.");
-			break;
-		case '+':	/* Byte offset from a symbol */
-			pp->offset = strtoul(arg, &tmp, 0);
-			if (*tmp != '\0')
-				semantic_error("There is non-digit charactor"
-						" in offset.");
-			break;
-		case '@':	/* File name */
-			if (pp->file)
-				semantic_error("SRC@SRC is not allowed.");
-			pp->file = strdup(arg);
-			DIE_IF(pp->file == NULL);
-			if (ptr)
-				semantic_error("@SRC must be the last "
-					       "option.");
-			break;
-		case '%':	/* Probe places */
-			if (strcmp(arg, "return") == 0) {
-				pp->retprobe = 1;
-			} else	/* Others not supported yet */
-				semantic_error("%%%s is not supported.", arg);
-			break;
-		default:
-			DIE_IF("Program has a bug.");
-			break;
-		}
-	}
-
-	/* Exclusion check */
-	if (pp->line && pp->offset)
-		semantic_error("Offset can't be used with line number.");
-	if (!pp->line && pp->file && !pp->function)
-		semantic_error("File always requires line number.");
-	if (pp->offset && !pp->function)
-		semantic_error("Offset requires an entry function.");
-	if (pp->retprobe && !pp->function)
-		semantic_error("Return probe requires an entry function.");
-	if ((pp->offset || pp->line) && pp->retprobe)
-		semantic_error("Offset/Line can't be used with return probe.");
-
-	pr_debug("symbol:%s file:%s line:%d offset:%d, return:%d\n",
-		 pp->function, pp->file, pp->line, pp->offset, pp->retprobe);
-}
-
 /* Parse an event definition. Note that any error must die. */
 static void parse_probe_event(const char *str)
 {
-	char *argv[MAX_PROBE_ARGS + 1];	/* probe + args */
-	int argc, i;
 	struct probe_point *pp = &session.probes[session.nr_probe];
 
 	pr_debug("probe-definition(%d): %s\n", session.nr_probe, str);
 	if (++session.nr_probe == MAX_PROBES)
-		semantic_error("Too many probes");
-
-	/* Separate arguments, similar to argv_split */
-	argc = 0;
-	do {
-		/* Skip separators */
-		while (isspace(*str))
-			str++;
-
-		/* Add an argument */
-		if (*str != '\0') {
-			const char *s = str;
-			/* Check the limit number of arguments */
-			if (argc == MAX_PROBE_ARGS + 1)
-				semantic_error("Too many arguments");
-
-			/* Skip the argument */
-			while (!isspace(*str) && *str != '\0')
-				str++;
-
-			/* Duplicate the argument */
-			argv[argc] = strndup(s, str - s);
-			if (argv[argc] == NULL)
-				die("strndup");
-			pr_debug("argv[%d]=%s\n", argc, argv[argc]);
-			argc++;
-
-		}
-	} while (*str != '\0');
-	if (!argc)
-		semantic_error("An empty argument.");
-
-	/* Parse probe point */
-	parse_probe_point(argv[0], pp);
-	free(argv[0]);
-	if (pp->file || pp->line)
-		session.need_dwarf = 1;
-
-	/* Copy arguments */
-	pp->nr_args = argc - 1;
-	if (pp->nr_args > 0) {
-		pp->args = (char **)malloc(sizeof(char *) * pp->nr_args);
-		if (!pp->args)
-			die("malloc");
-		memcpy(pp->args, &argv[1], sizeof(char *) * pp->nr_args);
-	}
+		die("Too many probes (> %d) are specified.", MAX_PROBES);
 
-	/* Ensure return probe has no C argument */
-	for (i = 0; i < pp->nr_args; i++)
-		if (is_c_varname(pp->args[i])) {
-			if (pp->retprobe)
-				semantic_error("You can't specify local"
-						" variable for kretprobe");
-			session.need_dwarf = 1;
-		}
+	/* Parse perf-probe event into probe_point */
+	session.need_dwarf = parse_perf_probe_event(str, pp);
 
 	pr_debug("%d arguments\n", pp->nr_args);
 }
@@ -288,59 +149,15 @@ static const struct option options[] = {
 		"\t\tALN:\tAbsolute line number in file.\n"
 		"\t\tARG:\tProbe argument (local variable name or\n"
 #endif
-		"\t\t\tkprobe-tracer argument format is supported.)\n",
+		"\t\t\tkprobe-tracer argument format.)\n",
 		opt_add_probe_event),
 	OPT_END()
 };
 
-static int write_new_event(int fd, const char *buf)
-{
-	int ret;
-
-	ret = write(fd, buf, strlen(buf));
-	if (ret <= 0)
-		die("Failed to create event.");
-	else
-		printf("Added new event: %s\n", buf);
-
-	return ret;
-}
-
-#define MAX_CMDLEN 256
-
-static int synthesize_probe_event(struct probe_point *pp)
-{
-	char *buf;
-	int i, len, ret;
-	pp->probes[0] = buf = zalloc(MAX_CMDLEN);
-	if (!buf)
-		die("Failed to allocate memory by zalloc.");
-	ret = snprintf(buf, MAX_CMDLEN, "%s+%d", pp->function, pp->offset);
-	if (ret <= 0 || ret >= MAX_CMDLEN)
-		goto error;
-	len = ret;
-
-	for (i = 0; i < pp->nr_args; i++) {
-		ret = snprintf(&buf[len], MAX_CMDLEN - len, " %s",
-			       pp->args[i]);
-		if (ret <= 0 || ret >= MAX_CMDLEN - len)
-			goto error;
-		len += ret;
-	}
-	pp->found = 1;
-	return pp->found;
-error:
-	free(pp->probes[0]);
-	if (ret > 0)
-		ret = -E2BIG;
-	return ret;
-}
-
 int cmd_probe(int argc, const char **argv, const char *prefix __used)
 {
 	int i, j, fd, ret;
 	struct probe_point *pp;
-	char buf[MAX_CMDLEN];
 
 	argc = parse_options(argc, argv, options, probe_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
@@ -352,7 +169,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 
 	if (session.need_dwarf)
 #ifdef NO_LIBDWARF
-		semantic_error("Debuginfo-analysis is not supported");
+		die("Debuginfo-analysis is not supported");
 #else	/* !NO_LIBDWARF */
 		pr_debug("Some probes require debuginfo.\n");
 
@@ -398,41 +215,15 @@ end_dwarf:
 		if (pp->found)	/* This probe is already found. */
 			continue;
 
-		ret = synthesize_probe_event(pp);
+		ret = synthesize_trace_kprobe_event(pp);
 		if (ret == -E2BIG)
-			semantic_error("probe point is too long.");
+			die("probe point definition becomes too long.");
 		else if (ret < 0)
 			die("Failed to synthesize a probe point.");
 	}
 
 	/* Settng up probe points */
-	snprintf(buf, MAX_CMDLEN, "%s/../kprobe_events", debugfs_path);
-	fd = open(buf, O_WRONLY, O_APPEND);
-	if (fd < 0) {
-		if (errno == ENOENT)
-			die("kprobe_events file does not exist - please rebuild with CONFIG_KPROBE_TRACER.");
-		else
-			die("Could not open kprobe_events file: %s",
-			    strerror(errno));
-	}
-	for (j = 0; j < session.nr_probe; j++) {
-		pp = &session.probes[j];
-		if (pp->found == 1) {
-			snprintf(buf, MAX_CMDLEN, "%c:%s/%s_%x %s\n",
-				pp->retprobe ? 'r' : 'p', PERFPROBE_GROUP,
-				pp->function, pp->offset, pp->probes[0]);
-			write_new_event(fd, buf);
-		} else
-			for (i = 0; i < pp->found; i++) {
-				snprintf(buf, MAX_CMDLEN, "%c:%s/%s_%x_%d %s\n",
-					pp->retprobe ? 'r' : 'p',
-					PERFPROBE_GROUP,
-					pp->function, pp->offset, i,
-					pp->probes[i]);
-				write_new_event(fd, buf);
-			}
-	}
-	close(fd);
+	add_trace_kprobe_events(session.probes, session.nr_probe);
 	return 0;
 }
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
new file mode 100644
index 0000000..7335a3b
--- /dev/null
+++ b/tools/perf/util/probe-event.c
@@ -0,0 +1,273 @@
+/*
+ * probe-event.c : perf-probe definition to kprobe_events format converter
+ *
+ * Written by Masami Hiramatsu <mhiramat@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ */
+
+#define _GNU_SOURCE
+#include <sys/utsname.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+
+#undef _GNU_SOURCE
+#include "event.h"
+#include "debug.h"
+#include "parse-events.h"  /* For debugfs_path */
+#include "probe-event.h"
+
+#define MAX_CMDLEN 256
+#define MAX_PROBE_ARGS 128
+#define PERFPROBE_GROUP "probe"
+
+#define semantic_error(msg ...) die("Semantic error :" msg)
+
+/* Parse probepoint definition. */
+static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
+{
+	char *ptr, *tmp;
+	char c, nc = 0;
+	/*
+	 * <Syntax>
+	 * perf probe SRC:LN
+	 * perf probe FUNC[+OFFS|%return][@SRC]
+	 */
+
+	ptr = strpbrk(arg, ":+@%");
+	if (ptr) {
+		nc = *ptr;
+		*ptr++ = '\0';
+	}
+
+	/* Check arg is function or file and copy it */
+	if (strchr(arg, '.'))	/* File */
+		pp->file = strdup(arg);
+	else			/* Function */
+		pp->function = strdup(arg);
+	DIE_IF(pp->file == NULL && pp->function == NULL);
+
+	/* Parse other options */
+	while (ptr) {
+		arg = ptr;
+		c = nc;
+		ptr = strpbrk(arg, ":+@%");
+		if (ptr) {
+			nc = *ptr;
+			*ptr++ = '\0';
+		}
+		switch (c) {
+		case ':':	/* Line number */
+			pp->line = strtoul(arg, &tmp, 0);
+			if (*tmp != '\0')
+				semantic_error("There is non-digit charactor"
+						" in line number.");
+			break;
+		case '+':	/* Byte offset from a symbol */
+			pp->offset = strtoul(arg, &tmp, 0);
+			if (*tmp != '\0')
+				semantic_error("There is non-digit charactor"
+						" in offset.");
+			break;
+		case '@':	/* File name */
+			if (pp->file)
+				semantic_error("SRC@SRC is not allowed.");
+			pp->file = strdup(arg);
+			DIE_IF(pp->file == NULL);
+			if (ptr)
+				semantic_error("@SRC must be the last "
+					       "option.");
+			break;
+		case '%':	/* Probe places */
+			if (strcmp(arg, "return") == 0) {
+				pp->retprobe = 1;
+			} else	/* Others not supported yet */
+				semantic_error("%%%s is not supported.", arg);
+			break;
+		default:
+			DIE_IF("Program has a bug.");
+			break;
+		}
+	}
+
+	/* Exclusion check */
+	if (pp->line && pp->offset)
+		semantic_error("Offset can't be used with line number.");
+
+	if (!pp->line && pp->file && !pp->function)
+		semantic_error("File always requires line number.");
+
+	if (pp->offset && !pp->function)
+		semantic_error("Offset requires an entry function.");
+
+	if (pp->retprobe && !pp->function)
+		semantic_error("Return probe requires an entry function.");
+
+	if ((pp->offset || pp->line) && pp->retprobe)
+		semantic_error("Offset/Line can't be used with return probe.");
+
+	pr_debug("symbol:%s file:%s line:%d offset:%d, return:%d\n",
+		 pp->function, pp->file, pp->line, pp->offset, pp->retprobe);
+}
+
+/* Parse perf-probe event definition */
+int parse_perf_probe_event(const char *str, struct probe_point *pp)
+{
+	char *argv[MAX_PROBE_ARGS + 1];	/* probe + args */
+	int argc, i, need_dwarf = 0;
+
+	/* Separate arguments, similar to argv_split */
+	argc = 0;
+	do {
+		/* Skip separators */
+		while (isspace(*str))
+			str++;
+
+		/* Add an argument */
+		if (*str != '\0') {
+			const char *s = str;
+			/* Check the limit number of arguments */
+			if (argc == MAX_PROBE_ARGS + 1)
+				semantic_error("Too many arguments");
+
+			/* Skip the argument */
+			while (!isspace(*str) && *str != '\0')
+				str++;
+
+			/* Duplicate the argument */
+			argv[argc] = strndup(s, str - s);
+			if (argv[argc] == NULL)
+				die("strndup");
+			pr_debug("argv[%d]=%s\n", argc, argv[argc]);
+			argc++;
+		}
+	} while (*str != '\0');
+	if (!argc)
+		semantic_error("An empty argument.");
+
+	/* Parse probe point */
+	parse_perf_probe_probepoint(argv[0], pp);
+	free(argv[0]);
+	if (pp->file || pp->line)
+		need_dwarf = 1;
+
+	/* Copy arguments */
+	pp->nr_args = argc - 1;
+	if (pp->nr_args > 0) {
+		pp->args = (char **)malloc(sizeof(char *) * pp->nr_args);
+		if (!pp->args)
+			die("malloc");
+		memcpy(pp->args, &argv[1], sizeof(char *) * pp->nr_args);
+	}
+
+	/* Ensure return probe has no C argument */
+	for (i = 0; i < pp->nr_args; i++)
+		if (is_c_varname(pp->args[i])) {
+			if (pp->retprobe)
+				semantic_error("You can't specify local"
+						" variable for kretprobe");
+			need_dwarf = 1;
+		}
+
+	return need_dwarf;
+}
+
+int synthesize_trace_kprobe_event(struct probe_point *pp)
+{
+	char *buf;
+	int i, len, ret;
+
+	pp->probes[0] = buf = zalloc(MAX_CMDLEN);
+	if (!buf)
+		die("Failed to allocate memory by zalloc.");
+	ret = snprintf(buf, MAX_CMDLEN, "%s+%d", pp->function, pp->offset);
+	if (ret <= 0 || ret >= MAX_CMDLEN)
+		goto error;
+	len = ret;
+
+	for (i = 0; i < pp->nr_args; i++) {
+		ret = snprintf(&buf[len], MAX_CMDLEN - len, " %s",
+			       pp->args[i]);
+		if (ret <= 0 || ret >= MAX_CMDLEN - len)
+			goto error;
+		len += ret;
+	}
+	pp->found = 1;
+
+	return pp->found;
+error:
+	free(pp->probes[0]);
+	if (ret > 0)
+		ret = -E2BIG;
+
+	return ret;
+}
+
+static int write_trace_kprobe_event(int fd, const char *buf)
+{
+	int ret;
+
+	ret = write(fd, buf, strlen(buf));
+	if (ret <= 0)
+		die("Failed to create event.");
+	else
+		printf("Added new event: %s\n", buf);
+
+	return ret;
+}
+
+void add_trace_kprobe_events(struct probe_point *probes, int nr_probes)
+{
+	int i, j, fd;
+	struct probe_point *pp;
+	char buf[MAX_CMDLEN];
+
+	snprintf(buf, MAX_CMDLEN, "%s/../kprobe_events", debugfs_path);
+	fd = open(buf, O_WRONLY, O_APPEND);
+	if (fd < 0) {
+		if (errno == ENOENT)
+			die("kprobe_events file does not exist -"
+			    " please rebuild with CONFIG_KPROBE_TRACER.");
+		else
+			die("Could not open kprobe_events file: %s",
+			    strerror(errno));
+	}
+
+	for (j = 0; j < nr_probes; j++) {
+		pp = probes + j;
+		if (pp->found == 1) {
+			snprintf(buf, MAX_CMDLEN, "%c:%s/%s_%x %s\n",
+				pp->retprobe ? 'r' : 'p', PERFPROBE_GROUP,
+				pp->function, pp->offset, pp->probes[0]);
+			write_trace_kprobe_event(fd, buf);
+		} else
+			for (i = 0; i < pp->found; i++) {
+				snprintf(buf, MAX_CMDLEN, "%c:%s/%s_%x_%d %s\n",
+					pp->retprobe ? 'r' : 'p',
+					PERFPROBE_GROUP,
+					pp->function, pp->offset, i,
+					pp->probes[i]);
+				write_trace_kprobe_event(fd, buf);
+			}
+	}
+	close(fd);
+}
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
new file mode 100644
index 0000000..0089c45
--- /dev/null
+++ b/tools/perf/util/probe-event.h
@@ -0,0 +1,10 @@
+#ifndef _PROBE_EVENT_H
+#define _PROBE_EVENT_H
+
+#include "probe-finder.h"
+
+extern int parse_perf_probe_event(const char *str, struct probe_point *pp);
+extern int synthesize_trace_kprobe_event(struct probe_point *pp);
+extern void add_trace_kprobe_events(struct probe_point *probes, int nr_probes);
+
+#endif /*_PROBE_EVENT_H */


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
