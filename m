Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbXKSWKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbXKSWKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbXKSWIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:08:04 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47471 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbXKSWIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:08:01 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 2/4] proc: Rewrite do_task_stat to correctly handle pid namespaces.
References: <20071117183109.GA2605@tv-sign.ru>
	<m1abp9vqua.fsf@ebiederm.dsl.xmission.com>
	<m163zxvqm9.fsf_-_@ebiederm.dsl.xmission.com>
Date: Mon, 19 Nov 2007 15:06:25 -0700
In-Reply-To: <m163zxvqm9.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Mon, 19 Nov 2007 15:04:46 -0700")
Message-ID: <m11walvqji.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Currently (as pointed out by Oleg) do_task_stat has a race
when calling task_pid_nr_ns with the task exiting.  In addition
do_task_stat is not currently displaying information in the
context of the pid namespace that mounted the /proc filesystem.
So "cut -d' ' -f 1 /proc/<pid>/stat" may not equal <pid>.

This patch fixes the problem by converting to a single_open
seq_file show method.  Getting the pid namespace from the
filesystem superblock instead of current, and simply using
the the struct pid from the inode instead of attempting to get
that same pid from the task.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/array.c    |   24 ++++++++++++------------
 fs/proc/base.c     |    4 ++--
 fs/proc/internal.h |    4 ++--
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index eba339e..e7d290f 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -77,6 +77,7 @@
 #include <linux/cpuset.h>
 #include <linux/rcupdate.h>
 #include <linux/delayacct.h>
+#include <linux/seq_file.h>
 #include <linux/pid_namespace.h>
 
 #include <asm/pgtable.h>
@@ -384,14 +385,14 @@ static cputime_t task_gtime(struct task_struct *p)
 	return p->gtime;
 }
 
-static int do_task_stat(struct task_struct *task, char *buffer, int whole)
+static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
+			struct pid *pid, struct task_struct *task, int whole)
 {
 	unsigned long vsize, eip, esp, wchan = ~0UL;
 	long priority, nice;
 	int tty_pgrp = -1, tty_nr = 0;
 	sigset_t sigign, sigcatch;
 	char state;
-	int res;
 	pid_t ppid = 0, pgid = -1, sid = -1;
 	int num_threads = 0;
 	struct mm_struct *mm;
@@ -403,9 +404,6 @@ static int do_task_stat(struct task_struct *task, char *buffer, int whole)
 	unsigned long rsslim = 0;
 	char tcomm[sizeof(task->comm)];
 	unsigned long flags;
-	struct pid_namespace *ns;
-
-	ns = current->nsproxy->pid_ns;
 
 	state = *get_task_state(task);
 	vsize = eip = esp = 0;
@@ -492,10 +490,10 @@ static int do_task_stat(struct task_struct *task, char *buffer, int whole)
 	/* convert nsec -> ticks */
 	start_time = nsec_to_clock_t(start_time);
 
-	res = sprintf(buffer, "%d (%s) %c %d %d %d %d %d %u %lu \
+	seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu \
 %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
 %lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld\n",
-		task_pid_nr_ns(task, ns),
+		pid_nr_ns(pid, ns),
 		tcomm,
 		state,
 		ppid,
@@ -544,17 +542,19 @@ static int do_task_stat(struct task_struct *task, char *buffer, int whole)
 		cputime_to_clock_t(cgtime));
 	if (mm)
 		mmput(mm);
-	return res;
+	return 0;
 }
 
-int proc_tid_stat(struct task_struct *task, char *buffer)
+int proc_tid_stat(struct seq_file *m, struct pid_namespace *ns,
+			struct pid *pid, struct task_struct *task)
 {
-	return do_task_stat(task, buffer, 0);
+	return do_task_stat(m, ns, pid, task, 0);
 }
 
-int proc_tgid_stat(struct task_struct *task, char *buffer)
+int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns,
+			struct pid *pid, struct task_struct *task)
 {
-	return do_task_stat(task, buffer, 1);
+	return do_task_stat(m, ns, pid, task, 1);
 }
 
 int proc_pid_statm(struct task_struct *task, char *buffer)
diff --git a/fs/proc/base.c b/fs/proc/base.c
index e9ff77e..51f0e7a 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2228,7 +2228,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("sched",      S_IRUGO|S_IWUSR, pid_sched),
 #endif
 	INF("cmdline",    S_IRUGO, pid_cmdline),
-	INF("stat",       S_IRUGO, tgid_stat),
+	ONE("stat",       S_IRUGO, tgid_stat),
 	INF("statm",      S_IRUGO, pid_statm),
 	REG("maps",       S_IRUGO, maps),
 #ifdef CONFIG_NUMA
@@ -2549,7 +2549,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("sched",     S_IRUGO|S_IWUSR, pid_sched),
 #endif
 	INF("cmdline",   S_IRUGO, pid_cmdline),
-	INF("stat",      S_IRUGO, tid_stat),
+	ONE("stat",      S_IRUGO, tid_stat),
 	INF("statm",     S_IRUGO, pid_statm),
 	REG("maps",      S_IRUGO, maps),
 #ifdef CONFIG_NUMA
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 1b2b6c6..74bc772 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -46,8 +46,8 @@ extern int maps_protect;
 
 extern void create_seq_entry(char *name, mode_t mode, const struct file_operations *f);
 extern int proc_exe_link(struct inode *, struct dentry **, struct vfsmount **);
-extern int proc_tid_stat(struct task_struct *,  char *);
-extern int proc_tgid_stat(struct task_struct *, char *);
+extern int proc_tid_stat(struct seq_file *m, struct pid_namespace *ns, struct pid *pid, struct task_struct *task);
+extern int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns, struct pid *pid, struct task_struct *task);
 extern int proc_pid_status(struct task_struct *, char *);
 extern int proc_pid_statm(struct task_struct *, char *);
 
-- 
1.5.3.rc6.17.g1911

