Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbZFGPhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbZFGPhU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 11:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbZFGPhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 11:37:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:55938 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbZFGPhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 11:37:07 -0400
Date: Sun, 7 Jun 2009 15:36:33 GMT
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
Subject: [tip:perfcounters/core] perf top: Fall back to cpu-clock-tick hrtimer sampling if no cycle counter available
Message-ID: <tip-716c69fecacd42f2a304a97158e04af2786a3f65@git.kernel.org>
Git-Commit-ID: 716c69fecacd42f2a304a97158e04af2786a3f65
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 07 Jun 2009 15:36:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  716c69fecacd42f2a304a97158e04af2786a3f65
Gitweb:     http://git.kernel.org/tip/716c69fecacd42f2a304a97158e04af2786a3f65
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 7 Jun 2009 17:31:52 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 7 Jun 2009 17:31:52 +0200

perf top: Fall back to cpu-clock-tick hrtimer sampling if no cycle counter available

On architectures/CPUs without PMU support but with perfcounters
enabled 'perf top' currently fails because it cannot create a
cycle based hw-perfcounter.

Fall back to the cpu-clock-tick sw-perfcounter in this case, which
is hrtimer based and will always work (as long as perfcounters
is enabled).

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-top.c |  113 +++++++++++++++++++++++++++------------------
 tools/perf/util/usage.c  |   10 ++--
 2 files changed, 73 insertions(+), 50 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index fdc1d58..6da30a1 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -527,58 +527,81 @@ static void mmap_read(void)
 	}
 }
 
-static int __cmd_top(void)
+int nr_poll;
+int group_fd;
+
+static void start_counter(int i, int counter)
 {
 	struct perf_counter_attr *attr;
-	pthread_t thread;
-	int i, counter, group_fd, nr_poll = 0;
 	unsigned int cpu;
+
+	cpu = profile_cpu;
+	if (target_pid == -1 && profile_cpu == -1)
+		cpu = i;
+
+	attr = attrs + counter;
+
+	attr->sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
+	attr->freq		= freq;
+
+try_again:
+	fd[i][counter] = sys_perf_counter_open(attr, target_pid, cpu, group_fd, 0);
+
+	if (fd[i][counter] < 0) {
+		int err = errno;
+
+		error("sys_perf_counter_open() syscall returned with %d (%s)\n",
+			fd[i][counter], strerror(err));
+
+		if (err == EPERM)
+			die(" No permission - are you root?\n");
+		/*
+		 * If it's cycles then fall back to hrtimer
+		 * based cpu-clock-tick sw counter, which
+		 * is always available even if no PMU support:
+		 */
+		if (attr->type == PERF_TYPE_HARDWARE
+			&& attr->config == PERF_COUNT_CPU_CYCLES) {
+
+			warning(" ... trying to fall back to cpu-clock-ticks\n");
+			attr->type = PERF_TYPE_SOFTWARE;
+			attr->config = PERF_COUNT_CPU_CLOCK;
+			goto try_again;
+		}
+		exit(-1);
+	}
+	assert(fd[i][counter] >= 0);
+	fcntl(fd[i][counter], F_SETFL, O_NONBLOCK);
+
+	/*
+	 * First counter acts as the group leader:
+	 */
+	if (group && group_fd == -1)
+		group_fd = fd[i][counter];
+
+	event_array[nr_poll].fd = fd[i][counter];
+	event_array[nr_poll].events = POLLIN;
+	nr_poll++;
+
+	mmap_array[i][counter].counter = counter;
+	mmap_array[i][counter].prev = 0;
+	mmap_array[i][counter].mask = mmap_pages*page_size - 1;
+	mmap_array[i][counter].base = mmap(NULL, (mmap_pages+1)*page_size,
+			PROT_READ, MAP_SHARED, fd[i][counter], 0);
+	if (mmap_array[i][counter].base == MAP_FAILED)
+		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
+}
+
+static int __cmd_top(void)
+{
+	pthread_t thread;
+	int i, counter;
 	int ret;
 
 	for (i = 0; i < nr_cpus; i++) {
 		group_fd = -1;
-		for (counter = 0; counter < nr_counters; counter++) {
-
-			cpu	= profile_cpu;
-			if (target_pid == -1 && profile_cpu == -1)
-				cpu = i;
-
-			attr = attrs + counter;
-
-			attr->sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
-			attr->freq		= freq;
-
-			fd[i][counter] = sys_perf_counter_open(attr, target_pid, cpu, group_fd, 0);
-			if (fd[i][counter] < 0) {
-				int err = errno;
-
-				error("syscall returned with %d (%s)\n",
-					fd[i][counter], strerror(err));
-				if (err == EPERM)
-					printf("Are you root?\n");
-				exit(-1);
-			}
-			assert(fd[i][counter] >= 0);
-			fcntl(fd[i][counter], F_SETFL, O_NONBLOCK);
-
-			/*
-			 * First counter acts as the group leader:
-			 */
-			if (group && group_fd == -1)
-				group_fd = fd[i][counter];
-
-			event_array[nr_poll].fd = fd[i][counter];
-			event_array[nr_poll].events = POLLIN;
-			nr_poll++;
-
-			mmap_array[i][counter].counter = counter;
-			mmap_array[i][counter].prev = 0;
-			mmap_array[i][counter].mask = mmap_pages*page_size - 1;
-			mmap_array[i][counter].base = mmap(NULL, (mmap_pages+1)*page_size,
-					PROT_READ, MAP_SHARED, fd[i][counter], 0);
-			if (mmap_array[i][counter].base == MAP_FAILED)
-				die("failed to mmap with %d (%s)\n", errno, strerror(errno));
-		}
+		for (counter = 0; counter < nr_counters; counter++)
+			start_counter(i, counter);
 	}
 
 	/* Wait for a minimal set of events before starting the snapshot */
diff --git a/tools/perf/util/usage.c b/tools/perf/util/usage.c
index 2cad286..e16bf9a 100644
--- a/tools/perf/util/usage.c
+++ b/tools/perf/util/usage.c
@@ -9,29 +9,29 @@ static void report(const char *prefix, const char *err, va_list params)
 {
 	char msg[1024];
 	vsnprintf(msg, sizeof(msg), err, params);
-	fprintf(stderr, "%s%s\n", prefix, msg);
+	fprintf(stderr, " %s%s\n", prefix, msg);
 }
 
 static NORETURN void usage_builtin(const char *err)
 {
-	fprintf(stderr, "\n usage: %s\n", err);
+	fprintf(stderr, "\n Usage: %s\n", err);
 	exit(129);
 }
 
 static NORETURN void die_builtin(const char *err, va_list params)
 {
-	report("fatal: ", err, params);
+	report(" Fatal: ", err, params);
 	exit(128);
 }
 
 static void error_builtin(const char *err, va_list params)
 {
-	report("error: ", err, params);
+	report(" Error: ", err, params);
 }
 
 static void warn_builtin(const char *warn, va_list params)
 {
-	report("warning: ", warn, params);
+	report(" Warning: ", warn, params);
 }
 
 /* If we are in a dlopen()ed .so write to a global variable would segfault
