Return-Path: <linux-kernel-owner+w=401wt.eu-S1751120AbZG2E13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120AbZG2E13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 00:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbZG2E12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 00:27:28 -0400
Received: from smtp-out.google.com ([216.239.45.13]:46469 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZG2E11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 00:27:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=fnpoEoXs4m3zZayjiiR/dwHnRkxtBBiboNQvb8g5djBf+NuuukP57qc1/wKxd1Hae
	MDxc08p+QNqmoh2MoQa6Q==
Date: Tue, 28 Jul 2009 21:27:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>, Paul Menage <menage@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch -mm v2] mm: introduce oom_adj_child
Message-ID: <alpine.DEB.2.00.0907282125260.554@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's helpful to be able to specify an oom_adj value for newly forked
children that do not share memory with the parent.

Before making oom_adj values a characteristic of a task's mm in
2ff05b2b4eac2e63d345fc731ea151a060247f53, it was possible to change the
oom_adj value of a vfork() child prior to execve() without implicitly
changing the oom_adj value of the parent.  With the new behavior, the
oom_adj values of both threads would change since they represent the same
memory.

That change was necessary to fix an oom killer livelock which would occur
when a child would be selected for oom kill prior to execve() and the
task could not be killed because it shared memory with an OOM_DISABLE
parent.  In fact, only the most negative (most immune) oom_adj value for
all threads sharing the same memory would actually be used by the oom
killer, leaving inconsistencies amongst all other threads having
different oom_adj values (and, thus, incorrectly exported
/proc/pid/oom_score values).

This patch adds a new per-process parameter: /proc/pid/oom_adj_child.
This defaults to mirror the value of /proc/pid/oom_adj but may be changed
so that mm's initialized by their children are preferred over the parent
by the oom killer.  Setting oom_adj_child to be less (i.e. more immune)
than the task's oom_adj value itself is governed by the CAP_SYS_RESOURCE
capability.

When a mm is initialized, the initial oom_adj value will be set to the
parent's oom_adj_child.  This allows tasks to elevate the oom_adj value
of a vfork'd child prior to execve() before the execution actually takes
place.

Furthermore, /proc/pid/oom_adj_child is inherited from the task that
forked it.

Cc: Rik van Riel <riel@redhat.com>
Cc: Paul Menage <menage@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/filesystems/proc.txt |   38 ++++++++++++++++----
 fs/proc/base.c                     |   68 ++++++++++++++++++++++++++++++++++++
 include/linux/sched.h              |    1 +
 kernel/fork.c                      |    3 +-
 4 files changed, 101 insertions(+), 9 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -34,10 +34,11 @@ Table of Contents
 
   3	Per-Process Parameters
   3.1	/proc/<pid>/oom_adj - Adjust the oom-killer score
-  3.2	/proc/<pid>/oom_score - Display current oom-killer score
-  3.3	/proc/<pid>/io - Display the IO accounting fields
-  3.4	/proc/<pid>/coredump_filter - Core dump filtering settings
-  3.5	/proc/<pid>/mountinfo - Information about mounts
+  3.2	/proc/<pid>/oom_adj_child - Change default oom_adj for children
+  3.3	/proc/<pid>/oom_score - Display current oom-killer score
+  3.4	/proc/<pid>/io - Display the IO accounting fields
+  3.5	/proc/<pid>/coredump_filter - Core dump filtering settings
+  3.6	/proc/<pid>/mountinfo - Information about mounts
 
 
 ------------------------------------------------------------------------------
@@ -1206,7 +1207,28 @@ The task with the highest badness score is then selected and its children
 are killed, process itself will be killed in an OOM situation when it does
 not have children or some of them disabled oom like described above.
 
-3.2 /proc/<pid>/oom_score - Display current oom-killer score
+
+3.2 /proc/<pid>/oom_adj_child - Change default oom_adj for children
+-------------------------------------------------------------------
+
+This file can be used to change the default oom_adj value for children when a
+new mm is initialized.  The oom_adj value for a child's mm is typically the
+task's oom_adj value itself, however this value can be altered by writing to
+this file.
+
+This is particularly helpful when a child is vfork'd and its mm following exec
+should have a higher priority oom_adj value than its parent.  The new mm will
+default to oom_adj_child of the parent task.
+
+oom_adj_child will mirror oom_adj whenever the latter changes for all tasks
+that share its memory.  This avoids having to set both values when simply
+tuning oom_adj and that value should be inherited by all children.
+
+Setting oom_adj_child to be more immune than the task's mm itself (i.e. less
+than oom_adj) is governed by the CAP_SYS_RESOURCE capability.
+
+
+3.3 /proc/<pid>/oom_score - Display current oom-killer score
 -------------------------------------------------------------
 
 This file can be used to check the current score used by the oom-killer is for
@@ -1214,7 +1236,7 @@ any given <pid>. Use it together with /proc/<pid>/oom_adj to tune which
 process should be killed in an out-of-memory situation.
 
 
-3.3  /proc/<pid>/io - Display the IO accounting fields
+3.4  /proc/<pid>/io - Display the IO accounting fields
 -------------------------------------------------------
 
 This file contains IO statistics for each running process
@@ -1316,7 +1338,7 @@ those 64-bit counters, process A could see an intermediate result.
 More information about this can be found within the taskstats documentation in
 Documentation/accounting.
 
-3.4 /proc/<pid>/coredump_filter - Core dump filtering settings
+3.5 /proc/<pid>/coredump_filter - Core dump filtering settings
 ---------------------------------------------------------------
 When a process is dumped, all anonymous memory is written to a core file as
 long as the size of the core file isn't limited. But sometimes we don't want
@@ -1360,7 +1382,7 @@ For example:
   $ echo 0x7 > /proc/self/coredump_filter
   $ ./some_program
 
-3.5	/proc/<pid>/mountinfo - Information about mounts
+3.6	/proc/<pid>/mountinfo - Information about mounts
 --------------------------------------------------------
 
 This file contains lines of the form:
diff --git a/fs/proc/base.c b/fs/proc/base.c
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1023,6 +1023,7 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
 	struct task_struct *task;
+	struct task_struct *g, *p;
 	char buffer[PROC_NUMBUF], *end;
 	int oom_adjust;
 
@@ -1051,6 +1052,12 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
 		put_task_struct(task);
 		return -EACCES;
 	}
+	read_lock(&tasklist_lock);
+	do_each_thread(g, p) {
+		if (p->mm && p->mm == task->mm)
+			p->oom_adj_child = oom_adjust;
+	} while_each_thread(g, p);
+	read_unlock(&tasklist_lock);
 	task->mm->oom_adj = oom_adjust;
 	task_unlock(task);
 	put_task_struct(task);
@@ -1064,6 +1071,65 @@ static const struct file_operations proc_oom_adjust_operations = {
 	.write		= oom_adjust_write,
 };
 
+static ssize_t oom_adj_child_read(struct file *file, char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
+	char buffer[PROC_NUMBUF];
+	size_t len;
+	int oom_adj_child;
+
+	if (!task)
+		return -ESRCH;
+	oom_adj_child = task->oom_adj_child;
+	put_task_struct(task);
+
+	len = snprintf(buffer, sizeof(buffer), "%i\n", oom_adj_child);
+
+	return simple_read_from_buffer(buf, count, ppos, buffer, len);
+}
+
+static ssize_t oom_adj_child_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct task_struct *task;
+	char buffer[PROC_NUMBUF], *end;
+	int oom_adj_child;
+
+	memset(buffer, 0, sizeof(buffer));
+	if (count > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+	if (copy_from_user(buffer, buf, count))
+		return -EFAULT;
+	oom_adj_child = simple_strtol(buffer, &end, 0);
+	if ((oom_adj_child < OOM_ADJUST_MIN ||
+	     oom_adj_child > OOM_ADJUST_MAX) && oom_adj_child != OOM_DISABLE)
+		return -EINVAL;
+	if (*end == '\n')
+		end++;
+	task = get_proc_task(file->f_path.dentry->d_inode);
+	if (!task)
+		return -ESRCH;
+	task_lock(task);
+	if (task->mm && oom_adj_child < task->mm->oom_adj &&
+	    !capable(CAP_SYS_RESOURCE)) {
+		task_unlock(task);
+		put_task_struct(task);
+		return -EINVAL;
+	}
+	task_unlock(task);
+	task->oom_adj_child = oom_adj_child;
+	put_task_struct(task);
+	if (end - buffer == 0)
+		return -EIO;
+	return end - buffer;
+}
+
+static const struct file_operations proc_oom_adj_child_operations = {
+	.read		= oom_adj_child_read,
+	.write		= oom_adj_child_write,
+};
+
 #ifdef CONFIG_AUDITSYSCALL
 #define TMPBUFLEN 21
 static ssize_t proc_loginuid_read(struct file * file, char __user * buf,
@@ -2548,6 +2614,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 #endif
 	INF("oom_score",  S_IRUGO, proc_oom_score),
 	REG("oom_adj",    S_IRUGO|S_IWUSR, proc_oom_adjust_operations),
+	REG("oom_adj_child",	S_IRUGO|S_IWUSR, proc_oom_adj_child_operations),
 #ifdef CONFIG_AUDITSYSCALL
 	REG("loginuid",   S_IWUSR|S_IRUGO, proc_loginuid_operations),
 	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
@@ -2886,6 +2953,7 @@ static const struct pid_entry tid_base_stuff[] = {
 #endif
 	INF("oom_score", S_IRUGO, proc_oom_score),
 	REG("oom_adj",   S_IRUGO|S_IWUSR, proc_oom_adjust_operations),
+	REG("oom_adj_child",	S_IRUGO|S_IWUSR, proc_oom_adj_child_operations),
 #ifdef CONFIG_AUDITSYSCALL
 	REG("loginuid",  S_IWUSR|S_IRUGO, proc_loginuid_operations),
 	REG("sessionid",  S_IRUSR, proc_sessionid_operations),
diff --git a/include/linux/sched.h b/include/linux/sched.h
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1198,6 +1198,7 @@ struct task_struct {
 	 * a short time
 	 */
 	unsigned char fpu_counter;
+	s8 oom_adj_child;	/* Default child OOM-kill score adjustment */
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	unsigned int btrace_seq;
 #endif
diff --git a/kernel/fork.c b/kernel/fork.c
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -426,7 +426,7 @@ static struct mm_struct * mm_init(struct mm_struct * mm, struct task_struct *p)
 	init_rwsem(&mm->mmap_sem);
 	INIT_LIST_HEAD(&mm->mmlist);
 	mm->flags = (current->mm) ? current->mm->flags : default_dump_filter;
-	mm->oom_adj = (current->mm) ? current->mm->oom_adj : 0;
+	mm->oom_adj = p->oom_adj_child;
 	mm->core_state = NULL;
 	mm->nr_ptes = 0;
 	set_mm_counter(mm, file_rss, 0);
@@ -679,6 +679,7 @@ good_mm:
 
 	tsk->mm = mm;
 	tsk->active_mm = mm;
+	tsk->oom_adj_child = mm->oom_adj;
 	return 0;
 
 fail_nomem:
