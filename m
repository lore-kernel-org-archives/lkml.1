Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab0AOALh (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 19:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757822Ab0AOALf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 19:11:35 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47964 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757811Ab0AOALb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 19:11:31 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/2] rcu: 1Q2010 update for RCU documentation
Date: Thu, 14 Jan 2010 16:10:57 -0800
Message-Id: <12635142581866-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20100115001021.GA25878@linux.vnet.ibm.com>
References: <20100115001021.GA25878@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add expedited functions.  Review documentation and update obsolete
verbiage.  Also fix the advice for the RCU CPU-stall kernel configuration
parameter, and document RCU CPU-stall warnings.
---
 Documentation/RCU/00-INDEX                   |    8 +-
 Documentation/RCU/RTFP.txt                   |   58 +++++++-
 Documentation/RCU/checklist.txt              |  200 +++++++++++++++-----------
 Documentation/RCU/rcu.txt                    |   48 +------
 Documentation/RCU/stallwarn.txt              |   58 ++++++++
 Documentation/RCU/torture.txt                |   12 ++
 Documentation/RCU/whatisRCU.txt              |    3 +-
 Documentation/filesystems/dentry-locking.txt |    3 +-
 lib/Kconfig.debug                            |    4 +-
 9 files changed, 258 insertions(+), 136 deletions(-)
 create mode 100644 Documentation/RCU/stallwarn.txt

diff --git a/Documentation/RCU/00-INDEX b/Documentation/RCU/00-INDEX
index 9bb62f7..0a27ea9 100644
--- a/Documentation/RCU/00-INDEX
+++ b/Documentation/RCU/00-INDEX
@@ -8,14 +8,18 @@ listRCU.txt
 	- Using RCU to Protect Read-Mostly Linked Lists
 NMI-RCU.txt
 	- Using RCU to Protect Dynamic NMI Handlers
+rcubarrier.txt
+	- RCU and Unloadable Modules
+rculist_nulls.txt
+	- RCU list primitives for use with SLAB_DESTROY_BY_RCU
 rcuref.txt
 	- Reference-count design for elements of lists/arrays protected by RCU
 rcu.txt
 	- RCU Concepts
-rcubarrier.txt
-	- Unloading modules that use RCU callbacks
 RTFP.txt
 	- List of RCU papers (bibliography) going back to 1980.
+stallwarn.txt
+	- RCU CPU stall warnings (CONFIG_RCU_CPU_STALL_DETECTOR)
 torture.txt
 	- RCU Torture Test Operation (CONFIG_RCU_TORTURE_TEST)
 trace.txt
diff --git a/Documentation/RCU/RTFP.txt b/Documentation/RCU/RTFP.txt
index d2b8523..5051209 100644
--- a/Documentation/RCU/RTFP.txt
+++ b/Documentation/RCU/RTFP.txt
@@ -25,10 +25,10 @@ to be referencing the data structure.  However, this mechanism was not
 optimized for modern computer systems, which is not surprising given
 that these overheads were not so expensive in the mid-80s.  Nonetheless,
 passive serialization appears to be the first deferred-destruction
-mechanism to be used in production.  Furthermore, the relevant patent has
-lapsed, so this approach may be used in non-GPL software, if desired.
-(In contrast, use of RCU is permitted only in software licensed under
-GPL.  Sorry!!!)
+mechanism to be used in production.  Furthermore, the relevant patent
+has lapsed, so this approach may be used in non-GPL software, if desired.
+(In contrast, implementation of RCU is permitted only in software licensed
+under either GPL or LGPL.  Sorry!!!)
 
 In 1990, Pugh [Pugh90] noted that explicitly tracking which threads
 were reading a given data structure permitted deferred free to operate
@@ -150,6 +150,18 @@ preemptible RCU [PaulEMcKenney2007PreemptibleRCU], and the three-part
 LWN "What is RCU?" series [PaulEMcKenney2007WhatIsRCUFundamentally,
 PaulEMcKenney2008WhatIsRCUUsage, and PaulEMcKenney2008WhatIsRCUAPI].
 
+2008 saw a journal paper on real-time RCU [DinakarGuniguntala2008IBMSysJ],
+a history of how Linux changed RCU more than RCU changed Linux
+[PaulEMcKenney2008RCUOSR], and a design overview of hierarchical RCU
+[PaulEMcKenney2008HierarchicalRCU].
+
+2009 introduced user-level RCU algorithms [PaulEMcKenney2009MaliciousURCU],
+which Mathieu Desnoyers is now maintaining [MathieuDesnoyers2009URCU]
+[MathieuDesnoyersPhD].  TINY_RCU [PaulEMcKenney2009BloatWatchRCU] made
+its appearance, as did expedited RCU [PaulEMcKenney2009expeditedRCU].
+The problem of resizeable RCU-protected hash tables may now be on a path
+to a solution [JoshTriplett2009RPHash].
+
 Bibtex Entries
 
 @article{Kung80
@@ -730,6 +742,11 @@ Revised:
 "
 }
 
+#
+#	"What is RCU?" LWN series.
+#
+########################################################################
+
 @article{DinakarGuniguntala2008IBMSysJ
 ,author="D. Guniguntala and P. E. McKenney and J. Triplett and J. Walpole"
 ,title="The read-copy-update mechanism for supporting real-time applications on shared-memory multiprocessor systems with {Linux}"
@@ -820,3 +837,36 @@ Revised:
 	Uniprocessor assumptions allow simplified RCU implementation.
 "
 }
+
+@unpublished{PaulEMcKenney2009expeditedRCU
+,Author="Paul E. McKenney"
+,Title="[{PATCH} -tip 0/3] expedited 'big hammer' {RCU} grace periods"
+,month="June"
+,day="25"
+,year="2009"
+,note="Available:
+\url{http://lkml.org/lkml/2009/6/25/306}
+[Viewed August 16, 2009]"
+,annotation="
+	First posting of expedited RCU to be accepted into -tip.
+"
+}
+
+@unpublished{JoshTriplett2009RPHash
+,Author="Josh Triplett"
+,Title="Scalable concurrent hash tables via relativistic programming"
+,month="September"
+,year="2009"
+,note="Linux Plumbers Conference presentation"
+,annotation="
+	RP fun with hash tables.
+"
+}
+
+@phdthesis{MathieuDesnoyersPhD
+, title  = "Low-impact Operating System Tracing"
+, author = "Mathieu Desnoyers"
+, school = "Ecole Polytechnique de Montr\'{e}al"
+, month  = "December"
+, year   = 2009
+}
diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index 51525a3..767cf06 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -8,13 +8,12 @@ would cause.  This list is based on experiences reviewing such patches
 over a rather long period of time, but improvements are always welcome!
 
 0.	Is RCU being applied to a read-mostly situation?  If the data
-	structure is updated more than about 10% of the time, then
-	you should strongly consider some other approach, unless
-	detailed performance measurements show that RCU is nonetheless
-	the right tool for the job.  Yes, you might think of RCU
-	as simply cutting overhead off of the readers and imposing it
-	on the writers.  That is exactly why normal uses of RCU will
-	do much more reading than updating.
+	structure is updated more than about 10% of the time, then you
+	should strongly consider some other approach, unless detailed
+	performance measurements show that RCU is nonetheless the right
+	tool for the job.  Yes, RCU does reduce read-side overhead by
+	increasing write-side overhead, which is exactly why normal uses
+	of RCU will do much more reading than updating.
 
 	Another exception is where performance is not an issue, and RCU
 	provides a simpler implementation.  An example of this situation
@@ -35,13 +34,13 @@ over a rather long period of time, but improvements are always welcome!
 
 	If you choose #b, be prepared to describe how you have handled
 	memory barriers on weakly ordered machines (pretty much all of
-	them -- even x86 allows reads to be reordered), and be prepared
-	to explain why this added complexity is worthwhile.  If you
-	choose #c, be prepared to explain how this single task does not
-	become a major bottleneck on big multiprocessor machines (for
-	example, if the task is updating information relating to itself
-	that other tasks can read, there by definition can be no
-	bottleneck).
+	them -- even x86 allows later loads to be reordered to precede
+	earlier stores), and be prepared to explain why this added
+	complexity is worthwhile.  If you choose #c, be prepared to
+	explain how this single task does not become a major bottleneck on
+	big multiprocessor machines (for example, if the task is updating
+	information relating to itself that other tasks can read, there
+	by definition can be no bottleneck).
 
 2.	Do the RCU read-side critical sections make proper use of
 	rcu_read_lock() and friends?  These primitives are needed
@@ -51,8 +50,10 @@ over a rather long period of time, but improvements are always welcome!
 	actuarial risk of your kernel.
 
 	As a rough rule of thumb, any dereference of an RCU-protected
-	pointer must be covered by rcu_read_lock() or rcu_read_lock_bh()
-	or by the appropriate update-side lock.
+	pointer must be covered by rcu_read_lock(), rcu_read_lock_bh(),
+	rcu_read_lock_sched(), or by the appropriate update-side lock.
+	Disabling of preemption can serve as rcu_read_lock_sched(), but
+	is less readable.
 
 3.	Does the update code tolerate concurrent accesses?
 
@@ -62,25 +63,27 @@ over a rather long period of time, but improvements are always welcome!
 	of ways to handle this concurrency, depending on the situation:
 
 	a.	Use the RCU variants of the list and hlist update
-		primitives to add, remove, and replace elements on an
-		RCU-protected list.  Alternatively, use the RCU-protected
-		trees that have been added to the Linux kernel.
+		primitives to add, remove, and replace elements on
+		an RCU-protected list.	Alternatively, use the other
+		RCU-protected data structures that have been added to
+		the Linux kernel.
 
 		This is almost always the best approach.
 
 	b.	Proceed as in (a) above, but also maintain per-element
 		locks (that are acquired by both readers and writers)
 		that guard per-element state.  Of course, fields that
-		the readers refrain from accessing can be guarded by the
-		update-side lock.
+		the readers refrain from accessing can be guarded by
+		some other lock acquired only by updaters, if desired.
 
 		This works quite well, also.
 
 	c.	Make updates appear atomic to readers.  For example,
-		pointer updates to properly aligned fields will appear
-		atomic, as will individual atomic primitives.  Operations
-		performed under a lock and sequences of multiple atomic
-		primitives will -not- appear to be atomic.
+		pointer updates to properly aligned fields will
+		appear atomic, as will individual atomic primitives.
+		Sequences of perations performed under a lock will -not-
+		appear to be atomic to RCU readers, nor will sequences
+		of multiple atomic primitives.
 
 		This can work, but is starting to get a bit tricky.
 
@@ -98,9 +101,9 @@ over a rather long period of time, but improvements are always welcome!
 		a new structure containing updated values.
 
 4.	Weakly ordered CPUs pose special challenges.  Almost all CPUs
-	are weakly ordered -- even i386 CPUs allow reads to be reordered.
-	RCU code must take all of the following measures to prevent
-	memory-corruption problems:
+	are weakly ordered -- even x86 CPUs allow later loads to be
+	reordered to precede earlier stores.  RCU code must take all of
+	the following measures to prevent memory-corruption problems:
 
 	a.	Readers must maintain proper ordering of their memory
 		accesses.  The rcu_dereference() primitive ensures that
@@ -113,14 +116,21 @@ over a rather long period of time, but improvements are always welcome!
 		The rcu_dereference() primitive is also an excellent
 		documentation aid, letting the person reading the code
 		know exactly which pointers are protected by RCU.
-
-		The rcu_dereference() primitive is used by the various
-		"_rcu()" list-traversal primitives, such as the
-		list_for_each_entry_rcu().  Note that it is perfectly
-		legal (if redundant) for update-side code to use
-		rcu_dereference() and the "_rcu()" list-traversal
-		primitives.  This is particularly useful in code
-		that is common to readers and updaters.
+		Please note that compilers can also reorder code, and
+		they are becoming increasingly aggressive about doing
+		just that.  The rcu_dereference() primitive therefore
+		also prevents destructive compiler optimizations.
+
+		The rcu_dereference() primitive is used by the
+		various "_rcu()" list-traversal primitives, such
+		as the list_for_each_entry_rcu().  Note that it is
+		perfectly legal (if redundant) for update-side code to
+		use rcu_dereference() and the "_rcu()" list-traversal
+		primitives.  This is particularly useful in code that
+		is common to readers and updaters.  However, neither
+		rcu_dereference() nor the "_rcu()" list-traversal
+		primitives can substitute for a good concurrency design
+		coordinating among multiple updaters.
 
 	b.	If the list macros are being used, the list_add_tail_rcu()
 		and list_add_rcu() primitives must be used in order
@@ -135,11 +145,14 @@ over a rather long period of time, but improvements are always welcome!
 		readers.  Similarly, if the hlist macros are being used,
 		the hlist_del_rcu() primitive is required.
 
-		The list_replace_rcu() primitive may be used to
-		replace an old structure with a new one in an
-		RCU-protected list.
+		The list_replace_rcu() and hlist_replace_rcu() primitives
+		may be used to replace an old structure with a new one
+		in their respective types of RCU-protected lists.
+
+	d.	Rules similar to (4b) and (4c) apply to the "hlist_nulls"
+		type of RCU-protected linked lists.
 
-	d.	Updates must ensure that initialization of a given
+	e.	Updates must ensure that initialization of a given
 		structure happens before pointers to that structure are
 		publicized.  Use the rcu_assign_pointer() primitive
 		when publicizing a pointer to a structure that can
@@ -151,16 +164,31 @@ over a rather long period of time, but improvements are always welcome!
 	it cannot block.
 
 6.	Since synchronize_rcu() can block, it cannot be called from
-	any sort of irq context.  Ditto for synchronize_sched() and
-	synchronize_srcu().
-
-7.	If the updater uses call_rcu(), then the corresponding readers
-	must use rcu_read_lock() and rcu_read_unlock().  If the updater
-	uses call_rcu_bh(), then the corresponding readers must use
-	rcu_read_lock_bh() and rcu_read_unlock_bh().  If the updater
-	uses call_rcu_sched(), then the corresponding readers must
-	disable preemption.  Mixing things up will result in confusion
-	and broken kernels.
+	any sort of irq context.  The same rule applies for
+	synchronize_rcu_bh(), synchronize_sched(), synchronize_srcu(),
+	synchronize_rcu_expedited(), synchronize_rcu_bh_expedited(),
+	synchronize_sched_expedite(), and synchronize_srcu_expedited().
+
+	The expedited forms of these primitives have the same semantics
+	as the non-expedited forms, but expediting is both expensive
+	and unfriendly to real-time workloads.	Use of the expedited
+	primitives should be restricted to rare configuration-change
+	operations that would not normally be undertaken while a real-time
+	workload is running.
+
+7.	If the updater uses call_rcu() or synchronize_rcu(), then the
+	corresponding readers must use rcu_read_lock() and
+	rcu_read_unlock().  If the updater uses call_rcu_bh() or
+	synchronize_rcu_bh(), then the corresponding readers must
+	use rcu_read_lock_bh() and rcu_read_unlock_bh().  If the
+	updater uses call_rcu_sched() or synchronize_sched(), then
+	the corresponding readers must disable preemption, possibly
+	by calling rcu_read_lock_sched() and rcu_read_unlock_sched().
+	If the updater uses synchronize_srcu(), the the corresponding
+	readers must use srcu_read_lock() and srcu_read_unlock(),
+	and with the same srcu_struct.	The rules for the expedited
+	primitives are the same as for their non-expedited counterparts.
+	Mixing things up will result in confusion and broken kernels.
 
 	One exception to this rule: rcu_read_lock() and rcu_read_unlock()
 	may be substituted for rcu_read_lock_bh() and rcu_read_unlock_bh()
@@ -212,6 +240,8 @@ over a rather long period of time, but improvements are always welcome!
 	e.	Periodically invoke synchronize_rcu(), permitting a limited
 		number of updates per grace period.
 
+	The same cautions apply to call_rcu_bh() and call_rcu_sched().
+
 9.	All RCU list-traversal primitives, which include
 	rcu_dereference(), list_for_each_entry_rcu(),
 	list_for_each_continue_rcu(), and list_for_each_safe_rcu(),
@@ -229,7 +259,8 @@ over a rather long period of time, but improvements are always welcome!
 10.	Conversely, if you are in an RCU read-side critical section,
 	and you don't hold the appropriate update-side lock, you -must-
 	use the "_rcu()" variants of the list macros.  Failing to do so
-	will break Alpha and confuse people reading your code.
+	will break Alpha, cause aggressive compilers to generate bad code,
+	and confuse people trying to read your code.
 
 11.	Note that synchronize_rcu() -only- guarantees to wait until
 	all currently executing rcu_read_lock()-protected RCU read-side
@@ -239,15 +270,21 @@ over a rather long period of time, but improvements are always welcome!
 	rcu_read_lock()-protected read-side critical sections, do -not-
 	use synchronize_rcu().
 
-	If you want to wait for some of these other things, you might
-	instead need to use synchronize_irq() or synchronize_sched().
+	Similarly, disabling preemption is not an acceptable substitute
+	for rcu_read_lock().  Code that attempts to use preemption
+	disabling where it should be using rcu_read_lock() will break
+	in real-time kernel builds.
+
+	If you want to wait for interrupt handlers, NMI handlers, and
+	code under the influence of preempt_disable(), you instead
+	need to use synchronize_irq() or synchronize_sched().
 
 12.	Any lock acquired by an RCU callback must be acquired elsewhere
 	with softirq disabled, e.g., via spin_lock_irqsave(),
 	spin_lock_bh(), etc.  Failing to disable irq on a given
-	acquisition of that lock will result in deadlock as soon as the
-	RCU callback happens to interrupt that acquisition's critical
-	section.
+	acquisition of that lock will result in deadlock as soon as
+	the RCU softirq handler happens to run your RCU callback while
+	interrupting that acquisition's critical section.
 
 13.	RCU callbacks can be and are executed in parallel.  In many cases,
 	the callback code simply wrappers around kfree(), so that this
@@ -265,29 +302,30 @@ over a rather long period of time, but improvements are always welcome!
 	not the case, a self-spawning RCU callback would prevent the
 	victim CPU from ever going offline.)
 
-14.	SRCU (srcu_read_lock(), srcu_read_unlock(), and synchronize_srcu())
-	may only be invoked from process context.  Unlike other forms of
-	RCU, it -is- permissible to block in an SRCU read-side critical
-	section (demarked by srcu_read_lock() and srcu_read_unlock()),
-	hence the "SRCU": "sleepable RCU".  Please note that if you
-	don't need to sleep in read-side critical sections, you should
-	be using RCU rather than SRCU, because RCU is almost always
-	faster and easier to use than is SRCU.
+14.	SRCU (srcu_read_lock(), srcu_read_unlock(), synchronize_srcu(),
+	and synchronize_srcu_expedited()) may only be invoked from
+	process context.  Unlike other forms of RCU, it -is- permissible
+	to block in an SRCU read-side critical section (demarked by
+	srcu_read_lock() and srcu_read_unlock()), hence the "SRCU":
+	"sleepable RCU".  Please note that if you don't need to sleep
+	in read-side critical sections, you should be using RCU rather
+	than SRCU, because RCU is almost always faster and easier to
+	use than is SRCU.
 
 	Also unlike other forms of RCU, explicit initialization
 	and cleanup is required via init_srcu_struct() and
 	cleanup_srcu_struct().	These are passed a "struct srcu_struct"
 	that defines the scope of a given SRCU domain.	Once initialized,
 	the srcu_struct is passed to srcu_read_lock(), srcu_read_unlock()
-	and synchronize_srcu().  A given synchronize_srcu() waits only
-	for SRCU read-side critical sections governed by srcu_read_lock()
-	and srcu_read_unlock() calls that have been passd the same
-	srcu_struct.  This property is what makes sleeping read-side
-	critical sections tolerable -- a given subsystem delays only
-	its own updates, not those of other subsystems using SRCU.
-	Therefore, SRCU is less prone to OOM the system than RCU would
-	be if RCU's read-side critical sections were permitted to
-	sleep.
+	synchronize_srcu(), and synchronize_srcu_expedited().  A given
+	synchronize_srcu() waits only for SRCU read-side critical
+	sections governed by srcu_read_lock() and srcu_read_unlock()
+	calls that have been passed the same srcu_struct.  This property
+	is what makes sleeping read-side critical sections tolerable --
+	a given subsystem delays only its own updates, not those of other
+	subsystems using SRCU.	Therefore, SRCU is less prone to OOM the
+	system than RCU would be if RCU's read-side critical sections
+	were permitted to sleep.
 
 	The ability to sleep in read-side critical sections does not
 	come for free.	First, corresponding srcu_read_lock() and
@@ -311,12 +349,12 @@ over a rather long period of time, but improvements are always welcome!
 	destructive operation, and -only- -then- invoke call_rcu(),
 	synchronize_rcu(), or friends.
 
-	Because these primitives only wait for pre-existing readers,
-	it is the caller's responsibility to guarantee safety to
-	any subsequent readers.
+	Because these primitives only wait for pre-existing readers, it
+	is the caller's responsibility to guarantee that any subsequent
+	readers will execute safely.
 
-16.	The various RCU read-side primitives do -not- contain memory
-	barriers.  The CPU (and in some cases, the compiler) is free
-	to reorder code into and out of RCU read-side critical sections.
-	It is the responsibility of the RCU update-side primitives to
-	deal with this.
+16.	The various RCU read-side primitives do -not- necessarily contain
+	memory barriers.  You should therefore plan for the CPU
+	and the compiler to freely reorder code into and out of RCU
+	read-side critical sections.  It is the responsibility of the
+	RCU update-side primitives to deal with this.
diff --git a/Documentation/RCU/rcu.txt b/Documentation/RCU/rcu.txt
index 2a23523..3185270 100644
--- a/Documentation/RCU/rcu.txt
+++ b/Documentation/RCU/rcu.txt
@@ -75,6 +75,8 @@ o	I hear that RCU is patented?  What is with that?
 	search for the string "Patent" in RTFP.txt to find them.
 	Of these, one was allowed to lapse by the assignee, and the
 	others have been contributed to the Linux kernel under GPL.
+	There are now also LGPL implementations of user-level RCU
+	available (http://lttng.org/?q=node/18).
 
 o	I hear that RCU needs work in order to support realtime kernels?
 
@@ -91,48 +93,4 @@ o	Where can I find more information on RCU?
 
 o	What are all these files in this directory?
 
-
-	NMI-RCU.txt
-
-		Describes how to use RCU to implement dynamic
-		NMI handlers, which can be revectored on the fly,
-		without rebooting.
-
-	RTFP.txt
-
-		List of RCU-related publications and web sites.
-
-	UP.txt
-
-		Discussion of RCU usage in UP kernels.
-
-	arrayRCU.txt
-
-		Describes how to use RCU to protect arrays, with
-		resizeable arrays whose elements reference other
-		data structures being of the most interest.
-
-	checklist.txt
-
-		Lists things to check for when inspecting code that
-		uses RCU.
-
-	listRCU.txt
-
-		Describes how to use RCU to protect linked lists.
-		This is the simplest and most common use of RCU
-		in the Linux kernel.
-
-	rcu.txt
-
-		You are reading it!
-
-	rcuref.txt
-
-		Describes how to combine use of reference counts
-		with RCU.
-
-	whatisRCU.txt
-
-		Overview of how the RCU implementation works.  Along
-		the way, presents a conceptual view of RCU.
+	See 00-INDEX for the list.
diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
new file mode 100644
index 0000000..1423d25
--- /dev/null
+++ b/Documentation/RCU/stallwarn.txt
@@ -0,0 +1,58 @@
+Using RCU's CPU Stall Detector
+
+The CONFIG_RCU_CPU_STALL_DETECTOR kernel config parameter enables
+RCU's CPU stall detector, which detects conditions that unduly delay
+RCU grace periods.  The stall detector's idea of what constitutes
+"unduly delayed" is controlled by a pair of C preprocessor macros:
+
+RCU_SECONDS_TILL_STALL_CHECK
+
+	This macro defines the period of time that RCU will wait from
+	the beginning of a grace period until it issues an RCU CPU
+	stall warning.	It is normally ten seconds.
+
+RCU_SECONDS_TILL_STALL_RECHECK
+
+	This macro defines the period of time that RCU will wait after
+	issuing a stall warning until it issues another stall warning.
+	It is normally set to thirty seconds.
+
+RCU_STALL_RAT_DELAY
+
+	The CPU stall detector tries to make the offending CPU rat on itself,
+	as this often gives better-quality stack traces.  However, if
+	the offending CPU does not detect its own stall in the number
+	of jiffies specified by RCU_STALL_RAT_DELAY, then other CPUs will
+	complain.  This is normally set to two jiffies.
+
+The following problems can result in an RCU CPU stall warning:
+
+o	A CPU looping in an RCU read-side critical section.
+	
+o	A CPU looping with interrupts disabled.
+
+o	A CPU looping with preemption disabled.
+
+o	For !CONFIG_PREEMPT kernels, a CPU looping anywhere in the kernel
+	without invoking schedule().
+
+o	A bug in the RCU implementation.
+
+o	A hardware failure.  This is quite unlikely, but has occurred
+	at least once in a former life.  A CPU failed in a running system,
+	becoming unresponsive, but not causing an immediate crash.
+	This resulted in a series of RCU CPU stall warnings, eventually
+	leading the realization that the CPU had failed.
+
+The RCU, RCU-sched, and RCU-bh implementations have CPU stall warning.
+SRCU does not do so directly, but its calls to synchronize_sched() will
+result in RCU-sched detecting any CPU stalls that might be occurring.
+
+To diagnose the cause of the stall, inspect the stack traces.  The offending
+function will usually be near the top of the stack.  If you have a series
+of stall warnings from a single extended stall, comparing the stack traces
+can often help determine where the stall is occurring, which will usually
+be in the function nearest the top of the stack that stays the same from
+trace to trace.
+
+RCU bugs can often be debugged with the help of CONFIG_RCU_TRACE.
diff --git a/Documentation/RCU/torture.txt b/Documentation/RCU/torture.txt
index 9dba3bb..0e50bc2 100644
--- a/Documentation/RCU/torture.txt
+++ b/Documentation/RCU/torture.txt
@@ -30,6 +30,18 @@ MODULE PARAMETERS
 
 This module has the following parameters:
 
+fqs_duration	Duration (in microseconds) of artificially induced bursts
+		of force_quiescent_state() invocations.  In RCU
+		implementations having force_quiescent_state(), these
+		bursts help force races between forcing a given grace
+		period and that grace period ending on its own.
+
+fqs_holdoff	Holdoff time (in microseconds) between consecutive calls
+		to force_quiescent_state() within a burst.
+
+fqs_stutter	Wait time (in seconds) between consecutive bursts
+		of calls to force_quiescent_state().
+
 irqreaders	Says to invoke RCU readers from irq level.  This is currently
 		done via timers.  Defaults to "1" for variants of RCU that
 		permit this.  (Or, more accurately, variants of RCU that do
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index d542ca2..469a58b 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -327,7 +327,8 @@ a.	synchronize_rcu()	rcu_read_lock() / rcu_read_unlock()
 
 b.	call_rcu_bh()		rcu_read_lock_bh() / rcu_read_unlock_bh()
 
-c.	synchronize_sched()	preempt_disable() / preempt_enable()
+c.	synchronize_sched()	rcu_read_lock_sched() / rcu_read_unlock_sched()
+				preempt_disable() / preempt_enable()
 				local_irq_save() / local_irq_restore()
 				hardirq enter / hardirq exit
 				NMI enter / NMI exit
diff --git a/Documentation/filesystems/dentry-locking.txt b/Documentation/filesystems/dentry-locking.txt
index 4c0c575..79334ed 100644
--- a/Documentation/filesystems/dentry-locking.txt
+++ b/Documentation/filesystems/dentry-locking.txt
@@ -62,7 +62,8 @@ changes are :
 2. Insertion of a dentry into the hash table is done using
    hlist_add_head_rcu() which take care of ordering the writes - the
    writes to the dentry must be visible before the dentry is
-   inserted. This works in conjunction with hlist_for_each_rcu() while
+   inserted. This works in conjunction with hlist_for_each_rcu(),
+   which has since been replaced by hlist_for_each_entry_rcu(), while
    walking the hash chain. The only requirement is that all
    initialization to the dentry must be done before
    hlist_add_head_rcu() since we don't have dcache_lock protection
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 25c3ed5..6bf97d1 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -765,9 +765,9 @@ config RCU_CPU_STALL_DETECTOR
 	  CPUs are delaying the current grace period, but only when
 	  the grace period extends for excessive time periods.
 
-	  Say Y if you want RCU to perform such checks.
+	  Say N if you want to disable such checks.
 
-	  Say N if you are unsure.
+	  Say Y if you are unsure.
 
 config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
-- 
1.5.2.5

