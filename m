Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbZLAHeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbZLAHeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 02:34:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753782AbZLAHeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 02:34:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:37396 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513AbZLAHeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 02:34:02 -0500
Date: Tue, 1 Dec 2009 07:32:57 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, mingo@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, acme@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20091201002017.10235.76575.stgit@harusame>
References: <20091201002017.10235.76575.stgit@harusame>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Add --list option for listing current probe events
Message-ID: <tip-4de189fe6e5ad8241f6f8709d2e2ba4c3aeae33a@git.kernel.org>
Git-Commit-ID: 4de189fe6e5ad8241f6f8709d2e2ba4c3aeae33a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4de189fe6e5ad8241f6f8709d2e2ba4c3aeae33a
Gitweb:     http://git.kernel.org/tip/4de189fe6e5ad8241f6f8709d2e2ba4c3aeae33a
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 30 Nov 2009 19:20:17 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 1 Dec 2009 08:20:02 +0100

perf probe: Add --list option for listing current probe events

Add --list option for listing currently defined probe events
in the kernel. This shows events in below format;

 [group:event]	<perf-probe probe-definition>

for example:

 [probe:schedule_0]	schedule+30 cpu

Note that source file/line information is not supported yet.
So even if you added a probe by line, it will be shown in
<symbol+offset>.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
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
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091201002017.10235.76575.stgit@harusame>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-probe.c    |   12 ++-
 tools/perf/util/probe-event.c |  231 ++++++++++++++++++++++++++++++++++++++---
 tools/perf/util/probe-event.h |    5 +
 3 files changed, 230 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index bf20df2..b5d15cf 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -62,6 +62,8 @@ static struct {
 	struct probe_point probes[MAX_PROBES];
 } session;
 
+static bool listing;
+
 /* Parse an event definition. Note that any error must die. */
 static void parse_probe_event(const char *str)
 {
@@ -119,6 +121,7 @@ static int open_default_vmlinux(void)
 static const char * const probe_usage[] = {
 	"perf probe [<options>] 'PROBEDEF' ['PROBEDEF' ...]",
 	"perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]",
+	"perf probe --list",
 	NULL
 };
 
@@ -129,6 +132,7 @@ static const struct option options[] = {
 	OPT_STRING('k', "vmlinux", &session.vmlinux, "file",
 		"vmlinux/module pathname"),
 #endif
+	OPT_BOOLEAN('l', "list", &listing, "list up current probes"),
 	OPT_CALLBACK('a', "add", NULL,
 #ifdef NO_LIBDWARF
 		"FUNC[+OFFS|%return] [ARG ...]",
@@ -164,9 +168,15 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	for (i = 0; i < argc; i++)
 		parse_probe_event(argv[i]);
 
-	if (session.nr_probe == 0)
+	if ((session.nr_probe == 0 && !listing) ||
+	    (session.nr_probe != 0 && listing))
 		usage_with_options(probe_usage, options);
 
+	if (listing) {
+		show_perf_probe_events();
+		return 0;
+	}
+
 	if (session.need_dwarf)
 #ifdef NO_LIBDWARF
 		die("Debuginfo-analysis is not supported");
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index e3a683a..7f4f288 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -29,10 +29,13 @@
 #include <unistd.h>
 #include <stdlib.h>
 #include <string.h>
+#include <stdarg.h>
+#include <limits.h>
 
 #undef _GNU_SOURCE
 #include "event.h"
 #include "string.h"
+#include "strlist.h"
 #include "debug.h"
 #include "parse-events.h"  /* For debugfs_path */
 #include "probe-event.h"
@@ -43,6 +46,19 @@
 
 #define semantic_error(msg ...) die("Semantic error :" msg)
 
+/* If there is no space to write, returns -E2BIG. */
+static int e_snprintf(char *str, size_t size, const char *format, ...)
+{
+	int ret;
+	va_list ap;
+	va_start(ap, format);
+	ret = vsnprintf(str, size, format, ap);
+	va_end(ap);
+	if (ret >= (int)size)
+		ret = -E2BIG;
+	return ret;
+}
+
 /* Parse probepoint definition. */
 static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 {
@@ -166,6 +182,103 @@ int parse_perf_probe_event(const char *str, struct probe_point *pp)
 	return need_dwarf;
 }
 
+/* Parse kprobe_events event into struct probe_point */
+void parse_trace_kprobe_event(const char *str, char **group, char **event,
+			      struct probe_point *pp)
+{
+	char pr;
+	char *p;
+	int ret, i, argc;
+	char **argv;
+
+	pr_debug("Parsing kprobe_events: %s\n", str);
+	argv = argv_split(str, &argc);
+	if (!argv)
+		die("argv_split failed.");
+	if (argc < 2)
+		semantic_error("Too less arguments.");
+
+	/* Scan event and group name. */
+	ret = sscanf(argv[0], "%c:%m[^/ \t]/%m[^ \t]",
+		     &pr, group, event);
+	if (ret != 3)
+		semantic_error("Failed to parse event name: %s", argv[0]);
+	pr_debug("Group:%s Event:%s probe:%c\n", *group, *event, pr);
+
+	if (!pp)
+		goto end;
+
+	pp->retprobe = (pr == 'r');
+
+	/* Scan function name and offset */
+	ret = sscanf(argv[1], "%m[^+]+%d", &pp->function, &pp->offset);
+	if (ret == 1)
+		pp->offset = 0;
+
+	/* kprobe_events doesn't have this information */
+	pp->line = 0;
+	pp->file = NULL;
+
+	pp->nr_args = argc - 2;
+	pp->args = zalloc(sizeof(char *) * pp->nr_args);
+	for (i = 0; i < pp->nr_args; i++) {
+		p = strchr(argv[i + 2], '=');
+		if (p)	/* We don't need which register is assigned. */
+			*p = '\0';
+		pp->args[i] = strdup(argv[i + 2]);
+		if (!pp->args[i])
+			die("Failed to copy argument.");
+	}
+
+end:
+	argv_free(argv);
+}
+
+int synthesize_perf_probe_event(struct probe_point *pp)
+{
+	char *buf;
+	char offs[64] = "", line[64] = "";
+	int i, len, ret;
+
+	pp->probes[0] = buf = zalloc(MAX_CMDLEN);
+	if (!buf)
+		die("Failed to allocate memory by zalloc.");
+	if (pp->offset) {
+		ret = e_snprintf(offs, 64, "+%d", pp->offset);
+		if (ret <= 0)
+			goto error;
+	}
+	if (pp->line) {
+		ret = e_snprintf(line, 64, ":%d", pp->line);
+		if (ret <= 0)
+			goto error;
+	}
+
+	if (pp->function)
+		ret = e_snprintf(buf, MAX_CMDLEN, "%s%s%s%s", pp->function,
+				 offs, pp->retprobe ? "%return" : "", line);
+	else
+		ret = e_snprintf(buf, MAX_CMDLEN, "%s%s%s%s", pp->file, line);
+	if (ret <= 0)
+		goto error;
+	len = ret;
+
+	for (i = 0; i < pp->nr_args; i++) {
+		ret = e_snprintf(&buf[len], MAX_CMDLEN - len, " %s",
+				 pp->args[i]);
+		if (ret <= 0)
+			goto error;
+		len += ret;
+	}
+	pp->found = 1;
+
+	return pp->found;
+error:
+	free(pp->probes[0]);
+
+	return ret;
+}
+
 int synthesize_trace_kprobe_event(struct probe_point *pp)
 {
 	char *buf;
@@ -174,15 +287,15 @@ int synthesize_trace_kprobe_event(struct probe_point *pp)
 	pp->probes[0] = buf = zalloc(MAX_CMDLEN);
 	if (!buf)
 		die("Failed to allocate memory by zalloc.");
-	ret = snprintf(buf, MAX_CMDLEN, "%s+%d", pp->function, pp->offset);
-	if (ret <= 0 || ret >= MAX_CMDLEN)
+	ret = e_snprintf(buf, MAX_CMDLEN, "%s+%d", pp->function, pp->offset);
+	if (ret <= 0)
 		goto error;
 	len = ret;
 
 	for (i = 0; i < pp->nr_args; i++) {
-		ret = snprintf(&buf[len], MAX_CMDLEN - len, " %s",
-			       pp->args[i]);
-		if (ret <= 0 || ret >= MAX_CMDLEN - len)
+		ret = e_snprintf(&buf[len], MAX_CMDLEN - len, " %s",
+				 pp->args[i]);
+		if (ret <= 0)
 			goto error;
 		len += ret;
 	}
@@ -191,12 +304,105 @@ int synthesize_trace_kprobe_event(struct probe_point *pp)
 	return pp->found;
 error:
 	free(pp->probes[0]);
-	if (ret > 0)
-		ret = -E2BIG;
 
 	return ret;
 }
 
+static int open_kprobe_events(int flags, int mode)
+{
+	char buf[PATH_MAX];
+	int ret;
+
+	ret = e_snprintf(buf, PATH_MAX, "%s/../kprobe_events", debugfs_path);
+	if (ret < 0)
+		die("Failed to make kprobe_events path.");
+
+	ret = open(buf, flags, mode);
+	if (ret < 0) {
+		if (errno == ENOENT)
+			die("kprobe_events file does not exist -"
+			    " please rebuild with CONFIG_KPROBE_TRACER.");
+		else
+			die("Could not open kprobe_events file: %s",
+			    strerror(errno));
+	}
+	return ret;
+}
+
+/* Get raw string list of current kprobe_events */
+static struct strlist *get_trace_kprobe_event_rawlist(int fd)
+{
+	int ret, idx;
+	FILE *fp;
+	char buf[MAX_CMDLEN];
+	char *p;
+	struct strlist *sl;
+
+	sl = strlist__new(true, NULL);
+
+	fp = fdopen(dup(fd), "r");
+	while (!feof(fp)) {
+		p = fgets(buf, MAX_CMDLEN, fp);
+		if (!p)
+			break;
+
+		idx = strlen(p) - 1;
+		if (p[idx] == '\n')
+			p[idx] = '\0';
+		ret = strlist__add(sl, buf);
+		if (ret < 0)
+			die("strlist__add failed: %s", strerror(-ret));
+	}
+	fclose(fp);
+
+	return sl;
+}
+
+/* Free and zero clear probe_point */
+static void clear_probe_point(struct probe_point *pp)
+{
+	int i;
+
+	if (pp->function)
+		free(pp->function);
+	if (pp->file)
+		free(pp->file);
+	for (i = 0; i < pp->nr_args; i++)
+		free(pp->args[i]);
+	if (pp->args)
+		free(pp->args);
+	for (i = 0; i < pp->found; i++)
+		free(pp->probes[i]);
+	memset(pp, 0, sizeof(pp));
+}
+
+/* List up current perf-probe events */
+void show_perf_probe_events(void)
+{
+	unsigned int i;
+	int fd;
+	char *group, *event;
+	struct probe_point pp;
+	struct strlist *rawlist;
+	struct str_node *ent;
+
+	fd = open_kprobe_events(O_RDONLY, 0);
+	rawlist = get_trace_kprobe_event_rawlist(fd);
+	close(fd);
+
+	for (i = 0; i < strlist__nr_entries(rawlist); i++) {
+		ent = strlist__entry(rawlist, i);
+		parse_trace_kprobe_event(ent->s, &group, &event, &pp);
+		synthesize_perf_probe_event(&pp);
+		printf("[%s:%s]\t%s\n", group, event, pp.probes[0]);
+		free(group);
+		free(event);
+		clear_probe_point(&pp);
+	}
+
+	strlist__delete(rawlist);
+}
+
 static int write_trace_kprobe_event(int fd, const char *buf)
 {
 	int ret;
@@ -216,16 +422,7 @@ void add_trace_kprobe_events(struct probe_point *probes, int nr_probes)
 	struct probe_point *pp;
 	char buf[MAX_CMDLEN];
 
-	snprintf(buf, MAX_CMDLEN, "%s/../kprobe_events", debugfs_path);
-	fd = open(buf, O_WRONLY, O_APPEND);
-	if (fd < 0) {
-		if (errno == ENOENT)
-			die("kprobe_events file does not exist -"
-			    " please rebuild with CONFIG_KPROBE_TRACER.");
-		else
-			die("Could not open kprobe_events file: %s",
-			    strerror(errno));
-	}
+	fd = open_kprobe_events(O_WRONLY, O_APPEND);
 
 	for (j = 0; j < nr_probes; j++) {
 		pp = probes + j;
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 0089c45..88db7d1 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -2,9 +2,14 @@
 #define _PROBE_EVENT_H
 
 #include "probe-finder.h"
+#include "strlist.h"
 
 extern int parse_perf_probe_event(const char *str, struct probe_point *pp);
+extern int synthesize_perf_probe_event(struct probe_point *pp);
+extern void parse_trace_kprobe_event(const char *str, char **group,
+				     char **event, struct probe_point *pp);
 extern int synthesize_trace_kprobe_event(struct probe_point *pp);
 extern void add_trace_kprobe_events(struct probe_point *probes, int nr_probes);
+extern void show_perf_probe_events(void);
 
 #endif /*_PROBE_EVENT_H */
