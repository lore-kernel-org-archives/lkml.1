Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbZGBR2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbZGBR2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbZGBR23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:28:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39107 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbZGBR22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:28:28 -0400
Date: Thu, 2 Jul 2009 19:25:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ratan Nalumasu <rnalumasu@gmail.com>,
       Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] change __wake_up_parent() to use filtered wakeup
Message-ID: <20090702172511.GA24089@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ratan Nalumasu reported that in a process with many threads doing
unnecessary wakeups.  Every waiting thread in the process wakes up to loop
through the children and see that the only ones it cares about are still
not ready.

Now that we have struct wait_opts we can change do_wait/__wake_up_parent
to use filtered wakeups.

We can make child_wait_callback() more clever later, right now it only
checks eligible_child().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exit.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- WAIT/kernel/exit.c~2_WAKE_PARENT	2009-07-02 18:29:24.000000000 +0200
+++ WAIT/kernel/exit.c	2009-07-02 18:38:03.000000000 +0200
@@ -1089,6 +1089,7 @@ struct wait_opts {
 	int __user		*wo_stat;
 	struct rusage __user	*wo_rusage;
 
+	wait_queue_t		child_wait;
 	int			notask_error;
 };
 
@@ -1558,20 +1559,35 @@ static int ptrace_do_wait(struct wait_op
 	return 0;
 }
 
+static int child_wait_callback(wait_queue_t *wait, unsigned mode,
+				int sync, void *key)
+{
+	struct wait_opts *wo = container_of(wait, struct wait_opts,
+						child_wait);
+	struct task_struct *p = key;
+
+	if (!eligible_child(wo, p))
+		return 0;
+
+	return default_wake_function(wait, mode, sync, key);
+}
+
 void __wake_up_parent(struct task_struct *p, struct task_struct *parent)
 {
-	wake_up_interruptible_sync(&parent->signal->wait_chldexit);
+	__wake_up_sync_key(&parent->signal->wait_chldexit,
+				TASK_INTERRUPTIBLE, 1, p);
 }
 
 static long do_wait(struct wait_opts *wo)
 {
-	DECLARE_WAITQUEUE(wait, current);
 	struct task_struct *tsk;
 	int retval;
 
 	trace_sched_process_wait(wo->wo_pid);
 
-	add_wait_queue(&current->signal->wait_chldexit,&wait);
+	init_waitqueue_func_entry(&wo->child_wait, child_wait_callback);
+	wo->child_wait.private = current;
+	add_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
 repeat:
 	/*
 	 * If there is nothing that can match our critiera just get out.
@@ -1612,7 +1628,8 @@ notask:
 	}
 end:
 	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&current->signal->wait_chldexit,&wait);
+	remove_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
+
 	if (wo->wo_info) {
 		struct siginfo __user *infop = wo->wo_info;
 

