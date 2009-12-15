Return-Path: <linux-kernel-owner+w=401wt.eu-S932354AbZLOP16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354AbZLOP16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 10:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757033AbZLOP1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 10:27:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756734AbZLOP13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 10:27:29 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 01/14] perf probe: Cleanup struct session in
	builtin-probe.c
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 15 Dec 2009 10:31:14 -0500
Message-ID: <20091215153114.17436.77000.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091215153106.17436.66584.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091215153106.17436.66584.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup struct session in builtin-probe.c, including
change need_dwarf to bool and move listing flag into
struct session as list_events flag.
This also changes parse_perf_probe_event() interface
due to code readability.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
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
---

 tools/perf/builtin-probe.c    |   13 +++++++------
 tools/perf/util/probe-event.c |   12 +++++++-----
 tools/perf/util/probe-event.h |    4 +++-
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 5a47c1e..559eeb4 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -59,13 +59,13 @@ const char *default_search_path[NR_SEARCH_PATH] = {
 static struct {
 	char *vmlinux;
 	char *release;
-	int need_dwarf;
+	bool need_dwarf;
+	bool list_events;
 	int nr_probe;
 	struct probe_point probes[MAX_PROBES];
 	struct strlist *dellist;
 } session;
 
-static bool listing;
 
 /* Parse an event definition. Note that any error must die. */
 static void parse_probe_event(const char *str)
@@ -77,7 +77,7 @@ static void parse_probe_event(const char *str)
 		die("Too many probes (> %d) are specified.", MAX_PROBES);
 
 	/* Parse perf-probe event into probe_point */
-	session.need_dwarf = parse_perf_probe_event(str, pp);
+	parse_perf_probe_event(str, pp, &session.need_dwarf);
 
 	pr_debug("%d arguments\n", pp->nr_args);
 }
@@ -166,7 +166,8 @@ static const struct option options[] = {
 	OPT_STRING('k', "vmlinux", &session.vmlinux, "file",
 		"vmlinux/module pathname"),
 #endif
-	OPT_BOOLEAN('l', "list", &listing, "list up current probe events"),
+	OPT_BOOLEAN('l', "list", &session.list_events,
+		    "list up current probe events"),
 	OPT_CALLBACK('d', "del", NULL, "[GROUP:]EVENT", "delete a probe event.",
 		opt_del_probe_event),
 	OPT_CALLBACK('a', "add", NULL,
@@ -207,10 +208,10 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	if (argc > 0)
 		parse_probe_event_argv(argc, argv);
 
-	if ((session.nr_probe == 0 && !session.dellist && !listing))
+	if ((!session.nr_probe && !session.dellist && !session.list_events))
 		usage_with_options(probe_usage, options);
 
-	if (listing) {
+	if (session.list_events) {
 		if (session.nr_probe != 0 || session.dellist) {
 			pr_warning("  Error: Don't use --list with"
 				   " --add/--del.\n");
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index d14a458..add379c 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -150,10 +150,13 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 }
 
 /* Parse perf-probe event definition */
-int parse_perf_probe_event(const char *str, struct probe_point *pp)
+void parse_perf_probe_event(const char *str, struct probe_point *pp,
+			    bool *need_dwarf)
 {
 	char **argv;
-	int argc, i, need_dwarf = 0;
+	int argc, i;
+
+	*need_dwarf = false;
 
 	argv = argv_split(str, &argc);
 	if (!argv)
@@ -164,7 +167,7 @@ int parse_perf_probe_event(const char *str, struct probe_point *pp)
 	/* Parse probe point */
 	parse_perf_probe_probepoint(argv[0], pp);
 	if (pp->file || pp->line)
-		need_dwarf = 1;
+		*need_dwarf = true;
 
 	/* Copy arguments and ensure return probe has no C argument */
 	pp->nr_args = argc - 1;
@@ -177,12 +180,11 @@ int parse_perf_probe_event(const char *str, struct probe_point *pp)
 			if (pp->retprobe)
 				semantic_error("You can't specify local"
 						" variable for kretprobe");
-			need_dwarf = 1;
+			*need_dwarf = true;
 		}
 	}
 
 	argv_free(argv);
-	return need_dwarf;
 }
 
 /* Parse kprobe_events event into struct probe_point */
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index f752159..028575b 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -1,10 +1,12 @@
 #ifndef _PROBE_EVENT_H
 #define _PROBE_EVENT_H
 
+#include <stdbool.h>
 #include "probe-finder.h"
 #include "strlist.h"
 
-extern int parse_perf_probe_event(const char *str, struct probe_point *pp);
+extern void parse_perf_probe_event(const char *str, struct probe_point *pp,
+				   bool *need_dwarf);
 extern int synthesize_perf_probe_event(struct probe_point *pp);
 extern void parse_trace_kprobe_event(const char *str, char **group,
 				     char **event, struct probe_point *pp);


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
