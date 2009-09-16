Return-Path: <linux-kernel-owner+w=401wt.eu-S1758822AbZIPK00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbZIPK00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758700AbZIPK0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:26:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:58516 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757678AbZIPK0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:26:22 -0400
Date: Wed, 16 Sep 2009 10:25:47 GMT
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
Subject: [tip:perfcounters/core] perf sched: Sanity check context switch events
Message-ID: <tip-c8a37751043427c6e4397a2cbfd617cb5f215c72@git.kernel.org>
Git-Commit-ID: c8a37751043427c6e4397a2cbfd617cb5f215c72
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:25:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c8a37751043427c6e4397a2cbfd617cb5f215c72
Gitweb:     http://git.kernel.org/tip/c8a37751043427c6e4397a2cbfd617cb5f215c72
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 16 Sep 2009 14:07:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Sep 2009 12:08:28 +0200

perf sched: Sanity check context switch events

Use 'perf sched latency' to track the current task based on
context-switch events, and flag the cases where there's some
impossible transition: such as a PID being switched out that
was not switched in.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-sched.c |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 1f0f9be..2d54236 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -119,6 +119,7 @@ static unsigned long		replay_repeat = 10;
 static unsigned long		nr_timestamps;
 static unsigned long		nr_unordered_timestamps;
 static unsigned long		nr_state_machine_bugs;
+static unsigned long		nr_context_switch_bugs;
 static unsigned long		nr_events;
 static unsigned long		nr_lost_chunks;
 static unsigned long		nr_lost_events;
@@ -1399,6 +1400,14 @@ static void __cmd_lat(void)
 			printf(" (due to lost events?)");
 		printf("\n");
 	}
+	if (nr_context_switch_bugs && nr_timestamps) {
+		printf("  INFO: %.3f%% context switch bugs (%ld out of %ld)",
+			(double)nr_context_switch_bugs/(double)nr_timestamps*100.0,
+			nr_context_switch_bugs, nr_timestamps);
+		if (nr_lost_events)
+			printf(" (due to lost events?)");
+		printf("\n");
+	}
 	printf("\n");
 
 }
@@ -1425,10 +1434,16 @@ process_sched_wakeup_event(struct raw_event_sample *raw,
 	trace_handler->wakeup_event(&wakeup_event, event, cpu, timestamp, thread);
 }
 
+/*
+ * Track the current task - that way we can know whether there's any
+ * weird events, such as a task being switched away that is not current.
+ */
+static u32 curr_pid[MAX_CPUS] = { [0 ... MAX_CPUS-1] = -1 };
+
 static void
 process_sched_switch_event(struct raw_event_sample *raw,
 			   struct event *event,
-			   int cpu __used,
+			   int cpu,
 			   u64 timestamp __used,
 			   struct thread *thread __used)
 {
@@ -1444,6 +1459,16 @@ process_sched_switch_event(struct raw_event_sample *raw,
 	FILL_FIELD(switch_event, next_pid, event, raw->data);
 	FILL_FIELD(switch_event, next_prio, event, raw->data);
 
+	if (curr_pid[cpu] != (u32)-1) {
+		/*
+		 * Are we trying to switch away a PID that is
+		 * not current?
+		 */
+		if (curr_pid[cpu] != switch_event.prev_pid)
+			nr_context_switch_bugs++;
+	}
+	curr_pid[cpu] = switch_event.next_pid;
+
 	trace_handler->switch_event(&switch_event, event, cpu, timestamp, thread);
 }
 
