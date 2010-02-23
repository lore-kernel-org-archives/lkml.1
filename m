Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab0BWBHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:07:10 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43217 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873Ab0BWBFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:05:18 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 13/21] rcu: documentation update for CONFIG_PROVE_RCU
Date: Mon, 22 Feb 2010 17:04:57 -0800
Message-Id: <1266887105-1528-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100223010435.GA666@linux.vnet.ibm.com>
References: <20100223010435.GA666@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a lockdep.txt file and updates checklist.txt and whatisRCU.txt
to reflect the new lockdep-enabled capabilities of RCU.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/00-INDEX      |    2 +
 Documentation/RCU/checklist.txt |   34 +++++++++++--------
 Documentation/RCU/lockdep.txt   |   67 +++++++++++++++++++++++++++++++++++++++
 Documentation/RCU/whatisRCU.txt |   13 +++++---
 4 files changed, 97 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/RCU/lockdep.txt

diff --git a/Documentation/RCU/00-INDEX b/Documentation/RCU/00-INDEX
index 0a27ea9..71b6f50 100644
--- a/Documentation/RCU/00-INDEX
+++ b/Documentation/RCU/00-INDEX
@@ -6,6 +6,8 @@ checklist.txt
 	- Review Checklist for RCU Patches
 listRCU.txt
 	- Using RCU to Protect Read-Mostly Linked Lists
+lockdep.txt
+	- RCU and lockdep checking
 NMI-RCU.txt
 	- Using RCU to Protect Dynamic NMI Handlers
 rcubarrier.txt
diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index 767cf06..cbc180f 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -127,10 +127,14 @@ over a rather long period of time, but improvements are always welcome!
 		perfectly legal (if redundant) for update-side code to
 		use rcu_dereference() and the "_rcu()" list-traversal
 		primitives.  This is particularly useful in code that
-		is common to readers and updaters.  However, neither
-		rcu_dereference() nor the "_rcu()" list-traversal
-		primitives can substitute for a good concurrency design
-		coordinating among multiple updaters.
+		is common to readers and updaters.  However, lockdep
+		will complain if you access rcu_dereference() outside
+		of an RCU read-side critical section.  See lockdep.txt
+		to learn what to do about this.
+
+		Of course, neither rcu_dereference() nor the "_rcu()"
+		list-traversal primitives can substitute for a good
+		concurrency design coordinating among multiple updaters.
 
 	b.	If the list macros are being used, the list_add_tail_rcu()
 		and list_add_rcu() primitives must be used in order
@@ -249,7 +253,9 @@ over a rather long period of time, but improvements are always welcome!
 	must be protected by appropriate update-side locks.  RCU
 	read-side critical sections are delimited by rcu_read_lock()
 	and rcu_read_unlock(), or by similar primitives such as
-	rcu_read_lock_bh() and rcu_read_unlock_bh().
+	rcu_read_lock_bh() and rcu_read_unlock_bh(), in which case
+	the matching rcu_dereference() primitive must be used in order
+	to keep lockdep happy, in this case, rcu_dereference_bh().
 
 	The reason that it is permissible to use RCU list-traversal
 	primitives when the update-side lock is held is that doing so
@@ -302,15 +308,15 @@ over a rather long period of time, but improvements are always welcome!
 	not the case, a self-spawning RCU callback would prevent the
 	victim CPU from ever going offline.)
 
-14.	SRCU (srcu_read_lock(), srcu_read_unlock(), synchronize_srcu(),
-	and synchronize_srcu_expedited()) may only be invoked from
-	process context.  Unlike other forms of RCU, it -is- permissible
-	to block in an SRCU read-side critical section (demarked by
-	srcu_read_lock() and srcu_read_unlock()), hence the "SRCU":
-	"sleepable RCU".  Please note that if you don't need to sleep
-	in read-side critical sections, you should be using RCU rather
-	than SRCU, because RCU is almost always faster and easier to
-	use than is SRCU.
+14.	SRCU (srcu_read_lock(), srcu_read_unlock(), srcu_dereference(),
+	synchronize_srcu(), and synchronize_srcu_expedited()) may only
+	be invoked from process context.  Unlike other forms of RCU, it
+	-is- permissible to block in an SRCU read-side critical section
+	(demarked by srcu_read_lock() and srcu_read_unlock()), hence the
+	"SRCU": "sleepable RCU".  Please note that if you don't need
+	to sleep in read-side critical sections, you should be using
+	RCU rather than SRCU, because RCU is almost always faster and
+	easier to use than is SRCU.
 
 	Also unlike other forms of RCU, explicit initialization
 	and cleanup is required via init_srcu_struct() and
diff --git a/Documentation/RCU/lockdep.txt b/Documentation/RCU/lockdep.txt
new file mode 100644
index 0000000..fe24b58
--- /dev/null
+++ b/Documentation/RCU/lockdep.txt
@@ -0,0 +1,67 @@
+RCU and lockdep checking
+
+All flavors of RCU have lockdep checking available, so that lockdep is
+aware of when each task enters and leaves any flavor of RCU read-side
+critical section.  Each flavor of RCU is tracked separately (but note
+that this is not the case in 2.6.32 and earlier).  This allows lockdep's
+tracking to include RCU state, which can sometimes help when debugging
+deadlocks and the like.
+
+In addition, RCU provides the following primitives that check lockdep's
+state:
+
+	rcu_read_lock_held() for normal RCU.
+	rcu_read_lock_bh_held() for RCU-bh.
+	rcu_read_lock_sched_held() for RCU-sched.
+	srcu_read_lock_held() for SRCU.
+
+These functions are conservative, and will therefore return 1 if they
+aren't certain (for example, if CONFIG_DEBUG_LOCK_ALLOC is not set).
+This prevents things like WARN_ON(!rcu_read_lock_held()) from giving false
+positives when lockdep is disabled.
+
+In addition, a separate kernel config parameter CONFIG_PROVE_RCU enables
+checking of rcu_dereference() primitives:
+
+	rcu_dereference(p):
+		Check for RCU read-side critical section.
+	rcu_dereference_bh(p):
+		Check for RCU-bh read-side critical section.
+	rcu_dereference_sched(p):
+		Check for RCU-sched read-side critical section.
+	srcu_dereference(p, sp):
+		Check for SRCU read-side critical section.
+	rcu_dereference_check(p, c):
+		Use explicit check expression "c".
+	rcu_dereference_raw(p)
+		Don't check.  (Use sparingly, if at all.)
+
+The rcu_dereference_check() check expression can be any boolean
+expression, but would normally include one of the rcu_read_lock_held()
+family of functions and a lockdep expression.  However, any boolean
+expression can be used.  For a moderately ornate example, consider
+the following:
+
+	file = rcu_dereference_check(fdt->fd[fd],
+				     rcu_read_lock_held() ||
+				     lockdep_is_held(&files->file_lock) ||
+				     atomic_read(&files->count) == 1);
+
+This expression picks up the pointer "fdt->fd[fd]" in an RCU-safe manner,
+and, if CONFIG_PROVE_RCU is configured, verifies that this expression
+is used in:
+
+1.	An RCU read-side critical section, or
+2.	with files->file_lock held, or
+3.	on an unshared files_struct.
+
+In case (1), the pointer is picked up in an RCU-safe manner for vanilla
+RCU read-side critical sections, in case (2) the ->file_lock prevents
+any change from taking place, and finally, in case (3) the current task
+is the only task accessing the file_struct, again preventing any change
+from taking place.
+
+There are currently only "universal" versions of the rcu_assign_pointer()
+and RCU list-/tree-traversal primitives, which do not (yet) check for
+being in an RCU read-side critical section.  In the future, separate
+versions of these primitives might be created.
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index 469a58b..1dc00ee 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -323,15 +323,17 @@ used as follows:
 	Defer			Protect
 
 a.	synchronize_rcu()	rcu_read_lock() / rcu_read_unlock()
-	call_rcu()
+	call_rcu()		rcu_dereference()
 
 b.	call_rcu_bh()		rcu_read_lock_bh() / rcu_read_unlock_bh()
+				rcu_dereference_bh()
 
 c.	synchronize_sched()	rcu_read_lock_sched() / rcu_read_unlock_sched()
 				preempt_disable() / preempt_enable()
 				local_irq_save() / local_irq_restore()
 				hardirq enter / hardirq exit
 				NMI enter / NMI exit
+				rcu_dereference_sched()
 
 These three mechanisms are used as follows:
 
@@ -781,9 +783,8 @@ Linux-kernel source code, but it helps to have a full list of the
 APIs, since there does not appear to be a way to categorize them
 in docbook.  Here is the list, by category.
 
-RCU pointer/list traversal:
+RCU list traversal:
 
-	rcu_dereference
 	list_for_each_entry_rcu
 	hlist_for_each_entry_rcu
 	hlist_nulls_for_each_entry_rcu
@@ -809,7 +810,7 @@ RCU:	Critical sections	Grace period		Barrier
 
 	rcu_read_lock		synchronize_net		rcu_barrier
 	rcu_read_unlock		synchronize_rcu
-				synchronize_rcu_expedited
+	rcu_dereference		synchronize_rcu_expedited
 				call_rcu
 
 
@@ -817,7 +818,7 @@ bh:	Critical sections	Grace period		Barrier
 
 	rcu_read_lock_bh	call_rcu_bh		rcu_barrier_bh
 	rcu_read_unlock_bh	synchronize_rcu_bh
-				synchronize_rcu_bh_expedited
+	rcu_dereference_bh	synchronize_rcu_bh_expedited
 
 
 sched:	Critical sections	Grace period		Barrier
@@ -826,12 +827,14 @@ sched:	Critical sections	Grace period		Barrier
 	rcu_read_unlock_sched	call_rcu_sched
 	[preempt_disable]	synchronize_sched_expedited
 	[and friends]
+	rcu_dereference_sched
 
 
 SRCU:	Critical sections	Grace period		Barrier
 
 	srcu_read_lock		synchronize_srcu	N/A
 	srcu_read_unlock	synchronize_srcu_expedited
+	srcu_dereference
 
 SRCU:	Initialization/cleanup
 	init_srcu_struct
-- 
1.6.6

