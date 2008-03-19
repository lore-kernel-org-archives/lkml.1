Return-Path: <linux-kernel-owner+w=401wt.eu-S941803AbYCSW5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941803AbYCSW5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966327AbYCSVYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:24:12 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:33591 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765977AbYCSVYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:24:09 -0400
Date: Wed, 19 Mar 2008 17:36:27 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: rfc, leader_pid_type()
Message-ID: <20080319143627.GA4199@tv-sign.ru>
References: <20080318153811.GA3488@tv-sign.ru> <m18x0fvh5d.fsf@ebiederm.dsl.xmission.com> <20080318221552.GA143@tv-sign.ru> <m13aqnvdnk.fsf@ebiederm.dsl.xmission.com> <20080319003112.GA183@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080319003112.GA183@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19, Oleg Nesterov wrote:
>
> On 03/18, Eric W. Biederman wrote:
> >
> > Oleg Nesterov <oleg@tv-sign.ru> writes:
> > 
> > > On 03/18, Eric W. Biederman wrote:
> > >>
> > >> Any chance we can make de_thread rcu safe?
> > >> 
> > >> We are very close.
> > >> 
> > >> It would take a double check but I believe all we need to do is to
> > >> modify detach_pid to remove link->pid.  This of course messes up
> > >> pid_alive but otherwise we should be ok if we have a big fat comment.
> > >
> > > Not sure I understand... detach_pid(type) already sets
> > >
> > > 	task->pids[type].pid = NULL;
> > 
> > Sorry.  I meant to remove that line that clears task->pids[type].pid 
> > If we don't set .pid to NULL we can still dereference while the task_struct
> > is rcu reachable.

To clarify: we can't change detach_pid() and remove the line that clears
task->pids[type].pid right now. Look for example at get_task_pid(), it
could be used without rcu, using the previously pinned task_struct.

But in the long term this might be right.

(As for pid_alive(). Can't we rename it? Its name is very misleading, and it
 shouldn't play with ->pids, this looks confusing. Just do p->sighand != 0)

> !!!!! Yes you are right.
> 
> No, we don't need to change detach_pid(), but we can change transfer_pid()
> and kill this line:
> 
> 	old->pids[type].pid = NULL;
> 
> this can't break de_thread()->release_task(leader)->__unhash_process()
> because leader is not group_leader() any longer.
> 
> And with this change we can't see task_session() == NULL under rcu_read_lock()
> during exec, great!
> 
> And. this doesn't break do_each_pid_task(PIDTYPE_SID), we can't see both
> old and new leaders.
> 
> > >> We might need to replace the detach_pid, attach_pid sequence in
> > >> __set_special_pids with an optimized sequence like transfer_pid
> > >> call it replace_pid where we guarantee there is always a valid pid
> > >> pointer in the group_leader.
> > >
> > > OK... I think you are right... good point.
> 
> Yes, good point. Except we need a couple of subtle but straightforward
> changes, but I think this change worth it.

Something like the patch below. What do you think? setsid/setpgrp now
can use change_pid(). The change in transfer_pid() needs a separate
patch with the fat changelog.

This doesn't solve the problem with task_tgid() == NULL, but at least
this is not possible with task == current.

Oleg.

--- 25/kernel/pid.c~1_PID_CHANGE	2008-02-16 17:51:17.000000000 +0300
+++ 25/kernel/pid.c	2008-03-19 17:15:15.000000000 +0300
@@ -317,29 +317,25 @@ EXPORT_SYMBOL_GPL(find_pid);
 /*
  * attach_pid() must be called with the tasklist_lock write-held.
  */
-int attach_pid(struct task_struct *task, enum pid_type type,
-		struct pid *pid)
+int attach_pid(struct task_struct *task, enum pid_type type, struct pid *pid)
 {
-	struct pid_link *link;
+	struct pid_link *link = &task->pids[type];
 
-	link = &task->pids[type];
 	link->pid = pid;
-	hlist_add_head_rcu(&link->node, &pid->tasks[type]);
+	if (likely(pid != NULL))
+		hlist_add_head_rcu(&link->node, &pid->tasks[type]);
 
 	return 0;
 }
 
-void detach_pid(struct task_struct *task, enum pid_type type)
+void change_pid(struct task_struct *task, enum pid_type type, struct pid *new)
 {
-	struct pid_link *link;
-	struct pid *pid;
+	struct pid_link *link = &task->pids[type];
+	struct pid *pid = link->pid;
 	int tmp;
 
-	link = &task->pids[type];
-	pid = link->pid;
-
 	hlist_del_rcu(&link->node);
-	link->pid = NULL;
+	attach_pid(task, type, new);
 
 	for (tmp = PIDTYPE_MAX; --tmp >= 0; )
 		if (!hlist_empty(&pid->tasks[tmp]))
@@ -348,13 +344,17 @@ void detach_pid(struct task_struct *task
 	free_pid(pid);
 }
 
+void detach_pid(struct task_struct *task, enum pid_type type)
+{
+	change_pid(task, type, NULL);
+}
+
 /* transfer_pid is an optimization of attach_pid(new), detach_pid(old) */
 void transfer_pid(struct task_struct *old, struct task_struct *new,
 			   enum pid_type type)
 {
 	new->pids[type].pid = old->pids[type].pid;
 	hlist_replace_rcu(&old->pids[type].node, &new->pids[type].node);
-	old->pids[type].pid = NULL;
 }
 
 struct task_struct *pid_task(struct pid *pid, enum pid_type type)

