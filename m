Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbZLCSn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbZLCSn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 13:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbZLCSn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 13:43:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58916 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452AbZLCSnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 13:43:55 -0500
Date: Thu, 3 Dec 2009 19:43:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/rcu for v2.6.33
Message-ID: <20091203184339.GA29165@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -0.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.3 required=5.9 tests=BAYES_00,FB_SPACEY_ZIP autolearn=no SpamAssassin version=3.2.5
	1.7 FB_SPACEY_ZIP          BODY: Looks like a  s p a c e d zipcode.
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-rcu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-rcu-for-linus

Highlights:

 - RCU-Tiny

 - various difficult fixes for rare hangs

 - lots of cleanups

 - debuggability improvements

 - Enable the RCU stall-detector by default (the Kconfig option
   has been available for some time but default-off - so most people
   have it off already). This can find RCU bugs and it can also report
   hangs elsewhere in the kernel.

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      rcu: Do tiny cleanups in rcutiny

Lai Jiangshan (1):
      rcu: Cleanup: balance rcu_irq_enter()/rcu_irq_exit() calls

Paul E. McKenney (28):
      rcu: Add rnp->blocked_tasks to tracing
      rcu: Update trace.txt documentation to reflect recent changes
      rcu: Update trace.txt documentation for blocked-tasks lists
      rcu: "Tiny RCU", The Bloatwatch Edition
      rcu: Add synchronize_srcu_expedited()
      rcu: Add synchronize_srcu_expedited() to the rcutorture test suite
      rcu: Add synchronize_srcu_expedited() to the documentation
      rcu: Improve rcutorture diagnostics when bad torture_type specified
      rcu: Fix TINY_RCU #elif condition
      rcu: Prepare for synchronization fixes: clean up for non-NO_HZ handling of ->completed counter
      rcu: Fix synchronization for rcu_process_gp_end() uses of ->completed counter
      rcu: Fix note_new_gpnum() uses of ->gpnum
      rcu: Remove inline from forward-referenced functions
      rcu: Enable synchronize_sched_expedited() fastpath
      rcu: Rename dynticks_completed to completed_fqs
      rcu: Simplify association of quiescent states with grace periods
      rcu: Mark init-time-only rcu_bootup_announce() as __init
      rcu: Accelerate callback processing on CPUs not detecting GP end
      rcu: Simplify association of forced quiescent states with grace periods
      rcu: Further cleanups of use of lastcomp
      rcu: Eliminate __rcu_pending() false positives
      rcu: Fix grace-period-stall bug on large systems with CPU hotplug
      rcu: Eliminate unneeded function wrapping
      rcu: Re-arrange code to reduce #ifdef pain
      rcu: Rename "quiet" functions
      rcu: Enable fourth level of TREE_RCU hierarchy
      rcu: Add expedited grace-period support for preemptible RCU
      rcu: Make RCU's CPU-stall detector be default

Peter Zijlstra (1):
      rcu: Simplify creating of lockdep class for root rcu_node


 Documentation/RCU/trace.txt     |  254 ++++-----------------
 Documentation/RCU/whatisRCU.txt |    2 +-
 include/linux/hardirq.h         |   24 ++
 include/linux/rcupdate.h        |   10 +-
 include/linux/rcutiny.h         |  104 +++++++++
 include/linux/rcutree.h         |    7 +-
 include/linux/srcu.h            |    1 +
 init/Kconfig                    |    9 +
 kernel/Makefile                 |    1 +
 kernel/rcupdate.c               |  122 ----------
 kernel/rcutiny.c                |  282 ++++++++++++++++++++++++
 kernel/rcutorture.c             |   65 +++++-
 kernel/rcutree.c                |  465 ++++++++++++++++++++++++++-------------
 kernel/rcutree.h                |   69 +++++-
 kernel/rcutree_plugin.h         |  309 +++++++++++++++++++++++---
 kernel/rcutree_trace.c          |   12 +-
 kernel/sched.c                  |    1 +
 kernel/softirq.c                |    2 +-
 kernel/srcu.c                   |   74 +++++--
 lib/Kconfig.debug               |    2 +-
 20 files changed, 1234 insertions(+), 581 deletions(-)
 create mode 100644 include/linux/rcutiny.h
 create mode 100644 kernel/rcutiny.c

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 187bbf1..8608fd8 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -1,185 +1,10 @@
 CONFIG_RCU_TRACE debugfs Files and Formats
 
 
-The rcupreempt and rcutree implementations of RCU provide debugfs trace
-output that summarizes counters and state.  This information is useful for
-debugging RCU itself, and can sometimes also help to debug abuses of RCU.
-Note that the rcuclassic implementation of RCU does not provide debugfs
-trace output.
-
-The following sections describe the debugfs files and formats for
-preemptable RCU (rcupreempt) and hierarchical RCU (rcutree).
-
-
-Preemptable RCU debugfs Files and Formats
-
-This implementation of RCU provides three debugfs files under the
-top-level directory RCU: rcu/rcuctrs (which displays the per-CPU
-counters used by preemptable RCU) rcu/rcugp (which displays grace-period
-counters), and rcu/rcustats (which internal counters for debugging RCU).
-
-The output of "cat rcu/rcuctrs" looks as follows:
-
-CPU last cur F M
-  0    5  -5 0 0
-  1   -1   0 0 0
-  2    0   1 0 0
-  3    0   1 0 0
-  4    0   1 0 0
-  5    0   1 0 0
-  6    0   2 0 0
-  7    0  -1 0 0
-  8    0   1 0 0
-ggp = 26226, state = waitzero
-
-The per-CPU fields are as follows:
-
-o	"CPU" gives the CPU number.  Offline CPUs are not displayed.
-
-o	"last" gives the value of the counter that is being decremented
-	for the current grace period phase.  In the example above,
-	the counters sum to 4, indicating that there are still four
-	RCU read-side critical sections still running that started
-	before the last counter flip.
-
-o	"cur" gives the value of the counter that is currently being
-	both incremented (by rcu_read_lock()) and decremented (by
-	rcu_read_unlock()).  In the example above, the counters sum to
-	1, indicating that there is only one RCU read-side critical section
-	still running that started after the last counter flip.
-
-o	"F" indicates whether RCU is waiting for this CPU to acknowledge
-	a counter flip.  In the above example, RCU is not waiting on any,
-	which is consistent with the state being "waitzero" rather than
-	"waitack".
-
-o	"M" indicates whether RCU is waiting for this CPU to execute a
-	memory barrier.  In the above example, RCU is not waiting on any,
-	which is consistent with the state being "waitzero" rather than
-	"waitmb".
-
-o	"ggp" is the global grace-period counter.
-
-o	"state" is the RCU state, which can be one of the following:
-
-	o	"idle": there is no grace period in progress.
-
-	o	"waitack": RCU just incremented the global grace-period
-		counter, which has the effect of reversing the roles of
-		the "last" and "cur" counters above, and is waiting for
-		all the CPUs to acknowledge the flip.  Once the flip has
-		been acknowledged, CPUs will no longer be incrementing
-		what are now the "last" counters, so that their sum will
-		decrease monotonically down to zero.
-
-	o	"waitzero": RCU is waiting for the sum of the "last" counters
-		to decrease to zero.
-
-	o	"waitmb": RCU is waiting for each CPU to execute a memory
-		barrier, which ensures that instructions from a given CPU's
-		last RCU read-side critical section cannot be reordered
-		with instructions following the memory-barrier instruction.
-
-The output of "cat rcu/rcugp" looks as follows:
-
-oldggp=48870  newggp=48873
-
-Note that reading from this file provokes a synchronize_rcu().  The
-"oldggp" value is that of "ggp" from rcu/rcuctrs above, taken before
-executing the synchronize_rcu(), and the "newggp" value is also the
-"ggp" value, but taken after the synchronize_rcu() command returns.
-
-
-The output of "cat rcu/rcugp" looks as follows:
-
-na=1337955 nl=40 wa=1337915 wl=44 da=1337871 dl=0 dr=1337871 di=1337871
-1=50989 e1=6138 i1=49722 ie1=82 g1=49640 a1=315203 ae1=265563 a2=49640
-z1=1401244 ze1=1351605 z2=49639 m1=5661253 me1=5611614 m2=49639
-
-These are counters tracking internal preemptable-RCU events, however,
-some of them may be useful for debugging algorithms using RCU.  In
-particular, the "nl", "wl", and "dl" values track the number of RCU
-callbacks in various states.  The fields are as follows:
-
-o	"na" is the total number of RCU callbacks that have been enqueued
-	since boot.
-
-o	"nl" is the number of RCU callbacks waiting for the previous
-	grace period to end so that they can start waiting on the next
-	grace period.
-
-o	"wa" is the total number of RCU callbacks that have started waiting
-	for a grace period since boot.  "na" should be roughly equal to
-	"nl" plus "wa".
-
-o	"wl" is the number of RCU callbacks currently waiting for their
-	grace period to end.
-
-o	"da" is the total number of RCU callbacks whose grace periods
-	have completed since boot.  "wa" should be roughly equal to
-	"wl" plus "da".
-
-o	"dr" is the total number of RCU callbacks that have been removed
-	from the list of callbacks ready to invoke.  "dr" should be roughly
-	equal to "da".
-
-o	"di" is the total number of RCU callbacks that have been invoked
-	since boot.  "di" should be roughly equal to "da", though some
-	early versions of preemptable RCU had a bug so that only the
-	last CPU's count of invocations was displayed, rather than the
-	sum of all CPU's counts.
-
-o	"1" is the number of calls to rcu_try_flip().  This should be
-	roughly equal to the sum of "e1", "i1", "a1", "z1", and "m1"
-	described below.  In other words, the number of times that
-	the state machine is visited should be equal to the sum of the
-	number of times that each state is visited plus the number of
-	times that the state-machine lock acquisition failed.
-
-o	"e1" is the number of times that rcu_try_flip() was unable to
-	acquire the fliplock.
-
-o	"i1" is the number of calls to rcu_try_flip_idle().
-
-o	"ie1" is the number of times rcu_try_flip_idle() exited early
-	due to the calling CPU having no work for RCU.
-
-o	"g1" is the number of times that rcu_try_flip_idle() decided
-	to start a new grace period.  "i1" should be roughly equal to
-	"ie1" plus "g1".
-
-o	"a1" is the number of calls to rcu_try_flip_waitack().
-
-o	"ae1" is the number of times that rcu_try_flip_waitack() found
-	that at least one CPU had not yet acknowledge the new grace period
-	(AKA "counter flip").
-
-o	"a2" is the number of time rcu_try_flip_waitack() found that
-	all CPUs had acknowledged.  "a1" should be roughly equal to
-	"ae1" plus "a2".  (This particular output was collected on
-	a 128-CPU machine, hence the smaller-than-usual fraction of
-	calls to rcu_try_flip_waitack() finding all CPUs having already
-	acknowledged.)
-
-o	"z1" is the number of calls to rcu_try_flip_waitzero().
-
-o	"ze1" is the number of times that rcu_try_flip_waitzero() found
-	that not all of the old RCU read-side critical sections had
-	completed.
-
-o	"z2" is the number of times that rcu_try_flip_waitzero() finds
-	the sum of the counters equal to zero, in other words, that
-	all of the old RCU read-side critical sections had completed.
-	The value of "z1" should be roughly equal to "ze1" plus
-	"z2".
-
-o	"m1" is the number of calls to rcu_try_flip_waitmb().
-
-o	"me1" is the number of times that rcu_try_flip_waitmb() finds
-	that at least one CPU has not yet executed a memory barrier.
-
-o	"m2" is the number of times that rcu_try_flip_waitmb() finds that
-	all CPUs have executed a memory barrier.
+The rcutree implementation of RCU provides debugfs trace output that
+summarizes counters and state.  This information is useful for debugging
+RCU itself, and can sometimes also help to debug abuses of RCU.
+The following sections describe the debugfs files and formats.
 
 
 Hierarchical RCU debugfs Files and Formats
@@ -210,9 +35,10 @@ rcu_bh:
   6 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=859/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
   7 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=3761/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
 
-The first section lists the rcu_data structures for rcu, the second for
-rcu_bh.  Each section has one line per CPU, or eight for this 8-CPU system.
-The fields are as follows:
+The first section lists the rcu_data structures for rcu_sched, the second
+for rcu_bh.  Note that CONFIG_TREE_PREEMPT_RCU kernels will have an
+additional section for rcu_preempt.  Each section has one line per CPU,
+or eight for this 8-CPU system.  The fields are as follows:
 
 o	The number at the beginning of each line is the CPU number.
 	CPUs numbers followed by an exclamation mark are offline,
@@ -223,9 +49,9 @@ o	The number at the beginning of each line is the CPU number.
 
 o	"c" is the count of grace periods that this CPU believes have
 	completed.  CPUs in dynticks idle mode may lag quite a ways
-	behind, for example, CPU 4 under "rcu" above, which has slept
-	through the past 25 RCU grace periods.	It is not unusual to
-	see CPUs lagging by thousands of grace periods.
+	behind, for example, CPU 4 under "rcu_sched" above, which has
+	slept through the past 25 RCU grace periods.  It is not unusual
+	to see CPUs lagging by thousands of grace periods.
 
 o	"g" is the count of grace periods that this CPU believes have
 	started.  Again, CPUs in dynticks idle mode may lag behind.
@@ -308,8 +134,10 @@ The output of "cat rcu/rcugp" looks as follows:
 rcu_sched: completed=33062  gpnum=33063
 rcu_bh: completed=464  gpnum=464
 
-Again, this output is for both "rcu" and "rcu_bh".  The fields are
-taken from the rcu_state structure, and are as follows:
+Again, this output is for both "rcu_sched" and "rcu_bh".  Note that
+kernels built with CONFIG_TREE_PREEMPT_RCU will have an additional
+"rcu_preempt" line.  The fields are taken from the rcu_state structure,
+and are as follows:
 
 o	"completed" is the number of grace periods that have completed.
 	It is comparable to the "c" field from rcu/rcudata in that a
@@ -324,23 +152,24 @@ o	"gpnum" is the number of grace periods that have started.  It is
 	If these two fields are equal (as they are for "rcu_bh" above),
 	then there is no grace period in progress, in other words, RCU
 	is idle.  On the other hand, if the two fields differ (as they
-	do for "rcu" above), then an RCU grace period is in progress.
+	do for "rcu_sched" above), then an RCU grace period is in progress.
 
 
 The output of "cat rcu/rcuhier" looks as follows, with very long lines:
 
-c=6902 g=6903 s=2 jfq=3 j=72c7 nfqs=13142/nfqsng=0(13142) fqlh=6
-1/1 0:127 ^0    
-3/3 0:35 ^0    0/0 36:71 ^1    0/0 72:107 ^2    0/0 108:127 ^3    
-3/3f 0:5 ^0    2/3 6:11 ^1    0/0 12:17 ^2    0/0 18:23 ^3    0/0 24:29 ^4    0/0 30:35 ^5    0/0 36:41 ^0    0/0 42:47 ^1    0/0 48:53 ^2    0/0 54:59 ^3    0/0 60:65 ^4    0/0 66:71 ^5    0/0 72:77 ^0    0/0 78:83 ^1    0/0 84:89 ^2    0/0 90:95 ^3    0/0 96:101 ^4    0/0 102:107 ^5    0/0 108:113 ^0    0/0 114:119 ^1    0/0 120:125 ^2    0/0 126:127 ^3    
+c=6902 g=6903 s=2 jfq=3 j=72c7 nfqs=13142/nfqsng=0(13142) fqlh=6 oqlen=0
+1/1 .>. 0:127 ^0    
+3/3 .>. 0:35 ^0    0/0 .>. 36:71 ^1    0/0 .>. 72:107 ^2    0/0 .>. 108:127 ^3    
+3/3f .>. 0:5 ^0    2/3 .>. 6:11 ^1    0/0 .>. 12:17 ^2    0/0 .>. 18:23 ^3    0/0 .>. 24:29 ^4    0/0 .>. 30:35 ^5    0/0 .>. 36:41 ^0    0/0 .>. 42:47 ^1    0/0 .>. 48:53 ^2    0/0 .>. 54:59 ^3    0/0 .>. 60:65 ^4    0/0 .>. 66:71 ^5    0/0 .>. 72:77 ^0    0/0 .>. 78:83 ^1    0/0 .>. 84:89 ^2    0/0 .>. 90:95 ^3    0/0 .>. 96:101 ^4    0/0 .>. 102:107 ^5    0/0 .>. 108:113 ^0    0/0 .>. 114:119 ^1    0/0 .>. 120:125 ^2    0/0 .>. 126:127 ^3    
 rcu_bh:
-c=-226 g=-226 s=1 jfq=-5701 j=72c7 nfqs=88/nfqsng=0(88) fqlh=0
-0/1 0:127 ^0    
-0/3 0:35 ^0    0/0 36:71 ^1    0/0 72:107 ^2    0/0 108:127 ^3    
-0/3f 0:5 ^0    0/3 6:11 ^1    0/0 12:17 ^2    0/0 18:23 ^3    0/0 24:29 ^4    0/0 30:35 ^5    0/0 36:41 ^0    0/0 42:47 ^1    0/0 48:53 ^2    0/0 54:59 ^3    0/0 60:65 ^4    0/0 66:71 ^5    0/0 72:77 ^0    0/0 78:83 ^1    0/0 84:89 ^2    0/0 90:95 ^3    0/0 96:101 ^4    0/0 102:107 ^5    0/0 108:113 ^0    0/0 114:119 ^1    0/0 120:125 ^2    0/0 126:127 ^3
+c=-226 g=-226 s=1 jfq=-5701 j=72c7 nfqs=88/nfqsng=0(88) fqlh=0 oqlen=0
+0/1 .>. 0:127 ^0    
+0/3 .>. 0:35 ^0    0/0 .>. 36:71 ^1    0/0 .>. 72:107 ^2    0/0 .>. 108:127 ^3    
+0/3f .>. 0:5 ^0    0/3 .>. 6:11 ^1    0/0 .>. 12:17 ^2    0/0 .>. 18:23 ^3    0/0 .>. 24:29 ^4    0/0 .>. 30:35 ^5    0/0 .>. 36:41 ^0    0/0 .>. 42:47 ^1    0/0 .>. 48:53 ^2    0/0 .>. 54:59 ^3    0/0 .>. 60:65 ^4    0/0 .>. 66:71 ^5    0/0 .>. 72:77 ^0    0/0 .>. 78:83 ^1    0/0 .>. 84:89 ^2    0/0 .>. 90:95 ^3    0/0 .>. 96:101 ^4    0/0 .>. 102:107 ^5    0/0 .>. 108:113 ^0    0/0 .>. 114:119 ^1    0/0 .>. 120:125 ^2    0/0 .>. 126:127 ^3
 
-This is once again split into "rcu" and "rcu_bh" portions.  The fields are
-as follows:
+This is once again split into "rcu_sched" and "rcu_bh" portions,
+and CONFIG_TREE_PREEMPT_RCU kernels will again have an additional
+"rcu_preempt" section.  The fields are as follows:
 
 o	"c" is exactly the same as "completed" under rcu/rcugp.
 
@@ -372,6 +201,11 @@ o	"fqlh" is the number of calls to force_quiescent_state() that
 	exited immediately (without even being counted in nfqs above)
 	due to contention on ->fqslock.
 
+o	"oqlen" is the number of callbacks on the "orphan" callback
+	list.  RCU callbacks are placed on this list by CPUs going
+	offline, and are "adopted" either by the CPU helping the outgoing
+	CPU or by the next rcu_barrier*() call, whichever comes first.
+
 o	Each element of the form "1/1 0:127 ^0" represents one struct
 	rcu_node.  Each line represents one level of the hierarchy, from
 	root to leaves.  It is best to think of the rcu_data structures
@@ -379,7 +213,7 @@ o	Each element of the form "1/1 0:127 ^0" represents one struct
 	might be either one, two, or three levels of rcu_node structures,
 	depending on the relationship between CONFIG_RCU_FANOUT and
 	CONFIG_NR_CPUS.
-	
+
 	o	The numbers separated by the "/" are the qsmask followed
 		by the qsmaskinit.  The qsmask will have one bit
 		set for each entity in the next lower level that
@@ -389,10 +223,19 @@ o	Each element of the form "1/1 0:127 ^0" represents one struct
 		The value of qsmaskinit is assigned to that of qsmask
 		at the beginning of each grace period.
 
-		For example, for "rcu", the qsmask of the first entry
-		of the lowest level is 0x14, meaning that we are still
-		waiting for CPUs 2 and 4 to check in for the current
-		grace period.
+		For example, for "rcu_sched", the qsmask of the first
+		entry of the lowest level is 0x14, meaning that we
+		are still waiting for CPUs 2 and 4 to check in for the
+		current grace period.
+
+	o	The characters separated by the ">" indicate the state
+		of the blocked-tasks lists.  A "T" preceding the ">"
+		indicates that at least one task blocked in an RCU
+		read-side critical section blocks the current grace
+		period, while a "." preceding the ">" indicates otherwise.
+		The character following the ">" indicates similarly for
+		the next grace period.  A "T" should appear in this
+		field only for rcu-preempt.
 
 	o	The numbers separated by the ":" are the range of CPUs
 		served by this struct rcu_node.  This can be helpful
@@ -431,8 +274,9 @@ rcu_bh:
   6 np=120834 qsp=9902 cbr=0 cng=0 gpc=6 gps=3 nf=2 nn=110921
   7 np=144888 qsp=26336 cbr=0 cng=0 gpc=8 gps=2 nf=0 nn=118542
 
-As always, this is once again split into "rcu" and "rcu_bh" portions.
-The fields are as follows:
+As always, this is once again split into "rcu_sched" and "rcu_bh"
+portions, with CONFIG_TREE_PREEMPT_RCU kernels having an additional
+"rcu_preempt" section.  The fields are as follows:
 
 o	"np" is the number of times that __rcu_pending() has been invoked
 	for the corresponding flavor of RCU.
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index e41a7fe..d542ca2 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -830,7 +830,7 @@ sched:	Critical sections	Grace period		Barrier
 SRCU:	Critical sections	Grace period		Barrier
 
 	srcu_read_lock		synchronize_srcu	N/A
-	srcu_read_unlock
+	srcu_read_unlock	synchronize_srcu_expedited
 
 SRCU:	Initialization/cleanup
 	init_srcu_struct
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 6d527ee..d5b3876 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -139,10 +139,34 @@ static inline void account_system_vtime(struct task_struct *tsk)
 #endif
 
 #if defined(CONFIG_NO_HZ)
+#if defined(CONFIG_TINY_RCU)
+extern void rcu_enter_nohz(void);
+extern void rcu_exit_nohz(void);
+
+static inline void rcu_irq_enter(void)
+{
+	rcu_exit_nohz();
+}
+
+static inline void rcu_irq_exit(void)
+{
+	rcu_enter_nohz();
+}
+
+static inline void rcu_nmi_enter(void)
+{
+}
+
+static inline void rcu_nmi_exit(void)
+{
+}
+
+#else
 extern void rcu_irq_enter(void);
 extern void rcu_irq_exit(void);
 extern void rcu_nmi_enter(void);
 extern void rcu_nmi_exit(void);
+#endif
 #else
 # define rcu_irq_enter() do { } while (0)
 # define rcu_irq_exit() do { } while (0)
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 3ebd0b7..24440f4 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -52,11 +52,6 @@ struct rcu_head {
 };
 
 /* Exported common interfaces */
-#ifdef CONFIG_TREE_PREEMPT_RCU
-extern void synchronize_rcu(void);
-#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-#define synchronize_rcu synchronize_sched
-#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 extern void synchronize_rcu_bh(void);
 extern void synchronize_sched(void);
 extern void rcu_barrier(void);
@@ -67,12 +62,11 @@ extern int sched_expedited_torture_stats(char *page);
 
 /* Internal to kernel */
 extern void rcu_init(void);
-extern void rcu_scheduler_starting(void);
-extern int rcu_needs_cpu(int cpu);
-extern int rcu_scheduler_active;
 
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 #include <linux/rcutree.h>
+#elif defined(CONFIG_TINY_RCU)
+#include <linux/rcutiny.h>
 #else
 #error "Unknown RCU implementation specified to kernel configuration"
 #endif
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
new file mode 100644
index 0000000..c4ba9a7
--- /dev/null
+++ b/include/linux/rcutiny.h
@@ -0,0 +1,104 @@
+/*
+ * Read-Copy Update mechanism for mutual exclusion, the Bloatwatch edition.
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
+ * Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+ *
+ * For detailed explanation of Read-Copy Update mechanism see -
+ *		Documentation/RCU
+ */
+#ifndef __LINUX_TINY_H
+#define __LINUX_TINY_H
+
+#include <linux/cache.h>
+
+void rcu_sched_qs(int cpu);
+void rcu_bh_qs(int cpu);
+
+#define __rcu_read_lock()	preempt_disable()
+#define __rcu_read_unlock()	preempt_enable()
+#define __rcu_read_lock_bh()	local_bh_disable()
+#define __rcu_read_unlock_bh()	local_bh_enable()
+#define call_rcu_sched		call_rcu
+
+#define rcu_init_sched()	do { } while (0)
+extern void rcu_check_callbacks(int cpu, int user);
+
+static inline int rcu_needs_cpu(int cpu)
+{
+	return 0;
+}
+
+/*
+ * Return the number of grace periods.
+ */
+static inline long rcu_batches_completed(void)
+{
+	return 0;
+}
+
+/*
+ * Return the number of bottom-half grace periods.
+ */
+static inline long rcu_batches_completed_bh(void)
+{
+	return 0;
+}
+
+extern int rcu_expedited_torture_stats(char *page);
+
+#define synchronize_rcu synchronize_sched
+
+static inline void synchronize_rcu_expedited(void)
+{
+	synchronize_sched();
+}
+
+static inline void synchronize_rcu_bh_expedited(void)
+{
+	synchronize_sched();
+}
+
+struct notifier_block;
+
+#ifdef CONFIG_NO_HZ
+
+extern void rcu_enter_nohz(void);
+extern void rcu_exit_nohz(void);
+
+#else /* #ifdef CONFIG_NO_HZ */
+
+static inline void rcu_enter_nohz(void)
+{
+}
+
+static inline void rcu_exit_nohz(void)
+{
+}
+
+#endif /* #else #ifdef CONFIG_NO_HZ */
+
+static inline void rcu_scheduler_starting(void)
+{
+}
+
+static inline void exit_rcu(void)
+{
+}
+
+#endif /* __LINUX_RCUTINY_H */
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 9642c6b..c93eee5 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -34,15 +34,15 @@ struct notifier_block;
 
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
-extern int rcu_cpu_notify(struct notifier_block *self,
-			  unsigned long action, void *hcpu);
 extern int rcu_needs_cpu(int cpu);
+extern void rcu_scheduler_starting(void);
 extern int rcu_expedited_torture_stats(char *page);
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
 extern void __rcu_read_lock(void);
 extern void __rcu_read_unlock(void);
+extern void synchronize_rcu(void);
 extern void exit_rcu(void);
 
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
@@ -57,7 +57,7 @@ static inline void __rcu_read_unlock(void)
 	preempt_enable();
 }
 
-#define __synchronize_sched() synchronize_rcu()
+#define synchronize_rcu synchronize_sched
 
 static inline void exit_rcu(void)
 {
@@ -83,7 +83,6 @@ static inline void synchronize_rcu_bh_expedited(void)
 	synchronize_sched_expedited();
 }
 
-extern void __rcu_init(void);
 extern void rcu_check_callbacks(int cpu, int user);
 
 extern long rcu_batches_completed(void);
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index aca0eee..4765d97 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -48,6 +48,7 @@ void cleanup_srcu_struct(struct srcu_struct *sp);
 int srcu_read_lock(struct srcu_struct *sp) __acquires(sp);
 void srcu_read_unlock(struct srcu_struct *sp, int idx) __releases(sp);
 void synchronize_srcu(struct srcu_struct *sp);
+void synchronize_srcu_expedited(struct srcu_struct *sp);
 long srcu_batches_completed(struct srcu_struct *sp);
 
 #endif
diff --git a/init/Kconfig b/init/Kconfig
index 09c5c64..d367bf6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -334,6 +334,15 @@ config TREE_PREEMPT_RCU
 	  is also required.  It also scales down nicely to
 	  smaller systems.
 
+config TINY_RCU
+	bool "UP-only small-memory-footprint RCU"
+	depends on !SMP
+	help
+	  This option selects the RCU implementation that is
+	  designed for UP systems from which real-time response
+	  is not required.  This option greatly reduces the
+	  memory footprint of RCU.
+
 endchoice
 
 config RCU_TRACE
diff --git a/kernel/Makefile b/kernel/Makefile
index b8d4cd8..e9a0e6e 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -82,6 +82,7 @@ obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_TREE_RCU) += rcutree.o
 obj-$(CONFIG_TREE_PREEMPT_RCU) += rcutree.o
 obj-$(CONFIG_TREE_RCU_TRACE) += rcutree_trace.o
+obj-$(CONFIG_TINY_RCU) += rcutiny.o
 obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 4001833..9b7fd47 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -44,7 +44,6 @@
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
-#include <linux/kernel_stat.h>
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key rcu_lock_key;
@@ -53,8 +52,6 @@ struct lockdep_map rcu_lock_map =
 EXPORT_SYMBOL_GPL(rcu_lock_map);
 #endif
 
-int rcu_scheduler_active __read_mostly;
-
 /*
  * Awaken the corresponding synchronize_rcu() instance now that a
  * grace period has elapsed.
@@ -66,122 +63,3 @@ void wakeme_after_rcu(struct rcu_head  *head)
 	rcu = container_of(head, struct rcu_synchronize, head);
 	complete(&rcu->completion);
 }
-
-#ifdef CONFIG_TREE_PREEMPT_RCU
-
-/**
- * synchronize_rcu - wait until a grace period has elapsed.
- *
- * Control will return to the caller some time after a full grace
- * period has elapsed, in other words after all currently executing RCU
- * read-side critical sections have completed.  RCU read-side critical
- * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
- * and may be nested.
- */
-void synchronize_rcu(void)
-{
-	struct rcu_synchronize rcu;
-
-	if (!rcu_scheduler_active)
-		return;
-
-	init_completion(&rcu.completion);
-	/* Will wake me after RCU finished. */
-	call_rcu(&rcu.head, wakeme_after_rcu);
-	/* Wait for it. */
-	wait_for_completion(&rcu.completion);
-}
-EXPORT_SYMBOL_GPL(synchronize_rcu);
-
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-
-/**
- * synchronize_sched - wait until an rcu-sched grace period has elapsed.
- *
- * Control will return to the caller some time after a full rcu-sched
- * grace period has elapsed, in other words after all currently executing
- * rcu-sched read-side critical sections have completed.   These read-side
- * critical sections are delimited by rcu_read_lock_sched() and
- * rcu_read_unlock_sched(), and may be nested.  Note that preempt_disable(),
- * local_irq_disable(), and so on may be used in place of
- * rcu_read_lock_sched().
- *
- * This means that all preempt_disable code sequences, including NMI and
- * hardware-interrupt handlers, in progress on entry will have completed
- * before this primitive returns.  However, this does not guarantee that
- * softirq handlers will have completed, since in some kernels, these
- * handlers can run in process context, and can block.
- *
- * This primitive provides the guarantees made by the (now removed)
- * synchronize_kernel() API.  In contrast, synchronize_rcu() only
- * guarantees that rcu_read_lock() sections will have completed.
- * In "classic RCU", these two guarantees happen to be one and
- * the same, but can differ in realtime RCU implementations.
- */
-void synchronize_sched(void)
-{
-	struct rcu_synchronize rcu;
-
-	if (rcu_blocking_is_gp())
-		return;
-
-	init_completion(&rcu.completion);
-	/* Will wake me after RCU finished. */
-	call_rcu_sched(&rcu.head, wakeme_after_rcu);
-	/* Wait for it. */
-	wait_for_completion(&rcu.completion);
-}
-EXPORT_SYMBOL_GPL(synchronize_sched);
-
-/**
- * synchronize_rcu_bh - wait until an rcu_bh grace period has elapsed.
- *
- * Control will return to the caller some time after a full rcu_bh grace
- * period has elapsed, in other words after all currently executing rcu_bh
- * read-side critical sections have completed.  RCU read-side critical
- * sections are delimited by rcu_read_lock_bh() and rcu_read_unlock_bh(),
- * and may be nested.
- */
-void synchronize_rcu_bh(void)
-{
-	struct rcu_synchronize rcu;
-
-	if (rcu_blocking_is_gp())
-		return;
-
-	init_completion(&rcu.completion);
-	/* Will wake me after RCU finished. */
-	call_rcu_bh(&rcu.head, wakeme_after_rcu);
-	/* Wait for it. */
-	wait_for_completion(&rcu.completion);
-}
-EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
-
-static int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
-		unsigned long action, void *hcpu)
-{
-	return rcu_cpu_notify(self, action, hcpu);
-}
-
-void __init rcu_init(void)
-{
-	int i;
-
-	__rcu_init();
-	cpu_notifier(rcu_barrier_cpu_hotplug, 0);
-
-	/*
-	 * We don't need protection against CPU-hotplug here because
-	 * this is called early in boot, before either interrupts
-	 * or the scheduler are operational.
-	 */
-	for_each_online_cpu(i)
-		rcu_barrier_cpu_hotplug(NULL, CPU_UP_PREPARE, (void *)(long)i);
-}
-
-void rcu_scheduler_starting(void)
-{
-	WARN_ON(num_online_cpus() != 1);
-	WARN_ON(nr_context_switches() > 0);
-	rcu_scheduler_active = 1;
-}
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
new file mode 100644
index 0000000..9f6d9ff
--- /dev/null
+++ b/kernel/rcutiny.c
@@ -0,0 +1,282 @@
+/*
+ * Read-Copy Update mechanism for mutual exclusion, the Bloatwatch edition.
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
+ * Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+ *
+ * For detailed explanation of Read-Copy Update mechanism see -
+ *		Documentation/RCU
+ */
+#include <linux/moduleparam.h>
+#include <linux/completion.h>
+#include <linux/interrupt.h>
+#include <linux/notifier.h>
+#include <linux/rcupdate.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/time.h>
+#include <linux/cpu.h>
+
+/* Global control variables for rcupdate callback mechanism. */
+struct rcu_ctrlblk {
+	struct rcu_head *rcucblist;	/* List of pending callbacks (CBs). */
+	struct rcu_head **donetail;	/* ->next pointer of last "done" CB. */
+	struct rcu_head **curtail;	/* ->next pointer of last CB. */
+};
+
+/* Definition for rcupdate control block. */
+static struct rcu_ctrlblk rcu_ctrlblk = {
+	.donetail	= &rcu_ctrlblk.rcucblist,
+	.curtail	= &rcu_ctrlblk.rcucblist,
+};
+
+static struct rcu_ctrlblk rcu_bh_ctrlblk = {
+	.donetail	= &rcu_bh_ctrlblk.rcucblist,
+	.curtail	= &rcu_bh_ctrlblk.rcucblist,
+};
+
+#ifdef CONFIG_NO_HZ
+
+static long rcu_dynticks_nesting = 1;
+
+/*
+ * Enter dynticks-idle mode, which is an extended quiescent state
+ * if we have fully entered that mode (i.e., if the new value of
+ * dynticks_nesting is zero).
+ */
+void rcu_enter_nohz(void)
+{
+	if (--rcu_dynticks_nesting == 0)
+		rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
+}
+
+/*
+ * Exit dynticks-idle mode, so that we are no longer in an extended
+ * quiescent state.
+ */
+void rcu_exit_nohz(void)
+{
+	rcu_dynticks_nesting++;
+}
+
+#endif /* #ifdef CONFIG_NO_HZ */
+
+/*
+ * Helper function for rcu_qsctr_inc() and rcu_bh_qsctr_inc().
+ * Also disable irqs to avoid confusion due to interrupt handlers
+ * invoking call_rcu().
+ */
+static int rcu_qsctr_help(struct rcu_ctrlblk *rcp)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	if (rcp->rcucblist != NULL &&
+	    rcp->donetail != rcp->curtail) {
+		rcp->donetail = rcp->curtail;
+		local_irq_restore(flags);
+		return 1;
+	}
+	local_irq_restore(flags);
+
+	return 0;
+}
+
+/*
+ * Record an rcu quiescent state.  And an rcu_bh quiescent state while we
+ * are at it, given that any rcu quiescent state is also an rcu_bh
+ * quiescent state.  Use "+" instead of "||" to defeat short circuiting.
+ */
+void rcu_sched_qs(int cpu)
+{
+	if (rcu_qsctr_help(&rcu_ctrlblk) + rcu_qsctr_help(&rcu_bh_ctrlblk))
+		raise_softirq(RCU_SOFTIRQ);
+}
+
+/*
+ * Record an rcu_bh quiescent state.
+ */
+void rcu_bh_qs(int cpu)
+{
+	if (rcu_qsctr_help(&rcu_bh_ctrlblk))
+		raise_softirq(RCU_SOFTIRQ);
+}
+
+/*
+ * Check to see if the scheduling-clock interrupt came from an extended
+ * quiescent state, and, if so, tell RCU about it.
+ */
+void rcu_check_callbacks(int cpu, int user)
+{
+	if (user ||
+	    (idle_cpu(cpu) &&
+	     !in_softirq() &&
+	     hardirq_count() <= (1 << HARDIRQ_SHIFT)))
+		rcu_sched_qs(cpu);
+	else if (!in_softirq())
+		rcu_bh_qs(cpu);
+}
+
+/*
+ * Helper function for rcu_process_callbacks() that operates on the
+ * specified rcu_ctrlkblk structure.
+ */
+static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
+{
+	struct rcu_head *next, *list;
+	unsigned long flags;
+
+	/* If no RCU callbacks ready to invoke, just return. */
+	if (&rcp->rcucblist == rcp->donetail)
+		return;
+
+	/* Move the ready-to-invoke callbacks to a local list. */
+	local_irq_save(flags);
+	list = rcp->rcucblist;
+	rcp->rcucblist = *rcp->donetail;
+	*rcp->donetail = NULL;
+	if (rcp->curtail == rcp->donetail)
+		rcp->curtail = &rcp->rcucblist;
+	rcp->donetail = &rcp->rcucblist;
+	local_irq_restore(flags);
+
+	/* Invoke the callbacks on the local list. */
+	while (list) {
+		next = list->next;
+		prefetch(next);
+		list->func(list);
+		list = next;
+	}
+}
+
+/*
+ * Invoke any callbacks whose grace period has completed.
+ */
+static void rcu_process_callbacks(struct softirq_action *unused)
+{
+	__rcu_process_callbacks(&rcu_ctrlblk);
+	__rcu_process_callbacks(&rcu_bh_ctrlblk);
+}
+
+/*
+ * Wait for a grace period to elapse.  But it is illegal to invoke
+ * synchronize_sched() from within an RCU read-side critical section.
+ * Therefore, any legal call to synchronize_sched() is a quiescent
+ * state, and so on a UP system, synchronize_sched() need do nothing.
+ * Ditto for synchronize_rcu_bh().  (But Lai Jiangshan points out the
+ * benefits of doing might_sleep() to reduce latency.)
+ *
+ * Cool, huh?  (Due to Josh Triplett.)
+ *
+ * But we want to make this a static inline later.
+ */
+void synchronize_sched(void)
+{
+	cond_resched();
+}
+EXPORT_SYMBOL_GPL(synchronize_sched);
+
+void synchronize_rcu_bh(void)
+{
+	synchronize_sched();
+}
+EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
+
+/*
+ * Helper function for call_rcu() and call_rcu_bh().
+ */
+static void __call_rcu(struct rcu_head *head,
+		       void (*func)(struct rcu_head *rcu),
+		       struct rcu_ctrlblk *rcp)
+{
+	unsigned long flags;
+
+	head->func = func;
+	head->next = NULL;
+
+	local_irq_save(flags);
+	*rcp->curtail = head;
+	rcp->curtail = &head->next;
+	local_irq_restore(flags);
+}
+
+/*
+ * Post an RCU callback to be invoked after the end of an RCU grace
+ * period.  But since we have but one CPU, that would be after any
+ * quiescent state.
+ */
+void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
+{
+	__call_rcu(head, func, &rcu_ctrlblk);
+}
+EXPORT_SYMBOL_GPL(call_rcu);
+
+/*
+ * Post an RCU bottom-half callback to be invoked after any subsequent
+ * quiescent state.
+ */
+void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
+{
+	__call_rcu(head, func, &rcu_bh_ctrlblk);
+}
+EXPORT_SYMBOL_GPL(call_rcu_bh);
+
+void rcu_barrier(void)
+{
+	struct rcu_synchronize rcu;
+
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	call_rcu(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+}
+EXPORT_SYMBOL_GPL(rcu_barrier);
+
+void rcu_barrier_bh(void)
+{
+	struct rcu_synchronize rcu;
+
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	call_rcu_bh(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+}
+EXPORT_SYMBOL_GPL(rcu_barrier_bh);
+
+void rcu_barrier_sched(void)
+{
+	struct rcu_synchronize rcu;
+
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	call_rcu_sched(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+}
+EXPORT_SYMBOL_GPL(rcu_barrier_sched);
+
+void __init rcu_init(void)
+{
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+}
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 697c0a0..a621a67 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -327,6 +327,11 @@ rcu_torture_cb(struct rcu_head *p)
 		cur_ops->deferred_free(rp);
 }
 
+static int rcu_no_completed(void)
+{
+	return 0;
+}
+
 static void rcu_torture_deferred_free(struct rcu_torture *p)
 {
 	call_rcu(&p->rtort_rcu, rcu_torture_cb);
@@ -388,6 +393,21 @@ static struct rcu_torture_ops rcu_sync_ops = {
 	.name		= "rcu_sync"
 };
 
+static struct rcu_torture_ops rcu_expedited_ops = {
+	.init		= rcu_sync_torture_init,
+	.cleanup	= NULL,
+	.readlock	= rcu_torture_read_lock,
+	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
+	.readunlock	= rcu_torture_read_unlock,
+	.completed	= rcu_no_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= synchronize_rcu_expedited,
+	.cb_barrier	= NULL,
+	.stats		= NULL,
+	.irq_capable	= 1,
+	.name		= "rcu_expedited"
+};
+
 /*
  * Definitions for rcu_bh torture testing.
  */
@@ -547,6 +567,25 @@ static struct rcu_torture_ops srcu_ops = {
 	.name		= "srcu"
 };
 
+static void srcu_torture_synchronize_expedited(void)
+{
+	synchronize_srcu_expedited(&srcu_ctl);
+}
+
+static struct rcu_torture_ops srcu_expedited_ops = {
+	.init		= srcu_torture_init,
+	.cleanup	= srcu_torture_cleanup,
+	.readlock	= srcu_torture_read_lock,
+	.read_delay	= srcu_read_delay,
+	.readunlock	= srcu_torture_read_unlock,
+	.completed	= srcu_torture_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= srcu_torture_synchronize_expedited,
+	.cb_barrier	= NULL,
+	.stats		= srcu_torture_stats,
+	.name		= "srcu_expedited"
+};
+
 /*
  * Definitions for sched torture testing.
  */
@@ -562,11 +601,6 @@ static void sched_torture_read_unlock(int idx)
 	preempt_enable();
 }
 
-static int sched_torture_completed(void)
-{
-	return 0;
-}
-
 static void rcu_sched_torture_deferred_free(struct rcu_torture *p)
 {
 	call_rcu_sched(&p->rtort_rcu, rcu_torture_cb);
@@ -583,7 +617,7 @@ static struct rcu_torture_ops sched_ops = {
 	.readlock	= sched_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= sched_torture_read_unlock,
-	.completed	= sched_torture_completed,
+	.completed	= rcu_no_completed,
 	.deferred_free	= rcu_sched_torture_deferred_free,
 	.sync		= sched_torture_synchronize,
 	.cb_barrier	= rcu_barrier_sched,
@@ -592,13 +626,13 @@ static struct rcu_torture_ops sched_ops = {
 	.name		= "sched"
 };
 
-static struct rcu_torture_ops sched_ops_sync = {
+static struct rcu_torture_ops sched_sync_ops = {
 	.init		= rcu_sync_torture_init,
 	.cleanup	= NULL,
 	.readlock	= sched_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= sched_torture_read_unlock,
-	.completed	= sched_torture_completed,
+	.completed	= rcu_no_completed,
 	.deferred_free	= rcu_sync_torture_deferred_free,
 	.sync		= sched_torture_synchronize,
 	.cb_barrier	= NULL,
@@ -612,7 +646,7 @@ static struct rcu_torture_ops sched_expedited_ops = {
 	.readlock	= sched_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= sched_torture_read_unlock,
-	.completed	= sched_torture_completed,
+	.completed	= rcu_no_completed,
 	.deferred_free	= rcu_sync_torture_deferred_free,
 	.sync		= synchronize_sched_expedited,
 	.cb_barrier	= NULL,
@@ -1097,9 +1131,10 @@ rcu_torture_init(void)
 	int cpu;
 	int firsterr = 0;
 	static struct rcu_torture_ops *torture_ops[] =
-		{ &rcu_ops, &rcu_sync_ops, &rcu_bh_ops, &rcu_bh_sync_ops,
-		  &sched_expedited_ops,
-		  &srcu_ops, &sched_ops, &sched_ops_sync, };
+		{ &rcu_ops, &rcu_sync_ops, &rcu_expedited_ops,
+		  &rcu_bh_ops, &rcu_bh_sync_ops,
+		  &srcu_ops, &srcu_expedited_ops,
+		  &sched_ops, &sched_sync_ops, &sched_expedited_ops, };
 
 	mutex_lock(&fullstop_mutex);
 
@@ -1110,8 +1145,12 @@ rcu_torture_init(void)
 			break;
 	}
 	if (i == ARRAY_SIZE(torture_ops)) {
-		printk(KERN_ALERT "rcutorture: invalid torture type: \"%s\"\n",
+		printk(KERN_ALERT "rcu-torture: invalid torture type: \"%s\"\n",
 		       torture_type);
+		printk(KERN_ALERT "rcu-torture types:");
+		for (i = 0; i < ARRAY_SIZE(torture_ops); i++)
+			printk(KERN_ALERT " %s", torture_ops[i]->name);
+		printk(KERN_ALERT "\n");
 		mutex_unlock(&fullstop_mutex);
 		return -EINVAL;
 	}
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index f3077c0..53ae959 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -46,18 +46,22 @@
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 #include <linux/time.h>
+#include <linux/kernel_stat.h>
 
 #include "rcutree.h"
 
 /* Data structures. */
 
+static struct lock_class_key rcu_node_class[NUM_RCU_LVLS];
+
 #define RCU_STATE_INITIALIZER(name) { \
 	.level = { &name.node[0] }, \
 	.levelcnt = { \
 		NUM_RCU_LVL_0,  /* root of hierarchy. */ \
 		NUM_RCU_LVL_1, \
 		NUM_RCU_LVL_2, \
-		NUM_RCU_LVL_3, /* == MAX_RCU_LVLS */ \
+		NUM_RCU_LVL_3, \
+		NUM_RCU_LVL_4, /* == MAX_RCU_LVLS */ \
 	}, \
 	.signaled = RCU_GP_IDLE, \
 	.gpnum = -300, \
@@ -77,6 +81,8 @@ DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
 struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
+static int rcu_scheduler_active __read_mostly;
+
 
 /*
  * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
@@ -98,7 +104,7 @@ void rcu_sched_qs(int cpu)
 	struct rcu_data *rdp;
 
 	rdp = &per_cpu(rcu_sched_data, cpu);
-	rdp->passed_quiesc_completed = rdp->completed;
+	rdp->passed_quiesc_completed = rdp->gpnum - 1;
 	barrier();
 	rdp->passed_quiesc = 1;
 	rcu_preempt_note_context_switch(cpu);
@@ -109,7 +115,7 @@ void rcu_bh_qs(int cpu)
 	struct rcu_data *rdp;
 
 	rdp = &per_cpu(rcu_bh_data, cpu);
-	rdp->passed_quiesc_completed = rdp->completed;
+	rdp->passed_quiesc_completed = rdp->gpnum - 1;
 	barrier();
 	rdp->passed_quiesc = 1;
 }
@@ -335,28 +341,9 @@ void rcu_irq_exit(void)
 		set_need_resched();
 }
 
-/*
- * Record the specified "completed" value, which is later used to validate
- * dynticks counter manipulations.  Specify "rsp->completed - 1" to
- * unconditionally invalidate any future dynticks manipulations (which is
- * useful at the beginning of a grace period).
- */
-static void dyntick_record_completed(struct rcu_state *rsp, long comp)
-{
-	rsp->dynticks_completed = comp;
-}
-
 #ifdef CONFIG_SMP
 
 /*
- * Recall the previously recorded value of the completion for dynticks.
- */
-static long dyntick_recall_completed(struct rcu_state *rsp)
-{
-	return rsp->dynticks_completed;
-}
-
-/*
  * Snapshot the specified CPU's dynticks counter so that we can later
  * credit them with an implicit quiescent state.  Return 1 if this CPU
  * is in dynticks idle mode, which is an extended quiescent state.
@@ -419,24 +406,8 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 
 #else /* #ifdef CONFIG_NO_HZ */
 
-static void dyntick_record_completed(struct rcu_state *rsp, long comp)
-{
-}
-
 #ifdef CONFIG_SMP
 
-/*
- * If there are no dynticks, then the only way that a CPU can passively
- * be in a quiescent state is to be offline.  Unlike dynticks idle, which
- * is a point in time during the prior (already finished) grace period,
- * an offline CPU is always in a quiescent state, and thus can be
- * unconditionally applied.  So just return the current value of completed.
- */
-static long dyntick_recall_completed(struct rcu_state *rsp)
-{
-	return rsp->completed;
-}
-
 static int dyntick_save_progress_counter(struct rcu_data *rdp)
 {
 	return 0;
@@ -553,13 +524,33 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 /*
  * Update CPU-local rcu_data state to record the newly noticed grace period.
  * This is used both when we started the grace period and when we notice
- * that someone else started the grace period.
+ * that someone else started the grace period.  The caller must hold the
+ * ->lock of the leaf rcu_node structure corresponding to the current CPU,
+ *  and must have irqs disabled.
  */
+static void __note_new_gpnum(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
+{
+	if (rdp->gpnum != rnp->gpnum) {
+		rdp->qs_pending = 1;
+		rdp->passed_quiesc = 0;
+		rdp->gpnum = rnp->gpnum;
+	}
+}
+
 static void note_new_gpnum(struct rcu_state *rsp, struct rcu_data *rdp)
 {
-	rdp->qs_pending = 1;
-	rdp->passed_quiesc = 0;
-	rdp->gpnum = rsp->gpnum;
+	unsigned long flags;
+	struct rcu_node *rnp;
+
+	local_irq_save(flags);
+	rnp = rdp->mynode;
+	if (rdp->gpnum == ACCESS_ONCE(rnp->gpnum) || /* outside lock. */
+	    !spin_trylock(&rnp->lock)) { /* irqs already off, retry later. */
+		local_irq_restore(flags);
+		return;
+	}
+	__note_new_gpnum(rsp, rnp, rdp);
+	spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
@@ -583,6 +574,79 @@ check_for_new_grace_period(struct rcu_state *rsp, struct rcu_data *rdp)
 }
 
 /*
+ * Advance this CPU's callbacks, but only if the current grace period
+ * has ended.  This may be called only from the CPU to whom the rdp
+ * belongs.  In addition, the corresponding leaf rcu_node structure's
+ * ->lock must be held by the caller, with irqs disabled.
+ */
+static void
+__rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
+{
+	/* Did another grace period end? */
+	if (rdp->completed != rnp->completed) {
+
+		/* Advance callbacks.  No harm if list empty. */
+		rdp->nxttail[RCU_DONE_TAIL] = rdp->nxttail[RCU_WAIT_TAIL];
+		rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_READY_TAIL];
+		rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+
+		/* Remember that we saw this grace-period completion. */
+		rdp->completed = rnp->completed;
+	}
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
+	unsigned long flags;
+	struct rcu_node *rnp;
+
+	local_irq_save(flags);
+	rnp = rdp->mynode;
+	if (rdp->completed == ACCESS_ONCE(rnp->completed) || /* outside lock. */
+	    !spin_trylock(&rnp->lock)) { /* irqs already off, retry later. */
+		local_irq_restore(flags);
+		return;
+	}
+	__rcu_process_gp_end(rsp, rnp, rdp);
+	spin_unlock_irqrestore(&rnp->lock, flags);
+}
+
+/*
+ * Do per-CPU grace-period initialization for running CPU.  The caller
+ * must hold the lock of the leaf rcu_node structure corresponding to
+ * this CPU.
+ */
+static void
+rcu_start_gp_per_cpu(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
+{
+	/* Prior grace period ended, so advance callbacks for current CPU. */
+	__rcu_process_gp_end(rsp, rnp, rdp);
+
+	/*
+	 * Because this CPU just now started the new grace period, we know
+	 * that all of its callbacks will be covered by this upcoming grace
+	 * period, even the ones that were registered arbitrarily recently.
+	 * Therefore, advance all outstanding callbacks to RCU_WAIT_TAIL.
+	 *
+	 * Other CPUs cannot be sure exactly when the grace period started.
+	 * Therefore, their recently registered callbacks must pass through
+	 * an additional RCU_NEXT_READY stage, so that they will be handled
+	 * by the next RCU grace period.
+	 */
+	rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+	rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+
+	/* Set state so that this CPU will detect the next quiescent state. */
+	__note_new_gpnum(rsp, rnp, rdp);
+}
+
+/*
  * Start a new RCU grace period if warranted, re-initializing the hierarchy
  * in preparation for detecting the next grace period.  The caller must hold
  * the root node's ->lock, which is released before return.  Hard irqs must
@@ -596,7 +660,23 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	if (!cpu_needs_another_gp(rsp, rdp)) {
-		spin_unlock_irqrestore(&rnp->lock, flags);
+		if (rnp->completed == rsp->completed) {
+			spin_unlock_irqrestore(&rnp->lock, flags);
+			return;
+		}
+		spin_unlock(&rnp->lock);	 /* irqs remain disabled. */
+
+		/*
+		 * Propagate new ->completed value to rcu_node structures
+		 * so that other CPUs don't have to wait until the start
+		 * of the next grace period to process their callbacks.
+		 */
+		rcu_for_each_node_breadth_first(rsp, rnp) {
+			spin_lock(&rnp->lock);	 /* irqs already disabled. */
+			rnp->completed = rsp->completed;
+			spin_unlock(&rnp->lock); /* irqs remain disabled. */
+		}
+		local_irq_restore(flags);
 		return;
 	}
 
@@ -606,29 +686,15 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	rsp->signaled = RCU_GP_INIT; /* Hold off force_quiescent_state. */
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 	record_gp_stall_check_time(rsp);
-	dyntick_record_completed(rsp, rsp->completed - 1);
-	note_new_gpnum(rsp, rdp);
-
-	/*
-	 * Because this CPU just now started the new grace period, we know
-	 * that all of its callbacks will be covered by this upcoming grace
-	 * period, even the ones that were registered arbitrarily recently.
-	 * Therefore, advance all outstanding callbacks to RCU_WAIT_TAIL.
-	 *
-	 * Other CPUs cannot be sure exactly when the grace period started.
-	 * Therefore, their recently registered callbacks must pass through
-	 * an additional RCU_NEXT_READY stage, so that they will be handled
-	 * by the next RCU grace period.
-	 */
-	rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
-	rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
 
 	/* Special-case the common single-level case. */
 	if (NUM_RCU_NODES == 1) {
 		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->qsmask = rnp->qsmaskinit;
 		rnp->gpnum = rsp->gpnum;
+		rnp->completed = rsp->completed;
 		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
+		rcu_start_gp_per_cpu(rsp, rnp, rdp);
 		spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
@@ -661,6 +727,9 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->qsmask = rnp->qsmaskinit;
 		rnp->gpnum = rsp->gpnum;
+		rnp->completed = rsp->completed;
+		if (rnp == rdp->mynode)
+			rcu_start_gp_per_cpu(rsp, rnp, rdp);
 		spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 	}
 
@@ -672,58 +741,32 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 }
 
 /*
- * Advance this CPU's callbacks, but only if the current grace period
- * has ended.  This may be called only from the CPU to whom the rdp
- * belongs.
+ * Report a full set of quiescent states to the specified rcu_state
+ * data structure.  This involves cleaning up after the prior grace
+ * period and letting rcu_start_gp() start up the next grace period
+ * if one is needed.  Note that the caller must hold rnp->lock, as
+ * required by rcu_start_gp(), which will release it.
  */
-static void
-rcu_process_gp_end(struct rcu_state *rsp, struct rcu_data *rdp)
-{
-	long completed_snap;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	completed_snap = ACCESS_ONCE(rsp->completed);  /* outside of lock. */
-
-	/* Did another grace period end? */
-	if (rdp->completed != completed_snap) {
-
-		/* Advance callbacks.  No harm if list empty. */
-		rdp->nxttail[RCU_DONE_TAIL] = rdp->nxttail[RCU_WAIT_TAIL];
-		rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_READY_TAIL];
-		rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
-
-		/* Remember that we saw this grace-period completion. */
-		rdp->completed = completed_snap;
-	}
-	local_irq_restore(flags);
-}
-
-/*
- * Clean up after the prior grace period and let rcu_start_gp() start up
- * the next grace period if one is needed.  Note that the caller must
- * hold rnp->lock, as required by rcu_start_gp(), which will release it.
- */
-static void cpu_quiet_msk_finish(struct rcu_state *rsp, unsigned long flags)
+static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 	__releases(rcu_get_root(rsp)->lock)
 {
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
 	rsp->completed = rsp->gpnum;
 	rsp->signaled = RCU_GP_IDLE;
-	rcu_process_gp_end(rsp, rsp->rda[smp_processor_id()]);
 	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
 }
 
 /*
- * Similar to cpu_quiet(), for which it is a helper function.  Allows
- * a group of CPUs to be quieted at one go, though all the CPUs in the
- * group must be represented by the same leaf rcu_node structure.
- * That structure's lock must be held upon entry, and it is released
- * before return.
+ * Similar to rcu_report_qs_rdp(), for which it is a helper function.
+ * Allows quiescent states for a group of CPUs to be reported at one go
+ * to the specified rcu_node structure, though all the CPUs in the group
+ * must be represented by the same rcu_node structure (which need not be
+ * a leaf rcu_node structure, though it often will be).  That structure's
+ * lock must be held upon entry, and it is released before return.
  */
 static void
-cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp, struct rcu_node *rnp,
-	      unsigned long flags)
+rcu_report_qs_rnp(unsigned long mask, struct rcu_state *rsp,
+		  struct rcu_node *rnp, unsigned long flags)
 	__releases(rnp->lock)
 {
 	struct rcu_node *rnp_c;
@@ -759,21 +802,23 @@ cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp, struct rcu_node *rnp,
 
 	/*
 	 * Get here if we are the last CPU to pass through a quiescent
-	 * state for this grace period.  Invoke cpu_quiet_msk_finish()
+	 * state for this grace period.  Invoke rcu_report_qs_rsp()
 	 * to clean up and start the next grace period if one is needed.
 	 */
-	cpu_quiet_msk_finish(rsp, flags); /* releases rnp->lock. */
+	rcu_report_qs_rsp(rsp, flags); /* releases rnp->lock. */
 }
 
 /*
- * Record a quiescent state for the specified CPU, which must either be
- * the current CPU.  The lastcomp argument is used to make sure we are
- * still in the grace period of interest.  We don't want to end the current
- * grace period based on quiescent states detected in an earlier grace
- * period!
+ * Record a quiescent state for the specified CPU to that CPU's rcu_data
+ * structure.  This must be either called from the specified CPU, or
+ * called when the specified CPU is known to be offline (and when it is
+ * also known that no other CPU is concurrently trying to help the offline
+ * CPU).  The lastcomp argument is used to make sure we are still in the
+ * grace period of interest.  We don't want to end the current grace period
+ * based on quiescent states detected in an earlier grace period!
  */
 static void
-cpu_quiet(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long lastcomp)
+rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long lastcomp)
 {
 	unsigned long flags;
 	unsigned long mask;
@@ -781,15 +826,15 @@ cpu_quiet(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long lastcomp)
 
 	rnp = rdp->mynode;
 	spin_lock_irqsave(&rnp->lock, flags);
-	if (lastcomp != ACCESS_ONCE(rsp->completed)) {
+	if (lastcomp != rnp->completed) {
 
 		/*
 		 * Someone beat us to it for this grace period, so leave.
 		 * The race with GP start is resolved by the fact that we
 		 * hold the leaf rcu_node lock, so that the per-CPU bits
 		 * cannot yet be initialized -- so we would simply find our
-		 * CPU's bit already cleared in cpu_quiet_msk() if this race
-		 * occurred.
+		 * CPU's bit already cleared in rcu_report_qs_rnp() if this
+		 * race occurred.
 		 */
 		rdp->passed_quiesc = 0;	/* try again later! */
 		spin_unlock_irqrestore(&rnp->lock, flags);
@@ -807,7 +852,7 @@ cpu_quiet(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long lastcomp)
 		 */
 		rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
 
-		cpu_quiet_msk(mask, rsp, rnp, flags); /* releases rnp->lock */
+		rcu_report_qs_rnp(mask, rsp, rnp, flags); /* rlses rnp->lock */
 	}
 }
 
@@ -838,8 +883,11 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
 	if (!rdp->passed_quiesc)
 		return;
 
-	/* Tell RCU we are done (but cpu_quiet() will be the judge of that). */
-	cpu_quiet(rdp->cpu, rsp, rdp, rdp->passed_quiesc_completed);
+	/*
+	 * Tell RCU we are done (but rcu_report_qs_rdp() will be the
+	 * judge of that).
+	 */
+	rcu_report_qs_rdp(rdp->cpu, rsp, rdp, rdp->passed_quiesc_completed);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -899,8 +947,8 @@ static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
 static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 {
 	unsigned long flags;
-	long lastcomp;
 	unsigned long mask;
+	int need_report = 0;
 	struct rcu_data *rdp = rsp->rda[cpu];
 	struct rcu_node *rnp;
 
@@ -914,30 +962,32 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 		spin_lock(&rnp->lock);		/* irqs already disabled. */
 		rnp->qsmaskinit &= ~mask;
 		if (rnp->qsmaskinit != 0) {
-			spin_unlock(&rnp->lock); /* irqs remain disabled. */
+			if (rnp != rdp->mynode)
+				spin_unlock(&rnp->lock); /* irqs remain disabled. */
 			break;
 		}
-
-		/*
-		 * If there was a task blocking the current grace period,
-		 * and if all CPUs have checked in, we need to propagate
-		 * the quiescent state up the rcu_node hierarchy.  But that
-		 * is inconvenient at the moment due to deadlock issues if
-		 * this should end the current grace period.  So set the
-		 * offlined CPU's bit in ->qsmask in order to force the
-		 * next force_quiescent_state() invocation to clean up this
-		 * mess in a deadlock-free manner.
-		 */
-		if (rcu_preempt_offline_tasks(rsp, rnp, rdp) && !rnp->qsmask)
-			rnp->qsmask |= mask;
-
+		if (rnp == rdp->mynode)
+			need_report = rcu_preempt_offline_tasks(rsp, rnp, rdp);
+		else
+			spin_unlock(&rnp->lock); /* irqs remain disabled. */
 		mask = rnp->grpmask;
-		spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 		rnp = rnp->parent;
 	} while (rnp != NULL);
-	lastcomp = rsp->completed;
 
-	spin_unlock_irqrestore(&rsp->onofflock, flags);
+	/*
+	 * We still hold the leaf rcu_node structure lock here, and
+	 * irqs are still disabled.  The reason for this subterfuge is
+	 * because invoking rcu_report_unblock_qs_rnp() with ->onofflock
+	 * held leads to deadlock.
+	 */
+	spin_unlock(&rsp->onofflock); /* irqs remain disabled. */
+	rnp = rdp->mynode;
+	if (need_report & RCU_OFL_TASKS_NORM_GP)
+		rcu_report_unblock_qs_rnp(rnp, flags);
+	else
+		spin_unlock_irqrestore(&rnp->lock, flags);
+	if (need_report & RCU_OFL_TASKS_EXP_GP)
+		rcu_report_exp_rnp(rsp, rnp);
 
 	rcu_adopt_orphan_cbs(rsp);
 }
@@ -1109,7 +1159,7 @@ static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
 	rcu_for_each_leaf_node(rsp, rnp) {
 		mask = 0;
 		spin_lock_irqsave(&rnp->lock, flags);
-		if (rsp->completed != lastcomp) {
+		if (rnp->completed != lastcomp) {
 			spin_unlock_irqrestore(&rnp->lock, flags);
 			return 1;
 		}
@@ -1123,10 +1173,10 @@ static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
 			if ((rnp->qsmask & bit) != 0 && f(rsp->rda[cpu]))
 				mask |= bit;
 		}
-		if (mask != 0 && rsp->completed == lastcomp) {
+		if (mask != 0 && rnp->completed == lastcomp) {
 
-			/* cpu_quiet_msk() releases rnp->lock. */
-			cpu_quiet_msk(mask, rsp, rnp, flags);
+			/* rcu_report_qs_rnp() releases rnp->lock. */
+			rcu_report_qs_rnp(mask, rsp, rnp, flags);
 			continue;
 		}
 		spin_unlock_irqrestore(&rnp->lock, flags);
@@ -1144,6 +1194,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	long lastcomp;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 	u8 signaled;
+	u8 forcenow;
 
 	if (!rcu_gp_in_progress(rsp))
 		return;  /* No grace period in progress, nothing to force. */
@@ -1156,10 +1207,10 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		goto unlock_ret; /* no emergency and done recently. */
 	rsp->n_force_qs++;
 	spin_lock(&rnp->lock);
-	lastcomp = rsp->completed;
+	lastcomp = rsp->gpnum - 1;
 	signaled = rsp->signaled;
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
-	if (lastcomp == rsp->gpnum) {
+	if(!rcu_gp_in_progress(rsp)) {
 		rsp->n_force_qs_ngp++;
 		spin_unlock(&rnp->lock);
 		goto unlock_ret;  /* no GP in progress, time updated. */
@@ -1180,21 +1231,29 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		if (rcu_process_dyntick(rsp, lastcomp,
 					dyntick_save_progress_counter))
 			goto unlock_ret;
+		/* fall into next case. */
+
+	case RCU_SAVE_COMPLETED:
 
 		/* Update state, record completion counter. */
+		forcenow = 0;
 		spin_lock(&rnp->lock);
-		if (lastcomp == rsp->completed &&
-		    rsp->signaled == RCU_SAVE_DYNTICK) {
+		if (lastcomp + 1 == rsp->gpnum &&
+		    lastcomp == rsp->completed &&
+		    rsp->signaled == signaled) {
 			rsp->signaled = RCU_FORCE_QS;
-			dyntick_record_completed(rsp, lastcomp);
+			rsp->completed_fqs = lastcomp;
+			forcenow = signaled == RCU_SAVE_COMPLETED;
 		}
 		spin_unlock(&rnp->lock);
-		break;
+		if (!forcenow)
+			break;
+		/* fall into next case. */
 
 	case RCU_FORCE_QS:
 
 		/* Check dyntick-idle state, send IPI to laggarts. */
-		if (rcu_process_dyntick(rsp, dyntick_recall_completed(rsp),
+		if (rcu_process_dyntick(rsp, rsp->completed_fqs,
 					rcu_implicit_dynticks_qs))
 			goto unlock_ret;
 
@@ -1351,6 +1410,68 @@ void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
 
+/**
+ * synchronize_sched - wait until an rcu-sched grace period has elapsed.
+ *
+ * Control will return to the caller some time after a full rcu-sched
+ * grace period has elapsed, in other words after all currently executing
+ * rcu-sched read-side critical sections have completed.   These read-side
+ * critical sections are delimited by rcu_read_lock_sched() and
+ * rcu_read_unlock_sched(), and may be nested.  Note that preempt_disable(),
+ * local_irq_disable(), and so on may be used in place of
+ * rcu_read_lock_sched().
+ *
+ * This means that all preempt_disable code sequences, including NMI and
+ * hardware-interrupt handlers, in progress on entry will have completed
+ * before this primitive returns.  However, this does not guarantee that
+ * softirq handlers will have completed, since in some kernels, these
+ * handlers can run in process context, and can block.
+ *
+ * This primitive provides the guarantees made by the (now removed)
+ * synchronize_kernel() API.  In contrast, synchronize_rcu() only
+ * guarantees that rcu_read_lock() sections will have completed.
+ * In "classic RCU", these two guarantees happen to be one and
+ * the same, but can differ in realtime RCU implementations.
+ */
+void synchronize_sched(void)
+{
+	struct rcu_synchronize rcu;
+
+	if (rcu_blocking_is_gp())
+		return;
+
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	call_rcu_sched(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+}
+EXPORT_SYMBOL_GPL(synchronize_sched);
+
+/**
+ * synchronize_rcu_bh - wait until an rcu_bh grace period has elapsed.
+ *
+ * Control will return to the caller some time after a full rcu_bh grace
+ * period has elapsed, in other words after all currently executing rcu_bh
+ * read-side critical sections have completed.  RCU read-side critical
+ * sections are delimited by rcu_read_lock_bh() and rcu_read_unlock_bh(),
+ * and may be nested.
+ */
+void synchronize_rcu_bh(void)
+{
+	struct rcu_synchronize rcu;
+
+	if (rcu_blocking_is_gp())
+		return;
+
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	call_rcu_bh(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+}
+EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
+
 /*
  * Check to see if there is any immediate RCU-related work to be done
  * by the current CPU, for the specified type of RCU, returning 1 if so.
@@ -1360,6 +1481,8 @@ EXPORT_SYMBOL_GPL(call_rcu_bh);
  */
 static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 {
+	struct rcu_node *rnp = rdp->mynode;
+
 	rdp->n_rcu_pending++;
 
 	/* Check for CPU stalls, if enabled. */
@@ -1384,13 +1507,13 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 	}
 
 	/* Has another RCU grace period completed?  */
-	if (ACCESS_ONCE(rsp->completed) != rdp->completed) { /* outside lock */
+	if (ACCESS_ONCE(rnp->completed) != rdp->completed) { /* outside lock */
 		rdp->n_rp_gp_completed++;
 		return 1;
 	}
 
 	/* Has a new RCU grace period started? */
-	if (ACCESS_ONCE(rsp->gpnum) != rdp->gpnum) { /* outside lock */
+	if (ACCESS_ONCE(rnp->gpnum) != rdp->gpnum) { /* outside lock */
 		rdp->n_rp_gp_started++;
 		return 1;
 	}
@@ -1433,6 +1556,21 @@ int rcu_needs_cpu(int cpu)
 	       rcu_preempt_needs_cpu(cpu);
 }
 
+/*
+ * This function is invoked towards the end of the scheduler's initialization
+ * process.  Before this is called, the idle task might contain
+ * RCU read-side critical sections (during which time, this idle
+ * task is booting the system).  After this function is called, the
+ * idle tasks are prohibited from containing RCU read-side critical
+ * sections.
+ */
+void rcu_scheduler_starting(void)
+{
+	WARN_ON(num_online_cpus() != 1);
+	WARN_ON(nr_context_switches() > 0);
+	rcu_scheduler_active = 1;
+}
+
 static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
 static atomic_t rcu_barrier_cpu_count;
 static DEFINE_MUTEX(rcu_barrier_mutex);
@@ -1544,21 +1682,16 @@ static void __cpuinit
 rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptable)
 {
 	unsigned long flags;
-	long lastcomp;
 	unsigned long mask;
 	struct rcu_data *rdp = rsp->rda[cpu];
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	/* Set up local state, ensuring consistent view of global state. */
 	spin_lock_irqsave(&rnp->lock, flags);
-	lastcomp = rsp->completed;
-	rdp->completed = lastcomp;
-	rdp->gpnum = lastcomp;
 	rdp->passed_quiesc = 0;  /* We could be racing with new GP, */
 	rdp->qs_pending = 1;	 /*  so set up to respond to current GP. */
 	rdp->beenonline = 1;	 /* We have now been online. */
 	rdp->preemptable = preemptable;
-	rdp->passed_quiesc_completed = lastcomp - 1;
 	rdp->qlen_last_fqs_check = 0;
 	rdp->n_force_qs_snap = rsp->n_force_qs;
 	rdp->blimit = blimit;
@@ -1580,6 +1713,11 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptable)
 		spin_lock(&rnp->lock);	/* irqs already disabled. */
 		rnp->qsmaskinit |= mask;
 		mask = rnp->grpmask;
+		if (rnp == rdp->mynode) {
+			rdp->gpnum = rnp->completed; /* if GP in progress... */
+			rdp->completed = rnp->completed;
+			rdp->passed_quiesc_completed = rnp->completed - 1;
+		}
 		spin_unlock(&rnp->lock); /* irqs already disabled. */
 		rnp = rnp->parent;
 	} while (rnp != NULL && !(rnp->qsmaskinit & mask));
@@ -1597,8 +1735,8 @@ static void __cpuinit rcu_online_cpu(int cpu)
 /*
  * Handle CPU online/offline notification events.
  */
-int __cpuinit rcu_cpu_notify(struct notifier_block *self,
-			     unsigned long action, void *hcpu)
+static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
+				    unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
 
@@ -1685,8 +1823,8 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 		cpustride *= rsp->levelspread[i];
 		rnp = rsp->level[i];
 		for (j = 0; j < rsp->levelcnt[i]; j++, rnp++) {
-			if (rnp != rcu_get_root(rsp))
-				spin_lock_init(&rnp->lock);
+			spin_lock_init(&rnp->lock);
+			lockdep_set_class(&rnp->lock, &rcu_node_class[i]);
 			rnp->gpnum = 0;
 			rnp->qsmask = 0;
 			rnp->qsmaskinit = 0;
@@ -1707,9 +1845,10 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 			rnp->level = i;
 			INIT_LIST_HEAD(&rnp->blocked_tasks[0]);
 			INIT_LIST_HEAD(&rnp->blocked_tasks[1]);
+			INIT_LIST_HEAD(&rnp->blocked_tasks[2]);
+			INIT_LIST_HEAD(&rnp->blocked_tasks[3]);
 		}
 	}
-	spin_lock_init(&rcu_get_root(rsp)->lock);
 }
 
 /*
@@ -1735,16 +1874,30 @@ do { \
 	} \
 } while (0)
 
-void __init __rcu_init(void)
+void __init rcu_init(void)
 {
+	int i;
+
 	rcu_bootup_announce();
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 	printk(KERN_INFO "RCU-based detection of stalled CPUs is enabled.\n");
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+#if NUM_RCU_LVL_4 != 0
+	printk(KERN_INFO "Experimental four-level hierarchy is enabled.\n");
+#endif /* #if NUM_RCU_LVL_4 != 0 */
 	RCU_INIT_FLAVOR(&rcu_sched_state, rcu_sched_data);
 	RCU_INIT_FLAVOR(&rcu_bh_state, rcu_bh_data);
 	__rcu_init_preempt();
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+
+	/*
+	 * We don't need protection against CPU-hotplug here because
+	 * this is called early in boot, before either interrupts
+	 * or the scheduler are operational.
+	 */
+	cpu_notifier(rcu_cpu_notify, 0);
+	for_each_online_cpu(i)
+		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)i);
 }
 
 #include "rcutree_plugin.h"
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 1899023..d2a0046 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -34,10 +34,11 @@
  * In practice, this has not been tested, so there is probably some
  * bug somewhere.
  */
-#define MAX_RCU_LVLS 3
+#define MAX_RCU_LVLS 4
 #define RCU_FANOUT	      (CONFIG_RCU_FANOUT)
 #define RCU_FANOUT_SQ	      (RCU_FANOUT * RCU_FANOUT)
 #define RCU_FANOUT_CUBE	      (RCU_FANOUT_SQ * RCU_FANOUT)
+#define RCU_FANOUT_FOURTH     (RCU_FANOUT_CUBE * RCU_FANOUT)
 
 #if NR_CPUS <= RCU_FANOUT
 #  define NUM_RCU_LVLS	      1
@@ -45,23 +46,33 @@
 #  define NUM_RCU_LVL_1	      (NR_CPUS)
 #  define NUM_RCU_LVL_2	      0
 #  define NUM_RCU_LVL_3	      0
+#  define NUM_RCU_LVL_4	      0
 #elif NR_CPUS <= RCU_FANOUT_SQ
 #  define NUM_RCU_LVLS	      2
 #  define NUM_RCU_LVL_0	      1
 #  define NUM_RCU_LVL_1	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT)
 #  define NUM_RCU_LVL_2	      (NR_CPUS)
 #  define NUM_RCU_LVL_3	      0
+#  define NUM_RCU_LVL_4	      0
 #elif NR_CPUS <= RCU_FANOUT_CUBE
 #  define NUM_RCU_LVLS	      3
 #  define NUM_RCU_LVL_0	      1
 #  define NUM_RCU_LVL_1	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_SQ)
 #  define NUM_RCU_LVL_2	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT)
 #  define NUM_RCU_LVL_3	      NR_CPUS
+#  define NUM_RCU_LVL_4	      0
+#elif NR_CPUS <= RCU_FANOUT_FOURTH
+#  define NUM_RCU_LVLS	      4
+#  define NUM_RCU_LVL_0	      1
+#  define NUM_RCU_LVL_1	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_CUBE)
+#  define NUM_RCU_LVL_2	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_SQ)
+#  define NUM_RCU_LVL_3	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT)
+#  define NUM_RCU_LVL_4	      NR_CPUS
 #else
 # error "CONFIG_RCU_FANOUT insufficient for NR_CPUS"
 #endif /* #if (NR_CPUS) <= RCU_FANOUT */
 
-#define RCU_SUM (NUM_RCU_LVL_0 + NUM_RCU_LVL_1 + NUM_RCU_LVL_2 + NUM_RCU_LVL_3)
+#define RCU_SUM (NUM_RCU_LVL_0 + NUM_RCU_LVL_1 + NUM_RCU_LVL_2 + NUM_RCU_LVL_3 + NUM_RCU_LVL_4)
 #define NUM_RCU_NODES (RCU_SUM - NR_CPUS)
 
 /*
@@ -84,14 +95,21 @@ struct rcu_node {
 	long	gpnum;		/* Current grace period for this node. */
 				/*  This will either be equal to or one */
 				/*  behind the root rcu_node's gpnum. */
+	long	completed;	/* Last grace period completed for this node. */
+				/*  This will either be equal to or one */
+				/*  behind the root rcu_node's gpnum. */
 	unsigned long qsmask;	/* CPUs or groups that need to switch in */
 				/*  order for current grace period to proceed.*/
 				/*  In leaf rcu_node, each bit corresponds to */
 				/*  an rcu_data structure, otherwise, each */
 				/*  bit corresponds to a child rcu_node */
 				/*  structure. */
+	unsigned long expmask;	/* Groups that have ->blocked_tasks[] */
+				/*  elements that need to drain to allow the */
+				/*  current expedited grace period to */
+				/*  complete (only for TREE_PREEMPT_RCU). */
 	unsigned long qsmaskinit;
-				/* Per-GP initialization for qsmask. */
+				/* Per-GP initial value for qsmask & expmask. */
 	unsigned long grpmask;	/* Mask to apply to parent qsmask. */
 				/*  Only one bit will be set in this mask. */
 	int	grplo;		/* lowest-numbered CPU or group here. */
@@ -99,7 +117,7 @@ struct rcu_node {
 	u8	grpnum;		/* CPU/group number for next level up. */
 	u8	level;		/* root is at level 0. */
 	struct rcu_node *parent;
-	struct list_head blocked_tasks[2];
+	struct list_head blocked_tasks[4];
 				/* Tasks blocked in RCU read-side critsect. */
 				/*  Grace period number (->gpnum) x blocked */
 				/*  by tasks on the (x & 0x1) element of the */
@@ -114,6 +132,21 @@ struct rcu_node {
 	for ((rnp) = &(rsp)->node[0]; \
 	     (rnp) < &(rsp)->node[NUM_RCU_NODES]; (rnp)++)
 
+/*
+ * Do a breadth-first scan of the non-leaf rcu_node structures for the
+ * specified rcu_state structure.  Note that if there is a singleton
+ * rcu_node tree with but one rcu_node structure, this loop is a no-op.
+ */
+#define rcu_for_each_nonleaf_node_breadth_first(rsp, rnp) \
+	for ((rnp) = &(rsp)->node[0]; \
+	     (rnp) < (rsp)->level[NUM_RCU_LVLS - 1]; (rnp)++)
+
+/*
+ * Scan the leaves of the rcu_node hierarchy for the specified rcu_state
+ * structure.  Note that if there is a singleton rcu_node tree with but
+ * one rcu_node structure, this loop -will- visit the rcu_node structure.
+ * It is still a leaf node, even if it is also the root node.
+ */
 #define rcu_for_each_leaf_node(rsp, rnp) \
 	for ((rnp) = (rsp)->level[NUM_RCU_LVLS - 1]; \
 	     (rnp) < &(rsp)->node[NUM_RCU_NODES]; (rnp)++)
@@ -204,11 +237,12 @@ struct rcu_data {
 #define RCU_GP_IDLE		0	/* No grace period in progress. */
 #define RCU_GP_INIT		1	/* Grace period being initialized. */
 #define RCU_SAVE_DYNTICK	2	/* Need to scan dyntick state. */
-#define RCU_FORCE_QS		3	/* Need to force quiescent state. */
+#define RCU_SAVE_COMPLETED	3	/* Need to save rsp->completed. */
+#define RCU_FORCE_QS		4	/* Need to force quiescent state. */
 #ifdef CONFIG_NO_HZ
 #define RCU_SIGNAL_INIT		RCU_SAVE_DYNTICK
 #else /* #ifdef CONFIG_NO_HZ */
-#define RCU_SIGNAL_INIT		RCU_FORCE_QS
+#define RCU_SIGNAL_INIT		RCU_SAVE_COMPLETED
 #endif /* #else #ifdef CONFIG_NO_HZ */
 
 #define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
@@ -246,7 +280,7 @@ struct rcu_state {
 	long	gpnum;				/* Current gp number. */
 	long	completed;			/* # of last completed gp. */
 
-	/* End  of fields guarded by root rcu_node's lock. */
+	/* End of fields guarded by root rcu_node's lock. */
 
 	spinlock_t onofflock;			/* exclude on/offline and */
 						/*  starting new GP.  Also */
@@ -260,6 +294,8 @@ struct rcu_state {
 	long orphan_qlen;			/* Number of orphaned cbs. */
 	spinlock_t fqslock;			/* Only one task forcing */
 						/*  quiescent states. */
+	long	completed_fqs;			/* Value of completed @ snap. */
+						/*  Protected by fqslock. */
 	unsigned long jiffies_force_qs;		/* Time at which to invoke */
 						/*  force_quiescent_state(). */
 	unsigned long n_force_qs;		/* Number of calls to */
@@ -274,11 +310,15 @@ struct rcu_state {
 	unsigned long jiffies_stall;		/* Time at which to check */
 						/*  for CPU stalls. */
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-#ifdef CONFIG_NO_HZ
-	long dynticks_completed;		/* Value of completed @ snap. */
-#endif /* #ifdef CONFIG_NO_HZ */
 };
 
+/* Return values for rcu_preempt_offline_tasks(). */
+
+#define RCU_OFL_TASKS_NORM_GP	0x1		/* Tasks blocking normal */
+						/*  GP were moved to root. */
+#define RCU_OFL_TASKS_EXP_GP	0x2		/* Tasks blocking expedited */
+						/*  GP were moved to root. */
+
 #ifdef RCU_TREE_NONCORE
 
 /*
@@ -298,10 +338,14 @@ DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);
 #else /* #ifdef RCU_TREE_NONCORE */
 
 /* Forward declarations for rcutree_plugin.h */
-static inline void rcu_bootup_announce(void);
+static void rcu_bootup_announce(void);
 long rcu_batches_completed(void);
 static void rcu_preempt_note_context_switch(int cpu);
 static int rcu_preempted_readers(struct rcu_node *rnp);
+#ifdef CONFIG_HOTPLUG_CPU
+static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
+				      unsigned long flags);
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 static void rcu_print_task_stall(struct rcu_node *rnp);
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
@@ -315,6 +359,9 @@ static void rcu_preempt_offline_cpu(int cpu);
 static void rcu_preempt_check_callbacks(int cpu);
 static void rcu_preempt_process_callbacks(void);
 void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
+#if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_TREE_PREEMPT_RCU)
+static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp);
+#endif /* #if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_TREE_PREEMPT_RCU) */
 static int rcu_preempt_pending(int cpu);
 static int rcu_preempt_needs_cpu(int cpu);
 static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index ef2a58c..37fbccd 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -24,16 +24,19 @@
  *	   Paul E. McKenney <paulmck@linux.vnet.ibm.com>
  */
 
+#include <linux/delay.h>
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
 struct rcu_state rcu_preempt_state = RCU_STATE_INITIALIZER(rcu_preempt_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
 
+static int rcu_preempted_readers_exp(struct rcu_node *rnp);
+
 /*
  * Tell them what RCU they are running.
  */
-static inline void rcu_bootup_announce(void)
+static void __init rcu_bootup_announce(void)
 {
 	printk(KERN_INFO
 	       "Experimental preemptable hierarchical RCU implementation.\n");
@@ -67,7 +70,7 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed);
 static void rcu_preempt_qs(int cpu)
 {
 	struct rcu_data *rdp = &per_cpu(rcu_preempt_data, cpu);
-	rdp->passed_quiesc_completed = rdp->completed;
+	rdp->passed_quiesc_completed = rdp->gpnum - 1;
 	barrier();
 	rdp->passed_quiesc = 1;
 }
@@ -157,14 +160,58 @@ EXPORT_SYMBOL_GPL(__rcu_read_lock);
  */
 static int rcu_preempted_readers(struct rcu_node *rnp)
 {
-	return !list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]);
+	int phase = rnp->gpnum & 0x1;
+
+	return !list_empty(&rnp->blocked_tasks[phase]) ||
+	       !list_empty(&rnp->blocked_tasks[phase + 2]);
+}
+
+/*
+ * Record a quiescent state for all tasks that were previously queued
+ * on the specified rcu_node structure and that were blocking the current
+ * RCU grace period.  The caller must hold the specified rnp->lock with
+ * irqs disabled, and this lock is released upon return, but irqs remain
+ * disabled.
+ */
+static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
+	__releases(rnp->lock)
+{
+	unsigned long mask;
+	struct rcu_node *rnp_p;
+
+	if (rnp->qsmask != 0 || rcu_preempted_readers(rnp)) {
+		spin_unlock_irqrestore(&rnp->lock, flags);
+		return;  /* Still need more quiescent states! */
+	}
+
+	rnp_p = rnp->parent;
+	if (rnp_p == NULL) {
+		/*
+		 * Either there is only one rcu_node in the tree,
+		 * or tasks were kicked up to root rcu_node due to
+		 * CPUs going offline.
+		 */
+		rcu_report_qs_rsp(&rcu_preempt_state, flags);
+		return;
+	}
+
+	/* Report up the rest of the hierarchy. */
+	mask = rnp->grpmask;
+	spin_unlock(&rnp->lock);	/* irqs remain disabled. */
+	spin_lock(&rnp_p->lock);	/* irqs already disabled. */
+	rcu_report_qs_rnp(mask, &rcu_preempt_state, rnp_p, flags);
 }
 
+/*
+ * Handle special cases during rcu_read_unlock(), such as needing to
+ * notify RCU core processing or task having blocked during the RCU
+ * read-side critical section.
+ */
 static void rcu_read_unlock_special(struct task_struct *t)
 {
 	int empty;
+	int empty_exp;
 	unsigned long flags;
-	unsigned long mask;
 	struct rcu_node *rnp;
 	int special;
 
@@ -207,36 +254,30 @@ static void rcu_read_unlock_special(struct task_struct *t)
 			spin_unlock(&rnp->lock);  /* irqs remain disabled. */
 		}
 		empty = !rcu_preempted_readers(rnp);
+		empty_exp = !rcu_preempted_readers_exp(rnp);
+		smp_mb(); /* ensure expedited fastpath sees end of RCU c-s. */
 		list_del_init(&t->rcu_node_entry);
 		t->rcu_blocked_node = NULL;
 
 		/*
 		 * If this was the last task on the current list, and if
 		 * we aren't waiting on any CPUs, report the quiescent state.
-		 * Note that both cpu_quiet_msk_finish() and cpu_quiet_msk()
-		 * drop rnp->lock and restore irq.
+		 * Note that rcu_report_unblock_qs_rnp() releases rnp->lock.
 		 */
-		if (!empty && rnp->qsmask == 0 &&
-		    !rcu_preempted_readers(rnp)) {
-			struct rcu_node *rnp_p;
-
-			if (rnp->parent == NULL) {
-				/* Only one rcu_node in the tree. */
-				cpu_quiet_msk_finish(&rcu_preempt_state, flags);
-				return;
-			}
-			/* Report up the rest of the hierarchy. */
-			mask = rnp->grpmask;
+		if (empty)
 			spin_unlock_irqrestore(&rnp->lock, flags);
-			rnp_p = rnp->parent;
-			spin_lock_irqsave(&rnp_p->lock, flags);
-			WARN_ON_ONCE(rnp->qsmask);
-			cpu_quiet_msk(mask, &rcu_preempt_state, rnp_p, flags);
-			return;
-		}
-		spin_unlock(&rnp->lock);
+		else
+			rcu_report_unblock_qs_rnp(rnp, flags);
+
+		/*
+		 * If this was the last task on the expedited lists,
+		 * then we need to report up the rcu_node hierarchy.
+		 */
+		if (!empty_exp && !rcu_preempted_readers_exp(rnp))
+			rcu_report_exp_rnp(&rcu_preempt_state, rnp);
+	} else {
+		local_irq_restore(flags);
 	}
-	local_irq_restore(flags);
 }
 
 /*
@@ -303,6 +344,8 @@ static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
  * rcu_node.  The reason for not just moving them to the immediate
  * parent is to remove the need for rcu_read_unlock_special() to
  * make more than two attempts to acquire the target rcu_node's lock.
+ * Returns true if there were tasks blocking the current RCU grace
+ * period.
  *
  * Returns 1 if there was previously a task blocking the current grace
  * period on the specified rcu_node structure.
@@ -316,7 +359,7 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	int i;
 	struct list_head *lp;
 	struct list_head *lp_root;
-	int retval = rcu_preempted_readers(rnp);
+	int retval = 0;
 	struct rcu_node *rnp_root = rcu_get_root(rsp);
 	struct task_struct *tp;
 
@@ -326,7 +369,9 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	}
 	WARN_ON_ONCE(rnp != rdp->mynode &&
 		     (!list_empty(&rnp->blocked_tasks[0]) ||
-		      !list_empty(&rnp->blocked_tasks[1])));
+		      !list_empty(&rnp->blocked_tasks[1]) ||
+		      !list_empty(&rnp->blocked_tasks[2]) ||
+		      !list_empty(&rnp->blocked_tasks[3])));
 
 	/*
 	 * Move tasks up to root rcu_node.  Rely on the fact that the
@@ -334,7 +379,11 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	 * rcu_nodes in terms of gp_num value.  This fact allows us to
 	 * move the blocked_tasks[] array directly, element by element.
 	 */
-	for (i = 0; i < 2; i++) {
+	if (rcu_preempted_readers(rnp))
+		retval |= RCU_OFL_TASKS_NORM_GP;
+	if (rcu_preempted_readers_exp(rnp))
+		retval |= RCU_OFL_TASKS_EXP_GP;
+	for (i = 0; i < 4; i++) {
 		lp = &rnp->blocked_tasks[i];
 		lp_root = &rnp_root->blocked_tasks[i];
 		while (!list_empty(lp)) {
@@ -346,7 +395,6 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 			spin_unlock(&rnp_root->lock); /* irqs remain disabled */
 		}
 	}
-
 	return retval;
 }
 
@@ -398,14 +446,183 @@ void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 }
 EXPORT_SYMBOL_GPL(call_rcu);
 
+/**
+ * synchronize_rcu - wait until a grace period has elapsed.
+ *
+ * Control will return to the caller some time after a full grace
+ * period has elapsed, in other words after all currently executing RCU
+ * read-side critical sections have completed.  RCU read-side critical
+ * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
+ * and may be nested.
+ */
+void synchronize_rcu(void)
+{
+	struct rcu_synchronize rcu;
+
+	if (!rcu_scheduler_active)
+		return;
+
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	call_rcu(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+}
+EXPORT_SYMBOL_GPL(synchronize_rcu);
+
+static DECLARE_WAIT_QUEUE_HEAD(sync_rcu_preempt_exp_wq);
+static long sync_rcu_preempt_exp_count;
+static DEFINE_MUTEX(sync_rcu_preempt_exp_mutex);
+
 /*
- * Wait for an rcu-preempt grace period.  We are supposed to expedite the
- * grace period, but this is the crude slow compatability hack, so just
- * invoke synchronize_rcu().
+ * Return non-zero if there are any tasks in RCU read-side critical
+ * sections blocking the current preemptible-RCU expedited grace period.
+ * If there is no preemptible-RCU expedited grace period currently in
+ * progress, returns zero unconditionally.
+ */
+static int rcu_preempted_readers_exp(struct rcu_node *rnp)
+{
+	return !list_empty(&rnp->blocked_tasks[2]) ||
+	       !list_empty(&rnp->blocked_tasks[3]);
+}
+
+/*
+ * return non-zero if there is no RCU expedited grace period in progress
+ * for the specified rcu_node structure, in other words, if all CPUs and
+ * tasks covered by the specified rcu_node structure have done their bit
+ * for the current expedited grace period.  Works only for preemptible
+ * RCU -- other RCU implementation use other means.
+ *
+ * Caller must hold sync_rcu_preempt_exp_mutex.
+ */
+static int sync_rcu_preempt_exp_done(struct rcu_node *rnp)
+{
+	return !rcu_preempted_readers_exp(rnp) &&
+	       ACCESS_ONCE(rnp->expmask) == 0;
+}
+
+/*
+ * Report the exit from RCU read-side critical section for the last task
+ * that queued itself during or before the current expedited preemptible-RCU
+ * grace period.  This event is reported either to the rcu_node structure on
+ * which the task was queued or to one of that rcu_node structure's ancestors,
+ * recursively up the tree.  (Calm down, calm down, we do the recursion
+ * iteratively!)
+ *
+ * Caller must hold sync_rcu_preempt_exp_mutex.
+ */
+static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
+{
+	unsigned long flags;
+	unsigned long mask;
+
+	spin_lock_irqsave(&rnp->lock, flags);
+	for (;;) {
+		if (!sync_rcu_preempt_exp_done(rnp))
+			break;
+		if (rnp->parent == NULL) {
+			wake_up(&sync_rcu_preempt_exp_wq);
+			break;
+		}
+		mask = rnp->grpmask;
+		spin_unlock(&rnp->lock); /* irqs remain disabled */
+		rnp = rnp->parent;
+		spin_lock(&rnp->lock); /* irqs already disabled */
+		rnp->expmask &= ~mask;
+	}
+	spin_unlock_irqrestore(&rnp->lock, flags);
+}
+
+/*
+ * Snapshot the tasks blocking the newly started preemptible-RCU expedited
+ * grace period for the specified rcu_node structure.  If there are no such
+ * tasks, report it up the rcu_node hierarchy.
+ *
+ * Caller must hold sync_rcu_preempt_exp_mutex and rsp->onofflock.
+ */
+static void
+sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
+{
+	int must_wait;
+
+	spin_lock(&rnp->lock); /* irqs already disabled */
+	list_splice_init(&rnp->blocked_tasks[0], &rnp->blocked_tasks[2]);
+	list_splice_init(&rnp->blocked_tasks[1], &rnp->blocked_tasks[3]);
+	must_wait = rcu_preempted_readers_exp(rnp);
+	spin_unlock(&rnp->lock); /* irqs remain disabled */
+	if (!must_wait)
+		rcu_report_exp_rnp(rsp, rnp);
+}
+
+/*
+ * Wait for an rcu-preempt grace period, but expedite it.  The basic idea
+ * is to invoke synchronize_sched_expedited() to push all the tasks to
+ * the ->blocked_tasks[] lists, move all entries from the first set of
+ * ->blocked_tasks[] lists to the second set, and finally wait for this
+ * second set to drain.
  */
 void synchronize_rcu_expedited(void)
 {
-	synchronize_rcu();
+	unsigned long flags;
+	struct rcu_node *rnp;
+	struct rcu_state *rsp = &rcu_preempt_state;
+	long snap;
+	int trycount = 0;
+
+	smp_mb(); /* Caller's modifications seen first by other CPUs. */
+	snap = ACCESS_ONCE(sync_rcu_preempt_exp_count) + 1;
+	smp_mb(); /* Above access cannot bleed into critical section. */
+
+	/*
+	 * Acquire lock, falling back to synchronize_rcu() if too many
+	 * lock-acquisition failures.  Of course, if someone does the
+	 * expedited grace period for us, just leave.
+	 */
+	while (!mutex_trylock(&sync_rcu_preempt_exp_mutex)) {
+		if (trycount++ < 10)
+			udelay(trycount * num_online_cpus());
+		else {
+			synchronize_rcu();
+			return;
+		}
+		if ((ACCESS_ONCE(sync_rcu_preempt_exp_count) - snap) > 0)
+			goto mb_ret; /* Others did our work for us. */
+	}
+	if ((ACCESS_ONCE(sync_rcu_preempt_exp_count) - snap) > 0)
+		goto unlock_mb_ret; /* Others did our work for us. */
+
+	/* force all RCU readers onto blocked_tasks[]. */
+	synchronize_sched_expedited();
+
+	spin_lock_irqsave(&rsp->onofflock, flags);
+
+	/* Initialize ->expmask for all non-leaf rcu_node structures. */
+	rcu_for_each_nonleaf_node_breadth_first(rsp, rnp) {
+		spin_lock(&rnp->lock); /* irqs already disabled. */
+		rnp->expmask = rnp->qsmaskinit;
+		spin_unlock(&rnp->lock); /* irqs remain disabled. */
+	}
+
+	/* Snapshot current state of ->blocked_tasks[] lists. */
+	rcu_for_each_leaf_node(rsp, rnp)
+		sync_rcu_preempt_exp_init(rsp, rnp);
+	if (NUM_RCU_NODES > 1)
+		sync_rcu_preempt_exp_init(rsp, rcu_get_root(rsp));
+
+	spin_unlock_irqrestore(&rsp->onofflock, flags);
+
+	/* Wait for snapshotted ->blocked_tasks[] lists to drain. */
+	rnp = rcu_get_root(rsp);
+	wait_event(sync_rcu_preempt_exp_wq,
+		   sync_rcu_preempt_exp_done(rnp));
+
+	/* Clean up and exit. */
+	smp_mb(); /* ensure expedited GP seen before counter increment. */
+	ACCESS_ONCE(sync_rcu_preempt_exp_count)++;
+unlock_mb_ret:
+	mutex_unlock(&sync_rcu_preempt_exp_mutex);
+mb_ret:
+	smp_mb(); /* ensure subsequent action seen after grace period. */
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
 
@@ -481,7 +698,7 @@ void exit_rcu(void)
 /*
  * Tell them what RCU they are running.
  */
-static inline void rcu_bootup_announce(void)
+static void __init rcu_bootup_announce(void)
 {
 	printk(KERN_INFO "Hierarchical RCU implementation.\n");
 }
@@ -512,6 +729,16 @@ static int rcu_preempted_readers(struct rcu_node *rnp)
 	return 0;
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+
+/* Because preemptible RCU does not exist, no quieting of tasks. */
+static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
+{
+	spin_unlock_irqrestore(&rnp->lock, flags);
+}
+
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 
 /*
@@ -594,6 +821,20 @@ void synchronize_rcu_expedited(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
 
+#ifdef CONFIG_HOTPLUG_CPU
+
+/*
+ * Because preemptable RCU does not exist, there is never any need to
+ * report on tasks preempted in RCU read-side critical sections during
+ * expedited RCU grace periods.
+ */
+static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
+{
+	return;
+}
+
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+
 /*
  * Because preemptable RCU does not exist, it never has any work to do.
  */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 4b31c77..9d2c884 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -155,12 +155,15 @@ static const struct file_operations rcudata_csv_fops = {
 
 static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 {
+	long gpnum;
 	int level = 0;
+	int phase;
 	struct rcu_node *rnp;
 
+	gpnum = rsp->gpnum;
 	seq_printf(m, "c=%ld g=%ld s=%d jfq=%ld j=%x "
 		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld\n",
-		   rsp->completed, rsp->gpnum, rsp->signaled,
+		   rsp->completed, gpnum, rsp->signaled,
 		   (long)(rsp->jiffies_force_qs - jiffies),
 		   (int)(jiffies & 0xffff),
 		   rsp->n_force_qs, rsp->n_force_qs_ngp,
@@ -171,8 +174,13 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 			seq_puts(m, "\n");
 			level = rnp->level;
 		}
-		seq_printf(m, "%lx/%lx %d:%d ^%d    ",
+		phase = gpnum & 0x1;
+		seq_printf(m, "%lx/%lx %c%c>%c%c %d:%d ^%d    ",
 			   rnp->qsmask, rnp->qsmaskinit,
+			   "T."[list_empty(&rnp->blocked_tasks[phase])],
+			   "E."[list_empty(&rnp->blocked_tasks[phase + 2])],
+			   "T."[list_empty(&rnp->blocked_tasks[!phase])],
+			   "E."[list_empty(&rnp->blocked_tasks[!phase + 2])],
 			   rnp->grplo, rnp->grphi, rnp->grpnum);
 	}
 	seq_puts(m, "\n");
diff --git a/kernel/sched.c b/kernel/sched.c
index 76c0e96..e69fee4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -10865,6 +10865,7 @@ void synchronize_sched_expedited(void)
 		spin_unlock_irqrestore(&rq->lock, flags);
 	}
 	rcu_expedited_state = RCU_EXPEDITED_STATE_IDLE;
+	synchronize_sched_expedited_count++;
 	mutex_unlock(&rcu_sched_expedited_mutex);
 	put_online_cpus();
 	if (need_full_sync)
diff --git a/kernel/softirq.c b/kernel/softirq.c
index f8749e5..21939d9 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -302,9 +302,9 @@ void irq_exit(void)
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
 
+	rcu_irq_exit();
 #ifdef CONFIG_NO_HZ
 	/* Make sure that timer wheel updates are propagated */
-	rcu_irq_exit();
 	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
 		tick_nohz_stop_sched_tick(0);
 #endif
diff --git a/kernel/srcu.c b/kernel/srcu.c
index b0aeeaf..818d7d9 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -49,6 +49,7 @@ int init_srcu_struct(struct srcu_struct *sp)
 	sp->per_cpu_ref = alloc_percpu(struct srcu_struct_array);
 	return (sp->per_cpu_ref ? 0 : -ENOMEM);
 }
+EXPORT_SYMBOL_GPL(init_srcu_struct);
 
 /*
  * srcu_readers_active_idx -- returns approximate number of readers
@@ -97,6 +98,7 @@ void cleanup_srcu_struct(struct srcu_struct *sp)
 	free_percpu(sp->per_cpu_ref);
 	sp->per_cpu_ref = NULL;
 }
+EXPORT_SYMBOL_GPL(cleanup_srcu_struct);
 
 /**
  * srcu_read_lock - register a new reader for an SRCU-protected structure.
@@ -118,6 +120,7 @@ int srcu_read_lock(struct srcu_struct *sp)
 	preempt_enable();
 	return idx;
 }
+EXPORT_SYMBOL_GPL(srcu_read_lock);
 
 /**
  * srcu_read_unlock - unregister a old reader from an SRCU-protected structure.
@@ -136,22 +139,12 @@ void srcu_read_unlock(struct srcu_struct *sp, int idx)
 	per_cpu_ptr(sp->per_cpu_ref, smp_processor_id())->c[idx]--;
 	preempt_enable();
 }
+EXPORT_SYMBOL_GPL(srcu_read_unlock);
 
-/**
- * synchronize_srcu - wait for prior SRCU read-side critical-section completion
- * @sp: srcu_struct with which to synchronize.
- *
- * Flip the completed counter, and wait for the old count to drain to zero.
- * As with classic RCU, the updater must use some separate means of
- * synchronizing concurrent updates.  Can block; must be called from
- * process context.
- *
- * Note that it is illegal to call synchornize_srcu() from the corresponding
- * SRCU read-side critical section; doing so will result in deadlock.
- * However, it is perfectly legal to call synchronize_srcu() on one
- * srcu_struct from some other srcu_struct's read-side critical section.
+/*
+ * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
  */
-void synchronize_srcu(struct srcu_struct *sp)
+void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
 {
 	int idx;
 
@@ -173,7 +166,7 @@ void synchronize_srcu(struct srcu_struct *sp)
 		return;
 	}
 
-	synchronize_sched();  /* Force memory barrier on all CPUs. */
+	sync_func();  /* Force memory barrier on all CPUs. */
 
 	/*
 	 * The preceding synchronize_sched() ensures that any CPU that
@@ -190,7 +183,7 @@ void synchronize_srcu(struct srcu_struct *sp)
 	idx = sp->completed & 0x1;
 	sp->completed++;
 
-	synchronize_sched();  /* Force memory barrier on all CPUs. */
+	sync_func();  /* Force memory barrier on all CPUs. */
 
 	/*
 	 * At this point, because of the preceding synchronize_sched(),
@@ -203,7 +196,7 @@ void synchronize_srcu(struct srcu_struct *sp)
 	while (srcu_readers_active_idx(sp, idx))
 		schedule_timeout_interruptible(1);
 
-	synchronize_sched();  /* Force memory barrier on all CPUs. */
+	sync_func();  /* Force memory barrier on all CPUs. */
 
 	/*
 	 * The preceding synchronize_sched() forces all srcu_read_unlock()
@@ -237,6 +230,47 @@ void synchronize_srcu(struct srcu_struct *sp)
 }
 
 /**
+ * synchronize_srcu - wait for prior SRCU read-side critical-section completion
+ * @sp: srcu_struct with which to synchronize.
+ *
+ * Flip the completed counter, and wait for the old count to drain to zero.
+ * As with classic RCU, the updater must use some separate means of
+ * synchronizing concurrent updates.  Can block; must be called from
+ * process context.
+ *
+ * Note that it is illegal to call synchronize_srcu() from the corresponding
+ * SRCU read-side critical section; doing so will result in deadlock.
+ * However, it is perfectly legal to call synchronize_srcu() on one
+ * srcu_struct from some other srcu_struct's read-side critical section.
+ */
+void synchronize_srcu(struct srcu_struct *sp)
+{
+	__synchronize_srcu(sp, synchronize_sched);
+}
+EXPORT_SYMBOL_GPL(synchronize_srcu);
+
+/**
+ * synchronize_srcu_expedited - like synchronize_srcu, but less patient
+ * @sp: srcu_struct with which to synchronize.
+ *
+ * Flip the completed counter, and wait for the old count to drain to zero.
+ * As with classic RCU, the updater must use some separate means of
+ * synchronizing concurrent updates.  Can block; must be called from
+ * process context.
+ *
+ * Note that it is illegal to call synchronize_srcu_expedited()
+ * from the corresponding SRCU read-side critical section; doing so
+ * will result in deadlock.  However, it is perfectly legal to call
+ * synchronize_srcu_expedited() on one srcu_struct from some other
+ * srcu_struct's read-side critical section.
+ */
+void synchronize_srcu_expedited(struct srcu_struct *sp)
+{
+	__synchronize_srcu(sp, synchronize_sched_expedited);
+}
+EXPORT_SYMBOL_GPL(synchronize_srcu_expedited);
+
+/**
  * srcu_batches_completed - return batches completed.
  * @sp: srcu_struct on which to report batch completion.
  *
@@ -248,10 +282,4 @@ long srcu_batches_completed(struct srcu_struct *sp)
 {
 	return sp->completed;
 }
-
-EXPORT_SYMBOL_GPL(init_srcu_struct);
-EXPORT_SYMBOL_GPL(cleanup_srcu_struct);
-EXPORT_SYMBOL_GPL(srcu_read_lock);
-EXPORT_SYMBOL_GPL(srcu_read_unlock);
-EXPORT_SYMBOL_GPL(synchronize_srcu);
 EXPORT_SYMBOL_GPL(srcu_batches_completed);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8911558..50e0e78 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -749,7 +749,7 @@ config RCU_TORTURE_TEST_RUNNABLE
 config RCU_CPU_STALL_DETECTOR
 	bool "Check for stalled CPUs delaying RCU grace periods"
 	depends on TREE_RCU || TREE_PREEMPT_RCU
-	default n
+	default y
 	help
 	  This option causes RCU to printk information on which
 	  CPUs are delaying the current grace period, but only when
