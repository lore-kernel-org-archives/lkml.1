Return-Path: <linux-kernel-owner+w=401wt.eu-S1760373AbZFJWV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760373AbZFJWV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 18:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755769AbZFJWVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 18:21:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47363 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343AbZFJWVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 18:21:49 -0400
Date: Thu, 11 Jun 2009 00:21:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU updates for v2.6.31
Message-ID: <20090610222138.GA837@elte.hu>
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

Linus,

Please pull the latest rcu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rcu-for-linus

The first commit is the first step in the planned removal of 
Classic-RCU and merging Preempt-RCU into Tree-RCU: make Tree-RCU the 
default.

 Thanks,

	Ingo

------------------>
Jiri Pirko (2):
      rculist.h: introduce list_entry_rcu() and list_first_entry_rcu()
      rculist: use list_entry_rcu in places where it's appropriate

Oleg Nesterov (1):
      rcu: rcu_sched_grace_period(): kill the bogus flush_signals()

Paul E. McKenney (3):
      RCU: make treercu be default
      rcu: Add __rcu_pending tracing to hierarchical RCU
      rcu: Update RCU tracing documentation for __rcu_pending


 Documentation/RCU/trace.txt     |  102 ++++++++++++++++++++++++++++++--------
 include/linux/rculist.h         |   30 +++++++++++-
 include/linux/rcutree.h         |    9 +++-
 include/linux/sched.h           |    8 ++-
 init/Kconfig                    |    2 +-
 ipc/sem.c                       |    4 +-
 kernel/rcupreempt.c             |    8 +---
 kernel/rcutree.c                |   25 +++++++--
 kernel/rcutree_trace.c          |   64 ++++++++++++++++++++++++-
 security/integrity/ima/ima_fs.c |    4 +-
 security/smack/smackfs.c        |    8 ++--
 11 files changed, 213 insertions(+), 51 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 0688482..02cced1 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -192,23 +192,24 @@ rcu/rcuhier (which displays the struct rcu_node hierarchy).
 The output of "cat rcu/rcudata" looks as follows:
 
 rcu:
-  0 c=4011 g=4012 pq=1 pqc=4011 qp=0 rpfq=1 rp=3c2a dt=23301/73 dn=2 df=1882 of=0 ri=2126 ql=2 b=10
-  1 c=4011 g=4012 pq=1 pqc=4011 qp=0 rpfq=3 rp=39a6 dt=78073/1 dn=2 df=1402 of=0 ri=1875 ql=46 b=10
-  2 c=4010 g=4010 pq=1 pqc=4010 qp=0 rpfq=-5 rp=1d12 dt=16646/0 dn=2 df=3140 of=0 ri=2080 ql=0 b=10
-  3 c=4012 g=4013 pq=1 pqc=4012 qp=1 rpfq=3 rp=2b50 dt=21159/1 dn=2 df=2230 of=0 ri=1923 ql=72 b=10
-  4 c=4012 g=4013 pq=1 pqc=4012 qp=1 rpfq=3 rp=1644 dt=5783/1 dn=2 df=3348 of=0 ri=2805 ql=7 b=10
-  5 c=4012 g=4013 pq=0 pqc=4011 qp=1 rpfq=3 rp=1aac dt=5879/1 dn=2 df=3140 of=0 ri=2066 ql=10 b=10
-  6 c=4012 g=4013 pq=1 pqc=4012 qp=1 rpfq=3 rp=ed8 dt=5847/1 dn=2 df=3797 of=0 ri=1266 ql=10 b=10
-  7 c=4012 g=4013 pq=1 pqc=4012 qp=1 rpfq=3 rp=1fa2 dt=6199/1 dn=2 df=2795 of=0 ri=2162 ql=28 b=10
+rcu:
+  0 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=10951/1 dn=0 df=1101 of=0 ri=36 ql=0 b=10
+  1 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=16117/1 dn=0 df=1015 of=0 ri=0 ql=0 b=10
+  2 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=1445/1 dn=0 df=1839 of=0 ri=0 ql=0 b=10
+  3 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=6681/1 dn=0 df=1545 of=0 ri=0 ql=0 b=10
+  4 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=1003/1 dn=0 df=1992 of=0 ri=0 ql=0 b=10
+  5 c=17829 g=17830 pq=1 pqc=17829 qp=1 dt=3887/1 dn=0 df=3331 of=0 ri=4 ql=2 b=10
+  6 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=859/1 dn=0 df=3224 of=0 ri=0 ql=0 b=10
+  7 c=17829 g=17830 pq=0 pqc=17829 qp=1 dt=3761/1 dn=0 df=1818 of=0 ri=0 ql=2 b=10
 rcu_bh:
-  0 c=-268 g=-268 pq=1 pqc=-268 qp=0 rpfq=-145 rp=21d6 dt=23301/73 dn=2 df=0 of=0 ri=0 ql=0 b=10
-  1 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-170 rp=20ce dt=78073/1 dn=2 df=26 of=0 ri=5 ql=0 b=10
-  2 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-83 rp=fbd dt=16646/0 dn=2 df=28 of=0 ri=4 ql=0 b=10
-  3 c=-268 g=-268 pq=1 pqc=-268 qp=0 rpfq=-105 rp=178c dt=21159/1 dn=2 df=28 of=0 ri=2 ql=0 b=10
-  4 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-30 rp=b54 dt=5783/1 dn=2 df=32 of=0 ri=0 ql=0 b=10
-  5 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-29 rp=df5 dt=5879/1 dn=2 df=30 of=0 ri=3 ql=0 b=10
-  6 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-28 rp=788 dt=5847/1 dn=2 df=32 of=0 ri=0 ql=0 b=10
-  7 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-53 rp=1098 dt=6199/1 dn=2 df=30 of=0 ri=3 ql=0 b=10
+  0 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=10951/1 dn=0 df=0 of=0 ri=0 ql=0 b=10
+  1 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=16117/1 dn=0 df=13 of=0 ri=0 ql=0 b=10
+  2 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=1445/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
+  3 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=6681/1 dn=0 df=9 of=0 ri=0 ql=0 b=10
+  4 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=1003/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
+  5 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=3887/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
+  6 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=859/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
+  7 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=3761/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
 
 The first section lists the rcu_data structures for rcu, the second for
 rcu_bh.  Each section has one line per CPU, or eight for this 8-CPU system.
@@ -253,12 +254,6 @@ o	"pqc" indicates which grace period the last-observed quiescent
 o	"qp" indicates that RCU still expects a quiescent state from
 	this CPU.
 
-o	"rpfq" is the number of rcu_pending() calls on this CPU required
-	to induce this CPU to invoke force_quiescent_state().
-
-o	"rp" is low-order four hex digits of the count of how many times
-	rcu_pending() has been invoked on this CPU.
-
 o	"dt" is the current value of the dyntick counter that is incremented
 	when entering or leaving dynticks idle state, either by the
 	scheduler or by irq.  The number after the "/" is the interrupt
@@ -305,6 +300,9 @@ o	"b" is the batch limit for this CPU.  If more than this number
 	of RCU callbacks is ready to invoke, then the remainder will
 	be deferred.
 
+There is also an rcu/rcudata.csv file with the same information in
+comma-separated-variable spreadsheet format.
+
 
 The output of "cat rcu/rcugp" looks as follows:
 
@@ -411,3 +409,63 @@ o	Each element of the form "1/1 0:127 ^0" represents one struct
 		For example, the first entry at the lowest level shows
 		"^0", indicating that it corresponds to bit zero in
 		the first entry at the middle level.
+
+
+The output of "cat rcu/rcu_pending" looks as follows:
+
+rcu:
+  0 np=255892 qsp=53936 cbr=0 cng=14417 gpc=10033 gps=24320 nf=6445 nn=146741
+  1 np=261224 qsp=54638 cbr=0 cng=25723 gpc=16310 gps=2849 nf=5912 nn=155792
+  2 np=237496 qsp=49664 cbr=0 cng=2762 gpc=45478 gps=1762 nf=1201 nn=136629
+  3 np=236249 qsp=48766 cbr=0 cng=286 gpc=48049 gps=1218 nf=207 nn=137723
+  4 np=221310 qsp=46850 cbr=0 cng=26 gpc=43161 gps=4634 nf=3529 nn=123110
+  5 np=237332 qsp=48449 cbr=0 cng=54 gpc=47920 gps=3252 nf=201 nn=137456
+  6 np=219995 qsp=46718 cbr=0 cng=50 gpc=42098 gps=6093 nf=4202 nn=120834
+  7 np=249893 qsp=49390 cbr=0 cng=72 gpc=38400 gps=17102 nf=41 nn=144888
+rcu_bh:
+  0 np=146741 qsp=1419 cbr=0 cng=6 gpc=0 gps=0 nf=2 nn=145314
+  1 np=155792 qsp=12597 cbr=0 cng=0 gpc=4 gps=8 nf=3 nn=143180
+  2 np=136629 qsp=18680 cbr=0 cng=0 gpc=7 gps=6 nf=0 nn=117936
+  3 np=137723 qsp=2843 cbr=0 cng=0 gpc=10 gps=7 nf=0 nn=134863
+  4 np=123110 qsp=12433 cbr=0 cng=0 gpc=4 gps=2 nf=0 nn=110671
+  5 np=137456 qsp=4210 cbr=0 cng=0 gpc=6 gps=5 nf=0 nn=133235
+  6 np=120834 qsp=9902 cbr=0 cng=0 gpc=6 gps=3 nf=2 nn=110921
+  7 np=144888 qsp=26336 cbr=0 cng=0 gpc=8 gps=2 nf=0 nn=118542
+
+As always, this is once again split into "rcu" and "rcu_bh" portions.
+The fields are as follows:
+
+o	"np" is the number of times that __rcu_pending() has been invoked
+	for the corresponding flavor of RCU.
+
+o	"qsp" is the number of times that the RCU was waiting for a
+	quiescent state from this CPU.
+
+o	"cbr" is the number of times that this CPU had RCU callbacks
+	that had passed through a grace period, and were thus ready
+	to be invoked.
+
+o	"cng" is the number of times that this CPU needed another
+	grace period while RCU was idle.
+
+o	"gpc" is the number of times that an old grace period had
+	completed, but this CPU was not yet aware of it.
+
+o	"gps" is the number of times that a new grace period had started,
+	but this CPU was not yet aware of it.
+
+o	"nf" is the number of times that this CPU suspected that the
+	current grace period had run for too long, and thus needed to
+	be forced.
+
+	Please note that "forcing" consists of sending resched IPIs
+	to holdout CPUs.  If that CPU really still is in an old RCU
+	read-side critical section, then we really do have to wait for it.
+	The assumption behing "forcing" is that the CPU is not still in
+	an old RCU read-side critical section, but has not yet responded
+	for some other reason.
+
+o	"nn" is the number of times that this CPU needed nothing.  Alert
+	readers will note that the rcu "nn" number for a given CPU very
+	closely matches the rcu_bh "np" number for that same CPU.  This
+	is due to short-circuit evaluation in rcu_pending().
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index e649bd3..5710f43 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -198,6 +198,32 @@ static inline void list_splice_init_rcu(struct list_head *list,
 	at->prev = last;
 }
 
+/**
+ * list_entry_rcu - get the struct for this entry
+ * @ptr:        the &struct list_head pointer.
+ * @type:       the type of the struct this is embedded in.
+ * @member:     the name of the list_struct within the struct.
+ *
+ * This primitive may safely run concurrently with the _rcu list-mutation
+ * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
+ */
+#define list_entry_rcu(ptr, type, member) \
+	container_of(rcu_dereference(ptr), type, member)
+
+/**
+ * list_first_entry_rcu - get the first element from a list
+ * @ptr:        the list head to take the element from.
+ * @type:       the type of the struct this is embedded in.
+ * @member:     the name of the list_struct within the struct.
+ *
+ * Note, that list is expected to be not empty.
+ *
+ * This primitive may safely run concurrently with the _rcu list-mutation
+ * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
+ */
+#define list_first_entry_rcu(ptr, type, member) \
+	list_entry_rcu((ptr)->next, type, member)
+
 #define __list_for_each_rcu(pos, head) \
 	for (pos = rcu_dereference((head)->next); \
 		pos != (head); \
@@ -214,9 +240,9 @@ static inline void list_splice_init_rcu(struct list_head *list,
  * as long as the traversal is guarded by rcu_read_lock().
  */
 #define list_for_each_entry_rcu(pos, head, member) \
-	for (pos = list_entry(rcu_dereference((head)->next), typeof(*pos), member); \
+	for (pos = list_entry_rcu((head)->next, typeof(*pos), member); \
 		prefetch(pos->member.next), &pos->member != (head); \
-		pos = list_entry(rcu_dereference(pos->member.next), typeof(*pos), member))
+		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
 
 
 /**
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 58b2aa5..5a51538 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -161,8 +161,15 @@ struct rcu_data {
 	unsigned long offline_fqs;	/* Kicked due to being offline. */
 	unsigned long resched_ipi;	/* Sent a resched IPI. */
 
-	/* 5) For future __rcu_pending statistics. */
+	/* 5) __rcu_pending() statistics. */
 	long n_rcu_pending;		/* rcu_pending() calls since boot. */
+	long n_rp_qs_pending;
+	long n_rp_cb_ready;
+	long n_rp_cpu_needs_gp;
+	long n_rp_gp_completed;
+	long n_rp_gp_started;
+	long n_rp_need_fqs;
+	long n_rp_need_nothing;
 
 	int cpu;
 };
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b4c38bc..886df41 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -77,6 +77,7 @@ struct sched_param {
 #include <linux/proportions.h>
 #include <linux/seccomp.h>
 #include <linux/rcupdate.h>
+#include <linux/rculist.h>
 #include <linux/rtmutex.h>
 
 #include <linux/time.h>
@@ -2010,7 +2011,8 @@ static inline unsigned long wait_task_inactive(struct task_struct *p,
 }
 #endif
 
-#define next_task(p)	list_entry(rcu_dereference((p)->tasks.next), struct task_struct, tasks)
+#define next_task(p) \
+	list_entry_rcu((p)->tasks.next, struct task_struct, tasks)
 
 #define for_each_process(p) \
 	for (p = &init_task ; (p = next_task(p)) != &init_task ; )
@@ -2049,8 +2051,8 @@ int same_thread_group(struct task_struct *p1, struct task_struct *p2)
 
 static inline struct task_struct *next_thread(const struct task_struct *p)
 {
-	return list_entry(rcu_dereference(p->thread_group.next),
-			  struct task_struct, thread_group);
+	return list_entry_rcu(p->thread_group.next,
+			      struct task_struct, thread_group);
 }
 
 static inline int thread_group_empty(struct task_struct *p)
diff --git a/init/Kconfig b/init/Kconfig
index 7be4d38..d4e9671 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -308,7 +308,7 @@ menu "RCU Subsystem"
 
 choice
 	prompt "RCU Implementation"
-	default CLASSIC_RCU
+	default TREE_RCU
 
 config CLASSIC_RCU
 	bool "Classic RCU"
diff --git a/ipc/sem.c b/ipc/sem.c
index 16a2189..87c2b64 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1290,8 +1290,8 @@ void exit_sem(struct task_struct *tsk)
 		int i;
 
 		rcu_read_lock();
-		un = list_entry(rcu_dereference(ulp->list_proc.next),
-					struct sem_undo, list_proc);
+		un = list_entry_rcu(ulp->list_proc.next,
+				    struct sem_undo, list_proc);
 		if (&un->list_proc == &ulp->list_proc)
 			semid = -1;
 		 else
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index ce97a4d..beb0e65 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -1356,17 +1356,11 @@ static int rcu_sched_grace_period(void *arg)
 
 		rcu_ctrlblk.sched_sleep = rcu_sched_sleeping;
 		spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
-		ret = 0;
+		ret = 0; /* unused */
 		__wait_event_interruptible(rcu_ctrlblk.sched_wq,
 			rcu_ctrlblk.sched_sleep != rcu_sched_sleeping,
 			ret);
 
-		/*
-		 * Signals would prevent us from sleeping, and we cannot
-		 * do much with them in any case.  So flush them.
-		 */
-		if (ret)
-			flush_signals(current);
 		couldsleepnext = 0;
 
 	} while (!kthread_should_stop());
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d2a372f..0dccfbb 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1259,31 +1259,44 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 	check_cpu_stall(rsp, rdp);
 
 	/* Is the RCU core waiting for a quiescent state from this CPU? */
-	if (rdp->qs_pending)
+	if (rdp->qs_pending) {
+		rdp->n_rp_qs_pending++;
 		return 1;
+	}
 
 	/* Does this CPU have callbacks ready to invoke? */
-	if (cpu_has_callbacks_ready_to_invoke(rdp))
+	if (cpu_has_callbacks_ready_to_invoke(rdp)) {
+		rdp->n_rp_cb_ready++;
 		return 1;
+	}
 
 	/* Has RCU gone idle with this CPU needing another grace period? */
-	if (cpu_needs_another_gp(rsp, rdp))
+	if (cpu_needs_another_gp(rsp, rdp)) {
+		rdp->n_rp_cpu_needs_gp++;
 		return 1;
+	}
 
 	/* Has another RCU grace period completed?  */
-	if (ACCESS_ONCE(rsp->completed) != rdp->completed) /* outside of lock */
+	if (ACCESS_ONCE(rsp->completed) != rdp->completed) { /* outside lock */
+		rdp->n_rp_gp_completed++;
 		return 1;
+	}
 
 	/* Has a new RCU grace period started? */
-	if (ACCESS_ONCE(rsp->gpnum) != rdp->gpnum) /* outside of lock */
+	if (ACCESS_ONCE(rsp->gpnum) != rdp->gpnum) { /* outside lock */
+		rdp->n_rp_gp_started++;
 		return 1;
+	}
 
 	/* Has an RCU GP gone long enough to send resched IPIs &c? */
 	if (ACCESS_ONCE(rsp->completed) != ACCESS_ONCE(rsp->gpnum) &&
-	    ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0))
+	    ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0)) {
+		rdp->n_rp_need_fqs++;
 		return 1;
+	}
 
 	/* nothing to do */
+	rdp->n_rp_need_nothing++;
 	return 0;
 }
 
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 4b1875b..fe1dcdb 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -213,7 +213,63 @@ static struct file_operations rcugp_fops = {
 	.release = single_release,
 };
 
-static struct dentry *rcudir, *datadir, *datadir_csv, *hierdir, *gpdir;
+static void print_one_rcu_pending(struct seq_file *m, struct rcu_data *rdp)
+{
+	seq_printf(m, "%3d%cnp=%ld "
+		   "qsp=%ld cbr=%ld cng=%ld gpc=%ld gps=%ld nf=%ld nn=%ld\n",
+		   rdp->cpu,
+		   cpu_is_offline(rdp->cpu) ? '!' : ' ',
+		   rdp->n_rcu_pending,
+		   rdp->n_rp_qs_pending,
+		   rdp->n_rp_cb_ready,
+		   rdp->n_rp_cpu_needs_gp,
+		   rdp->n_rp_gp_completed,
+		   rdp->n_rp_gp_started,
+		   rdp->n_rp_need_fqs,
+		   rdp->n_rp_need_nothing);
+}
+
+static void print_rcu_pendings(struct seq_file *m, struct rcu_state *rsp)
+{
+	int cpu;
+	struct rcu_data *rdp;
+
+	for_each_possible_cpu(cpu) {
+		rdp = rsp->rda[cpu];
+		if (rdp->beenonline)
+			print_one_rcu_pending(m, rdp);
+	}
+}
+
+static int show_rcu_pending(struct seq_file *m, void *unused)
+{
+	seq_puts(m, "rcu:\n");
+	print_rcu_pendings(m, &rcu_state);
+	seq_puts(m, "rcu_bh:\n");
+	print_rcu_pendings(m, &rcu_bh_state);
+	return 0;
+}
+
+static int rcu_pending_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_rcu_pending, NULL);
+}
+
+static struct file_operations rcu_pending_fops = {
+	.owner = THIS_MODULE,
+	.open = rcu_pending_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static struct dentry *rcudir;
+static struct dentry *datadir;
+static struct dentry *datadir_csv;
+static struct dentry *gpdir;
+static struct dentry *hierdir;
+static struct dentry *rcu_pendingdir;
+
 static int __init rcuclassic_trace_init(void)
 {
 	rcudir = debugfs_create_dir("rcu", NULL);
@@ -238,6 +294,11 @@ static int __init rcuclassic_trace_init(void)
 						NULL, &rcuhier_fops);
 	if (!hierdir)
 		goto free_out;
+
+	rcu_pendingdir = debugfs_create_file("rcu_pending", 0444, rcudir,
+						NULL, &rcu_pending_fops);
+	if (!rcu_pendingdir)
+		goto free_out;
 	return 0;
 free_out:
 	if (datadir)
@@ -257,6 +318,7 @@ static void __exit rcuclassic_trace_cleanup(void)
 	debugfs_remove(datadir_csv);
 	debugfs_remove(gpdir);
 	debugfs_remove(hierdir);
+	debugfs_remove(rcu_pendingdir);
 	debugfs_remove(rcudir);
 }
 
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index ffbe259..510186f 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -84,8 +84,8 @@ static void *ima_measurements_next(struct seq_file *m, void *v, loff_t *pos)
 	 * against concurrent list-extension
 	 */
 	rcu_read_lock();
-	qe = list_entry(rcu_dereference(qe->later.next),
-			struct ima_queue_entry, later);
+	qe = list_entry_rcu(qe->later.next,
+			    struct ima_queue_entry, later);
 	rcu_read_unlock();
 	(*pos)++;
 
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index e03a7e1..11d2cb1 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -734,8 +734,8 @@ static void smk_netlbladdr_insert(struct smk_netlbladdr *new)
 		return;
 	}
 
-	m = list_entry(rcu_dereference(smk_netlbladdr_list.next),
-			 struct smk_netlbladdr, list);
+	m = list_entry_rcu(smk_netlbladdr_list.next,
+			   struct smk_netlbladdr, list);
 
 	/* the comparison '>' is a bit hacky, but works */
 	if (new->smk_mask.s_addr > m->smk_mask.s_addr) {
@@ -748,8 +748,8 @@ static void smk_netlbladdr_insert(struct smk_netlbladdr *new)
 			list_add_rcu(&new->list, &m->list);
 			return;
 		}
-		m_next = list_entry(rcu_dereference(m->list.next),
-				 struct smk_netlbladdr, list);
+		m_next = list_entry_rcu(m->list.next,
+					struct smk_netlbladdr, list);
 		if (new->smk_mask.s_addr > m_next->smk_mask.s_addr) {
 			list_add_rcu(&new->list, &m->list);
 			return;
