Return-Path: <linux-kernel-owner+w=401wt.eu-S932786AbZLJWKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbZLJWKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 17:10:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761924AbZLJWKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 17:10:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:41312 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761903AbZLJWKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 17:10:03 -0500
Date: Thu, 10 Dec 2009 22:09:59 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20091210004703.029784964@linutronix.de>
References: <20091210004703.029784964@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] sys: Fix missing rcu protection for __task_cred() access
Message-ID: <tip-d4581a239a40319205762b76c01eb6363f277efa@git.kernel.org>
Git-Commit-ID: d4581a239a40319205762b76c01eb6363f277efa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d4581a239a40319205762b76c01eb6363f277efa
Gitweb:     http://git.kernel.org/tip/d4581a239a40319205762b76c01eb6363f277efa
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 10 Dec 2009 00:52:51 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 10 Dec 2009 23:04:11 +0100

sys: Fix missing rcu protection for __task_cred() access

commit c69e8d9 (CRED: Use RCU to access another task's creds and to
release a task's own creds) added non rcu_read_lock() protected access
to task creds of the target task in set_prio_one().

The comment above the function says:
 * - the caller must hold the RCU read lock

The calling code in sys_setpriority does read_lock(&tasklist_lock) but
not rcu_read_lock(). This works only when CONFIG_TREE_PREEMPT_RCU=n.
With CONFIG_TREE_PREEMPT_RCU=y the rcu_callbacks can run in the tick
interrupt when they see no read side critical section.

There is another instance of __task_cred() in sys_setpriority() itself
which is equally unprotected.

Wrap the whole code section into a rcu read side critical section to
fix this quick and dirty.

Will be revisited in course of the read_lock(&tasklist_lock) -> rcu
crusade.

Oleg noted further:

This also fixes another bug here. find_task_by_vpid() is not safe
without rcu_read_lock(). I do not mean it is not safe to use the
result, just find_pid_ns() by itself is not safe.

Usually tasklist gives enough protection, but if copy_process() fails
it calls free_pid() lockless and does call_rcu(delayed_put_pid().
This means, without rcu lock find_pid_ns() can't scan the hash table
safely.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20091210004703.029784964@linutronix.de>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

---
 kernel/sys.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 9968c5f..bc1dc61 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -163,6 +163,7 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
 	if (niceval > 19)
 		niceval = 19;
 
+	rcu_read_lock();
 	read_lock(&tasklist_lock);
 	switch (which) {
 		case PRIO_PROCESS:
@@ -200,6 +201,7 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
 	}
 out_unlock:
 	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 out:
 	return error;
 }
