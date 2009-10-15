Return-Path: <linux-kernel-owner+w=401wt.eu-S935032AbZJOJ1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935032AbZJOJ1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933727AbZJOJ07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:26:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:45723 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933519AbZJOJ04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:26:56 -0400
Date: Thu, 15 Oct 2009 09:25:37 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1255540559799-git-send-email->
References: <1255540559799-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Update trace.txt documentation to reflect recent changes
Message-ID: <tip-bd58b430039435e4c981cf802b5b11d511d73abd@git.kernel.org>
Git-Commit-ID: bd58b430039435e4c981cf802b5b11d511d73abd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 09:25:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd58b430039435e4c981cf802b5b11d511d73abd
Gitweb:     http://git.kernel.org/tip/bd58b430039435e4c981cf802b5b11d511d73abd
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 14 Oct 2009 10:15:54 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Oct 2009 11:20:23 +0200

rcu: Update trace.txt documentation to reflect recent changes

o	Remove the CONFIG_PREEMPT_RCU documentation since this
	config option has now been removed.

o	Change the now-incorrect references to "rcu" labels to
	instead be "rcu_sched".

o	Add notes stating that CONFIG_TREE_PREEMPT_RCU kernels will
	have additional "rcu_preempt" output.

o	Note the new "oqlen" field in the rcuhier output (for
	RCU callbacks orphaned by an offlined CPU).

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
Cc: npiggin@suse.de
Cc: jens.axboe@oracle.com
LKML-Reference: <1255540559799-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/RCU/trace.txt |  231 ++++++------------------------------------
 1 files changed, 33 insertions(+), 198 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 187bbf1..c1a9550 100644
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
+c=6902 g=6903 s=2 jfq=3 j=72c7 nfqs=13142/nfqsng=0(13142) fqlh=6 oqlen=0
 1/1 0:127 ^0    
 3/3 0:35 ^0    0/0 36:71 ^1    0/0 72:107 ^2    0/0 108:127 ^3    
 3/3f 0:5 ^0    2/3 6:11 ^1    0/0 12:17 ^2    0/0 18:23 ^3    0/0 24:29 ^4    0/0 30:35 ^5    0/0 36:41 ^0    0/0 42:47 ^1    0/0 48:53 ^2    0/0 54:59 ^3    0/0 60:65 ^4    0/0 66:71 ^5    0/0 72:77 ^0    0/0 78:83 ^1    0/0 84:89 ^2    0/0 90:95 ^3    0/0 96:101 ^4    0/0 102:107 ^5    0/0 108:113 ^0    0/0 114:119 ^1    0/0 120:125 ^2    0/0 126:127 ^3    
 rcu_bh:
-c=-226 g=-226 s=1 jfq=-5701 j=72c7 nfqs=88/nfqsng=0(88) fqlh=0
+c=-226 g=-226 s=1 jfq=-5701 j=72c7 nfqs=88/nfqsng=0(88) fqlh=0 oqlen=0
 0/1 0:127 ^0    
 0/3 0:35 ^0    0/0 36:71 ^1    0/0 72:107 ^2    0/0 108:127 ^3    
 0/3f 0:5 ^0    0/3 6:11 ^1    0/0 12:17 ^2    0/0 18:23 ^3    0/0 24:29 ^4    0/0 30:35 ^5    0/0 36:41 ^0    0/0 42:47 ^1    0/0 48:53 ^2    0/0 54:59 ^3    0/0 60:65 ^4    0/0 66:71 ^5    0/0 72:77 ^0    0/0 78:83 ^1    0/0 84:89 ^2    0/0 90:95 ^3    0/0 96:101 ^4    0/0 102:107 ^5    0/0 108:113 ^0    0/0 114:119 ^1    0/0 120:125 ^2    0/0 126:127 ^3
 
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
@@ -389,10 +223,10 @@ o	Each element of the form "1/1 0:127 ^0" represents one struct
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
 
 	o	The numbers separated by the ":" are the range of CPUs
 		served by this struct rcu_node.  This can be helpful
@@ -431,8 +265,9 @@ rcu_bh:
   6 np=120834 qsp=9902 cbr=0 cng=0 gpc=6 gps=3 nf=2 nn=110921
   7 np=144888 qsp=26336 cbr=0 cng=0 gpc=8 gps=2 nf=0 nn=118542
 
-As always, this is once again split into "rcu" and "rcu_bh" portions.
-The fields are as follows:
+As always, this is once again split into "rcu_sched" and "rcu_bh"
+portions, with CONFIG_TREE_PREEMPT_RCU kernels having an additional
+"rcu_preempt" section.  The fields are as follows:
 
 o	"np" is the number of times that __rcu_pending() has been invoked
 	for the corresponding flavor of RCU.
