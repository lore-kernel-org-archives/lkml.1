Return-Path: <linux-kernel-owner+w=401wt.eu-S1764784AbYBUAxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764784AbYBUAxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 19:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757995AbYBUAxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 19:53:31 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:22371 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbYBUAxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 19:53:30 -0500
Message-ID: <47BCCB89.4070000@ct.jp.nec.com>
Date: Wed, 20 Feb 2008 16:53:29 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] latencytop: change /proc task_struct access method
References: <47B4C5E7.5000802@ct.jp.nec.com> <20080214164216.45ebf51f@laptopd505.fenrus.org> <20080215011341.GA11756@elte.hu>
In-Reply-To: <20080215011341.GA11756@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here is a delta patch against sched-devel.git tree.

These two patches in sched-devel.git tree fix the issues.
latencytop: fix kernel panic while reading latency proc file
latencytop: fix memory leak on latency proc file

However, this is more appropriate way to fix, I think.

---
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Change getting task_struct by get_proc_task() at read or write time,
and returns -ESRCH if get_proc_task() returns NULL.
This is same behavior as other /proc files.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 fs/proc/base.c |   40 ++++++++++++----------------------------
 1 files changed, 12 insertions(+), 28 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 64661c3..bebf9a8 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -314,9 +314,12 @@ static int proc_pid_schedstat(struct task_struct *task, char *buffer)
 static int lstats_show_proc(struct seq_file *m, void *v)
 {
 	int i;
-	struct task_struct *task = m->private;
-	seq_puts(m, "Latency Top version : v0.1\n");
+	struct inode *inode = m->private;
+	struct task_struct *task = get_proc_task(inode);
 
+	if (!task)
+		return -ESRCH;
+	seq_puts(m, "Latency Top version : v0.1\n");
 	for (i = 0; i < 32; i++) {
 		if (task->latency_record[i].backtrace[0]) {
 			int q;
@@ -341,43 +344,24 @@ static int lstats_show_proc(struct seq_file *m, void *v)
 		}
 
 	}
+	put_task_struct(task);
 	return 0;
 }
 
 static int lstats_open(struct inode *inode, struct file *file)
 {
-	int ret;
-	struct seq_file *m;
-	struct task_struct *task = get_proc_task(inode);
-
-	if (!task)
-		return -ENOENT;
-	ret = single_open(file, lstats_show_proc, NULL);
-	if (!ret) {
-		m = file->private_data;
-		m->private = task;
-	}
-	return ret;
-}
-
-static int lstats_release(struct inode *inode, struct file *file)
-{
-	struct seq_file *m = file->private_data;
-	struct task_struct *task = m->private;
-
-	put_task_struct(task);
-	return single_release(inode, file);
+	return single_open(file, lstats_show_proc, inode);
 }
 
 static ssize_t lstats_write(struct file *file, const char __user *buf,
 			    size_t count, loff_t *offs)
 {
-	struct seq_file *m;
-	struct task_struct *task;
+	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
 
-	m = file->private_data;
-	task = m->private;
+	if (!task)
+		return -ESRCH;
 	clear_all_latency_tracing(task);
+	put_task_struct(task);
 
 	return count;
 }
@@ -387,7 +371,7 @@ static const struct file_operations proc_lstats_operations = {
 	.read		= seq_read,
 	.write		= lstats_write,
 	.llseek		= seq_lseek,
-	.release	= lstats_release,
+	.release	= single_release,
 };
 
 #endif
-- 
1.5.3.8

