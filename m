Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbZGKR0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbZGKR0p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 13:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbZGKR0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 13:26:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:39256 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570AbZGKR0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 13:26:18 -0400
Date: Sat, 11 Jul 2009 17:25:43 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1247325517-12272-5-git-send-email-acme@redhat.com>
References: <1247325517-12272-5-git-send-email-acme@redhat.com>
Subject: [tip:perfcounters/core] perf report: Introduce -n/--show-nr-samples
Message-ID: <tip-e3d7e183dc276df2fcaf02af173a49ad119ba9f9@git.kernel.org>
Git-Commit-ID: e3d7e183dc276df2fcaf02af173a49ad119ba9f9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 11 Jul 2009 17:25:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e3d7e183dc276df2fcaf02af173a49ad119ba9f9
Gitweb:     http://git.kernel.org/tip/e3d7e183dc276df2fcaf02af173a49ad119ba9f9
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 11 Jul 2009 12:18:37 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 11 Jul 2009 19:20:27 +0200

perf report: Introduce -n/--show-nr-samples

[acme@doppio pahole]$ perf report -ns comm,dso,symbol -d /lib64/libc-2.10.1.so -C pahole | head -17
    21.94%      32101  [.] _int_malloc
    20.10%      29402  [.] __GI_strcmp
    16.77%      24533  [.] __tsearch
    12.61%      18450  [.] malloc_consolidate
     6.42%       9394  [.] _int_free
     6.28%       9191  [.] __tfind
     4.56%       6678  [.] __GI___libc_free
     4.46%       6520  [.] _IO_vfprintf_internal
     2.59%       3786  [.] __malloc
     1.17%       1716  [.] __GI_memcpy
[acme@doppio pahole]$

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1247325517-12272-5-git-send-email-acme@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Documentation/perf-report.txt |    3 +++
 tools/perf/builtin-report.c              |   18 ++++++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 05774df..e72e931 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -24,6 +24,9 @@ OPTIONS
 --dsos=::
 	Only consider symbols in these dsos. CSV that understands
 	file://filename entries.
+-n
+--show-nr-samples
+	Show the number of samples for each symbol
 -C::
 --comms=::
 	Only consider symbols in these comms. CSV that understands
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f342212..430a195 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -51,6 +51,7 @@ static int		verbose;
 static int		modules;
 
 static int		full_paths;
+static int		show_nr_samples;
 
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
@@ -1024,6 +1025,13 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, u64 total_samples)
 	else
 		ret = fprintf(fp, field_sep ? "%lld" : "%12lld ", self->count);
 
+	if (show_nr_samples) {
+		if (field_sep)
+			fprintf(fp, "%c%lld", *field_sep, self->count);
+		else
+			fprintf(fp, "%11lld", self->count);
+	}
+
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		if (se->elide)
 			continue;
@@ -1361,6 +1369,12 @@ static size_t output__fprintf(FILE *fp, u64 total_samples)
 	fprintf(fp, "#\n");
 
 	fprintf(fp, "# Overhead");
+	if (show_nr_samples) {
+		if (field_sep)
+			fprintf(fp, "%cSamples", *field_sep);
+		else
+			fputs("  Samples  ", fp);
+	}
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		if (se->elide)
 			continue;
@@ -1388,6 +1402,8 @@ static size_t output__fprintf(FILE *fp, u64 total_samples)
 		goto print_entries;
 
 	fprintf(fp, "# ........");
+	if (show_nr_samples)
+		fprintf(fp, " ..........");
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		unsigned int i;
 
@@ -1979,6 +1995,8 @@ static const struct option options[] = {
 	OPT_STRING('k', "vmlinux", &vmlinux, "file", "vmlinux pathname"),
 	OPT_BOOLEAN('m', "modules", &modules,
 		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
+	OPT_BOOLEAN('n', "show-nr-samples", &show_nr_samples,
+		    "Show a column with the number of samples"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent"),
 	OPT_BOOLEAN('P', "full-paths", &full_paths,
