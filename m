Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbZIQUp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbZIQUp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbZIQUp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:45:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57373 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbZIQUpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:45:25 -0400
Date: Thu, 17 Sep 2009 22:45:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [Announce] 'perf sched': Utility to capture, measure and analyze
	scheduler latencies and behavior
Message-ID: <20090917204513.GA15496@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The recent discussions on lkml about scheduler interactivity have again 
demonstrated a particular weakness in Linux instrumentation: the lack of 
a turn-key solution that gives us both high level summaries and fine low 
level details about CPU scheduler behavior.

This makes it needlessly hard to talk about interactivity with an 
objective basis, desktop users often have to resort to post subjective 
impressions how smooth the desktop 'feels' - instead of being able to 
report hard numbers. We've got LatencyTop with a great GUI and latency 
maximums but that does not give us finegrained traces that scheduler 
developers could act upon. We've got ftrace for finegrained traces but 
that does not give us high-level information and use and analysis is 
difficult.

We are pleased to announce the first experimental version of a utility 
that tries to meet this ambitious goal: the new 'perf sched' family of 
tools that uses performance events to objective characterise arbitrary 
workloads from a scheduling and latency point of view.

In the past few days we've also used this new tool to re-tune the 
scheduler for interactivity and scalability. While it's still early code 
i can already observe that this tool surpassed our expectations and we 
can now analyze most scheduler properties from within 'perf sched' 
alone.

'perf sched' has five sub-commands currently:

  perf sched record            # low-overhead recording of arbitrary workloads
  perf sched latency           # output per task latency metrics
  perf sched map               # show summary/map of context-switching
  perf sched trace             # output finegrained trace
  perf sched replay            # replay a captured workload using simlated threads

Desktop users would generally use 'perf sched record' to capture a trace 
(which creates perf.data), and 'perf sched latency' tool to check 
latencies (which analyzes the trace in perf.data). The other tools too 
use an already recorded perf.data.

'scehd latency' example usage:

 perf sched record sleep 10     # record full system activity for 10 seconds
 perf sched latency --sort max  # report latencies sorted by max 

 -----------------------------------------------------------------------------------------
  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms |
 -----------------------------------------------------------------------------------------
  :14086:14086          |      0.095 ms |        2 | avg:    3.445 ms | max:    6.891 ms |
  gnome-session:13792   |     31.713 ms |      102 | avg:    0.160 ms | max:    5.992 ms |
  metacity:14038        |     49.220 ms |      637 | avg:    0.066 ms | max:    5.942 ms |
  gconfd-2:13971        |     48.587 ms |      777 | avg:    0.047 ms | max:    5.793 ms |
  gnome-power-man:14050 |    140.601 ms |      434 | avg:    0.097 ms | max:    5.367 ms |
  python:14049          |    114.694 ms |      125 | avg:    0.120 ms | max:    5.343 ms |
  kblockd/1:236         |      3.458 ms |      498 | avg:    0.179 ms | max:    5.271 ms |
  Xorg:3122             |   1073.107 ms |     2920 | avg:    0.030 ms | max:    5.265 ms |
  dbus-daemon:2063      |     64.593 ms |      665 | avg:    0.103 ms | max:    4.730 ms |
  :14040:14040          |     30.786 ms |      255 | avg:    0.095 ms | max:    4.155 ms |
  events/1:8            |      0.105 ms |       13 | avg:    0.598 ms | max:    3.775 ms |
  console-kit-dae:2080  |     14.867 ms |      152 | avg:    0.142 ms | max:    3.760 ms |
  gnome-settings-:14023 |    572.653 ms |      979 | avg:    0.056 ms | max:    3.627 ms |
 ...
 -----------------------------------------------------------------------------------------
  TOTAL:                |   3144.817 ms |    11654 |
 ---------------------------------------------------

this particular capture showed latencies that occured during a Gnome 
startup session. The following output shows firefox latencies during a 
'make -j4' kernel build on a dual-core laptop:

 europe:~> perf sched record sleep 10
 [ perf record: Woken up 15 times to write data ]
 [ perf record: Captured and wrote 7.408 MB perf.data (~323639 samples) ]

 -----------------------------------------------------------------------------------------
  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms |
 -----------------------------------------------------------------------------------------
 ...
  firefox:14329         |    845.724 ms |     1411 | avg:    0.529 ms | max:   14.982 ms |
 ...
 -----------------------------------------------------------------------------------------
  TOTAL:                |  20196.186 ms |    11011 |
 ---------------------------------------------------


Another sub-tool that interprets and analyzes the events in perf.data is 
'perf sched map', which prints an abbreviated text map of scheduling 
events. For example here is a snipped from the life of a 16-CPU box:

  $ perf sched map
  ...

   N1  O1  .   .   .   S1  .   .   .   B0  .  *I0  C1  .   M1  .    23002.773423 secs
   N1  O1  .  *Q0  .   S1  .   .   .   B0  .   I0  C1  .   M1  .    23002.773423 secs
   N1  O1  .   Q0  .   S1  .   .   .   B0  .  *R1  C1  .   M1  .    23002.773485 secs
   N1  O1  .   Q0  .   S1  .  *S0  .   B0  .   R1  C1  .   M1  .    23002.773478 secs
  *L0  O1  .   Q0  .   S1  .   S0  .   B0  .   R1  C1  .   M1  .    23002.773523 secs
   L0  O1  .  *.   .   S1  .   S0  .   B0  .   R1  C1  .   M1  .    23002.773531 secs
   L0  O1  .   .   .   S1  .   S0  .   B0  .   R1  C1 *T1  M1  .    23002.773547 secs T1 => irqbalance:2089
   L0  O1  .   .   .   S1  .   S0  .  *P0  .   R1  C1  T1  M1  .    23002.773549 secs
  *N1  O1  .   .   .   S1  .   S0  .   P0  .   R1  C1  T1  M1  .    23002.773566 secs
   N1  O1  .   .   .  *J0  .   S0  .   P0  .   R1  C1  T1  M1  .    23002.773571 secs
   N1  O1  .   .   .   J0  .   S0 *B0  P0  .   R1  C1  T1  M1  .    23002.773592 secs
   N1  O1  .   .   .   J0  .  *U0  B0  P0  .   R1  C1  T1  M1  .    23002.773582 secs
   N1  O1  .   .   .  *S1  .   U0  B0  P0  .   R1  C1  T1  M1  .    23002.773604 secs
   N1  O1  .   .   .   S1  .   U0  B0 *.   .   R1  C1  T1  M1  .    23002.773615 secs
   N1  O1  .   .   .   S1  .   U0  B0  .   .  *K0  C1  T1  M1  .    23002.773631 secs
   N1  O1  .  *M0  .   S1  .   U0  B0  .   .   K0  C1  T1  M1  .    23002.773624 secs
   N1  O1  .   M0  .   S1  .   U0 *.   .   .   K0  C1  T1  M1  .    23002.773644 secs
   N1  O1  .   M0  .   S1  .   U0  .   .   .  *R1  C1  T1  M1  .    23002.773662 secs
   N1  O1  .   M0  .   S1  .  *.   .   .   .   R1  C1  T1  M1  .    23002.773648 secs
   N1  O1  .  *.   .   S1  .   .   .   .   .   R1  C1  T1  M1  .    23002.773680 secs
   N1  O1  .   .   .  *L0  .   .   .   .   .   R1  C1  T1  M1  .    23002.773717 secs
  *N0  O1  .   .   .   L0  .   .   .   .   .   R1  C1  T1  M1  .    23002.773709 secs
  *N1  O1  .   .   .   L0  .   .   .   .   .   R1  C1  T1  M1  .    23002.773747 secs

Columns stand for individual CPUs, from CPU0 to CPU15, and the
two-letter shortcuts stand for tasks that are running on a CPU.

'*' denotes the CPU that had the event.

A dot signals an idle CPU.

New tasks are assigned new two-letter shortcuts - when they occur first 
they are printed. In the above example 'T1' stood for irqbalance:

      T1 => irqbalance:2089

The map can be used to characterise the 'health' of a workload at a 
glance, without having to go through hundreds of scheduling events. 
Problems in CPU distribution, bad scheduling patterns and incorrect 
migrations can be seen from this map.

'perf sched trace' is another sub-tool, it shows the trace as it 
happened, with all its fine details:

  pipe-test-100k-13520 [001]  1254.354513808: sched_stat_wait: task: pipe-test-100k:13521 wait: 5362 [ns]
  pipe-test-100k-13520 [001]  1254.354514876: sched_switch: task pipe-test-100k:13520 [120] (S) ==> pipe-test-100k:13521 [120]
          :13521-13521 [001]  1254.354517927: sched_stat_runtime: task: pipe-test-100k:13521 runtime: 5092 [ns], vruntime: 133967391150 [ns]
          :13521-13521 [001]  1254.354518984: sched_stat_sleep: task: pipe-test-100k:13520 sleep: 5092 [ns]
          :13521-13521 [001]  1254.354520011: sched_wakeup: task pipe-test-100k:13520 [120] success=1 [001]
          :13521-13521 [001]  1254.354521668: sched_stat_runtime: task: pipe-test-100k:13521 runtime: 3951 [ns], vruntime: 133967395101 [ns]
          :13521-13521 [001]  1254.354522773: sched_stat_wait: task: pipe-test-100k:13520 wait: 3951 [ns]
          :13521-13521 [001]  1254.354523860: sched_switch: task pipe-test-100k:13521 [120] (R) ==> pipe-test-100k:13520 [120]
  pipe-test-100k-13520 [001]  1254.354527060: sched_stat_runtime: task: pipe-test-100k:13520 runtime: 5375 [ns], vruntime: 133962396525 [ns]
  pipe-test-100k-13520 [001]  1254.354528225: sched_stat_wait: task: pipe-test-100k:13521 wait: 5375 [ns]
  pipe-test-100k-13520 [001]  1254.354529294: sched_switch: task pipe-test-100k:13520 [120] (S) ==> pipe-test-100k:13521 [120]
          :13521-13521 [001]  1254.354532345: sched_stat_runtime: task: pipe-test-100k:13521 runtime: 5092 [ns], vruntime: 133967400193 [ns]

Some problems can only be seen on this level.

There's also the 'perf sched replay' sub-tool - an (experimental) 
scheduling workload 'simulator'. This tool takes recorded events and 
turns them into sleep/run patterns of user-space threads which are then 
executed as if they real workload was running:

 $ perf sched replay
 run measurement overhead: 3771 nsecs
 sleep measurement overhead: 66617 nsecs
 the run test took 999708 nsecs
 the sleep test took 1097207 nsecs
 nr_run_events:        200221
 nr_sleep_events:      200235
 nr_wakeup_events:     100130
 task      0 (                perf:     13519), nr_events: 148
 task      1 (                perf:     13520), nr_events: 200037
 task      2 (      pipe-test-100k:     13521), nr_events: 300090
 task      3 (         ksoftirqd/0:         4), nr_events: 8
 task      4 (             swapper:         0), nr_events: 170
 task      5 (     gnome-power-man:      3192), nr_events: 3
 task      6 (     gdm-simple-gree:      3234), nr_events: 3
 task      7 (                Xorg:      3122), nr_events: 5
 task      8 (     hald-addon-stor:      2234), nr_events: 27
 task      9 (               ata/0:       321), nr_events: 29
 task     10 (           scsi_eh_4:       704), nr_events: 37
 task     11 (            events/1:         8), nr_events: 3
 task     12 (            events/0:         7), nr_events: 6
 task     13 (           flush-8:0:      6980), nr_events: 20
 ------------------------------------------------------------
 #1  : 2038.157, ravg: 2038.16, cpu: 0.09 / 0.09
 #2  : 2042.153, ravg: 2038.56, cpu: 0.11 / 0.09
 ^C

'top' showed the following while the replay was running:

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND                        
 13559 mingo     20   0 39108  29m  872 R 73.7  1.5   0:04.94 :pipe-test-100k                
 13561 mingo     20   0 39108  29m  872 R 62.7  1.5   0:04.46 :swapper                       
 13558 mingo     20   0 39108  29m  872 S 42.2  1.5   0:02.80 :perf                          
 13557 mingo     20   0 39108  29m  872 S 12.6  1.5   0:00.83 :perf                          
 13570 mingo     20   0 39108  29m  872 S  0.3  1.5   0:00.01 :flush-8:0                

The ':' prefix is artificial so that the simulated tasks are not 
confused with real tasks. Note that these are fully simulated tasks - 
there's no :pipe-test-100k binary executed by perf sched replay - the 
workload simulator renames its worker threads to the original command 
name.

The idea behind 'perf sched replay' is to allow the replication of 
difficult to set up workloads and their measurement, and to allow the 
tweaking of the scheduler without having to re-create the original 
scenario. It's a scheduler sandbox and workloads can be examined via 
their perf.data recordings alone.

All in one, 'perf sched' is extensible and modular and can take new 
sub-commands in the future as well - we thought latencies to be the 
first and most important mode of analysis to be added.

Also note that alternative schedulers such as BFS can easily add support 
for perf sched as well, by adding the following three tracepoints:

        sched:sched_switch
        sched:sched_stat_runtime
        sched:sched_wakeup

It's around 3 lines of code added. This would be highly desirable, to 
allow apples-to-apples comparison of schedulers, using the same tooling.

The latest version of 'perf sched', plus the re-tuned scheduler can be 
found in the -tip tree:

   http://people.redhat.com/mingo/tip.git/README

Or 'perf sched' alone can be found in the following standalone Git tree as well:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters/core

Plus a combo patch against Linus's latest tree is attached below as well,
for your testing and review pleasure.

 Thanks,

	Ingo

------------------>
Linus,

Please pull the latest perfcounters/core git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters/core

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (11):
      perf tools: Allow the specification of all tracepoints at once
      perf sched: Fix bad event alignment
      perf sched: Make it easier to plug in new sub profilers
      perf sched: Add sched latency profiling
      perf sched: Rename struct lat_snapshot to struct work atoms
      perf sched: Add involuntarily sleeping task in work atoms
      perf sched: Export the total, max latency and total runtime to thread atoms list
      perf sched: Fix nsec to msec conversion
      perf sched: Implement multidimensional sorting
      perf tools: Add an option to multiplex counters in a single channel
      perf tools: Fix processing of randomly serialized sched traces

Ingo Molnar (22):
      perf: Add 'perf sched' tool
      perf sched: Import schedbench.c
      perf sched: Implement the scheduling workload replay engine
      perf sched: Tighten up the code
      perf sched: Clean up latency and replay sub-commands
      perf sched: Display time in milliseconds, reorganize output
      perf sched: Add runtime stats
      perf sched: Output runtime and context switch totals
      perf sched: Add 'perf sched latency' and 'perf sched replay'
      perf sched: Finish latency => atom rename and misc cleanups
      perf sched: Clean up PID sorting logic
      perf sched: Implement the 'perf sched record' subcommand
      perf_counter: Allow mmap if paranoid checks are turned off
      perf sched: Add 'perf sched trace', improve documentation
      perf_counter, sched: Add sched_stat_runtime tracepoint
      perf tools: Implement counter output multiplexing
      perf sched: Fix 'perf sched latency' output on 32-bit systems
      perf sched: Account for lost events, increase default buffering
      perf sched: Sanity check context switch events
      perf sched: Make idle thread and comm/pid names more consistent
      perf sched: Add 'perf sched map' scheduling event map printout
      perf sched: Determine the number of CPUs automatically

Peter Zijlstra (3):
      perf_counter: Do not throttle single swcounter events
      perf_counter: Allow for a wakeup watermark
      perf record: Disable profiling before draining the buffer

mingo (2):
      perf sched: Print PIDs too
      perf sched: Add support for sched:sched_stat_runtime events


 include/linux/perf_counter.h            |   10 +-
 include/trace/events/sched.h            |   33 +
 kernel/perf_counter.c                   |   52 +-
 kernel/sched_fair.c                     |    1 +
 tools/perf/Documentation/perf-sched.txt |   41 +
 tools/perf/Documentation/perf-trace.txt |   25 +
 tools/perf/Makefile                     |    1 +
 tools/perf/builtin-record.c             |   56 +-
 tools/perf/builtin-sched.c              | 2002 +++++++++++++++++++++++++++++++
 tools/perf/builtin.h                    |    5 +-
 tools/perf/command-list.txt             |    2 +
 tools/perf/perf.c                       |    1 +
 tools/perf/util/event.h                 |    2 +-
 tools/perf/util/parse-events.c          |  207 +++-
 tools/perf/util/thread.c                |    4 +-
 tools/perf/util/thread.h                |    9 +-
 tools/perf/util/trace-event-parse.c     |   45 +-
 tools/perf/util/trace-event-read.c      |    6 +-
 tools/perf/util/trace-event.h           |    5 +
 19 files changed, 2400 insertions(+), 107 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-sched.txt
 create mode 100644 tools/perf/Documentation/perf-trace.txt
 create mode 100644 tools/perf/builtin-sched.c

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 972f90d..6c1ef72 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -199,10 +199,14 @@ struct perf_counter_attr {
 				inherit_stat   :  1, /* per task counts       */
 				enable_on_exec :  1, /* next exec enables     */
 				task           :  1, /* trace fork/exit       */
+				watermark      :  1, /* wakeup_watermark      */
 
-				__reserved_1   : 50;
+				__reserved_1   : 49;
 
-	__u32			wakeup_events;	/* wakeup every n events */
+	union {
+		__u32		wakeup_events;	  /* wakeup every n events */
+		__u32		wakeup_watermark; /* bytes before wakeup   */
+	};
 	__u32			__reserved_2;
 
 	__u64			__reserved_3;
@@ -521,6 +525,8 @@ struct perf_mmap_data {
 	atomic_t			wakeup;		/* needs a wakeup    */
 	atomic_t			lost;		/* nr records lost   */
 
+	long				watermark;	/* wakeup watermark  */
+
 	struct perf_counter_mmap_page   *user_page;
 	void				*data_pages[0];
 };
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index b48f1ad..4069c43 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -380,6 +380,39 @@ TRACE_EVENT(sched_stat_wait,
 );
 
 /*
+ * Tracepoint for accounting runtime (time the task is executing
+ * on a CPU).
+ */
+TRACE_EVENT(sched_stat_runtime,
+
+	TP_PROTO(struct task_struct *tsk, u64 runtime, u64 vruntime),
+
+	TP_ARGS(tsk, runtime, vruntime),
+
+	TP_STRUCT__entry(
+		__array( char,	comm,	TASK_COMM_LEN	)
+		__field( pid_t,	pid			)
+		__field( u64,	runtime			)
+		__field( u64,	vruntime			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		__entry->pid		= tsk->pid;
+		__entry->runtime	= runtime;
+		__entry->vruntime	= vruntime;
+	)
+	TP_perf_assign(
+		__perf_count(runtime);
+	),
+
+	TP_printk("task: %s:%d runtime: %Lu [ns], vruntime: %Lu [ns]",
+			__entry->comm, __entry->pid,
+			(unsigned long long)__entry->runtime,
+			(unsigned long long)__entry->vruntime)
+);
+
+/*
  * Tracepoint for accounting sleep time (time the task is not runnable,
  * including iowait, see below).
  */
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index e0d91fd..29b73b6 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2176,6 +2176,13 @@ static int perf_mmap_data_alloc(struct perf_counter *counter, int nr_pages)
 	data->nr_pages = nr_pages;
 	atomic_set(&data->lock, -1);
 
+	if (counter->attr.watermark) {
+		data->watermark = min_t(long, PAGE_SIZE * nr_pages,
+				      counter->attr.wakeup_watermark);
+	}
+	if (!data->watermark)
+		data->watermark = max(PAGE_SIZE, PAGE_SIZE * nr_pages / 4);
+
 	rcu_assign_pointer(counter->data, data);
 
 	return 0;
@@ -2315,7 +2322,8 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	lock_limit >>= PAGE_SHIFT;
 	locked = vma->vm_mm->locked_vm + extra;
 
-	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
+	if ((locked > lock_limit) && perf_paranoid_tracepoint_raw() &&
+		!capable(CAP_IPC_LOCK)) {
 		ret = -EPERM;
 		goto unlock;
 	}
@@ -2516,23 +2524,15 @@ struct perf_output_handle {
 	unsigned long		flags;
 };
 
-static bool perf_output_space(struct perf_mmap_data *data,
-			      unsigned int offset, unsigned int head)
+static bool perf_output_space(struct perf_mmap_data *data, unsigned long tail,
+			      unsigned long offset, unsigned long head)
 {
-	unsigned long tail;
 	unsigned long mask;
 
 	if (!data->writable)
 		return true;
 
 	mask = (data->nr_pages << PAGE_SHIFT) - 1;
-	/*
-	 * Userspace could choose to issue a mb() before updating the tail
-	 * pointer. So that all reads will be completed before the write is
-	 * issued.
-	 */
-	tail = ACCESS_ONCE(data->user_page->data_tail);
-	smp_rmb();
 
 	offset = (offset - tail) & mask;
 	head   = (head   - tail) & mask;
@@ -2678,7 +2678,7 @@ static int perf_output_begin(struct perf_output_handle *handle,
 {
 	struct perf_counter *output_counter;
 	struct perf_mmap_data *data;
-	unsigned int offset, head;
+	unsigned long tail, offset, head;
 	int have_lost;
 	struct {
 		struct perf_event_header header;
@@ -2716,16 +2716,23 @@ static int perf_output_begin(struct perf_output_handle *handle,
 	perf_output_lock(handle);
 
 	do {
+		/*
+		 * Userspace could choose to issue a mb() before updating the
+		 * tail pointer. So that all reads will be completed before the
+		 * write is issued.
+		 */
+		tail = ACCESS_ONCE(data->user_page->data_tail);
+		smp_rmb();
 		offset = head = atomic_long_read(&data->head);
 		head += size;
-		if (unlikely(!perf_output_space(data, offset, head)))
+		if (unlikely(!perf_output_space(data, tail, offset, head)))
 			goto fail;
 	} while (atomic_long_cmpxchg(&data->head, offset, head) != offset);
 
 	handle->offset	= offset;
 	handle->head	= head;
 
-	if ((offset >> PAGE_SHIFT) != (head >> PAGE_SHIFT))
+	if (head - tail > data->watermark)
 		atomic_set(&data->wakeup, 1);
 
 	if (have_lost) {
@@ -3493,14 +3500,15 @@ static void perf_log_throttle(struct perf_counter *counter, int enable)
  * Generic counter overflow handling, sampling.
  */
 
-int perf_counter_overflow(struct perf_counter *counter, int nmi,
-			  struct perf_sample_data *data)
+static int __perf_counter_overflow(struct perf_counter *counter, int nmi,
+				   int throttle, struct perf_sample_data *data)
 {
 	int events = atomic_read(&counter->event_limit);
-	int throttle = counter->pmu->unthrottle != NULL;
 	struct hw_perf_counter *hwc = &counter->hw;
 	int ret = 0;
 
+	throttle = (throttle && counter->pmu->unthrottle != NULL);
+
 	if (!throttle) {
 		hwc->interrupts++;
 	} else {
@@ -3553,6 +3561,12 @@ int perf_counter_overflow(struct perf_counter *counter, int nmi,
 	return ret;
 }
 
+int perf_counter_overflow(struct perf_counter *counter, int nmi,
+			  struct perf_sample_data *data)
+{
+	return __perf_counter_overflow(counter, nmi, 1, data);
+}
+
 /*
  * Generic software counter infrastructure
  */
@@ -3591,6 +3605,7 @@ static void perf_swcounter_overflow(struct perf_counter *counter,
 				    int nmi, struct perf_sample_data *data)
 {
 	struct hw_perf_counter *hwc = &counter->hw;
+	int throttle = 0;
 	u64 overflow;
 
 	data->period = counter->hw.last_period;
@@ -3600,13 +3615,14 @@ static void perf_swcounter_overflow(struct perf_counter *counter,
 		return;
 
 	for (; overflow; overflow--) {
-		if (perf_counter_overflow(counter, nmi, data)) {
+		if (__perf_counter_overflow(counter, nmi, throttle, data)) {
 			/*
 			 * We inhibit the overflow from happening when
 			 * hwc->interrupts == MAX_INTERRUPTS.
 			 */
 			break;
 		}
+		throttle = 0;
 	}
 }
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index aa7f841..a097e90 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -513,6 +513,7 @@ static void update_curr(struct cfs_rq *cfs_rq)
 	if (entity_is_task(curr)) {
 		struct task_struct *curtask = task_of(curr);
 
+		trace_sched_stat_runtime(curtask, delta_exec, curr->vruntime);
 		cpuacct_charge(curtask, delta_exec);
 		account_group_exec_runtime(curtask, delta_exec);
 	}
diff --git a/tools/perf/Documentation/perf-sched.txt b/tools/perf/Documentation/perf-sched.txt
new file mode 100644
index 0000000..1ce7919
--- /dev/null
+++ b/tools/perf/Documentation/perf-sched.txt
@@ -0,0 +1,41 @@
+perf-sched(1)
+==============
+
+NAME
+----
+perf-sched - Tool to trace/measure scheduler properties (latencies)
+
+SYNOPSIS
+--------
+[verse]
+'perf sched' {record|latency|replay|trace}
+
+DESCRIPTION
+-----------
+There's four variants of perf sched:
+
+  'perf sched record <command>' to record the scheduling events
+  of an arbitrary workload.
+
+  'perf sched latency' to report the per task scheduling latencies
+  and other scheduling properties of the workload.
+
+  'perf sched trace' to see a detailed trace of the workload that
+  was recorded.
+
+  'perf sched replay' to simulate the workload that was recorded
+  via perf sched record. (this is done by starting up mockup threads
+  that mimic the workload based on the events in the trace. These
+  threads can then replay the timings (CPU runtime and sleep patterns)
+  of the workload as it occured when it was recorded - and can repeat
+  it a number of times, measuring its performance.)
+
+OPTIONS
+-------
+-D::
+--dump-raw-trace=::
+        Display verbose dump of the sched data.
+
+SEE ALSO
+--------
+linkperf:perf-record[1]
diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
new file mode 100644
index 0000000..41ed753
--- /dev/null
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -0,0 +1,25 @@
+perf-trace(1)
+==============
+
+NAME
+----
+perf-trace - Read perf.data (created by perf record) and display trace output
+
+SYNOPSIS
+--------
+[verse]
+'perf trace' [-i <file> | --input=file] symbol_name
+
+DESCRIPTION
+-----------
+This command reads the input file and displays the trace recorded.
+
+OPTIONS
+-------
+-D::
+--dump-raw-trace=::
+        Display verbose dump of the trace data.
+
+SEE ALSO
+--------
+linkperf:perf-record[1]
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9f8d207..2cb8cc3 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -376,6 +376,7 @@ LIB_OBJS += util/trace-event-info.o
 
 BUILTIN_OBJS += builtin-annotate.o
 BUILTIN_OBJS += builtin-help.o
+BUILTIN_OBJS += builtin-sched.o
 BUILTIN_OBJS += builtin-list.o
 BUILTIN_OBJS += builtin-record.o
 BUILTIN_OBJS += builtin-report.o
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 99a12fe..2459e5a 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -48,6 +48,8 @@ static int			call_graph			= 0;
 static int			inherit_stat			= 0;
 static int			no_samples			= 0;
 static int			sample_address			= 0;
+static int			multiplex			= 0;
+static int			multiplex_fd			= -1;
 
 static long			samples;
 static struct timeval		last_read;
@@ -470,19 +472,28 @@ try_again:
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
+	if (multiplex && fd[nr_cpu][counter] != multiplex_fd) {
+		int ret;
+
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
 	}
 
 	ioctl(fd[nr_cpu][counter], PERF_COUNTER_IOC_ENABLE);
@@ -513,6 +524,7 @@ static int __cmd_record(int argc, const char **argv)
 	pid_t pid = 0;
 	int flags;
 	int ret;
+	unsigned long waking = 0;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
@@ -614,17 +626,29 @@ static int __cmd_record(int argc, const char **argv)
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
 			if (done)
 				break;
-			ret = poll(event_array, nr_poll, 100);
+			ret = poll(event_array, nr_poll, -1);
+			waking++;
+		}
+
+		if (done) {
+			for (i = 0; i < nr_cpu; i++) {
+				for (counter = 0; counter < nr_counters; counter++)
+					ioctl(fd[i][counter], PERF_COUNTER_IOC_DISABLE);
+			}
 		}
 	}
 
+	fprintf(stderr, "[ perf record: Woken up %ld times to write data ]\n", waking);
+
 	/*
 	 * Approximate RIP event size: 24 bytes.
 	 */
@@ -681,6 +705,8 @@ static const struct option options[] = {
 		    "Sample addresses"),
 	OPT_BOOLEAN('n', "no-samples", &no_samples,
 		    "don't sample"),
+	OPT_BOOLEAN('M', "multiplex", &multiplex,
+		    "multiplex counter output in a single channel"),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
new file mode 100644
index 0000000..9e04827
--- /dev/null
+++ b/tools/perf/builtin-sched.c
@@ -0,0 +1,2002 @@
+#include "builtin.h"
+#include "perf.h"
+
+#include "util/util.h"
+#include "util/cache.h"
+#include "util/symbol.h"
+#include "util/thread.h"
+#include "util/header.h"
+
+#include "util/parse-options.h"
+#include "util/trace-event.h"
+
+#include "util/debug.h"
+
+#include <sys/types.h>
+#include <sys/prctl.h>
+
+#include <semaphore.h>
+#include <pthread.h>
+#include <math.h>
+
+static char			const *input_name = "perf.data";
+static int			input;
+static unsigned long		page_size;
+static unsigned long		mmap_window = 32;
+
+static unsigned long		total_comm = 0;
+
+static struct rb_root		threads;
+static struct thread		*last_match;
+
+static struct perf_header	*header;
+static u64			sample_type;
+
+static char			default_sort_order[] = "avg, max, switch, runtime";
+static char			*sort_order = default_sort_order;
+
+#define PR_SET_NAME		15               /* Set process name */
+#define MAX_CPUS		4096
+
+#define BUG_ON(x)		assert(!(x))
+
+static u64			run_measurement_overhead;
+static u64			sleep_measurement_overhead;
+
+#define COMM_LEN		20
+#define SYM_LEN			129
+
+#define MAX_PID			65536
+
+static unsigned long		nr_tasks;
+
+struct sched_atom;
+
+struct task_desc {
+	unsigned long		nr;
+	unsigned long		pid;
+	char			comm[COMM_LEN];
+
+	unsigned long		nr_events;
+	unsigned long		curr_event;
+	struct sched_atom	**atoms;
+
+	pthread_t		thread;
+	sem_t			sleep_sem;
+
+	sem_t			ready_for_work;
+	sem_t			work_done_sem;
+
+	u64			cpu_usage;
+};
+
+enum sched_event_type {
+	SCHED_EVENT_RUN,
+	SCHED_EVENT_SLEEP,
+	SCHED_EVENT_WAKEUP,
+};
+
+struct sched_atom {
+	enum sched_event_type	type;
+	u64			timestamp;
+	u64			duration;
+	unsigned long		nr;
+	int			specific_wait;
+	sem_t			*wait_sem;
+	struct task_desc	*wakee;
+};
+
+static struct task_desc		*pid_to_task[MAX_PID];
+
+static struct task_desc		**tasks;
+
+static pthread_mutex_t		start_work_mutex = PTHREAD_MUTEX_INITIALIZER;
+static u64			start_time;
+
+static pthread_mutex_t		work_done_wait_mutex = PTHREAD_MUTEX_INITIALIZER;
+
+static unsigned long		nr_run_events;
+static unsigned long		nr_sleep_events;
+static unsigned long		nr_wakeup_events;
+
+static unsigned long		nr_sleep_corrections;
+static unsigned long		nr_run_events_optimized;
+
+static unsigned long		targetless_wakeups;
+static unsigned long		multitarget_wakeups;
+
+static u64			cpu_usage;
+static u64			runavg_cpu_usage;
+static u64			parent_cpu_usage;
+static u64			runavg_parent_cpu_usage;
+
+static unsigned long		nr_runs;
+static u64			sum_runtime;
+static u64			sum_fluct;
+static u64			run_avg;
+
+static unsigned long		replay_repeat = 10;
+static unsigned long		nr_timestamps;
+static unsigned long		nr_unordered_timestamps;
+static unsigned long		nr_state_machine_bugs;
+static unsigned long		nr_context_switch_bugs;
+static unsigned long		nr_events;
+static unsigned long		nr_lost_chunks;
+static unsigned long		nr_lost_events;
+
+#define TASK_STATE_TO_CHAR_STR "RSDTtZX"
+
+enum thread_state {
+	THREAD_SLEEPING = 0,
+	THREAD_WAIT_CPU,
+	THREAD_SCHED_IN,
+	THREAD_IGNORE
+};
+
+struct work_atom {
+	struct list_head	list;
+	enum thread_state	state;
+	u64			sched_out_time;
+	u64			wake_up_time;
+	u64			sched_in_time;
+	u64			runtime;
+};
+
+struct work_atoms {
+	struct list_head	work_list;
+	struct thread		*thread;
+	struct rb_node		node;
+	u64			max_lat;
+	u64			total_lat;
+	u64			nb_atoms;
+	u64			total_runtime;
+};
+
+typedef int (*sort_fn_t)(struct work_atoms *, struct work_atoms *);
+
+static struct rb_root		atom_root, sorted_atom_root;
+
+static u64			all_runtime;
+static u64			all_count;
+
+
+static u64 get_nsecs(void)
+{
+	struct timespec ts;
+
+	clock_gettime(CLOCK_MONOTONIC, &ts);
+
+	return ts.tv_sec * 1000000000ULL + ts.tv_nsec;
+}
+
+static void burn_nsecs(u64 nsecs)
+{
+	u64 T0 = get_nsecs(), T1;
+
+	do {
+		T1 = get_nsecs();
+	} while (T1 + run_measurement_overhead < T0 + nsecs);
+}
+
+static void sleep_nsecs(u64 nsecs)
+{
+	struct timespec ts;
+
+	ts.tv_nsec = nsecs % 999999999;
+	ts.tv_sec = nsecs / 999999999;
+
+	nanosleep(&ts, NULL);
+}
+
+static void calibrate_run_measurement_overhead(void)
+{
+	u64 T0, T1, delta, min_delta = 1000000000ULL;
+	int i;
+
+	for (i = 0; i < 10; i++) {
+		T0 = get_nsecs();
+		burn_nsecs(0);
+		T1 = get_nsecs();
+		delta = T1-T0;
+		min_delta = min(min_delta, delta);
+	}
+	run_measurement_overhead = min_delta;
+
+	printf("run measurement overhead: %Ld nsecs\n", min_delta);
+}
+
+static void calibrate_sleep_measurement_overhead(void)
+{
+	u64 T0, T1, delta, min_delta = 1000000000ULL;
+	int i;
+
+	for (i = 0; i < 10; i++) {
+		T0 = get_nsecs();
+		sleep_nsecs(10000);
+		T1 = get_nsecs();
+		delta = T1-T0;
+		min_delta = min(min_delta, delta);
+	}
+	min_delta -= 10000;
+	sleep_measurement_overhead = min_delta;
+
+	printf("sleep measurement overhead: %Ld nsecs\n", min_delta);
+}
+
+static struct sched_atom *
+get_new_event(struct task_desc *task, u64 timestamp)
+{
+	struct sched_atom *event = calloc(1, sizeof(*event));
+	unsigned long idx = task->nr_events;
+	size_t size;
+
+	event->timestamp = timestamp;
+	event->nr = idx;
+
+	task->nr_events++;
+	size = sizeof(struct sched_atom *) * task->nr_events;
+	task->atoms = realloc(task->atoms, size);
+	BUG_ON(!task->atoms);
+
+	task->atoms[idx] = event;
+
+	return event;
+}
+
+static struct sched_atom *last_event(struct task_desc *task)
+{
+	if (!task->nr_events)
+		return NULL;
+
+	return task->atoms[task->nr_events - 1];
+}
+
+static void
+add_sched_event_run(struct task_desc *task, u64 timestamp, u64 duration)
+{
+	struct sched_atom *event, *curr_event = last_event(task);
+
+	/*
+	 * optimize an existing RUN event by merging this one
+	 * to it:
+	 */
+	if (curr_event && curr_event->type == SCHED_EVENT_RUN) {
+		nr_run_events_optimized++;
+		curr_event->duration += duration;
+		return;
+	}
+
+	event = get_new_event(task, timestamp);
+
+	event->type = SCHED_EVENT_RUN;
+	event->duration = duration;
+
+	nr_run_events++;
+}
+
+static void
+add_sched_event_wakeup(struct task_desc *task, u64 timestamp,
+		       struct task_desc *wakee)
+{
+	struct sched_atom *event, *wakee_event;
+
+	event = get_new_event(task, timestamp);
+	event->type = SCHED_EVENT_WAKEUP;
+	event->wakee = wakee;
+
+	wakee_event = last_event(wakee);
+	if (!wakee_event || wakee_event->type != SCHED_EVENT_SLEEP) {
+		targetless_wakeups++;
+		return;
+	}
+	if (wakee_event->wait_sem) {
+		multitarget_wakeups++;
+		return;
+	}
+
+	wakee_event->wait_sem = calloc(1, sizeof(*wakee_event->wait_sem));
+	sem_init(wakee_event->wait_sem, 0, 0);
+	wakee_event->specific_wait = 1;
+	event->wait_sem = wakee_event->wait_sem;
+
+	nr_wakeup_events++;
+}
+
+static void
+add_sched_event_sleep(struct task_desc *task, u64 timestamp,
+		      u64 task_state __used)
+{
+	struct sched_atom *event = get_new_event(task, timestamp);
+
+	event->type = SCHED_EVENT_SLEEP;
+
+	nr_sleep_events++;
+}
+
+static struct task_desc *register_pid(unsigned long pid, const char *comm)
+{
+	struct task_desc *task;
+
+	BUG_ON(pid >= MAX_PID);
+
+	task = pid_to_task[pid];
+
+	if (task)
+		return task;
+
+	task = calloc(1, sizeof(*task));
+	task->pid = pid;
+	task->nr = nr_tasks;
+	strcpy(task->comm, comm);
+	/*
+	 * every task starts in sleeping state - this gets ignored
+	 * if there's no wakeup pointing to this sleep state:
+	 */
+	add_sched_event_sleep(task, 0, 0);
+
+	pid_to_task[pid] = task;
+	nr_tasks++;
+	tasks = realloc(tasks, nr_tasks*sizeof(struct task_task *));
+	BUG_ON(!tasks);
+	tasks[task->nr] = task;
+
+	if (verbose)
+		printf("registered task #%ld, PID %ld (%s)\n", nr_tasks, pid, comm);
+
+	return task;
+}
+
+
+static void print_task_traces(void)
+{
+	struct task_desc *task;
+	unsigned long i;
+
+	for (i = 0; i < nr_tasks; i++) {
+		task = tasks[i];
+		printf("task %6ld (%20s:%10ld), nr_events: %ld\n",
+			task->nr, task->comm, task->pid, task->nr_events);
+	}
+}
+
+static void add_cross_task_wakeups(void)
+{
+	struct task_desc *task1, *task2;
+	unsigned long i, j;
+
+	for (i = 0; i < nr_tasks; i++) {
+		task1 = tasks[i];
+		j = i + 1;
+		if (j == nr_tasks)
+			j = 0;
+		task2 = tasks[j];
+		add_sched_event_wakeup(task1, 0, task2);
+	}
+}
+
+static void
+process_sched_event(struct task_desc *this_task __used, struct sched_atom *atom)
+{
+	int ret = 0;
+	u64 now;
+	long long delta;
+
+	now = get_nsecs();
+	delta = start_time + atom->timestamp - now;
+
+	switch (atom->type) {
+		case SCHED_EVENT_RUN:
+			burn_nsecs(atom->duration);
+			break;
+		case SCHED_EVENT_SLEEP:
+			if (atom->wait_sem)
+				ret = sem_wait(atom->wait_sem);
+			BUG_ON(ret);
+			break;
+		case SCHED_EVENT_WAKEUP:
+			if (atom->wait_sem)
+				ret = sem_post(atom->wait_sem);
+			BUG_ON(ret);
+			break;
+		default:
+			BUG_ON(1);
+	}
+}
+
+static u64 get_cpu_usage_nsec_parent(void)
+{
+	struct rusage ru;
+	u64 sum;
+	int err;
+
+	err = getrusage(RUSAGE_SELF, &ru);
+	BUG_ON(err);
+
+	sum =  ru.ru_utime.tv_sec*1e9 + ru.ru_utime.tv_usec*1e3;
+	sum += ru.ru_stime.tv_sec*1e9 + ru.ru_stime.tv_usec*1e3;
+
+	return sum;
+}
+
+static u64 get_cpu_usage_nsec_self(void)
+{
+	char filename [] = "/proc/1234567890/sched";
+	unsigned long msecs, nsecs;
+	char *line = NULL;
+	u64 total = 0;
+	size_t len = 0;
+	ssize_t chars;
+	FILE *file;
+	int ret;
+
+	sprintf(filename, "/proc/%d/sched", getpid());
+	file = fopen(filename, "r");
+	BUG_ON(!file);
+
+	while ((chars = getline(&line, &len, file)) != -1) {
+		ret = sscanf(line, "se.sum_exec_runtime : %ld.%06ld\n",
+			&msecs, &nsecs);
+		if (ret == 2) {
+			total = msecs*1e6 + nsecs;
+			break;
+		}
+	}
+	if (line)
+		free(line);
+	fclose(file);
+
+	return total;
+}
+
+static void *thread_func(void *ctx)
+{
+	struct task_desc *this_task = ctx;
+	u64 cpu_usage_0, cpu_usage_1;
+	unsigned long i, ret;
+	char comm2[22];
+
+	sprintf(comm2, ":%s", this_task->comm);
+	prctl(PR_SET_NAME, comm2);
+
+again:
+	ret = sem_post(&this_task->ready_for_work);
+	BUG_ON(ret);
+	ret = pthread_mutex_lock(&start_work_mutex);
+	BUG_ON(ret);
+	ret = pthread_mutex_unlock(&start_work_mutex);
+	BUG_ON(ret);
+
+	cpu_usage_0 = get_cpu_usage_nsec_self();
+
+	for (i = 0; i < this_task->nr_events; i++) {
+		this_task->curr_event = i;
+		process_sched_event(this_task, this_task->atoms[i]);
+	}
+
+	cpu_usage_1 = get_cpu_usage_nsec_self();
+	this_task->cpu_usage = cpu_usage_1 - cpu_usage_0;
+
+	ret = sem_post(&this_task->work_done_sem);
+	BUG_ON(ret);
+
+	ret = pthread_mutex_lock(&work_done_wait_mutex);
+	BUG_ON(ret);
+	ret = pthread_mutex_unlock(&work_done_wait_mutex);
+	BUG_ON(ret);
+
+	goto again;
+}
+
+static void create_tasks(void)
+{
+	struct task_desc *task;
+	pthread_attr_t attr;
+	unsigned long i;
+	int err;
+
+	err = pthread_attr_init(&attr);
+	BUG_ON(err);
+	err = pthread_attr_setstacksize(&attr, (size_t)(16*1024));
+	BUG_ON(err);
+	err = pthread_mutex_lock(&start_work_mutex);
+	BUG_ON(err);
+	err = pthread_mutex_lock(&work_done_wait_mutex);
+	BUG_ON(err);
+	for (i = 0; i < nr_tasks; i++) {
+		task = tasks[i];
+		sem_init(&task->sleep_sem, 0, 0);
+		sem_init(&task->ready_for_work, 0, 0);
+		sem_init(&task->work_done_sem, 0, 0);
+		task->curr_event = 0;
+		err = pthread_create(&task->thread, &attr, thread_func, task);
+		BUG_ON(err);
+	}
+}
+
+static void wait_for_tasks(void)
+{
+	u64 cpu_usage_0, cpu_usage_1;
+	struct task_desc *task;
+	unsigned long i, ret;
+
+	start_time = get_nsecs();
+	cpu_usage = 0;
+	pthread_mutex_unlock(&work_done_wait_mutex);
+
+	for (i = 0; i < nr_tasks; i++) {
+		task = tasks[i];
+		ret = sem_wait(&task->ready_for_work);
+		BUG_ON(ret);
+		sem_init(&task->ready_for_work, 0, 0);
+	}
+	ret = pthread_mutex_lock(&work_done_wait_mutex);
+	BUG_ON(ret);
+
+	cpu_usage_0 = get_cpu_usage_nsec_parent();
+
+	pthread_mutex_unlock(&start_work_mutex);
+
+	for (i = 0; i < nr_tasks; i++) {
+		task = tasks[i];
+		ret = sem_wait(&task->work_done_sem);
+		BUG_ON(ret);
+		sem_init(&task->work_done_sem, 0, 0);
+		cpu_usage += task->cpu_usage;
+		task->cpu_usage = 0;
+	}
+
+	cpu_usage_1 = get_cpu_usage_nsec_parent();
+	if (!runavg_cpu_usage)
+		runavg_cpu_usage = cpu_usage;
+	runavg_cpu_usage = (runavg_cpu_usage*9 + cpu_usage)/10;
+
+	parent_cpu_usage = cpu_usage_1 - cpu_usage_0;
+	if (!runavg_parent_cpu_usage)
+		runavg_parent_cpu_usage = parent_cpu_usage;
+	runavg_parent_cpu_usage = (runavg_parent_cpu_usage*9 +
+				   parent_cpu_usage)/10;
+
+	ret = pthread_mutex_lock(&start_work_mutex);
+	BUG_ON(ret);
+
+	for (i = 0; i < nr_tasks; i++) {
+		task = tasks[i];
+		sem_init(&task->sleep_sem, 0, 0);
+		task->curr_event = 0;
+	}
+}
+
+static void run_one_test(void)
+{
+	u64 T0, T1, delta, avg_delta, fluct, std_dev;
+
+	T0 = get_nsecs();
+	wait_for_tasks();
+	T1 = get_nsecs();
+
+	delta = T1 - T0;
+	sum_runtime += delta;
+	nr_runs++;
+
+	avg_delta = sum_runtime / nr_runs;
+	if (delta < avg_delta)
+		fluct = avg_delta - delta;
+	else
+		fluct = delta - avg_delta;
+	sum_fluct += fluct;
+	std_dev = sum_fluct / nr_runs / sqrt(nr_runs);
+	if (!run_avg)
+		run_avg = delta;
+	run_avg = (run_avg*9 + delta)/10;
+
+	printf("#%-3ld: %0.3f, ",
+		nr_runs, (double)delta/1000000.0);
+
+	printf("ravg: %0.2f, ",
+		(double)run_avg/1e6);
+
+	printf("cpu: %0.2f / %0.2f",
+		(double)cpu_usage/1e6, (double)runavg_cpu_usage/1e6);
+
+#if 0
+	/*
+	 * rusage statistics done by the parent, these are less
+	 * accurate than the sum_exec_runtime based statistics:
+	 */
+	printf(" [%0.2f / %0.2f]",
+		(double)parent_cpu_usage/1e6,
+		(double)runavg_parent_cpu_usage/1e6);
+#endif
+
+	printf("\n");
+
+	if (nr_sleep_corrections)
+		printf(" (%ld sleep corrections)\n", nr_sleep_corrections);
+	nr_sleep_corrections = 0;
+}
+
+static void test_calibrations(void)
+{
+	u64 T0, T1;
+
+	T0 = get_nsecs();
+	burn_nsecs(1e6);
+	T1 = get_nsecs();
+
+	printf("the run test took %Ld nsecs\n", T1-T0);
+
+	T0 = get_nsecs();
+	sleep_nsecs(1e6);
+	T1 = get_nsecs();
+
+	printf("the sleep test took %Ld nsecs\n", T1-T0);
+}
+
+static int
+process_comm_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	struct thread *thread;
+
+	thread = threads__findnew(event->comm.pid, &threads, &last_match);
+
+	dump_printf("%p [%p]: perf_event_comm: %s:%d\n",
+		(void *)(offset + head),
+		(void *)(long)(event->header.size),
+		event->comm.comm, event->comm.pid);
+
+	if (thread == NULL ||
+	    thread__set_comm(thread, event->comm.comm)) {
+		dump_printf("problem processing perf_event_comm, skipping event.\n");
+		return -1;
+	}
+	total_comm++;
+
+	return 0;
+}
+
+
+struct raw_event_sample {
+	u32 size;
+	char data[0];
+};
+
+#define FILL_FIELD(ptr, field, event, data)	\
+	ptr.field = (typeof(ptr.field)) raw_field_value(event, #field, data)
+
+#define FILL_ARRAY(ptr, array, event, data)			\
+do {								\
+	void *__array = raw_field_ptr(event, #array, data);	\
+	memcpy(ptr.array, __array, sizeof(ptr.array));	\
+} while(0)
+
+#define FILL_COMMON_FIELDS(ptr, event, data)			\
+do {								\
+	FILL_FIELD(ptr, common_type, event, data);		\
+	FILL_FIELD(ptr, common_flags, event, data);		\
+	FILL_FIELD(ptr, common_preempt_count, event, data);	\
+	FILL_FIELD(ptr, common_pid, event, data);		\
+	FILL_FIELD(ptr, common_tgid, event, data);		\
+} while (0)
+
+
+
+struct trace_switch_event {
+	u32 size;
+
+	u16 common_type;
+	u8 common_flags;
+	u8 common_preempt_count;
+	u32 common_pid;
+	u32 common_tgid;
+
+	char prev_comm[16];
+	u32 prev_pid;
+	u32 prev_prio;
+	u64 prev_state;
+	char next_comm[16];
+	u32 next_pid;
+	u32 next_prio;
+};
+
+struct trace_runtime_event {
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
+	u64 runtime;
+	u64 vruntime;
+};
+
+struct trace_wakeup_event {
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
+	u32 success;
+	u32 cpu;
+};
+
+struct trace_fork_event {
+	u32 size;
+
+	u16 common_type;
+	u8 common_flags;
+	u8 common_preempt_count;
+	u32 common_pid;
+	u32 common_tgid;
+
+	char parent_comm[16];
+	u32 parent_pid;
+	char child_comm[16];
+	u32 child_pid;
+};
+
+struct trace_sched_handler {
+	void (*switch_event)(struct trace_switch_event *,
+			     struct event *,
+			     int cpu,
+			     u64 timestamp,
+			     struct thread *thread);
+
+	void (*runtime_event)(struct trace_runtime_event *,
+			      struct event *,
+			      int cpu,
+			      u64 timestamp,
+			      struct thread *thread);
+
+	void (*wakeup_event)(struct trace_wakeup_event *,
+			     struct event *,
+			     int cpu,
+			     u64 timestamp,
+			     struct thread *thread);
+
+	void (*fork_event)(struct trace_fork_event *,
+			   struct event *,
+			   int cpu,
+			   u64 timestamp,
+			   struct thread *thread);
+};
+
+
+static void
+replay_wakeup_event(struct trace_wakeup_event *wakeup_event,
+		    struct event *event,
+		    int cpu __used,
+		    u64 timestamp __used,
+		    struct thread *thread __used)
+{
+	struct task_desc *waker, *wakee;
+
+	if (verbose) {
+		printf("sched_wakeup event %p\n", event);
+
+		printf(" ... pid %d woke up %s/%d\n",
+			wakeup_event->common_pid,
+			wakeup_event->comm,
+			wakeup_event->pid);
+	}
+
+	waker = register_pid(wakeup_event->common_pid, "<unknown>");
+	wakee = register_pid(wakeup_event->pid, wakeup_event->comm);
+
+	add_sched_event_wakeup(waker, timestamp, wakee);
+}
+
+static u64 cpu_last_switched[MAX_CPUS];
+
+static void
+replay_switch_event(struct trace_switch_event *switch_event,
+		    struct event *event,
+		    int cpu,
+		    u64 timestamp,
+		    struct thread *thread __used)
+{
+	struct task_desc *prev, *next;
+	u64 timestamp0;
+	s64 delta;
+
+	if (verbose)
+		printf("sched_switch event %p\n", event);
+
+	if (cpu >= MAX_CPUS || cpu < 0)
+		return;
+
+	timestamp0 = cpu_last_switched[cpu];
+	if (timestamp0)
+		delta = timestamp - timestamp0;
+	else
+		delta = 0;
+
+	if (delta < 0)
+		die("hm, delta: %Ld < 0 ?\n", delta);
+
+	if (verbose) {
+		printf(" ... switch from %s/%d to %s/%d [ran %Ld nsecs]\n",
+			switch_event->prev_comm, switch_event->prev_pid,
+			switch_event->next_comm, switch_event->next_pid,
+			delta);
+	}
+
+	prev = register_pid(switch_event->prev_pid, switch_event->prev_comm);
+	next = register_pid(switch_event->next_pid, switch_event->next_comm);
+
+	cpu_last_switched[cpu] = timestamp;
+
+	add_sched_event_run(prev, timestamp, delta);
+	add_sched_event_sleep(prev, timestamp, switch_event->prev_state);
+}
+
+
+static void
+replay_fork_event(struct trace_fork_event *fork_event,
+		  struct event *event,
+		  int cpu __used,
+		  u64 timestamp __used,
+		  struct thread *thread __used)
+{
+	if (verbose) {
+		printf("sched_fork event %p\n", event);
+		printf("... parent: %s/%d\n", fork_event->parent_comm, fork_event->parent_pid);
+		printf("...  child: %s/%d\n", fork_event->child_comm, fork_event->child_pid);
+	}
+	register_pid(fork_event->parent_pid, fork_event->parent_comm);
+	register_pid(fork_event->child_pid, fork_event->child_comm);
+}
+
+static struct trace_sched_handler replay_ops  = {
+	.wakeup_event		= replay_wakeup_event,
+	.switch_event		= replay_switch_event,
+	.fork_event		= replay_fork_event,
+};
+
+struct sort_dimension {
+	const char		*name;
+	sort_fn_t		cmp;
+	struct list_head	list;
+};
+
+static LIST_HEAD(cmp_pid);
+
+static int
+thread_lat_cmp(struct list_head *list, struct work_atoms *l, struct work_atoms *r)
+{
+	struct sort_dimension *sort;
+	int ret = 0;
+
+	BUG_ON(list_empty(list));
+
+	list_for_each_entry(sort, list, list) {
+		ret = sort->cmp(l, r);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
+static struct work_atoms *
+thread_atoms_search(struct rb_root *root, struct thread *thread,
+			 struct list_head *sort_list)
+{
+	struct rb_node *node = root->rb_node;
+	struct work_atoms key = { .thread = thread };
+
+	while (node) {
+		struct work_atoms *atoms;
+		int cmp;
+
+		atoms = container_of(node, struct work_atoms, node);
+
+		cmp = thread_lat_cmp(sort_list, &key, atoms);
+		if (cmp > 0)
+			node = node->rb_left;
+		else if (cmp < 0)
+			node = node->rb_right;
+		else {
+			BUG_ON(thread != atoms->thread);
+			return atoms;
+		}
+	}
+	return NULL;
+}
+
+static void
+__thread_latency_insert(struct rb_root *root, struct work_atoms *data,
+			 struct list_head *sort_list)
+{
+	struct rb_node **new = &(root->rb_node), *parent = NULL;
+
+	while (*new) {
+		struct work_atoms *this;
+		int cmp;
+
+		this = container_of(*new, struct work_atoms, node);
+		parent = *new;
+
+		cmp = thread_lat_cmp(sort_list, data, this);
+
+		if (cmp > 0)
+			new = &((*new)->rb_left);
+		else
+			new = &((*new)->rb_right);
+	}
+
+	rb_link_node(&data->node, parent, new);
+	rb_insert_color(&data->node, root);
+}
+
+static void thread_atoms_insert(struct thread *thread)
+{
+	struct work_atoms *atoms;
+
+	atoms = calloc(sizeof(*atoms), 1);
+	if (!atoms)
+		die("No memory");
+
+	atoms->thread = thread;
+	INIT_LIST_HEAD(&atoms->work_list);
+	__thread_latency_insert(&atom_root, atoms, &cmp_pid);
+}
+
+static void
+latency_fork_event(struct trace_fork_event *fork_event __used,
+		   struct event *event __used,
+		   int cpu __used,
+		   u64 timestamp __used,
+		   struct thread *thread __used)
+{
+	/* should insert the newcomer */
+}
+
+__used
+static char sched_out_state(struct trace_switch_event *switch_event)
+{
+	const char *str = TASK_STATE_TO_CHAR_STR;
+
+	return str[switch_event->prev_state];
+}
+
+static void
+add_sched_out_event(struct work_atoms *atoms,
+		    char run_state,
+		    u64 timestamp)
+{
+	struct work_atom *atom;
+
+	atom = calloc(sizeof(*atom), 1);
+	if (!atom)
+		die("Non memory");
+
+	atom->sched_out_time = timestamp;
+
+	if (run_state == 'R') {
+		atom->state = THREAD_WAIT_CPU;
+		atom->wake_up_time = atom->sched_out_time;
+	}
+
+	list_add_tail(&atom->list, &atoms->work_list);
+}
+
+static void
+add_runtime_event(struct work_atoms *atoms, u64 delta, u64 timestamp __used)
+{
+	struct work_atom *atom;
+
+	BUG_ON(list_empty(&atoms->work_list));
+
+	atom = list_entry(atoms->work_list.prev, struct work_atom, list);
+
+	atom->runtime += delta;
+	atoms->total_runtime += delta;
+}
+
+static void
+add_sched_in_event(struct work_atoms *atoms, u64 timestamp)
+{
+	struct work_atom *atom;
+	u64 delta;
+
+	if (list_empty(&atoms->work_list))
+		return;
+
+	atom = list_entry(atoms->work_list.prev, struct work_atom, list);
+
+	if (atom->state != THREAD_WAIT_CPU)
+		return;
+
+	if (timestamp < atom->wake_up_time) {
+		atom->state = THREAD_IGNORE;
+		return;
+	}
+
+	atom->state = THREAD_SCHED_IN;
+	atom->sched_in_time = timestamp;
+
+	delta = atom->sched_in_time - atom->wake_up_time;
+	atoms->total_lat += delta;
+	if (delta > atoms->max_lat)
+		atoms->max_lat = delta;
+	atoms->nb_atoms++;
+}
+
+static void
+latency_switch_event(struct trace_switch_event *switch_event,
+		     struct event *event __used,
+		     int cpu,
+		     u64 timestamp,
+		     struct thread *thread __used)
+{
+	struct work_atoms *out_events, *in_events;
+	struct thread *sched_out, *sched_in;
+	u64 timestamp0;
+	s64 delta;
+
+	BUG_ON(cpu >= MAX_CPUS || cpu < 0);
+
+	timestamp0 = cpu_last_switched[cpu];
+	cpu_last_switched[cpu] = timestamp;
+	if (timestamp0)
+		delta = timestamp - timestamp0;
+	else
+		delta = 0;
+
+	if (delta < 0)
+		die("hm, delta: %Ld < 0 ?\n", delta);
+
+
+	sched_out = threads__findnew(switch_event->prev_pid, &threads, &last_match);
+	sched_in = threads__findnew(switch_event->next_pid, &threads, &last_match);
+
+	out_events = thread_atoms_search(&atom_root, sched_out, &cmp_pid);
+	if (!out_events) {
+		thread_atoms_insert(sched_out);
+		out_events = thread_atoms_search(&atom_root, sched_out, &cmp_pid);
+		if (!out_events)
+			die("out-event: Internal tree error");
+	}
+	add_sched_out_event(out_events, sched_out_state(switch_event), timestamp);
+
+	in_events = thread_atoms_search(&atom_root, sched_in, &cmp_pid);
+	if (!in_events) {
+		thread_atoms_insert(sched_in);
+		in_events = thread_atoms_search(&atom_root, sched_in, &cmp_pid);
+		if (!in_events)
+			die("in-event: Internal tree error");
+		/*
+		 * Take came in we have not heard about yet,
+		 * add in an initial atom in runnable state:
+		 */
+		add_sched_out_event(in_events, 'R', timestamp);
+	}
+	add_sched_in_event(in_events, timestamp);
+}
+
+static void
+latency_runtime_event(struct trace_runtime_event *runtime_event,
+		     struct event *event __used,
+		     int cpu,
+		     u64 timestamp,
+		     struct thread *this_thread __used)
+{
+	struct work_atoms *atoms;
+	struct thread *thread;
+
+	BUG_ON(cpu >= MAX_CPUS || cpu < 0);
+
+	thread = threads__findnew(runtime_event->pid, &threads, &last_match);
+	atoms = thread_atoms_search(&atom_root, thread, &cmp_pid);
+	if (!atoms) {
+		thread_atoms_insert(thread);
+		atoms = thread_atoms_search(&atom_root, thread, &cmp_pid);
+		if (!atoms)
+			die("in-event: Internal tree error");
+		add_sched_out_event(atoms, 'R', timestamp);
+	}
+
+	add_runtime_event(atoms, runtime_event->runtime, timestamp);
+}
+
+static void
+latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
+		     struct event *__event __used,
+		     int cpu __used,
+		     u64 timestamp,
+		     struct thread *thread __used)
+{
+	struct work_atoms *atoms;
+	struct work_atom *atom;
+	struct thread *wakee;
+
+	/* Note for later, it may be interesting to observe the failing cases */
+	if (!wakeup_event->success)
+		return;
+
+	wakee = threads__findnew(wakeup_event->pid, &threads, &last_match);
+	atoms = thread_atoms_search(&atom_root, wakee, &cmp_pid);
+	if (!atoms) {
+		thread_atoms_insert(wakee);
+		atoms = thread_atoms_search(&atom_root, wakee, &cmp_pid);
+		if (!atoms)
+			die("wakeup-event: Internal tree error");
+		add_sched_out_event(atoms, 'S', timestamp);
+	}
+
+	BUG_ON(list_empty(&atoms->work_list));
+
+	atom = list_entry(atoms->work_list.prev, struct work_atom, list);
+
+	if (atom->state != THREAD_SLEEPING)
+		nr_state_machine_bugs++;
+
+	nr_timestamps++;
+	if (atom->sched_out_time > timestamp) {
+		nr_unordered_timestamps++;
+		return;
+	}
+
+	atom->state = THREAD_WAIT_CPU;
+	atom->wake_up_time = timestamp;
+}
+
+static struct trace_sched_handler lat_ops  = {
+	.wakeup_event		= latency_wakeup_event,
+	.switch_event		= latency_switch_event,
+	.runtime_event		= latency_runtime_event,
+	.fork_event		= latency_fork_event,
+};
+
+static void output_lat_thread(struct work_atoms *work_list)
+{
+	int i;
+	int ret;
+	u64 avg;
+
+	if (!work_list->nb_atoms)
+		return;
+	/*
+	 * Ignore idle threads:
+	 */
+	if (!strcmp(work_list->thread->comm, "swapper"))
+		return;
+
+	all_runtime += work_list->total_runtime;
+	all_count += work_list->nb_atoms;
+
+	ret = printf("  %s:%d ", work_list->thread->comm, work_list->thread->pid);
+
+	for (i = 0; i < 24 - ret; i++)
+		printf(" ");
+
+	avg = work_list->total_lat / work_list->nb_atoms;
+
+	printf("|%11.3f ms |%9llu | avg:%9.3f ms | max:%9.3f ms |\n",
+	      (double)work_list->total_runtime / 1e6,
+		 work_list->nb_atoms, (double)avg / 1e6,
+		 (double)work_list->max_lat / 1e6);
+}
+
+static int pid_cmp(struct work_atoms *l, struct work_atoms *r)
+{
+	if (l->thread->pid < r->thread->pid)
+		return -1;
+	if (l->thread->pid > r->thread->pid)
+		return 1;
+
+	return 0;
+}
+
+static struct sort_dimension pid_sort_dimension = {
+	.name			= "pid",
+	.cmp			= pid_cmp,
+};
+
+static int avg_cmp(struct work_atoms *l, struct work_atoms *r)
+{
+	u64 avgl, avgr;
+
+	if (!l->nb_atoms)
+		return -1;
+
+	if (!r->nb_atoms)
+		return 1;
+
+	avgl = l->total_lat / l->nb_atoms;
+	avgr = r->total_lat / r->nb_atoms;
+
+	if (avgl < avgr)
+		return -1;
+	if (avgl > avgr)
+		return 1;
+
+	return 0;
+}
+
+static struct sort_dimension avg_sort_dimension = {
+	.name			= "avg",
+	.cmp			= avg_cmp,
+};
+
+static int max_cmp(struct work_atoms *l, struct work_atoms *r)
+{
+	if (l->max_lat < r->max_lat)
+		return -1;
+	if (l->max_lat > r->max_lat)
+		return 1;
+
+	return 0;
+}
+
+static struct sort_dimension max_sort_dimension = {
+	.name			= "max",
+	.cmp			= max_cmp,
+};
+
+static int switch_cmp(struct work_atoms *l, struct work_atoms *r)
+{
+	if (l->nb_atoms < r->nb_atoms)
+		return -1;
+	if (l->nb_atoms > r->nb_atoms)
+		return 1;
+
+	return 0;
+}
+
+static struct sort_dimension switch_sort_dimension = {
+	.name			= "switch",
+	.cmp			= switch_cmp,
+};
+
+static int runtime_cmp(struct work_atoms *l, struct work_atoms *r)
+{
+	if (l->total_runtime < r->total_runtime)
+		return -1;
+	if (l->total_runtime > r->total_runtime)
+		return 1;
+
+	return 0;
+}
+
+static struct sort_dimension runtime_sort_dimension = {
+	.name			= "runtime",
+	.cmp			= runtime_cmp,
+};
+
+static struct sort_dimension *available_sorts[] = {
+	&pid_sort_dimension,
+	&avg_sort_dimension,
+	&max_sort_dimension,
+	&switch_sort_dimension,
+	&runtime_sort_dimension,
+};
+
+#define NB_AVAILABLE_SORTS	(int)(sizeof(available_sorts) / sizeof(struct sort_dimension *))
+
+static LIST_HEAD(sort_list);
+
+static int sort_dimension__add(char *tok, struct list_head *list)
+{
+	int i;
+
+	for (i = 0; i < NB_AVAILABLE_SORTS; i++) {
+		if (!strcmp(available_sorts[i]->name, tok)) {
+			list_add_tail(&available_sorts[i]->list, list);
+
+			return 0;
+		}
+	}
+
+	return -1;
+}
+
+static void setup_sorting(void);
+
+static void sort_lat(void)
+{
+	struct rb_node *node;
+
+	for (;;) {
+		struct work_atoms *data;
+		node = rb_first(&atom_root);
+		if (!node)
+			break;
+
+		rb_erase(node, &atom_root);
+		data = rb_entry(node, struct work_atoms, node);
+		__thread_latency_insert(&sorted_atom_root, data, &sort_list);
+	}
+}
+
+static struct trace_sched_handler *trace_handler;
+
+static void
+process_sched_wakeup_event(struct raw_event_sample *raw,
+			   struct event *event,
+			   int cpu __used,
+			   u64 timestamp __used,
+			   struct thread *thread __used)
+{
+	struct trace_wakeup_event wakeup_event;
+
+	FILL_COMMON_FIELDS(wakeup_event, event, raw->data);
+
+	FILL_ARRAY(wakeup_event, comm, event, raw->data);
+	FILL_FIELD(wakeup_event, pid, event, raw->data);
+	FILL_FIELD(wakeup_event, prio, event, raw->data);
+	FILL_FIELD(wakeup_event, success, event, raw->data);
+	FILL_FIELD(wakeup_event, cpu, event, raw->data);
+
+	if (trace_handler->wakeup_event)
+		trace_handler->wakeup_event(&wakeup_event, event, cpu, timestamp, thread);
+}
+
+/*
+ * Track the current task - that way we can know whether there's any
+ * weird events, such as a task being switched away that is not current.
+ */
+static int max_cpu;
+
+static u32 curr_pid[MAX_CPUS] = { [0 ... MAX_CPUS-1] = -1 };
+
+static struct thread *curr_thread[MAX_CPUS];
+
+static char next_shortname1 = 'A';
+static char next_shortname2 = '0';
+
+static void
+map_switch_event(struct trace_switch_event *switch_event,
+		 struct event *event __used,
+		 int this_cpu,
+		 u64 timestamp,
+		 struct thread *thread __used)
+{
+	struct thread *sched_out, *sched_in;
+	int new_shortname;
+	u64 timestamp0;
+	s64 delta;
+	int cpu;
+
+	BUG_ON(this_cpu >= MAX_CPUS || this_cpu < 0);
+
+	if (this_cpu > max_cpu)
+		max_cpu = this_cpu;
+
+	timestamp0 = cpu_last_switched[this_cpu];
+	cpu_last_switched[this_cpu] = timestamp;
+	if (timestamp0)
+		delta = timestamp - timestamp0;
+	else
+		delta = 0;
+
+	if (delta < 0)
+		die("hm, delta: %Ld < 0 ?\n", delta);
+
+
+	sched_out = threads__findnew(switch_event->prev_pid, &threads, &last_match);
+	sched_in = threads__findnew(switch_event->next_pid, &threads, &last_match);
+
+	curr_thread[this_cpu] = sched_in;
+
+	printf("  ");
+
+	new_shortname = 0;
+	if (!sched_in->shortname[0]) {
+		sched_in->shortname[0] = next_shortname1;
+		sched_in->shortname[1] = next_shortname2;
+
+		if (next_shortname1 < 'Z') {
+			next_shortname1++;
+		} else {
+			next_shortname1='A';
+			if (next_shortname2 < '9') {
+				next_shortname2++;
+			} else {
+				next_shortname2='0';
+			}
+		}
+		new_shortname = 1;
+	}
+
+	for (cpu = 0; cpu <= max_cpu; cpu++) {
+		if (cpu != this_cpu)
+			printf(" ");
+		else
+			printf("*");
+
+		if (curr_thread[cpu]) {
+			if (curr_thread[cpu]->pid)
+				printf("%2s ", curr_thread[cpu]->shortname);
+			else
+				printf(".  ");
+		} else
+			printf("   ");
+	}
+
+	printf("  %12.6f secs ", (double)timestamp/1e9);
+	if (new_shortname) {
+		printf("%s => %s:%d\n",
+			sched_in->shortname, sched_in->comm, sched_in->pid);
+	} else {
+		printf("\n");
+	}
+}
+
+
+static void
+process_sched_switch_event(struct raw_event_sample *raw,
+			   struct event *event,
+			   int this_cpu,
+			   u64 timestamp __used,
+			   struct thread *thread __used)
+{
+	struct trace_switch_event switch_event;
+
+	FILL_COMMON_FIELDS(switch_event, event, raw->data);
+
+	FILL_ARRAY(switch_event, prev_comm, event, raw->data);
+	FILL_FIELD(switch_event, prev_pid, event, raw->data);
+	FILL_FIELD(switch_event, prev_prio, event, raw->data);
+	FILL_FIELD(switch_event, prev_state, event, raw->data);
+	FILL_ARRAY(switch_event, next_comm, event, raw->data);
+	FILL_FIELD(switch_event, next_pid, event, raw->data);
+	FILL_FIELD(switch_event, next_prio, event, raw->data);
+
+	if (curr_pid[this_cpu] != (u32)-1) {
+		/*
+		 * Are we trying to switch away a PID that is
+		 * not current?
+		 */
+		if (curr_pid[this_cpu] != switch_event.prev_pid)
+			nr_context_switch_bugs++;
+	}
+	if (trace_handler->switch_event)
+		trace_handler->switch_event(&switch_event, event, this_cpu, timestamp, thread);
+
+	curr_pid[this_cpu] = switch_event.next_pid;
+}
+
+static void
+process_sched_runtime_event(struct raw_event_sample *raw,
+			   struct event *event,
+			   int cpu __used,
+			   u64 timestamp __used,
+			   struct thread *thread __used)
+{
+	struct trace_runtime_event runtime_event;
+
+	FILL_ARRAY(runtime_event, comm, event, raw->data);
+	FILL_FIELD(runtime_event, pid, event, raw->data);
+	FILL_FIELD(runtime_event, runtime, event, raw->data);
+	FILL_FIELD(runtime_event, vruntime, event, raw->data);
+
+	if (trace_handler->runtime_event)
+		trace_handler->runtime_event(&runtime_event, event, cpu, timestamp, thread);
+}
+
+static void
+process_sched_fork_event(struct raw_event_sample *raw,
+			 struct event *event,
+			 int cpu __used,
+			 u64 timestamp __used,
+			 struct thread *thread __used)
+{
+	struct trace_fork_event fork_event;
+
+	FILL_COMMON_FIELDS(fork_event, event, raw->data);
+
+	FILL_ARRAY(fork_event, parent_comm, event, raw->data);
+	FILL_FIELD(fork_event, parent_pid, event, raw->data);
+	FILL_ARRAY(fork_event, child_comm, event, raw->data);
+	FILL_FIELD(fork_event, child_pid, event, raw->data);
+
+	if (trace_handler->fork_event)
+		trace_handler->fork_event(&fork_event, event, cpu, timestamp, thread);
+}
+
+static void
+process_sched_exit_event(struct event *event,
+			 int cpu __used,
+			 u64 timestamp __used,
+			 struct thread *thread __used)
+{
+	if (verbose)
+		printf("sched_exit event %p\n", event);
+}
+
+static void
+process_raw_event(event_t *raw_event __used, void *more_data,
+		  int cpu, u64 timestamp, struct thread *thread)
+{
+	struct raw_event_sample *raw = more_data;
+	struct event *event;
+	int type;
+
+	type = trace_parse_common_type(raw->data);
+	event = trace_find_event(type);
+
+	if (!strcmp(event->name, "sched_switch"))
+		process_sched_switch_event(raw, event, cpu, timestamp, thread);
+	if (!strcmp(event->name, "sched_stat_runtime"))
+		process_sched_runtime_event(raw, event, cpu, timestamp, thread);
+	if (!strcmp(event->name, "sched_wakeup"))
+		process_sched_wakeup_event(raw, event, cpu, timestamp, thread);
+	if (!strcmp(event->name, "sched_wakeup_new"))
+		process_sched_wakeup_event(raw, event, cpu, timestamp, thread);
+	if (!strcmp(event->name, "sched_process_fork"))
+		process_sched_fork_event(raw, event, cpu, timestamp, thread);
+	if (!strcmp(event->name, "sched_process_exit"))
+		process_sched_exit_event(event, cpu, timestamp, thread);
+}
+
+static int
+process_sample_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	char level;
+	int show = 0;
+	struct dso *dso = NULL;
+	struct thread *thread;
+	u64 ip = event->ip.ip;
+	u64 timestamp = -1;
+	u32 cpu = -1;
+	u64 period = 1;
+	void *more_data = event->ip.__more_data;
+	int cpumode;
+
+	thread = threads__findnew(event->ip.pid, &threads, &last_match);
+
+	if (sample_type & PERF_SAMPLE_TIME) {
+		timestamp = *(u64 *)more_data;
+		more_data += sizeof(u64);
+	}
+
+	if (sample_type & PERF_SAMPLE_CPU) {
+		cpu = *(u32 *)more_data;
+		more_data += sizeof(u32);
+		more_data += sizeof(u32); /* reserved */
+	}
+
+	if (sample_type & PERF_SAMPLE_PERIOD) {
+		period = *(u64 *)more_data;
+		more_data += sizeof(u64);
+	}
+
+	dump_printf("%p [%p]: PERF_EVENT_SAMPLE (IP, %d): %d/%d: %p period: %Ld\n",
+		(void *)(offset + head),
+		(void *)(long)(event->header.size),
+		event->header.misc,
+		event->ip.pid, event->ip.tid,
+		(void *)(long)ip,
+		(long long)period);
+
+	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
+
+	if (thread == NULL) {
+		eprintf("problem processing %d event, skipping it.\n",
+			event->header.type);
+		return -1;
+	}
+
+	cpumode = event->header.misc & PERF_EVENT_MISC_CPUMODE_MASK;
+
+	if (cpumode == PERF_EVENT_MISC_KERNEL) {
+		show = SHOW_KERNEL;
+		level = 'k';
+
+		dso = kernel_dso;
+
+		dump_printf(" ...... dso: %s\n", dso->name);
+
+	} else if (cpumode == PERF_EVENT_MISC_USER) {
+
+		show = SHOW_USER;
+		level = '.';
+
+	} else {
+		show = SHOW_HV;
+		level = 'H';
+
+		dso = hypervisor_dso;
+
+		dump_printf(" ...... dso: [hypervisor]\n");
+	}
+
+	if (sample_type & PERF_SAMPLE_RAW)
+		process_raw_event(event, more_data, cpu, timestamp, thread);
+
+	return 0;
+}
+
+static int
+process_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	trace_event(event);
+
+	nr_events++;
+	switch (event->header.type) {
+	case PERF_EVENT_MMAP:
+		return 0;
+	case PERF_EVENT_LOST:
+		nr_lost_chunks++;
+		nr_lost_events += event->lost.lost;
+		return 0;
+
+	case PERF_EVENT_COMM:
+		return process_comm_event(event, offset, head);
+
+	case PERF_EVENT_EXIT ... PERF_EVENT_READ:
+		return 0;
+
+	case PERF_EVENT_SAMPLE:
+		return process_sample_event(event, offset, head);
+
+	case PERF_EVENT_MAX:
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+static int read_events(void)
+{
+	int ret, rc = EXIT_FAILURE;
+	unsigned long offset = 0;
+	unsigned long head = 0;
+	struct stat perf_stat;
+	event_t *event;
+	uint32_t size;
+	char *buf;
+
+	trace_report();
+	register_idle_thread(&threads, &last_match);
+
+	input = open(input_name, O_RDONLY);
+	if (input < 0) {
+		perror("failed to open file");
+		exit(-1);
+	}
+
+	ret = fstat(input, &perf_stat);
+	if (ret < 0) {
+		perror("failed to stat file");
+		exit(-1);
+	}
+
+	if (!perf_stat.st_size) {
+		fprintf(stderr, "zero-sized file, nothing to do!\n");
+		exit(0);
+	}
+	header = perf_header__read(input);
+	head = header->data_offset;
+	sample_type = perf_header__sample_type(header);
+
+	if (!(sample_type & PERF_SAMPLE_RAW))
+		die("No trace sample to read. Did you call perf record "
+		    "without -R?");
+
+	if (load_kernel() < 0) {
+		perror("failed to load kernel symbols");
+		return EXIT_FAILURE;
+	}
+
+remap:
+	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
+			   MAP_SHARED, input, offset);
+	if (buf == MAP_FAILED) {
+		perror("failed to mmap file");
+		exit(-1);
+	}
+
+more:
+	event = (event_t *)(buf + head);
+
+	size = event->header.size;
+	if (!size)
+		size = 8;
+
+	if (head + event->header.size >= page_size * mmap_window) {
+		unsigned long shift = page_size * (head / page_size);
+		int res;
+
+		res = munmap(buf, page_size * mmap_window);
+		assert(res == 0);
+
+		offset += shift;
+		head -= shift;
+		goto remap;
+	}
+
+	size = event->header.size;
+
+
+	if (!size || process_event(event, offset, head) < 0) {
+
+		/*
+		 * assume we lost track of the stream, check alignment, and
+		 * increment a single u64 in the hope to catch on again 'soon'.
+		 */
+
+		if (unlikely(head & 7))
+			head &= ~7ULL;
+
+		size = 8;
+	}
+
+	head += size;
+
+	if (offset + head < (unsigned long)perf_stat.st_size)
+		goto more;
+
+	rc = EXIT_SUCCESS;
+	close(input);
+
+	return rc;
+}
+
+static void print_bad_events(void)
+{
+	if (nr_unordered_timestamps && nr_timestamps) {
+		printf("  INFO: %.3f%% unordered timestamps (%ld out of %ld)\n",
+			(double)nr_unordered_timestamps/(double)nr_timestamps*100.0,
+			nr_unordered_timestamps, nr_timestamps);
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
+		printf("\n");
+	}
+	if (nr_context_switch_bugs && nr_timestamps) {
+		printf("  INFO: %.3f%% context switch bugs (%ld out of %ld)",
+			(double)nr_context_switch_bugs/(double)nr_timestamps*100.0,
+			nr_context_switch_bugs, nr_timestamps);
+		if (nr_lost_events)
+			printf(" (due to lost events?)");
+		printf("\n");
+	}
+}
+
+static void __cmd_lat(void)
+{
+	struct rb_node *next;
+
+	setup_pager();
+	read_events();
+	sort_lat();
+
+	printf("\n -----------------------------------------------------------------------------------------\n");
+	printf("  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms |\n");
+	printf(" -----------------------------------------------------------------------------------------\n");
+
+	next = rb_first(&sorted_atom_root);
+
+	while (next) {
+		struct work_atoms *work_list;
+
+		work_list = rb_entry(next, struct work_atoms, node);
+		output_lat_thread(work_list);
+		next = rb_next(next);
+	}
+
+	printf(" -----------------------------------------------------------------------------------------\n");
+	printf("  TOTAL:                |%11.3f ms |%9Ld |\n",
+		(double)all_runtime/1e6, all_count);
+
+	printf(" ---------------------------------------------------\n");
+
+	print_bad_events();
+	printf("\n");
+
+}
+
+static struct trace_sched_handler map_ops  = {
+	.wakeup_event		= NULL,
+	.switch_event		= map_switch_event,
+	.runtime_event		= NULL,
+	.fork_event		= NULL,
+};
+
+static void __cmd_map(void)
+{
+	max_cpu = sysconf(_SC_NPROCESSORS_CONF);
+
+	setup_pager();
+	read_events();
+	print_bad_events();
+}
+
+static void __cmd_replay(void)
+{
+	unsigned long i;
+
+	calibrate_run_measurement_overhead();
+	calibrate_sleep_measurement_overhead();
+
+	test_calibrations();
+
+	read_events();
+
+	printf("nr_run_events:        %ld\n", nr_run_events);
+	printf("nr_sleep_events:      %ld\n", nr_sleep_events);
+	printf("nr_wakeup_events:     %ld\n", nr_wakeup_events);
+
+	if (targetless_wakeups)
+		printf("target-less wakeups:  %ld\n", targetless_wakeups);
+	if (multitarget_wakeups)
+		printf("multi-target wakeups: %ld\n", multitarget_wakeups);
+	if (nr_run_events_optimized)
+		printf("run atoms optimized: %ld\n",
+			nr_run_events_optimized);
+
+	print_task_traces();
+	add_cross_task_wakeups();
+
+	create_tasks();
+	printf("------------------------------------------------------------\n");
+	for (i = 0; i < replay_repeat; i++)
+		run_one_test();
+}
+
+
+static const char * const sched_usage[] = {
+	"perf sched [<options>] {record|latency|replay|trace}",
+	NULL
+};
+
+static const struct option sched_options[] = {
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_END()
+};
+
+static const char * const latency_usage[] = {
+	"perf sched latency [<options>]",
+	NULL
+};
+
+static const struct option latency_options[] = {
+	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
+		   "sort by key(s): runtime, switch, avg, max"),
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_END()
+};
+
+static const char * const replay_usage[] = {
+	"perf sched replay [<options>]",
+	NULL
+};
+
+static const struct option replay_options[] = {
+	OPT_INTEGER('r', "repeat", &replay_repeat,
+		    "repeat the workload replay N times (-1: infinite)"),
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_END()
+};
+
+static void setup_sorting(void)
+{
+	char *tmp, *tok, *str = strdup(sort_order);
+
+	for (tok = strtok_r(str, ", ", &tmp);
+			tok; tok = strtok_r(NULL, ", ", &tmp)) {
+		if (sort_dimension__add(tok, &sort_list) < 0) {
+			error("Unknown --sort key: `%s'", tok);
+			usage_with_options(latency_usage, latency_options);
+		}
+	}
+
+	free(str);
+
+	sort_dimension__add((char *)"pid", &cmp_pid);
+}
+
+static const char *record_args[] = {
+	"record",
+	"-a",
+	"-R",
+	"-M",
+	"-f",
+	"-m", "1024",
+	"-c", "1",
+	"-e", "sched:sched_switch:r",
+	"-e", "sched:sched_stat_wait:r",
+	"-e", "sched:sched_stat_sleep:r",
+	"-e", "sched:sched_stat_iowait:r",
+	"-e", "sched:sched_stat_runtime:r",
+	"-e", "sched:sched_process_exit:r",
+	"-e", "sched:sched_process_fork:r",
+	"-e", "sched:sched_wakeup:r",
+	"-e", "sched:sched_migrate_task:r",
+};
+
+static int __cmd_record(int argc, const char **argv)
+{
+	unsigned int rec_argc, i, j;
+	const char **rec_argv;
+
+	rec_argc = ARRAY_SIZE(record_args) + argc - 1;
+	rec_argv = calloc(rec_argc + 1, sizeof(char *));
+
+	for (i = 0; i < ARRAY_SIZE(record_args); i++)
+		rec_argv[i] = strdup(record_args[i]);
+
+	for (j = 1; j < (unsigned int)argc; j++, i++)
+		rec_argv[i] = argv[j];
+
+	BUG_ON(i != rec_argc);
+
+	return cmd_record(i, rec_argv, NULL);
+}
+
+int cmd_sched(int argc, const char **argv, const char *prefix __used)
+{
+	symbol__init();
+	page_size = getpagesize();
+
+	argc = parse_options(argc, argv, sched_options, sched_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+	if (!argc)
+		usage_with_options(sched_usage, sched_options);
+
+	if (!strncmp(argv[0], "rec", 3)) {
+		return __cmd_record(argc, argv);
+	} else if (!strncmp(argv[0], "lat", 3)) {
+		trace_handler = &lat_ops;
+		if (argc > 1) {
+			argc = parse_options(argc, argv, latency_options, latency_usage, 0);
+			if (argc)
+				usage_with_options(latency_usage, latency_options);
+		}
+		setup_sorting();
+		__cmd_lat();
+	} else if (!strcmp(argv[0], "map")) {
+		trace_handler = &map_ops;
+		setup_sorting();
+		__cmd_map();
+	} else if (!strncmp(argv[0], "rep", 3)) {
+		trace_handler = &replay_ops;
+		if (argc) {
+			argc = parse_options(argc, argv, replay_options, replay_usage, 0);
+			if (argc)
+				usage_with_options(replay_usage, replay_options);
+		}
+		__cmd_replay();
+	} else if (!strcmp(argv[0], "trace")) {
+		/*
+		 * Aliased to 'perf trace' for now:
+		 */
+		return cmd_trace(argc, argv, prefix);
+	} else {
+		usage_with_options(sched_usage, sched_options);
+	}
+
+	return 0;
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index 3a63e41..b09cadb 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -16,12 +16,13 @@ extern int check_pager_config(const char *cmd);
 
 extern int cmd_annotate(int argc, const char **argv, const char *prefix);
 extern int cmd_help(int argc, const char **argv, const char *prefix);
+extern int cmd_sched(int argc, const char **argv, const char *prefix);
+extern int cmd_list(int argc, const char **argv, const char *prefix);
 extern int cmd_record(int argc, const char **argv, const char *prefix);
 extern int cmd_report(int argc, const char **argv, const char *prefix);
 extern int cmd_stat(int argc, const char **argv, const char *prefix);
 extern int cmd_top(int argc, const char **argv, const char *prefix);
-extern int cmd_version(int argc, const char **argv, const char *prefix);
-extern int cmd_list(int argc, const char **argv, const char *prefix);
 extern int cmd_trace(int argc, const char **argv, const char *prefix);
+extern int cmd_version(int argc, const char **argv, const char *prefix);
 
 #endif
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index eebce30..3133c74 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -4,7 +4,9 @@
 #
 perf-annotate			mainporcelain common
 perf-list			mainporcelain common
+perf-sched			mainporcelain common
 perf-record			mainporcelain common
 perf-report			mainporcelain common
 perf-stat			mainporcelain common
 perf-top			mainporcelain common
+perf-trace			mainporcelain common
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index fe4589d..c972d1c 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -293,6 +293,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "annotate", cmd_annotate, 0 },
 		{ "version", cmd_version, 0 },
 		{ "trace", cmd_trace, 0 },
+		{ "sched", cmd_sched, 0 },
 	};
 	unsigned int i;
 	static const char ext[] = STRIP_EXTENSION;
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
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index a587d41..034245e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -18,6 +18,12 @@ struct event_symbol {
 	const char	*alias;
 };
 
+enum event_result {
+	EVT_FAILED,
+	EVT_HANDLED,
+	EVT_HANDLED_ALL
+};
+
 char debugfs_path[MAXPATHLEN];
 
 #define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
@@ -344,7 +350,7 @@ static int parse_aliases(const char **str, const char *names[][MAX_ALIASES], int
 	return -1;
 }
 
-static int
+static enum event_result
 parse_generic_hw_event(const char **str, struct perf_counter_attr *attr)
 {
 	const char *s = *str;
@@ -356,7 +362,7 @@ parse_generic_hw_event(const char **str, struct perf_counter_attr *attr)
 	 * then bail out:
 	 */
 	if (cache_type == -1)
-		return 0;
+		return EVT_FAILED;
 
 	while ((cache_op == -1 || cache_result == -1) && *s == '-') {
 		++s;
@@ -402,27 +408,112 @@ parse_generic_hw_event(const char **str, struct perf_counter_attr *attr)
 	attr->type = PERF_TYPE_HW_CACHE;
 
 	*str = s;
-	return 1;
+	return EVT_HANDLED;
+}
+
+static enum event_result
+parse_single_tracepoint_event(char *sys_name,
+			      const char *evt_name,
+			      unsigned int evt_length,
+			      char *flags,
+			      struct perf_counter_attr *attr,
+			      const char **strp)
+{
+	char evt_path[MAXPATHLEN];
+	char id_buf[4];
+	u64 id;
+	int fd;
+
+	if (flags) {
+		if (!strncmp(flags, "record", strlen(flags)))
+			attr->sample_type |= PERF_SAMPLE_RAW;
+	}
+
+	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
+		 sys_name, evt_name);
+
+	fd = open(evt_path, O_RDONLY);
+	if (fd < 0)
+		return EVT_FAILED;
+
+	if (read(fd, id_buf, sizeof(id_buf)) < 0) {
+		close(fd);
+		return EVT_FAILED;
+	}
+
+	close(fd);
+	id = atoll(id_buf);
+	attr->config = id;
+	attr->type = PERF_TYPE_TRACEPOINT;
+	*strp = evt_name + evt_length;
+
+	return EVT_HANDLED;
 }
 
-static int parse_tracepoint_event(const char **strp,
+/* sys + ':' + event + ':' + flags*/
+#define MAX_EVOPT_LEN	(MAX_EVENT_LENGTH * 2 + 2 + 128)
+static enum event_result
+parse_subsystem_tracepoint_event(char *sys_name, char *flags)
+{
+	char evt_path[MAXPATHLEN];
+	struct dirent *evt_ent;
+	DIR *evt_dir;
+
+	snprintf(evt_path, MAXPATHLEN, "%s/%s", debugfs_path, sys_name);
+	evt_dir = opendir(evt_path);
+
+	if (!evt_dir) {
+		perror("Can't open event dir");
+		return EVT_FAILED;
+	}
+
+	while ((evt_ent = readdir(evt_dir))) {
+		char event_opt[MAX_EVOPT_LEN + 1];
+		int len;
+		unsigned int rem = MAX_EVOPT_LEN;
+
+		if (!strcmp(evt_ent->d_name, ".")
+		    || !strcmp(evt_ent->d_name, "..")
+		    || !strcmp(evt_ent->d_name, "enable")
+		    || !strcmp(evt_ent->d_name, "filter"))
+			continue;
+
+		len = snprintf(event_opt, MAX_EVOPT_LEN, "%s:%s", sys_name,
+			       evt_ent->d_name);
+		if (len < 0)
+			return EVT_FAILED;
+
+		rem -= len;
+		if (flags) {
+			if (rem < strlen(flags) + 1)
+				return EVT_FAILED;
+
+			strcat(event_opt, ":");
+			strcat(event_opt, flags);
+		}
+
+		if (parse_events(NULL, event_opt, 0))
+			return EVT_FAILED;
+	}
+
+	return EVT_HANDLED_ALL;
+}
+
+
+static enum event_result parse_tracepoint_event(const char **strp,
 				    struct perf_counter_attr *attr)
 {
 	const char *evt_name;
 	char *flags;
 	char sys_name[MAX_EVENT_LENGTH];
-	char id_buf[4];
-	int fd;
 	unsigned int sys_length, evt_length;
-	u64 id;
-	char evt_path[MAXPATHLEN];
 
 	if (valid_debugfs_mount(debugfs_path))
 		return 0;
 
 	evt_name = strchr(*strp, ':');
 	if (!evt_name)
-		return 0;
+		return EVT_FAILED;
 
 	sys_length = evt_name - *strp;
 	if (sys_length >= MAX_EVENT_LENGTH)
@@ -434,32 +525,22 @@ static int parse_tracepoint_event(const char **strp,
 
 	flags = strchr(evt_name, ':');
 	if (flags) {
-		*flags = '\0';
+		/* split it out: */
+		evt_name = strndup(evt_name, flags - evt_name);
 		flags++;
-		if (!strncmp(flags, "record", strlen(flags)))
-			attr->sample_type |= PERF_SAMPLE_RAW;
 	}
 
 	evt_length = strlen(evt_name);
 	if (evt_length >= MAX_EVENT_LENGTH)
-		return 0;
+		return EVT_FAILED;
 
-	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
-		 sys_name, evt_name);
-	fd = open(evt_path, O_RDONLY);
-	if (fd < 0)
-		return 0;
-
-	if (read(fd, id_buf, sizeof(id_buf)) < 0) {
-		close(fd);
-		return 0;
-	}
-	close(fd);
-	id = atoll(id_buf);
-	attr->config = id;
-	attr->type = PERF_TYPE_TRACEPOINT;
-	*strp = evt_name + evt_length;
-	return 1;
+	if (!strcmp(evt_name, "*")) {
+		*strp = evt_name + evt_length;
+		return parse_subsystem_tracepoint_event(sys_name, flags);
+	} else
+		return parse_single_tracepoint_event(sys_name, evt_name,
+						     evt_length, flags,
+						     attr, strp);
 }
 
 static int check_events(const char *str, unsigned int i)
@@ -477,7 +558,7 @@ static int check_events(const char *str, unsigned int i)
 	return 0;
 }
 
-static int
+static enum event_result
 parse_symbolic_event(const char **strp, struct perf_counter_attr *attr)
 {
 	const char *str = *strp;
@@ -490,31 +571,32 @@ parse_symbolic_event(const char **strp, struct perf_counter_attr *attr)
 			attr->type = event_symbols[i].type;
 			attr->config = event_symbols[i].config;
 			*strp = str + n;
-			return 1;
+			return EVT_HANDLED;
 		}
 	}
-	return 0;
+	return EVT_FAILED;
 }
 
-static int parse_raw_event(const char **strp, struct perf_counter_attr *attr)
+static enum event_result
+parse_raw_event(const char **strp, struct perf_counter_attr *attr)
 {
 	const char *str = *strp;
 	u64 config;
 	int n;
 
 	if (*str != 'r')
-		return 0;
+		return EVT_FAILED;
 	n = hex2u64(str + 1, &config);
 	if (n > 0) {
 		*strp = str + n + 1;
 		attr->type = PERF_TYPE_RAW;
 		attr->config = config;
-		return 1;
+		return EVT_HANDLED;
 	}
-	return 0;
+	return EVT_FAILED;
 }
 
-static int
+static enum event_result
 parse_numeric_event(const char **strp, struct perf_counter_attr *attr)
 {
 	const char *str = *strp;
@@ -530,13 +612,13 @@ parse_numeric_event(const char **strp, struct perf_counter_attr *attr)
 			attr->type = type;
 			attr->config = config;
 			*strp = endp;
-			return 1;
+			return EVT_HANDLED;
 		}
 	}
-	return 0;
+	return EVT_FAILED;
 }
 
-static int
+static enum event_result
 parse_event_modifier(const char **strp, struct perf_counter_attr *attr)
 {
 	const char *str = *strp;
@@ -569,37 +651,60 @@ parse_event_modifier(const char **strp, struct perf_counter_attr *attr)
  * Each event can have multiple symbolic names.
  * Symbolic names are (almost) exactly matched.
  */
-static int parse_event_symbols(const char **str, struct perf_counter_attr *attr)
+static enum event_result
+parse_event_symbols(const char **str, struct perf_counter_attr *attr)
 {
-	if (!(parse_tracepoint_event(str, attr) ||
-	      parse_raw_event(str, attr) ||
-	      parse_numeric_event(str, attr) ||
-	      parse_symbolic_event(str, attr) ||
-	      parse_generic_hw_event(str, attr)))
-		return 0;
+	enum event_result ret;
+
+	ret = parse_tracepoint_event(str, attr);
+	if (ret != EVT_FAILED)
+		goto modifier;
+
+	ret = parse_raw_event(str, attr);
+	if (ret != EVT_FAILED)
+		goto modifier;
 
+	ret = parse_numeric_event(str, attr);
+	if (ret != EVT_FAILED)
+		goto modifier;
+
+	ret = parse_symbolic_event(str, attr);
+	if (ret != EVT_FAILED)
+		goto modifier;
+
+	ret = parse_generic_hw_event(str, attr);
+	if (ret != EVT_FAILED)
+		goto modifier;
+
+	return EVT_FAILED;
+
+modifier:
 	parse_event_modifier(str, attr);
 
-	return 1;
+	return ret;
 }
 
 int parse_events(const struct option *opt __used, const char *str, int unset __used)
 {
 	struct perf_counter_attr attr;
+	enum event_result ret;
 
 	for (;;) {
 		if (nr_counters == MAX_COUNTERS)
 			return -1;
 
 		memset(&attr, 0, sizeof(attr));
-		if (!parse_event_symbols(&str, &attr))
+		ret = parse_event_symbols(&str, &attr);
+		if (ret == EVT_FAILED)
 			return -1;
 
 		if (!(*str == 0 || *str == ',' || isspace(*str)))
 			return -1;
 
-		attrs[nr_counters] = attr;
-		nr_counters++;
+		if (ret != EVT_HANDLED_ALL) {
+			attrs[nr_counters] = attr;
+			nr_counters++;
+		}
 
 		if (*str == 0)
 			break;
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 7635928..45efb5d 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -8,7 +8,7 @@
 
 static struct thread *thread__new(pid_t pid)
 {
-	struct thread *self = malloc(sizeof(*self));
+	struct thread *self = calloc(1, sizeof(*self));
 
 	if (self != NULL) {
 		self->pid = pid;
@@ -85,7 +85,7 @@ register_idle_thread(struct rb_root *threads, struct thread **last_match)
 {
 	struct thread *thread = threads__findnew(0, threads, last_match);
 
-	if (!thread || thread__set_comm(thread, "[init]")) {
+	if (!thread || thread__set_comm(thread, "swapper")) {
 		fprintf(stderr, "problem inserting idle task.\n");
 		exit(-1);
 	}
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 634f280..32aea3c 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -4,10 +4,11 @@
 #include "symbol.h"
 
 struct thread {
-	struct rb_node	 rb_node;
-	struct list_head maps;
-	pid_t		 pid;
-	char		 *comm;
+	struct rb_node		rb_node;
+	struct list_head	maps;
+	pid_t			pid;
+	char			shortname[3];
+	char			*comm;
 };
 
 int thread__set_comm(struct thread *self, const char *comm);
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 629e602..f6a8437 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1776,6 +1776,29 @@ static unsigned long long read_size(void *ptr, int size)
 	}
 }
 
+unsigned long long
+raw_field_value(struct event *event, const char *name, void *data)
+{
+	struct format_field *field;
+
+	field = find_any_field(event, name);
+	if (!field)
+		return 0ULL;
+
+	return read_size(data + field->offset, field->size);
+}
+
+void *raw_field_ptr(struct event *event, const char *name, void *data)
+{
+	struct format_field *field;
+
+	field = find_any_field(event, name);
+	if (!field)
+		return NULL;
+
+	return data + field->offset;
+}
+
 static int get_common_info(const char *type, int *offset, int *size)
 {
 	struct event *event;
@@ -1799,7 +1822,7 @@ static int get_common_info(const char *type, int *offset, int *size)
 	return 0;
 }
 
-static int parse_common_type(void *data)
+int trace_parse_common_type(void *data)
 {
 	static int type_offset;
 	static int type_size;
@@ -1832,7 +1855,7 @@ static int parse_common_pid(void *data)
 	return read_size(data + pid_offset, pid_size);
 }
 
-static struct event *find_event(int id)
+struct event *trace_find_event(int id)
 {
 	struct event *event;
 
@@ -2420,8 +2443,8 @@ get_return_for_leaf(int cpu, int cur_pid, unsigned long long cur_func,
 	int type;
 	int pid;
 
-	type = parse_common_type(next->data);
-	event = find_event(type);
+	type = trace_parse_common_type(next->data);
+	event = trace_find_event(type);
 	if (!event)
 		return NULL;
 
@@ -2502,8 +2525,8 @@ print_graph_entry_leaf(struct event *event, void *data, struct record *ret_rec)
 	int type;
 	int i;
 
-	type = parse_common_type(ret_rec->data);
-	ret_event = find_event(type);
+	type = trace_parse_common_type(ret_rec->data);
+	ret_event = trace_find_event(type);
 
 	field = find_field(ret_event, "rettime");
 	if (!field)
@@ -2696,11 +2719,13 @@ void print_event(int cpu, void *data, int size, unsigned long long nsecs,
 	nsecs -= secs * NSECS_PER_SEC;
 	usecs = nsecs / NSECS_PER_USEC;
 
-	type = parse_common_type(data);
+	type = trace_parse_common_type(data);
 
-	event = find_event(type);
-	if (!event)
-		die("ug! no event found for type %d", type);
+	event = trace_find_event(type);
+	if (!event) {
+		printf("ug! no event found for type %d\n", type);
+		return;
+	}
 
 	pid = parse_common_pid(data);
 
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index a1217a1..1b5c847 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -458,12 +458,13 @@ struct record *trace_read_data(int cpu)
 	return data;
 }
 
-void trace_report (void)
+void trace_report(void)
 {
 	const char *input_file = "trace.info";
 	char buf[BUFSIZ];
 	char test[] = { 23, 8, 68 };
 	char *version;
+	int show_version = 0;
 	int show_funcs = 0;
 	int show_printk = 0;
 
@@ -480,7 +481,8 @@ void trace_report (void)
 		die("not a trace file (missing tracing)");
 
 	version = read_string();
-	printf("version = %s\n", version);
+	if (show_version)
+		printf("version = %s\n", version);
 	free(version);
 
 	read_or_die(buf, 1);
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 420294a..d35ebf1 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -234,6 +234,11 @@ extern int header_page_data_offset;
 extern int header_page_data_size;
 
 int parse_header_page(char *buf, unsigned long size);
+int trace_parse_common_type(void *data);
+struct event *trace_find_event(int id);
+unsigned long long
+raw_field_value(struct event *event, const char *name, void *data);
+void *raw_field_ptr(struct event *event, const char *name, void *data);
 
 void read_tracing_data(struct perf_counter_attr *pattrs, int nb_counters);
 
