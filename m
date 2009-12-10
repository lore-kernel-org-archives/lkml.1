Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbZLJAyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbZLJAyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759316AbZLJAyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:54:35 -0500
Received: from www.tglx.de ([62.245.132.106]:53866 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759256AbZLJAy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:54:29 -0500
Message-Id: <20091210004703.269843657@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 10 Dec 2009 00:53:21 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>
Subject: [patch 7/9] signals: Fix more rcu assumptions
References: <20091210001308.247025548@linutronix.de>
Content-Disposition: inline; filename=signal-fix-more-rcu-assumptions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) Remove the misleading comment in __sigqueue_alloc() which claims
   that holding a spinlock is equivalent to rcu_read_lock().

2) Wrap the __send_signal() call in send_signal() into a rcu read side
   critical section to guarantee that the __sigqueue_alloc()
   requirement is met in any case.

This needs to be revisited to remove the remaining users of
read_lock(&tasklist_lock) but that's outside the scope of this patch.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Index: linux-2.6-tip/kernel/signal.c
===================================================================
--- linux-2.6-tip.orig/kernel/signal.c
+++ linux-2.6-tip/kernel/signal.c
@@ -220,8 +220,7 @@ __sigqueue_alloc(int sig, struct task_st
 	/*
 	 * We won't get problems with the target's UID changing under us
 	 * because changing it requires RCU be used, and if t != current, the
-	 * caller must be holding the RCU readlock (by way of a spinlock) and
-	 * we use RCU protection here
+	 * caller must be holding the RCU readlock.
 	 */
 	user = get_uid(__task_cred(t)->user);
 	atomic_inc(&user->sigpending);
@@ -946,7 +945,7 @@ out_set:
 static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			int group)
 {
-	int from_ancestor_ns = 0;
+	int ret, from_ancestor_ns = 0;
 
 #ifdef CONFIG_PID_NS
 	if (!is_si_special(info) && SI_FROMUSER(info) &&
@@ -954,7 +953,11 @@ static int send_signal(int sig, struct s
 		from_ancestor_ns = 1;
 #endif
 
-	return __send_signal(sig, info, t, group, from_ancestor_ns);
+	rcu_read_lock();
+	ret = __send_signal(sig, info, t, group, from_ancestor_ns);
+	rcu_read_unlock();
+
+	return ret;
 }
 
 static void print_fatal_signal(struct pt_regs *regs, int signr)


