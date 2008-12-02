Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYLBWWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYLBWWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 17:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYLBWWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 17:22:11 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:41026 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbYLBWWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:22:03 -0500
Date: Tue, 2 Dec 2008 14:21:58 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: cl@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org,
       manfred@colorfullife.com, dipankar@in.ibm.com, josht@linux.vnet.ibm.com,
       schamp@sgi.com, niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       penberg@cs.helsinki.fi, andi@firstfloor.org, tglx@linutronix.de
Subject: [PATCH -tip] v9 scalable classic RCU implementation
Message-ID: <20081202222157.GA14911@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch fixes a long-standing performance bug in classic RCU that
results in massive internal-to-RCU lock contention on systems with
more than a few hundred CPUs.  Although this patch creates a separate
flavor of RCU for ease of review and patch maintenance, it is intended
to replace classic RCU.

This patch still handles stress better than does mainline, so I am
actually calling it ready for inclusion (and here you thought that would
never happen!).  This patch is against the -tip tree.  Nevertheless,
experience on an actual 1000+ CPU machine would still be most welcome.

Most of the changes noted below were found while creating an rcutiny
(which should permit ejecting the current rcuclassic) and while doing
detailed line-by-line documentation.

Updates from v8 (http://lkml.org/lkml/2008/11/15/139):

o	Fix a theoretical race between grace-period initialization and
	force_quiescent_state() that could occur if more than three
	jiffies were required to carry out the grace-period
	initialization.  Which it might, if you had enough CPUs.

o	Apply Ingo's printk-standardization patch.

o	Substitute local variables for repeated accesses to global
	variables.

o	Fix comment misspellings and redundant (but harmless) increments
	of ->n_rcu_pending (this latter after having explicitly added it).

o	Apply checkpatch fixes.

Updates from v7 (http://lkml.org/lkml/2008/10/10/291):

o	Fixed a number of problems noted by Gautham Shenoy, including
	the cpu-stall-detection bug that he was having difficulty
	convincing me was real.  ;-)

o	Changed cpu-stall detection to wait for ten seconds rather than
	three in order to reduce false positive, as suggested by Ingo
	Molnar.

o	Produced a design document (http://lwn.net/Articles/305782/).
	The act of writing this document uncovered a number of both
	theoretical and "here and now" bugs as noted below.

o	Fix dynticks_nesting accounting confusion, simplify WARN_ON()
	condition, fix kerneldoc comments, and add memory barriers
	in dynticks interface functions.

o	Add more data to tracing.

o	Remove unused "rcu_barrier" field from rcu_data structure.

o	Count calls to rcu_pending() from scheduling-clock interrupt
	to use as a surrogate timebase should jiffies stop counting.

o	Fix a theoretical race between force_quiescent_state() and
	grace-period initialization.  Yes, initialization does have to
	go on for some jiffies for this race to occur, but given enough
	CPUs...

Updates from v6 (http://lkml.org/lkml/2008/9/23/448):

o	Fix a number of checkpatch.pl complaints.

o	Apply review comments from Ingo Molnar and Lai Jiangshan
	on the stall-detection code.

o	Fix several bugs in !CONFIG_SMP builds.

o	Fix a misspelled config-parameter name so that RCU now announces
	at boot time if stall detection is configured.

o	Run tests on numerous combinations of configurations parameters,
	which after the fixes above, now build and run correctly.

Updates from v5 (http://lkml.org/lkml/2008/9/15/92, bad subject line):

o	Fix a compiler error in the !CONFIG_FANOUT_EXACT case (blew a
	changeset some time ago, and finally got around to retesting
	this option).

o	Fix some tracing bugs in rcupreempt that caused incorrect
	totals to be printed.

o	I now test with a more brutal random-selection online/offline
	script (attached).  Probably more brutal than it needs to be
	on the people reading it as well, but so it goes.

o	A number of optimizations and usability improvements:

	o	Make rcu_pending() ignore the grace-period timeout when
		there is no grace period in progress.

	o	Make force_quiescent_state() avoid going for a global
		lock in the case where there is no grace period in
		progress.

	o	Rearrange struct fields to improve struct layout.

	o	Make call_rcu() initiate a grace period if RCU was
		idle, rather than waiting for the next scheduling
		clock interrupt.

	o	Invoke rcu_irq_enter() and rcu_irq_exit() only when
		idle, as suggested by Andi Kleen.  I still don't
		completely trust this change, and might back it out.

	o	Make CONFIG_RCU_TRACE be the single config variable
		manipulated for all forms of RCU, instead of the prior
		confusion.

	o	Document tracing files and formats for both rcupreempt
		and rcutree.

Updates from v4 for those missing v5 given its bad subject line:

o	Separated dynticks interface so that NMIs and irqs call separate
	functions, greatly simplifying it.  In particular, this code
	no longer requires a proof of correctness.  ;-)

o	Separated dynticks state out into its own per-CPU structure,
	avoiding the duplicated accounting.

o	The case where a dynticks-idle CPU runs an irq handler that
	invokes call_rcu() is now correctly handled, forcing that CPU
	out of dynticks-idle mode.

o	Review comments have been applied (thank you all!!!).
	For but one example, fixed the dynticks-ordering issue that
	Manfred pointed out, saving me much debugging.  ;-)

o	Adjusted rcuclassic and rcupreempt to handle dynticks changes.

Attached is an updated patch to Classic RCU that applies a hierarchy,
greatly reducing the contention on the top-level lock for large machines.
This passes 10-hour concurrent rcutorture and online-offline testing on
128-CPU ppc64 without dynticks enabled, and exposes some timekeeping
bugs in presence of dynticks (exciting working on a system where
"sleep 1" hangs until interrupted...), which were fixed in the
2.6.27 kernel.  It is getting more reliable than mainline by some
measures, so the next version will be against -tip for inclusion.
See also Manfred Spraul's recent patches (or his earlier work from
2004 at http://marc.info/?l=linux-kernel&m=108546384711797&w=2).
We will converge onto a common patch in the fullness of time, but are
currently exploring different regions of the design space.  That said,
I have already gratefully stolen quite a few of Manfred's ideas.

This patch provides CONFIG_RCU_FANOUT, which controls the bushiness
of the RCU hierarchy.  Defaults to 32 on 32-bit machines and 64 on
64-bit machines.  If CONFIG_NR_CPUS is less than CONFIG_RCU_FANOUT,
there is no hierarchy.  By default, the RCU initialization code will
adjust CONFIG_RCU_FANOUT to balance the hierarchy, so strongly NUMA
architectures may choose to set CONFIG_RCU_FANOUT_EXACT to disable
this balancing, allowing the hierarchy to be exactly aligned to the
underlying hardware.  Up to two levels of hierarchy are permitted
(in addition to the root node), allowing up to 16,384 CPUs on 32-bit
systems and up to 262,144 CPUs on 64-bit systems.  I just know that I
am going to regret saying this, but this seems more than sufficient
for the foreseeable future.  (Some architectures might wish to set
CONFIG_RCU_FANOUT=4, which would limit such architectures to 64 CPUs.
If this becomes a real problem, additional levels can be added, but I
doubt that it will make a significant difference on real hardware.)

In the common case, a given CPU will manipulate its private rcu_data
structure and the rcu_node structure that it shares with its immediate
neighbors.  This can reduce both lock and memory contention by multiple
orders of magnitude, which should eliminate the need for the strange
manipulations that are reported to be required when running Linux on
very large systems.

Some shortcomings:

o	Need to change tracing to use seqfile, as suggested by
	Jiangshan.  Also need .csv-format tracing for systems with
	very large numbers of CPUs and update documentation.

	This will be provided as a separate patch.

o	More bugs will probably surface as a result of an ongoing
	line-by-line code inspection.

	Patches will be provided as required.

o	There are probably hangs, rcutorture failures, &c.  Seems
	quite stable on a 128-CPU machine, but that is kind of small
	compared to 4096 CPUs.  However, seems to do better than
	mainline.

	Patches will be provided as required.

o	The memory footprint of this version is several KB larger
	than rcuclassic.

	A separate UP-only rcutiny patch will be provided, which will
	reduce the memory footprint significantly, even compared
	to the old rcuclassic.

Credits:

o	Manfred Spraul for ideas, review comments, and bugs spotted,
	as well as some good friendly competition.  ;-)

o	Josh Triplett, Ingo Molnar, Peter Zijlstra, Mathieu Desnoyers,
	Lai Jiangshan, Andi Kleen, Andy Whitcroft, and Andrew Morton
	for reviews and comments.

o	Thomas Gleixner for much-needed help with some timer issues
	(see patches below).

o	Jon M. Tollefson, Tim Pepper, Andrew Theurer, Jose R. Santos,
	Andy Whitcroft, Darrick Wong, Nishanth Aravamudan, Anton
	Blanchard, and Nathan Lynch for keeping machines alive despite
	my heavy abuse^Wtesting.

To build, start with 2.6.28-rc3, and apply:

	http://www.rdrop.com/users/paulmck/patches/linux-2.6-tip.2008.11.29a.patch
	http://www.rdrop.com/users/paulmck/patches/2.6.28-rc3-tip-treeRCU-4.patch

The former gets you to commit #29cbda77a67cf263d636feea65d3bbc9c7de2e24
in /tip/core/rcu in the -tip tree, and the latter is the following patch.

Thoughts?

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 Documentation/RCU/00-INDEX             |    2 
 Documentation/RCU/trace.txt            |  413 ++++++++
 arch/powerpc/platforms/pseries/rtasd.c |    4 
 include/linux/hardirq.h                |   14 
 include/linux/rcupdate.h               |   10 
 include/linux/rcutree.h                |  329 +++++++
 init/Kconfig                           |   18 
 kernel/Kconfig.preempt                 |   62 +
 kernel/Makefile                        |    6 
 kernel/rcupreempt.c                    |   10 
 kernel/rcupreempt_trace.c              |   10 
 kernel/rcutree.c                       | 1541 +++++++++++++++++++++++++++++++++
 kernel/rcutree_trace.c                 |  238 +++++
 kernel/softirq.c                       |    5 
 lib/Kconfig.debug                      |   13 
 15 files changed, 2644 insertions(+), 31 deletions(-)

diff --git a/Documentation/RCU/00-INDEX b/Documentation/RCU/00-INDEX
index 461481d..7dc0695 100644
--- a/Documentation/RCU/00-INDEX
+++ b/Documentation/RCU/00-INDEX
@@ -16,6 +16,8 @@ RTFP.txt
 	- List of RCU papers (bibliography) going back to 1980.
 torture.txt
 	- RCU Torture Test Operation (CONFIG_RCU_TORTURE_TEST)
+trace.txt
+	- CONFIG_RCU_TRACE debugfs files and formats
 UP.txt
 	- RCU on Uniprocessor Systems
 whatisRCU.txt
diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
new file mode 100644
index 0000000..0688482
--- /dev/null
+++ b/Documentation/RCU/trace.txt
@@ -0,0 +1,413 @@
+CONFIG_RCU_TRACE debugfs Files and Formats
+
+
+The rcupreempt and rcutree implementations of RCU provide debugfs trace
+output that summarizes counters and state.  This information is useful for
+debugging RCU itself, and can sometimes also help to debug abuses of RCU.
+Note that the rcuclassic implementation of RCU does not provide debugfs
+trace output.
+
+The following sections describe the debugfs files and formats for
+preemptable RCU (rcupreempt) and hierarchical RCU (rcutree).
+
+
+Preemptable RCU debugfs Files and Formats
+
+This implementation of RCU provides three debugfs files under the
+top-level directory RCU: rcu/rcuctrs (which displays the per-CPU
+counters used by preemptable RCU) rcu/rcugp (which displays grace-period
+counters), and rcu/rcustats (which internal counters for debugging RCU).
+
+The output of "cat rcu/rcuctrs" looks as follows:
+
+CPU last cur F M
+  0    5  -5 0 0
+  1   -1   0 0 0
+  2    0   1 0 0
+  3    0   1 0 0
+  4    0   1 0 0
+  5    0   1 0 0
+  6    0   2 0 0
+  7    0  -1 0 0
+  8    0   1 0 0
+ggp = 26226, state = waitzero
+
+The per-CPU fields are as follows:
+
+o	"CPU" gives the CPU number.  Offline CPUs are not displayed.
+
+o	"last" gives the value of the counter that is being decremented
+	for the current grace period phase.  In the example above,
+	the counters sum to 4, indicating that there are still four
+	RCU read-side critical sections still running that started
+	before the last counter flip.
+
+o	"cur" gives the value of the counter that is currently being
+	both incremented (by rcu_read_lock()) and decremented (by
+	rcu_read_unlock()).  In the example above, the counters sum to
+	1, indicating that there is only one RCU read-side critical section
+	still running that started after the last counter flip.
+
+o	"F" indicates whether RCU is waiting for this CPU to acknowledge
+	a counter flip.  In the above example, RCU is not waiting on any,
+	which is consistent with the state being "waitzero" rather than
+	"waitack".
+
+o	"M" indicates whether RCU is waiting for this CPU to execute a
+	memory barrier.  In the above example, RCU is not waiting on any,
+	which is consistent with the state being "waitzero" rather than
+	"waitmb".
+
+o	"ggp" is the global grace-period counter.
+
+o	"state" is the RCU state, which can be one of the following:
+
+	o	"idle": there is no grace period in progress.
+
+	o	"waitack": RCU just incremented the global grace-period
+		counter, which has the effect of reversing the roles of
+		the "last" and "cur" counters above, and is waiting for
+		all the CPUs to acknowledge the flip.  Once the flip has
+		been acknowledged, CPUs will no longer be incrementing
+		what are now the "last" counters, so that their sum will
+		decrease monotonically down to zero.
+
+	o	"waitzero": RCU is waiting for the sum of the "last" counters
+		to decrease to zero.
+
+	o	"waitmb": RCU is waiting for each CPU to execute a memory
+		barrier, which ensures that instructions from a given CPU's
+		last RCU read-side critical section cannot be reordered
+		with instructions following the memory-barrier instruction.
+
+The output of "cat rcu/rcugp" looks as follows:
+
+oldggp=48870  newggp=48873
+
+Note that reading from this file provokes a synchronize_rcu().  The
+"oldggp" value is that of "ggp" from rcu/rcuctrs above, taken before
+executing the synchronize_rcu(), and the "newggp" value is also the
+"ggp" value, but taken after the synchronize_rcu() command returns.
+
+
+The output of "cat rcu/rcugp" looks as follows:
+
+na=1337955 nl=40 wa=1337915 wl=44 da=1337871 dl=0 dr=1337871 di=1337871
+1=50989 e1=6138 i1=49722 ie1=82 g1=49640 a1=315203 ae1=265563 a2=49640
+z1=1401244 ze1=1351605 z2=49639 m1=5661253 me1=5611614 m2=49639
+
+These are counters tracking internal preemptable-RCU events, however,
+some of them may be useful for debugging algorithms using RCU.  In
+particular, the "nl", "wl", and "dl" values track the number of RCU
+callbacks in various states.  The fields are as follows:
+
+o	"na" is the total number of RCU callbacks that have been enqueued
+	since boot.
+
+o	"nl" is the number of RCU callbacks waiting for the previous
+	grace period to end so that they can start waiting on the next
+	grace period.
+
+o	"wa" is the total number of RCU callbacks that have started waiting
+	for a grace period since boot.  "na" should be roughly equal to
+	"nl" plus "wa".
+
+o	"wl" is the number of RCU callbacks currently waiting for their
+	grace period to end.
+
+o	"da" is the total number of RCU callbacks whose grace periods
+	have completed since boot.  "wa" should be roughly equal to
+	"wl" plus "da".
+
+o	"dr" is the total number of RCU callbacks that have been removed
+	from the list of callbacks ready to invoke.  "dr" should be roughly
+	equal to "da".
+
+o	"di" is the total number of RCU callbacks that have been invoked
+	since boot.  "di" should be roughly equal to "da", though some
+	early versions of preemptable RCU had a bug so that only the
+	last CPU's count of invocations was displayed, rather than the
+	sum of all CPU's counts.
+
+o	"1" is the number of calls to rcu_try_flip().  This should be
+	roughly equal to the sum of "e1", "i1", "a1", "z1", and "m1"
+	described below.  In other words, the number of times that
+	the state machine is visited should be equal to the sum of the
+	number of times that each state is visited plus the number of
+	times that the state-machine lock acquisition failed.
+
+o	"e1" is the number of times that rcu_try_flip() was unable to
+	acquire the fliplock.
+
+o	"i1" is the number of calls to rcu_try_flip_idle().
+
+o	"ie1" is the number of times rcu_try_flip_idle() exited early
+	due to the calling CPU having no work for RCU.
+
+o	"g1" is the number of times that rcu_try_flip_idle() decided
+	to start a new grace period.  "i1" should be roughly equal to
+	"ie1" plus "g1".
+
+o	"a1" is the number of calls to rcu_try_flip_waitack().
+
+o	"ae1" is the number of times that rcu_try_flip_waitack() found
+	that at least one CPU had not yet acknowledge the new grace period
+	(AKA "counter flip").
+
+o	"a2" is the number of time rcu_try_flip_waitack() found that
+	all CPUs had acknowledged.  "a1" should be roughly equal to
+	"ae1" plus "a2".  (This particular output was collected on
+	a 128-CPU machine, hence the smaller-than-usual fraction of
+	calls to rcu_try_flip_waitack() finding all CPUs having already
+	acknowledged.)
+
+o	"z1" is the number of calls to rcu_try_flip_waitzero().
+
+o	"ze1" is the number of times that rcu_try_flip_waitzero() found
+	that not all of the old RCU read-side critical sections had
+	completed.
+
+o	"z2" is the number of times that rcu_try_flip_waitzero() finds
+	the sum of the counters equal to zero, in other words, that
+	all of the old RCU read-side critical sections had completed.
+	The value of "z1" should be roughly equal to "ze1" plus
+	"z2".
+
+o	"m1" is the number of calls to rcu_try_flip_waitmb().
+
+o	"me1" is the number of times that rcu_try_flip_waitmb() finds
+	that at least one CPU has not yet executed a memory barrier.
+
+o	"m2" is the number of times that rcu_try_flip_waitmb() finds that
+	all CPUs have executed a memory barrier.
+
+
+Hierarchical RCU debugfs Files and Formats
+
+This implementation of RCU provides three debugfs files under the
+top-level directory RCU: rcu/rcudata (which displays fields in struct
+rcu_data), rcu/rcugp (which displays grace-period counters), and
+rcu/rcuhier (which displays the struct rcu_node hierarchy).
+
+The output of "cat rcu/rcudata" looks as follows:
+
+rcu:
+  0 c=4011 g=4012 pq=1 pqc=4011 qp=0 rpfq=1 rp=3c2a dt=23301/73 dn=2 df=1882 of=0 ri=2126 ql=2 b=10
+  1 c=4011 g=4012 pq=1 pqc=4011 qp=0 rpfq=3 rp=39a6 dt=78073/1 dn=2 df=1402 of=0 ri=1875 ql=46 b=10
+  2 c=4010 g=4010 pq=1 pqc=4010 qp=0 rpfq=-5 rp=1d12 dt=16646/0 dn=2 df=3140 of=0 ri=2080 ql=0 b=10
+  3 c=4012 g=4013 pq=1 pqc=4012 qp=1 rpfq=3 rp=2b50 dt=21159/1 dn=2 df=2230 of=0 ri=1923 ql=72 b=10
+  4 c=4012 g=4013 pq=1 pqc=4012 qp=1 rpfq=3 rp=1644 dt=5783/1 dn=2 df=3348 of=0 ri=2805 ql=7 b=10
+  5 c=4012 g=4013 pq=0 pqc=4011 qp=1 rpfq=3 rp=1aac dt=5879/1 dn=2 df=3140 of=0 ri=2066 ql=10 b=10
+  6 c=4012 g=4013 pq=1 pqc=4012 qp=1 rpfq=3 rp=ed8 dt=5847/1 dn=2 df=3797 of=0 ri=1266 ql=10 b=10
+  7 c=4012 g=4013 pq=1 pqc=4012 qp=1 rpfq=3 rp=1fa2 dt=6199/1 dn=2 df=2795 of=0 ri=2162 ql=28 b=10
+rcu_bh:
+  0 c=-268 g=-268 pq=1 pqc=-268 qp=0 rpfq=-145 rp=21d6 dt=23301/73 dn=2 df=0 of=0 ri=0 ql=0 b=10
+  1 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-170 rp=20ce dt=78073/1 dn=2 df=26 of=0 ri=5 ql=0 b=10
+  2 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-83 rp=fbd dt=16646/0 dn=2 df=28 of=0 ri=4 ql=0 b=10
+  3 c=-268 g=-268 pq=1 pqc=-268 qp=0 rpfq=-105 rp=178c dt=21159/1 dn=2 df=28 of=0 ri=2 ql=0 b=10
+  4 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-30 rp=b54 dt=5783/1 dn=2 df=32 of=0 ri=0 ql=0 b=10
+  5 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-29 rp=df5 dt=5879/1 dn=2 df=30 of=0 ri=3 ql=0 b=10
+  6 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-28 rp=788 dt=5847/1 dn=2 df=32 of=0 ri=0 ql=0 b=10
+  7 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-53 rp=1098 dt=6199/1 dn=2 df=30 of=0 ri=3 ql=0 b=10
+
+The first section lists the rcu_data structures for rcu, the second for
+rcu_bh.  Each section has one line per CPU, or eight for this 8-CPU system.
+The fields are as follows:
+
+o	The number at the beginning of each line is the CPU number.
+	CPUs numbers followed by an exclamation mark are offline,
+	but have been online at least once since boot.	There will be
+	no output for CPUs that have never been online, which can be
+	a good thing in the surprisingly common case where NR_CPUS is
+	substantially larger than the number of actual CPUs.
+
+o	"c" is the count of grace periods that this CPU believes have
+	completed.  CPUs in dynticks idle mode may lag quite a ways
+	behind, for example, CPU 4 under "rcu" above, which has slept
+	through the past 25 RCU grace periods.	It is not unusual to
+	see CPUs lagging by thousands of grace periods.
+
+o	"g" is the count of grace periods that this CPU believes have
+	started.  Again, CPUs in dynticks idle mode may lag behind.
+	If the "c" and "g" values are equal, this CPU has already
+	reported a quiescent state for the last RCU grace period that
+	it is aware of, otherwise, the CPU believes that it owes RCU a
+	quiescent state.
+
+o	"pq" indicates that this CPU has passed through a quiescent state
+	for the current grace period.  It is possible for "pq" to be
+	"1" and "c" different than "g", which indicates that although
+	the CPU has passed through a quiescent state, either (1) this
+	CPU has not yet reported that fact, (2) some other CPU has not
+	yet reported for this grace period, or (3) both.
+
+o	"pqc" indicates which grace period the last-observed quiescent
+	state for this CPU corresponds to.  This is important for handling
+	the race between CPU 0 reporting an extended dynticks-idle
+	quiescent state for CPU 1 and CPU 1 suddenly waking up and
+	reporting its own quiescent state.  If CPU 1 was the last CPU
+	for the current grace period, then the CPU that loses this race
+	will attempt to incorrectly mark CPU 1 as having checked in for
+	the next grace period!
+
+o	"qp" indicates that RCU still expects a quiescent state from
+	this CPU.
+
+o	"rpfq" is the number of rcu_pending() calls on this CPU required
+	to induce this CPU to invoke force_quiescent_state().
+
+o	"rp" is low-order four hex digits of the count of how many times
+	rcu_pending() has been invoked on this CPU.
+
+o	"dt" is the current value of the dyntick counter that is incremented
+	when entering or leaving dynticks idle state, either by the
+	scheduler or by irq.  The number after the "/" is the interrupt
+	nesting depth when in dyntick-idle state, or one greater than
+	the interrupt-nesting depth otherwise.
+
+	This field is displayed only for CONFIG_NO_HZ kernels.
+
+o	"dn" is the current value of the dyntick counter that is incremented
+	when entering or leaving dynticks idle state via NMI.  If both
+	the "dt" and "dn" values are even, then this CPU is in dynticks
+	idle mode and may be ignored by RCU.  If either of these two
+	counters is odd, then RCU must be alert to the possibility of
+	an RCU read-side critical section running on this CPU.
+
+	This field is displayed only for CONFIG_NO_HZ kernels.
+
+o	"df" is the number of times that some other CPU has forced a
+	quiescent state on behalf of this CPU due to this CPU being in
+	dynticks-idle state.
+
+	This field is displayed only for CONFIG_NO_HZ kernels.
+
+o	"of" is the number of times that some other CPU has forced a
+	quiescent state on behalf of this CPU due to this CPU being
+	offline.  In a perfect world, this might neve happen, but it
+	turns out that offlining and onlining a CPU can take several grace
+	periods, and so there is likely to be an extended period of time
+	when RCU believes that the CPU is online when it really is not.
+	Please note that erring in the other direction (RCU believing a
+	CPU is offline when it is really alive and kicking) is a fatal
+	error, so it makes sense to err conservatively.
+
+o	"ri" is the number of times that RCU has seen fit to send a
+	reschedule IPI to this CPU in order to get it to report a
+	quiescent state.
+
+o	"ql" is the number of RCU callbacks currently residing on
+	this CPU.  This is the total number of callbacks, regardless
+	of what state they are in (new, waiting for grace period to
+	start, waiting for grace period to end, ready to invoke).
+
+o	"b" is the batch limit for this CPU.  If more than this number
+	of RCU callbacks is ready to invoke, then the remainder will
+	be deferred.
+
+
+The output of "cat rcu/rcugp" looks as follows:
+
+rcu: completed=33062  gpnum=33063
+rcu_bh: completed=464  gpnum=464
+
+Again, this output is for both "rcu" and "rcu_bh".  The fields are
+taken from the rcu_state structure, and are as follows:
+
+o	"completed" is the number of grace periods that have completed.
+	It is comparable to the "c" field from rcu/rcudata in that a
+	CPU whose "c" field matches the value of "completed" is aware
+	that the corresponding RCU grace period has completed.
+
+o	"gpnum" is the number of grace periods that have started.  It is
+	comparable to the "g" field from rcu/rcudata in that a CPU
+	whose "g" field matches the value of "gpnum" is aware that the
+	corresponding RCU grace period has started.
+
+	If these two fields are equal (as they are for "rcu_bh" above),
+	then there is no grace period in progress, in other words, RCU
+	is idle.  On the other hand, if the two fields differ (as they
+	do for "rcu" above), then an RCU grace period is in progress.
+
+
+The output of "cat rcu/rcuhier" looks as follows, with very long lines:
+
+c=6902 g=6903 s=2 jfq=3 j=72c7 nfqs=13142/nfqsng=0(13142) fqlh=6
+1/1 0:127 ^0    
+3/3 0:35 ^0    0/0 36:71 ^1    0/0 72:107 ^2    0/0 108:127 ^3    
+3/3f 0:5 ^0    2/3 6:11 ^1    0/0 12:17 ^2    0/0 18:23 ^3    0/0 24:29 ^4    0/0 30:35 ^5    0/0 36:41 ^0    0/0 42:47 ^1    0/0 48:53 ^2    0/0 54:59 ^3    0/0 60:65 ^4    0/0 66:71 ^5    0/0 72:77 ^0    0/0 78:83 ^1    0/0 84:89 ^2    0/0 90:95 ^3    0/0 96:101 ^4    0/0 102:107 ^5    0/0 108:113 ^0    0/0 114:119 ^1    0/0 120:125 ^2    0/0 126:127 ^3    
+rcu_bh:
+c=-226 g=-226 s=1 jfq=-5701 j=72c7 nfqs=88/nfqsng=0(88) fqlh=0
+0/1 0:127 ^0    
+0/3 0:35 ^0    0/0 36:71 ^1    0/0 72:107 ^2    0/0 108:127 ^3    
+0/3f 0:5 ^0    0/3 6:11 ^1    0/0 12:17 ^2    0/0 18:23 ^3    0/0 24:29 ^4    0/0 30:35 ^5    0/0 36:41 ^0    0/0 42:47 ^1    0/0 48:53 ^2    0/0 54:59 ^3    0/0 60:65 ^4    0/0 66:71 ^5    0/0 72:77 ^0    0/0 78:83 ^1    0/0 84:89 ^2    0/0 90:95 ^3    0/0 96:101 ^4    0/0 102:107 ^5    0/0 108:113 ^0    0/0 114:119 ^1    0/0 120:125 ^2    0/0 126:127 ^3
+
+This is once again split into "rcu" and "rcu_bh" portions.  The fields are
+as follows:
+
+o	"c" is exactly the same as "completed" under rcu/rcugp.
+
+o	"g" is exactly the same as "gpnum" under rcu/rcugp.
+
+o	"s" is the "signaled" state that drives force_quiescent_state()'s
+	state machine.
+
+o	"jfq" is the number of jiffies remaining for this grace period
+	before force_quiescent_state() is invoked to help push things
+	along.  Note that CPUs in dyntick-idle mode thoughout the grace
+	period will not report on their own, but rather must be check by
+	some other CPU via force_quiescent_state().
+
+o	"j" is the low-order four hex digits of the jiffies counter.
+	Yes, Paul did run into a number of problems that turned out to
+	be due to the jiffies counter no longer counting.  Why do you ask?
+
+o	"nfqs" is the number of calls to force_quiescent_state() since
+	boot.
+
+o	"nfqsng" is the number of useless calls to force_quiescent_state(),
+	where there wasn't actually a grace period active.  This can
+	happen due to races.  The number in parentheses is the difference
+	between "nfqs" and "nfqsng", or the number of times that
+	force_quiescent_state() actually did some real work.
+
+o	"fqlh" is the number of calls to force_quiescent_state() that
+	exited immediately (without even being counted in nfqs above)
+	due to contention on ->fqslock.
+
+o	Each element of the form "1/1 0:127 ^0" represents one struct
+	rcu_node.  Each line represents one level of the hierarchy, from
+	root to leaves.  It is best to think of the rcu_data structures
+	as forming yet another level after the leaves.  Note that there
+	might be either one, two, or three levels of rcu_node structures,
+	depending on the relationship between CONFIG_RCU_FANOUT and
+	CONFIG_NR_CPUS.
+	
+	o	The numbers separated by the "/" are the qsmask followed
+		by the qsmaskinit.  The qsmask will have one bit
+		set for each entity in the next lower level that
+		has not yet checked in for the current grace period.
+		The qsmaskinit will have one bit for each entity that is
+		currently expected to check in during each grace period.
+		The value of qsmaskinit is assigned to that of qsmask
+		at the beginning of each grace period.
+
+		For example, for "rcu", the qsmask of the first entry
+		of the lowest level is 0x14, meaning that we are still
+		waiting for CPUs 2 and 4 to check in for the current
+		grace period.
+
+	o	The numbers separated by the ":" are the range of CPUs
+		served by this struct rcu_node.  This can be helpful
+		in working out how the hierarchy is wired together.
+
+		For example, the first entry at the lowest level shows
+		"0:5", indicating that it covers CPUs 0 through 5.
+
+	o	The number after the "^" indicates the bit in the
+		next higher level rcu_node structure that this
+		rcu_node structure corresponds to.
+
+		For example, the first entry at the lowest level shows
+		"^0", indicating that it corresponds to bit zero in
+		the first entry at the middle level.
diff --git a/arch/powerpc/platforms/pseries/rtasd.c b/arch/powerpc/platforms/pseries/rtasd.c
index f4e55be..afad9f5 100644
--- a/arch/powerpc/platforms/pseries/rtasd.c
+++ b/arch/powerpc/platforms/pseries/rtasd.c
@@ -208,6 +208,7 @@ void pSeries_log_error(char *buf, unsigned int err_type, int fatal)
 		break;
 	case ERR_TYPE_KERNEL_PANIC:
 	default:
+		WARN_ON_ONCE(!irqs_disabled()); /* @@@ DEBUG @@@ */
 		spin_unlock_irqrestore(&rtasd_log_lock, s);
 		return;
 	}
@@ -227,6 +228,7 @@ void pSeries_log_error(char *buf, unsigned int err_type, int fatal)
 	/* Check to see if we need to or have stopped logging */
 	if (fatal || !logging_enabled) {
 		logging_enabled = 0;
+		WARN_ON_ONCE(!irqs_disabled()); /* @@@ DEBUG @@@ */
 		spin_unlock_irqrestore(&rtasd_log_lock, s);
 		return;
 	}
@@ -249,11 +251,13 @@ void pSeries_log_error(char *buf, unsigned int err_type, int fatal)
 		else
 			rtas_log_start += 1;
 
+		WARN_ON_ONCE(!irqs_disabled()); /* @@@ DEBUG @@@ */
 		spin_unlock_irqrestore(&rtasd_log_lock, s);
 		wake_up_interruptible(&rtas_log_wait);
 		break;
 	case ERR_TYPE_KERNEL_PANIC:
 	default:
+		WARN_ON_ONCE(!irqs_disabled()); /* @@@ DEBUG @@@ */
 		spin_unlock_irqrestore(&rtasd_log_lock, s);
 		return;
 	}
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 181006c..9b70b92 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -118,13 +118,17 @@ static inline void account_system_vtime(struct task_struct *tsk)
 }
 #endif
 
-#if defined(CONFIG_PREEMPT_RCU) && defined(CONFIG_NO_HZ)
+#if defined(CONFIG_NO_HZ) && !defined(CONFIG_CLASSIC_RCU)
 extern void rcu_irq_enter(void);
 extern void rcu_irq_exit(void);
+extern void rcu_nmi_enter(void);
+extern void rcu_nmi_exit(void);
 #else
 # define rcu_irq_enter() do { } while (0)
 # define rcu_irq_exit() do { } while (0)
-#endif /* CONFIG_PREEMPT_RCU */
+# define rcu_nmi_enter() do { } while (0)
+# define rcu_nmi_exit() do { } while (0)
+#endif /* #if defined(CONFIG_NO_HZ) && !defined(CONFIG_CLASSIC_RCU) */
 
 /*
  * It is safe to do non-atomic ops on ->hardirq_context,
@@ -134,7 +138,6 @@ extern void rcu_irq_exit(void);
  */
 #define __irq_enter()					\
 	do {						\
-		rcu_irq_enter();			\
 		account_system_vtime(current);		\
 		add_preempt_count(HARDIRQ_OFFSET);	\
 		trace_hardirq_enter();			\
@@ -153,7 +156,6 @@ extern void irq_enter(void);
 		trace_hardirq_exit();			\
 		account_system_vtime(current);		\
 		sub_preempt_count(HARDIRQ_OFFSET);	\
-		rcu_irq_exit();				\
 	} while (0)
 
 /*
@@ -161,7 +163,7 @@ extern void irq_enter(void);
  */
 extern void irq_exit(void);
 
-#define nmi_enter()		do { lockdep_off(); __irq_enter(); } while (0)
-#define nmi_exit()		do { __irq_exit(); lockdep_on(); } while (0)
+#define nmi_enter()		do { lockdep_off(); rcu_nmi_enter(); __irq_enter(); } while (0)
+#define nmi_exit()		do { __irq_exit(); rcu_nmi_exit(); lockdep_on(); } while (0)
 
 #endif /* LINUX_HARDIRQ_H */
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 86f1f5e..bfd289a 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -52,11 +52,15 @@ struct rcu_head {
 	void (*func)(struct rcu_head *head);
 };
 
-#ifdef CONFIG_CLASSIC_RCU
+#if defined(CONFIG_CLASSIC_RCU)
 #include <linux/rcuclassic.h>
-#else /* #ifdef CONFIG_CLASSIC_RCU */
+#elif defined(CONFIG_TREE_RCU)
+#include <linux/rcutree.h>
+#elif defined(CONFIG_PREEMPT_RCU)
 #include <linux/rcupreempt.h>
-#endif /* #else #ifdef CONFIG_CLASSIC_RCU */
+#else
+#error "Unknown RCU implementation specified to kernel configuration"
+#endif /* #else #if defined(CONFIG_CLASSIC_RCU) */
 
 #define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL }
 #define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
new file mode 100644
index 0000000..d4368b7
--- /dev/null
+++ b/include/linux/rcutree.h
@@ -0,0 +1,329 @@
+/*
+ * Read-Copy Update mechanism for mutual exclusion (tree-based version)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2008
+ *
+ * Author: Dipankar Sarma <dipankar@in.ibm.com>
+ *	   Paul E. McKenney <paulmck@linux.vnet.ibm.com> Hierarchical algorithm
+ *
+ * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
+ * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
+ *
+ * For detailed explanation of Read-Copy Update mechanism see -
+ * 	Documentation/RCU
+ */
+
+#ifndef __LINUX_RCUTREE_H
+#define __LINUX_RCUTREE_H
+
+#include <linux/cache.h>
+#include <linux/spinlock.h>
+#include <linux/threads.h>
+#include <linux/percpu.h>
+#include <linux/cpumask.h>
+#include <linux/seqlock.h>
+
+/*
+ * Define shape of hierarchy based on NR_CPUS and CONFIG_RCU_FANOUT.
+ * In theory, it should be possible to add more levels straightforwardly.
+ * In practice, this has not been tested, so there is probably some
+ * bug somewhere.
+ */
+#define MAX_RCU_LVLS 3
+#define RCU_FANOUT	      (CONFIG_RCU_FANOUT)
+#define RCU_FANOUT_SQ	      (RCU_FANOUT * RCU_FANOUT)
+#define RCU_FANOUT_CUBE	      (RCU_FANOUT_SQ * RCU_FANOUT)
+
+#if NR_CPUS <= RCU_FANOUT
+#  define NUM_RCU_LVLS	      1
+#  define NUM_RCU_LVL_0	      1
+#  define NUM_RCU_LVL_1	      (NR_CPUS)
+#  define NUM_RCU_LVL_2	      0
+#  define NUM_RCU_LVL_3	      0
+#elif NR_CPUS <= RCU_FANOUT_SQ
+#  define NUM_RCU_LVLS	      2
+#  define NUM_RCU_LVL_0	      1
+#  define NUM_RCU_LVL_1	      (((NR_CPUS) + RCU_FANOUT - 1) / RCU_FANOUT)
+#  define NUM_RCU_LVL_2	      (NR_CPUS)
+#  define NUM_RCU_LVL_3	      0
+#elif NR_CPUS <= RCU_FANOUT_CUBE
+#  define NUM_RCU_LVLS	      3
+#  define NUM_RCU_LVL_0	      1
+#  define NUM_RCU_LVL_1	      (((NR_CPUS) + RCU_FANOUT_SQ - 1) / RCU_FANOUT_SQ)
+#  define NUM_RCU_LVL_2	      (((NR_CPUS) + (RCU_FANOUT) - 1) / (RCU_FANOUT))
+#  define NUM_RCU_LVL_3	      NR_CPUS
+#else
+# error "CONFIG_RCU_FANOUT insufficient for NR_CPUS"
+#endif /* #if (NR_CPUS) <= RCU_FANOUT */
+
+#define RCU_SUM (NUM_RCU_LVL_0 + NUM_RCU_LVL_1 + NUM_RCU_LVL_2 + NUM_RCU_LVL_3)
+#define NUM_RCU_NODES (RCU_SUM - NR_CPUS)
+
+/*
+ * Dynticks per-CPU state.
+ */
+struct rcu_dynticks {
+	int dynticks_nesting;	/* Track nesting level, sort of. */
+	int dynticks;		/* Even value for dynticks-idle, else odd. */
+	int dynticks_nmi;	/* Even value for either dynticks-idle or */
+				/*  not in nmi handler, else odd.  So this */
+				/*  remains even for nmi from irq handler. */
+};
+
+/*
+ * Definition for node within the RCU grace-period-detection hierarchy.
+ */
+struct rcu_node {
+	spinlock_t lock;
+	unsigned long qsmask;	/* CPUs or groups that need to switch in */
+				/*  order for current grace period to proceed.*/
+	unsigned long qsmaskinit;
+				/* Per-GP initialization for qsmask. */
+	unsigned long grpmask;	/* Mask to apply to parent qsmask. */
+	int	grplo;		/* lowest-numbered CPU or group here. */
+	int	grphi;		/* highest-numbered CPU or group here. */
+	u8	grpnum;		/* CPU/group number for next level up. */
+	u8	level;		/* root is at level 0. */
+	struct rcu_node *parent;
+} ____cacheline_internodealigned_in_smp;
+
+/* Index values for nxttail array in struct rcu_data. */
+#define RCU_DONE_TAIL		0	/* Also RCU_WAIT head. */
+#define RCU_WAIT_TAIL		1	/* Also RCU_NEXT_READY head. */
+#define RCU_NEXT_READY_TAIL	2	/* Also RCU_NEXT head. */
+#define RCU_NEXT_TAIL		3
+#define RCU_NEXT_SIZE		4
+
+/* Per-CPU data for read-copy update. */
+struct rcu_data {
+	/* 1) quiescent-state and grace-period handling : */
+	long		completed;	/* Track rsp->completed gp number */
+					/*  in order to detect GP end. */
+	long		gpnum;		/* Highest gp number that this CPU */
+					/*  is aware of having started. */
+	long		passed_quiesc_completed;
+					/* Value of completed at time of qs. */
+	bool		passed_quiesc;	/* User-mode/idle loop etc. */
+	bool		qs_pending;	/* Core waits for quiesc state. */
+	bool		beenonline;	/* CPU online at least once. */
+	struct rcu_node *mynode;	/* This CPU's leaf of hierarchy */
+	unsigned long grpmask;		/* Mask to apply to leaf qsmask. */
+
+	/* 2) batch handling */
+	/*
+	 * If nxtlist is not NULL, it is partitioned as follows.
+	 * Any of the partitions might be empty, in which case the
+	 * pointer to that partition will be equal to the pointer for
+	 * the following partition.  When the list is empty, all of
+	 * the nxttail elements point to nxtlist, which is NULL.
+	 *
+	 * [*nxttail[RCU_NEXT_READY_TAIL], NULL = *nxttail[RCU_NEXT_TAIL]):
+	 *	Entries that might have arrived after current GP ended
+	 * [*nxttail[RCU_WAIT_TAIL], *nxttail[RCU_NEXT_READY_TAIL]):
+	 *	Entries known to have arrived before current GP ended
+	 * [*nxttail[RCU_DONE_TAIL], *nxttail[RCU_WAIT_TAIL]):
+	 *	Entries that batch # <= ->completed - 1: waiting for current GP
+	 * [nxtlist, *nxttail[RCU_DONE_TAIL]):
+	 *	Entries that batch # <= ->completed
+	 *	The grace period for these entries has completed, and
+	 *	the other grace-period-completed entries may be moved
+	 *	here temporarily in rcu_process_callbacks().
+	 */
+	struct rcu_head *nxtlist;
+	struct rcu_head **nxttail[RCU_NEXT_SIZE];
+	long		qlen; 	 	/* # of queued callbacks */
+	long		blimit;		/* Upper limit on a processed batch */
+
+#ifdef CONFIG_NO_HZ
+	/* 3) dynticks interface. */
+	struct rcu_dynticks *dynticks;	/* Shared per-CPU dynticks state. */
+	int dynticks_snap;		/* Per-GP tracking for dynticks. */
+	int dynticks_nmi_snap;		/* Per-GP tracking for dynticks_nmi. */
+#endif /* #ifdef CONFIG_NO_HZ */
+
+	/* 4) reasons this CPU needed to be kicked by force_quiescent_state */
+#ifdef CONFIG_NO_HZ
+	unsigned long dynticks_fqs;	/* Kicked due to dynticks idle. */
+#endif /* #ifdef CONFIG_NO_HZ */
+	unsigned long offline_fqs;	/* Kicked due to being offline. */
+	unsigned long resched_ipi;	/* Sent a resched IPI. */
+
+	/* 5) state to allow this CPU to force_quiescent_state on others */
+	long n_rcu_pending;		/* rcu_pending() calls since boot. */
+	long n_rcu_pending_force_qs;	/* when to force quiescent states. */
+
+	int cpu;
+};
+
+/* Values for signaled field in struct rcu_state. */
+#define RCU_GP_INIT		0	/* Grace period being initialized. */
+#define RCU_SAVE_DYNTICK	1	/* Need to scan dyntick state. */
+#define RCU_FORCE_QS		2	/* Need to force quiescent state. */
+#ifdef CONFIG_NO_HZ
+#define RCU_SIGNAL_INIT		RCU_SAVE_DYNTICK
+#else /* #ifdef CONFIG_NO_HZ */
+#define RCU_SIGNAL_INIT		RCU_FORCE_QS
+#endif /* #else #ifdef CONFIG_NO_HZ */
+
+#define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+#define RCU_SECONDS_TILL_STALL_CHECK   (10 * HZ)  /* for rsp->jiffies_stall */
+#define RCU_SECONDS_TILL_STALL_RECHECK (30 * HZ)  /* for rsp->jiffies_stall */
+#define RCU_STALL_RAT_DELAY		2	  /* Allow other CPUs time */
+						  /*  to take at least one */
+						  /*  scheduling clock irq */
+						  /*  before ratting on them. */
+
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+
+/*
+ * RCU global state, including node hierarchy.  This hierarchy is
+ * represented in "heap" form in a dense array.  The root (first level)
+ * of the hierarchy is in ->node[0] (referenced by ->level[0]), the second
+ * level in ->node[1] through ->node[m] (->node[1] referenced by ->level[1]),
+ * and the third level in ->node[m+1] and following (->node[m+1] referenced
+ * by ->level[2]).  The number of levels is determined by the number of
+ * CPUs and by CONFIG_RCU_FANOUT.  Small systems will have a "hierarchy"
+ * consisting of a single rcu_node.
+ */
+struct rcu_state {
+	struct rcu_node node[NUM_RCU_NODES];	/* Hierarchy. */
+	struct rcu_node *level[NUM_RCU_LVLS];	/* Hierarchy levels. */
+	u32 levelcnt[MAX_RCU_LVLS + 1];		/* # nodes in each level. */
+	u8 levelspread[NUM_RCU_LVLS];		/* kids/node in each level. */
+	struct rcu_data *rda[NR_CPUS];		/* array of rdp pointers. */
+
+	/* The following fields are guarded by the root rcu_node's lock. */
+
+	u8	signaled ____cacheline_internodealigned_in_smp;
+						/* Force QS state. */
+	long	gpnum;				/* Current gp number. */
+	long	completed;			/* # of last completed gp. */
+	spinlock_t onofflock;			/* exclude on/offline and */
+						/*  starting new GP. */
+	spinlock_t fqslock;			/* Only one task forcing */
+						/*  quiescent states. */
+	unsigned long jiffies_force_qs;		/* Time at which to invoke */
+						/*  force_quiescent_state(). */
+	unsigned long n_force_qs;		/* Number of calls to */
+						/*  force_quiescent_state(). */
+	unsigned long n_force_qs_lh;		/* ~Number of calls leaving */
+						/*  due to lock unavailable. */
+	unsigned long n_force_qs_ngp;		/* Number of calls leaving */
+						/*  due to no GP active. */
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+	unsigned long gp_start;			/* Time at which GP started, */
+						/*  but in jiffies. */
+	unsigned long jiffies_stall;		/* Time at which to check */
+						/*  for CPU stalls. */
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+#ifdef CONFIG_NO_HZ
+	long dynticks_completed;		/* Value of completed @ snap. */
+#endif /* #ifdef CONFIG_NO_HZ */
+};
+
+extern struct rcu_state rcu_state;
+DECLARE_PER_CPU(struct rcu_data, rcu_data);
+
+extern struct rcu_state rcu_bh_state;
+DECLARE_PER_CPU(struct rcu_data, rcu_bh_data);
+
+/*
+ * Increment the quiescent state counter.
+ * The counter is a bit degenerated: We do not need to know
+ * how many quiescent states passed, just if there was at least
+ * one since the start of the grace period. Thus just a flag.
+ */
+static inline void rcu_qsctr_inc(int cpu)
+{
+	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
+	rdp->passed_quiesc = 1;
+	rdp->passed_quiesc_completed = rdp->completed;
+}
+static inline void rcu_bh_qsctr_inc(int cpu)
+{
+	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
+	rdp->passed_quiesc = 1;
+	rdp->passed_quiesc_completed = rdp->completed;
+}
+
+extern int rcu_pending(int cpu);
+extern int rcu_needs_cpu(int cpu);
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+extern struct lockdep_map rcu_lock_map;
+# define rcu_read_acquire()	\
+			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
+# define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
+#else
+# define rcu_read_acquire()	do { } while (0)
+# define rcu_read_release()	do { } while (0)
+#endif
+
+static inline void __rcu_read_lock(void)
+{
+	preempt_disable();
+	__acquire(RCU);
+	rcu_read_acquire();
+}
+static inline void __rcu_read_unlock(void)
+{
+	rcu_read_release();
+	__release(RCU);
+	preempt_enable();
+}
+static inline void __rcu_read_lock_bh(void)
+{
+	local_bh_disable();
+	__acquire(RCU_BH);
+	rcu_read_acquire();
+}
+static inline void __rcu_read_unlock_bh(void)
+{
+	rcu_read_release();
+	__release(RCU_BH);
+	local_bh_enable();
+}
+
+#define __synchronize_sched() synchronize_rcu()
+
+#define call_rcu_sched(head, func) call_rcu(head, func)
+
+static inline void rcu_init_sched(void)
+{
+}
+
+extern void __rcu_init(void);
+extern void rcu_check_callbacks(int cpu, int user);
+extern void rcu_restart_cpu(int cpu);
+
+extern long rcu_batches_completed(void);
+extern long rcu_batches_completed_bh(void);
+
+#ifdef CONFIG_NO_HZ
+void rcu_enter_nohz(void);
+void rcu_exit_nohz(void);
+#else /* CONFIG_NO_HZ */
+static inline void rcu_enter_nohz(void)
+{
+}
+static inline void rcu_exit_nohz(void)
+{
+}
+#endif /* CONFIG_NO_HZ */
+
+#endif /* __LINUX_RCUTREE_H */
diff --git a/init/Kconfig b/init/Kconfig
index 86b00c5..1467130 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -928,10 +928,16 @@ source "block/Kconfig"
 config PREEMPT_NOTIFIERS
 	bool
 
-config CLASSIC_RCU
-	def_bool !PREEMPT_RCU
+config TREE_RCU_TRACE
+	def_bool RCU_TRACE && TREE_RCU
+	select DEBUG_FS
 	help
-	  This option selects the classic RCU implementation that is
-	  designed for best read-side performance on non-realtime
-	  systems.  Classic RCU is the default.  Note that the
-	  PREEMPT_RCU symbol is used to select/deselect this option.
+	  This option provides tracing for the TREE_RCU implementation,
+	  permitting Makefile to trivially select kernel/rcutree_trace.c.
+
+config PREEMPT_RCU_TRACE
+	def_bool RCU_TRACE && PREEMPT_RCU
+	select DEBUG_FS
+	help
+	  This option provides tracing for the PREEMPT_RCU implementation,
+	  permitting Makefile to trivially select kernel/rcupreempt_trace.c.
diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index 9fdba03..463f297 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -52,10 +52,29 @@ config PREEMPT
 
 endchoice
 
+choice
+	prompt "RCU Implementation"
+	default CLASSIC_RCU
+
+config CLASSIC_RCU
+	bool "Classic RCU"
+	help
+	  This option selects the classic RCU implementation that is
+	  designed for best read-side performance on non-realtime
+	  systems.
+	  
+	  Select this option if you are unsure.
+
+config TREE_RCU
+	bool "Tree-based hierarchical RCU"
+	help
+	  This option selects the RCU implementation that is
+	  designed for very large SMP system with hundreds or
+	  thousands of CPUs.
+
 config PREEMPT_RCU
 	bool "Preemptible RCU"
 	depends on PREEMPT
-	default n
 	help
 	  This option reduces the latency of the kernel by making certain
 	  RCU sections preemptible. Normally RCU code is non-preemptible, if
@@ -64,16 +83,47 @@ config PREEMPT_RCU
 	  now-naive assumptions about each RCU read-side critical section
 	  remaining on a given CPU through its execution.
 
-	  Say N if you are unsure.
+endchoice
 
 config RCU_TRACE
-	bool "Enable tracing for RCU - currently stats in debugfs"
-	depends on PREEMPT_RCU
-	select DEBUG_FS
-	default y
+	bool "Enable tracing for RCU"
+	depends on TREE_RCU || PREEMPT_RCU
 	help
 	  This option provides tracing in RCU which presents stats
 	  in debugfs for debugging RCU implementation.
 
 	  Say Y here if you want to enable RCU tracing
 	  Say N if you are unsure.
+
+config RCU_FANOUT
+	int "Tree-based hierarchical RCU fanout value"
+	range 2 64 if 64BIT
+	range 2 32 if !64BIT
+	depends on TREE_RCU
+	default 64 if 64BIT
+	default 32 if !64BIT
+	help
+	  This option controls the fanout of hierarchical implementations
+	  of RCU, allowing RCU to work efficiently on machines with
+	  large numbers of CPUs.  This value must be at least the cube
+	  root of NR_CPUS, which allows NR_CPUS up to 32,768 for 32-bit
+	  systems and up to 262,144 for 64-bit systems.
+
+	  Select a specific number if testing RCU itself.
+	  Take the default if unsure.
+
+config RCU_FANOUT_EXACT
+	bool "Disable tree-based hierarchical RCU auto-balancing"
+	depends on TREE_RCU
+	default n
+	help
+	  This option forces use of the exact RCU_FANOUT value specified,
+	  regardless of imbalances in the hierarchy.  This is useful for
+	  testing RCU itself, and might one day be useful on systems with
+	  strong NUMA behavior.
+
+	  Without RCU_FANOUT_EXACT, the code will balance the hierarchy.
+
+	  Say n if unsure.
+
+	
diff --git a/kernel/Makefile b/kernel/Makefile
index 9a3ec66..b96ef0b 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -76,10 +76,10 @@ obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_CLASSIC_RCU) += rcuclassic.o
+obj-$(CONFIG_TREE_RCU) += rcutree.o
 obj-$(CONFIG_PREEMPT_RCU) += rcupreempt.o
-ifeq ($(CONFIG_PREEMPT_RCU),y)
-obj-$(CONFIG_RCU_TRACE) += rcupreempt_trace.o
-endif
+obj-$(CONFIG_TREE_RCU_TRACE) += rcutree_trace.o
+obj-$(CONFIG_PREEMPT_RCU_TRACE) += rcupreempt_trace.o
 obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 59236e8..0498265 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -551,6 +551,16 @@ void rcu_irq_exit(void)
 	}
 }
 
+void rcu_nmi_enter(void)
+{
+	rcu_irq_enter();
+}
+
+void rcu_nmi_exit(void)
+{
+	rcu_irq_exit();
+}
+
 static void dyntick_save_progress_counter(int cpu)
 {
 	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
diff --git a/kernel/rcupreempt_trace.c b/kernel/rcupreempt_trace.c
index 35c2d33..7c2665c 100644
--- a/kernel/rcupreempt_trace.c
+++ b/kernel/rcupreempt_trace.c
@@ -149,12 +149,12 @@ static void rcupreempt_trace_sum(struct rcupreempt_trace *sp)
 		sp->done_length += cp->done_length;
 		sp->done_add += cp->done_add;
 		sp->done_remove += cp->done_remove;
-		atomic_set(&sp->done_invoked, atomic_read(&cp->done_invoked));
+		atomic_add(atomic_read(&cp->done_invoked), &sp->done_invoked);
 		sp->rcu_check_callbacks += cp->rcu_check_callbacks;
-		atomic_set(&sp->rcu_try_flip_1,
-			   atomic_read(&cp->rcu_try_flip_1));
-		atomic_set(&sp->rcu_try_flip_e1,
-			   atomic_read(&cp->rcu_try_flip_e1));
+		atomic_add(atomic_read(&cp->rcu_try_flip_1),
+			   &sp->rcu_try_flip_1);
+		atomic_add(atomic_read(&cp->rcu_try_flip_e1),
+			   &sp->rcu_try_flip_e1);
 		sp->rcu_try_flip_i1 += cp->rcu_try_flip_i1;
 		sp->rcu_try_flip_ie1 += cp->rcu_try_flip_ie1;
 		sp->rcu_try_flip_g1 += cp->rcu_try_flip_g1;
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
new file mode 100644
index 0000000..ad8cd20
--- /dev/null
+++ b/kernel/rcutree.c
@@ -0,0 +1,1541 @@
+/*
+ * Read-Copy Update mechanism for mutual exclusion
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2008
+ *
+ * Authors: Dipankar Sarma <dipankar@in.ibm.com>
+ *	    Manfred Spraul <manfred@colorfullife.com>
+ *	    Paul E. McKenney <paulmck@linux.vnet.ibm.com> Hierarchical version
+ *
+ * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
+ * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
+ *
+ * For detailed explanation of Read-Copy Update mechanism see -
+ * 	Documentation/RCU
+ */
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/smp.h>
+#include <linux/rcupdate.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <asm/atomic.h>
+#include <linux/bitops.h>
+#include <linux/module.h>
+#include <linux/completion.h>
+#include <linux/moduleparam.h>
+#include <linux/percpu.h>
+#include <linux/notifier.h>
+#include <linux/cpu.h>
+#include <linux/mutex.h>
+#include <linux/time.h>
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+static struct lock_class_key rcu_lock_key;
+struct lockdep_map rcu_lock_map =
+	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock", &rcu_lock_key);
+EXPORT_SYMBOL_GPL(rcu_lock_map);
+#endif
+
+/* Data structures. */
+
+#define RCU_STATE_INITIALIZER(name) { \
+	.level = { &name.node[0] }, \
+	.levelcnt = { \
+		NUM_RCU_LVL_0,  /* root of hierarchy. */ \
+		NUM_RCU_LVL_1, \
+		NUM_RCU_LVL_2, \
+		NUM_RCU_LVL_3, /* == MAX_RCU_LVLS */ \
+	}, \
+	.signaled = RCU_SIGNAL_INIT, \
+	.gpnum = -300, \
+	.completed = -300, \
+	.onofflock = __SPIN_LOCK_UNLOCKED(&name.onofflock), \
+	.fqslock = __SPIN_LOCK_UNLOCKED(&name.fqslock), \
+	.n_force_qs = 0, \
+	.n_force_qs_ngp = 0, \
+}
+
+struct rcu_state rcu_state = RCU_STATE_INITIALIZER(rcu_state);
+DEFINE_PER_CPU(struct rcu_data, rcu_data);
+
+struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
+DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
+
+#ifdef CONFIG_NO_HZ
+DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks);
+#endif /* #ifdef CONFIG_NO_HZ */
+
+static int blimit = 10;		/* Maximum callbacks per softirq. */
+static int qhimark = 10000;	/* If this many pending, ignore blimit. */
+static int qlowmark = 100;	/* Once only this many pending, use blimit. */
+
+static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
+
+/*
+ * Return the number of RCU batches processed thus far for debug & stats.
+ */
+long rcu_batches_completed(void)
+{
+	return rcu_state.completed;
+}
+EXPORT_SYMBOL_GPL(rcu_batches_completed);
+
+/*
+ * Return the number of RCU BH batches processed thus far for debug & stats.
+ */
+long rcu_batches_completed_bh(void)
+{
+	return rcu_bh_state.completed;
+}
+EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
+
+/*
+ * Does the CPU have callbacks ready to be invoked?
+ */
+static int
+cpu_has_callbacks_ready_to_invoke(struct rcu_data *rdp)
+{
+	return &rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL];
+}
+
+/*
+ * Does the current CPU require a yet-as-unscheduled grace period?
+ */
+static int
+cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	/* ACCESS_ONCE() because we are accessing outside of lock. */
+	return *rdp->nxttail[RCU_DONE_TAIL] &&
+	       ACCESS_ONCE(rsp->completed) == ACCESS_ONCE(rsp->gpnum);
+}
+
+/*
+ * Return the root node of the specified rcu_state structure.
+ */
+static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
+{
+	return &rsp->node[0];
+}
+
+#ifdef CONFIG_SMP
+
+/*
+ * If the specified CPU is offline, tell the caller that it is in
+ * a quiescent state.  Otherwise, whack it with a reschedule IPI.
+ * Grace periods can end up waiting on an offline CPU when that
+ * CPU is in the process of coming online -- it will be added to the
+ * rcu_node bitmasks before it actually makes it online.  The same thing
+ * can happen while a CPU is in the process of coming online.  Because this
+ * race is quite rare, we check for it after detecting that the grace
+ * period has been delayed rather than checking each and every CPU
+ * each and every time we start a new grace period.
+ */
+static int rcu_implicit_offline_qs(struct rcu_data *rdp)
+{
+	/*
+	 * If the CPU is offline, it is in a quiescent state.  We can
+	 * trust its state not to change because interrupts are disabled.
+	 */
+	if (cpu_is_offline(rdp->cpu)) {
+		rdp->offline_fqs++;
+		return 1;
+	}
+
+	/* The CPU is online, so send it a reschedule IPI. */
+	if (rdp->cpu != smp_processor_id())
+		smp_send_reschedule(rdp->cpu);
+	else
+		set_need_resched();
+	rdp->resched_ipi++;
+	return 0;
+}
+
+#endif /* #ifdef CONFIG_SMP */
+
+#ifdef CONFIG_NO_HZ
+static DEFINE_RATELIMIT_STATE(rcu_rs, 10 * HZ, 5);
+
+/**
+ * rcu_enter_nohz - inform RCU that current CPU is entering nohz
+ *
+ * Enter nohz mode, in other words, -leave- the mode in which RCU
+ * read-side critical sections can occur.  (Though RCU read-side
+ * critical sections can occur in irq handlers in nohz mode, a possibility
+ * handled by rcu_irq_enter() and rcu_irq_exit()).
+ */
+void rcu_enter_nohz(void)
+{
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+
+	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp->dynticks++;
+	rdtp->dynticks_nesting--;
+	WARN_ON_RATELIMIT(rdtp->dynticks & 0x1, &rcu_rs);
+	local_irq_restore(flags);
+}
+
+/*
+ * rcu_exit_nohz - inform RCU that current CPU is leaving nohz
+ *
+ * Exit nohz mode, in other words, -enter- the mode in which RCU
+ * read-side critical sections normally occur.
+ */
+void rcu_exit_nohz(void)
+{
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp->dynticks++;
+	rdtp->dynticks_nesting++;
+	WARN_ON_RATELIMIT(!(rdtp->dynticks & 0x1), &rcu_rs);
+	local_irq_restore(flags);
+	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
+}
+
+/**
+ * rcu_nmi_enter - inform RCU of entry to NMI context
+ *
+ * If the CPU was idle with dynamic ticks active, and there is no
+ * irq handler running, this updates rdtp->dynticks_nmi to let the
+ * RCU grace-period handling know that the CPU is active.
+ */
+void rcu_nmi_enter(void)
+{
+	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+
+	if (rdtp->dynticks & 0x1)
+		return;
+	rdtp->dynticks_nmi++;
+	WARN_ON_RATELIMIT(!(rdtp->dynticks_nmi & 0x1), &rcu_rs);
+	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
+}
+
+/**
+ * rcu_nmi_exit - inform RCU of exit from NMI context
+ *
+ * If the CPU was idle with dynamic ticks active, and there is no
+ * irq handler running, this updates rdtp->dynticks_nmi to let the
+ * RCU grace-period handling know that the CPU is no longer active.
+ */
+void rcu_nmi_exit(void)
+{
+	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+
+	if (rdtp->dynticks & 0x1)
+		return;
+	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
+	rdtp->dynticks_nmi++;
+	WARN_ON_RATELIMIT(rdtp->dynticks_nmi & 0x1, &rcu_rs);
+}
+
+/**
+ * rcu_irq_enter - inform RCU of entry to hard irq context
+ *
+ * If the CPU was idle with dynamic ticks active, this updates the
+ * rdtp->dynticks to let the RCU handling know that the CPU is active.
+ */
+void rcu_irq_enter(void)
+{
+	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+
+	if (rdtp->dynticks_nesting++)
+		return;
+	rdtp->dynticks++;
+	WARN_ON_RATELIMIT(!(rdtp->dynticks & 0x1), &rcu_rs);
+	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
+}
+
+/**
+ * rcu_irq_exit - inform RCU of exit from hard irq context
+ *
+ * If the CPU was idle with dynamic ticks active, update the rdp->dynticks
+ * to put let the RCU handling be aware that the CPU is going back to idle
+ * with no ticks.
+ */
+void rcu_irq_exit(void)
+{
+	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+
+	if (--rdtp->dynticks_nesting)
+		return;
+	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
+	rdtp->dynticks++;
+	WARN_ON_RATELIMIT(rdtp->dynticks & 0x1, &rcu_rs);
+
+	/* If the interrupt queued a callback, get out of dyntick mode. */
+	if (__get_cpu_var(rcu_data).nxtlist ||
+	    __get_cpu_var(rcu_bh_data).nxtlist)
+		set_need_resched();
+}
+
+/*
+ * Record the specified "completed" value, which is later used to validate
+ * dynticks counter manipulations.  Specify "rsp->completed - 1" to
+ * unconditionally invalidate any future dynticks manipulations (which is
+ * useful at the beginning of a grace period).
+ */
+static void dyntick_record_completed(struct rcu_state *rsp, int comp)
+{
+	rsp->dynticks_completed = comp;
+}
+
+#ifdef CONFIG_SMP
+
+/*
+ * Recall the previously recorded value of the completion for dynticks.
+ */
+static long dyntick_recall_completed(struct rcu_state *rsp)
+{
+	return rsp->dynticks_completed;
+}
+
+/*
+ * Snapshot the specified CPU's dynticks counter so that we can later
+ * credit them with an implicit quiescent state.  Return 1 if this CPU
+ * is already in a quiescent state courtesy of dynticks idle mode.
+ */
+static int dyntick_save_progress_counter(struct rcu_data *rdp)
+{
+	int ret;
+	int snap;
+	int snap_nmi;
+
+	snap = rdp->dynticks->dynticks;
+	snap_nmi = rdp->dynticks->dynticks_nmi;
+	smp_mb();	/* Order sampling of snap with end of grace period. */
+	rdp->dynticks_snap = snap;
+	rdp->dynticks_nmi_snap = snap_nmi;
+	ret = ((snap & 0x1) == 0) && ((snap_nmi & 0x1) == 0);
+	if (ret)
+		rdp->dynticks_fqs++;
+	return ret;
+}
+
+/*
+ * Return true if the specified CPU has passed through a quiescent
+ * state by virtue of being in or having passed through an dynticks
+ * idle state since the last call to dyntick_save_progress_counter()
+ * for this same CPU.
+ */
+static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
+{
+	long curr;
+	long curr_nmi;
+	long snap;
+	long snap_nmi;
+
+	curr = rdp->dynticks->dynticks;
+	snap = rdp->dynticks_snap;
+	curr_nmi = rdp->dynticks->dynticks_nmi;
+	snap_nmi = rdp->dynticks_nmi_snap;
+	smp_mb(); /* force ordering with cpu entering/leaving dynticks. */
+
+	/*
+	 * If the CPU passed through or entered a dynticks idle phase with
+	 * no active irq/NMI handlers, then we can safely pretend that the CPU
+	 * already acknowledged the request to pass through a quiescent
+	 * state.  Either way, that CPU cannot possibly be in an RCU
+	 * read-side critical section that started before the beginning
+	 * of the current RCU grace period.
+	 */
+	if ((curr != snap || (curr & 0x1) == 0) &&
+	    (curr_nmi != snap_nmi || (curr_nmi & 0x1) == 0)) {
+		rdp->dynticks_fqs++;
+		return 1;
+	}
+
+	/* Go check for the CPU being offline. */
+	return rcu_implicit_offline_qs(rdp);
+}
+
+#endif /* #ifdef CONFIG_SMP */
+
+#else /* #ifdef CONFIG_NO_HZ */
+
+static void dyntick_record_completed(struct rcu_state *rsp, int comp)
+{
+}
+
+#ifdef CONFIG_SMP
+
+/*
+ * If there are no dynticks, then the only way that a CPU can passively
+ * be in a quiescent state is to be offline.  Unlike dynticks idle, which
+ * is a point in time during the prior (already finished) grace period,
+ * an offline CPU is always in a quiescent state, and thus can be
+ * unconditionally applied.  So just return the current value of completed.
+ */
+static long dyntick_recall_completed(struct rcu_state *rsp)
+{
+	return rsp->completed;
+}
+
+static int dyntick_save_progress_counter(struct rcu_data *rdp)
+{
+	return 0;
+}
+
+static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
+{
+	return rcu_implicit_offline_qs(rdp);
+}
+
+#endif /* #ifdef CONFIG_SMP */
+
+#endif /* #else #ifdef CONFIG_NO_HZ */
+
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+
+static void record_gp_stall_check_time(struct rcu_state *rsp)
+{
+	rsp->gp_start = jiffies;
+	rsp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_CHECK;
+}
+
+static void print_other_cpu_stall(struct rcu_state *rsp)
+{
+	int cpu;
+	long delta;
+	unsigned long flags;
+	struct rcu_node *rnp = rcu_get_root(rsp);
+	struct rcu_node *rnp_cur = rsp->level[NUM_RCU_LVLS - 1];
+	struct rcu_node *rnp_end = &rsp->node[NUM_RCU_NODES];
+
+	/* Only let one CPU complain about others per time interval. */
+
+	spin_lock_irqsave(&rnp->lock, flags);
+	delta = jiffies - rsp->jiffies_stall;
+	if (delta < RCU_STALL_RAT_DELAY || rsp->gpnum == rsp->completed) {
+		spin_unlock_irqrestore(&rnp->lock, flags);
+		return;
+	}
+	rsp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
+	spin_unlock_irqrestore(&rnp->lock, flags);
+
+	/* OK, time to rat on our buddy... */
+
+	printk(KERN_ERR "INFO: RCU detected CPU stalls:");
+	for (; rnp_cur < rnp_end; rnp_cur++) {
+		if (rnp_cur->qsmask == 0)
+			continue;
+		for (cpu = 0; cpu <= rnp_cur->grphi - rnp_cur->grplo; cpu++)
+			if (rnp_cur->qsmask & (1UL << cpu))
+				printk(" %d", rnp_cur->grplo + cpu);
+	}
+	printk(" (detected by %d, t=%ld jiffies)\n",
+	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
+	force_quiescent_state(rsp, 0);  /* Kick them all. */
+}
+
+static void print_cpu_stall(struct rcu_state *rsp)
+{
+	unsigned long flags;
+	struct rcu_node *rnp = rcu_get_root(rsp);
+
+	printk(KERN_ERR "INFO: RCU detected CPU %d stall (t=%lu jiffies)\n",
+			smp_processor_id(), jiffies - rsp->gp_start);
+	dump_stack();
+	spin_lock_irqsave(&rnp->lock, flags);
+	if ((long)(jiffies - rsp->jiffies_stall) >= 0)
+		rsp->jiffies_stall =
+			jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
+	spin_unlock_irqrestore(&rnp->lock, flags);
+	set_need_resched();  /* kick ourselves to get things going. */
+}
+
+static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	long delta;
+	struct rcu_node *rnp;
+
+	delta = jiffies - rsp->jiffies_stall;
+	rnp = rdp->mynode;
+	if ((rnp->qsmask & rdp->grpmask) && delta >= 0) {
+
+		/* We haven't checked in, so go dump stack. */
+		print_cpu_stall(rsp);
+
+	} else if (rsp->gpnum != rsp->completed &&
+		   delta >= RCU_STALL_RAT_DELAY) {
+
+		/* They had two time units to dump stack, so complain. */
+		print_other_cpu_stall(rsp);
+	}
+}
+
+#else /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+
+static void record_gp_stall_check_time(struct rcu_state *rsp)
+{
+}
+
+static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+}
+
+#endif /* #else #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+
+/*
+ * Update CPU-local rcu_data state to record the newly noticed grace period.
+ * This is used both when we started the grace period and when we notice
+ * that someone else started the grace period.
+ */
+static void note_new_gpnum(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	rdp->qs_pending = 1;
+	rdp->passed_quiesc = 0;
+	rdp->gpnum = rsp->gpnum;
+	rdp->n_rcu_pending_force_qs = rdp->n_rcu_pending +
+				      RCU_JIFFIES_TILL_FORCE_QS;
+}
+
+/*
+ * Did someone else start a new RCU grace period start since we last
+ * checked?  Update local state appropriately if so.  Must be called
+ * on the CPU corresponding to rdp.
+ */
+static int
+check_for_new_grace_period(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	local_irq_save(flags);
+	if (rdp->gpnum != rsp->gpnum) {
+		note_new_gpnum(rsp, rdp);
+		ret = 1;
+	}
+	local_irq_restore(flags);
+	return ret;
+}
+
+/*
+ * Start a new RCU grace period if warranted, re-initializing the hierarchy
+ * in preparation for detecting the next grace period.  The caller must hold
+ * the root node's ->lock, which is released before return.  Hard irqs must
+ * be disabled.
+ */
+static void
+rcu_start_gp(struct rcu_state *rsp, unsigned long iflg)
+	__releases(rcu_get_root(rsp)->lock)
+{
+	unsigned long flags = iflg;
+	struct rcu_data *rdp = rsp->rda[smp_processor_id()];
+	struct rcu_node *rnp = rcu_get_root(rsp);
+	struct rcu_node *rnp_cur;
+	struct rcu_node *rnp_end;
+
+	if (!cpu_needs_another_gp(rsp, rdp)) {
+		spin_unlock_irqrestore(&rnp->lock, flags);
+		return;
+	}
+
+	/* Advance to a new grace period and initialize state. */
+	rsp->gpnum++;
+	rsp->signaled = RCU_GP_INIT; /* Hold off force_quiescent_state. */
+	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
+	rdp->n_rcu_pending_force_qs = rdp->n_rcu_pending +
+				      RCU_JIFFIES_TILL_FORCE_QS;
+	record_gp_stall_check_time(rsp);
+	dyntick_record_completed(rsp, rsp->completed - 1);
+	note_new_gpnum(rsp, rdp);
+
+	/*
+	 * Because we are first, we know that all our callbacks will
+	 * be covered by this upcoming grace period, even the ones
+	 * that were registered arbitrarily recently.
+	 */
+	rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+	rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+
+	/* Special-case the common single-level case. */
+	if (NUM_RCU_NODES == 1) {
+		rnp->qsmask = rnp->qsmaskinit;
+		spin_unlock_irqrestore(&rnp->lock, flags);
+		return;
+	}
+
+	spin_unlock(&rnp->lock);  /* leave irqs disabled. */
+
+
+	/* Exclude any concurrent CPU-hotplug operations. */
+	spin_lock(&rsp->onofflock);  /* irqs already disabled. */
+
+	/*
+	 * Set the quiescent-state-needed bits in all the non-leaf RCU
+	 * nodes for all currently online CPUs.  This operation relies
+	 * on the layout of the hierarchy within the rsp->node[] array.
+	 * Note that other CPUs will access only the leaves of the
+	 * hierarchy, which still indicate that no grace period is in
+	 * progress.  In addition, we have excluded CPU-hotplug operations.
+	 *
+	 * We therefore do not need to hold any locks.  Any required
+	 * memory barriers will be supplied by the locks guarding the
+	 * leaf rcu_nodes in the hierarchy.
+	 */
+
+	rnp_end = rsp->level[NUM_RCU_LVLS - 1];
+	for (rnp_cur = &rsp->node[0]; rnp_cur < rnp_end; rnp_cur++)
+		rnp_cur->qsmask = rnp_cur->qsmaskinit;
+
+	/*
+	 * Now set up the leaf nodes.  Here we must be careful.  First,
+	 * we need to hold the lock in order to exclude other CPUs, which
+	 * might be contending for the leaf nodes' locks.  Second, as
+	 * soon as we initialize a given leaf node, its CPUs might run
+	 * up the rest of the hierarchy.  We must therefore acquire locks
+	 * for each node that we touch during this stage.  (But we still
+	 * are excluding CPU-hotplug operations.)
+	 *
+	 * Note that the grace period cannot complete until we finish
+	 * the initialization process, as there will be at least one
+	 * qsmask bit set in the root node until that time, namely the
+	 * one corresponding to this CPU.
+	 */
+	rnp_end = &rsp->node[NUM_RCU_NODES];
+	rnp_cur = rsp->level[NUM_RCU_LVLS - 1];
+	for (; rnp_cur < rnp_end; rnp_cur++) {
+		spin_lock(&rnp_cur->lock);	/* irqs already disabled. */
+		rnp_cur->qsmask = rnp_cur->qsmaskinit;
+		spin_unlock(&rnp_cur->lock);	/* irqs already disabled. */
+	}
+
+	rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state now OK. */
+	spin_unlock_irqrestore(&rsp->onofflock, flags);
+}
+
+/*
+ * Advance this CPU's callbacks, but only if the current grace period
+ * has ended.  This may be called only from the CPU to whom the rdp
+ * belongs.
+ */
+static void
+rcu_process_gp_end(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	long completed_snap;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	completed_snap = ACCESS_ONCE(rsp->completed);  /* outside of lock. */
+
+	/* Did another grace period end? */
+	if (rdp->completed != completed_snap) {
+
+		/* Advance callbacks.  No harm if list empty. */
+		rdp->nxttail[RCU_DONE_TAIL] = rdp->nxttail[RCU_WAIT_TAIL];
+		rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_READY_TAIL];
+		rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+
+		/* Remember that we saw this grace-period completion. */
+		rdp->completed = completed_snap;
+	}
+	local_irq_restore(flags);
+}
+
+/*
+ * Similar to cpu_quiet(), for which it is a helper function.  Allows
+ * a group of CPUs to be quieted at one go, though all the CPUs in the
+ * group must be represented by the same leaf rcu_node structure.
+ * That structure's lock must be held upon entry, and it is released
+ * before return.
+ */
+static void
+cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp, struct rcu_node *rnp,
+	      unsigned long flags)
+	__releases(rnp->lock)
+{
+	/* Walk up the rcu_node hierarchy. */
+	for (;;) {
+		if (!(rnp->qsmask & mask)) {
+
+			/* Our bit has already been cleared, so done. */
+			spin_unlock_irqrestore(&rnp->lock, flags);
+			return;
+		}
+		rnp->qsmask &= ~mask;
+		if (rnp->qsmask != 0) {
+
+			/* Other bits still set at this level, so done. */
+			spin_unlock_irqrestore(&rnp->lock, flags);
+			return;
+		}
+		mask = rnp->grpmask;
+		if (rnp->parent == NULL) {
+
+			/* No more levels.  Exit loop holding root lock. */
+
+			break;
+		}
+		spin_unlock_irqrestore(&rnp->lock, flags);
+		rnp = rnp->parent;
+		spin_lock_irqsave(&rnp->lock, flags);
+	}
+
+	/*
+	 * Get here if we are the last CPU to pass through a quiescent
+	 * state for this grace period.  Clean up and let rcu_start_gp()
+	 * start up the next grace period if one is needed.  Note that
+	 * we still hold rnp->lock, as required by rcu_start_gp(), which
+	 * will release it.
+	 */
+	rsp->completed = rsp->gpnum;
+	rcu_process_gp_end(rsp, rsp->rda[smp_processor_id()]);
+	rcu_start_gp(rsp, flags);  /* releases rnp->lock. */
+}
+
+/*
+ * Record a quiescent state for the specified CPU, which must either be
+ * the current CPU or an offline CPU.  The lastcomp argument is used to
+ * make sure we are still in the grace period of interest.  We don't want
+ * to end the current grace period based on quiescent states detected in
+ * an earlier grace period!
+ */
+static void
+cpu_quiet(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long lastcomp)
+{
+	unsigned long flags;
+	unsigned long mask;
+	struct rcu_node *rnp;
+
+	rnp = rdp->mynode;
+	spin_lock_irqsave(&rnp->lock, flags);
+	if (lastcomp != ACCESS_ONCE(rsp->completed)) {
+
+		/*
+		 * Someone beat us to it for this grace period, so leave.
+		 * The race with GP start is resolved by the fact that we
+		 * hold the leaf rcu_node lock, so that the per-CPU bits
+		 * cannot yet be initialized -- so we would simply find our
+		 * CPU's bit already cleared in cpu_quiet_msk() if this race
+		 * occurred.
+		 */
+		rdp->passed_quiesc = 0;	/* try again later! */
+		spin_unlock_irqrestore(&rnp->lock, flags);
+		return;
+	}
+	mask = rdp->grpmask;
+	if ((rnp->qsmask & mask) == 0) {
+		spin_unlock_irqrestore(&rnp->lock, flags);
+	} else {
+		rdp->qs_pending = 0;
+
+		/*
+		 * This GP can't end until cpu checks in, so all of our
+		 * callbacks can be processed during the next GP.
+		 */
+		rdp = rsp->rda[smp_processor_id()];
+		rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+
+		cpu_quiet_msk(mask, rsp, rnp, flags); /* releases rnp->lock */
+	}
+}
+
+/*
+ * Check to see if there is a new grace period of which this CPU
+ * is not yet aware, and if so, set up local rcu_data state for it.
+ * Otherwise, see if this CPU has just passed through its first
+ * quiescent state for this grace period, and record that fact if so.
+ */
+static void
+rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	/* If there is now a new grace period, record and return. */
+	if (check_for_new_grace_period(rsp, rdp))
+		return;
+
+	/*
+	 * Does this CPU still need to do its part for current grace period?
+	 * If no, return and let the other CPUs do their part as well.
+	 */
+	if (!rdp->qs_pending)
+		return;
+
+	/*
+	 * Was there a quiescent state since the beginning of the grace
+	 * period? If no, then exit and wait for the next call.
+	 */
+	if (!rdp->passed_quiesc)
+		return;
+
+	/* Tell RCU we are done (but cpu_quiet() will be the judge of that). */
+	cpu_quiet(rdp->cpu, rsp, rdp, rdp->passed_quiesc_completed);
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+
+/*
+ * Remove the outgoing CPU from the bitmasks in the rcu_node hierarchy
+ * and move all callbacks from the outgoing CPU to the current one.
+ */
+static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
+{
+	int i;
+	unsigned long flags;
+	long lastcomp;
+	unsigned long mask;
+	struct rcu_data *rdp = rsp->rda[cpu];
+	struct rcu_data *rdp_me;
+	struct rcu_node *rnp;
+
+	/* Exclude any attempts to start a new grace period. */
+	spin_lock_irqsave(&rsp->onofflock, flags);
+
+	/* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */
+	rnp = rdp->mynode;
+	mask = rdp->grpmask;	/* rnp->grplo is constant. */
+	do {
+		spin_lock(&rnp->lock);		/* irqs already disabled. */
+		rnp->qsmaskinit &= ~mask;
+		if (rnp->qsmaskinit != 0) {
+			spin_unlock(&rnp->lock); /* irqs already disabled. */
+			break;
+		}
+		mask = rnp->grpmask;
+		spin_unlock(&rnp->lock);	/* irqs already disabled. */
+		rnp = rnp->parent;
+	} while (rnp != NULL);
+	lastcomp = rsp->completed;
+
+	spin_unlock(&rsp->onofflock);		/* irqs remain disabled. */
+
+	/* Being offline is a quiescent state, so go record it. */
+	cpu_quiet(cpu, rsp, rdp, lastcomp);
+
+	/*
+	 * Move callbacks from the outgoing CPU to the running CPU.
+	 * Note that the outgoing CPU is now quiscent, so it is now
+	 * (uncharacteristically) safe to access it rcu_data structure.
+	 * Note also that we must carefully retain the order of the
+	 * outgoing CPU's callbacks in order for rcu_barrier() to work
+	 * correctly.  Finally, note that we start all the callbacks
+	 * afresh, even those that have passed through a grace period
+	 * and are therefore ready to invoke.  The theory is that hotplug
+	 * events are rare, and that if they are frequent enough to
+	 * indefinitely delay callbacks, you have far worse things to
+	 * be worrying about.
+	 */
+	rdp_me = rsp->rda[smp_processor_id()];
+	if (rdp->nxtlist != NULL) {
+		*rdp_me->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
+		rdp_me->nxttail[RCU_NEXT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+		rdp->nxtlist = NULL;
+		for (i = 0; i < RCU_NEXT_SIZE; i++)
+			rdp->nxttail[i] = &rdp->nxtlist;
+		rdp_me->qlen += rdp->qlen;
+		rdp->qlen = 0;
+	}
+	local_irq_restore(flags);
+}
+
+/*
+ * Remove the specified CPU from the RCU hierarchy and move any pending
+ * callbacks that it might have to the current CPU.  This code assumes
+ * that at least one CPU in the system will remain running at all times.
+ * Any attempt to offline -all- CPUs is likely to strand RCU callbacks.
+ */
+static void rcu_offline_cpu(int cpu)
+{
+	__rcu_offline_cpu(cpu, &rcu_state);
+	__rcu_offline_cpu(cpu, &rcu_bh_state);
+}
+
+#else /* #ifdef CONFIG_HOTPLUG_CPU */
+
+static void rcu_offline_cpu(int cpu)
+{
+}
+
+#endif /* #else #ifdef CONFIG_HOTPLUG_CPU */
+
+/*
+ * Invoke any RCU callbacks that have made it to the end of their grace
+ * period.  Thottle as specified by rdp->blimit.
+ */
+static void rcu_do_batch(struct rcu_data *rdp)
+{
+	unsigned long flags;
+	struct rcu_head *next, *list, **tail;
+	int count;
+
+	/* If no callbacks are ready, just return.*/
+	if (!cpu_has_callbacks_ready_to_invoke(rdp))
+		return;
+
+	/*
+	 * Extract the list of ready callbacks, disabling to prevent
+	 * races with call_rcu() from interrupt handlers.
+	 */
+	local_irq_save(flags);
+	list = rdp->nxtlist;
+	rdp->nxtlist = *rdp->nxttail[RCU_DONE_TAIL];
+	*rdp->nxttail[RCU_DONE_TAIL] = NULL;
+	tail = rdp->nxttail[RCU_DONE_TAIL];
+	for (count = RCU_NEXT_SIZE - 1; count >= 0; count--)
+		if (rdp->nxttail[count] == rdp->nxttail[RCU_DONE_TAIL])
+			rdp->nxttail[count] = &rdp->nxtlist;
+	local_irq_restore(flags);
+
+	/* Invoke callbacks. */
+	count = 0;
+	while (list) {
+		next = list->next;
+		prefetch(next);
+		list->func(list);
+		list = next;
+		if (++count >= rdp->blimit)
+			break;
+	}
+
+	local_irq_save(flags);
+
+	/* Update count, and requeue any remaining callbacks. */
+	rdp->qlen -= count;
+	if (list != NULL) {
+		*tail = rdp->nxtlist;
+		rdp->nxtlist = list;
+		for (count = 0; count < RCU_NEXT_SIZE; count++)
+			if (&rdp->nxtlist == rdp->nxttail[count])
+				rdp->nxttail[count] = tail;
+			else
+				break;
+	}
+
+	/* Reinstate batch limit if we have worked down the excess. */
+	if (rdp->blimit == LONG_MAX && rdp->qlen <= qlowmark)
+		rdp->blimit = blimit;
+
+	local_irq_restore(flags);
+
+	/* Re-raise the RCU softirq if there are callbacks remaining. */
+	if (cpu_has_callbacks_ready_to_invoke(rdp))
+		raise_softirq(RCU_SOFTIRQ);
+}
+
+/*
+ * Check to see if this CPU is in a non-context-switch quiescent state
+ * (user mode or idle loop for rcu, non-softirq execution for rcu_bh).
+ * Also schedule the RCU softirq handler.
+ *
+ * This function must be called with hardirqs disabled.  It is normally
+ * invoked from the scheduling-clock interrupt.  If rcu_pending returns
+ * false, there is no point in invoking rcu_check_callbacks().
+ */
+void rcu_check_callbacks(int cpu, int user)
+{
+	if (user ||
+	    (idle_cpu(cpu) && !in_softirq() &&
+				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
+
+		/*
+		 * Get here if this CPU took its interrupt from user
+		 * mode or from the idle loop, and if this is not a
+		 * nested interrupt.  In this case, the CPU is in
+		 * a quiescent state, so count it.
+		 *
+		 * Also do a memory barrier.  This is needed to handle
+		 * the case where writes from a preempt-disable section
+		 * of code get reordered into schedule() by this CPU's
+		 * write buffer.  The memory barrier makes sure that
+		 * the rcu_qsctr_inc() and rcu_bh_qsctr_inc() are see
+		 * by other CPUs to happen after any such write.
+		 */
+
+		smp_mb();  /* See above block comment. */
+		rcu_qsctr_inc(cpu);
+		rcu_bh_qsctr_inc(cpu);
+
+	} else if (!in_softirq()) {
+
+		/*
+		 * Get here if this CPU did not take its interrupt from
+		 * softirq, in other words, if it is not interrupting
+		 * a rcu_bh read-side critical section.  This is an _bh
+		 * critical section, so count it.  The memory barrier
+		 * is needed for the same reason as is the above one.
+		 */
+
+		smp_mb();  /* See above block comment. */
+		rcu_bh_qsctr_inc(cpu);
+	}
+	raise_softirq(RCU_SOFTIRQ);
+}
+
+#ifdef CONFIG_SMP
+
+/*
+ * Scan the leaf rcu_node structures, processing dyntick state for any that
+ * have not yet encountered a quiescent state, using the function specified.
+ * Returns 1 if the current grace period ends while scanning (possibly
+ * because we made it end).
+ */
+static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
+			       int (*f)(struct rcu_data *))
+{
+	unsigned long bit;
+	int cpu;
+	unsigned long flags;
+	unsigned long mask;
+	struct rcu_node *rnp_cur = rsp->level[NUM_RCU_LVLS - 1];
+	struct rcu_node *rnp_end = &rsp->node[NUM_RCU_NODES];
+
+	for (; rnp_cur < rnp_end; rnp_cur++) {
+		mask = 0;
+		spin_lock_irqsave(&rnp_cur->lock, flags);
+		if (rsp->completed != lastcomp) {
+			spin_unlock_irqrestore(&rnp_cur->lock, flags);
+			return 1;
+		}
+		if (rnp_cur->qsmask == 0) {
+			spin_unlock_irqrestore(&rnp_cur->lock, flags);
+			continue;
+		}
+		cpu = rnp_cur->grplo;
+		bit = 1;
+		mask = 0;
+		for (; cpu <= rnp_cur->grphi; cpu++, bit <<= 1) {
+			if ((rnp_cur->qsmask & bit) != 0 && f(rsp->rda[cpu]))
+				mask |= bit;
+		}
+		if (mask != 0 && rsp->completed == lastcomp) {
+
+			/* cpu_quiet_msk() releases rnp_cur->lock. */
+			cpu_quiet_msk(mask, rsp, rnp_cur, flags);
+			continue;
+		}
+		spin_unlock_irqrestore(&rnp_cur->lock, flags);
+	}
+	return 0;
+}
+
+/*
+ * Force quiescent states on reluctant CPUs, and also detect which
+ * CPUs are in dyntick-idle mode.
+ */
+static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
+{
+	unsigned long flags;
+	long lastcomp;
+	struct rcu_data *rdp = rsp->rda[smp_processor_id()];
+	struct rcu_node *rnp = rcu_get_root(rsp);
+	u8 signaled;
+
+	if (ACCESS_ONCE(rsp->completed) == ACCESS_ONCE(rsp->gpnum))
+		return;  /* No grace period in progress, nothing to force. */
+	if (!spin_trylock_irqsave(&rsp->fqslock, flags)) {
+		rsp->n_force_qs_lh++; /* Inexact, can lose counts.  Tough! */
+		return;	/* Someone else is already on the job. */
+	}
+	if (relaxed &&
+	    (long)(rsp->jiffies_force_qs - jiffies) >= 0 &&
+	    (rdp->n_rcu_pending_force_qs - rdp->n_rcu_pending) >= 0)
+		goto unlock_ret; /* no emergency and done recently. */
+	rsp->n_force_qs++;
+	spin_lock(&rnp->lock);
+	lastcomp = rsp->completed;
+	signaled = rsp->signaled;
+	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
+	rdp->n_rcu_pending_force_qs = rdp->n_rcu_pending +
+				      RCU_JIFFIES_TILL_FORCE_QS;
+	if (lastcomp == rsp->gpnum) {
+		rsp->n_force_qs_ngp++;
+		spin_unlock(&rnp->lock);
+		goto unlock_ret;  /* no GP in progress, time updated. */
+	}
+	spin_unlock(&rnp->lock);
+	switch (signaled) {
+	case RCU_GP_INIT:
+
+		break; /* grace period still initializing, ignore. */
+
+	case RCU_SAVE_DYNTICK:
+
+		if (RCU_SIGNAL_INIT != RCU_SAVE_DYNTICK)
+			break; /* So gcc recognizes the dead code. */
+
+		/* Record dyntick-idle state. */
+		if (rcu_process_dyntick(rsp, lastcomp,
+					dyntick_save_progress_counter))
+			goto unlock_ret;
+
+		/* Update state, record completion counter. */
+		spin_lock(&rnp->lock);
+		if (lastcomp == rsp->completed) {
+			rsp->signaled = RCU_FORCE_QS;
+			dyntick_record_completed(rsp, lastcomp);
+		}
+		spin_unlock(&rnp->lock);
+		break;
+
+	case RCU_FORCE_QS:
+
+		/* Check dyntick-idle state, send IPI to laggarts. */
+		if (rcu_process_dyntick(rsp, dyntick_recall_completed(rsp),
+					rcu_implicit_dynticks_qs))
+			goto unlock_ret;
+
+		/* Leave state in case more forcing is required. */
+
+		break;
+	}
+unlock_ret:
+	spin_unlock_irqrestore(&rsp->fqslock, flags);
+}
+
+#else /* #ifdef CONFIG_SMP */
+
+static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
+{
+	set_need_resched();
+}
+
+#endif /* #else #ifdef CONFIG_SMP */
+
+/*
+ * This does the RCU processing work from softirq context for the
+ * specified rcu_state and rcu_data structures.  This may be called
+ * only from the CPU to whom the rdp belongs.
+ */
+static void
+__rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	unsigned long flags;
+
+	/*
+	 * If an RCU GP has gone long enough, go check for dyntick
+	 * idle CPUs and, if needed, send resched IPIs.
+	 */
+	if ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0 ||
+	    (rdp->n_rcu_pending_force_qs - rdp->n_rcu_pending) < 0)
+		force_quiescent_state(rsp, 1);
+
+	/*
+	 * Advance callbacks in response to end of earlier grace
+	 * period that some other CPU ended.
+	 */
+	rcu_process_gp_end(rsp, rdp);
+
+	/* Update RCU state based on any recent quiescent states. */
+	rcu_check_quiescent_state(rsp, rdp);
+
+	/* Does this CPU require a not-yet-started grace period? */
+	if (cpu_needs_another_gp(rsp, rdp)) {
+		spin_lock_irqsave(&rcu_get_root(rsp)->lock, flags);
+		rcu_start_gp(rsp, flags);  /* releases above lock */
+	}
+
+	/* If there are callbacks ready, invoke them. */
+	rcu_do_batch(rdp);
+}
+
+/*
+ * Do softirq processing for the current CPU.
+ */
+static void rcu_process_callbacks(struct softirq_action *unused)
+{
+	/*
+	 * Memory references from any prior RCU read-side critical sections
+	 * executed by the interrupted code must be seen before any RCU
+	 * grace-period manipulations below.
+	 */
+	smp_mb(); /* See above block comment. */
+
+	__rcu_process_callbacks(&rcu_state, &__get_cpu_var(rcu_data));
+	__rcu_process_callbacks(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
+
+	/*
+	 * Memory references from any later RCU read-side critical sections
+	 * executed by the interrupted code must be seen after any RCU
+	 * grace-period manipulations above.
+	 */
+	smp_mb(); /* See above block comment. */
+}
+
+static void
+__call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
+	   struct rcu_state *rsp)
+{
+	unsigned long flags;
+	struct rcu_data *rdp;
+
+	head->func = func;
+	head->next = NULL;
+
+	smp_mb(); /* Ensure RCU update seen before callback registry. */
+
+	/*
+	 * Opportunistically note grace-period endings and beginnings.
+	 * Note that we might see a beginning right after we see an
+	 * end, but never vice versa, since this CPU has to pass through
+	 * a quiescent state betweentimes.
+	 */
+	local_irq_save(flags);
+	rdp = rsp->rda[smp_processor_id()];
+	rcu_process_gp_end(rsp, rdp);
+	check_for_new_grace_period(rsp, rdp);
+
+	/* Add the callback to our list. */
+	*rdp->nxttail[RCU_NEXT_TAIL] = head;
+	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
+
+	/* Start a new grace period if one not already started. */
+	if (ACCESS_ONCE(rsp->completed) == ACCESS_ONCE(rsp->gpnum)) {
+		unsigned long nestflag;
+		struct rcu_node *rnp_root = rcu_get_root(rsp);
+
+		spin_lock_irqsave(&rnp_root->lock, nestflag);
+		rcu_start_gp(rsp, nestflag);  /* releases rnp_root->lock. */
+	}
+
+	/* Force the grace period if too many callbacks or too long waiting. */
+	if (unlikely(++rdp->qlen > qhimark)) {
+		rdp->blimit = LONG_MAX;
+		force_quiescent_state(rsp, 0);
+	} else if ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0 ||
+		   (rdp->n_rcu_pending_force_qs - rdp->n_rcu_pending) < 0)
+		force_quiescent_state(rsp, 1);
+	local_irq_restore(flags);
+}
+
+/*
+ * Queue an RCU callback for invocation after a grace period.
+ */
+void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
+{
+	__call_rcu(head, func, &rcu_state);
+}
+EXPORT_SYMBOL_GPL(call_rcu);
+
+/*
+ * Queue an RCU for invocation after a quicker grace period.
+ */
+void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
+{
+	__call_rcu(head, func, &rcu_bh_state);
+}
+EXPORT_SYMBOL_GPL(call_rcu_bh);
+
+/*
+ * Check to see if there is any immediate RCU-related work to be done
+ * by the current CPU, for the specified type of RCU, returning 1 if so.
+ * The checks are in order of increasing expense: checks that can be
+ * carried out against CPU-local state are performed first.  However,
+ * we must check for CPU stalls first, else we might not get a chance.
+ */
+static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	rdp->n_rcu_pending++;
+
+	/* Check for CPU stalls, if enabled. */
+	check_cpu_stall(rsp, rdp);
+
+	/* Is the RCU core waiting for a quiescent state from this CPU? */
+	if (rdp->qs_pending)
+		return 1;
+
+	/* Does this CPU have callbacks ready to invoke? */
+	if (cpu_has_callbacks_ready_to_invoke(rdp))
+		return 1;
+
+	/* Has RCU gone idle with this CPU needing another grace period? */
+	if (cpu_needs_another_gp(rsp, rdp))
+		return 1;
+
+	/* Has another RCU grace period completed?  */
+	if (ACCESS_ONCE(rsp->completed) != rdp->completed) /* outside of lock */
+		return 1;
+
+	/* Has a new RCU grace period started? */
+	if (ACCESS_ONCE(rsp->gpnum) != rdp->gpnum) /* outside of lock */
+		return 1;
+
+	/* Has an RCU GP gone long enough to send resched IPIs &c? */
+	if (ACCESS_ONCE(rsp->completed) != ACCESS_ONCE(rsp->gpnum) &&
+	    ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0 ||
+	     (rdp->n_rcu_pending_force_qs - rdp->n_rcu_pending) < 0))
+		return 1;
+
+	/* nothing to do */
+	return 0;
+}
+
+/*
+ * Check to see if there is any immediate RCU-related work to be done
+ * by the current CPU, returning 1 if so.  This function is part of the
+ * RCU implementation; it is -not- an exported member of the RCU API.
+ */
+int rcu_pending(int cpu)
+{
+	return __rcu_pending(&rcu_state, &per_cpu(rcu_data, cpu)) ||
+	       __rcu_pending(&rcu_bh_state, &per_cpu(rcu_bh_data, cpu));
+}
+
+/*
+ * Check to see if any future RCU-related work will need to be done
+ * by the current CPU, even if none need be done immediately, returning
+ * 1 if so.  This function is part of the RCU implementation; it is -not-
+ * an exported member of the RCU API.
+ */
+int rcu_needs_cpu(int cpu)
+{
+	/* RCU callbacks either ready or pending? */
+	return per_cpu(rcu_data, cpu).nxtlist ||
+	       per_cpu(rcu_bh_data, cpu).nxtlist;
+}
+
+/*
+ * Initialize a CPU's per-CPU RCU data.  We take this "scorched earth"
+ * approach so that we don't have to worry about how long the CPU has
+ * been gone, or whether it ever was online previously.  We do trust the
+ * ->mynode field, as it is constant for a given struct rcu_data and
+ * initialized during early boot.
+ *
+ * Note that only one online or offline event can be happening at a given
+ * time.  Note also that we can accept some slop in the rsp->completed
+ * access due to the fact that this CPU cannot possibly have any RCU
+ * callbacks in flight yet.
+ */
+static void
+rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
+{
+	unsigned long flags;
+	int i;
+	long lastcomp;
+	unsigned long mask;
+	struct rcu_data *rdp = rsp->rda[cpu];
+	struct rcu_node *rnp = rcu_get_root(rsp);
+
+	/* Set up local state, ensuring consistent view of global state. */
+	spin_lock_irqsave(&rnp->lock, flags);
+	lastcomp = rsp->completed;
+	rdp->completed = lastcomp;
+	rdp->gpnum = lastcomp;
+	rdp->passed_quiesc = 0;  /* We could be racing with new GP, */
+	rdp->qs_pending = 1;	 /*  so set up to respond to current GP. */
+	rdp->beenonline = 1;	 /* We have now been online. */
+	rdp->passed_quiesc_completed = lastcomp - 1;
+	rdp->grpmask = 1UL << (cpu - rdp->mynode->grplo);
+	rdp->nxtlist = NULL;
+	for (i = 0; i < RCU_NEXT_SIZE; i++)
+		rdp->nxttail[i] = &rdp->nxtlist;
+	rdp->qlen = 0;
+	rdp->blimit = blimit;
+#ifdef CONFIG_NO_HZ
+	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
+#endif /* #ifdef CONFIG_NO_HZ */
+	rdp->cpu = cpu;
+	spin_unlock(&rnp->lock);		/* irqs remain disabled. */
+
+	/*
+	 * A new grace period might start here.  If so, we won't be part
+	 * of it, but that is OK, as we are currently in a quiescent state.
+	 */
+
+	/* Exclude any attempts to start a new GP on large systems. */
+	spin_lock(&rsp->onofflock);		/* irqs already disabled. */
+
+	/* Add CPU to rcu_node bitmasks. */
+	rnp = rdp->mynode;
+	mask = rdp->grpmask;
+	do {
+		/* Exclude any attempts to start a new GP on small systems. */
+		spin_lock(&rnp->lock);	/* irqs already disabled. */
+		rnp->qsmaskinit |= mask;
+		mask = rnp->grpmask;
+		spin_unlock(&rnp->lock); /* irqs already disabled. */
+		rnp = rnp->parent;
+	} while (rnp != NULL && !(rnp->qsmaskinit & mask));
+
+	spin_unlock(&rsp->onofflock);		/* irqs remain disabled. */
+
+	/*
+	 * A new grace period might start here.  If so, we will be part of
+	 * it, and its gpnum will be greater than ours, so we will
+	 * participate.  It is also possible for the gpnum to have been
+	 * incremented before this function was called, and the bitmasks
+	 * to not be filled out until now, in which case we will also
+	 * participate due to our gpnum being behind.
+	 */
+
+	/* Since it is coming online, the CPU is in a quiescent state. */
+	cpu_quiet(cpu, rsp, rdp, lastcomp);
+	local_irq_restore(flags);
+}
+
+static void __cpuinit rcu_online_cpu(int cpu)
+{
+#ifdef CONFIG_NO_HZ
+	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
+
+	rdtp->dynticks_nesting = 1;
+	rdtp->dynticks |= 1; 	/* need consecutive #s even for hotplug. */
+	rdtp->dynticks_nmi = (rdtp->dynticks + 1) & ~0x1;
+#endif /* #ifdef CONFIG_NO_HZ */
+	rcu_init_percpu_data(cpu, &rcu_state);
+	rcu_init_percpu_data(cpu, &rcu_bh_state);
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+}
+
+/*
+ * Handle CPU online/offline notifcation events.
+ */
+static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
+				unsigned long action, void *hcpu)
+{
+	long cpu = (long)hcpu;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		rcu_online_cpu(cpu);
+		break;
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+		rcu_offline_cpu(cpu);
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+/*
+ * Compute the per-level fanout, either using the exact fanout specified
+ * or balancing the tree, depending on CONFIG_RCU_FANOUT_EXACT.
+ */
+#ifdef CONFIG_RCU_FANOUT_EXACT
+static void __init rcu_init_levelspread(struct rcu_state *rsp)
+{
+	int i;
+
+	for (i = NUM_RCU_LVLS - 1; i >= 0; i--)
+		rsp->levelspread[i] = CONFIG_RCU_FANOUT;
+}
+#else /* #ifdef CONFIG_RCU_FANOUT_EXACT */
+static void __init rcu_init_levelspread(struct rcu_state *rsp)
+{
+	int ccur;
+	int cprv;
+	int i;
+
+	cprv = NR_CPUS;
+	for (i = NUM_RCU_LVLS - 1; i >= 0; i--) {
+		ccur = rsp->levelcnt[i];
+		rsp->levelspread[i] = (cprv + ccur - 1) / ccur;
+		cprv = ccur;
+	}
+}
+#endif /* #else #ifdef CONFIG_RCU_FANOUT_EXACT */
+
+/*
+ * Helper function for rcu_init() that initializes one rcu_state structure.
+ */
+static void __init rcu_init_one(struct rcu_state *rsp)
+{
+	int cpustride = 1;
+	int i;
+	int j;
+	struct rcu_node *rnp;
+
+	/* Initialize the level-tracking arrays. */
+
+	for (i = 1; i < NUM_RCU_LVLS; i++)
+		rsp->level[i] = rsp->level[i - 1] + rsp->levelcnt[i - 1];
+	rcu_init_levelspread(rsp);
+
+	/* Initialize the elements themselves, starting from the leaves. */
+
+	for (i = NUM_RCU_LVLS - 1; i >= 0; i--) {
+		cpustride *= rsp->levelspread[i];
+		rnp = rsp->level[i];
+		for (j = 0; j < rsp->levelcnt[i]; j++, rnp++) {
+			spin_lock_init(&rnp->lock);
+			rnp->qsmask = 0;
+			rnp->qsmaskinit = 0;
+			rnp->grplo = j * cpustride;
+			rnp->grphi = (j + 1) * cpustride - 1;
+			if (rnp->grphi >= NR_CPUS)
+				rnp->grphi = NR_CPUS - 1;
+			if (i == 0) {
+				rnp->grpnum = 0;
+				rnp->grpmask = 0;
+				rnp->parent = NULL;
+			} else {
+				rnp->grpnum = j % rsp->levelspread[i - 1];
+				rnp->grpmask = 1UL << rnp->grpnum;
+				rnp->parent = rsp->level[i - 1] +
+					      j / rsp->levelspread[i - 1];
+			}
+			rnp->level = i;
+		}
+	}
+}
+
+/*
+ * Helper macro for __rcu_init().  To be used nowhere else!
+ * Assigns leaf node pointers into each CPU's rcu_data structure.
+ */
+#define RCU_DATA_PTR_INIT(rsp, rcu_data) \
+do { \
+	rnp = (rsp)->level[NUM_RCU_LVLS - 1]; \
+	j = 0; \
+	for_each_possible_cpu(i) { \
+		if (i > rnp[j].grphi) \
+			j++; \
+		per_cpu(rcu_data, i).mynode = &rnp[j]; \
+		(rsp)->rda[i] = &per_cpu(rcu_data, i); \
+	} \
+} while (0)
+
+static struct notifier_block __cpuinitdata rcu_nb = {
+	.notifier_call	= rcu_cpu_notify,
+};
+
+void __init __rcu_init(void)
+{
+	int i;			/* All used by RCU_DATA_PTR_INIT(). */
+	int j;
+	struct rcu_node *rnp;
+
+	printk(KERN_WARNING "Experimental hierarchical RCU implementation.\n");
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+	printk(KERN_INFO "RCU-based detection of stalled CPUs is enabled.\n");
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+	rcu_init_one(&rcu_state);
+	RCU_DATA_PTR_INIT(&rcu_state, rcu_data);
+	rcu_init_one(&rcu_bh_state);
+	RCU_DATA_PTR_INIT(&rcu_bh_state, rcu_bh_data);
+
+	for_each_online_cpu(i)
+		rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE, (void *)(long)i);
+	/* Register notifier for non-boot CPUs */
+	register_cpu_notifier(&rcu_nb);
+	printk(KERN_WARNING "Experimental hierarchical RCU init done.\n");
+}
+
+module_param(blimit, int, 0);
+module_param(qhimark, int, 0);
+module_param(qlowmark, int, 0);
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
new file mode 100644
index 0000000..6dc2807
--- /dev/null
+++ b/kernel/rcutree_trace.c
@@ -0,0 +1,238 @@
+/*
+ * Read-Copy Update tracing for classic implementation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2008
+ *
+ * Papers:  http://www.rdrop.com/users/paulmck/RCU
+ *
+ * For detailed explanation of Read-Copy Update mechanism see -
+ * 		Documentation/RCU
+ *
+ */
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/smp.h>
+#include <linux/rcupdate.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <asm/atomic.h>
+#include <linux/bitops.h>
+#include <linux/module.h>
+#include <linux/completion.h>
+#include <linux/moduleparam.h>
+#include <linux/percpu.h>
+#include <linux/notifier.h>
+#include <linux/cpu.h>
+#include <linux/mutex.h>
+#include <linux/debugfs.h>
+
+static DEFINE_MUTEX(rcuclassic_trace_mutex);
+static char *rcuclassic_trace_buf;
+#define RCUCLASSIC_TRACE_BUF_SIZE (512*num_possible_cpus())
+
+static int print_one_rcu_data(struct rcu_data *rdp, char *buf, char *ebuf)
+{
+	int cnt = 0;
+
+	if (!rdp->beenonline)
+		return 0;
+	cnt += snprintf(&buf[cnt], ebuf - &buf[cnt],
+		"%3d%cc=%ld g=%ld pq=%d pqc=%ld qp=%d rpfq=%ld rp=%x",
+		rdp->cpu,
+		cpu_is_offline(rdp->cpu) ? '!' : ' ',
+		rdp->completed, rdp->gpnum,
+		rdp->passed_quiesc, rdp->passed_quiesc_completed,
+		rdp->qs_pending,
+		rdp->n_rcu_pending_force_qs - rdp->n_rcu_pending,
+		(int)(rdp->n_rcu_pending & 0xffff));
+#ifdef CONFIG_NO_HZ
+	cnt += snprintf(&buf[cnt], ebuf - &buf[cnt],
+		" dt=%d/%d dn=%d df=%lu",
+		rdp->dynticks->dynticks,
+		rdp->dynticks->dynticks_nesting,
+		rdp->dynticks->dynticks_nmi,
+		rdp->dynticks_fqs);
+#endif /* #ifdef CONFIG_NO_HZ */
+	cnt += snprintf(&buf[cnt], ebuf - &buf[cnt],
+		" of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
+	cnt += snprintf(&buf[cnt], ebuf - &buf[cnt],
+		" ql=%ld b=%ld\n", rdp->qlen, rdp->blimit);
+	return cnt;
+}
+
+#define PRINT_RCU_DATA(name, buf, ebuf) \
+	do { \
+		int _p_r_d_i; \
+		\
+		for_each_possible_cpu(_p_r_d_i) \
+			(buf) += print_one_rcu_data(&per_cpu(name, _p_r_d_i), \
+						    buf, ebuf); \
+	} while (0)
+
+static ssize_t rcudata_read(struct file *filp, char __user *buffer,
+				size_t count, loff_t *ppos)
+{
+	ssize_t bcount;
+	char *buf = rcuclassic_trace_buf;
+	char *ebuf = &rcuclassic_trace_buf[RCUCLASSIC_TRACE_BUF_SIZE];
+
+	mutex_lock(&rcuclassic_trace_mutex);
+	buf += snprintf(buf, ebuf - buf, "rcu:\n");
+	PRINT_RCU_DATA(rcu_data, buf, ebuf);
+	buf += snprintf(buf, ebuf - buf, "rcu_bh:\n");
+	PRINT_RCU_DATA(rcu_bh_data, buf, ebuf);
+	bcount = simple_read_from_buffer(buffer, count, ppos,
+			rcuclassic_trace_buf, strlen(rcuclassic_trace_buf));
+	mutex_unlock(&rcuclassic_trace_mutex);
+	return bcount;
+}
+
+static int print_one_rcu_state(struct rcu_state *rsp, char *buf, char *ebuf)
+{
+	int cnt = 0;
+	int level = 0;
+	struct rcu_node *rnp;
+
+	cnt += snprintf(&buf[cnt], ebuf - &buf[cnt],
+			"c=%ld g=%ld s=%d jfq=%ld j=%x nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu\n",
+			rsp->completed, rsp->gpnum, rsp->signaled,
+			(long)(rsp->jiffies_force_qs - jiffies),
+			(int)(jiffies & 0xffff),
+			rsp->n_force_qs, rsp->n_force_qs_ngp,
+			rsp->n_force_qs - rsp->n_force_qs_ngp,
+			rsp->n_force_qs_lh);
+	for (rnp = &rsp->node[0]; rnp - &rsp->node[0] < NUM_RCU_NODES; rnp++) {
+		if (rnp->level != level) {
+			cnt += snprintf(&buf[cnt], ebuf - &buf[cnt], "\n");
+			level = rnp->level;
+		}
+		cnt += snprintf(&buf[cnt], ebuf - &buf[cnt],
+				"%lx/%lx %d:%d ^%d    ",
+				rnp->qsmask, rnp->qsmaskinit,
+				rnp->grplo, rnp->grphi, rnp->grpnum);
+	}
+	cnt += snprintf(&buf[cnt], ebuf - &buf[cnt], "\n");
+	return cnt;
+}
+
+static ssize_t rcuhier_read(struct file *filp, char __user *buffer,
+				size_t count, loff_t *ppos)
+{
+	ssize_t bcount;
+	char *buf = rcuclassic_trace_buf;
+	char *ebuf = &rcuclassic_trace_buf[RCUCLASSIC_TRACE_BUF_SIZE];
+
+	mutex_lock(&rcuclassic_trace_mutex);
+	buf += print_one_rcu_state(&rcu_state, buf, ebuf);
+	buf += snprintf(buf, ebuf - buf, "rcu_bh:\n");
+	buf += print_one_rcu_state(&rcu_bh_state, buf, ebuf);
+	bcount = simple_read_from_buffer(buffer, count, ppos,
+			rcuclassic_trace_buf, strlen(rcuclassic_trace_buf));
+	mutex_unlock(&rcuclassic_trace_mutex);
+	return bcount;
+}
+
+static ssize_t rcugp_read(struct file *filp, char __user *buffer,
+				size_t count, loff_t *ppos)
+{
+	ssize_t bcount;
+	char *buf = rcuclassic_trace_buf;
+	char *ebuf = &rcuclassic_trace_buf[RCUCLASSIC_TRACE_BUF_SIZE];
+
+	mutex_lock(&rcuclassic_trace_mutex);
+	buf += snprintf(buf, ebuf - buf, "rcu: completed=%ld  gpnum=%ld\n",
+			rcu_state.completed, rcu_state.gpnum);
+	buf += snprintf(buf, ebuf - buf, "rcu_bh: completed=%ld  gpnum=%ld\n",
+			rcu_bh_state.completed, rcu_bh_state.gpnum);
+	bcount = simple_read_from_buffer(buffer, count, ppos,
+			rcuclassic_trace_buf, strlen(rcuclassic_trace_buf));
+	mutex_unlock(&rcuclassic_trace_mutex);
+	return bcount;
+}
+
+static struct file_operations rcudata_fops = {
+	.owner = THIS_MODULE,
+	.read = rcudata_read,
+};
+
+static struct file_operations rcuhier_fops = {
+	.owner = THIS_MODULE,
+	.read = rcuhier_read,
+};
+
+static struct file_operations rcugp_fops = {
+	.owner = THIS_MODULE,
+	.read = rcugp_read,
+};
+
+static struct dentry *rcudir, *datadir, *hierdir, *gpdir;
+static int rcuclassic_debugfs_init(void)
+{
+	rcudir = debugfs_create_dir("rcu", NULL);
+	if (!rcudir)
+		goto out;
+	datadir = debugfs_create_file("rcudata", 0444, rcudir,
+						NULL, &rcudata_fops);
+	if (!datadir)
+		goto free_out;
+
+	gpdir = debugfs_create_file("rcugp", 0444, rcudir, NULL, &rcugp_fops);
+	if (!gpdir)
+		goto free_out;
+
+	hierdir = debugfs_create_file("rcuhier", 0444, rcudir,
+						NULL, &rcuhier_fops);
+	if (!hierdir)
+		goto free_out;
+	return 0;
+free_out:
+	if (datadir)
+		debugfs_remove(datadir);
+	if (gpdir)
+		debugfs_remove(gpdir);
+	debugfs_remove(rcudir);
+out:
+	return 1;
+}
+
+static int __init rcuclassic_trace_init(void)
+{
+	int ret;
+
+	rcuclassic_trace_buf = kmalloc(RCUCLASSIC_TRACE_BUF_SIZE, GFP_KERNEL);
+	if (!rcuclassic_trace_buf)
+		return 1;
+	ret = rcuclassic_debugfs_init();
+	if (ret)
+		kfree(rcuclassic_trace_buf);
+	return ret;
+}
+
+static void __exit rcuclassic_trace_cleanup(void)
+{
+	debugfs_remove(datadir);
+	debugfs_remove(gpdir);
+	debugfs_remove(hierdir);
+	debugfs_remove(rcudir);
+	kfree(rcuclassic_trace_buf);
+}
+
+
+module_init(rcuclassic_trace_init);
+module_exit(rcuclassic_trace_cleanup);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 7110dae..845107f 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -269,6 +269,7 @@ void irq_enter(void)
 {
 	int cpu = smp_processor_id();
 
+	rcu_irq_enter();
 	if (idle_cpu(cpu) && !in_interrupt())
 		tick_check_idle(cpu);
 
@@ -294,9 +295,9 @@ void irq_exit(void)
 
 #ifdef CONFIG_NO_HZ
 	/* Make sure that timer wheel updates are propagated */
-	if (!in_interrupt() && idle_cpu(smp_processor_id()) && !need_resched())
-		tick_nohz_stop_sched_tick(0);
 	rcu_irq_exit();
+	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
+		tick_nohz_stop_sched_tick(0);
 #endif
 	preempt_enable_no_resched();
 }
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index b0f239e..465d822 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -619,6 +619,19 @@ config RCU_CPU_STALL_DETECTOR
 
 	  Say N if you are unsure.
 
+config RCU_CPU_STALL_DETECTOR
+	bool "Check for stalled CPUs delaying RCU grace periods"
+	depends on CLASSIC_RCU || TREE_RCU
+	default n
+	help
+	  This option causes RCU to printk information on which
+	  CPUs are delaying the current grace period, but only when
+	  the grace period extends for excessive time periods.
+
+	  Say Y if you want RCU to perform such checks.
+
+	  Say N if you are unsure.
+
 config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
 	depends on DEBUG_KERNEL
