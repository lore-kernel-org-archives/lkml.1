Return-Path: <linux-kernel-owner+w=401wt.eu-S933160AbYCDS6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160AbYCDS6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932900AbYCDSyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:54:46 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:50755 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765974AbYCDSyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:54:45 -0500
Date: Tue, 4 Mar 2008 21:57:45 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Jiri Kosina <jkosina@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: [RFC,PATCH 2/2] kill_pid_info: don't take now unneeded tasklist_lock
Message-ID: <20080304185745.GA8482@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously handle_stop_signal(SIGCONT) could drop ->siglock. That is why
kill_pid_info(SIGCONT) takes tasklist_lock to make sure the target task
can't go away after unlock. Not needed now.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/include/linux/signal.h~1__KILL_NO_TASKLIST	2008-02-15 16:59:17.000000000 +0300
+++ 25/include/linux/signal.h	2008-03-04 21:43:25.000000000 +0300
@@ -362,8 +362,6 @@ int unhandled_signal(struct task_struct 
 #define sig_kernel_stop(sig) \
 	(((sig) < SIGRTMIN) && siginmask(sig, SIG_KERNEL_STOP_MASK))
 
-#define sig_needs_tasklist(sig)	((sig) == SIGCONT)
-
 #define sig_user_defined(t, signr) \
 	(((t)->sighand->action[(signr)-1].sa.sa_handler != SIG_DFL) &&	\
 	 ((t)->sighand->action[(signr)-1].sa.sa_handler != SIG_IGN))
--- 25/kernel/signal.c~1__KILL_NO_TASKLIST	2008-03-04 21:24:20.000000000 +0300
+++ 25/kernel/signal.c	2008-03-04 21:44:58.000000000 +0300
@@ -1030,9 +1030,6 @@ int kill_pid_info(int sig, struct siginf
 	struct task_struct *p;
 
 	rcu_read_lock();
-	if (unlikely(sig_needs_tasklist(sig)))
-		read_lock(&tasklist_lock);
-
 retry:
 	p = pid_task(pid, PIDTYPE_PID);
 	if (p) {
@@ -1046,10 +1043,8 @@ retry:
 			 */
 			goto retry;
 	}
-
-	if (unlikely(sig_needs_tasklist(sig)))
-		read_unlock(&tasklist_lock);
 	rcu_read_unlock();
+
 	return error;
 }
 

