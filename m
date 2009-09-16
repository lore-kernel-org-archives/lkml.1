Return-Path: <linux-kernel-owner+w=401wt.eu-S1758807AbZIPK0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbZIPK0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758674AbZIPK0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:26:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:58500 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758759AbZIPK0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:26:02 -0400
Date: Wed, 16 Sep 2009 10:25:34 GMT
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
Subject: [tip:perfcounters/core] perf sched: Account for lost events, increase default buffering
Message-ID: <tip-dc02bf7178c8e2cb3d442ae19027b736d51c7dd5@git.kernel.org>
Git-Commit-ID: dc02bf7178c8e2cb3d442ae19027b736d51c7dd5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:25:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc02bf7178c8e2cb3d442ae19027b736d51c7dd5
Gitweb:     http://git.kernel.org/tip/dc02bf7178c8e2cb3d442ae19027b736d51c7dd5
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 16 Sep 2009 13:45:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Sep 2009 11:48:05 +0200

perf sched: Account for lost events, increase default buffering

Output such lost event and state machine weirdness stats:

   TOTAL:                |  14974.910 ms |    46384 |
  ---------------------------------------------------
   INFO: 8.865% lost events (19132 out of 215819, in 8 chunks)
   INFO: 0.198% state machine bugs (49 out of 24708) (due to lost events?)

And increase buffering to -m 1024 (4 MB) by default. Since we
use output multiplexing that kind of space is needed.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-sched.c |   60 ++++++++++++++++++++++++++++++--------------
 tools/perf/util/event.h    |    2 +-
 2 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index adcb563..1f0f9be 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -117,7 +117,11 @@ static u64			run_avg;
 
 static unsigned long		replay_repeat = 10;
 static unsigned long		nr_timestamps;
-static unsigned long		unordered_timestamps;
+static unsigned long		nr_unordered_timestamps;
+static unsigned long		nr_state_machine_bugs;
+static unsigned long		nr_events;
+static unsigned long		nr_lost_chunks;
+static unsigned long		nr_lost_events;
 
 #define TASK_STATE_TO_CHAR_STR "RSDTtZX"
 
@@ -668,14 +672,14 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 
 	thread = threads__findnew(event->comm.pid, &threads, &last_match);
 
-	dump_printf("%p [%p]: PERF_EVENT_COMM: %s:%d\n",
+	dump_printf("%p [%p]: perf_event_comm: %s:%d\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->comm.comm, event->comm.pid);
 
 	if (thread == NULL ||
 	    thread__set_comm(thread, event->comm.comm)) {
-		dump_printf("problem processing PERF_EVENT_COMM, skipping event.\n");
+		dump_printf("problem processing perf_event_comm, skipping event.\n");
 		return -1;
 	}
 	total_comm++;
@@ -1168,14 +1172,12 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 
 	atom = list_entry(atoms->work_list.prev, struct work_atom, list);
 
-	if (atom->state != THREAD_SLEEPING) {
-		printf("boo2\n");
-		return;
-	}
+	if (atom->state != THREAD_SLEEPING)
+		nr_state_machine_bugs++;
 
 	nr_timestamps++;
 	if (atom->sched_out_time > timestamp) {
-		unordered_timestamps++;
+		nr_unordered_timestamps++;
 		return;
 	}
 
@@ -1214,7 +1216,7 @@ static void output_lat_thread(struct work_atoms *work_list)
 
 	avg = work_list->total_lat / work_list->nb_atoms;
 
-	printf("|%9.3f ms |%9llu | avg:%9.3f ms | max:%9.3f ms |\n",
+	printf("|%11.3f ms |%9llu | avg:%9.3f ms | max:%9.3f ms |\n",
 	      (double)work_list->total_runtime / 1e6,
 		 work_list->nb_atoms, (double)avg / 1e6,
 		 (double)work_list->max_lat / 1e6);
@@ -1359,9 +1361,9 @@ static void __cmd_lat(void)
 	read_events();
 	sort_lat();
 
-	printf("\n ---------------------------------------------------------------------------------------\n");
-	printf("  Task                  |  Runtime ms | Switches | Average delay ms | Maximum delay ms |\n");
-	printf(" ---------------------------------------------------------------------------------------\n");
+	printf("\n -----------------------------------------------------------------------------------------\n");
+	printf("  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms |\n");
+	printf(" -----------------------------------------------------------------------------------------\n");
 
 	next = rb_first(&sorted_atom_root);
 
@@ -1373,18 +1375,32 @@ static void __cmd_lat(void)
 		next = rb_next(next);
 	}
 
-	printf(" ---------------------------------------------------------------------------------------\n");
-	printf("  TOTAL:                |%9.3f ms |%9Ld |",
+	printf(" -----------------------------------------------------------------------------------------\n");
+	printf("  TOTAL:                |%11.3f ms |%9Ld |\n",
 		(double)all_runtime/1e6, all_count);
 
-	if (unordered_timestamps && nr_timestamps) {
-		printf(" INFO: %.2f%% unordered events.\n",
-			(double)unordered_timestamps/(double)nr_timestamps*100.0);
+	printf(" ---------------------------------------------------\n");
+	if (nr_unordered_timestamps && nr_timestamps) {
+		printf("  INFO: %.3f%% unordered timestamps (%ld out of %ld)\n",
+			(double)nr_unordered_timestamps/(double)nr_timestamps*100.0,
+			nr_unordered_timestamps, nr_timestamps);
 	} else {
+	}
+	if (nr_lost_events && nr_events) {
+		printf("  INFO: %.3f%% lost events (%ld out of %ld, in %ld chunks)\n",
+			(double)nr_lost_events/(double)nr_events*100.0,
+			nr_lost_events, nr_events, nr_lost_chunks);
+	}
+	if (nr_state_machine_bugs && nr_timestamps) {
+		printf("  INFO: %.3f%% state machine bugs (%ld out of %ld)",
+			(double)nr_state_machine_bugs/(double)nr_timestamps*100.0,
+			nr_state_machine_bugs, nr_timestamps);
+		if (nr_lost_events)
+			printf(" (due to lost events?)");
 		printf("\n");
 	}
+	printf("\n");
 
-	printf(" -------------------------------------------------\n\n");
 }
 
 static struct trace_sched_handler *trace_handler;
@@ -1585,8 +1601,13 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	trace_event(event);
 
+	nr_events++;
 	switch (event->header.type) {
-	case PERF_EVENT_MMAP ... PERF_EVENT_LOST:
+	case PERF_EVENT_MMAP:
+		return 0;
+	case PERF_EVENT_LOST:
+		nr_lost_chunks++;
+		nr_lost_events += event->lost.lost;
 		return 0;
 
 	case PERF_EVENT_COMM:
@@ -1768,6 +1789,7 @@ static const char *record_args[] = {
 	"-R",
 	"-M",
 	"-f",
+	"-m", "1024",
 	"-c", "1",
 	"-e", "sched:sched_switch:r",
 	"-e", "sched:sched_stat_wait:r",
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index fa2d4e9..2495529 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -52,7 +52,7 @@ struct lost_event {
  */
 struct read_event {
 	struct perf_event_header header;
-	u32 pid,tid;
+	u32 pid, tid;
 	u64 value;
 	u64 time_enabled;
 	u64 time_running;
