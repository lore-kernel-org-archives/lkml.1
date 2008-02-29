Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbYB2EBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbYB2EBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 23:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbYB2EB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 23:01:28 -0500
Received: from smtp-out.google.com ([216.239.45.13]:45757 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbYB2EB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 23:01:27 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=OGbExP3QajmbES0moBhP0AoN/z9PGN2UxNJHoOK6RmHnbnrNINOkOM51ebiE+57wN
	uu9TC/9dQVLhUb/wbZOOA==
Date: Thu, 28 Feb 2008 20:00:43 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, maxk@qualcomm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
In-Reply-To: <20080228213402.7260906f.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802281945060.31783@chino.kir.corp.google.com>
References: <20080227222103.673194000@chello.nl> <20080228075010.GA28781@elte.hu> <20080228020808.3fd22f77.pj@sgi.com> <20080228090847.GA1133@elte.hu> <20080228031710.3405e405.pj@sgi.com> <alpine.DEB.1.00.0802280129580.15900@chino.kir.corp.google.com>
 <alpine.DEB.1.00.0802280212070.23040@chino.kir.corp.google.com> <20080228113728.7b8e5811.pj@sgi.com> <alpine.DEB.1.00.0802281309480.24402@chino.kir.corp.google.com> <20080228164637.114fb19d.pj@sgi.com> <alpine.DEB.1.00.0802281452340.13082@chino.kir.corp.google.com>
 <20080228181611.49671331.pj@sgi.com> <alpine.DEB.1.00.0802281659460.3158@chino.kir.corp.google.com> <20080228213402.7260906f.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Paul Jackson wrote:

> Apparently, you thought I was trying to reject the patch on the grounds
> that no such problem could ever occur, and you were showing how such a
> problem could occur.  I wasn't trying to reject the patch, and I agree
> that the check made sense, and I agree that such a problem could occur,
> as your example shows.
> 

Ok, good.  We're in agreement that my patch fixes a problem in allowing 
kthreads to move to cpusets that either currently or eventually deny them 
access to the cpu to which they are bound.

Now do you have any preference without extensive cpusets or cgroups 
hacking where we can gracefully handle -EINVAL being returned from 
set_cpus_allowed() so the task doesn't end up in a different cpuset?  The 
return value of set_cpus_allowed() is currently ignored by the cpuset 
implementation and, regardless, cpuset_attach() returns void.

cpuset_can_attach() does some sanity checking, but we need a call to 
set_cpus_allowed() to check the new logic and will actually change 
tsk->cpus_allowed if correctly invoked.

So the cpusets implementation needs a similar check in cpuset_can_attach() 
so that it is expressly denied from moving before we ever call 
cpuset_attach().  It doesn't make sense that a kthread is going to move 
itself through the cpusets interface, so this can simply be done by 
checking for tsk->flags & PF_THREAD_BOUND.



sched: prevent bound kthreads from changing cpus_allowed

Kthreads that have called kthread_bind() are bound to specific cpus, so 
other tasks should not be able to change their cpus_allowed from under 
them.  Otherwise, it is possible to move kthreads, such as the migration 
or watchdog threads, so they are not allowed access to the cpu they work 
on.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/sched.h |    1 +
 kernel/cpuset.c       |    2 ++
 kernel/kthread.c      |    1 +
 kernel/sched.c        |    6 ++++++
 4 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1464,6 +1464,7 @@ static inline void put_task_struct(struct task_struct *t)
 #define PF_SWAPWRITE	0x00800000	/* Allowed to write to swap */
 #define PF_SPREAD_PAGE	0x01000000	/* Spread page cache over cpuset */
 #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
+#define PF_THREAD_BOUND 0x04000000	/* Thread bound to specific cpu */
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
 #define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezeable */
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1162,6 +1162,8 @@ static int cpuset_can_attach(struct cgroup_subsys *ss,
 
 	if (cpus_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
 		return -ENOSPC;
+	if (tsk->flags & PF_THREAD_BOUND)
+		return -EINVAL;
 
 	return security_task_setscheduler(tsk, 0, NULL);
 }
diff --git a/kernel/kthread.c b/kernel/kthread.c
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -180,6 +180,7 @@ void kthread_bind(struct task_struct *k, unsigned int cpu)
 	wait_task_inactive(k);
 	set_task_cpu(k, cpu);
 	k->cpus_allowed = cpumask_of_cpu(cpu);
+	k->flags |= PF_THREAD_BOUND;
 }
 EXPORT_SYMBOL(kthread_bind);
 
diff --git a/kernel/sched.c b/kernel/sched.c
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5345,6 +5345,12 @@ int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 		goto out;
 	}
 
+	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current &&
+		     !cpus_equal(p->cpus_allowed, new_mask))) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (p->sched_class->set_cpus_allowed)
 		p->sched_class->set_cpus_allowed(p, &new_mask);
 	else {
