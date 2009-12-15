Return-Path: <linux-kernel-owner+w=401wt.eu-S1759244AbZLOPar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244AbZLOPar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 10:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758766AbZLOPaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 10:30:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454AbZLOP2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 10:28:01 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 08/14] perf probe: Use strlist__for_each macros in
	probe-event.c
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
Date: Tue, 15 Dec 2009 10:32:03 -0500
Message-ID: <20091215153203.17436.52039.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091215153106.17436.66584.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091215153106.17436.66584.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use strlist__for_each macros instead of using strlist__entry()
and index variable.

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

 tools/perf/util/probe-event.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 4055d01..fa7e8e5 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -404,7 +404,6 @@ static void show_perf_probe_event(const char *group, const char *event,
 /* List up current perf-probe events */
 void show_perf_probe_events(void)
 {
-	unsigned int i;
 	int fd, nr;
 	char *group, *event;
 	struct probe_point pp;
@@ -415,8 +414,7 @@ void show_perf_probe_events(void)
 	rawlist = get_trace_kprobe_event_rawlist(fd);
 	close(fd);
 
-	for (i = 0; i < strlist__nr_entries(rawlist); i++) {
-		ent = strlist__entry(rawlist, i);
+	strlist__for_each(ent, rawlist) {
 		parse_trace_kprobe_event(ent->s, &group, &event, &pp);
 		/* Synthesize only event probe point */
 		nr = pp.nr_args;
@@ -436,7 +434,6 @@ void show_perf_probe_events(void)
 /* Get current perf-probe event names */
 static struct strlist *get_perf_event_names(int fd, bool include_group)
 {
-	unsigned int i;
 	char *group, *event;
 	char buf[128];
 	struct strlist *sl, *rawlist;
@@ -445,8 +442,7 @@ static struct strlist *get_perf_event_names(int fd, bool include_group)
 	rawlist = get_trace_kprobe_event_rawlist(fd);
 
 	sl = strlist__new(true, NULL);
-	for (i = 0; i < strlist__nr_entries(rawlist); i++) {
-		ent = strlist__entry(rawlist, i);
+	strlist__for_each(ent, rawlist) {
 		parse_trace_kprobe_event(ent->s, &group, &event, NULL);
 		if (include_group) {
 			if (e_snprintf(buf, 128, "%s:%s", group, event) < 0)
@@ -562,7 +558,6 @@ static void del_trace_kprobe_event(int fd, const char *group,
 void del_trace_kprobe_events(struct strlist *dellist)
 {
 	int fd;
-	unsigned int i;
 	const char *group, *event;
 	char *p, *str;
 	struct str_node *ent;
@@ -572,8 +567,7 @@ void del_trace_kprobe_events(struct strlist *dellist)
 	/* Get current event names */
 	namelist = get_perf_event_names(fd, true);
 
-	for (i = 0; i < strlist__nr_entries(dellist); i++) {
-		ent = strlist__entry(dellist, i);
+	strlist__for_each(ent, dellist) {
 		str = strdup(ent->s);
 		if (!str)
 			die("Failed to copy event.");


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
