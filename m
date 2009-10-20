Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbZJTAxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbZJTAxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 20:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755609AbZJTAxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 20:53:33 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50770 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbZJTAxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 20:53:33 -0400
Date: Mon, 19 Oct 2009 20:53:29 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, nhorman@tuxdriver.com
Subject: Re: [PATCH 1/3] extend get/setrlimit to support setting rlimits
	external to a process (v7)
Message-ID: <20091020005329.GB8886@localhost.localdomain>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org> <20091012161342.GA32088@hmsreliant.think-freely.org> <20091012201304.GG32088@hmsreliant.think-freely.org> <20091020005214.GA8886@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091020005214.GA8886@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -4.4 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Modify setrlimit syscall to accomodate various usages.
    
    Split the sys_setrlimit syscall into two parts:
    1) a DEFINE_SYSCALL wrapper that implements the sys_setrlimit function
    2) a core do_setrlimit function that accepts as a parameter a task on which to
    operate on the limits of
    
    This allows us later to implement sys_setprlimit, which allows us to change the
    limits of any process from userspace
    
    Signed-off-by: Neil Horman <nhorman@tuxdriver.com


 include/linux/sched.h |    3 +++
 kernel/sys.c          |   48 ++++++++++++++++++++++++++++++------------------
 2 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7755763..ce95005 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -672,6 +672,9 @@ struct signal_struct {
 	int oom_adj;	/* OOM kill score adjustment (bit shift) */
 };
 
+extern int do_setrlimit(unsigned int resource, struct rlimit *new_rlim,
+			struct task_struct *tsk);
+
 /* Context switch must be unlocked if interrupts are to be enabled */
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
 # define __ARCH_WANT_UNLOCKED_CTXSW
diff --git a/kernel/sys.c b/kernel/sys.c
index 1828f8d..0e210a4 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1238,41 +1238,41 @@ SYSCALL_DEFINE2(old_getrlimit, unsigned int, resource,
 
 #endif
 
-SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
+int do_setrlimit(unsigned int resource, struct rlimit *new_rlim,
+		 struct task_struct *tsk)
 {
-	struct rlimit new_rlim, *old_rlim;
 	int retval;
+	struct rlimit *old_rlim;
 
-	if (resource >= RLIM_NLIMITS)
-		return -EINVAL;
-	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
-		return -EFAULT;
-	if (new_rlim.rlim_cur > new_rlim.rlim_max)
+
+	if (new_rlim->rlim_cur > new_rlim->rlim_max)
 		return -EINVAL;
-	old_rlim = current->signal->rlim + resource;
-	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
+	old_rlim = tsk->signal->rlim + resource;
+
+	if ((new_rlim->rlim_max > old_rlim->rlim_max) &&
 	    !capable(CAP_SYS_RESOURCE))
 		return -EPERM;
-	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
+
+	if (resource == RLIMIT_NOFILE && new_rlim->rlim_max > sysctl_nr_open)
 		return -EPERM;
 
-	retval = security_task_setrlimit(resource, &new_rlim);
+	retval = security_task_setrlimit(resource, new_rlim);
 	if (retval)
 		return retval;
 
-	if (resource == RLIMIT_CPU && new_rlim.rlim_cur == 0) {
+	if (resource == RLIMIT_CPU && new_rlim->rlim_cur == 0) {
 		/*
 		 * The caller is asking for an immediate RLIMIT_CPU
 		 * expiry.  But we use the zero value to mean "it was
 		 * never set".  So let's cheat and make it one second
 		 * instead
 		 */
-		new_rlim.rlim_cur = 1;
+		new_rlim->rlim_cur = 1;
 	}
 
-	task_lock(current->group_leader);
-	*old_rlim = new_rlim;
-	task_unlock(current->group_leader);
+	task_lock(tsk->group_leader);
+	*old_rlim = *new_rlim;
+	task_unlock(tsk->group_leader);
 
 	if (resource != RLIMIT_CPU)
 		goto out;
@@ -1283,14 +1283,26 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 	 * very long-standing error, and fixing it now risks breakage of
 	 * applications, so we live with it
 	 */
-	if (new_rlim.rlim_cur == RLIM_INFINITY)
+	if (new_rlim->rlim_cur == RLIM_INFINITY)
 		goto out;
 
-	update_rlimit_cpu(new_rlim.rlim_cur);
+	update_rlimit_cpu(new_rlim->rlim_cur);
 out:
 	return 0;
 }
 
+SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
+{
+	struct rlimit new_rlim;
+
+	if (resource >= RLIM_NLIMITS)
+		return -EINVAL;
+	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
+		return -EFAULT;
+
+	return do_setrlimit(resource, &new_rlim, current);
+}
+
 /*
  * It would make sense to put struct rusage in the task_struct,
  * except that would make the task_struct be *really big*.  After
