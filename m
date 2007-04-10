Return-Path: <linux-kernel-owner+w=401wt.eu-S1031456AbXDJSw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031456AbXDJSw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 14:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031454AbXDJSw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 14:52:57 -0400
Received: from mail.screens.ru ([213.234.233.54]:46412 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031456AbXDJSw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 14:52:57 -0400
Date: Tue, 10 Apr 2007 22:52:22 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] reparent kernel threads to swapper
Message-ID: <20070410185222.GA107@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A lot of kernel threads parented to /sbin/init slow down do_wait() when
a non-detached (user-space) process exits. Change reparent_kthread() to
use init_task as a parent. Since init_task can't go away, we don't need
to put the caller on init_task.children list.

NOTE: pstree doesn't show kernel threads with this patch.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 2.6.21-rc5/kernel/exit.c~3_SWAPPER	2007-04-10 21:59:41.000000000 +0400
+++ 2.6.21-rc5/kernel/exit.c	2007-04-10 22:25:25.000000000 +0400
@@ -255,11 +255,11 @@ static int has_stopped_jobs(struct pid *
 }
 
 /**
- * reparent_kthread - Reparent the calling kernel thread to the init task of the pid space that the thread belongs to.
+ * reparent_kthread - Reparent the calling kernel thread to swapper.
  *
  * If a kernel thread is launched as a result of a system call, or if
- * it ever exits, it should generally reparent itself to init so that
- * it is correctly cleaned up on exit.
+ * it ever exits, it should generally reparent itself so that it is
+ * correctly cleaned up on exit.
  *
  * The various task state such as scheduling policy and priority may have
  * been inherited from a user process, so we reset them to sane values here.
@@ -272,9 +272,8 @@ void reparent_kthread(void)
 
 	ptrace_unlink(current);
 	remove_parent(current);
-	current->parent = init_pid_ns.child_reaper;
+	current->parent = &init_task;
 	current->real_parent = current->parent;
-	add_parent(current);
 
 	/* make the task auto-reap */
 	current->exit_signal = -1;

