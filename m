Return-Path: <linux-kernel-owner+w=401wt.eu-S1754454AbXKSVqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbXKSVqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 16:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbXKSVqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 16:46:01 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53771 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbXKSVqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 16:46:00 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] proc: Remove races from proc_id_readdir()
References: <20071117181549.GA1415@tv-sign.ru>
	<m1bq9swqyu.fsf@ebiederm.dsl.xmission.com>
	<20071118142047.GA360@tv-sign.ru>
	<m1tzniumoo.fsf@ebiederm.dsl.xmission.com>
	<20071119182937.GA89@tv-sign.ru>
Date: Mon, 19 Nov 2007 14:44:52 -0700
In-Reply-To: <20071119182937.GA89@tv-sign.ru> (Oleg Nesterov's message of
	"Mon, 19 Nov 2007 21:29:37 +0300")
Message-ID: <m1ejelvrjf.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Oleg noticed that the call of task_pid_nr_ns() in proc_pid_readdir
is racy with respect to tasks exiting.

After a bit of examination it also appears that the call itself
is completely unnecessary.

So to fix the problem this patch modifies next_tgid() to return
both a tgid and the task struct in question.

A structure is introduced to return these values because it is
slightly cleaner and easier to optimize, and the resulting code
is a little shorter.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

---
 fs/proc/base.c |   51 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 5b92b79..7e8eca4 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2454,19 +2454,23 @@ out:
  * Find the first task with tgid >= tgid
  *
  */
-static struct task_struct *next_tgid(unsigned int tgid,
-		struct pid_namespace *ns)
-{
+struct tgid_iter {
+	unsigned int tgid;
 	struct task_struct *task;
+};
+static struct tgid_iter next_tgid(struct pid_namespace *ns, struct tgid_iter iter)
+{
 	struct pid *pid;
 
+	if (iter.task)
+		put_task_struct(iter.task);
 	rcu_read_lock();
 retry:
-	task = NULL;
-	pid = find_ge_pid(tgid, ns);
+	iter.task = NULL;
+	pid = find_ge_pid(iter.tgid, ns);
 	if (pid) {
-		tgid = pid_nr_ns(pid, ns) + 1;
-		task = pid_task(pid, PIDTYPE_PID);
+		iter.tgid = pid_nr_ns(pid, ns);
+		iter.task = pid_task(pid, PIDTYPE_PID);
 		/* What we to know is if the pid we have find is the
 		 * pid of a thread_group_leader.  Testing for task
 		 * being a thread_group_leader is the obvious thing
@@ -2479,23 +2483,25 @@ retry:
 		 * found doesn't happen to be a thread group leader.
 		 * As we don't care in the case of readdir.
 		 */
-		if (!task || !has_group_leader_pid(task))
+		if (!iter.task || !has_group_leader_pid(iter.task)) {
+			iter.tgid += 1;
 			goto retry;
-		get_task_struct(task);
+		}
+		get_task_struct(iter.task);
 	}
 	rcu_read_unlock();
-	return task;
+	return iter;
 }
 
 #define TGID_OFFSET (FIRST_PROCESS_ENTRY + ARRAY_SIZE(proc_base_stuff))
 
 static int proc_pid_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
-	struct task_struct *task, int tgid)
+	struct tgid_iter iter)
 {
 	char name[PROC_NUMBUF];
-	int len = snprintf(name, sizeof(name), "%d", tgid);
+	int len = snprintf(name, sizeof(name), "%d", iter.tgid);
 	return proc_fill_cache(filp, dirent, filldir, name, len,
-				proc_pid_instantiate, task, NULL);
+				proc_pid_instantiate, iter.task, NULL);
 }
 
 /* for the /proc/ directory itself, after non-process stuff has been done */
@@ -2503,8 +2509,7 @@ int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)
 {
 	unsigned int nr = filp->f_pos - FIRST_PROCESS_ENTRY;
 	struct task_struct *reaper = get_proc_task(filp->f_path.dentry->d_inode);
-	struct task_struct *task;
-	int tgid;
+	struct tgid_iter iter;
 	struct pid_namespace *ns;
 
 	if (!reaper)
@@ -2517,14 +2522,14 @@ int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	}
 
 	ns = filp->f_dentry->d_sb->s_fs_info;
-	tgid = filp->f_pos - TGID_OFFSET;
-	for (task = next_tgid(tgid, ns);
-	     task;
-	     put_task_struct(task), task = next_tgid(tgid + 1, ns)) {
-		tgid = task_pid_nr_ns(task, ns);
-		filp->f_pos = tgid + TGID_OFFSET;
-		if (proc_pid_fill_cache(filp, dirent, filldir, task, tgid) < 0) {
-			put_task_struct(task);
+	iter.task = NULL;
+	iter.tgid = filp->f_pos - TGID_OFFSET;
+	for (iter = next_tgid(ns, iter);
+	     iter.task;
+	     iter.tgid += 1, iter = next_tgid(ns, iter)) {
+		filp->f_pos = iter.tgid + TGID_OFFSET;
+		if (proc_pid_fill_cache(filp, dirent, filldir, iter) < 0) {
+			put_task_struct(iter.task);
 			goto out;
 		}
 	}
-- 
1.5.3.rc6.17.g1911

