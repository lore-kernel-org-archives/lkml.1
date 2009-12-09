Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbZLIH1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbZLIH1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757291AbZLIH1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:27:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:45729 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757130AbZLIH1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:27:11 -0500
Date: Wed, 9 Dec 2009 07:26:15 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, mingo@redhat.com, peterz@infradead.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, acme@redhat.com, peterz@infradead.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20091208220323.10142.62079.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091208220323.10142.62079.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Support --del option
Message-ID: <tip-fa28244d12337eebcc620b23852ec3cf29582ff9@git.kernel.org>
Git-Commit-ID: fa28244d12337eebcc620b23852ec3cf29582ff9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa28244d12337eebcc620b23852ec3cf29582ff9
Gitweb:     http://git.kernel.org/tip/fa28244d12337eebcc620b23852ec3cf29582ff9
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 8 Dec 2009 17:03:23 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 07:26:53 +0100

perf probe: Support --del option

Support perf probe --del <event> option. Currently,
perf probe can have only one event for each --del option.
If you'd like to delete several probe events, you need
to specify --del for each events.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
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
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
LKML-Reference: <20091208220323.10142.62079.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-probe.c    |   33 ++++++++++++++++++--
 tools/perf/util/probe-event.c |   69 ++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/probe-event.h |    1 +
 3 files changed, 96 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 1c97e13..5a47c1e 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -35,6 +35,7 @@
 #include "perf.h"
 #include "builtin.h"
 #include "util/util.h"
+#include "util/strlist.h"
 #include "util/event.h"
 #include "util/debug.h"
 #include "util/parse-options.h"
@@ -61,6 +62,7 @@ static struct {
 	int need_dwarf;
 	int nr_probe;
 	struct probe_point probes[MAX_PROBES];
+	struct strlist *dellist;
 } session;
 
 static bool listing;
@@ -107,6 +109,17 @@ static int opt_add_probe_event(const struct option *opt __used,
 	return 0;
 }
 
+static int opt_del_probe_event(const struct option *opt __used,
+			       const char *str, int unset __used)
+{
+	if (str) {
+		if (!session.dellist)
+			session.dellist = strlist__new(true, NULL);
+		strlist__add(session.dellist, str);
+	}
+	return 0;
+}
+
 #ifndef NO_LIBDWARF
 static int open_default_vmlinux(void)
 {
@@ -141,6 +154,7 @@ static int open_default_vmlinux(void)
 static const char * const probe_usage[] = {
 	"perf probe [<options>] 'PROBEDEF' ['PROBEDEF' ...]",
 	"perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]",
+	"perf probe [<options>] --del '[GROUP:]EVENT' ...",
 	"perf probe --list",
 	NULL
 };
@@ -152,7 +166,9 @@ static const struct option options[] = {
 	OPT_STRING('k', "vmlinux", &session.vmlinux, "file",
 		"vmlinux/module pathname"),
 #endif
-	OPT_BOOLEAN('l', "list", &listing, "list up current probes"),
+	OPT_BOOLEAN('l', "list", &listing, "list up current probe events"),
+	OPT_CALLBACK('d', "del", NULL, "[GROUP:]EVENT", "delete a probe event.",
+		opt_del_probe_event),
 	OPT_CALLBACK('a', "add", NULL,
 #ifdef NO_LIBDWARF
 		"FUNC[+OFFS|%return] [ARG ...]",
@@ -191,15 +207,26 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	if (argc > 0)
 		parse_probe_event_argv(argc, argv);
 
-	if ((session.nr_probe == 0 && !listing) ||
-	    (session.nr_probe != 0 && listing))
+	if ((session.nr_probe == 0 && !session.dellist && !listing))
 		usage_with_options(probe_usage, options);
 
 	if (listing) {
+		if (session.nr_probe != 0 || session.dellist) {
+			pr_warning("  Error: Don't use --list with"
+				   " --add/--del.\n");
+			usage_with_options(probe_usage, options);
+		}
 		show_perf_probe_events();
 		return 0;
 	}
 
+	if (session.dellist) {
+		del_trace_kprobe_events(session.dellist);
+		strlist__delete(session.dellist);
+		if (session.nr_probe == 0)
+			return 0;
+	}
+
 	if (session.need_dwarf)
 #ifdef NO_LIBDWARF
 		die("Debuginfo-analysis is not supported");
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 31beedc..9480d99 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -430,10 +430,11 @@ void show_perf_probe_events(void)
 }
 
 /* Get current perf-probe event names */
-static struct strlist *get_perf_event_names(int fd)
+static struct strlist *get_perf_event_names(int fd, bool include_group)
 {
 	unsigned int i;
 	char *group, *event;
+	char buf[128];
 	struct strlist *sl, *rawlist;
 	struct str_node *ent;
 
@@ -443,7 +444,12 @@ static struct strlist *get_perf_event_names(int fd)
 	for (i = 0; i < strlist__nr_entries(rawlist); i++) {
 		ent = strlist__entry(rawlist, i);
 		parse_trace_kprobe_event(ent->s, &group, &event, NULL);
-		strlist__add(sl, event);
+		if (include_group) {
+			if (e_snprintf(buf, 128, "%s:%s", group, event) < 0)
+				die("Failed to copy group:event name.");
+			strlist__add(sl, buf);
+		} else
+			strlist__add(sl, event);
 		free(group);
 		free(event);
 	}
@@ -457,9 +463,10 @@ static void write_trace_kprobe_event(int fd, const char *buf)
 {
 	int ret;
 
+	pr_debug("Writing event: %s\n", buf);
 	ret = write(fd, buf, strlen(buf));
 	if (ret <= 0)
-		die("Failed to create event.");
+		die("Failed to write event: %s", strerror(errno));
 }
 
 static void get_new_event_name(char *buf, size_t len, const char *base,
@@ -496,7 +503,7 @@ void add_trace_kprobe_events(struct probe_point *probes, int nr_probes)
 
 	fd = open_kprobe_events(O_RDWR, O_APPEND);
 	/* Get current event names */
-	namelist = get_perf_event_names(fd);
+	namelist = get_perf_event_names(fd, false);
 
 	for (j = 0; j < nr_probes; j++) {
 		pp = probes + j;
@@ -524,3 +531,57 @@ void add_trace_kprobe_events(struct probe_point *probes, int nr_probes)
 	strlist__delete(namelist);
 	close(fd);
 }
+
+static void del_trace_kprobe_event(int fd, const char *group,
+				   const char *event, struct strlist *namelist)
+{
+	char buf[128];
+
+	if (e_snprintf(buf, 128, "%s:%s", group, event) < 0)
+		die("Failed to copy event.");
+	if (!strlist__has_entry(namelist, buf)) {
+		pr_warning("Warning: event \"%s\" is not found.\n", buf);
+		return;
+	}
+	/* Convert from perf-probe event to trace-kprobe event */
+	if (e_snprintf(buf, 128, "-:%s/%s", group, event) < 0)
+		die("Failed to copy event.");
+
+	write_trace_kprobe_event(fd, buf);
+	printf("Remove event: %s:%s\n", group, event);
+}
+
+void del_trace_kprobe_events(struct strlist *dellist)
+{
+	int fd;
+	unsigned int i;
+	const char *group, *event;
+	char *p, *str;
+	struct str_node *ent;
+	struct strlist *namelist;
+
+	fd = open_kprobe_events(O_RDWR, O_APPEND);
+	/* Get current event names */
+	namelist = get_perf_event_names(fd, true);
+
+	for (i = 0; i < strlist__nr_entries(dellist); i++) {
+		ent = strlist__entry(dellist, i);
+		str = strdup(ent->s);
+		if (!str)
+			die("Failed to copy event.");
+		p = strchr(str, ':');
+		if (p) {
+			group = str;
+			*p = '\0';
+			event = p + 1;
+		} else {
+			group = PERFPROBE_GROUP;
+			event = str;
+		}
+		del_trace_kprobe_event(fd, group, event, namelist);
+		free(str);
+	}
+	strlist__delete(namelist);
+	close(fd);
+}
+
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 0c6fe56..f752159 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -10,6 +10,7 @@ extern void parse_trace_kprobe_event(const char *str, char **group,
 				     char **event, struct probe_point *pp);
 extern int synthesize_trace_kprobe_event(struct probe_point *pp);
 extern void add_trace_kprobe_events(struct probe_point *probes, int nr_probes);
+extern void del_trace_kprobe_events(struct strlist *dellist);
 extern void show_perf_probe_events(void);
 
 /* Maximum index number of event-name postfix */
