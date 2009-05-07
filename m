Return-Path: <linux-kernel-owner+w=401wt.eu-S1758574AbZEGGwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574AbZEGGwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 02:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904AbZEGGvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 02:51:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58719 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858AbZEGGvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 02:51:39 -0400
Date: Thu, 7 May 2009 08:46:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] do_wait: fix the theoretical race with stop/trace/cont
Message-ID: <20090507064650.GA15878@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_wait:

	current->state = TASK_INTERRUPTIBLE;

	read_lock(&tasklist_lock);
	... search for the task to reap ...

In theory, the ->state changing can leak into the critical section.
Since the child can change its status under read_lock(tasklist) in
parallel (finish_stop/ptrace_stop), we can miss the wakeup if
__wake_up_parent() sees us in TASK_RUNNING state. Add the barrier.

Also, use __set_current_state() to set TASK_RUNNING.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- PTRACE/kernel/exit.c~5_MB	2009-05-07 05:34:40.000000000 +0200
+++ PTRACE/kernel/exit.c	2009-05-07 05:43:06.000000000 +0200
@@ -1581,7 +1581,7 @@ repeat:
 	   (!wo->wo_pid || hlist_empty(&wo->wo_pid->tasks[wo->wo_type])))
 		goto notask;
 
-	current->state = TASK_INTERRUPTIBLE;
+	set_current_state(TASK_INTERRUPTIBLE);
 	read_lock(&tasklist_lock);
 	tsk = current;
 	do {
@@ -1608,7 +1608,7 @@ notask:
 		}
 	}
 end:
-	current->state = TASK_RUNNING;
+	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&current->signal->wait_chldexit,&wait);
 	if (wo->wo_info) {
 		struct siginfo __user *infop = wo->wo_info;

