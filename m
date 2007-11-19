Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbXKSWOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbXKSWOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbXKSWOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:14:10 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55404 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbXKSWOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:14:09 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH] proc: seqfile convert proc_pid_statm
References: <20071117183109.GA2605@tv-sign.ru>
	<m1abp9vqua.fsf@ebiederm.dsl.xmission.com>
	<m163zxvqm9.fsf_-_@ebiederm.dsl.xmission.com>
	<m11walvqji.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ve7xubt1.fsf_-_@ebiederm.dsl.xmission.com>
Date: Mon, 19 Nov 2007 15:13:07 -0700
In-Reply-To: <m1ve7xubt1.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Mon, 19 Nov 2007 15:10:02 -0700")
Message-ID: <m1myt9ubnw.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This conversion is just for code cleanliness, uniformity, and general safety.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/array.c    |    8 +++++---
 fs/proc/base.c     |    4 ++--
 fs/proc/internal.h |    2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index d23d91d..b1a90c0 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -553,7 +553,8 @@ int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns,
 	return do_task_stat(m, ns, pid, task, 1);
 }
 
-int proc_pid_statm(struct task_struct *task, char *buffer)
+int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
+			struct pid *pid, struct task_struct *task)
 {
 	int size = 0, resident = 0, shared = 0, text = 0, lib = 0, data = 0;
 	struct mm_struct *mm = get_task_mm(task);
@@ -562,7 +563,8 @@ int proc_pid_statm(struct task_struct *task, char *buffer)
 		size = task_statm(mm, &shared, &text, &data, &resident);
 		mmput(mm);
 	}
+	seq_printf(m, "%d %d %d %d %d %d %d\n",
+			size, resident, shared, text, lib, data, 0);
 
-	return sprintf(buffer, "%d %d %d %d %d %d %d\n",
-		       size, resident, shared, text, lib, data, 0);
+	return 0;
 }
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 086a262..5b92b79 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2229,7 +2229,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 #endif
 	INF("cmdline",    S_IRUGO, pid_cmdline),
 	ONE("stat",       S_IRUGO, tgid_stat),
-	INF("statm",      S_IRUGO, pid_statm),
+	ONE("statm",      S_IRUGO, pid_statm),
 	REG("maps",       S_IRUGO, maps),
 #ifdef CONFIG_NUMA
 	REG("numa_maps",  S_IRUGO, numa_maps),
@@ -2550,7 +2550,7 @@ static const struct pid_entry tid_base_stuff[] = {
 #endif
 	INF("cmdline",   S_IRUGO, pid_cmdline),
 	ONE("stat",      S_IRUGO, tid_stat),
-	INF("statm",     S_IRUGO, pid_statm),
+	ONE("statm",     S_IRUGO, pid_statm),
 	REG("maps",      S_IRUGO, maps),
 #ifdef CONFIG_NUMA
 	REG("numa_maps", S_IRUGO, numa_maps),
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 0033645..4c17360 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -49,7 +49,7 @@ extern int proc_exe_link(struct inode *, struct dentry **, struct vfsmount **);
 extern int proc_tid_stat(struct seq_file *m, struct pid_namespace *ns, struct pid *pid, struct task_struct *task);
 extern int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns, struct pid *pid, struct task_struct *task);
 extern int proc_pid_status(struct seq_file *m, struct pid_namespace *ns, struct pid *pid, struct task_struct *task);
-extern int proc_pid_statm(struct task_struct *, char *);
+extern int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns, struct pid *pid, struct task_struct *task);
 
 extern const struct file_operations proc_maps_operations;
 extern const struct file_operations proc_numa_maps_operations;
-- 
1.5.3.rc6.17.g1911

