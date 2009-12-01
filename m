Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbZLAAVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbZLAAVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 19:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbZLAAU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 19:20:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbZLAAUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 19:20:54 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 9/9] perf probe: Simplify event naming
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
Date: Mon, 30 Nov 2009 19:20:25 -0500
Message-ID: <20091201002024.10235.2353.stgit@harusame>
In-Reply-To: <20091201001912.10235.79411.stgit@harusame>
References: <20091201001912.10235.79411.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify event naming as <symbol>_<seqnum>. Each event name is
globally unique (group name is not checked). So, if there is
schedule_0, next probe event on schedule() will be schedule_1.

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

 tools/perf/util/probe-event.c |   67 ++++++++++++++++++++++++++++++++---------
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
