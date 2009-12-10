Return-Path: <linux-kernel-owner+w=401wt.eu-S1759298AbZLJAy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298AbZLJAy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759221AbZLJAyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:54:25 -0500
Received: from www.tglx.de ([62.245.132.106]:54074 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330AbZLJAyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:54:17 -0500
Message-Id: <20091210004703.029784964@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 10 Dec 2009 00:52:51 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-security-module@vger.kernel.org
Subject: [patch 1/9] sys: Fix missing rcu protection for __task_cred() access
References: <20091210001308.247025548@linutronix.de>
Content-Disposition: inline; filename=sys-add-missing-rcu-protection.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org
---
 kernel/sys.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-tip/kernel/sys.c
===================================================================
--- linux-2.6-tip.orig/kernel/sys.c
+++ linux-2.6-tip/kernel/sys.c
@@ -163,6 +163,7 @@ SYSCALL_DEFINE3(setpriority, int, which,
 	if (niceval > 19)
 		niceval = 19;
 
+	rcu_read_lock();
 	read_lock(&tasklist_lock);
 	switch (which) {
 		case PRIO_PROCESS:
@@ -200,6 +201,7 @@ SYSCALL_DEFINE3(setpriority, int, which,
 	}
 out_unlock:
 	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 out:
 	return error;
 }


