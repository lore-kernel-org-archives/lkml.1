Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbXCZLrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbXCZLrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 07:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbXCZLrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 07:47:41 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37457 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbXCZLrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 07:47:39 -0400
Date: Mon, 26 Mar 2007 17:25:06 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Paul Jackson <pj@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@in.ibm.com>, menage@google.com
Subject: Re: [PATCH] Fix race between attach_task and cpuset_exit
Message-ID: <20070326115506.GL11794@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070325164746.GI11794@in.ibm.com> <20070325125025.b6e8f0d4.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070325125025.b6e8f0d4.pj@sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 12:50:25PM -0700, Paul Jackson wrote:
> Is there perhaps another race here? 

Yes, we have!

Modified patch below. Compile/boot tested on a x86_64 box.


Currently cpuset_exit() changes the exiting task's ->cpuset pointer w/o
taking task_lock(). This can lead to ugly races between attach_task and
cpuset_exit. Details of the races are described at
http://lkml.org/lkml/2007/3/24/132.

Patch below closes those races. It is against 2.6.21-rc4 and has
undergone a simple compile/boot test on a x86_64 box.

Signed-off-by : Srivatsa Vaddagiri <vatsa@in.ibm.com>


---


diff -puN kernel/cpuset.c~cpuset_race_fix kernel/cpuset.c
--- linux-2.6.21-rc4/kernel/cpuset.c~cpuset_race_fix	2007-03-25 21:08:27.000000000 +0530
+++ linux-2.6.21-rc4-vatsa/kernel/cpuset.c	2007-03-26 16:48:24.000000000 +0530
@@ -1182,6 +1182,7 @@ static int attach_task(struct cpuset *cs
 	pid_t pid;
 	struct task_struct *tsk;
 	struct cpuset *oldcs;
+	struct cpuset *oldcs_to_be_released = NULL;
 	cpumask_t cpus;
 	nodemask_t from, to;
 	struct mm_struct *mm;
@@ -1237,6 +1238,8 @@ static int attach_task(struct cpuset *cs
 	}
 	atomic_inc(&cs->count);
 	rcu_assign_pointer(tsk->cpuset, cs);
+	if (atomic_dec_and_test(&oldcs->count))
+		oldcs_to_be_released = oldcs;
 	task_unlock(tsk);
 
 	guarantee_online_cpus(cs, &cpus);
@@ -1257,8 +1260,8 @@ static int attach_task(struct cpuset *cs
 
 	put_task_struct(tsk);
 	synchronize_rcu();
-	if (atomic_dec_and_test(&oldcs->count))
-		check_for_release(oldcs, ppathbuf);
+	if (oldcs_to_be_released)
+		check_for_release(oldcs_to_be_released, ppathbuf);
 	return 0;
 }
 
@@ -2200,10 +2203,6 @@ void cpuset_fork(struct task_struct *chi
  * it is holding that mutex while calling check_for_release(),
  * which calls kmalloc(), so can't be called holding callback_mutex().
  *
- * We don't need to task_lock() this reference to tsk->cpuset,
- * because tsk is already marked PF_EXITING, so attach_task() won't
- * mess with it, or task is a failed fork, never visible to attach_task.
- *
  * the_top_cpuset_hack:
  *
  *    Set the exiting tasks cpuset to the root cpuset (top_cpuset).
@@ -2241,20 +2240,23 @@ void cpuset_fork(struct task_struct *chi
 void cpuset_exit(struct task_struct *tsk)
 {
 	struct cpuset *cs;
+	struct cpuset *oldcs_to_be_released = NULL;
 
+	task_lock(tsk);
 	cs = tsk->cpuset;
 	tsk->cpuset = &top_cpuset;	/* the_top_cpuset_hack - see above */
+	if (atomic_dec_and_test(&cs->count))
+		oldcs_to_be_released = cs;
+	task_unlock(tsk);
 
 	if (notify_on_release(cs)) {
 		char *pathbuf = NULL;
 
 		mutex_lock(&manage_mutex);
-		if (atomic_dec_and_test(&cs->count))
-			check_for_release(cs, &pathbuf);
+		if (oldcs_to_be_released)
+			check_for_release(oldcs_to_be_released, &pathbuf);
 		mutex_unlock(&manage_mutex);
 		cpuset_release_agent(pathbuf);
-	} else {
-		atomic_dec(&cs->count);
 	}
 }
 
_


-- 
Regards,
vatsa
