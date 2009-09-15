Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbZIOJg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbZIOJg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbZIOJgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:36:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:57473 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbZIOJgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:36:52 -0400
Date: Tue, 15 Sep 2009 09:36:18 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf tools: Implement counter output multiplexing
Message-ID: <tip-ea57c4f5203d82c7844c54cdef54e972cf4e9d1f@git.kernel.org>
Git-Commit-ID: ea57c4f5203d82c7844c54cdef54e972cf4e9d1f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 09:36:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea57c4f5203d82c7844c54cdef54e972cf4e9d1f
Gitweb:     http://git.kernel.org/tip/ea57c4f5203d82c7844c54cdef54e972cf4e9d1f
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 13 Sep 2009 18:15:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Sep 2009 15:45:11 +0200

perf tools: Implement counter output multiplexing

Finish the -M/--multiplex option implementation:

 - separate it out from group_fd

 - correctly set it via the ioctl and dont mmap counters that
   are multiplexed

 - modify the perf record event loop to deal with buffer-less
   counters.

 - remove the -g option from perf sched record

 - account for unordered events in perf sched latency

 - (add -f to perf sched record to ease measurements)

 - skip idle threads (pid==0) in latency output

The result is better latency output by 'perf sched latency':

 -----------------------------------------------------------------------------------
  Task              |  Runtime ms | Switches | Average delay ms | Maximum delay ms |
 -----------------------------------------------------------------------------------
  ksoftirqd/8       |    0.071 ms |        2 | avg:    0.458 ms | max:    0.913 ms |
  at-spi-registry   |    0.609 ms |       19 | avg:    0.013 ms | max:    0.023 ms |
  perf              |    3.316 ms |       16 | avg:    0.013 ms | max:    0.054 ms |
  Xorg              |    0.392 ms |       19 | avg:    0.011 ms | max:    0.018 ms |
  sleep             |    0.537 ms |        2 | avg:    0.009 ms | max:    0.009 ms |
 -----------------------------------------------------------------------------------
  TOTAL:            |    4.925 ms |       58 |
 ---------------------------------------------

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-record.c         |   43 +++++++++++++++++++++-------------
 tools/perf/builtin-sched.c          |   25 ++++++++++++++++++--
 tools/perf/util/trace-event-parse.c |    6 +++-
 3 files changed, 52 insertions(+), 22 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 79f99db..5f3127e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -49,6 +49,7 @@ static int			inherit_stat			= 0;
 static int			no_samples			= 0;
 static int			sample_address			= 0;
 static int			multiplex			= 0;
+static int			multiplex_fd			= -1;
 
 static long			samples;
 static struct timeval		last_read;
@@ -471,23 +472,29 @@ try_again:
 	 */
 	if (group && group_fd == -1)
 		group_fd = fd[nr_cpu][counter];
+	if (multiplex && multiplex_fd == -1)
+		multiplex_fd = fd[nr_cpu][counter];
 
-	event_array[nr_poll].fd = fd[nr_cpu][counter];
-	event_array[nr_poll].events = POLLIN;
-	nr_poll++;
-
-	mmap_array[nr_cpu][counter].counter = counter;
-	mmap_array[nr_cpu][counter].prev = 0;
-	mmap_array[nr_cpu][counter].mask = mmap_pages*page_size - 1;
-	mmap_array[nr_cpu][counter].base = mmap(NULL, (mmap_pages+1)*page_size,
-			PROT_READ|PROT_WRITE, MAP_SHARED, fd[nr_cpu][counter], 0);
-	if (mmap_array[nr_cpu][counter].base == MAP_FAILED) {
-		error("failed to mmap with %d (%s)\n", errno, strerror(errno));
-		exit(-1);
-	}
+	if (multiplex && fd[nr_cpu][counter] != multiplex_fd) {
+		int ret;
 
-	if (multiplex && fd[nr_cpu][counter] != group_fd)
-		ioctl(fd[nr_cpu][counter], PERF_COUNTER_IOC_SET_OUTPUT, group_fd);
+		ret = ioctl(fd[nr_cpu][counter], PERF_COUNTER_IOC_SET_OUTPUT, multiplex_fd);
+		assert(ret != -1);
+	} else {
+		event_array[nr_poll].fd = fd[nr_cpu][counter];
+		event_array[nr_poll].events = POLLIN;
+		nr_poll++;
+
+		mmap_array[nr_cpu][counter].counter = counter;
+		mmap_array[nr_cpu][counter].prev = 0;
+		mmap_array[nr_cpu][counter].mask = mmap_pages*page_size - 1;
+		mmap_array[nr_cpu][counter].base = mmap(NULL, (mmap_pages+1)*page_size,
+				PROT_READ|PROT_WRITE, MAP_SHARED, fd[nr_cpu][counter], 0);
+		if (mmap_array[nr_cpu][counter].base == MAP_FAILED) {
+			error("failed to mmap with %d (%s)\n", errno, strerror(errno));
+			exit(-1);
+		}
+	}
 
 	ioctl(fd[nr_cpu][counter], PERF_COUNTER_IOC_ENABLE);
 }
@@ -618,8 +625,10 @@ static int __cmd_record(int argc, const char **argv)
 		int hits = samples;
 
 		for (i = 0; i < nr_cpu; i++) {
-			for (counter = 0; counter < nr_counters; counter++)
-				mmap_read(&mmap_array[i][counter]);
+			for (counter = 0; counter < nr_counters; counter++) {
+				if (mmap_array[i][counter].base)
+					mmap_read(&mmap_array[i][counter]);
+			}
 		}
 
 		if (hits == samples) {
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 3e00323..2ce87ef 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -116,6 +116,8 @@ static u64			sum_fluct;
 static u64			run_avg;
 
 static unsigned long		replay_repeat = 10;
+static unsigned long		nr_timestamps;
+static unsigned long		unordered_timestamps;
 
 #define TASK_STATE_TO_CHAR_STR "RSDTtZX"
 
@@ -1109,8 +1111,11 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 	if (atom->state != THREAD_SLEEPING)
 		return;
 
-	if (atom->sched_out_time > timestamp)
+	nr_timestamps++;
+	if (atom->sched_out_time > timestamp) {
+		unordered_timestamps++;
 		return;
+	}
 
 	atom->state = THREAD_WAIT_CPU;
 	atom->wake_up_time = timestamp;
@@ -1130,6 +1135,11 @@ static void output_lat_thread(struct task_atoms *atom_list)
 
 	if (!atom_list->nb_atoms)
 		return;
+	/*
+	 * Ignore idle threads:
+	 */
+	if (!atom_list->thread->pid)
+		return;
 
 	all_runtime += atom_list->total_runtime;
 	all_count += atom_list->nb_atoms;
@@ -1301,8 +1311,16 @@ static void __cmd_lat(void)
 	}
 
 	printf("-----------------------------------------------------------------------------------\n");
-	printf(" TOTAL:            |%9.3f ms |%9Ld |\n",
+	printf(" TOTAL:            |%9.3f ms |%9Ld |",
 		(double)all_runtime/1e6, all_count);
+
+	if (unordered_timestamps && nr_timestamps) {
+		printf(" INFO: %.2f%% unordered events.\n",
+			(double)unordered_timestamps/(double)nr_timestamps*100.0);
+	} else {
+		printf("\n");
+	}
+
 	printf("---------------------------------------------\n");
 }
 
@@ -1667,12 +1685,13 @@ static const char *record_args[] = {
 	"-a",
 	"-R",
 	"-M",
-	"-g",
+	"-f",
 	"-c", "1",
 	"-e", "sched:sched_switch:r",
 	"-e", "sched:sched_stat_wait:r",
 	"-e", "sched:sched_stat_sleep:r",
 	"-e", "sched:sched_stat_iowait:r",
+	"-e", "sched:sched_stat_runtime:r",
 	"-e", "sched:sched_process_exit:r",
 	"-e", "sched:sched_process_fork:r",
 	"-e", "sched:sched_wakeup:r",
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 64d6e30..f6a8437 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -2722,8 +2722,10 @@ void print_event(int cpu, void *data, int size, unsigned long long nsecs,
 	type = trace_parse_common_type(data);
 
 	event = trace_find_event(type);
-	if (!event)
-		die("ug! no event found for type %d", type);
+	if (!event) {
+		printf("ug! no event found for type %d\n", type);
+		return;
+	}
 
 	pid = parse_common_pid(data);
 
