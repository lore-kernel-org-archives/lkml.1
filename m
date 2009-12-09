Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbZLIJxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbZLIJxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbZLIJxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:53:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:45034 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935AbZLIJxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:53:39 -0500
Date: Wed, 9 Dec 2009 09:52:54 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091208202026.769251187@linutronix.de>
References: <20091208202026.769251187@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Protect task->cpus_allowed access in sched_getaffinity()
Message-ID: <tip-3160568371da441b7f2fb57f2f1225404207e8f2@git.kernel.org>
Git-Commit-ID: 3160568371da441b7f2fb57f2f1225404207e8f2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3160568371da441b7f2fb57f2f1225404207e8f2
Gitweb:     http://git.kernel.org/tip/3160568371da441b7f2fb57f2f1225404207e8f2
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 8 Dec 2009 20:24:16 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 10:01:06 +0100

sched: Protect task->cpus_allowed access in sched_getaffinity()

sched_getaffinity() is not protected against a concurrent
modification of the tasks affinity.

Serialize the access with task_rq_lock(task).

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20091208202026.769251187@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 281da29..c4635f7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6631,6 +6631,8 @@ SYSCALL_DEFINE3(sched_setaffinity, pid_t, pid, unsigned int, len,
 long sched_getaffinity(pid_t pid, struct cpumask *mask)
 {
 	struct task_struct *p;
+	unsigned long flags;
+	struct rq *rq;
 	int retval;
 
 	get_online_cpus();
@@ -6645,7 +6647,9 @@ long sched_getaffinity(pid_t pid, struct cpumask *mask)
 	if (retval)
 		goto out_unlock;
 
+	rq = task_rq_lock(p, &flags);
 	cpumask_and(mask, &p->cpus_allowed, cpu_online_mask);
+	task_rq_unlock(rq, &flags);
 
 out_unlock:
 	read_unlock(&tasklist_lock);
