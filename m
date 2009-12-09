Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbZLIH2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbZLIH2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757248AbZLIH2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:28:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:45796 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbZLIH2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:28:09 -0500
Date: Wed, 9 Dec 2009 07:24:50 GMT
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
In-Reply-To: <20091208220240.10142.42916.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091208220240.10142.42916.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Change event list format
Message-ID: <tip-278498d438781426d8f315b65f7bca023a26fcc0@git.kernel.org>
Git-Commit-ID: 278498d438781426d8f315b65f7bca023a26fcc0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  278498d438781426d8f315b65f7bca023a26fcc0
Gitweb:     http://git.kernel.org/tip/278498d438781426d8f315b65f7bca023a26fcc0
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 8 Dec 2009 17:02:40 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 07:26:50 +0100

perf probe: Change event list format

Change event list format for user readability. perf probe --list
shows event list in "[GROUP:EVENT] EVENT-DEFINITION" format, but
this format is different from the output of perf-list, and
EVENT-DEFINITION is a bit blunt. This patch changes the format to
more user friendly one.

Before:
[probe:schedule_0]	schedule+10 prev cpu

After:
  probe:schedule_0                         (on schedule+10 with prev cpu)

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
LKML-Reference: <20091208220240.10142.42916.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
