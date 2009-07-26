Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbZGZVuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbZGZVuq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 17:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbZGZVuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 17:50:46 -0400
Received: from smtp-out.google.com ([216.239.45.13]:37757 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbZGZVuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 17:50:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=bTSxdXADduzN2FHVBQmO7gxqSv2hUFaJuRIHyjR5Dy+4LTDtnuCT/AuOsGBFLFdvZ
	TXDE8gTWekQkeZ/wm8nZg==
Date: Sun, 26 Jul 2009 14:50:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>, Paul Menage <menage@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [patch -mmotm] mm: introduce oom_adj_child
Message-ID: <alpine.DEB.2.00.0907261446050.12973@chino.kir.corp.google.com>
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
to be greater than oom_adj so that its children are more preferrable by
the oom killer.  It cannot be less than oom_adj since the oom killer will
attempt to kill a child of the selected process first if it does not
share memory.

When a mm is initialized, the initial oom_adj value will be set to
current's oom_adj_child.  This allows tasks to elevate the oom_adj value
of a vfork'd child prior to execve() before the execution actually takes
place.

Cc: Rik van Riel <riel@redhat.com>
Cc: Paul Menage <menage@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/filesystems/proc.txt |   39 ++++++++++++++++----
 fs/proc/base.c                     |   68 ++++++++++++++++++++++++++++++++++++
 include/linux/mm_types.h           |    3 +-
 kernel/fork.c                      |    5 ++-
 4 files changed, 105 insertions(+), 10 deletions(-)

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
@@ -1206,7 +1207,29 @@ The task with the highest badness score is then selected and its children
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
+default to oom_adj_child of the parent.
+
+oom_adj_child cannot be less than oom_adj since the oom killer will inherently
+attempt to oom kill a child if it does not share memory with the selected
+process.
+
+If oom_adj_child is set to equal oom_adj, then it will mirror oom_adj whenever
+it changes.  This avoids having to set both values when simply tuning oom_adj
+and that value should be inherited by all children.
+
+
+3.3 /proc/<pid>/oom_score - Display current oom-killer score
 -------------------------------------------------------------
 
 This file can be used to check the current score used by the oom-killer is for
@@ -1214,7 +1237,7 @@ any given <pid>. Use it together with /proc/<pid>/oom_adj to tune which
 process should be killed in an out-of-memory situation.
 
 
-3.3  /proc/<pid>/io - Display the IO accounting fields
+3.4  /proc/<pid>/io - Display the IO accounting fields
 -------------------------------------------------------
 
 This file contains IO statistics for each running process
@@ -1316,7 +1339,7 @@ those 64-bit counters, process A could see an intermediate result.
 More information about this can be found within the taskstats documentation in
 Documentation/accounting.
 
-3.4 /proc/<pid>/coredump_filter - Core dump filtering settings
+3.5 /proc/<pid>/coredump_filter - Core dump filtering settings
 ---------------------------------------------------------------
 When a process is dumped, all anonymous memory is written to a core file as
 long as the size of the core file isn't limited. But sometimes we don't want
@@ -1360,7 +1383,7 @@ For example:
   $ echo 0x7 > /proc/self/coredump_filter
   $ ./some_program
 
-3.5	/proc/<pid>/mountinfo - Information about mounts
+3.6	/proc/<pid>/mountinfo - Information about mounts
 --------------------------------------------------------
 
 This file contains lines of the form:
diff --git a/fs/proc/base.c b/fs/proc/base.c
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1051,6 +1051,9 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
 		put_task_struct(task);
 		return -EACCES;
 	}
+	if (task->mm->oom_adj_child == task->mm->oom_adj ||
+	    task->mm->oom_adj_child < oom_adjust)
+		task->mm->oom_adj_child = oom_adjust;
 	task->mm->oom_adj = oom_adjust;
 	task_unlock(task);
 	put_task_struct(task);
@@ -1064,6 +1067,69 @@ static const struct file_operations proc_oom_adjust_operations = {
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
+	task_lock(task);
+	if (task->mm)
+		oom_adj_child = task->mm->oom_adj_child;
+	else
+		oom_adj_child = OOM_DISABLE;
+	task_unlock(task);
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
+	if (!task->mm || oom_adj_child < task->mm->oom_adj) {
+		task_unlock(task);
+		put_task_struct(task);
+		return -EINVAL;
+	}
+	task->mm->oom_adj_child = oom_adj_child;
+	task_unlock(task);
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
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -240,7 +240,8 @@ struct mm_struct {
 
 	unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
 
-	s8 oom_adj;	/* OOM kill score adjustment (bit shift) */
+	s8 oom_adj;		/* OOM kill score adjustment (bit shift) */
+	s8 oom_adj_child;	/* Default child OOM kill score adjustment */
 
 	cpumask_t cpu_vm_mask;
 
diff --git a/kernel/fork.c b/kernel/fork.c
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -440,12 +440,15 @@ static void mm_init_aio(struct mm_struct *mm)
 
 static struct mm_struct * mm_init(struct mm_struct * mm, struct task_struct *p)
 {
+	s8 oom_adj;
+
 	atomic_set(&mm->mm_users, 1);
 	atomic_set(&mm->mm_count, 1);
 	init_rwsem(&mm->mmap_sem);
 	INIT_LIST_HEAD(&mm->mmlist);
 	mm->flags = (current->mm) ? current->mm->flags : default_dump_filter;
-	mm->oom_adj = (current->mm) ? current->mm->oom_adj : 0;
+	oom_adj = (current->mm) ? current->mm->oom_adj_child : 0;
+	mm->oom_adj = mm->oom_adj_child = oom_adj;
 	mm->core_state = NULL;
 	mm->nr_ptes = 0;
 	set_mm_counter(mm, file_rss, 0);
