Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbZK0XLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbZK0XLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:11:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbZK0XLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:11:11 -0500
Received: from server1.wserver.cz ([82.113.45.157]:60458 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbZK0XGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:06:05 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com
Subject: [PATCH v3 09/27] FS: proc, make limits writable
Date: Sat, 28 Nov 2009 00:05:49 +0100
Message-Id: <1259363167-9347-9-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Allow writing strings such as
Max core file size=0:unlimited
to /proc/<pid>/limits to change limits.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 fs/proc/base.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index be4733c..78c0367 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -536,8 +536,72 @@ static ssize_t limits_read(struct file *file, char __user *buf, size_t rcount,
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
 static const struct file_operations proc_pid_limits_operations = {
 	.read	= limits_read,
+	.write	= limits_write,
 };
 
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
@@ -2519,7 +2583,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	INF("auxv",       S_IRUSR, proc_pid_auxv),
 	ONE("status",     S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
-	REG("limits",	  S_IRUSR, proc_pid_limits_operations),
+	REG("limits",	  S_IRUSR|S_IWUSR, proc_pid_limits_operations),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
@@ -2853,7 +2917,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	INF("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
-	REG("limits",	  S_IRUSR, proc_pid_limits_operations),
+	REG("limits",	  S_IRUSR|S_IWUSR, proc_pid_limits_operations),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
-- 
1.6.5.3

