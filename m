Return-Path: <linux-kernel-owner+w=401wt.eu-S1757100AbYBNWve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100AbYBNWve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbYBNWvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:51:23 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:31283 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbYBNWvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:51:22 -0500
Message-ID: <47B4C5E7.5000802@ct.jp.nec.com>
Date: Thu, 14 Feb 2008 14:51:19 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] latencytop: fix kernel panic and memory leak on proc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I posted 2 patches to fix kernel panic and memory leak.
http://lkml.org/lkml/2008/2/14/282
http://lkml.org/lkml/2008/2/14/283

But, I think this patch is better than old ones.

---
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Reading /proc/<pid>/latency or /proc/<pid>/task/<tid>/latency could cause
NULL pointer dereference.

In lstats_open(), get_proc_task() can return NULL, in which case the kernel
will oops at lstats_show_proc() because m->private is NULL.

This can be reproduced by the follwoing script.
while :
do
	bash -c 'ls > ls.$$' &
	pid=$!
	cat /proc/$pid/latency &
	cat /proc/$pid/latency &
	cat /proc/$pid/latency &
	cat /proc/$pid/latency
done

And the task struct which gotten by get_proc_task() is never put.
put_task_struct() should be called.

This patch changes the private is used to store inode, and the task struct
will be gotten and putted in read or write function.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 fs/proc/base.c |   27 +++++++++++----------------
 1 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 7c6b4ec..5de8dd5 100644
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
@@ -341,32 +344,24 @@ static int lstats_show_proc(struct seq_file *m, void *v)
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
-	ret = single_open(file, lstats_show_proc, NULL);
-	if (!ret) {
-		m = file->private_data;
-		m->private = task;
-	}
-	return ret;
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
-- 
1.5.3.8

