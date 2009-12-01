Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbZLAHd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbZLAHd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 02:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbZLAHd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 02:33:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:37386 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758AbZLAHdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 02:33:54 -0500
Date: Tue, 1 Dec 2009 07:33:11 GMT
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
In-Reply-To: <20091201002024.10235.2353.stgit@harusame>
References: <20091201002024.10235.2353.stgit@harusame>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Simplify event naming
Message-ID: <tip-b498ce1f2753b9724b2fc05d2057f7d1490cfa93@git.kernel.org>
Git-Commit-ID: b498ce1f2753b9724b2fc05d2057f7d1490cfa93
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b498ce1f2753b9724b2fc05d2057f7d1490cfa93
Gitweb:     http://git.kernel.org/tip/b498ce1f2753b9724b2fc05d2057f7d1490cfa93
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 30 Nov 2009 19:20:25 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 1 Dec 2009 08:20:03 +0100

perf probe: Simplify event naming

Simplify event naming as <symbol>_<seqnum>. Each event name is
globally unique (group name is not checked). So, if there is
schedule_0, next probe event on schedule() will be schedule_1.

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
LKML-Reference: <20091201002024.10235.2353.stgit@harusame>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-event.c |   67 ++++++++++++++++++++++++++++++++--------
 tools/perf/util/probe-event.h |    3 ++
 2 files changed, 56 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 7f4f288..e42f3ac 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -403,6 +403,29 @@ void show_perf_probe_events(void)
 	strlist__delete(rawlist);
 }
 
+/* Get current perf-probe event names */
+static struct strlist *get_perf_event_names(int fd)
+{
+	unsigned int i;
+	char *group, *event;
+	struct strlist *sl, *rawlist;
+	struct str_node *ent;
+
+	rawlist = get_trace_kprobe_event_rawlist(fd);
+
+	sl = strlist__new(false, NULL);
+	for (i = 0; i < strlist__nr_entries(rawlist); i++) {
+		ent = strlist__entry(rawlist, i);
+		parse_trace_kprobe_event(ent->s, &group, &event, NULL);
+		strlist__add(sl, event);
+		free(group);
+	}
+
+	strlist__delete(rawlist);
+
+	return sl;
+}
+
 static int write_trace_kprobe_event(int fd, const char *buf)
 {
 	int ret;
@@ -416,30 +439,46 @@ static int write_trace_kprobe_event(int fd, const char *buf)
 	return ret;
 }
 
+static void get_new_event_name(char *buf, size_t len, const char *base,
+			       struct strlist *namelist)
+{
+	int i, ret;
+	for (i = 0; i < MAX_EVENT_INDEX; i++) {
+		ret = e_snprintf(buf, len, "%s_%d", base, i);
+		if (ret < 0)
+			die("snprintf() failed: %s", strerror(-ret));
+		if (!strlist__has_entry(namelist, buf))
+			break;
+	}
+	if (i == MAX_EVENT_INDEX)
+		die("Too many events are on the same function.");
+}
+
 void add_trace_kprobe_events(struct probe_point *probes, int nr_probes)
 {
 	int i, j, fd;
 	struct probe_point *pp;
 	char buf[MAX_CMDLEN];
+	char event[64];
+	struct strlist *namelist;
 
-	fd = open_kprobe_events(O_WRONLY, O_APPEND);
+	fd = open_kprobe_events(O_RDWR, O_APPEND);
+	/* Get current event names */
+	namelist = get_perf_event_names(fd);
 
 	for (j = 0; j < nr_probes; j++) {
 		pp = probes + j;
-		if (pp->found == 1) {
-			snprintf(buf, MAX_CMDLEN, "%c:%s/%s_%x %s\n",
-				pp->retprobe ? 'r' : 'p', PERFPROBE_GROUP,
-				pp->function, pp->offset, pp->probes[0]);
+		for (i = 0; i < pp->found; i++) {
+			/* Get an unused new event name */
+			get_new_event_name(event, 64, pp->function, namelist);
+			snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s\n",
+				 pp->retprobe ? 'r' : 'p',
+				 PERFPROBE_GROUP, event,
+				 pp->probes[i]);
 			write_trace_kprobe_event(fd, buf);
-		} else
-			for (i = 0; i < pp->found; i++) {
-				snprintf(buf, MAX_CMDLEN, "%c:%s/%s_%x_%d %s\n",
-					pp->retprobe ? 'r' : 'p',
-					PERFPROBE_GROUP,
-					pp->function, pp->offset, i,
-					pp->probes[i]);
-				write_trace_kprobe_event(fd, buf);
-			}
+			/* Add added event name to namelist */
+			strlist__add(namelist, event);
+		}
 	}
 	close(fd);
 }
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 88db7d1..0c6fe56 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -12,4 +12,7 @@ extern int synthesize_trace_kprobe_event(struct probe_point *pp);
 extern void add_trace_kprobe_events(struct probe_point *probes, int nr_probes);
 extern void show_perf_probe_events(void);
 
+/* Maximum index number of event-name postfix */
+#define MAX_EVENT_INDEX	1024
+
 #endif /*_PROBE_EVENT_H */
