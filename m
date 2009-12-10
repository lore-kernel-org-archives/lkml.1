Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZLJAyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZLJAyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbZLJAyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:54:13 -0500
Received: from www.tglx.de ([62.245.132.106]:54065 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611AbZLJAyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:54:13 -0500
Message-Id: <20091210004703.111906707@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 10 Dec 2009 00:53:03 -0000
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
Subject: [patch 3/9] proc: Add missing rcu protection for __task_cred() in
	task_sig()
References: <20091210001308.247025548@linutronix.de>
Content-Disposition: inline;
	filename=proc-fix-missing-rcu-protection-of-__task_cred.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_sig() accesses __task_cred() without being in a RCU read side
critical section. tasklist_lock is not protecting that when
CONFIG_TREE_PREEMPT_RCU=y.

Add a rcu_read_lock/unlock() section around the code which accesses
__task_cred().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>

---
 fs/proc/array.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-tip/fs/proc/array.c
===================================================================
--- linux-2.6-tip.orig/fs/proc/array.c
+++ linux-2.6-tip/fs/proc/array.c
@@ -265,7 +265,9 @@ static inline void task_sig(struct seq_f
 		blocked = p->blocked;
 		collect_sigign_sigcatch(p, &ignored, &caught);
 		num_threads = atomic_read(&p->signal->count);
+		rcu_read_lock();
 		qsize = atomic_read(&__task_cred(p)->user->sigpending);
+		rcu_read_unlock();
 		qlim = p->signal->rlim[RLIMIT_SIGPENDING].rlim_cur;
 		unlock_task_sighand(p, &flags);
 	}


