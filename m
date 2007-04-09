Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbXDINy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbXDINy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 09:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933054AbXDINy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 09:54:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56303 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932819AbXDINy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 09:54:56 -0400
Date: Mon, 9 Apr 2007 15:53:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@gmail.com>
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Subject: Re: Ten percent test
Message-ID: <20070409135355.GA11244@elte.hu>
References: <200703290237.38777.kernel@kolivas.org> <200704071423.47790.gene.heskett@gmail.com> <20070407185220.GA31725@elte.hu> <200704071630.25830.gene.heskett@gmail.com> <20070408104125.GB11123@elte.hu> <461939A4.2020305@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <461939A4.2020305@gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Rene Herman <rene.herman@gmail.com> wrote:

> > and that change from Mike responded to a testcase. Mike's latest 
> > changes (the ones you just tested) were mostly driven by actual 
> > testcases too, which measured long-term timeslice distribution 
> > fairness.
> 
> Ah yes, that one. Here's the next one in that series:
> 
> commit f1adad78dd2fc8edaa513e0bde92b4c64340245c
> Author: Linus Torvalds <torvalds@g5.osdl.org>
> Date:   Sun May 21 18:54:09 2006 -0700
> 
>     Revert "[PATCH] sched: fix interactive task starvation"

yes - in hindsight i regret having asked Mike for a "simpler" patch, 
which turned out to be rushed and plain broke your setup: my bad. And i 
completely forgot about that episode, Mike did a stream of changes in 
that timeframe and this one was indeed reverted :-/

> It personally had me wonder if _anyone_ was testing this stuff...

yes, i certainly tried it and it broke nothing, and it was in fact acked 
by Con too:

>    Signed-off-by: Mike Galbraith <efault@gmx.de>
>    Acked-by: Ingo Molnar <mingo@elte.hu>
>    Cc: Nick Piggin <nickpiggin@yahoo.com.au>
>    Acked-by: Con Kolivas <kernel@kolivas.org>
>    Signed-off-by: Andrew Morton <akpm@osdl.org>
>    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

but it broke your setup:

>    This reverts commit 5ce74abe788a26698876e66b9c9ce7e7acc25413 (and 
>    its dependent commit 8a5bc075b8d8cf7a87b3f08fad2fba0f5d13295e), 
>    because of audio underruns.
>
>    Reported by Rene Herman <rene.herman@keyaccess.nl>, who also 
>    pinpointed the exact cause of the underruns:
>
>      "Audio underruns galore, with only ogg123 and firefox (browsing 
>      the GIT tree online is also a nice trigger by the way).
>
>      If I back it out, everything is fine for me again."

so reverting it was justified. Basically, the approach was that the 
vanilla scheduler is working reasonably well, and that any improvement 
to it must not cause regression in areas where it already works well. 
(it obviously must have been working on your audio setup to a certain 
degree if reverting Mike's patch made the underruns go away)

In any case, it would be very nice if you could try Mike's latest patch, 
how does it work on your setup? (i've attached it)

	Ingo

--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="sched-mike-4.patch"

On Tue, 2007-04-03 at 08:01 +0200, Ingo Molnar wrote:

> looks interesting - could you send the patch?

Ok, this is looking/feeling pretty good in testing.  Comments on
fugliness etc much appreciated.

Below the numbers is a snapshot of my experimental tree.  It's a mixture
of my old throttling/anti-starvation tree and the task promotion patch,
with the addition of a scheduling class for interactive tasks to dish
out some of that targeted unfairness I mentioned.  SCHED_INTERACTIVE is
also targeted at the scenario where X or one of it's clients uses enough
CPU to end up in the expired array.

(note:  Xorg was not set SCHED_INTERACTIVE during the test runs below)

	-Mike

top - 12:31:34 up 16 min, 13 users,  load average: 7.37, 8.74, 6.58

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 6542 root      15   0  1568  108   24 S   43  0.0   0:58.98 1 fiftypercent
 6540 root      17   0  1568  440  356 R   30  0.0   1:00.04 0 fiftypercent
 6544 root      18   0  1568  108   24 R   28  0.0   0:58.36 0 fiftypercent
 6541 root      20   0  1568  108   24 R   26  0.0   0:57.70 1 fiftypercent
 6536 root      25   0  1436  356  296 R   24  0.0   0:45.76 1 chew
 6538 root      25   0  1436  356  296 R   20  0.0   0:49.73 0 chew
 6543 root      19   0  1568  108   24 R   19  0.0   0:58.04 1 fiftypercent
 6409 root      15   0  154m  63m  27m R    2  6.3   0:13.09 0 amarokapp
 6410 root      15   0  154m  63m  27m S    2  6.3   0:14.36 0 amarokapp
 6376 root      15   0  2380 1092  764 R    2  0.1   0:15.63 0 top
 5591 root      18   0  4736 1036  736 S    1  0.1   0:00.14 1 smpppd
 5678 root      15   0  167m  24m 4848 S    1  2.4   0:19.37 0 Xorg
 6202 root      15   0 32364  18m  12m S    1  1.8   0:04.25 1 konsole

50 lines from center of chew nailed to cpu0's log

pid 6538, prio   0, out for   27 ms, ran for    1 ms, load   6%
pid 6538, prio   0, out for   26 ms, ran for    4 ms, load  14%
pid 6538, prio   0, out for   27 ms, ran for    7 ms, load  20%
pid 6538, prio   0, out for   13 ms, ran for    5 ms, load  27%
pid 6538, prio   0, out for    8 ms, ran for    7 ms, load  49%
pid 6538, prio   0, out for   10 ms, ran for    7 ms, load  43%
pid 6538, prio   0, out for    9 ms, ran for    6 ms, load  42%
pid 6538, prio   0, out for    9 ms, ran for    7 ms, load  46%
pid 6538, prio   0, out for    9 ms, ran for    7 ms, load  43%
pid 6538, prio   0, out for    9 ms, ran for    7 ms, load  43%
pid 6538, prio   0, out for    8 ms, ran for    7 ms, load  48%
pid 6538, prio   0, out for    9 ms, ran for   27 ms, load  74%
pid 6538, prio   0, out for   27 ms, ran for    4 ms, load  13%
pid 6538, prio   0, out for   26 ms, ran for    5 ms, load  17%
pid 6538, prio   0, out for   27 ms, ran for    5 ms, load  17%
pid 6538, prio   0, out for   28 ms, ran for    6 ms, load  18%
pid 6538, prio   0, out for   30 ms, ran for    4 ms, load  14%
pid 6538, prio   0, out for   18 ms, ran for    5 ms, load  24%
pid 6538, prio   0, out for    9 ms, ran for    7 ms, load  42%
pid 6538, prio   0, out for    8 ms, ran for    7 ms, load  45%
pid 6538, prio   0, out for    8 ms, ran for    7 ms, load  45%
pid 6538, prio   0, out for    9 ms, ran for    7 ms, load  44%
pid 6538, prio   0, out for    9 ms, ran for    7 ms, load  43%
pid 6538, prio   0, out for    2 ms, ran for    7 ms, load  78%
pid 6538, prio   0, out for   45 ms, ran for   22 ms, load  33%
pid 6538, prio   0, out for   31 ms, ran for    2 ms, load   7%
pid 6538, prio   0, out for   62 ms, ran for    1 ms, load   3%
pid 6538, prio   0, out for   29 ms, ran for    3 ms, load  11%
pid 6538, prio   0, out for   26 ms, ran for    4 ms, load  13%
pid 6538, prio   0, out for  134 ms, ran for    5 ms, load   4%
pid 6538, prio   0, out for   78 ms, ran for    2 ms, load   3%
pid 6538, prio   0, out for    9 ms, ran for    3 ms, load  28%
pid 6538, prio   0, out for   10 ms, ran for    7 ms, load  42%
pid 6538, prio   0, out for   10 ms, ran for    7 ms, load  42%
pid 6538, prio   0, out for    8 ms, ran for    7 ms, load  48%
pid 6538, prio   0, out for    8 ms, ran for    7 ms, load  46%
pid 6538, prio   0, out for    9 ms, ran for    7 ms, load  43%
pid 6538, prio   0, out for   10 ms, ran for    7 ms, load  43%
pid 6538, prio   0, out for    9 ms, ran for    6 ms, load  39%
pid 6538, prio   0, out for    9 ms, ran for    7 ms, load  42%
pid 6538, prio   0, out for    8 ms, ran for    7 ms, load  46%
pid 6538, prio   0, out for   14 ms, ran for    6 ms, load  30%
pid 6538, prio   0, out for   27 ms, ran for    3 ms, load  12%
pid 6538, prio   0, out for   29 ms, ran for    4 ms, load  12%
pid 6538, prio   0, out for   29 ms, ran for    4 ms, load  13%
pid 6538, prio   0, out for   26 ms, ran for    4 ms, load  14%
pid 6538, prio   0, out for   29 ms, ran for    5 ms, load  14%
pid 6538, prio   0, out for   27 ms, ran for    4 ms, load  14%
pid 6538, prio   0, out for   26 ms, ran for    5 ms, load  16%
pid 6538, prio   0, out for   24 ms, ran for    6 ms, load  20%
pid 6538, prio   0, out for    7 ms, ran for    7 ms, load  49%


root@Homer: ./massive_intr 30 180
006502	00002373
006495	00002687
006518	00002417
006490	00002544
006500	00002417
006494	00002427
006498	00003032
006517	00003060
006505	00002401
006507	00002375
006514	00002398
006497	00002483
006506	00002388
006504	00002415
006510	00002472
006516	00002365
006509	00002441
006503	00002498
006512	00002930
006496	00002565
006492	00002389
006501	00002337
006508	00002395
006491	00002486
006499	00002394
006493	00002667
006515	00002569
006511	00002555
006513	00002637
006519	00002556

---
 include/linux/sched.h  |    7 
 include/linux/sysctl.h |    2 
 kernel/sched.c         |  450 +++++++++++++++++++++++++++++++++++++++++++++----
 kernel/sysctl.c        |   39 +++-
 4 files changed, 459 insertions(+), 39 deletions(-)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -34,6 +34,7 @@
 #define SCHED_FIFO		1
 #define SCHED_RR		2
 #define SCHED_BATCH		3
+#define SCHED_INTERACTIVE	4
 
 #ifdef __KERNEL__
 
@@ -528,7 +529,7 @@ struct signal_struct {
 #define rt_prio(prio)		unlikely((prio) < MAX_RT_PRIO)
 #define rt_task(p)		rt_prio((p)->prio)
 #define batch_task(p)		(unlikely((p)->policy == SCHED_BATCH))
-#define is_rt_policy(p)		((p) != SCHED_NORMAL && (p) != SCHED_BATCH)
+#define is_rt_policy(p)		((p) == SCHED_RR || (p) == SCHED_FIFO)
 #define has_rt_policy(p)	unlikely(is_rt_policy((p)->policy))
 
 /*
@@ -820,14 +821,14 @@ struct task_struct {
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	unsigned int btrace_seq;
 #endif
-	unsigned long sleep_avg;
+	unsigned long sleep_avg, last_slice, throttle;
 	unsigned long long timestamp, last_ran;
 	unsigned long long sched_time; /* sched_clock time spent running */
 	enum sleep_type sleep_type;
 
 	unsigned long policy;
 	cpumask_t cpus_allowed;
-	unsigned int time_slice, first_time_slice;
+	unsigned int time_slice, slice_info;
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	struct sched_info sched_info;
Index: linux/include/linux/sysctl.h
===================================================================
--- linux.orig/include/linux/sysctl.h
+++ linux/include/linux/sysctl.h
@@ -165,6 +165,8 @@ enum
 	KERN_MAX_LOCK_DEPTH=74,
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
+	KERN_SCHED_THROTTLE1=77,  /* int: throttling credit period 1 in secs */
+	KERN_SCHED_THROTTLE2=78,  /* int: throttling credit period 2 in secs */
 };
 
 
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -90,6 +90,20 @@ unsigned long long __attribute__((weak))
 #define NS_TO_JIFFIES(TIME)	((TIME) / (1000000000 / HZ))
 #define JIFFIES_TO_NS(TIME)	((TIME) * (1000000000 / HZ))
 
+#if (BITS_PER_LONG < 64)
+#define JIFFIES_TO_NS64(TIME) \
+	((unsigned long long)(TIME) * ((unsigned long) (1000000000 / HZ)))
+
+#define NS64_TO_JIFFIES(TIME) \
+	((((unsigned long long)((TIME)) >> BITS_PER_LONG) * \
+	(1 + NS_TO_JIFFIES(~0UL))) + NS_TO_JIFFIES((unsigned long)(TIME)))
+#else /* BITS_PER_LONG < 64 */
+
+#define NS64_TO_JIFFIES(TIME) NS_TO_JIFFIES(TIME)
+#define JIFFIES_TO_NS64(TIME) JIFFIES_TO_NS(TIME)
+
+#endif /* BITS_PER_LONG < 64 */
+
 /*
  * These are the 'tuning knobs' of the scheduler:
  *
@@ -109,6 +123,8 @@ unsigned long long __attribute__((weak))
 #define MAX_SLEEP_AVG		(DEF_TIMESLICE * MAX_BONUS)
 #define STARVATION_LIMIT	(MAX_SLEEP_AVG)
 #define NS_MAX_SLEEP_AVG	(JIFFIES_TO_NS(MAX_SLEEP_AVG))
+#define PCNT_PER_DYNPRIO	(100 / MAX_BONUS)
+#define INTERACTIVE_LIMIT	(DEF_TIMESLICE * 4)
 
 /*
  * If a task is 'interactive' then we reinsert it in the active
@@ -167,6 +183,133 @@ unsigned long long __attribute__((weak))
 	(JIFFIES_TO_NS(MAX_SLEEP_AVG * \
 		(MAX_BONUS / 2 + DELTA((p)) + 1) / MAX_BONUS - 1))
 
+#define INTERACTIVE_LIMIT_EXCEEDED(rq) \
+	((rq)->active->interactive_ticks + (rq)->expired->interactive_ticks > \
+		INTERACTIVE_LIMIT)
+
+/*
+ * Interactive boost can lead to starvation if the decision to
+ * boost a task turns out to be a bad one.  To combat this, we
+ * compute the sane upper limit for cpu usage 'slice_avg' based
+ * upon a task's sleep_avg, and use this information combined
+ * with a timer to determine when intervention is required.
+ *
+ * When a task is behaving as it's sleep_avg indicates it should,
+ * it's throttle is moved forward, otherwise it will timeout, and
+ * it's priority will be lowered.
+ *
+ * Throttling tunables.
+ *
+ * CREDIT_C1: The amount of cpu time in seconds that a new task
+ *           will run completely free, ie the head start a task
+ *           has before it has to push it's timer forward to avoid
+ *           being throttled.  Each conforming slice thereafter
+ *           increases it's stored credit, and vice versa.
+ *
+ * CREDIT_C2: The maximum amount of CPU time in seconds a task
+ *           can store for later use.  When a task has no stored
+ *           credit left, now is time C2.  Tasks begin life with
+ *           C1 seconds credit, ie C2 is C1 seconds in front of
+ *           them, and the 'buffer' will grow in front of them
+ *           if they perform in a conformant manner.  The maximum
+ *           credit that fits in 32 bits jiffies is 42949 seconds.
+ */
+
+int credit_c1 = 0;
+int credit_c2 = 14400;
+int credit_max = 42949;
+
+#define C1 (credit_c1 * MAX_BONUS * HZ)
+#define C2 (credit_c2 * MAX_BONUS * HZ + C1)
+#define C3 (MAX_BONUS * C2)
+
+#define credit_exhausted(p, credit) \
+	(time_after_eq(jiffies, (p)->throttle + (credit)))
+
+/*
+ * Masks for p->slice_info, formerly p->first_time_slice.
+ * SLICE_FTS:   0x80000000  Task is in it's first ever timeslice.
+ * SLICE_NEW:   0x40000000  Slice refreshed.
+ * SLICE_INT:   0x20000000  Task is a SCHED_INTERACTIVE task partner.
+ * SLICE_SPA:   0x1FFE0000  Spare bits.
+ * SLICE_LTS:   0x0001FF80  Last time slice
+ * SLICE_AVG:   0x0000007F  Task slice_avg stored as percentage.
+ */
+#define SLICE_AVG_BITS    7
+#define SLICE_LTS_BITS   10
+#define SLICE_SPA_BITS   12
+#define SLICE_INT_BITS    1
+#define SLICE_NEW_BITS    1
+#define SLICE_FTS_BITS    1
+
+#define SLICE_AVG_SHIFT   0
+#define SLICE_LTS_SHIFT   (SLICE_AVG_SHIFT + SLICE_AVG_BITS)
+#define SLICE_SPA_SHIFT   (SLICE_LTS_SHIFT + SLICE_LTS_BITS)
+#define SLICE_INT_SHIFT   (SLICE_SPA_SHIFT + SLICE_SPA_BITS)
+#define SLICE_NEW_SHIFT   (SLICE_INT_SHIFT + SLICE_INT_BITS)
+#define SLICE_FTS_SHIFT   (SLICE_NEW_SHIFT + SLICE_NEW_BITS)
+
+#define INFO_MASK(x)      ((1U << (x))-1)
+#define SLICE_AVG_MASK    (INFO_MASK(SLICE_AVG_BITS) << SLICE_AVG_SHIFT)
+#define SLICE_LTS_MASK    (INFO_MASK(SLICE_LTS_BITS) << SLICE_LTS_SHIFT)
+#define SLICE_SPA_MASK    (INFO_MASK(SLICE_SPA_BITS) << SLICE_SPA_SHIFT)
+#define SLICE_INT_MASK    (INFO_MASK(SLICE_INT_BITS) << SLICE_INT_SHIFT)
+#define SLICE_NEW_MASK    (INFO_MASK(SLICE_NEW_BITS) << SLICE_NEW_SHIFT)
+#define SLICE_FTS_MASK    (INFO_MASK(SLICE_FTS_BITS) << SLICE_FTS_SHIFT)
+
+/* p->slice_info access macros. */
+#define first_time_slice(p) ((p)->slice_info & SLICE_FTS_MASK)
+#define set_first_time_slice(p) ((p)->slice_info |= SLICE_FTS_MASK)
+#define clr_first_time_slice(p) ((p)->slice_info &= ~SLICE_FTS_MASK)
+
+#define slice_is_new(p) ((p)->slice_info & SLICE_NEW_MASK)
+#define set_slice_is_new(p) ((p)->slice_info |= SLICE_NEW_MASK)
+#define clr_slice_is_new(p) ((p)->slice_info &= ~SLICE_NEW_MASK)
+
+#define task_is_interactive(p) ((p)->slice_info & SLICE_INT_MASK)
+#define set_task_is_interactive(p) ((p)->slice_info |= SLICE_INT_MASK)
+#define clr_task_is_interactive(p) ((p)->slice_info &= ~SLICE_INT_MASK)
+
+#define last_slice(p) (((p)->slice_info & SLICE_LTS_MASK) >> SLICE_LTS_SHIFT)
+#define set_last_slice(p, n) ((p)->slice_info = (((p)->slice_info & \
+	~SLICE_LTS_MASK) | (((n) << SLICE_LTS_SHIFT) & SLICE_LTS_MASK)))
+
+#define NS_SLEEP_AVG_PCNT (NS_MAX_SLEEP_AVG / 100)
+
+/* Note: raw storage format of slice_avg is %cpu. */
+#define slice_avg(p) ((typeof((p)->sleep_avg)) \
+	((((p)->slice_info & SLICE_AVG_MASK) >> SLICE_AVG_SHIFT) * \
+	NS_SLEEP_AVG_PCNT))
+#define set_slice_avg(p, n) ((p)->slice_info = (((p)->slice_info & \
+	~SLICE_AVG_MASK) | ((((n) / NS_SLEEP_AVG_PCNT) \
+	<< SLICE_AVG_SHIFT) & SLICE_AVG_MASK)))
+#define slice_avg_raw(p)  \
+	(((p)->slice_info & SLICE_AVG_MASK) >> SLICE_AVG_SHIFT)
+#define set_slice_avg_raw(p, n) ((p)->slice_info = (((p)->slice_info & \
+	~SLICE_AVG_MASK) | (((n) << SLICE_AVG_SHIFT) & SLICE_AVG_MASK)))
+
+/* cpu usage macros. */
+#define cpu_avg(p) \
+	(100 - slice_avg_raw(p))
+
+#define cpu_max(p) \
+	(100 - ((p)->sleep_avg / NS_SLEEP_AVG_PCNT))
+
+#define time_this_slice(p) \
+	(jiffies - (p)->last_slice)
+
+#define cpu_this_slice(p) \
+	(100 * last_slice(p) / max((unsigned) time_this_slice(p), \
+	(unsigned) last_slice(p)))
+
+#define cpu_avg_rq(rq) \
+	(100 * DEF_TIMESLICE / max((unsigned) (rq)->slice_avg, \
+		(unsigned) DEF_TIMESLICE))
+
+/* Positively identified interactive tasks. */
+#define task_interactive(p) \
+	((p)->policy == SCHED_INTERACTIVE || task_is_interactive(p))
+
 #define TASK_PREEMPTS_CURR(p, rq) \
 	((p)->prio < (rq)->curr->prio)
 
@@ -201,6 +344,7 @@ static inline unsigned int task_timeslic
 
 struct prio_array {
 	unsigned int nr_active;
+	int interactive_ticks;
 	DECLARE_BITMAP(bitmap, MAX_PRIO+1); /* include 1 bit for delimiter */
 	struct list_head queue[MAX_PRIO];
 };
@@ -234,7 +378,8 @@ struct rq {
 	 */
 	unsigned long nr_uninterruptible;
 
-	unsigned long expired_timestamp;
+	unsigned long switch_timestamp;
+	unsigned long slice_avg;
 	/* Cached timestamp set by update_cpu_clock() */
 	unsigned long long most_recent_timestamp;
 	struct task_struct *curr, *idle;
@@ -691,6 +836,8 @@ static void dequeue_task(struct task_str
 	list_del(&p->run_list);
 	if (list_empty(array->queue + p->prio))
 		__clear_bit(p->prio, array->bitmap);
+	if (TASK_INTERACTIVE(p))
+		array->interactive_ticks -= p->time_slice;
 }
 
 static void enqueue_task(struct task_struct *p, struct prio_array *array)
@@ -700,6 +847,8 @@ static void enqueue_task(struct task_str
 	__set_bit(p->prio, array->bitmap);
 	array->nr_active++;
 	p->array = array;
+	if (TASK_INTERACTIVE(p))
+		array->interactive_ticks += p->time_slice;
 }
 
 /*
@@ -882,7 +1031,11 @@ static int recalc_task_prio(struct task_
 	/* Caller must always ensure 'now >= p->timestamp' */
 	unsigned long sleep_time = now - p->timestamp;
 
-	if (batch_task(p))
+	/*
+	 * Migration timestamp adjustment may induce negative time.
+	 * Ignore unquantifiable values as well as SCHED_BATCH tasks.
+	 */
+	if (now < p->timestamp || batch_task(p))
 		sleep_time = 0;
 
 	if (likely(sleep_time > 0)) {
@@ -893,7 +1046,14 @@ static int recalc_task_prio(struct task_
 		 */
 		unsigned long ceiling = INTERACTIVE_SLEEP(p);
 
-		if (p->mm && sleep_time > ceiling && p->sleep_avg < ceiling) {
+	 	/*
+		 * Update throttle position.
+		 */
+		p->throttle += NS64_TO_JIFFIES(sleep_time);
+		if (time_before(jiffies, p->throttle))
+			p->throttle = jiffies;
+
+		if (sleep_time > ceiling && p->sleep_avg < ceiling) {
 			/*
 			 * Prevents user tasks from achieving best priority
 			 * with one single large enough sleep.
@@ -915,7 +1075,7 @@ static int recalc_task_prio(struct task_
 			 * limited in their sleep_avg rise as they
 			 * are likely to be waiting on I/O
 			 */
-			if (p->sleep_type == SLEEP_NONINTERACTIVE && p->mm) {
+			if (p->sleep_type == SLEEP_NONINTERACTIVE) {
 				if (p->sleep_avg >= ceiling)
 					sleep_time = 0;
 				else if (p->sleep_avg + sleep_time >=
@@ -1531,16 +1691,23 @@ out_activate:
 		 * sleep_avg beyond just interactive state.
 		 */
 		p->sleep_type = SLEEP_NONINTERACTIVE;
-	} else
+	} else if (task_interactive(current)) {
+		/*
+		 * Tasks tagged as being truly interactive
+		 * pass temporary interactive status on to
+		 * the task they are waking.
+		 */
+		set_task_is_interactive(p);
+		p->sleep_type = SLEEP_INTERACTIVE;
+	}
 
 	/*
 	 * Tasks that have marked their sleep as noninteractive get
 	 * woken up with their sleep average not weighted in an
 	 * interactive way.
 	 */
-		if (old_state & TASK_NONINTERACTIVE)
-			p->sleep_type = SLEEP_NONINTERACTIVE;
-
+	else if (old_state & TASK_NONINTERACTIVE)
+		p->sleep_type = SLEEP_NONINTERACTIVE;
 
 	activate_task(p, rq, cpu == this_cpu);
 	/*
@@ -1628,9 +1795,24 @@ void fastcall sched_fork(struct task_str
 	 * The remainder of the first timeslice might be recovered by
 	 * the parent if the child exits early enough.
 	 */
-	p->first_time_slice = 1;
 	current->time_slice >>= 1;
 	p->timestamp = sched_clock();
+
+	/*
+	 * Set up slice_info and initial throttle position for the child.
+	 */
+	set_slice_avg(p, p->sleep_avg);
+	set_last_slice(p, p->time_slice);
+	set_slice_is_new(p);
+	set_first_time_slice(p);
+	p->last_slice = jiffies;
+	p->throttle = jiffies - C2 + C1;
+	/*
+	 * SCHED_INTERACTIVE policy cannot be inherited.
+	 */
+	if (unlikely(current->policy == SCHED_INTERACTIVE))
+		p->policy = SCHED_NORMAL;
+
 	if (unlikely(!current->time_slice)) {
 		/*
 		 * This case is rare, it happens when the parent has only
@@ -1745,7 +1927,7 @@ void fastcall sched_exit(struct task_str
 	 * the sleep_avg of the parent as well.
 	 */
 	rq = task_rq_lock(p->parent, &flags);
-	if (p->first_time_slice && task_cpu(p) == task_cpu(p->parent)) {
+	if (first_time_slice(p) && task_cpu(p) == task_cpu(p->parent)) {
 		p->parent->time_slice += p->time_slice;
 		if (unlikely(p->parent->time_slice > task_timeslice(p)))
 			p->parent->time_slice = task_timeslice(p);
@@ -3051,9 +3233,10 @@ static inline int expired_starving(struc
 {
 	if (rq->curr->static_prio > rq->best_expired_prio)
 		return 1;
-	if (!STARVATION_LIMIT || !rq->expired_timestamp)
+	if (!STARVATION_LIMIT)
 		return 0;
-	if (jiffies - rq->expired_timestamp > STARVATION_LIMIT * rq->nr_running)
+	if (jiffies - rq->switch_timestamp > rq->nr_running * DEF_TIMESLICE +
+			STARVATION_LIMIT)
 		return 1;
 	return 0;
 }
@@ -3131,8 +3314,165 @@ void account_steal_time(struct task_stru
 		cpustat->steal = cputime64_add(cpustat->steal, tmp);
 }
 
+/*
+ * Promote and requeue the next lower priority task.  If no task
+ * is available in the active array, switch to the expired array.
+ * @rq: runqueue to search.
+ * @prio: priority at which to begin search.
+ */
+static inline void promote_next_lower(struct rq *rq, int prio)
+{
+	struct prio_array *array = rq->active;
+	struct task_struct *p = NULL;
+	unsigned long long now = rq->most_recent_timestamp;
+	unsigned long *bitmap;
+	unsigned long starving = JIFFIES_TO_NS(rq->slice_avg);
+	int idx = prio + 1, found_noninteractive = 0;
+	int ticks = rq->active->interactive_ticks + rq->expired->interactive_ticks;
+
+repeat:
+	bitmap = array->bitmap;
+	idx = find_next_bit(bitmap, MAX_PRIO, idx);
+	if (idx < MAX_PRIO) {
+		struct list_head *queue = array->queue + idx;
+
+		p = list_entry(queue->next, struct task_struct, run_list);
+		if (!TASK_INTERACTIVE(p))
+			found_noninteractive = 1;
+
+		/* Skip non-starved queues. */
+		if (now < p->last_ran + starving) {
+			idx++;
+			p = NULL;
+			goto repeat;
+		}
+	} else if (!found_noninteractive && array == rq->active) {
+		/* Nobody home, check the expired array. */
+		array = rq->expired;
+		idx = prio;
+		p = NULL;
+		goto repeat;
+	}
+
+	/* Found one, requeue it. */
+	if (p) {
+		dequeue_task(p, p->array);
+		if (array == rq->active)
+			p->prio--;
+		/*
+		 * If we pulled a task from the expired array, correct
+		 * expired array info.  We can't afford a full search
+		 * for best_expired_prio, but do the best we can.
+		 */
+		else {
+			idx = sched_find_first_bit(array->bitmap);
+			if (idx < MAX_PRIO) {
+				if (rq->best_expired_prio > idx)
+					rq->best_expired_prio = idx;
+			} else {
+				/* We emptied the array */
+				rq->best_expired_prio = MAX_PRIO;
+				/*
+				 * If we have excessive interactive load,
+				 * do not inhibit forced array switching.
+				 */
+				if (ticks < INTERACTIVE_LIMIT)
+					rq->switch_timestamp = jiffies;
+			}
+		}
+		enqueue_task(p, rq->active);
+	}
+}
+
+/*
+ * Refresh timeslice and associated slice information.
+ * @p: the process to refresh.
+ */
+static void refresh_timeslice(struct task_struct *p)
+{
+	struct rq *rq = task_rq(p);
+	unsigned long slice_time = jiffies - p->last_slice;
+	int idle, cpu, cpu_avg, slice = last_slice(p);
+	int w = MAX_BONUS, delta, bonus;
+
+	if (unlikely(slice_time < slice))
+		slice_time = slice;
+
+	/* Update task's CPU usage. */
+	cpu_avg = slice_avg_raw(p);
+	cpu = cpu_this_slice(p);
+	idle = 100 - cpu;
+	delta = max(cpu_avg, idle) - min(cpu_avg, idle);
+	w = 1 + (delta / w);
+	cpu_avg = (w * cpu_avg + idle) / (w + 1);
+	set_slice_avg_raw(p, cpu_avg);
+
+	/*
+	 * If we've hit the throttle timeout, we aren't draining enough
+	 * sleep_avg to keep up with the task's cpu usage.  Up the ante
+	 * to bring the task back toward balance.
+	 */
+	if (credit_exhausted(p, C2) && p->sleep_avg > slice_avg(p)) {
+		unsigned long run_time = p->sleep_avg - slice_avg(p);
+		run_time /= w;
+		if (p->sleep_avg >= run_time)
+			p->sleep_avg -= run_time;
+	}
+
+	/*
+	 * Update throttle position and sanity check it.
+	 */
+	if (task_is_interactive(p))
+		p->throttle += slice_time - slice;
+	else if (INTERACTIVE_LIMIT_EXCEEDED(rq) &&
+			cpu_avg - cpu_avg_rq(rq) >= PCNT_PER_DYNPRIO) {
+		bonus = (cpu_avg - cpu_avg_rq(rq)) / PCNT_PER_DYNPRIO;
+		p->throttle -= slice_time * bonus;
+	} else if (cpu < cpu_max(p) + PCNT_PER_DYNPRIO) {
+		bonus = idle * PCNT_PER_DYNPRIO / 100;
+		p->throttle += (slice_time - slice) * bonus;
+	} else  if (cpu >= cpu_max(p) + PCNT_PER_DYNPRIO) {
+		bonus = (cpu - cpu_max(p)) / PCNT_PER_DYNPRIO;
+		p->throttle -= slice_time * bonus;
+	}
+
+	if (time_before(jiffies, p->throttle))
+		p->throttle = jiffies;
+	else if (credit_exhausted(p, C3))
+		p->throttle = jiffies - C3;
+
+	/* Add our slice time to the runqueue average. */
+	if (slice_time < HZ || slice_time < rq->nr_running * DEF_TIMESLICE) {
+		rq->slice_avg <<= 4;
+		rq->slice_avg += slice_time;
+		rq->slice_avg >>= 4;
+	}
+
+	/*
+	 * Ensure that SCHED_INTERACTIVE tasks and their partners will
+	 * always be classified correctly by TASK_INTERACTIVE(). Clear
+	 * propogated interactive task status.  Propogated status is
+	 * inherited from the parent, but is good for only one slice.
+	 */
+	if (task_is_interactive(p) && p->sleep_avg < INTERACTIVE_SLEEP(p))
+		p->sleep_avg = INTERACTIVE_SLEEP(p);
+	clr_task_is_interactive(p);
+
+	/* Update dynamic priority and time slice. */
+	p->prio = effective_prio(p);
+	p->time_slice = task_timeslice(p);
+	set_last_slice(p, p->time_slice);
+
+	/* And finally, stamp and flag the new slice. */
+	clr_first_time_slice(p);
+	set_slice_is_new(p);
+	p->last_slice = jiffies;
+}
+
 static void task_running_tick(struct rq *rq, struct task_struct *p)
 {
+	int task_was_interactive;
+
 	if (p->array != rq->active) {
 		/* Task has expired but was not scheduled yet */
 		set_tsk_need_resched(p);
@@ -3152,8 +3492,7 @@ static void task_running_tick(struct rq 
 		 * FIFO tasks have no timeslices.
 		 */
 		if ((p->policy == SCHED_RR) && !--p->time_slice) {
-			p->time_slice = task_timeslice(p);
-			p->first_time_slice = 0;
+			refresh_timeslice(p);
 			set_tsk_need_resched(p);
 
 			/* put it at the end of the queue: */
@@ -3161,21 +3500,36 @@ static void task_running_tick(struct rq 
 		}
 		goto out_unlock;
 	}
+
+	/*
+	 * Tick off interactive task ticks from the active array.
+	 */
+	task_was_interactive = TASK_INTERACTIVE(p);
+	if (task_was_interactive && --rq->active->interactive_ticks < 0)
+		rq->active->interactive_ticks = 0;
+
 	if (!--p->time_slice) {
 		dequeue_task(p, rq->active);
+		refresh_timeslice(p);
 		set_tsk_need_resched(p);
-		p->prio = effective_prio(p);
-		p->time_slice = task_timeslice(p);
-		p->first_time_slice = 0;
-
-		if (!rq->expired_timestamp)
-			rq->expired_timestamp = jiffies;
-		if (!TASK_INTERACTIVE(p) || expired_starving(rq)) {
+
+		if (!TASK_INTERACTIVE(p) || expired_starving(rq) ||
+				credit_exhausted(p, C2)) {
 			enqueue_task(p, rq->expired);
 			if (p->static_prio < rq->best_expired_prio)
 				rq->best_expired_prio = p->static_prio;
 		} else
 			enqueue_task(p, rq->active);
+
+		/*
+		 * Always look to see if any queue under you is starving,
+		 * and requeue a task if that is the case.  This prevents
+		 * things like multiple tasks at any priority waking in
+		 * streams and starving their less fortunate peers via
+		 * preempt, ie ensures that the less fortunate will have
+		 * bounded latency.
+		 */
+		promote_next_lower(rq, p->prio);
 	} else {
 		/*
 		 * Prevent a too long timeslice allowing a task to monopolize
@@ -3285,7 +3639,7 @@ asmlinkage void __sched schedule(void)
 	struct list_head *queue;
 	unsigned long long now;
 	unsigned long run_time;
-	int cpu, idx, new_prio;
+	int cpu, idx, new_prio, throttle;
 	long *switch_count;
 	struct rq *rq;
 
@@ -3332,9 +3686,13 @@ need_resched_nonpreemptible:
 
 	/*
 	 * Tasks charged proportionately less run_time at high sleep_avg to
-	 * delay them losing their interactive status
-	 */
-	run_time /= (CURRENT_BONUS(prev) ? : 1);
+	 * delay them losing their interactive status.  If we have too many
+	 * interactive ticks queued or this task is being throttled, switch
+	 * behavior to linear decay.
+	 */
+	throttle = INTERACTIVE_LIMIT_EXCEEDED(rq) || credit_exhausted(prev, C2);
+	if (!throttle)
+		run_time /= 1 + CURRENT_BONUS(prev);
 
 	spin_lock_irq(&rq->lock);
 
@@ -3356,7 +3714,7 @@ need_resched_nonpreemptible:
 		idle_balance(cpu, rq);
 		if (!rq->nr_running) {
 			next = rq->idle;
-			rq->expired_timestamp = 0;
+			rq->switch_timestamp = jiffies;
 			goto switch_tasks;
 		}
 	}
@@ -3370,7 +3728,8 @@ need_resched_nonpreemptible:
 		rq->active = rq->expired;
 		rq->expired = array;
 		array = rq->active;
-		rq->expired_timestamp = 0;
+		array->interactive_ticks = 0;
+		rq->switch_timestamp = jiffies;
 		rq->best_expired_prio = MAX_PRIO;
 	}
 
@@ -3380,6 +3739,8 @@ need_resched_nonpreemptible:
 
 	if (!rt_task(next) && interactive_sleep(next->sleep_type)) {
 		unsigned long long delta = now - next->timestamp;
+		int next_interactive = TASK_INTERACTIVE(next);
+
 		if (unlikely((long long)(now - next->timestamp) < 0))
 			delta = 0;
 
@@ -3389,14 +3750,33 @@ need_resched_nonpreemptible:
 		array = next->array;
 		new_prio = recalc_task_prio(next, next->timestamp + delta);
 
+		/*
+		 * If INTERACTIVE_LIMIT is exceeded, do not promote
+		 * tasks which already have interactive status.  This
+		 * can only make things worse if the load isn't truly
+		 * interactive, so let them decay.  We also don't want
+		 * a task which has been promoted while waiting to
+		 * get CPU after wakeup to be demoted, and thus end
+		 * up being preempted immediately by a task waking
+		 * at the priority it has just reached.  Tasks which
+		 * miss the tick frequently also get caught here, so
+		 * care has to be taken to not help them along. Since
+		 * these are very likely to have interactive status,
+		 * don't ever demote a non-interactive task here, and
+		 * always considered interactive tasks to be fair game.
+		 */
+		if ((throttle && next_interactive && new_prio < next->prio) ||
+			(!next_interactive && new_prio > next->prio))
+			goto switch_tasks;
+
 		if (unlikely(next->prio != new_prio)) {
 			dequeue_task(next, array);
 			next->prio = new_prio;
 			enqueue_task(next, array);
 		}
 	}
-	next->sleep_type = SLEEP_NORMAL;
 switch_tasks:
+	next->sleep_type = SLEEP_NORMAL;
 	if (next == rq->idle)
 		schedstat_inc(rq, sched_goidle);
 	prefetch(next);
@@ -3411,6 +3791,14 @@ switch_tasks:
 		prev->sleep_avg = 0;
 	prev->timestamp = prev->last_ran = now;
 
+	/*
+	 * Tag start of execution of a new timeslice.
+	 */
+	if (unlikely(slice_is_new(next))) {
+		next->last_slice = jiffies;
+		clr_slice_is_new(next);
+	}
+
 	sched_info_switch(prev, next);
 	if (likely(prev != next)) {
 		next->timestamp = next->last_ran = now;
@@ -4081,7 +4469,8 @@ recheck:
 	if (policy < 0)
 		policy = oldpolicy = p->policy;
 	else if (policy != SCHED_FIFO && policy != SCHED_RR &&
-			policy != SCHED_NORMAL && policy != SCHED_BATCH)
+			policy != SCHED_NORMAL && policy != SCHED_BATCH &&
+			policy != SCHED_INTERACTIVE)
 		return -EINVAL;
 	/*
 	 * Valid priorities for SCHED_FIFO and SCHED_RR are
@@ -4619,6 +5008,7 @@ asmlinkage long sys_sched_get_priority_m
 		break;
 	case SCHED_NORMAL:
 	case SCHED_BATCH:
+	case SCHED_INTERACTIVE:
 		ret = 0;
 		break;
 	}
@@ -4643,6 +5033,7 @@ asmlinkage long sys_sched_get_priority_m
 		break;
 	case SCHED_NORMAL:
 	case SCHED_BATCH:
+	case SCHED_INTERACTIVE:
 		ret = 0;
 	}
 	return ret;
@@ -6739,6 +7130,7 @@ void __init sched_init(void)
 		rq->active = rq->arrays;
 		rq->expired = rq->arrays + 1;
 		rq->best_expired_prio = MAX_PRIO;
+		rq->slice_avg = STARVATION_LIMIT;
 
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -76,6 +76,9 @@ extern int pid_max_min, pid_max_max;
 extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
 extern int compat_log;
+extern int credit_c1;
+extern int credit_c2;
+extern int credit_max;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
@@ -204,6 +207,13 @@ static ctl_table root_table[] = {
 	{ .ctl_name = 0 }
 };
 
+/*
+ * Constants for minimum and maximum testing in vm_table and
+ * kern_table.  We use these as one-element integer vectors.
+*/
+static int zero;
+static int one_hundred = 100;
+
 static ctl_table kern_table[] = {
 	{
 		.ctl_name	= KERN_PANIC,
@@ -611,16 +621,31 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
-
+	{
+		.ctl_name	= KERN_SCHED_THROTTLE1,
+		.procname	= "credit_c1",
+		.data		= &credit_c1,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &credit_max,
+	},
+	{
+		.ctl_name	= KERN_SCHED_THROTTLE2,
+		.procname	= "credit_c2",
+		.data		= &credit_c2,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &credit_max,
+	},
 	{ .ctl_name = 0 }
 };
 
-/* Constants for minimum and maximum testing in vm_table.
-   We use these as one-element integer vectors. */
-static int zero;
-static int one_hundred = 100;
-
-
 static ctl_table vm_table[] = {
 	{
 		.ctl_name	= VM_OVERCOMMIT_MEMORY,

--5mCyUwZo2JvN/JJP--
