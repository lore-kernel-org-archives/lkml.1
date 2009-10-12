Return-Path: <linux-kernel-owner+w=401wt.eu-S1754437AbZJLHOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbZJLHOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 03:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbZJLHOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 03:14:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:36898 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187AbZJLHOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 03:14:09 -0400
Date: Mon, 12 Oct 2009 07:13:02 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sched: Add -C option to measure on a specific CPU
Message-ID: <tip-55ffb7a6bd45d0083ffb132381cb46964a4afe01@git.kernel.org>
Git-Commit-ID: 55ffb7a6bd45d0083ffb132381cb46964a4afe01
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 12 Oct 2009 07:13:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55ffb7a6bd45d0083ffb132381cb46964a4afe01
Gitweb:     http://git.kernel.org/tip/55ffb7a6bd45d0083ffb132381cb46964a4afe01
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Sat, 10 Oct 2009 14:46:04 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Oct 2009 09:10:55 +0200

perf sched: Add -C option to measure on a specific CPU

To refresh, trying to sched record only one CPU results in bogus
latencies as below.

I fixed^Wmade it stop doing the bad thing today, by
following task migration events properly.

Before:

  marge:/root/tmp # taskset -c 1 perf sched record -C 0 -- sleep 10
  marge:/root/tmp # perf sched lat
   -----------------------------------------------------------------------------------------
    Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms |
   -----------------------------------------------------------------------------------------
    Xorg:4943             |      1.290 ms |        1 | avg: 1670.132 ms | max: 1670.132 ms |
    hald-addon-stor:3569  |      0.091 ms |        3 | avg:  658.609 ms | max: 1975.797 ms |
    hald-addon-stor:3573  |      0.209 ms |        4 | avg:  499.138 ms | max: 1990.565 ms |
    audispd:4270          |      0.012 ms |        1 | avg:    0.015 ms | max:    0.015 ms |
  ....

  marge:/root/tmp # perf sched trace|grep 'Xorg:4943'
           swapper-0     [000]   401.184013288: sched_stat_runtime: task: Xorg:4943 runtime: 1233188 [ns], vruntime: 19105169779 [ns]
   rt2870TimerQHan-4947  [000]   402.854140127: sched_stat_wait: task: Xorg:4943 wait: 580073 [ns]
   rt2870TimerQHan-4947  [000]   402.854141770: sched_migrate_task: task Xorg:4943 [140] from: 1  to: 0
   rt2870TimerQHan-4947  [000]   402.854143854: sched_stat_wait: task: Xorg:4943 wait: 0 [ns]
   rt2870TimerQHan-4947  [000]   402.854145397: sched_switch: task rt2870TimerQHan:4947 [140] (D) ==> Xorg:4943 [140]
              Xorg-4943  [000]   402.854193133: sched_stat_runtime: task: Xorg:4943 runtime: 56546 [ns], vruntime: 11766332500 [ns]
              Xorg-4943  [000]   402.854196842: sched_switch: task Xorg:4943 [140] (S) ==> swapper:0 [140]

After:

  marge:/root/tmp # taskset -c 1 perf sched record -C 0 -- sleep 10
  marge:/root/tmp # perf sched lat
   -----------------------------------------------------------------------------------------
    Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms |
   -----------------------------------------------------------------------------------------
    amarokapp:11150       |    271.297 ms |      878 | avg:    0.130 ms | max:    1.057 ms |
    konsole:5965          |      1.370 ms |       12 | avg:    0.092 ms | max:    0.855 ms |
    Xorg:4943             |    179.980 ms |     1109 | avg:    0.087 ms | max:    1.206 ms |
    hald-addon-stor:3574  |      0.212 ms |        9 | avg:    0.040 ms | max:    0.169 ms |
    hald-addon-stor:3570  |      0.223 ms |        9 | avg:    0.037 ms | max:    0.223 ms |
    klauncher:5864        |      0.550 ms |        8 | avg:    0.032 ms | max:    0.048 ms |

The 'Maximum delay ms' results are now sane.

Signed-off-by: Mike Galbraith <efault@gmx.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-sched.c |  101 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 100 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 6b00529..387a442 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -33,6 +33,8 @@ static u64			sample_type;
 static char			default_sort_order[] = "avg, max, switch, runtime";
 static char			*sort_order = default_sort_order;
 
+static int			profile_cpu = -1;
+
 static char			*cwd;
 static int			cwdlen;
 
@@ -75,6 +77,7 @@ enum sched_event_type {
 	SCHED_EVENT_RUN,
 	SCHED_EVENT_SLEEP,
 	SCHED_EVENT_WAKEUP,
+	SCHED_EVENT_MIGRATION,
 };
 
 struct sched_atom {
@@ -399,6 +402,8 @@ process_sched_event(struct task_desc *this_task __used, struct sched_atom *atom)
 				ret = sem_post(atom->wait_sem);
 			BUG_ON(ret);
 			break;
+		case SCHED_EVENT_MIGRATION:
+			break;
 		default:
 			BUG_ON(1);
 	}
@@ -746,6 +751,22 @@ struct trace_fork_event {
 	u32 child_pid;
 };
 
+struct trace_migrate_task_event {
+	u32 size;
+
+	u16 common_type;
+	u8 common_flags;
+	u8 common_preempt_count;
+	u32 common_pid;
+	u32 common_tgid;
+
+	char comm[16];
+	u32 pid;
+
+	u32 prio;
+	u32 cpu;
+};
+
 struct trace_sched_handler {
 	void (*switch_event)(struct trace_switch_event *,
 			     struct event *,
@@ -770,6 +791,12 @@ struct trace_sched_handler {
 			   int cpu,
 			   u64 timestamp,
 			   struct thread *thread);
+
+	void (*migrate_task_event)(struct trace_migrate_task_event *,
+			   struct event *,
+			   int cpu,
+			   u64 timestamp,
+			   struct thread *thread);
 };
 
 
@@ -1140,7 +1167,12 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 
 	atom = list_entry(atoms->work_list.prev, struct work_atom, list);
 
-	if (atom->state != THREAD_SLEEPING)
+	/*
+	 * You WILL be missing events if you've recorded only
+	 * one CPU, or are only looking at only one, so don't
+	 * make useless noise.
+	 */
+	if (profile_cpu == -1 && atom->state != THREAD_SLEEPING)
 		nr_state_machine_bugs++;
 
 	nr_timestamps++;
@@ -1153,11 +1185,51 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 	atom->wake_up_time = timestamp;
 }
 
+static void
+latency_migrate_task_event(struct trace_migrate_task_event *migrate_task_event,
+		     struct event *__event __used,
+		     int cpu __used,
+		     u64 timestamp,
+		     struct thread *thread __used)
+{
+	struct work_atoms *atoms;
+	struct work_atom *atom;
+	struct thread *migrant;
+
+	/*
+	 * Only need to worry about migration when profiling one CPU.
+	 */
+	if (profile_cpu == -1)
+		return;
+
+	migrant = threads__findnew(migrate_task_event->pid, &threads, &last_match);
+	atoms = thread_atoms_search(&atom_root, migrant, &cmp_pid);
+	if (!atoms) {
+		thread_atoms_insert(migrant);
+		register_pid(migrant->pid, migrant->comm);
+		atoms = thread_atoms_search(&atom_root, migrant, &cmp_pid);
+		if (!atoms)
+			die("migration-event: Internal tree error");
+		add_sched_out_event(atoms, 'R', timestamp);
+	}
+
+	BUG_ON(list_empty(&atoms->work_list));
+
+	atom = list_entry(atoms->work_list.prev, struct work_atom, list);
+	atom->sched_in_time = atom->sched_out_time = atom->wake_up_time = timestamp;
+
+	nr_timestamps++;
+
+	if (atom->sched_out_time > timestamp)
+		nr_unordered_timestamps++;
+}
+
 static struct trace_sched_handler lat_ops  = {
 	.wakeup_event		= latency_wakeup_event,
 	.switch_event		= latency_switch_event,
 	.runtime_event		= latency_runtime_event,
 	.fork_event		= latency_fork_event,
+	.migrate_task_event	= latency_migrate_task_event,
 };
 
 static void output_lat_thread(struct work_atoms *work_list)
@@ -1518,6 +1590,26 @@ process_sched_exit_event(struct event *event,
 }
 
 static void
+process_sched_migrate_task_event(struct raw_event_sample *raw,
+			   struct event *event,
+			   int cpu __used,
+			   u64 timestamp __used,
+			   struct thread *thread __used)
+{
+	struct trace_migrate_task_event migrate_task_event;
+
+	FILL_COMMON_FIELDS(migrate_task_event, event, raw->data);
+
+	FILL_ARRAY(migrate_task_event, comm, event, raw->data);
+	FILL_FIELD(migrate_task_event, pid, event, raw->data);
+	FILL_FIELD(migrate_task_event, prio, event, raw->data);
+	FILL_FIELD(migrate_task_event, cpu, event, raw->data);
+
+	if (trace_handler->migrate_task_event)
+		trace_handler->migrate_task_event(&migrate_task_event, event, cpu, timestamp, thread);
+}
+
+static void
 process_raw_event(event_t *raw_event __used, void *more_data,
 		  int cpu, u64 timestamp, struct thread *thread)
 {
@@ -1540,6 +1632,8 @@ process_raw_event(event_t *raw_event __used, void *more_data,
 		process_sched_fork_event(raw, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_process_exit"))
 		process_sched_exit_event(event, cpu, timestamp, thread);
+	if (!strcmp(event->name, "sched_migrate_task"))
+		process_sched_migrate_task_event(raw, event, cpu, timestamp, thread);
 }
 
 static int
@@ -1589,6 +1683,9 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		return -1;
 	}
 
+	if (profile_cpu != -1 && profile_cpu != (int) cpu)
+		return 0;
+
 	process_raw_event(event, more_data, cpu, timestamp, thread);
 
 	return 0;
@@ -1771,6 +1868,8 @@ static const struct option latency_options[] = {
 		   "sort by key(s): runtime, switch, avg, max"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
+	OPT_INTEGER('C', "CPU", &profile_cpu,
+		    "CPU to profile on"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
 	OPT_END()
