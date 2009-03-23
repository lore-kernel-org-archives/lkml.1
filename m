Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbZCWPHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbZCWPHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757874AbZCWPHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:07:38 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43428 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757085AbZCWPHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:07:37 -0400
To: linux-kernel@vger.kernel.org
CC: mingo@elte.hu, oleg@redhat.com, peterz@infradead.org, roland@redhat.com,
       efault@gmx.de, rjw@sisk.pl, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       stable@kernel.org
Subject: [patch] fix ptrace slowness
Message-Id: <E1LllkK-0000zF-1h@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 23 Mar 2009 16:07:24 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one incorporates comments from Oleg and Ingo.  Please apply to
2.6.29 and 2.6.2[78]-stable trees.

Thanks,
Miklos
----

From: Miklos Szeredi <mszeredi@suse.cz>

This patch fixes bug #12208:

  Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12208
  Subject         : uml is very slow on 2.6.28 host

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

This patch solves this by not rescheduling in read_unlock() after
ptrace_stop() has woken up the tracer.

Thanks to Oleg Nesterov and Ingo Molnar for the feedback.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: stable@kernel.org
---
 kernel/signal.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux.git/kernel/signal.c
===================================================================
--- linux.git.orig/kernel/signal.c	2009-03-20 09:41:04.000000000 +0100
+++ linux.git/kernel/signal.c	2009-03-23 15:40:57.000000000 +0100
@@ -1575,7 +1575,15 @@ static void ptrace_stop(int exit_code, i
 	read_lock(&tasklist_lock);
 	if (may_ptrace_stop()) {
 		do_notify_parent_cldstop(current, CLD_TRAPPED);
+		/*
+		 * Don't want to allow preemption here, because
+		 * sys_ptrace() needs this task to be inactive.
+		 *
+		 * XXX: implement read_unlock_no_resched().
+		 */
+		preempt_disable();
 		read_unlock(&tasklist_lock);
+		preempt_enable_no_resched();
 		schedule();
 	} else {
 		/*
