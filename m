Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbZF2Gxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbZF2Gxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 02:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbZF2Gxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 02:53:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50386 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbZF2Gxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 02:53:40 -0400
Date: Mon, 29 Jun 2009 05:38:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ratan Nalumasu <rnalumasu@gmail.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 2/2] change __wake_up_parent() to use filtered
	wakeup
Message-ID: <20090629033852.GA14404@redhat.com>
References: <20090622170437.GA4906@redhat.com> <20090624091316.73D0F4059B@magilla.sf.frob.com> <20090624152143.GB23848@redhat.com> <20090624185701.AA74C4059B@magilla.sf.frob.com> <20090624161111.GA27890@redhat.com> <20090624194239.A29174059B@magilla.sf.frob.com> <20090624171357.GA30435@redhat.com> <20090624205112.3EA944059B@magilla.sf.frob.com> <93ad5f3f0906252111n48742b9ax8dc2ad35b30f4292@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93ad5f3f0906252111n48742b9ax8dc2ad35b30f4292@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25, Ratan Nalumasu wrote:
>
> I understood it in the _past_, but somehow forgotten the details--I have a
> vague recollection that there was some special handling for the group leader
> stuff.
> However, to reconfirm, we believe that the
> following condition in eligible_child() is good, right:
> ===
>        if ((wo->wo_flags & __WNOTHREAD) && wo->child_wait.private !=
> p->parent)
>                return 0;
> ===
>
> I will run it on my test machines and see if everything looks good.

OK, thanks.

The only problem it uses ->parent, this conflicts with other out-of-tree
ptrace changes...

Roland, do you think we should do this change now or later?

If now, then we can also do another nice optimization, and it is for free.
See the untested patch below. It conflicts with those patches too, but
in both cases fixups are trivial.

Oleg.

------------------------------------------------------------------------
[PATCH] do not place sub-threads on task_struct->children list

Currently we add sub-threads to ->real_parent->children list. This
buys nothing but slows down do_wait().

With this patch ->children contains only main threads (group leaders).
The only complication is that forget_original_parent() should iterate
over sub-threads by hand. (note that we can move reparent_thread()
outside of while_each_thread() loop and simplify the code further).

>From now do_wait_thread() can never see task_detached() && !EXIT_DEAD
tasks, we can remove this check. (note that now we can unify
do_wait_thread() and ptrace_do_wait()).

This change can confuse the optimistic search inmm_update_next_owner(),
but this is fixable and minor.

Perhaps badness() and oom_kill_process() should be updated, but they
should be fixed in any case.

Do you see any problems?

---

 kernel/fork.c |    2 +-
 kernel/exit.c |   36 +++++++++++++++++-------------------
 2 files changed, 18 insertions(+), 20 deletions(-)

--- WAIT/kernel/fork.c~3_CHILDREN_NO_THREADS	2009-06-19 01:12:47.000000000 +0200
+++ WAIT/kernel/fork.c	2009-06-29 04:30:34.000000000 +0200
@@ -1245,7 +1245,6 @@ static struct task_struct *copy_process(
 	}
 
 	if (likely(p->pid)) {
-		list_add_tail(&p->sibling, &p->real_parent->children);
 		tracehook_finish_clone(p, clone_flags, trace);
 
 		if (thread_group_leader(p)) {
@@ -1257,6 +1256,7 @@ static struct task_struct *copy_process(
 			p->signal->tty = tty_kref_get(current->signal->tty);
 			attach_pid(p, PIDTYPE_PGID, task_pgrp(current));
 			attach_pid(p, PIDTYPE_SID, task_session(current));
+			list_add_tail(&p->sibling, &p->real_parent->children);
 			list_add_tail_rcu(&p->tasks, &init_task.tasks);
 			__get_cpu_var(process_counts)++;
 		}
--- WAIT/kernel/exit.c~3_CHILDREN_NO_THREADS	2009-06-24 17:36:28.000000000 +0200
+++ WAIT/kernel/exit.c	2009-06-29 04:47:21.000000000 +0200
@@ -67,11 +67,11 @@ static void __unhash_process(struct task
 		detach_pid(p, PIDTYPE_PGID);
 		detach_pid(p, PIDTYPE_SID);
 
+		list_del_init(&p->sibling);
 		list_del_rcu(&p->tasks);
 		__get_cpu_var(process_counts)--;
 	}
 	list_del_rcu(&p->thread_group);
-	list_del_init(&p->sibling);
 }
 
 /*
@@ -742,10 +742,10 @@ static void reparent_thread(struct task_
 	if (p->pdeath_signal)
 		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
 
-	list_move_tail(&p->sibling, &p->real_parent->children);
-
 	if (task_detached(p))
 		return;
+
+	list_move_tail(&p->sibling, &p->real_parent->children);
 	/*
 	 * If this is a threaded reparent there is no need to
 	 * notify anyone anything has happened.
@@ -771,7 +771,7 @@ static void reparent_thread(struct task_
 
 static void forget_original_parent(struct task_struct *father)
 {
-	struct task_struct *p, *n, *reaper;
+	struct task_struct *g, *p, *n, *reaper;
 	LIST_HEAD(dead_children);
 
 	exit_ptrace(father);
@@ -779,13 +779,16 @@ static void forget_original_parent(struc
 	write_lock_irq(&tasklist_lock);
 	reaper = find_new_reaper(father);
 
-	list_for_each_entry_safe(p, n, &father->children, sibling) {
-		p->real_parent = reaper;
-		if (p->parent == father) {
-			BUG_ON(task_ptrace(p));
-			p->parent = p->real_parent;
-		}
-		reparent_thread(father, p, &dead_children);
+	list_for_each_entry_safe(g, n, &father->children, sibling) {
+		p = g;
+		do {
+			p->real_parent = reaper;
+			if (p->parent == father) {
+				BUG_ON(task_ptrace(p));
+				p->parent = p->real_parent;
+			}
+			reparent_thread(father, p, &dead_children);
+		} while_each_thread(g, p);
 	}
 	write_unlock_irq(&tasklist_lock);
 
@@ -1533,14 +1536,9 @@ static int do_wait_thread(struct wait_op
 	struct task_struct *p;
 
 	list_for_each_entry(p, &tsk->children, sibling) {
-		/*
-		 * Do not consider detached threads.
-		 */
-		if (!task_detached(p)) {
-			int ret = wait_consider_task(wo, tsk, 0, p);
-			if (ret)
-				return ret;
-		}
+		int ret = wait_consider_task(wo, tsk, 0, p);
+		if (ret)
+			return ret;
 	}
 
 	return 0;

