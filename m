Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbYB2KMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbYB2KMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 05:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbYB2KMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 05:12:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35044 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861AbYB2KMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 05:12:01 -0500
Subject: Re: A strange behavior of sched_fair
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       vatsa <vatsa@linux.vnet.ibm.com>
In-Reply-To: <1204277686.6243.52.camel@lappy>
References: <47C5E977.2010401@jp.fujitsu.com>
	 <1204277686.6243.52.camel@lappy>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 11:11:49 +0100
Message-Id: <1204279909.6243.64.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 10:34 +0100, Peter Zijlstra wrote:
> On Wed, 2008-02-27 at 17:51 -0500, Kei Tokunaga wrote:
> > Hi Ingo,
> > 
> > I am playing around with sched_fair and cgroup, and it seems like
> > I hit a possible bug.  Could you also check if that is a bug?
> > 
> > Description of behavior:
> >    Start a cpu-bound task (t1), attach it to a cgroup (cgA), and let the
> >    task to run for a while (e.g. several tens of seconds or a couple of
> >    minutes would be adequate.)  Then, start another cpu-bound task (t2)
> >    and attach it to cgA in the way described in "Steps to Reproduce" section.
> >    You will see t1 does not get run for a while.
> >    (The tasks may not have to be cpu-bound, but it is easier to see the
> >     behavior using cpu-bound tasks.)
> > 
> > How reproducible:
> >    Always.
> > 
> > Environments where I saw the behavior:
> >    2.6.25-rc3 with resource management functions enabled on ia64 box.
> > 
> > Steps to Reproduce:
> >    # mkdir /dev/cgroup
> >    # mount -t cgroup -ocpuset,cpu cpu /dev/cgroup
> >    # mkdir /dev/cgroup/{a,b}
> >    # echo 0 > /dev/cgroup/a/cpuset.cpus
> >    # echo 0 > /dev/cgroup/b/cpuset.cpus
> >    # echo 1 > /dev/cgroup/a/cpuset.mems
> >    # echo 1 > /dev/cgroup/b/cpuset.mems
> >    # echo $$ > /dev/cgroup/b/tasks
> >    # ./a.out & echo $! > /dev/cgroup/a/tasks (a.out is just a for-loop program)
> >      [Wait for several tens of seconds or a couple of minutes.]
> >    # ./a.out2 & echo $! > /dev/cgroup/a/tasks (a.out2 is just a for-loop program)
> >      [You will see a.out does not get run for a while by running top command.]
> > 
> > Additional Info:
> >    a.out2 needs to be started from the shell of cgroup-b in order to
> >    reproduce the problem (, unless the system is UP.)  Starting a.out2
> >    in the manner, se->vruntime (or something to create the se->vruntime)
> >    of a.out2 seems to be initialized to a small value, compared to the
> >    value of a.out.  And the fair scheduler only runs a.out2 until the
> >    se->vruntime catches up with the se->vruntime of a.out.
> 
> Seems the vruntime doesn't get re-set if you move tasks between groups.
> sched_move_task() should call place_entity() in the context of the new
> cfs_rq.

This should do I guess - uncompiled, untested

---
Subject: sched: fair-group: fixup tasks on group move

Tasks would retain their old vruntime when moved between groups, this
can cause funny lags. Re-set the vruntime on group move to fit within
the new tree.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    4 ++++
 kernel/sched.c        |    3 +++
 kernel/sched_fair.c   |   14 ++++++++++++++
 3 files changed, 21 insertions(+)

Index: linux-2.6-2/include/linux/sched.h
===================================================================
--- linux-2.6-2.orig/include/linux/sched.h
+++ linux-2.6-2/include/linux/sched.h
@@ -899,6 +899,10 @@ struct sched_class {
 			     int running);
 	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
 			     int oldprio, int running);
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	void (*moved_group) (struct task_struct *p);
+#endif
 };
 
 struct load_weight {
Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -7831,6 +7831,9 @@ void sched_move_task(struct task_struct 
 
 	set_task_rq(tsk, task_cpu(tsk));
 
+	if (tsk->sched_class->moved_group)
+		tsk->sched_class->moved_group(tsk);
+
 	if (on_rq) {
 		if (unlikely(running))
 			tsk->sched_class->set_curr_task(rq);
Index: linux-2.6-2/kernel/sched_fair.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_fair.c
+++ linux-2.6-2/kernel/sched_fair.c
@@ -1398,6 +1398,16 @@ static void set_curr_task_fair(struct rq
 		set_next_entity(cfs_rq_of(se), se);
 }
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static void moved_group_fair(struct task_struct *p)
+{
+	struct cfs_rq = task_cfs_rq(tsk);
+
+	update_curr(cfs_rq);
+	place_entity(cfs_rq, &p->se, 1);
+}
+#endif
+
 /*
  * All the scheduling class methods:
  */
@@ -1426,6 +1436,10 @@ static const struct sched_class fair_sch
 
 	.prio_changed		= prio_changed_fair,
 	.switched_to		= switched_to_fair,
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	.moved_group		= moved_group_fair,
+#endif
 };
 
 #ifdef CONFIG_SCHED_DEBUG


