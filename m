Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbZJXBEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbZJXBEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZJXBEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:04:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:51705 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbZJXBEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:04:40 -0400
Date: Sat, 24 Oct 2009 01:03:44 GMT
From: tip-bot for Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       arjan@linux.intel.com, efault@gmx.de, arjan@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, arjan@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091020070939.7d0fb8a7@infradead.org>
References: <20091020070939.7d0fb8a7@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] perf timechart: Add a process filter
Message-ID: <tip-bbe2987bea26a684ff11d887dfc4cf39b22c27a2@git.kernel.org>
Git-Commit-ID: bbe2987bea26a684ff11d887dfc4cf39b22c27a2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bbe2987bea26a684ff11d887dfc4cf39b22c27a2
Gitweb:     http://git.kernel.org/tip/bbe2987bea26a684ff11d887dfc4cf39b22c27a2
Author:     Arjan van de Ven <arjan@infradead.org>
AuthorDate: Tue, 20 Oct 2009 07:09:39 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 20 Oct 2009 07:55:50 +0200

perf timechart: Add a process filter

During the Kernel Summit demo of perf/ftrace/timechart, there
was a feature request to have a process filter for timechart so
that you can zoom into one or a few processes that you are
really interested in.

This patch adds basic support for this feature, the -p
(--process) option now can select a PID or a process name to be
shown. Multiple -p options are allowed, and the combined set
will be included in the output.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091020070939.7d0fb8a7@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Documentation/perf-timechart.txt |    5 +-
 tools/perf/builtin-timechart.c              |  105 ++++++++++++++++++++++++++-
 2 files changed, 106 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
index a791009..4b17883 100644
--- a/tools/perf/Documentation/perf-timechart.txt
+++ b/tools/perf/Documentation/perf-timechart.txt
@@ -31,9 +31,12 @@ OPTIONS
 -w::
 --width=::
         Select the width of the SVG file (default: 1000)
--p::
+-P::
 --power-only::
         Only output the CPU power section of the diagram
+-p::
+--process::
+        Select the processes to display, by name or PID
 
 
 SEE ALSO
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index e8a510d..34fad57 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -153,6 +153,17 @@ static struct wake_event     *wake_events;
 
 struct sample_wrapper *all_samples;
 
+
+struct process_filter;
+struct process_filter {
+	char 			*name;
+	int  			pid;
+	struct process_filter 	*next;
+};
+
+static struct process_filter *process_filter;
+
+
 static struct per_pid *find_create_pid(int pid)
 {
 	struct per_pid *cursor = all_data;
@@ -763,11 +774,11 @@ static void draw_wakeups(void)
 				c = p->all;
 				while (c) {
 					if (c->Y && c->start_time <= we->time && c->end_time >= we->time) {
-						if (p->pid == we->waker) {
+						if (p->pid == we->waker && !from) {
 							from = c->Y;
 							task_from = strdup(c->comm);
 						}
-						if (p->pid == we->wakee) {
+						if (p->pid == we->wakee && !to) {
 							to = c->Y;
 							task_to = strdup(c->comm);
 						}
@@ -882,12 +893,89 @@ static void draw_process_bars(void)
 	}
 }
 
+static void add_process_filter(const char *string)
+{
+	struct process_filter *filt;
+	int pid;
+
+	pid = strtoull(string, NULL, 10);
+	filt = malloc(sizeof(struct process_filter));
+	if (!filt)
+		return;
+
+	filt->name = strdup(string);
+	filt->pid  = pid;
+	filt->next = process_filter;
+
+	process_filter = filt;
+}
+
+static int passes_filter(struct per_pid *p, struct per_pidcomm *c)
+{
+	struct process_filter *filt;
+	if (!process_filter)
+		return 1;
+
+	filt = process_filter;
+	while (filt) {
+		if (filt->pid && p->pid == filt->pid)
+			return 1;
+		if (strcmp(filt->name, c->comm) == 0)
+			return 1;
+		filt = filt->next;
+	}
+	return 0;
+}
+
+static int determine_display_tasks_filtered(void)
+{
+	struct per_pid *p;
+	struct per_pidcomm *c;
+	int count = 0;
+
+	p = all_data;
+	while (p) {
+		p->display = 0;
+		if (p->start_time == 1)
+			p->start_time = first_time;
+
+		/* no exit marker, task kept running to the end */
+		if (p->end_time == 0)
+			p->end_time = last_time;
+
+		c = p->all;
+
+		while (c) {
+			c->display = 0;
+
+			if (c->start_time == 1)
+				c->start_time = first_time;
+
+			if (passes_filter(p, c)) {
+				c->display = 1;
+				p->display = 1;
+				count++;
+			}
+
+			if (c->end_time == 0)
+				c->end_time = last_time;
+
+			c = c->next;
+		}
+		p = p->next;
+	}
+	return count;
+}
+
 static int determine_display_tasks(u64 threshold)
 {
 	struct per_pid *p;
 	struct per_pidcomm *c;
 	int count = 0;
 
+	if (process_filter)
+		return determine_display_tasks_filtered();
+
 	p = all_data;
 	while (p) {
 		p->display = 0;
@@ -1153,6 +1241,14 @@ static int __cmd_record(int argc, const char **argv)
 	return cmd_record(i, rec_argv, NULL);
 }
 
+static int
+parse_process(const struct option *opt __used, const char *arg, int __used unset)
+{
+	if (arg)
+		add_process_filter(arg);
+	return 0;
+}
+
 static const struct option options[] = {
 	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
@@ -1160,8 +1256,11 @@ static const struct option options[] = {
 		    "output file name"),
 	OPT_INTEGER('w', "width", &svg_page_width,
 		    "page width"),
-	OPT_BOOLEAN('p', "power-only", &power_only,
+	OPT_BOOLEAN('P', "power-only", &power_only,
 		    "output power data only"),
+	OPT_CALLBACK('p', "process", NULL, "process",
+		      "process selector. Pass a pid or process name.",
+		       parse_process),
 	OPT_END()
 };
 
