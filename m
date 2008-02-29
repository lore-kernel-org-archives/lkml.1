Return-Path: <linux-kernel-owner+w=401wt.eu-S933077AbYB2UXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077AbYB2UXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 15:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbYB2UXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 15:23:08 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50071 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbYB2UXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 15:23:07 -0500
Message-ID: <47C8692D.1030701@jp.fujitsu.com>
Date: Fri, 29 Feb 2008 15:21:01 -0500
From: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       vatsa <vatsa@linux.vnet.ibm.com>, Kei Tokunaga <ktokunag@redhat.com>,
       Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Subject: Re: A strange behavior of sched_fair
References: <47C5E977.2010401@jp.fujitsu.com> <1204277686.6243.52.camel@lappy> <1204279909.6243.64.camel@lappy> <20080229194213.GA21249@elte.hu>
In-Reply-To: <20080229194213.GA21249@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote, (2008/02/29 14:42):
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
>>> Seems the vruntime doesn't get re-set if you move tasks between 
>>> groups. sched_move_task() should call place_entity() in the context 
>>> of the new cfs_rq.
>> This should do I guess - uncompiled, untested
> 
> if someone tests it and if it solves the problem i'll apply it to the 
> scheduler tree.

Hi Ingo, Peter,

Thanks for the patch, Peter.  I modified it a bit to compile and
confirmed the issue did not occur on my ia64 box.  I am attaching
the revised patch below.

Thanks,
Kei


Subject: sched: fair-group: fixup tasks on group move

Tasks would retain their old vruntime when moved between groups, this
can cause funny lags. Re-set the vruntime on group move to fit within
the new tree.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>


---

  linux-2.6.25-rc3-cgroup-kei/include/linux/sched.h |    4 ++++
  linux-2.6.25-rc3-cgroup-kei/kernel/sched.c        |    3 +++
  linux-2.6.25-rc3-cgroup-kei/kernel/sched_fair.c   |   14 ++++++++++++++
  3 files changed, 21 insertions(+)

diff -puN include/linux/sched.h~sched_fair include/linux/sched.h
--- linux-2.6.25-rc3-cgroup/include/linux/sched.h~sched_fair	2008-02-29 12:26:47.000000000 -0500
+++ linux-2.6.25-rc3-cgroup-kei/include/linux/sched.h	2008-02-29 12:26:47.000000000 -0500
@@ -898,6 +898,10 @@ struct sched_class {
  			     int running);
  	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
  			     int oldprio, int running);
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	void (*moved_group) (struct task_struct *p);
+#endif
  };

  struct load_weight {
diff -puN kernel/sched.c~sched_fair kernel/sched.c
--- linux-2.6.25-rc3-cgroup/kernel/sched.c~sched_fair	2008-02-29 12:26:47.000000000 -0500
+++ linux-2.6.25-rc3-cgroup-kei/kernel/sched.c	2008-02-29 12:26:47.000000000 -0500
@@ -7825,6 +7825,9 @@ void sched_move_task(struct task_struct

  	set_task_rq(tsk, task_cpu(tsk));

+	if (tsk->sched_class->moved_group)
+		tsk->sched_class->moved_group(tsk);
+
  	if (on_rq) {
  		if (unlikely(running))
  			tsk->sched_class->set_curr_task(rq);
diff -puN kernel/sched_fair.c~sched_fair kernel/sched_fair.c
--- linux-2.6.25-rc3-cgroup/kernel/sched_fair.c~sched_fair	2008-02-29 12:26:47.000000000 -0500
+++ linux-2.6.25-rc3-cgroup-kei/kernel/sched_fair.c	2008-02-29 13:49:15.000000000 -0500
@@ -1403,6 +1403,16 @@ static void set_curr_task_fair(struct rq
  		set_next_entity(cfs_rq_of(se), se);
  }

+#ifdef CONFIG_FAIR_GROUP_SCHED
+static void moved_group_fair(struct task_struct *p)
+{
+	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+
+	update_curr(cfs_rq);
+	place_entity(cfs_rq, &p->se, 1);
+}
+#endif
+
  /*
   * All the scheduling class methods:
   */
@@ -1431,6 +1441,10 @@ static const struct sched_class fair_sch

  	.prio_changed		= prio_changed_fair,
  	.switched_to		= switched_to_fair,
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	.moved_group		= moved_group_fair,
+#endif
  };

  #ifdef CONFIG_SCHED_DEBUG

_



