Return-Path: <linux-kernel-owner+w=401wt.eu-S1757908AbZLNQcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbZLNQcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 11:32:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbZLNQcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 11:32:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:34081 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757886AbZLNQcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 11:32:04 -0500
Date: Mon, 14 Dec 2009 16:31:35 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091209100706.862897167@linutronix.de>
References: <20091209100706.862897167@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Use rcu in sched_get_rr_param()
Message-ID: <tip-1a551ae715825bb2a2107a2dd68de024a1fa4e32@git.kernel.org>
Git-Commit-ID: 1a551ae715825bb2a2107a2dd68de024a1fa4e32
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1a551ae715825bb2a2107a2dd68de024a1fa4e32
Gitweb:     http://git.kernel.org/tip/1a551ae715825bb2a2107a2dd68de024a1fa4e32
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 9 Dec 2009 10:15:11 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Dec 2009 17:11:35 +0100

sched: Use rcu in sched_get_rr_param()

read_lock(&tasklist_lock) does not protect
sys_sched_get_rr_param() against a concurrent update of the
policy or scheduler parameters as do_sched_scheduler() does not
take the tasklist_lock.

The access to task->sched_class->get_rr_interval is protected by
task_rq_lock(task).

Use rcu_read_lock() to protect find_task_by_vpid() and prevent
the task struct from going away.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20091209100706.862897167@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7989312..db5c266 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6873,7 +6873,7 @@ SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
 		return -EINVAL;
 
 	retval = -ESRCH;
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	p = find_process_by_pid(pid);
 	if (!p)
 		goto out_unlock;
@@ -6886,13 +6886,13 @@ SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
 	time_slice = p->sched_class->get_rr_interval(rq, p);
 	task_rq_unlock(rq, &flags);
 
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	jiffies_to_timespec(time_slice, &t);
 	retval = copy_to_user(interval, &t, sizeof(t)) ? -EFAULT : 0;
 	return retval;
 
 out_unlock:
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	return retval;
 }
 
