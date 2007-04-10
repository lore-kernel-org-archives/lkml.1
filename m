Return-Path: <linux-kernel-owner+w=401wt.eu-S1031164AbXDJRFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031164AbXDJRFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 13:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031175AbXDJRFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 13:05:38 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37009 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031164AbXDJRFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 13:05:37 -0400
Date: Tue, 10 Apr 2007 22:42:57 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: "Paul Jackson" <pj@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Balbir Singh" <balbir@in.ibm.com>
Subject: [PATCH] Fix race between attach_task and cpuset_exit
Message-ID: <20070410171257.GC3611@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070325164746.GI11794@in.ibm.com> <20070325125025.b6e8f0d4.pj@sgi.com> <20070326115506.GL11794@in.ibm.com> <6599ad830704042255t5c126a0cj86d644cb8174e177@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830704042255t5c126a0cj86d644cb8174e177@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 10:55:01PM -0700, Paul Menage wrote:
> Shouldn't we just put a task_lock()/task_unlock() around these lines
> and leave everything else as-is?
> 
> 	task_lock(tsk);
> 	cs = tsk->cpuset;
> 	tsk->cpuset = &top_cpuset;	/* the_top_cpuset_hack - see above */
> 	task_unlock(tsk)

Andrew,
	Can you drop fix-race-between-attach_task-and-cpuset_exit.patch
and take this fix instead, which addresses some points raised by Paul
Menage?





Currently cpuset_exit() changes the exiting task's ->cpuset pointer w/o
taking task_lock().  This can lead to ugly races between attach_task and
cpuset_exit.  Details of the races are described at
http://lkml.org/lkml/2007/3/24/132.

Patch below closes those races.  It is against 2.6.21-rc6-mm1 and has
undergone a simple compile/boot test on a x86_64 box.

Signed-off-by : Srivatsa Vaddagiri <vatsa@in.ibm.com>


---


diff -puN kernel/cpuset.c~cpuset_race_fix kernel/cpuset.c
--- linux-2.6.21-rc6/kernel/cpuset.c~cpuset_race_fix	2007-04-10 20:53:57.000000000 +0530
+++ linux-2.6.21-rc6-vatsa/kernel/cpuset.c	2007-04-10 22:08:46.000000000 +0530
@@ -2119,10 +2119,6 @@ void cpuset_fork(struct task_struct *chi
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
@@ -2161,8 +2157,10 @@ void cpuset_exit(struct task_struct *tsk
 {
 	struct cpuset *cs;
 
+	task_lock(current);
 	cs = tsk->cpuset;
 	tsk->cpuset = &top_cpuset;	/* the_top_cpuset_hack - see above */
+	task_unlock(current);
 
 	if (notify_on_release(cs)) {
 		char *pathbuf = NULL;
_

-- 
Regards,
vatsa
