Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbXKQUgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbXKQUgW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 15:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbXKQUgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 15:36:07 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34780 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbXKQUgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 15:36:06 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] task_pid_nr_ns() breaks proc_pid_readdir()
References: <20071117181549.GA1415@tv-sign.ru>
Date: Sat, 17 Nov 2007 13:35:05 -0700
In-Reply-To: <20071117181549.GA1415@tv-sign.ru> (Oleg Nesterov's message of
	"Sat, 17 Nov 2007 21:15:49 +0300")
Message-ID: <m1bq9swqyu.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> proc_pid_readdir:
>
> 	for (...; ...; task = next_tgid(tgid + 1, ns)) {
> 		tgid = task_pid_nr_ns(task, ns);
> 		... use tgid ...
>
> The first problem is that task_pid_nr_ns() can race with RCU and read the
> freed memory.
>
> However, rcu_read_lock() can't help. next_tgid() returns a pinned task_struct,
> but the task can be released (and it's pid detached) before task_pid_nr_ns()
> reads the pid_t value. In that case task_pid_nr_ns() returns 0 thus breaking
> the whole logic.
>
> Make sure that task_pid_nr_ns() returns !0 before updating tgid. Note that
> next_tgid(tgid + 1) can find the same "struct pid" again, but we shouldn't
> go into the endless loop because pid_task(PIDTYPE_PID) must return NULL in
> this case, so next_tgid() can't return the same task.
>
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Oleg I think I would rather update next_tgid to return the tgid (which
removes the need to call task_pid_nr_ns).  This keeps all of the task
iteration logic together in next_tgid.

Although looking at this in more detail, I'm half wondering if
proc_pid_make_inode() should take a struct pid instead of a task.
At first glance that looks like it might be a little simple and more
race free.  Although it doesn't do any favors to:
> 	inode->i_gid = 0;
> 	if (task_dumpable(task)) {
> 		inode->i_uid = task->euid;
> 		inode->i_gid = task->egid;
> 	}
> 	security_task_to_inode(task, inode);

Anyway short of rewriting the world this is what updating next_tgid
looks like.  Opinions?

Eric


diff --git a/fs/proc/base.c b/fs/proc/base.c
index a17c268..5d9328d 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2411,7 +2411,7 @@ out:
  * Find the first task with tgid >= tgid
  *
  */
-static struct task_struct *next_tgid(unsigned int tgid,
+static struct task_struct *next_tgid(unsigned int *tgid,
 		struct pid_namespace *ns)
 {
 	struct task_struct *task;
@@ -2420,9 +2420,9 @@ static struct task_struct *next_tgid(unsigned int tgid,
 	rcu_read_lock();
 retry:
 	task = NULL;
-	pid = find_ge_pid(tgid, ns);
+	pid = find_ge_pid(*tgid, ns);
 	if (pid) {
-		tgid = pid_nr_ns(pid, ns) + 1;
+		*tgid = pid_nr_ns(pid, ns);
 		task = pid_task(pid, PIDTYPE_PID);
 		/* What we to know is if the pid we have find is the
 		 * pid of a thread_group_leader.  Testing for task
@@ -2436,8 +2436,10 @@ retry:
 		 * found doesn't happen to be a thread group leader.
 		 * As we don't care in the case of readdir.
 		 */
-		if (!task || !has_group_leader_pid(task))
+		if (!task || !has_group_leader_pid(task)) {
+			*tgid += 1;
 			goto retry;
+		}
 		get_task_struct(task);
 	}
 	rcu_read_unlock();
@@ -2475,10 +2477,9 @@ int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)
 
 	ns = filp->f_dentry->d_sb->s_fs_info;
 	tgid = filp->f_pos - TGID_OFFSET;
-	for (task = next_tgid(tgid, ns);
+	for (task = next_tgid(&tgid, ns);
 	     task;
-	     put_task_struct(task), task = next_tgid(tgid + 1, ns)) {
-		tgid = task_pid_nr_ns(task, ns);
+	     put_task_struct(task), tgid += 1, task = next_tgid(&tgid, ns)) {
 		filp->f_pos = tgid + TGID_OFFSET;
 		if (proc_pid_fill_cache(filp, dirent, filldir, task, tgid) < 0) {
 			put_task_struct(task);
