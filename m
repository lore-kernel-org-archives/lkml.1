Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbYEaQO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbYEaQO6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 12:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbYEaQON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 12:14:13 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:38349 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbYEaQOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 12:14:12 -0400
Date: Sat, 31 May 2008 20:15:37 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] coredump: zap_threads: comments && use while_each_thread()
Message-ID: <20080531161537.GA5569@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No changes in fs/exec.o

The for_each_process() loop in zap_threads() is very subtle, it is not clear
why we don't race with fork/exit/exec. Add the fat comment.

Also, change the code to use while_each_thread().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/fs/exec.c~3_CDUMP_COMMENTS	2008-05-26 19:37:35.000000000 +0400
+++ 26-rc2/fs/exec.c	2008-05-31 20:05:21.000000000 +0400
@@ -1512,7 +1512,7 @@ static void zap_process(struct task_stru
 			sigaddset(&t->pending.signal, SIGKILL);
 			signal_wake_up(t, 1);
 		}
-	} while ((t = next_thread(t)) != start);
+	} while_each_thread(start, t);
 }
 
 static inline int zap_threads(struct task_struct *tsk, struct mm_struct *mm,
@@ -1534,7 +1534,36 @@ static inline int zap_threads(struct tas
 
 	if (atomic_read(&mm->mm_users) == mm->core_waiters + 1)
 		goto done;
-
+	/*
+	 * We should find and kill all tasks which use this mm, and we should
+	 * count them correctly into mm->core_waiters. We don't take tasklist
+	 * lock, but this is safe wrt:
+	 *
+	 * fork:
+	 *	None of sub-threads can fork after zap_process(leader). All
+	 *	processes which were created before this point should be
+	 *	visible to zap_threads() because copy_process() adds the new
+	 *	process to the tail of init_task.tasks list, and lock/unlock
+	 *	of ->siglock provides a memory barrier.
+	 *
+	 * do_exit:
+	 *	The caller holds mm->mmap_sem. This means that the task which
+	 *	uses this mm can't pass exit_mm(), so it can't exit or clear
+	 *	its ->mm.
+	 *
+	 * de_thread:
+	 *	It does list_replace_rcu(&leader->tasks, &current->tasks),
+	 *	we must see either old or new leader, this does not matter.
+	 *	However, it can change p->sighand, so lock_task_sighand(p)
+	 *	must be used. Since p->mm != NULL and we hold ->mmap_sem
+	 *	it can't fail.
+	 *
+	 *	Note also that "g" can be the old leader with ->mm == NULL
+	 *	and already unhashed and thus removed from ->thread_group.
+	 *	This is OK, __unhash_process()->list_del_rcu() does not
+	 *	clear the ->next pointer, we will find the new leader via
+	 *	next_thread().
+	 */
 	rcu_read_lock();
 	for_each_process(g) {
 		if (g == tsk->group_leader)
@@ -1544,17 +1573,13 @@ static inline int zap_threads(struct tas
 		do {
 			if (p->mm) {
 				if (p->mm == mm) {
-					/*
-					 * p->sighand can't disappear, but
-					 * may be changed by de_thread()
-					 */
 					lock_task_sighand(p, &flags);
 					zap_process(p);
 					unlock_task_sighand(p, &flags);
 				}
 				break;
 			}
-		} while ((p = next_thread(p)) != g);
+		} while_each_thread(g, p);
 	}
 	rcu_read_unlock();
 done:

