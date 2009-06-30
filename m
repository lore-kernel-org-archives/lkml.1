Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbZF3Um3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbZF3Um3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 16:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757635AbZF3UmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 16:42:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40427 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757606AbZF3UmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 16:42:02 -0400
Date: Tue, 30 Jun 2009 17:41:59 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 2/3] perf_counter tools: Add --comms parameter to 'perf
	report'
Message-ID: <20090630204159.GC15682@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that we can filter by comm. Symbols in other comms won't be accounted
for.

Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-report.txt |    4 +++
 tools/perf/builtin-report.c              |   31 +++++++++++++++++++++--------
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 13d85ca..4c44ef1 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -24,6 +24,10 @@ OPTIONS
 --dsos=::
 	Only consider symbols in these dsos. CSV that understands
 	file://filename entries.
+-C::
+--comms=::
+	Only consider symbols in these comms. CSV that understands
+	file://filename entries.
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 7c6b6e7..60bdcd9 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -33,8 +33,8 @@ static char		*vmlinux = NULL;
 
 static char		default_sort_order[] = "comm,dso";
 static char		*sort_order = default_sort_order;
-static char		*dso_list_str;
-static struct strlist	*dso_list;
+static char		*dso_list_str, *comm_list_str;
+static struct strlist	*dso_list, *comm_list;
 
 static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
@@ -1253,6 +1253,9 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		return -1;
 	}
 
+	if (comm_list && !strlist__has_entry(comm_list, thread->comm))
+		return 0;
+
 	if (event->header.misc & PERF_EVENT_MISC_KERNEL) {
 		show = SHOW_KERNEL;
 		level = 'k';
@@ -1667,6 +1670,8 @@ static const struct option options[] = {
 	OPT_BOOLEAN('c', "callchain", &callchain, "Display callchains"),
 	OPT_STRING('d', "dsos", &dso_list_str, "dso[,dso...]",
 		   "only consider symbols in these dsos"),
+	OPT_STRING('C', "comms", &comm_list_str, "comm[,comm...]",
+		   "only consider symbols in these comms"),
 	OPT_END()
 };
 
@@ -1685,6 +1690,19 @@ static void setup_sorting(void)
 	free(str);
 }
 
+static void setup_list(struct strlist **list, const char *list_str,
+		       const char *list_name)
+{
+	if (list_str) {
+		*list = strlist__new(true, list_str);
+		if (!*list) {
+			fprintf(stderr, "problems parsing %s list\n",
+				list_name);
+			exit(129);
+		}
+	}
+}
+
 int cmd_report(int argc, const char **argv, const char *prefix)
 {
 	symbol__init();
@@ -1706,13 +1724,8 @@ int cmd_report(int argc, const char **argv, const char *prefix)
 	if (argc)
 		usage_with_options(report_usage, options);
 
-	if (dso_list_str) {
-		dso_list = strlist__new(true, dso_list_str);
-		if (!dso_list) {
-			fprintf(stderr, "problems parsing dso list\n");
-			exit(129);
-		}
-	}
+	setup_list(&dso_list, dso_list_str, "dso");
+	setup_list(&comm_list, comm_list_str, "comm");
 
 	setup_pager();
 
-- 
1.6.2.5

