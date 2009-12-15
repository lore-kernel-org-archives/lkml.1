Return-Path: <linux-kernel-owner+w=401wt.eu-S1760944AbZLOTaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760944AbZLOTaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933556AbZLOTaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:30:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:51029 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760944AbZLOT3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:29:47 -0500
Date: Tue, 15 Dec 2009 19:27:08 GMT
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
In-Reply-To: <20091215153225.17436.15166.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091215153225.17436.15166.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Reject second attempt of adding same-name event
Message-ID: <tip-d761b08bff0a9b653f6bd248cea50322e7eccb14@git.kernel.org>
Git-Commit-ID: d761b08bff0a9b653f6bd248cea50322e7eccb14
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d761b08bff0a9b653f6bd248cea50322e7eccb14
Gitweb:     http://git.kernel.org/tip/d761b08bff0a9b653f6bd248cea50322e7eccb14
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 15 Dec 2009 10:32:25 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Dec 2009 20:22:04 +0100

perf probe: Reject second attempt of adding same-name event

Reject second attempt of adding same-name event. This patch
also provides --force option which allows user to add additional
probe events on the same-name event.

e.g.
(the first attempt : success)
 ./perf probe schedule
 Added new event:
   probe:schedule                           (on schedule+0)

(the second attempt : failure)
 ./perf probe schedule:11
 Error: event "schedule" already exists. (Use -f to force duplicates.)
   Fatal: Can't add new event.

(the second attempt with -f : successfully added)
 ./perf probe -f schedule:11
 Added new event:
   probe:schedule_1                         (on schedule+45)

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
LKML-Reference: <20091215153225.17436.15166.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-probe.c    |    6 +++++-
 tools/perf/util/probe-event.c |   24 +++++++++++++++++++++---
 tools/perf/util/probe-event.h |    3 ++-
 3 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index adc0a55..8b4fdae 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -61,6 +61,7 @@ static struct {
 	char *release;
 	bool need_dwarf;
 	bool list_events;
+	bool force_add;
 	int nr_probe;
 	struct probe_point probes[MAX_PROBES];
 	struct strlist *dellist;
@@ -192,6 +193,8 @@ static const struct option options[] = {
 #endif
 		"\t\t\tkprobe-tracer argument format.)\n",
 		opt_add_probe_event),
+	OPT_BOOLEAN('f', "force", &session.force_add, "forcibly add events"
+		    " with existing name"),
 	OPT_END()
 };
 
@@ -294,7 +297,8 @@ end_dwarf:
 	}
 
 	/* Settng up probe points */
-	add_trace_kprobe_events(session.probes, session.nr_probe);
+	add_trace_kprobe_events(session.probes, session.nr_probe,
+				session.force_add);
 	return 0;
 }
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 3b4cf45..b05d532 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -482,7 +482,7 @@ static void write_trace_kprobe_event(int fd, const char *buf)
 }
 
 static void get_new_event_name(char *buf, size_t len, const char *base,
-			       struct strlist *namelist)
+			       struct strlist *namelist, bool allow_suffix)
 {
 	int i, ret;
 
@@ -493,6 +493,12 @@ static void get_new_event_name(char *buf, size_t len, const char *base,
 	if (!strlist__has_entry(namelist, buf))
 		return;
 
+	if (!allow_suffix) {
+		pr_warning("Error: event \"%s\" already exists. "
+			   "(Use -f to force duplicates.)\n", base);
+		die("Can't add new event.");
+	}
+
 	/* Try to add suffix */
 	for (i = 1; i < MAX_EVENT_INDEX; i++) {
 		ret = e_snprintf(buf, len, "%s_%d", base, i);
@@ -505,13 +511,15 @@ static void get_new_event_name(char *buf, size_t len, const char *base,
 		die("Too many events are on the same function.");
 }
 
-void add_trace_kprobe_events(struct probe_point *probes, int nr_probes)
+void add_trace_kprobe_events(struct probe_point *probes, int nr_probes,
+			     bool force_add)
 {
 	int i, j, fd;
 	struct probe_point *pp;
 	char buf[MAX_CMDLEN];
 	char event[64];
 	struct strlist *namelist;
+	bool allow_suffix;
 
 	fd = open_kprobe_events(O_RDWR, O_APPEND);
 	/* Get current event names */
@@ -524,9 +532,12 @@ void add_trace_kprobe_events(struct probe_point *probes, int nr_probes)
 		if (!pp->group)
 			pp->group = strdup(PERFPROBE_GROUP);
 		DIE_IF(!pp->event || !pp->group);
+		/* If force_add is true, suffix search is allowed */
+		allow_suffix = force_add;
 		for (i = 0; i < pp->found; i++) {
 			/* Get an unused new event name */
-			get_new_event_name(event, 64, pp->event, namelist);
+			get_new_event_name(event, 64, pp->event, namelist,
+					   allow_suffix);
 			snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s\n",
 				 pp->retprobe ? 'r' : 'p',
 				 pp->group, event,
@@ -538,6 +549,13 @@ void add_trace_kprobe_events(struct probe_point *probes, int nr_probes)
 			show_perf_probe_event(event, buf, pp);
 			/* Add added event name to namelist */
 			strlist__add(namelist, event);
+			/*
+			 * Probes after the first probe which comes from same
+			 * user input are always allowed to add suffix, because
+			 * there might be several addresses corresponding to
+			 * one code line.
+			 */
+			allow_suffix = true;
 		}
 	}
 	/* Show how to use the event. */
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 8bb22f5..8fd3052 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -10,7 +10,8 @@ extern void parse_perf_probe_event(const char *str, struct probe_point *pp,
 extern int synthesize_perf_probe_event(struct probe_point *pp);
 extern void parse_trace_kprobe_event(const char *str, struct probe_point *pp);
 extern int synthesize_trace_kprobe_event(struct probe_point *pp);
-extern void add_trace_kprobe_events(struct probe_point *probes, int nr_probes);
+extern void add_trace_kprobe_events(struct probe_point *probes, int nr_probes,
+				    bool force_add);
 extern void del_trace_kprobe_events(struct strlist *dellist);
 extern void show_perf_probe_events(void);
 
