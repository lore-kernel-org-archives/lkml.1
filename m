Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbZCTJpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbZCTJpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 05:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbZCTJot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 05:44:49 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55023 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZCTJot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 05:44:49 -0400
To: mingo@elte.hu
Cc: peterz@infradead.org, roland@redhat.com, efault@gmx.de, rjw@sisk.pl,
       jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
Subject: [patch] don't preempt not TASK_RUNNING tasks
Message-Id: <E1LkbGe-00039U-Hc@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 20 Mar 2009 10:43:56 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

I tested this one, and I think it makes sense in any case as an
optimization.  It should also be good for -stable kernels.

Does it look OK?

Thanks,
Miklos
----

From: Miklos Szeredi <mszeredi@suse.cz>

This patch fixes bug #12208:

  http://bugzilla.kernel.org/show_bug.cgi?id=12208

Don't preempt tasks in preempt_schedule() if they are already in the
process of going to sleep.  Otherwise the task would wake up only to
go to sleep again.

Due to the way wait_task_inactive() works this can also drastically
slow down ptrace:

 - task A is ptracing task B
 - task B stops on a trace event
 - task A is woken up and preempts task B
 - task A calls ptrace on task B, which does ptrace_check_attach()
 - this calls wait_task_inactive(), which sees that task B is still on the runq
 - task A goes to sleep for a jiffy
 - ...

Since UML does lots of the above sequences, those jiffies quickly add
up to make it slow as hell.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: stable@kernel.org
---
 kernel/sched.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux.git/kernel/sched.c
===================================================================
--- linux.git.orig/kernel/sched.c	2009-03-20 09:40:47.000000000 +0100
+++ linux.git/kernel/sched.c	2009-03-20 10:28:56.000000000 +0100
@@ -4632,6 +4632,10 @@ asmlinkage void __sched preempt_schedule
 	if (likely(ti->preempt_count || irqs_disabled()))
 		return;
 
+	/* No point in preempting we are just about to go to sleep. */
+	if (current->state != TASK_RUNNING)
+		return;
+
 	do {
 		add_preempt_count(PREEMPT_ACTIVE);
 		schedule();
