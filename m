Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415AbYG3T6C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbYG3T6C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:58:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbYG3T5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:57:53 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:48461 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753070AbYG3T5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:57:52 -0400
From: Anders Johansson <ajohansson@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] making /proc/<pid>/limits writable
Date: Wed, 30 Jul 2008 21:57:45 +0200
User-Agent: KMail/1.10.0 (Linux/2.6.25.11-0.1-default; KDE/4.1.0; x86_64; ; )
Organization: SUSE LINUX GmbH, GF: Volker Smid, HRB 21284 (AG Nuernberg)
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_6eMkIWHD1OkHrGA"
Message-Id: <200807302157.46261.ajohansson@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_6eMkIWHD1OkHrGA
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

(For any replies, please cc. me, because I'm not subscribed)

Attached is a patch making the limits for a process writable, so it is 
possible to change the limits of a task other than current.

There are many reasons why this is desirable. The core limit is to me the most 
important. If a process hangs, because of some sort of race condition that 
happens once in a blue moon, and ulimit -c is set to 0, it might take forever 
to reproduce. It would be nice to be able to change that limit dynamically, to 
be able to get a core dump.

Other limits should also be settable, but for now I've only done core size.

The patch is against 2.6.27-rc1

btw, in case it isn't painfully obvious: this is my very first kernel patch 
that isn't a simple one-or-two-line bug fix

Anders

--Boundary-00=_6eMkIWHD1OkHrGA
Content-Type: text/x-patch;
  charset="us-ascii";
  name="pid_limits.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="pid_limits.diff"

diff -ur a/fs/proc/base.c b/fs/proc/base.c
--- a/fs/proc/base.c	2008-07-30 21:44:44.000000000 +0200
+++ b/fs/proc/base.c	2008-07-30 21:53:07.000000000 +0200
@@ -423,6 +423,76 @@
 
 #endif
 
+static ssize_t pid_limits_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *offs)
+{
+	int ret = 0;
+	struct task_struct *task;
+
+	if (!count)
+		goto out_no_task;
+	char c;
+	char *s = buf, *tmp;
+	char buffer[256];
+	unsigned long softlim, hardlim;
+	char hardlim_set = 0;
+
+	task = get_proc_task(file->f_dentry->d_inode);
+	if (!task) {
+		ret = -ESRCH;
+		goto out_no_task;
+	}
+	if (get_user(c, s)) {
+		ret = -EFAULT;
+		goto out;
+	}
+	s += 2;
+	switch (c) {
+		case 'c': {
+			if (copy_from_user(buffer, s, 255)) {
+				ret = -EFAULT;
+				goto out;
+			}
+			if (strncmp(buffer, "unlimited", 9) == 0)
+				softlim = RLIM_INFINITY;
+			else {
+				softlim = strict_strtoul(buffer, &tmp, 10);
+				if (tmp == buffer) {
+					ret = -EFAULT;
+					goto out;
+				}
+				softlim *= 1024;
+			}
+			if ((tmp - buffer) < count) {
+				s = tmp+1;
+				if (strncmp(s, "unlimited", 9) == 0) {
+					hardlim = RLIM_INFINITY;
+					hardlim_set = 1;
+				} else {
+					hardlim = strict_strtoul(s, &tmp, 10);
+					if (s != tmp) {
+						hardlim *= 1024;
+						hardlim_set = 1;
+					}
+				}
+			}
+			task_lock(task->group_leader);
+			task->signal->rlim[RLIMIT_CORE].rlim_cur = softlim;
+			if (hardlim_set) {
+				if ((hardlim <= task->signal->rlim[RLIMIT_CORE].rlim_max) ||
+					capable(CAP_SYS_ADMIN))
+					task->signal->rlim[RLIMIT_CORE].rlim_max = hardlim;
+			}
+			task_unlock(task->group_leader);
+		}
+	}
+	ret = count;
+out:
+	put_task_struct(task);
+out_no_task:
+	return ret;
+}
+
 /* The badness from the OOM killer */
 unsigned long badness(struct task_struct *p, unsigned long uptime);
 static int proc_oom_score(struct task_struct *task, char *buffer)
@@ -462,19 +532,28 @@
 };
 
 /* Display limits for a process */
-static int proc_pid_limits(struct task_struct *task, char *buffer)
+static int pid_limits_read(struct file *file, char __user *buf,
+				size_t cnt, loff_t *ppos)
 {
 	unsigned int i;
 	int count = 0;
 	unsigned long flags;
-	char *bufptr = buffer;
+	char *bufptr = buf;
+	int ret = -ESRCH;
 
 	struct rlimit rlim[RLIM_NLIMITS];
+	struct task_struct *task;
 
+	if (*ppos > 0)
+		return 0;
+
+	task = get_proc_task(file->f_dentry->d_inode);
+	if (!task)
+		goto out_no_task;
 	rcu_read_lock();
 	if (!lock_task_sighand(task,&flags)) {
 		rcu_read_unlock();
-		return 0;
+		goto out;
 	}
 	memcpy(rlim, task->signal->rlim, sizeof(struct rlimit) * RLIM_NLIMITS);
 	unlock_task_sighand(task, &flags);
@@ -506,8 +585,13 @@
 		else
 			count += sprintf(&bufptr[count], "\n");
 	}
-
-	return count;
+	
+	ret = count;
+	*ppos = count;
+out:
+	put_task_struct(task);
+out_no_task:
+	return ret;
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
@@ -2456,7 +2540,7 @@
 	REG("environ",    S_IRUSR, environ),
 	INF("auxv",       S_IRUSR, pid_auxv),
 	ONE("status",     S_IRUGO, pid_status),
-	INF("limits",	  S_IRUSR, pid_limits),
+	REG("limits",	  S_IRUSR|S_IWUSR, pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, pid_sched),
 #endif
@@ -2791,7 +2875,7 @@
 	REG("environ",   S_IRUSR, environ),
 	INF("auxv",      S_IRUSR, pid_auxv),
 	ONE("status",    S_IRUGO, pid_status),
-	INF("limits",	 S_IRUSR, pid_limits),
+	REG("limits",	 S_IRUSR|S_IWUSR, pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, pid_sched),
 #endif
Only in b/fs/proc: base.c.orig
Only in b/fs/proc: base.c.rej
Only in b/fs/proc: .base.c.rej.swp

--Boundary-00=_6eMkIWHD1OkHrGA--
