Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbYCBSld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbYCBSld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 13:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYCBSlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 13:41:08 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:44216 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbYCBSlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 13:41:07 -0500
Date: Sun, 2 Mar 2008 21:44:42 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@redhat.com>, Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] will_become_orphaned_pgrp: partially fix insufficient ->exit_state check
Message-ID: <20080302184442.GA16368@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

p->exit_state != 0 doesn't mean this process is dead, it may have sub-threads.
Change the code to use "p->exit_state && thread_group_empty(p)" instead.

Without this patch, ^Z doesn't deliver SIGTSTP to the foreground process if
the main thread has exited.

However, the new check is not perfect too. There is a window when exit_notify()
drops tasklist and before release_task(). Suppose that the last (non-leader)
thread exits. This means that entire group exits, but thread_group_empty() is
not true yet.

As Eric pointed out, is_global_init() is wrong as well, but I did not dare to
do other changes.

Just for the record, has_stopped_jobs() is absolutely wrong too. But we can't
fix it now, we should first fix SIGNAL_STOP_STOPPED issues.

And. Even with this patch ^Z doesn't play well with the dead main thread. The
task is stopped correctly but do_wait(WSTOPPED) can't see it. This is another
unrelated issue, will be (hopefully) fixed separately.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/exit.c~2_WBOP	2008-03-02 19:18:58.000000000 +0300
+++ 25/kernel/exit.c	2008-03-02 19:42:56.000000000 +0300
@@ -214,20 +214,19 @@ struct pid *session_of_pgrp(struct pid *
 static int will_become_orphaned_pgrp(struct pid *pgrp, struct task_struct *ignored_task)
 {
 	struct task_struct *p;
-	int ret = 1;
 
 	do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
-		if (p == ignored_task
-				|| p->exit_state
-				|| is_global_init(p->real_parent))
+		if ((p == ignored_task) ||
+		    (p->exit_state && thread_group_empty(p)) ||
+		    is_global_init(p->real_parent))
 			continue;
+
 		if (task_pgrp(p->real_parent) != pgrp &&
-		    task_session(p->real_parent) == task_session(p)) {
-			ret = 0;
-			break;
-		}
+		    task_session(p->real_parent) == task_session(p))
+			return 0;
 	} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
-	return ret;	/* (sighing) "Often!" */
+
+	return 1;
 }
 
 int is_current_pgrp_orphaned(void)

