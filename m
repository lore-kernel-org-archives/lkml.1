Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbZFBWIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbZFBWIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZFBWHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:07:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:42489 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbZFBWHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:07:52 -0400
Date: Tue, 2 Jun 2009 22:07:12 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf record: Add --append option
Message-ID: <tip-abaff32a03e26e5d6674cb2a26ad882efe7493a3@git.kernel.org>
Git-Commit-ID: abaff32a03e26e5d6674cb2a26ad882efe7493a3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 22:07:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  abaff32a03e26e5d6674cb2a26ad882efe7493a3
Gitweb:     http://git.kernel.org/tip/abaff32a03e26e5d6674cb2a26ad882efe7493a3
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 2 Jun 2009 22:59:57 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 23:01:02 +0200

perf record: Add --append option

Allow incremental profiling via 'perf record -A' - this will append
to an existing perf.data.

Also reorder perf record options by utility / likelyhood of usage.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-record.c |   40 +++++++++++++++++---------
 1 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index c2fd042..19cba6b 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -1,5 +1,7 @@
-
-
+/*
+ * perf record: Record the profile of a workload (or a CPU, or a PID) into
+ * the perf.data output file - for later analysis via perf report.
+ */
 #include "perf.h"
 #include "builtin.h"
 #include "util/util.h"
@@ -28,6 +30,7 @@ static int			system_wide			= 0;
 static pid_t			target_pid			= -1;
 static int			inherit				= 1;
 static int			force				= 0;
+static int			append_file			= 0;
 
 const unsigned int default_count[] = {
 	1000000,
@@ -385,22 +388,29 @@ static void open_counters(int cpu, pid_t pid)
 static int __cmd_record(int argc, const char **argv)
 {
 	int i, counter;
+	struct stat st;
 	pid_t pid;
+	int flags;
 	int ret;
-	struct stat st;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	assert(nr_cpus <= MAX_NR_CPUS);
 	assert(nr_cpus >= 0);
 
-	if (!stat(output_name, &st) && !force) {
-		fprintf(stderr, "Error, output file: %s exists, use -f to overwrite.\n",
+	if (!stat(output_name, &st) && !force && !append_file) {
+		fprintf(stderr, "Error, output file %s exists, use -A to append or -f to overwrite.\n",
 				output_name);
 		exit(-1);
 	}
 
-	output = open(output_name, O_CREAT|O_TRUNC|O_RDWR, S_IRUSR|S_IWUSR);
+	flags = O_CREAT|O_RDWR;
+	if (append_file)
+		flags |= O_APPEND;
+	else
+		flags |= O_TRUNC;
+
+	output = open(output_name, flags, S_IRUSR|S_IWUSR);
 	if (output < 0) {
 		perror("failed to create output file");
 		exit(-1);
@@ -466,22 +476,24 @@ static char events_help_msg[EVENTS_HELP_MAX];
 static const struct option options[] = {
 	OPT_CALLBACK('e', "event", NULL, "event",
 		     events_help_msg, parse_events),
-	OPT_INTEGER('c', "count", &default_interval,
-		    "event period to sample"),
-	OPT_INTEGER('m', "mmap-pages", &mmap_pages,
-		    "number of mmap data pages"),
-	OPT_STRING('o', "output", &output_name, "file",
-		    "output file name"),
-	OPT_BOOLEAN('i', "inherit", &inherit,
-		    "child tasks inherit counters"),
 	OPT_INTEGER('p', "pid", &target_pid,
 		    "record events on existing pid"),
 	OPT_INTEGER('r', "realtime", &realtime_prio,
 		    "collect data with this RT SCHED_FIFO priority"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 			    "system-wide collection from all CPUs"),
+	OPT_BOOLEAN('A', "append", &append_file,
+			    "append to the output file to do incremental profiling"),
 	OPT_BOOLEAN('f', "force", &force,
 			"overwrite existing data file"),
+	OPT_INTEGER('c', "count", &default_interval,
+		    "event period to sample"),
+	OPT_STRING('o', "output", &output_name, "file",
+		    "output file name"),
+	OPT_BOOLEAN('i', "inherit", &inherit,
+		    "child tasks inherit counters"),
+	OPT_INTEGER('m', "mmap-pages", &mmap_pages,
+		    "number of mmap data pages"),
 	OPT_END()
 };
 
