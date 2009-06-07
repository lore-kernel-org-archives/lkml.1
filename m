Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbZFGPnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbZFGPnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 11:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbZFGPnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 11:43:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:52009 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbZFGPnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 11:43:05 -0400
Date: Sun, 7 Jun 2009 15:42:32 GMT
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
Subject: [tip:perfcounters/core] perf record: Fall back to cpu-clock-ticks if no PMU
Message-ID: <tip-3da297a60f7e8840f79f7d0b343af078890939ea@git.kernel.org>
Git-Commit-ID: 3da297a60f7e8840f79f7d0b343af078890939ea
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 07 Jun 2009 15:42:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3da297a60f7e8840f79f7d0b343af078890939ea
Gitweb:     http://git.kernel.org/tip/3da297a60f7e8840f79f7d0b343af078890939ea
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 7 Jun 2009 17:39:02 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 7 Jun 2009 17:39:02 +0200

perf record: Fall back to cpu-clock-ticks if no PMU

On architectures/CPUs without PMU support but with perfcounters
enabled 'perf record' currently fails because it cannot create a
cycle based hw-perfcounter.

Fall back to the cpu-clock-tick sw-perfcounter in this case, which
is hrtimer based and will always work (as long as perfcounters
are enabled).

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-record.c |   25 +++++++++++++++++++++++--
 tools/perf/builtin-top.c    |   14 ++++++++++----
 2 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index aeab9c4..8786629 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -37,6 +37,7 @@ static pid_t			target_pid			= -1;
 static int			inherit				= 1;
 static int			force				= 0;
 static int			append_file			= 0;
+static int			verbose				= 0;
 
 static long			samples;
 static struct timeval		last_read;
@@ -349,17 +350,35 @@ static void create_counter(int counter, int cpu, pid_t pid)
 
 	track = 0; /* only the first counter needs these */
 
+try_again:
 	fd[nr_cpu][counter] = sys_perf_counter_open(attr, pid, cpu, group_fd, 0);
 
 	if (fd[nr_cpu][counter] < 0) {
 		int err = errno;
 
-		error("syscall returned with %d (%s)\n",
+		if (verbose)
+			error("sys_perf_counter_open() syscall returned with %d (%s)\n",
 				fd[nr_cpu][counter], strerror(err));
 		if (err == EPERM)
-			printf("Are you root?\n");
+			die("Permission error - are you root?\n");
+
+		/*
+		 * If it's cycles then fall back to hrtimer
+		 * based cpu-clock-tick sw counter, which
+		 * is always available even if no PMU support:
+		 */
+		if (attr->type == PERF_TYPE_HARDWARE
+			&& attr->config == PERF_COUNT_CPU_CYCLES) {
+
+			if (verbose)
+				warning(" ... trying to fall back to cpu-clock-ticks\n");
+			attr->type = PERF_TYPE_SOFTWARE;
+			attr->config = PERF_COUNT_CPU_CLOCK;
+			goto try_again;
+		}
 		exit(-1);
 	}
+
 	assert(fd[nr_cpu][counter] >= 0);
 	fcntl(fd[nr_cpu][counter], F_SETFL, O_NONBLOCK);
 
@@ -519,6 +538,8 @@ static const struct option options[] = {
 		    "profile at this frequency"),
 	OPT_INTEGER('m', "mmap-pages", &mmap_pages,
 		    "number of mmap data pages"),
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show counter open errors, etc)"),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 6da30a1..1f8c97d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -65,6 +65,7 @@ static int			group				=  0;
 static unsigned int		page_size;
 static unsigned int		mmap_pages			= 16;
 static int			freq				=  0;
+static int			verbose				=  0;
 
 static char			*sym_filter;
 static unsigned long		filter_start;
@@ -550,11 +551,12 @@ try_again:
 	if (fd[i][counter] < 0) {
 		int err = errno;
 
-		error("sys_perf_counter_open() syscall returned with %d (%s)\n",
-			fd[i][counter], strerror(err));
+		if (verbose)
+			error("sys_perf_counter_open() syscall returned with %d (%s)\n",
+				fd[i][counter], strerror(err));
 
 		if (err == EPERM)
-			die(" No permission - are you root?\n");
+			die("No permission - are you root?\n");
 		/*
 		 * If it's cycles then fall back to hrtimer
 		 * based cpu-clock-tick sw counter, which
@@ -563,7 +565,9 @@ try_again:
 		if (attr->type == PERF_TYPE_HARDWARE
 			&& attr->config == PERF_COUNT_CPU_CYCLES) {
 
-			warning(" ... trying to fall back to cpu-clock-ticks\n");
+			if (verbose)
+				warning(" ... trying to fall back to cpu-clock-ticks\n");
+
 			attr->type = PERF_TYPE_SOFTWARE;
 			attr->config = PERF_COUNT_CPU_CLOCK;
 			goto try_again;
@@ -673,6 +677,8 @@ static const struct option options[] = {
 		    "profile at this frequency"),
 	OPT_INTEGER('E', "entries", &print_entries,
 		    "display this many functions"),
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show counter open errors, etc)"),
 	OPT_END()
 };
 
