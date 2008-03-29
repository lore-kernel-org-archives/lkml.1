Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbYC2OiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbYC2OiU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 10:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYC2OiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 10:38:09 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:39256 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbYC2OiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 10:38:08 -0400
Date: Sat, 29 Mar 2008 17:37:45 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ptrace children revamp
Message-ID: <20080329143745.GA553@tv-sign.ru>
References: <20080329033412.120EE26FA1D@magilla.localdomain> <20080329033542.BFF4526FA1D@magilla.localdomain> <20080329103929.GB359@tv-sign.ru> <20080329131019.GA472@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080329131019.GA472@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29, Oleg Nesterov wrote:
>
> > -	list_for_each_entry_safe(p, n, &father->ptrace_children, ptrace_list) {
> >  		p->real_parent = reaper;
> > -		reparent_thread(p, father, 1);
> > +		if (p->parent == father) {
> > +			ptrace_unlink(p);
> > +			p->parent = p->real_parent;
> > +		}
> > +		reparent_thread(p, father);
> 
> Unless I missed something again, this is not 100% right.
> 
> Suppose that we are ->real_parent, the child was traced by us, we ignore
> SIGCHLD, and we are doing the threaded reparenting. In that case we should
> release the child if it is dead, like the current code does.
> 
> Even if we don't ignore SIGCHLD, we should notify our thread-group, but
> reparent_thread() skips do_notify_parent() when the new parent is from
> is from the same thread-group.
> 
> Note also that reparent_thread() has a very old bug. When it sees the
> EXIT_ZOMBIE task, it notifies the new parent, but doesn't check if the task
> becomes detached because the new parent ignores SIGCHLD. Currently this means
> that init must have a handler for SIGCHLD or we leak zombies.

Also, I think ptrace_exit() is not right,

	if (p->exit_signal != -1 && !thread_group_empty(p))
		do_notify_parent(p, p->exit_signal);

note the "!thread_group_empty()" above, I guess this is typo, thread group
must be empty if we are going to release the task or notify its parent.


IOW, perhaps something like the patch below makes sense.

Oleg.

--- x/kernel/exit.c~x	2008-03-29 17:14:54.000000000 +0300
+++ x/kernel/exit.c	2008-03-29 17:28:17.000000000 +0300
@@ -596,6 +596,16 @@ static void exit_mm(struct task_struct *
 	mmput(mm);
 }
 
+static void xxx(struct task_struct *p, struct list_head *dead)
+{
+	if (p->exit_state == EXIT_ZOMBIE) {
+		if (p->exit_signal != -1 && thread_group_empty(p))
+			do_notify_parent(p, p->exit_signal);
+		if (p->exit_signal == -1)
+			list_add(&p->ptrace_list, dead);
+	}
+}
+
 /*
  * Detach any ptrace attachees (not our own natural children).
  * Any that need to be release_task'd are put on the @dead list.
@@ -616,12 +626,7 @@ static void ptrace_exit(struct task_stru
 		 * reap itself, add it to the @dead list.  We can't call
 		 * release_task() here because we already hold tasklist_lock.
 		 */
-		if (p->exit_state == EXIT_ZOMBIE) {
-			if (p->exit_signal != -1 && !thread_group_empty(p))
-				do_notify_parent(p, p->exit_signal);
-			if (p->exit_signal == -1)
-				list_add(&p->ptrace_list, dead);
-		}
+		 xxx(p, dead);
 	}
 }
 
@@ -661,13 +666,6 @@ static void reparent_thread(struct task_
 	if (p->exit_signal != -1)
 		p->exit_signal = SIGCHLD;
 
-	/* If we'd notified the old parent about this child's death,
-	 * also notify the new parent.
-	 */
-	if (p->exit_state == EXIT_ZOMBIE &&
-	    p->exit_signal != -1 && thread_group_empty(p))
-		do_notify_parent(p, p->exit_signal);
-
 	/*
 	 * process group orphan check
 	 * Case ii: Our child is in a different pgrp
@@ -720,6 +718,7 @@ static void forget_original_parent(struc
 			p->parent = p->real_parent;
 		}
 		reparent_thread(p, father);
+		xxx(p, &ptrace_dead);
 	}
 
 	write_unlock_irq(&tasklist_lock);

