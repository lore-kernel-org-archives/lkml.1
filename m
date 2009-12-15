Return-Path: <linux-kernel-owner+w=401wt.eu-S1760986AbZLOT3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760986AbZLOT3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760971AbZLOT3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:29:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:50994 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760968AbZLOT3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:29:08 -0500
Date: Tue, 15 Dec 2009 19:26:54 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, mingo@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       fche@redhat.com, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, acme@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       fche@redhat.com, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20091215153218.17436.84675.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091215153218.17436.84675.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Support event name for --add option
Message-ID: <tip-af663d75a64d2cc3f18bdb8a29ff4650b9417c16@git.kernel.org>
Git-Commit-ID: af663d75a64d2cc3f18bdb8a29ff4650b9417c16
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af663d75a64d2cc3f18bdb8a29ff4650b9417c16
Gitweb:     http://git.kernel.org/tip/af663d75a64d2cc3f18bdb8a29ff4650b9417c16
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 15 Dec 2009 10:32:18 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Dec 2009 20:22:03 +0100

perf probe: Support event name for --add option

Support event name syntax for --add option. This allows
users to specify event name for each new event.

The --add syntax is:
 perf probe --add '[EVENT=]SRC:LINE ARGS'
or
 perf probe --add '[EVENT=]FUNC[+OFFS|%return|:RLN][@SRC] ARGS'

e.g.

 ./perf probe --add myprobe1=schedule

Note: currently group name is not supported yet, because it
can cause name-space confliction with other tracepoint/
hw-breakpoint events.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091215153218.17436.84675.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Documentation/perf-probe.txt |    3 +-
 tools/perf/builtin-probe.c              |    8 ++--
 tools/perf/util/probe-event.c           |   74 +++++++++++++++++++------------
 tools/perf/util/probe-event.h           |    3 +-
 tools/perf/util/probe-finder.h          |    3 +
 5 files changed, 55 insertions(+), 36 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 8fa6bf9..250e391 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -49,8 +49,9 @@ PROBE SYNTAX
 ------------
 Probe points are defined by following syntax.
 
- "FUNC[+OFFS|:RLN|%return][@SRC]|SRC:ALN [ARG ...]"
+ "[EVENT=]FUNC[+OFFS|:RLN|%return][@SRC]|SRC:ALN [ARG ...]"
 
+'EVENT' specifies the name of new event, if omitted, it will be set the name of the probed function. Currently, event group name is set as 'probe'.
 'FUNC' specifies a probed function name, and it may have one of the following options; '+OFFS' is the offset from function entry address in bytes, 'RLN' is the relative-line number from function entry line, and '%return' means that it probes function return. In addition, 'SRC' specifies a source file which has that function.
 It is also possible to specify a probe point by the source line number by using 'SRC:ALN' syntax, where 'SRC' is the source file path and 'ALN' is the line number.
 'ARG' specifies the arguments of this probe point. You can use the name of local variable, or kprobe-tracer argument format (e.g. $retval, %ax, etc).
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 438a7bb..adc0a55 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -172,13 +172,13 @@ static const struct option options[] = {
 		opt_del_probe_event),
 	OPT_CALLBACK('a', "add", NULL,
 #ifdef NO_LIBDWARF
-		"FUNC[+OFFS|%return] [ARG ...]",
+		"[EVENT=]FUNC[+OFFS|%return] [ARG ...]",
 #else
-		"FUNC[+OFFS|%return|:RLN][@SRC]|SRC:ALN [ARG ...]",
+		"[EVENT=]FUNC[+OFFS|%return|:RLN][@SRC]|SRC:ALN [ARG ...]",
 #endif
 		"probe point definition, where\n"
-		"\t\tGRP:\tGroup name (optional)\n"
-		"\t\tNAME:\tEvent name\n"
+		"\t\tGROUP:\tGroup name (optional)\n"
+		"\t\tEVENT:\tEvent name\n"
 		"\t\tFUNC:\tFunction name\n"
 		"\t\tOFFS:\tOffset from function entry (in byte)\n"
 		"\t\t%return:\tPut the probe at function return\n"
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 5e99e52..3b4cf45 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -69,10 +69,23 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 	char c, nc = 0;
 	/*
 	 * <Syntax>
-	 * perf probe SRC:LN
-	 * perf probe FUNC[+OFFS|%return][@SRC]
+	 * perf probe [EVENT=]SRC:LN
+	 * perf probe [EVENT=]FUNC[+OFFS|%return][@SRC]
+	 *
+	 * TODO:Group name support
 	 */
 
+	ptr = strchr(arg, '=');
+	if (ptr) {	/* Event name */
+		*ptr = '\0';
+		tmp = ptr + 1;
+		ptr = strchr(arg, ':');
+		if (ptr)	/* Group name is not supported yet. */
+			semantic_error("Group name is not supported yet.");
+		pp->event = strdup(arg);
+		arg = tmp;
+	}
+
 	ptr = strpbrk(arg, ":+@%");
 	if (ptr) {
 		nc = *ptr;
@@ -188,8 +201,7 @@ void parse_perf_probe_event(const char *str, struct probe_point *pp,
 }
 
 /* Parse kprobe_events event into struct probe_point */
-void parse_trace_kprobe_event(const char *str, char **group, char **event,
-			      struct probe_point *pp)
+void parse_trace_kprobe_event(const char *str, struct probe_point *pp)
 {
 	char pr;
 	char *p;
@@ -205,18 +217,17 @@ void parse_trace_kprobe_event(const char *str, char **group, char **event,
 
 	/* Scan event and group name. */
 	ret = sscanf(argv[0], "%c:%a[^/ \t]/%a[^ \t]",
-		     &pr, (float *)(void *)group, (float *)(void *)event);
+		     &pr, (float *)(void *)&pp->group,
+		     (float *)(void *)&pp->event);
 	if (ret != 3)
 		semantic_error("Failed to parse event name: %s", argv[0]);
-	pr_debug("Group:%s Event:%s probe:%c\n", *group, *event, pr);
-
-	if (!pp)
-		goto end;
+	pr_debug("Group:%s Event:%s probe:%c\n", pp->group, pp->event, pr);
 
 	pp->retprobe = (pr == 'r');
 
 	/* Scan function name and offset */
-	ret = sscanf(argv[1], "%a[^+]+%d", (float *)(void *)&pp->function, &pp->offset);
+	ret = sscanf(argv[1], "%a[^+]+%d", (float *)(void *)&pp->function,
+		     &pp->offset);
 	if (ret == 1)
 		pp->offset = 0;
 
@@ -235,7 +246,6 @@ void parse_trace_kprobe_event(const char *str, char **group, char **event,
 			die("Failed to copy argument.");
 	}
 
-end:
 	argv_free(argv);
 }
 
@@ -368,6 +378,10 @@ static void clear_probe_point(struct probe_point *pp)
 {
 	int i;
 
+	if (pp->event)
+		free(pp->event);
+	if (pp->group)
+		free(pp->group);
 	if (pp->function)
 		free(pp->function);
 	if (pp->file)
@@ -382,13 +396,13 @@ static void clear_probe_point(struct probe_point *pp)
 }
 
 /* Show an event */
-static void show_perf_probe_event(const char *group, const char *event,
-				  const char *place, struct probe_point *pp)
+static void show_perf_probe_event(const char *event, const char *place,
+				  struct probe_point *pp)
 {
 	int i, ret;
 	char buf[128];
 
-	ret = e_snprintf(buf, 128, "%s:%s", group, event);
+	ret = e_snprintf(buf, 128, "%s:%s", pp->group, event);
 	if (ret < 0)
 		die("Failed to copy event: %s", strerror(-ret));
 	printf("  %-40s (on %s", buf, place);
@@ -405,7 +419,6 @@ static void show_perf_probe_event(const char *group, const char *event,
 void show_perf_probe_events(void)
 {
 	int fd, nr;
-	char *group, *event;
 	struct probe_point pp;
 	struct strlist *rawlist;
 	struct str_node *ent;
@@ -415,16 +428,14 @@ void show_perf_probe_events(void)
 	close(fd);
 
 	strlist__for_each(ent, rawlist) {
-		parse_trace_kprobe_event(ent->s, &group, &event, &pp);
+		parse_trace_kprobe_event(ent->s, &pp);
 		/* Synthesize only event probe point */
 		nr = pp.nr_args;
 		pp.nr_args = 0;
 		synthesize_perf_probe_event(&pp);
 		pp.nr_args = nr;
 		/* Show an event */
-		show_perf_probe_event(group, event, pp.probes[0], &pp);
-		free(group);
-		free(event);
+		show_perf_probe_event(pp.event, pp.probes[0], &pp);
 		clear_probe_point(&pp);
 	}
 
@@ -434,24 +445,25 @@ void show_perf_probe_events(void)
 /* Get current perf-probe event names */
 static struct strlist *get_perf_event_names(int fd, bool include_group)
 {
-	char *group, *event;
 	char buf[128];
 	struct strlist *sl, *rawlist;
 	struct str_node *ent;
+	struct probe_point pp;
 
+	memset(&pp, 0, sizeof(pp));
 	rawlist = get_trace_kprobe_event_rawlist(fd);
 
 	sl = strlist__new(true, NULL);
 	strlist__for_each(ent, rawlist) {
-		parse_trace_kprobe_event(ent->s, &group, &event, NULL);
+		parse_trace_kprobe_event(ent->s, &pp);
 		if (include_group) {
-			if (e_snprintf(buf, 128, "%s:%s", group, event) < 0)
+			if (e_snprintf(buf, 128, "%s:%s", pp.group,
+				       pp.event) < 0)
 				die("Failed to copy group:event name.");
 			strlist__add(sl, buf);
 		} else
-			strlist__add(sl, event);
-		free(group);
-		free(event);
+			strlist__add(sl, pp.event);
+		clear_probe_point(&pp);
 	}
 
 	strlist__delete(rawlist);
@@ -507,19 +519,23 @@ void add_trace_kprobe_events(struct probe_point *probes, int nr_probes)
 
 	for (j = 0; j < nr_probes; j++) {
 		pp = probes + j;
+		if (!pp->event)
+			pp->event = strdup(pp->function);
+		if (!pp->group)
+			pp->group = strdup(PERFPROBE_GROUP);
+		DIE_IF(!pp->event || !pp->group);
 		for (i = 0; i < pp->found; i++) {
 			/* Get an unused new event name */
-			get_new_event_name(event, 64, pp->function, namelist);
+			get_new_event_name(event, 64, pp->event, namelist);
 			snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s\n",
 				 pp->retprobe ? 'r' : 'p',
-				 PERFPROBE_GROUP, event,
+				 pp->group, event,
 				 pp->probes[i]);
 			write_trace_kprobe_event(fd, buf);
 			printf("Added new event:\n");
 			/* Get the first parameter (probe-point) */
 			sscanf(pp->probes[i], "%s", buf);
-			show_perf_probe_event(PERFPROBE_GROUP, event,
-					      buf, pp);
+			show_perf_probe_event(event, buf, pp);
 			/* Add added event name to namelist */
 			strlist__add(namelist, event);
 		}
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 028575b..8bb22f5 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -8,8 +8,7 @@
 extern void parse_perf_probe_event(const char *str, struct probe_point *pp,
 				   bool *need_dwarf);
 extern int synthesize_perf_probe_event(struct probe_point *pp);
-extern void parse_trace_kprobe_event(const char *str, char **group,
-				     char **event, struct probe_point *pp);
+extern void parse_trace_kprobe_event(const char *str, struct probe_point *pp);
 extern int synthesize_trace_kprobe_event(struct probe_point *pp);
 extern void add_trace_kprobe_events(struct probe_point *probes, int nr_probes);
 extern void del_trace_kprobe_events(struct strlist *dellist);
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index bdebca6..5e4050c 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -12,6 +12,9 @@ static inline int is_c_varname(const char *name)
 }
 
 struct probe_point {
+	char	*event;		/* Event name */
+	char	*group;		/* Event group */
+
 	/* Inputs */
 	char	*file;		/* File name */
 	int	line;		/* Line number */
