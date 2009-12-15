Return-Path: <linux-kernel-owner+w=401wt.eu-S1759513AbZLOJfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513AbZLOJfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 04:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbZLOJfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 04:35:42 -0500
Received: from ozlabs.org ([203.10.76.45]:56157 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbZLOJfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 04:35:39 -0500
Date: Tue, 15 Dec 2009 20:34:37 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Michael Neuling <mikey@neuling.org>
Subject: [PATCH 2/2] perf tools: Cope with sparsely-numbered CPUs
Message-ID: <20091215093437.GB18661@brick.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For system-wide monitoring, the perf tools currently ask how many CPUs
are online, and then instantiate perf_events for CPUs 0 ... N-1.  This
doesn't work correctly when CPUs are numbered sparsely.  For example,
a four-core POWER6 in single-thread mode will have CPUs 0, 2, 4 and 6.
The perf tools will try to open counters on CPUs 0, 1, 2 and 3, and
either fail with an error message or silently ignore CPUs 4 and 6.

This fixes the problem by making perf stat, perf record and perf top
create counters for increasing CPU numbers until they have a counter
for each online CPU.  If the attempt to create a counter on a given
CPU fails, we get an ENODEV error and we just move on to the next CPU.
To avoid an infinite loop in case the number of online CPUs gets
reduced while we are creating counters, we re-read the number of
online CPUs when we fail to create a counter on some CPU.

Reported-by: Michael Neuling <mikey@neuling.org>
Tested-by: Michael Neuling <mikey@neuling.org>
Cc: stable@kernel.org
Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 tools/perf/builtin-record.c |   36 ++++++++++++++++++++++++++++--------
 tools/perf/builtin-stat.c   |   15 +++++++++++++--
 tools/perf/builtin-top.c    |   27 +++++++++++++++++++--------
 3 files changed, 60 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0e519c6..9a47b86 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -230,7 +230,7 @@ static struct perf_header_attr *get_header_attr(struct perf_event_attr *a, int n
 	return h_attr;
 }
 
-static void create_counter(int counter, int cpu, pid_t pid)
+static int create_counter(int counter, int cpu, pid_t pid)
 {
 	char *filter = filters[counter];
 	struct perf_event_attr *attr = attrs + counter;
@@ -287,8 +287,11 @@ try_again:
 
 		if (err == EPERM || err == EACCES)
 			die("Permission error - are you root?\n");
-		else if (err ==  ENODEV && profile_cpu != -1)
-			die("No such device - did you specify an out-of-range profile CPU?\n");
+		else if (err == ENODEV && system_wide) {
+			if (profile_cpu != -1)
+				die("No such device - did you specify an out-of-range profile CPU?\n");
+			return -1;
+		}
 
 		/*
 		 * If it's cycles then fall back to hrtimer
@@ -380,17 +383,28 @@ try_again:
 	}
 
 	ioctl(fd[nr_cpu][counter], PERF_EVENT_IOC_ENABLE);
+	return 0;
 }
 
-static void open_counters(int cpu, pid_t pid)
+static int open_counters(int cpu, pid_t pid)
 {
 	int counter;
 
 	group_fd = -1;
-	for (counter = 0; counter < nr_counters; counter++)
-		create_counter(counter, cpu, pid);
+	for (counter = 0; counter < nr_counters; counter++) {
+		if (create_counter(counter, cpu, pid)) {
+			/*
+			 * If cpu #cpu doesn't exist but we have already
+			 * created some events for it, close them.
+			 */
+			while (--counter >= 0)
+				close(fd[nr_cpu][counter]);
+			return -1;
+		}
+	}
 
 	nr_cpu++;
+	return 0;
 }
 
 static void atexit_header(void)
@@ -475,8 +489,14 @@ static int __cmd_record(int argc, const char **argv)
 		if (profile_cpu != -1) {
 			open_counters(profile_cpu, target_pid);
 		} else {
-			for (i = 0; i < nr_cpus; i++)
-				open_counters(i, target_pid);
+			for (i = 0; nr_cpu < nr_cpus; i++) {
+				/*
+				 * If cpu i doesn't exist, re-check
+				 * # online cpus in case it has changed.
+				 */
+				if (open_counters(i, target_pid))
+					nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+			}
 		}
 	}
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c70d720..5a1a7c0 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -145,13 +145,24 @@ static void create_perf_stat_counter(int counter, int pid)
 				    PERF_FORMAT_TOTAL_TIME_RUNNING;
 
 	if (system_wide) {
-		unsigned int cpu;
+		unsigned int cpu, cpu_id;
 
-		for (cpu = 0; cpu < nr_cpus; cpu++) {
+		cpu_id = 0;
+		for (cpu = 0; cpu < nr_cpus; cpu_id++) {
 			fd[cpu][counter] = sys_perf_event_open(attr, -1, cpu, -1, 0);
+			if (fd[cpu][counter] < 0 && errno == ENODEV) {
+				/*
+				 * This CPU number doesn't exist, re-read
+				 * nr_cpus (in case it's changed)
+				 * and try the next number.
+				 */
+				nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+				continue;
+			}
 			if (fd[cpu][counter] < 0 && verbose)
 				fprintf(stderr, ERR_PERF_OPEN, counter,
 					fd[cpu][counter], strerror(errno));
+			++cpu;
 		}
 	} else {
 		attr->inherit	     = inherit;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e0a374d..30fa53d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1077,14 +1077,9 @@ static void mmap_read(void)
 int nr_poll;
 int group_fd;
 
-static void start_counter(int i, int counter)
+static int start_counter(int i, int cpu, int counter)
 {
 	struct perf_event_attr *attr;
-	int cpu;
-
-	cpu = profile_cpu;
-	if (target_pid == -1 && profile_cpu == -1)
-		cpu = i;
 
 	attr = attrs + counter;
 
@@ -1107,6 +1102,8 @@ try_again:
 
 		if (err == EPERM || err == EACCES)
 			die("No permission - are you root?\n");
+		if (err == ENODEV && cpu != profile_cpu)
+			return -1;
 		/*
 		 * If it's cycles then fall back to hrtimer
 		 * based cpu-clock-tick sw counter, which
@@ -1148,12 +1145,14 @@ try_again:
 			PROT_READ, MAP_SHARED, fd[i][counter], 0);
 	if (mmap_array[i][counter].base == MAP_FAILED)
 		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
+	return 0;
 }
 
 static int __cmd_top(void)
 {
 	pthread_t thread;
 	int i, counter;
+	int cpu;
 	int ret;
 
 	if (target_pid != -1)
@@ -1161,10 +1160,22 @@ static int __cmd_top(void)
 	else
 		event__synthesize_threads(event__process);
 
-	for (i = 0; i < nr_cpus; i++) {
+	if (target_pid == -1 && profile_cpu == -1) {
+		cpu = 0;
+		for (i = 0; i < nr_cpus; ++i, ++cpu) {
+			group_fd = -1;
+			for (counter = 0; counter < nr_counters; counter++)
+				if (start_counter(i, i, counter)) {
+					--i;
+					nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+					break;
+				}
+		}
+
+	} else {
 		group_fd = -1;
 		for (counter = 0; counter < nr_counters; counter++)
-			start_counter(i, counter);
+			start_counter(0, profile_cpu, counter);
 	}
 
 	/* Wait for a minimal set of events before starting the snapshot */
