Return-Path: <linux-kernel-owner+w=401wt.eu-S966571AbZLHV7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966571AbZLHV7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:59:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966554AbZLHV64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:58:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966552AbZLHV6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:58:46 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 1/8] perf probe: Change event list format
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 08 Dec 2009 17:02:40 -0500
Message-ID: <20091208220240.10142.42916.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091208220232.10142.2643.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091208220232.10142.2643.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change event list format for user readability. perf probe --list
shows event list in "[GROUP:EVENT] EVENT-DEFINITION" format, but
this format is different from the output of perf-list, and
EVENT-DEFINITION is a bit blunt. This patch changes the
format to more user friendly one.

Before:
[probe:shedule_0]	schedule+10 prev cpu

After:
  probe:schedule_0                         (on schedule+10 with prev cpu)

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

 tools/perf/util/probe-event.c |   27 +++++++++++++++++++++++++--
 1 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 88e1804..a20e382 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -379,11 +379,29 @@ static void clear_probe_point(struct probe_point *pp)
 	memset(pp, 0, sizeof(pp));
 }
 
+/* Show an event */
+static void show_perf_probe_event(const char *group, const char *event,
+				  const char *place, struct probe_point *pp)
+{
+	int i;
+	char buf[128];
+
+	e_snprintf(buf, 128, "%s:%s", group, event);
+	printf("  %-40s (on %s", buf, place);
+
+	if (pp->nr_args > 0) {
+		printf(" with");
+		for (i = 0; i < pp->nr_args; i++)
+			printf(" %s", pp->args[i]);
+	}
+	printf(")\n");
+}
+
 /* List up current perf-probe events */
 void show_perf_probe_events(void)
 {
 	unsigned int i;
-	int fd;
+	int fd, nr;
 	char *group, *event;
 	struct probe_point pp;
 	struct strlist *rawlist;
@@ -396,8 +414,13 @@ void show_perf_probe_events(void)
 	for (i = 0; i < strlist__nr_entries(rawlist); i++) {
 		ent = strlist__entry(rawlist, i);
 		parse_trace_kprobe_event(ent->s, &group, &event, &pp);
+		/* Synthesize only event probe point */
+		nr = pp.nr_args;
+		pp.nr_args = 0;
 		synthesize_perf_probe_event(&pp);
-		printf("[%s:%s]\t%s\n", group, event, pp.probes[0]);
+		pp.nr_args = nr;
+		/* Show an event */
+		show_perf_probe_event(group, event, pp.probes[0], &pp);
 		free(group);
 		free(event);
 		clear_probe_point(&pp);


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
