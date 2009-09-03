Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbZICNtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbZICNtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbZICNtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:49:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:57482 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbZICNtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:49:16 -0400
Date: Thu, 3 Sep 2009 13:48:42 GMT
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
Subject: [tip:perfcounters/core] perf trace: Sample timestamps as well
Message-ID: <tip-6ddf259da76cab6555c2086386f8bcd10bbb86d2@git.kernel.org>
Git-Commit-ID: 6ddf259da76cab6555c2086386f8bcd10bbb86d2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 03 Sep 2009 13:48:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ddf259da76cab6555c2086386f8bcd10bbb86d2
Gitweb:     http://git.kernel.org/tip/6ddf259da76cab6555c2086386f8bcd10bbb86d2
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 3 Sep 2009 12:00:22 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Sep 2009 15:45:49 +0200

perf trace: Sample timestamps as well

Before:

            perf-21082 [013]     0.000000: sched_wakeup_new: task perf:21083 [120] success=1 [015]
            perf-21082 [013]     0.000000: sched_migrate_task: task perf:21082 [120] from: 13  to: 15
            perf-21082 [013]     0.000000: sched_process_fork: parent perf:21082  child perf:21083
            true-21083 [015]     0.000000: sched_wakeup: task migration/15:33 [0] success=1 [015]
            perf-21082 [013]     0.000000: sched_switch: task perf:21082 [120] (S) ==> swapper:0 [140]
            true-21083 [015]     0.000000: sched_switch: task perf:21083 [120] (R) ==> migration/15:33 [0]
            true-21083 [011]     0.000000: sched_process_exit: task true:21083 [120]

After:

            perf-21082 [013] 14674.797613: sched_wakeup_new: task perf:21083 [120] success=1 [015]
            perf-21082 [013] 14674.797506: sched_migrate_task: task perf:21082 [120] from: 13  to: 15
            perf-21082 [013] 14674.797610: sched_process_fork: parent perf:21082  child perf:21083
            true-21083 [015] 14674.797725: sched_wakeup: task migration/15:33 [0] success=1 [015]
            perf-21082 [013] 14674.797722: sched_switch: task perf:21082 [120] (S) ==> swapper:0 [140]
            true-21083 [015] 14674.797729: sched_switch: task perf:21083 [120] (R) ==> migration/15:33 [0]
            true-21083 [011] 14674.798159: sched_process_exit: task true:21083 [120]

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-record.c |    1 +
 tools/perf/builtin-trace.c  |    8 +++++++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ff93f8e..99a12fe 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -404,6 +404,7 @@ static void create_counter(int counter, int cpu, pid_t pid)
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
 	if (raw_samples) {
+		attr->sample_type	|= PERF_SAMPLE_TIME;
 		attr->sample_type	|= PERF_SAMPLE_RAW;
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 	}
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index bbe4c44..d59bf8a 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -58,6 +58,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	struct dso *dso = NULL;
 	struct thread *thread;
 	u64 ip = event->ip.ip;
+	u64 timestamp = -1;
 	u32 cpu = -1;
 	u64 period = 1;
 	void *more_data = event->ip.__more_data;
@@ -65,6 +66,11 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 
 	thread = threads__findnew(event->ip.pid, &threads, &last_match);
 
+	if (sample_type & PERF_SAMPLE_TIME) {
+		timestamp = *(u64 *)more_data;
+		more_data += sizeof(u64);
+	}
+
 	if (sample_type & PERF_SAMPLE_CPU) {
 		cpu = *(u32 *)more_data;
 		more_data += sizeof(u32);
@@ -127,7 +133,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		 * field, although it should be the same than this perf
 		 * event pid
 		 */
-		print_event(cpu, raw->data, raw->size, 0, thread->comm);
+		print_event(cpu, raw->data, raw->size, timestamp, thread->comm);
 	}
 	total += period;
 
