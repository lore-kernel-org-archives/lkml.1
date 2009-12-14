Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbZLNQbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbZLNQbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 11:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757820AbZLNQbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 11:31:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:34072 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755050AbZLNQbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 11:31:51 -0500
Date: Mon, 14 Dec 2009 16:31:19 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091209100706.789059966@linutronix.de>
References: <20091209100706.789059966@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Use rcu in sched_get/set_affinity()
Message-ID: <tip-23f5d142519621b16cf2b378cf8adf4dcf01a616@git.kernel.org>
Git-Commit-ID: 23f5d142519621b16cf2b378cf8adf4dcf01a616
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23f5d142519621b16cf2b378cf8adf4dcf01a616
Gitweb:     http://git.kernel.org/tip/23f5d142519621b16cf2b378cf8adf4dcf01a616
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 9 Dec 2009 10:15:01 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Dec 2009 17:11:35 +0100

sched: Use rcu in sched_get/set_affinity()

tasklist_lock is held read locked to protect the
find_task_by_vpid() call and to prevent the task going away.
sched_setaffinity acquires a task struct ref and drops tasklist
lock right away. The access to the cpus_allowed mask is
protected by rq->lock.

rcu_read_lock() provides the same protection here.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20091209100706.789059966@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1782bee..7989312 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6516,22 +6516,18 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 	int retval;
 
 	get_online_cpus();
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 
 	p = find_process_by_pid(pid);
 	if (!p) {
-		read_unlock(&tasklist_lock);
+		rcu_read_unlock();
 		put_online_cpus();
 		return -ESRCH;
 	}
 
-	/*
-	 * It is not safe to call set_cpus_allowed with the
-	 * tasklist_lock held. We will bump the task_struct's
-	 * usage count and then drop tasklist_lock.
-	 */
+	/* Prevent p going away */
 	get_task_struct(p);
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	if (!alloc_cpumask_var(&cpus_allowed, GFP_KERNEL)) {
 		retval = -ENOMEM;
@@ -6617,7 +6613,7 @@ long sched_getaffinity(pid_t pid, struct cpumask *mask)
 	int retval;
 
 	get_online_cpus();
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 
 	retval = -ESRCH;
 	p = find_process_by_pid(pid);
@@ -6633,7 +6629,7 @@ long sched_getaffinity(pid_t pid, struct cpumask *mask)
 	task_rq_unlock(rq, &flags);
 
 out_unlock:
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	put_online_cpus();
 
 	return retval;
