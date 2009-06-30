Return-Path: <linux-kernel-owner+w=401wt.eu-S1759058AbZF3Wzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058AbZF3Wzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbZF3Wzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:55:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:39328 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701AbZF3Wzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:55:31 -0400
Date: Tue, 30 Jun 2009 22:54:58 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, efault@gmx.de, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1246399282-20934-3-git-send-email-acme@redhat.com>
References: <1246399282-20934-3-git-send-email-acme@redhat.com>
Subject: [tip:perfcounters/urgent] perf report: Add --comms parameter
Message-ID: <tip-cc8b88b15ab8e5ae162a46c4b6b286b555190dd1@git.kernel.org>
Git-Commit-ID: cc8b88b15ab8e5ae162a46c4b6b286b555190dd1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 30 Jun 2009 22:54:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc8b88b15ab8e5ae162a46c4b6b286b555190dd1
Gitweb:     http://git.kernel.org/tip/cc8b88b15ab8e5ae162a46c4b6b286b555190dd1
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 30 Jun 2009 19:01:21 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 00:07:10 +0200

perf report: Add --comms parameter

So that we can filter by comm. Symbols in other comms won't be
accounted for.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1246399282-20934-3-git-send-email-acme@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Documentation/perf-report.txt |    4 +++
 tools/perf/builtin-report.c              |   33 ++++++++++++++++++++---------
 2 files changed, 27 insertions(+), 10 deletions(-)

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
index 7c6b6e7..8143477 100644
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
@@ -240,7 +240,7 @@ static u64 vdso__map_ip(struct map *map, u64 ip)
 
 static inline int is_anon_memory(const char *filename)
 {
-     return strcmp(filename, "//anon") == 0;
+	return strcmp(filename, "//anon") == 0;
 }
 
 static struct map *map__new(struct mmap_event *event)
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
 
