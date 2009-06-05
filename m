Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbZFEMqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbZFEMqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 08:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbZFEMq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 08:46:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:51828 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765AbZFEMqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 08:46:24 -0400
Date: Fri, 5 Jun 2009 12:45:51 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf record, top: Implement --freq
Message-ID: <tip-cf1f45744c6fa3501e0a6f0ddc418f0ef27e725b@git.kernel.org>
Git-Commit-ID: cf1f45744c6fa3501e0a6f0ddc418f0ef27e725b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 05 Jun 2009 12:45:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf1f45744c6fa3501e0a6f0ddc418f0ef27e725b
Gitweb:     http://git.kernel.org/tip/cf1f45744c6fa3501e0a6f0ddc418f0ef27e725b
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 5 Jun 2009 13:27:02 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 5 Jun 2009 13:39:23 +0200

perf record, top: Implement --freq

Support frequency-based profiling and make it the default.

(Also add a Hz printout in perf top.)

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-record.c |   10 +++++++++-
 Documentation/perf_counter/builtin-top.c    |   13 +++++++++----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index 7f2d7ce..e2301f3 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -27,6 +27,7 @@ static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 static int			nr_cpus				= 0;
 static unsigned int		page_size;
 static unsigned int		mmap_pages			= 128;
+static int			freq				= 0;
 static int			output;
 static const char		*output_name			= "perf.data";
 static int			group				= 0;
@@ -347,9 +348,10 @@ static void create_counter(int counter, int cpu, pid_t pid)
 	attr.config		= event_id[counter];
 	attr.sample_period	= event_count[counter];
 	attr.sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
+	attr.freq		= freq;
 	attr.mmap		= track;
 	attr.comm		= track;
-	attr.inherit	= (cpu < 0) && inherit;
+	attr.inherit		= (cpu < 0) && inherit;
 
 	track = 0; /* only the first counter needs these */
 
@@ -520,6 +522,8 @@ static const struct option options[] = {
 		    "output file name"),
 	OPT_BOOLEAN('i', "inherit", &inherit,
 		    "child tasks inherit counters"),
+	OPT_INTEGER('F', "freq", &freq,
+		    "profile at this frequency"),
 	OPT_INTEGER('m', "mmap-pages", &mmap_pages,
 		    "number of mmap data pages"),
 	OPT_END()
@@ -540,6 +544,10 @@ int cmd_record(int argc, const char **argv, const char *prefix)
 		event_id[0] = 0;
 	}
 
+	if (freq) {
+		default_interval = freq;
+		freq = 1;
+	}
 	for (counter = 0; counter < nr_counters; counter++) {
 		if (event_count[counter])
 			continue;
diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index 28cbde4..2fee595 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -74,8 +74,8 @@ static int			nr_cpus				=  0;
 static unsigned int		realtime_prio			=  0;
 static int			group				=  0;
 static unsigned int		page_size;
-static unsigned int		mmap_pages			=  16;
-static int			freq				= 0;
+static unsigned int		mmap_pages			= 16;
+static int			freq				=  0;
 
 static char			*sym_filter;
 static unsigned long		filter_start;
@@ -212,8 +212,13 @@ static void print_sym_table(void)
 		events_per_sec,
 		100.0 - (100.0*((events_per_sec-kevents_per_sec)/events_per_sec)));
 
-	if (nr_counters == 1)
-		printf("%d ", event_count[0]);
+	if (nr_counters == 1) {
+		printf("%d", event_count[0]);
+		if (freq)
+			printf("Hz ");
+		else
+			printf(" ");
+	}
 
 	for (counter = 0; counter < nr_counters; counter++) {
 		if (counter)
