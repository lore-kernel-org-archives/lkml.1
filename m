Return-Path: <linux-kernel-owner+w=401wt.eu-S1765158AbXLMRT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765158AbXLMRT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765269AbXLMRSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:18:48 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:33951 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763437AbXLMRSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:18:45 -0500
Date: Thu, 13 Dec 2007 22:48:14 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E McKenney <paulmck@us.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Ted Tso <tytso@us.ibm.com>, dvhltc@us.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 6/6] Preempt-RCU: Update RCU Documentation.
Message-ID: <20071213171814.GG25981@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071213170348.GA25981@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213170348.GA25981@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preempt-RCU: Update RCU Documentation.

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

This patch updates the RCU documentation to reflect preemptible RCU as
well as recent publications.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 Documentation/RCU/RTFP.txt    |  210 +++++++++++++++++++++++++++++++++++++++--
 Documentation/RCU/rcu.txt     |   19 +++-
 Documentation/RCU/torture.txt |   11 +-
 3 files changed, 221 insertions(+), 19 deletions(-)

diff --git a/Documentation/RCU/RTFP.txt b/Documentation/RCU/RTFP.txt
index 6221464..39ad8f5 100644
--- a/Documentation/RCU/RTFP.txt
+++ b/Documentation/RCU/RTFP.txt
@@ -9,8 +9,8 @@ The first thing resembling RCU was published in 1980, when Kung and Lehman
 [Kung80] recommended use of a garbage collector to defer destruction
 of nodes in a parallel binary search tree in order to simplify its
 implementation.  This works well in environments that have garbage
-collectors, but current production garbage collectors incur significant
-read-side overhead.
+collectors, but most production garbage collectors incur significant
+overhead.
 
 In 1982, Manber and Ladner [Manber82,Manber84] recommended deferring
 destruction until all threads running at that time have terminated, again
@@ -99,16 +99,25 @@ locking, reduces contention, reduces memory latency for readers, and
 parallelizes pipeline stalls and memory latency for writers.  However,
 these techniques still impose significant read-side overhead in the
 form of memory barriers.  Researchers at Sun worked along similar lines
-in the same timeframe [HerlihyLM02,HerlihyLMS03].  These techniques
-can be thought of as inside-out reference counts, where the count is
-represented by the number of hazard pointers referencing a given data
-structure (rather than the more conventional counter field within the
-data structure itself).
+in the same timeframe [HerlihyLM02].  These techniques can be thought
+of as inside-out reference counts, where the count is represented by the
+number of hazard pointers referencing a given data structure (rather than
+the more conventional counter field within the data structure itself).
+
+By the same token, RCU can be thought of as a "bulk reference count",
+where some form of reference counter covers all reference by a given CPU
+or thread during a set timeframe.  This timeframe is related to, but
+not necessarily exactly the same as, an RCU grace period.  In classic
+RCU, the reference counter is the per-CPU bit in the "bitmask" field,
+and each such bit covers all references that might have been made by
+the corresponding CPU during the prior grace period.  Of course, RCU
+can be thought of in other terms as well.
 
 In 2003, the K42 group described how RCU could be used to create
-hot-pluggable implementations of operating-system functions.  Later that
-year saw a paper describing an RCU implementation of System V IPC
-[Arcangeli03], and an introduction to RCU in Linux Journal [McKenney03a].
+hot-pluggable implementations of operating-system functions [Appavoo03a].
+Later that year saw a paper describing an RCU implementation of System
+V IPC [Arcangeli03], and an introduction to RCU in Linux Journal
+[McKenney03a].
 
 2004 has seen a Linux-Journal article on use of RCU in dcache
 [McKenney04a], a performance comparison of locking to RCU on several
@@ -117,10 +126,19 @@ number of operating-system kernels [PaulEdwardMcKenneyPhD], a paper
 describing how to make RCU safe for soft-realtime applications [Sarma04c],
 and a paper describing SELinux performance with RCU [JamesMorris04b].
 
-2005 has seen further adaptation of RCU to realtime use, permitting
+2005 brought further adaptation of RCU to realtime use, permitting
 preemption of RCU realtime critical sections [PaulMcKenney05a,
 PaulMcKenney05b].
 
+2006 saw the first best-paper award for an RCU paper [ThomasEHart2006a],
+as well as further work on efficient implementations of preemptible
+RCU [PaulEMcKenney2006b], but priority-boosting of RCU read-side critical
+sections proved elusive.  An RCU implementation permitting general
+blocking in read-side critical sections appeared [PaulEMcKenney2006c],
+Robert Olsson described an RCU-protected trie-hash combination
+[RobertOlsson2006a].
+
+
 Bibtex Entries
 
 @article{Kung80
@@ -203,6 +221,41 @@ Bibtex Entries
 ,Address="New Orleans, LA"
 }
 
+@conference{Pu95a,
+Author = "Calton Pu and Tito Autrey and Andrew Black and Charles Consel and
+Crispin Cowan and Jon Inouye and Lakshmi Kethana and Jonathan Walpole and
+Ke Zhang",
+Title = "Optimistic Incremental Specialization: Streamlining a Commercial
+Operating System",
+Booktitle = "15\textsuperscript{th} ACM Symposium on
+Operating Systems Principles (SOSP'95)",
+address = "Copper Mountain, CO",
+month="December",
+year="1995",
+pages="314-321",
+annotation="
+	Uses a replugger, but with a flag to signal when people are
+	using the resource at hand.  Only one reader at a time.
+"
+}
+
+@conference{Cowan96a,
+Author = "Crispin Cowan and Tito Autrey and Charles Krasic and
+Calton Pu and Jonathan Walpole",
+Title = "Fast Concurrent Dynamic Linking for an Adaptive Operating System",
+Booktitle = "International Conference on Configurable Distributed Systems
+(ICCDS'96)",
+address = "Annapolis, MD",
+month="May",
+year="1996",
+pages="108",
+isbn="0-8186-7395-8",
+annotation="
+	Uses a replugger, but with a counter to signal when people are
+	using the resource at hand.  Allows multiple readers.
+"
+}
+
 @techreport{Slingwine95
 ,author="John D. Slingwine and Paul E. McKenney"
 ,title="Apparatus and Method for Achieving Reduced Overhead Mutual
@@ -312,6 +365,49 @@ Andrea Arcangeli and Andi Kleen and Orran Krieger and Rusty Russell"
 [Viewed June 23, 2004]"
 }
 
+@conference{Michael02a
+,author="Maged M. Michael"
+,title="Safe Memory Reclamation for Dynamic Lock-Free Objects Using Atomic
+Reads and Writes"
+,Year="2002"
+,Month="August"
+,booktitle="{Proceedings of the 21\textsuperscript{st} Annual ACM
+Symposium on Principles of Distributed Computing}"
+,pages="21-30"
+,annotation="
+	Each thread keeps an array of pointers to items that it is
+	currently referencing.	Sort of an inside-out garbage collection
+	mechanism, but one that requires the accessing code to explicitly
+	state its needs.  Also requires read-side memory barriers on
+	most architectures.
+"
+}
+
+@conference{Michael02b
+,author="Maged M. Michael"
+,title="High Performance Dynamic Lock-Free Hash Tables and List-Based Sets"
+,Year="2002"
+,Month="August"
+,booktitle="{Proceedings of the 14\textsuperscript{th} Annual ACM
+Symposium on Parallel
+Algorithms and Architecture}"
+,pages="73-82"
+,annotation="
+	Like the title says...
+"
+}
+
+@InProceedings{HerlihyLM02
+,author={Maurice Herlihy and Victor Luchangco and Mark Moir}
+,title="The Repeat Offender Problem: A Mechanism for Supporting Dynamic-Sized,
+Lock-Free Data Structures"
+,booktitle={Proceedings of 16\textsuperscript{th} International
+Symposium on Distributed Computing}
+,year=2002
+,month="October"
+,pages="339-353"
+}
+
 @article{Appavoo03a
 ,author="J. Appavoo and K. Hui and C. A. N. Soules and R. W. Wisniewski and
 D. M. {Da Silva} and O. Krieger and M. A. Auslander and D. J. Edelsohn and
@@ -447,3 +543,95 @@ Oregon Health and Sciences University"
 	Realtime turns into making RCU yet more realtime friendly.
 "
 }
+
+@conference{ThomasEHart2006a
+,Author="Thomas E. Hart and Paul E. McKenney and Angela Demke Brown"
+,Title="Making Lockless Synchronization Fast: Performance Implications
+of Memory Reclamation"
+,Booktitle="20\textsuperscript{th} {IEEE} International Parallel and
+Distributed Processing Symposium"
+,month="April"
+,year="2006"
+,day="25-29"
+,address="Rhodes, Greece"
+,annotation="
+	Compares QSBR (AKA "classic RCU"), HPBR, EBR, and lock-free
+	reference counting.
+"
+}
+
+@Conference{PaulEMcKenney2006b
+,Author="Paul E. McKenney and Dipankar Sarma and Ingo Molnar and
+Suparna Bhattacharya"
+,Title="Extending RCU for Realtime and Embedded Workloads"
+,Booktitle="{Ottawa Linux Symposium}"
+,Month="July"
+,Year="2006"
+,pages="v2 123-138"
+,note="Available:
+\url{http://www.linuxsymposium.org/2006/view_abstract.php?content_key=184}
+\url{http://www.rdrop.com/users/paulmck/RCU/OLSrtRCU.2006.08.11a.pdf}
+[Viewed January 1, 2007]"
+,annotation="
+	Described how to improve the -rt implementation of realtime RCU.
+"
+}
+
+@unpublished{PaulEMcKenney2006c
+,Author="Paul E. McKenney"
+,Title="Sleepable {RCU}"
+,month="October"
+,day="9"
+,year="2006"
+,note="Available:
+\url{http://lwn.net/Articles/202847/}
+Revised:
+\url{http://www.rdrop.com/users/paulmck/RCU/srcu.2007.01.14a.pdf}
+[Viewed August 21, 2006]"
+,annotation="
+	LWN article introducing SRCU.
+"
+}
+
+@unpublished{RobertOlsson2006a
+,Author="Robert Olsson and Stefan Nilsson"
+,Title="{TRASH}: A dynamic {LC}-trie and hash data structure"
+,month="August"
+,day="18"
+,year="2006"
+,note="Available:
+\url{http://www.nada.kth.se/~snilsson/public/papers/trash/trash.pdf}
+[Viewed February 24, 2007]"
+,annotation="
+	RCU-protected dynamic trie-hash combination.
+"
+}
+
+@unpublished{ThomasEHart2007a
+,Author="Thomas E. Hart and Paul E. McKenney and Angela Demke Brown and Jonathan Walpole"
+,Title="Performance of memory reclamation for lockless synchronization"
+,journal="J. Parallel Distrib. Comput."
+,year="2007"
+,note="To appear in J. Parallel Distrib. Comput.
+       \url{doi=10.1016/j.jpdc.2007.04.010}"
+,annotation={
+	Compares QSBR (AKA "classic RCU"), HPBR, EBR, and lock-free
+	reference counting.  Journal version of ThomasEHart2006a.
+}
+}
+
+@unpublished{PaulEMcKenney2007QRCUspin
+,Author="Paul E. McKenney"
+,Title="Using Promela and Spin to verify parallel algorithms"
+,month="August"
+,day="1"
+,year="2007"
+,note="Available:
+\url{http://lwn.net/Articles/243851/}
+[Viewed September 8, 2007]"
+,annotation="
+	LWN article describing Promela and spin, and also using Oleg
+	Nesterov's QRCU as an example (with Paul McKenney's fastpath).
+"
+}
+
diff --git a/Documentation/RCU/rcu.txt b/Documentation/RCU/rcu.txt
index f84407c..95821a2 100644
--- a/Documentation/RCU/rcu.txt
+++ b/Documentation/RCU/rcu.txt
@@ -36,6 +36,14 @@ o	How can the updater tell when a grace period has completed
 	executed in user mode, or executed in the idle loop, we can
 	safely free up that item.
 
+	Preemptible variants of RCU (CONFIG_PREEMPT_RCU) get the
+	same effect, but require that the readers manipulate CPU-local
+	counters.  These counters allow limited types of blocking
+	within RCU read-side critical sections.  SRCU also uses
+	CPU-local counters, and permits general blocking within
+	RCU read-side critical sections.  These two variants of
+	RCU detect grace periods by sampling these counters.
+
 o	If I am running on a uniprocessor kernel, which can only do one
 	thing at a time, why should I wait for a grace period?
 
@@ -46,7 +54,10 @@ o	How can I see where RCU is currently used in the Linux kernel?
 	Search for "rcu_read_lock", "rcu_read_unlock", "call_rcu",
 	"rcu_read_lock_bh", "rcu_read_unlock_bh", "call_rcu_bh",
 	"srcu_read_lock", "srcu_read_unlock", "synchronize_rcu",
-	"synchronize_net", and "synchronize_srcu".
+	"synchronize_net", "synchronize_srcu", and the other RCU
+	primitives.  Or grab one of the cscope databases from:
+
+	http://www.rdrop.com/users/paulmck/RCU/linuxusage/rculocktab.html
 
 o	What guidelines should I follow when writing code that uses RCU?
 
@@ -67,7 +78,11 @@ o	I hear that RCU is patented?  What is with that?
 
 o	I hear that RCU needs work in order to support realtime kernels?
 
-	Yes, work in progress.
+	This work is largely completed.  Realtime-friendly RCU can be
+	enabled via the CONFIG_PREEMPT_RCU kernel configuration parameter.
+	However, work is in progress for enabling priority boosting of
+	preempted RCU read-side critical sections.This is needed if you
+	have CPU-bound realtime threads.
 
 o	Where can I find more information on RCU?
 
diff --git a/Documentation/RCU/torture.txt b/Documentation/RCU/torture.txt
index 25a3c3f..2967a65 100644
--- a/Documentation/RCU/torture.txt
+++ b/Documentation/RCU/torture.txt
@@ -46,12 +46,13 @@ stat_interval	The number of seconds between output of torture
 
 shuffle_interval
 		The number of seconds to keep the test threads affinitied
-		to a particular subset of the CPUs.  Used in conjunction
-		with test_no_idle_hz.
+		to a particular subset of the CPUs, defaults to 5 seconds.
+		Used in conjunction with test_no_idle_hz.
 
 test_no_idle_hz	Whether or not to test the ability of RCU to operate in
 		a kernel that disables the scheduling-clock interrupt to
 		idle CPUs.  Boolean parameter, "1" to test, "0" otherwise.
+		Defaults to omitting this test.
 
 torture_type	The type of RCU to test: "rcu" for the rcu_read_lock() API,
 		"rcu_sync" for rcu_read_lock() with synchronous reclamation,
@@ -82,8 +83,6 @@ be evident.  ;-)
 
 The entries are as follows:
 
-o	"ggp": The number of counter flips (or batches) since boot.
-
 o	"rtc": The hexadecimal address of the structure currently visible
 	to readers.
 
@@ -117,8 +116,8 @@ o	"Reader Pipe": Histogram of "ages" of structures seen by readers.
 o	"Reader Batch": Another histogram of "ages" of structures seen
 	by readers, but in terms of counter flips (or batches) rather
 	than in terms of grace periods.  The legal number of non-zero
-	entries is again two.  The reason for this separate view is
-	that it is easier to get the third entry to show up in the
+	entries is again two.  The reason for this separate view is that
+	it is sometimes easier to get the third entry to show up in the
 	"Reader Batch" list than in the "Reader Pipe" list.
 
 o	"Free-Block Circulation": Shows the number of torture structures
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
