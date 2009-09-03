Return-Path: <linux-kernel-owner+w=401wt.eu-S1756401AbZICUJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbZICUJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 16:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbZICUJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 16:09:13 -0400
Received: from server1.wserver.cz ([82.113.45.157]:51036 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322AbZICUIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 16:08:41 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: oleg@redhat.com
Cc: akpm@linux-foundation.org, mingo@redhat.com, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH v2 8/8] FS: proc, make limits writable
Date: Thu,  3 Sep 2009 22:08:44 +0200
Message-Id: <1252008524-5376-8-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090903174106.GC27161@redhat.com>
References: <20090903174106.GC27161@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow writing strings such as
Max core file size=0:unlimited
to /proc/<pid>/limits to change limits.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 fs/proc/base.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index ea71cae..0d9e3e9 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -129,6 +129,8 @@ struct pid_entry {
 		NULL, &proc_single_file_operations,	\
 		{ .proc_show = show } )
 
+static ssize_t proc_info_read(struct file * file, char __user * buf,
+			  size_t count, loff_t *ppos);
 /*
  * Count the number of hardlinks for the pid_entry table, excluding the .
  * and .. links.
@@ -522,6 +524,74 @@ static int proc_pid_limits(struct task_struct *task, char *buffer)
 	return count;
 }
 
+static ssize_t limits_write(struct file *file, const char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
+	char str[32 + 1 + 16 + 1 + 16 + 1], *delim, *next;
+	struct rlimit new_rlimit;
+	unsigned int i;
+	int ret;
+
+	if (!task) {
+		count = -ESRCH;
+		goto out;
+	}
+	if (copy_from_user(str, buf, min(count, sizeof(str) - 1))) {
+		count = -EFAULT;
+		goto put_task;
+	}
+
+	str[min(count, sizeof(str) - 1)] = 0;
+
+	delim = strchr(str, '=');
+	if (!delim) {
+		count = -EINVAL;
+		goto put_task;
+	}
+	*delim++ = 0; /* for easy 'str' usage */
+	new_rlimit.rlim_cur = simple_strtoul(delim, &next, 0);
+	if (*next != ':') {
+		if (strncmp(delim, "unlimited:", 10)) {
+			count = -EINVAL;
+			goto put_task;
+		}
+		new_rlimit.rlim_cur = RLIM_INFINITY;
+		next = delim + 9; /* move to ':' */
+	}
+	delim = next + 1;
+	new_rlimit.rlim_max = simple_strtoul(delim, &next, 0);
+	if (*next != 0) {
+		if (strcmp(delim, "unlimited")) {
+			count = -EINVAL;
+			goto put_task;
+		}
+		new_rlimit.rlim_max = RLIM_INFINITY;
+	}
+
+	for (i = 0; i < RLIM_NLIMITS; i++)
+		if (!strcmp(str, lnames[i].name))
+			break;
+	if (i >= RLIM_NLIMITS) {
+		count = -EINVAL;
+		goto put_task;
+	}
+
+	ret = setrlimit(task, i, &new_rlimit);
+	if (ret)
+		count = ret;
+
+put_task:
+	put_task_struct(task);
+out:
+	return count;
+}
+
+static const struct file_operations proc_pid_limits_operations = {
+	.read		= proc_info_read,
+	.write		= limits_write,
+};
+
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 static int proc_pid_syscall(struct task_struct *task, char *buffer)
 {
@@ -2501,7 +2571,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 	INF("auxv",       S_IRUSR, proc_pid_auxv),
 	ONE("status",     S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
-	INF("limits",	  S_IRUSR, proc_pid_limits),
+	NOD("limits",	  S_IFREG|S_IRUSR|S_IWUSR, NULL,
+			&proc_pid_limits_operations,
+			{ .proc_read = proc_pid_limits }),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
@@ -2836,7 +2908,9 @@ static const struct pid_entry tid_base_stuff[] = {
 	INF("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
-	INF("limits",	 S_IRUSR, proc_pid_limits),
+	NOD("limits",	  S_IFREG|S_IRUSR|S_IWUSR, NULL,
+			&proc_pid_limits_operations,
+			{ .proc_read = proc_pid_limits }),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
-- 
1.6.3.3

