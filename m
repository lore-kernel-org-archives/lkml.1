Return-Path: <linux-kernel-owner+w=401wt.eu-S1760615AbZCSWZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760615AbZCSWZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 18:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbZCSWY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 18:24:59 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43588 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809AbZCSWY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 18:24:59 -0400
To: roland@redhat.com
CC: peterz@infradead.org, efault@gmx.de, rjw@sisk.pl, jdike@addtoit.com,
       mingo@elte.hu, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [patch] fix uml slowness caused by ptrace preemption bug on host
Message-Id: <E1LkQeU-00020Z-Be@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 19 Mar 2009 23:23:50 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

This patch fixes bug #12208.

This turned out to be not a scheduler regression, but an already
existing problem in ptrace being triggered by subtle scheduler
changes.

The problem is this:

 - task A is ptracing task B
 - task B stops on a trace event
 - task A is woken up and preempts task B
 - task A calls ptrace on task B, which does ptrace_check_attach()
 - this calls wait_task_inactive(), which sees that task B is still on the runq
 - task A goes to sleep for a jiffy
 - ...

Since UML does lots of the above sequences, those jiffies quickly add
up to make it slow as hell.

This patch solves this by not scheduling on preempt_enable() after
ptrace_stop() has woken up the tracer.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 kernel/signal.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux.git/kernel/signal.c
===================================================================
--- linux.git.orig/kernel/signal.c	2009-03-19 22:48:59.000000000 +0100
+++ linux.git/kernel/signal.c	2009-03-19 22:54:22.000000000 +0100
@@ -1572,10 +1572,16 @@ static void ptrace_stop(int exit_code, i
 	/* Let the debugger run.  */
 	__set_current_state(TASK_TRACED);
 	spin_unlock_irq(&current->sighand->siglock);
+	preempt_disable();
 	read_lock(&tasklist_lock);
 	if (may_ptrace_stop()) {
 		do_notify_parent_cldstop(current, CLD_TRAPPED);
 		read_unlock(&tasklist_lock);
+		/*
+		 * Don't want to allow preemption here, because
+		 * sys_ptrace() needs this task to be inactive.
+		 */
+		preempt_enable_no_resched();
 		schedule();
 	} else {
 		/*
@@ -1586,6 +1592,7 @@ static void ptrace_stop(int exit_code, i
 		if (clear_code)
 			current->exit_code = 0;
 		read_unlock(&tasklist_lock);
+		preempt_enable();
 	}
 
 	/*
