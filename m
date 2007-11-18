Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbXKROUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbXKROUx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 09:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbXKROUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 09:20:44 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:44489 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604AbXKROUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 09:20:43 -0500
Date: Sun, 18 Nov 2007 17:20:47 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] task_pid_nr_ns() breaks proc_pid_readdir()
Message-ID: <20071118142047.GA360@tv-sign.ru>
References: <20071117181549.GA1415@tv-sign.ru> <m1bq9swqyu.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bq9swqyu.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
> > Make sure that task_pid_nr_ns() returns !0 before updating tgid. Note that
> > next_tgid(tgid + 1) can find the same "struct pid" again, but we shouldn't
> > go into the endless loop because pid_task(PIDTYPE_PID) must return NULL in
> > this case, so next_tgid() can't return the same task.
> >
> Oleg I think I would rather update next_tgid to return the tgid (which
> removes the need to call task_pid_nr_ns).  This keeps all of the task
> iteration logic together in next_tgid.

Yes sure, I think your patch is also correct, please use it.

<offtopic>

Personally, I hate the functions which use pointers to return another value.
(yes, yes, I know, my taste is perverted). Why don't we return structure in
this case? We can even make a common helper struct, say,

	struct pair {
		union {
			long val1;
			void *ptr1;
		};
		union {
			long val2;
			void *ptr2;
		};
	};

	#define PAIR(x1, x2)	(struct pair){{ . x1 }, { . x2 }}

Now, next_tgid() can do

	return PAIR(ptr1 = task, val2 = tgid);

With -freg-struct-return the generated code is nice.

Of course, another option is to rewrite the kernle in perl, in that case
proc_pid_readdir() can just do

	(task, tgid) = next_tgid();

</offtopic>

> Although looking at this in more detail, I'm half wondering if
> proc_pid_make_inode() should take a struct pid instead of a task.

Yes, I also thought about this. Needs more changes, and still not perfect.

I am starting to think we need a more generic change. How about the patch
below? With this change the stable task_struct implies we have the stable
pids, this allows us to do a lot of cleanups.

Oleg.

--- kernel/pid.c	2007-10-25 16:22:12.000000000 +0400
+++ -	2007-11-18 16:56:30.682555454 +0300
@@ -323,7 +323,7 @@ int fastcall attach_pid(struct task_stru
 	struct pid_link *link;
 
 	link = &task->pids[type];
-	link->pid = pid;
+	link->pid = get_pid(pid);
 	hlist_add_head_rcu(&link->node, &pid->tasks[type]);
 
 	return 0;
@@ -339,7 +339,6 @@ void fastcall detach_pid(struct task_str
 	pid = link->pid;
 
 	hlist_del_rcu(&link->node);
-	link->pid = NULL;
 
 	for (tmp = PIDTYPE_MAX; --tmp >= 0; )
 		if (!hlist_empty(&pid->tasks[tmp]))
@@ -348,6 +347,14 @@ void fastcall detach_pid(struct task_str
 	free_pid(pid);
 }
 
+void task_put_pids(struct pid_link *pids)
+{
+	int type = PIDTYPE_MAX;
+
+	while (type--)
+		put_pid(pids[type].pid);
+}
+
 /* transfer_pid is an optimization of attach_pid(new), detach_pid(old) */
 void fastcall transfer_pid(struct task_struct *old, struct task_struct *new,
 			   enum pid_type type)
--- kernel/fork.c	2007-11-09 12:57:31.000000000 +0300
+++ -	2007-11-18 16:57:34.037105563 +0300
@@ -121,6 +121,7 @@ void __put_task_struct(struct task_struc
 	WARN_ON(atomic_read(&tsk->usage));
 	WARN_ON(tsk == current);
 
+	task_put_pids(tsk->pids);
 	security_task_free(tsk);
 	free_uid(tsk->user);
 	put_group_info(tsk->group_info);

