Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbZK0XLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbZK0XLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbZK0XLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:11:10 -0500
Received: from server1.wserver.cz ([82.113.45.157]:60459 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbZK0XGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:06:05 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com
Subject: [PATCH v3 08/27] FS: proc, switch limits reading to fops
Date: Sat, 28 Nov 2009 00:05:48 +0100
Message-Id: <1259363167-9347-8-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Use fops instead of proc_info_read. We will need fops for limits
writing and the code would look ugly if we used
NOD("limits", S_IFREG|S_IRUSR|S_IWUSR, NULL,
	&proc_pid_limits_operations, { .proc_read = proc_pid_limits }),

We will just use
REG("limits", S_IRUSR|S_IWUSR, proc_pid_limits_operations),

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 fs/proc/base.c |   37 ++++++++++++++++++++++++++++---------
 1 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index af643b5..be4733c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -477,19 +477,30 @@ static const struct limit_names lnames[RLIM_NLIMITS] = {
 };
 
 /* Display limits for a process */
-static int proc_pid_limits(struct task_struct *task, char *buffer)
+static ssize_t limits_read(struct file *file, char __user *buf, size_t rcount,
+		loff_t *ppos)
 {
-	unsigned int i;
-	int count = 0;
-	unsigned long flags;
-	char *bufptr = buffer;
-
 	struct rlimit rlim[RLIM_NLIMITS];
+	struct task_struct *task;
+	unsigned long flags;
+	unsigned int i;
+	ssize_t count = 0;
+	char *bufptr;
 
-	if (!lock_task_sighand(task, &flags))
+	task = get_proc_task(file->f_path.dentry->d_inode);
+	if (!task)
+		return -ESRCH;
+	if (!lock_task_sighand(task, &flags)) {
+		put_task_struct(task);
 		return 0;
+	}
 	memcpy(rlim, task->signal->rlim, sizeof(struct rlimit) * RLIM_NLIMITS);
 	unlock_task_sighand(task, &flags);
+	put_task_struct(task);
+
+	bufptr = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!bufptr)
+		return -ENOMEM;
 
 	/*
 	 * print the file header
@@ -518,9 +529,17 @@ static int proc_pid_limits(struct task_struct *task, char *buffer)
 			count += sprintf(&bufptr[count], "\n");
 	}
 
+	count = simple_read_from_buffer(buf, rcount, ppos, bufptr, count);
+
+	free_page((unsigned long)bufptr);
+
 	return count;
 }
 
+static const struct file_operations proc_pid_limits_operations = {
+	.read	= limits_read,
+};
+
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 static int proc_pid_syscall(struct task_struct *task, char *buffer)
 {
@@ -2500,7 +2519,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	INF("auxv",       S_IRUSR, proc_pid_auxv),
 	ONE("status",     S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
-	INF("limits",	  S_IRUSR, proc_pid_limits),
+	REG("limits",	  S_IRUSR, proc_pid_limits_operations),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
@@ -2834,7 +2853,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	INF("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
-	INF("limits",	 S_IRUSR, proc_pid_limits),
+	REG("limits",	  S_IRUSR, proc_pid_limits_operations),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
-- 
1.6.5.3

