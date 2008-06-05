Return-Path: <linux-kernel-owner+w=401wt.eu-S1762503AbYFET5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762503AbYFET5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 15:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYFET5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 15:57:31 -0400
Received: from smtp-out.google.com ([216.239.33.17]:61531 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYFET5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 15:57:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	user-agent:mime-version:content-type;
	b=ZVPGDS5s2fUixSQmVV29mPlV/wfBv0eBgoJj+ld4yYvJD92dEhHaqpRzJ1Oh8Pgrt
	Uo8bWJQZW9deyhS061R4A==
Date: Thu, 5 Jun 2008 12:57:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, Paul Menage <menage@google.com>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: [patch] sched: prevent bound kthreads from changing cpus_allowed
Message-ID: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kthreads that have called kthread_bind() are bound to specific cpus, so
other tasks should not be able to change their cpus_allowed from under
them.  Otherwise, it is possible to move kthreads, such as the migration
or software watchdog threads, so they are not allowed access to the cpu
they work on.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/sched.h |    1 +
 kernel/cpuset.c       |   14 +++++++++++++-
 kernel/kthread.c      |    1 +
 kernel/sched.c        |    6 ++++++
 4 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1504,6 +1504,7 @@ static inline void put_task_struct(struct task_struct *t)
 #define PF_SWAPWRITE	0x00800000	/* Allowed to write to swap */
 #define PF_SPREAD_PAGE	0x01000000	/* Spread page cache over cpuset */
 #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
+#define PF_THREAD_BOUND	0x04000000	/* Thread bound to specific cpu */
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
 #define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezeable */
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1190,6 +1190,15 @@ static int cpuset_can_attach(struct cgroup_subsys *ss,
 
 	if (cpus_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
 		return -ENOSPC;
+	if (tsk->flags & PF_THREAD_BOUND) {
+		cpumask_t mask;
+
+		mutex_lock(&callback_mutex);
+		mask = cs->cpus_allowed;
+		mutex_unlock(&callback_mutex);
+		if (!cpus_equal(tsk->cpus_allowed, mask))
+			return -EINVAL;
+	}
 
 	return security_task_setscheduler(tsk, 0, NULL);
 }
@@ -1203,11 +1212,14 @@ static void cpuset_attach(struct cgroup_subsys *ss,
 	struct mm_struct *mm;
 	struct cpuset *cs = cgroup_cs(cont);
 	struct cpuset *oldcs = cgroup_cs(oldcont);
+	int err;
 
 	mutex_lock(&callback_mutex);
 	guarantee_online_cpus(cs, &cpus);
-	set_cpus_allowed_ptr(tsk, &cpus);
+	err = set_cpus_allowed_ptr(tsk, &cpus);
 	mutex_unlock(&callback_mutex);
+	if (err)
+		return;
 
 	from = oldcs->mems_allowed;
 	to = cs->mems_allowed;
diff --git a/kernel/kthread.c b/kernel/kthread.c
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -180,6 +180,7 @@ void kthread_bind(struct task_struct *k, unsigned int cpu)
 	set_task_cpu(k, cpu);
 	k->cpus_allowed = cpumask_of_cpu(cpu);
 	k->rt.nr_cpus_allowed = 1;
+	k->flags |= PF_THREAD_BOUND;
 }
 EXPORT_SYMBOL(kthread_bind);
 
diff --git a/kernel/sched.c b/kernel/sched.c
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5565,6 +5565,12 @@ int set_cpus_allowed_ptr(struct task_struct *p, const cpumask_t *new_mask)
 		goto out;
 	}
 
+	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current &&
+		     !cpus_equal(p->cpus_allowed, *new_mask))) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (p->sched_class->set_cpus_allowed)
 		p->sched_class->set_cpus_allowed(p, new_mask);
 	else {
