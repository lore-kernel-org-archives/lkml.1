Return-Path: <linux-kernel-owner+w=401wt.eu-S1756968AbZCRNkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbZCRNkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 09:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbZCRNj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 09:39:56 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60383 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbZCRNjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 09:39:55 -0400
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org,
       Zhang Le <r0bertz@gentoo.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       Oleg Nesterov <oleg@tv-sign.ru>
References: <1237185871-3343-1-git-send-email-r0bertz@gentoo.org>
	<m17i2okogv.fsf@fess.ebiederm.org>
	<20090318072720.GA20593@adriano.hkcable.com.hk>
	<m1mybjf77w.fsf@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 18 Mar 2009 06:39:47 -0700
In-Reply-To: <m1mybjf77w.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Wed\, 18 Mar 2009 03\:36\:35 -0700")
Message-ID: <m1wsandk64.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: adobriyan@gmail.com, oleg@tv-sign.ru, viro@ZenIV.linux.org.uk, r0bertz@gentoo.org, torvalds@osdl.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexey Dobriyan <adobriyan@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH] proc:  Fix proc_tid_readdir so it handles the weird cases.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix the logic in proc_task_readdir so that we provide the
guarantee that in the sequence:
opendir
readdir
readdir
....
readdir
closedir
If a thread exists from the beginning until the end we are
guaranteed to see it, even if some threads are created or
worse are destroyed during the readdir.

This guarantee is provided by reusing the same logic used
by proc_pid_readdir for the root directory of /proc.  The
pid is encoded into the offset, and we walk the pid bitmap
of all pids in the system, and test each of them to see if
it belongs to the specified thread group.

If we seek to a bad location or if the task we say last
exits it is ok because we can numerically find the next
task we would have returned.

This is slower that the previous version, but it should
not be too slow as this techinique is already use for
the root directory of /proc without problems.

Signed-off-by: Eric Biederman <ebiederm@xmission.com>
---
 fs/proc/base.c |  141 +++++++++++++++++++++-----------------------------------
 1 files changed, 53 insertions(+), 88 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index beaa0ce..2d8e9c9 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2754,13 +2754,13 @@ retry:
 	if (pid) {
 		iter.tgid = pid_nr_ns(pid, ns);
 		iter.task = pid_task(pid, PIDTYPE_PID);
-		/* What we to know is if the pid we have find is the
-		 * pid of a thread_group_leader.  Testing for task
-		 * being a thread_group_leader is the obvious thing
-		 * todo but there is a window when it fails, due to
-		 * the pid transfer logic in de_thread.
+		/* What we want to know is if the pid we have found is
+		 * the pid of a thread_group_leader.  Testing for task
+		 * being a thread_group_leader is the obvious thing to
+		 * do but there is a window when it fails, due to the
+		 * pid transfer logic in de_thread.
 		 *
-		 * So we perform the straight forward test of seeing
+		 * So we perform the straight forward test, of seeing
 		 * if the pid we have found is the pid of a thread
 		 * group leader, and don't worry if the task we have
 		 * found doesn't happen to be a thread group leader.
@@ -2978,82 +2978,54 @@ out_no_task:
 	return result;
 }
 
+
 /*
- * Find the first tid of a thread group to return to user space.
- *
- * Usually this is just the thread group leader, but if the users
- * buffer was too small or there was a seek into the middle of the
- * directory we have more work todo.
- *
- * In the case of a short read we start with find_task_by_pid.
+ * Find the next task in the thread group with tid >= tid.
+ * Return iter.task == NULL if ther is an error or no next task.
  *
- * In the case of a seek we start with the leader and walk nr
- * threads past it.
+ * The reference to the input task_struct is released.
  */
-static struct task_struct *first_tid(struct task_struct *leader,
-		int tid, int nr, struct pid_namespace *ns)
+struct tid_iter {
+	struct task_struct *task;
+	unsigned int tid;
+};
+static struct tid_iter next_tid(struct pid_namespace *ns, struct pid *tgid,
+				struct tid_iter iter)
 {
-	struct task_struct *pos;
+	struct pid *pid;
 
+	if (iter.task)
+		put_task_struct(iter.task);
 	rcu_read_lock();
-	/* Attempt to start with the pid of a thread */
-	if (tid && (nr > 0)) {
-		pos = find_task_by_pid_ns(tid, ns);
-		if (pos && (pos->group_leader == leader))
-			goto found;
-	}
-
-	/* If nr exceeds the number of threads there is nothing todo */
-	pos = NULL;
-	if (nr && nr >= get_nr_threads(leader))
-		goto out;
-
-	/* If we haven't found our starting place yet start
-	 * with the leader and walk nr threads forward.
-	 */
-	for (pos = leader; nr > 0; --nr) {
-		pos = next_thread(pos);
-		if (pos == leader) {
-			pos = NULL;
-			goto out;
+retry:
+	iter.task = NULL;
+	pid = find_ge_pid(iter.tid, ns);
+	if (pid) {
+		iter.tid = pid_nr_ns(pid, ns);
+		iter.task = pid_task(pid, PIDTYPE_PID);
+		/* As the tgid does not change during de_thread
+		 * this test if a task is in a thread group
+		 * should always be accurate.
+		 */
+		if (!iter.task || task_tgid(iter.task) != tgid) {
+			iter.tid += 1;
+			goto retry;
 		}
+		get_task_struct(iter.task);
 	}
-found:
-	get_task_struct(pos);
-out:
 	rcu_read_unlock();
-	return pos;
+	return iter;
 }
 
-/*
- * Find the next thread in the thread list.
- * Return NULL if there is an error or no next thread.
- *
- * The reference to the input task_struct is released.
- */
-static struct task_struct *next_tid(struct task_struct *start)
-{
-	struct task_struct *pos = NULL;
-	rcu_read_lock();
-	if (pid_alive(start)) {
-		pos = next_thread(start);
-		if (thread_group_leader(pos))
-			pos = NULL;
-		else
-			get_task_struct(pos);
-	}
-	rcu_read_unlock();
-	put_task_struct(start);
-	return pos;
-}
+#define TID_OFFSET 2
 
 static int proc_task_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
-	struct task_struct *task, int tid)
+	struct tid_iter iter)
 {
 	char name[PROC_NUMBUF];
-	int len = snprintf(name, sizeof(name), "%d", tid);
+	int len = snprintf(name, sizeof(name), "%d", iter.tid);
 	return proc_fill_cache(filp, dirent, filldir, name, len,
-				proc_task_instantiate, task, NULL);
+				proc_task_instantiate, iter.task, NULL);
 }
 
 /* for the /proc/TGID/task/ directories */
@@ -3061,24 +3033,22 @@ static int proc_task_readdir(struct file * filp, void * dirent, filldir_t filldi
 {
 	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
-	struct task_struct *leader = NULL;
+	struct pid *tgid = NULL;
 	struct task_struct *task;
 	int retval = -ENOENT;
 	ino_t ino;
-	int tid;
+	struct tid_iter iter;
 	struct pid_namespace *ns;
 
 	task = get_proc_task(inode);
 	if (!task)
 		goto out_no_task;
 	rcu_read_lock();
-	if (pid_alive(task)) {
-		leader = task->group_leader;
-		get_task_struct(leader);
-	}
+	if (pid_alive(task))
+		tgid = get_pid(task_tgid(task));
 	rcu_read_unlock();
 	put_task_struct(task);
-	if (!leader)
+	if (!tgid)
 		goto out_no_task;
 	retval = 0;
 
@@ -3097,26 +3067,21 @@ static int proc_task_readdir(struct file * filp, void * dirent, filldir_t filldi
 		/* fall through */
 	}
 
-	/* f_version caches the tgid value that the last readdir call couldn't
-	 * return. lseek aka telldir automagically resets f_version to 0.
-	 */
 	ns = filp->f_dentry->d_sb->s_fs_info;
-	tid = (int)filp->f_version;
-	filp->f_version = 0;
-	for (task = first_tid(leader, tid, filp->f_pos - 2, ns);
-	     task;
-	     task = next_tid(task), filp->f_pos++) {
-		tid = task_pid_nr_ns(task, ns);
-		if (proc_task_fill_cache(filp, dirent, filldir, task, tid) < 0) {
-			/* returning this tgid failed, save it as the first
-			 * pid for the next readir call */
-			filp->f_version = (u64)tid;
+	iter.task = NULL;
+	iter.tid = filp->f_pos - TID_OFFSET;
+	for (iter = next_tid(ns, tgid, iter);
+	     iter.task;
+	     iter.tid += 1, iter = next_tid(ns, tgid, iter)) {
+		filp->f_pos = iter.tid + TID_OFFSET;
+		if (proc_task_fill_cache(filp, dirent, filldir, iter) < 0) {
 			put_task_struct(task);
-			break;
+			goto out;
 		}
 	}
+	filp->f_pos = PID_MAX_LIMIT + TID_OFFSET;
 out:
-	put_task_struct(leader);
+	put_pid(tgid);
 out_no_task:
 	return retval;
 }
-- 
1.6.1.2.350.g88cc

