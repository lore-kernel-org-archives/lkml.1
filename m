Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbZEYU0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbZEYU0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 16:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbZEYU0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 16:26:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45969 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbZEYU0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 16:26:36 -0400
Date: Mon, 25 May 2009 22:21:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ptrace: wait_task_zombie: s/->parent/->real_parent/
Message-ID: <20090525202145.GA25243@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change wait_task_zombie() to use ->real_parent instead of ->parent.
We could even use current afaics, but ->real_parent is more clean.

We know that the child is not ptrace_reparented() and thus they are
equal. But we should avoid using task_struct->parent, we are going
to remove it.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- PTRACE/kernel/exit.c~WAIT_NO_PARENT	2009-05-25 20:24:50.000000000 +0200
+++ PTRACE/kernel/exit.c	2009-05-25 21:47:24.000000000 +0200
@@ -1210,7 +1210,7 @@ static int wait_task_zombie(struct wait_
 		 * p->signal fields, because they are only touched by
 		 * __exit_signal, which runs with tasklist_lock
 		 * write-locked anyway, and so is excluded here.  We do
-		 * need to protect the access to p->parent->signal fields,
+		 * need to protect the access to parent->signal fields,
 		 * as other threads in the parent group can be right
 		 * here reaping other children at the same time.
 		 *
@@ -1219,8 +1219,8 @@ static int wait_task_zombie(struct wait_
 		 * group including the group leader.
 		 */
 		thread_group_cputime(p, &cputime);
-		spin_lock_irq(&p->parent->sighand->siglock);
-		psig = p->parent->signal;
+		spin_lock_irq(&p->real_parent->sighand->siglock);
+		psig = p->real_parent->signal;
 		sig = p->signal;
 		psig->cutime =
 			cputime_add(psig->cutime,
@@ -1251,7 +1251,7 @@ static int wait_task_zombie(struct wait_
 			sig->oublock + sig->coublock;
 		task_io_accounting_add(&psig->ioac, &p->ioac);
 		task_io_accounting_add(&psig->ioac, &sig->ioac);
-		spin_unlock_irq(&p->parent->sighand->siglock);
+		spin_unlock_irq(&p->real_parent->sighand->siglock);
 	}
 
 	/*

