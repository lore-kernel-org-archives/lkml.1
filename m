Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbZLJAyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbZLJAyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbZLJAyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:54:19 -0500
Received: from www.tglx.de ([62.245.132.106]:54070 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135AbZLJAyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:54:16 -0500
Message-Id: <20091210004703.067454615@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 10 Dec 2009 00:52:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 2/9] fs: Add missing rcu protection for __task_cred() in
	sys_ioprio_get
References: <20091210001308.247025548@linutronix.de>
Content-Disposition: inline;
	filename=fs-fix-missing-rcu-protection-of-__task_cred.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_ioprio_get() accesses __task_cred() without being in a RCU read
side critical section. tasklist_lock is not protecting that when
CONFIG_TREE_PREEMPT_RCU=y.

Add a rcu_read_lock/unlock() section around the code which accesses
__task_cred().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/ioprio.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-tip/fs/ioprio.c
===================================================================
--- linux-2.6-tip.orig/fs/ioprio.c
+++ linux-2.6-tip/fs/ioprio.c
@@ -230,6 +230,7 @@ SYSCALL_DEFINE2(ioprio_get, int, which, 
 			if (!user)
 				break;
 
+			rcu_read_lock();
 			do_each_thread(g, p) {
 				if (__task_cred(p)->uid != user->uid)
 					continue;
@@ -241,6 +242,7 @@ SYSCALL_DEFINE2(ioprio_get, int, which, 
 				else
 					ret = ioprio_best(ret, tmpio);
 			} while_each_thread(g, p);
+			rcu_read_unlock();
 
 			if (who)
 				free_uid(user);


