Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbZHKVdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbZHKVdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 17:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbZHKVdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 17:33:20 -0400
Received: from sparc.brc.ubc.ca ([137.82.2.12]:54780 "EHLO sparc.brc.ubc.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591AbZHKVdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 17:33:20 -0400
From: Vincent Li <macli@brc.ubc.ca>
To: linux-kernel@vger.kernel.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Matt Mackall <mpm@selenic.com>, Vincent Li <macli@brc.ubc.ca>
Subject: [PATCH] fs/proc/: fix input sanity check.
Date: Tue, 11 Aug 2009 14:34:26 -0700
Message-Id: <1250026466-8769-1-git-send-email-macli@brc.ubc.ca>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix fs/proc/task_mmu.c clear_refs_write(), fs/proc/base.c proc_fault_inject_write()
 and proc_fault_inject_operations() input sanity check by following the disccusion of
http://marc.info/?l=linux-mm&m=124938168905463&w=2.

Signed-off-by: Vincent Li <macli@brc.ubc.ca>
---
 fs/proc/base.c     |   20 ++++++++------------
 fs/proc/task_mmu.c |   11 +++++------
 2 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 04d29a0..44054d2 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1190,17 +1190,16 @@ static ssize_t proc_fault_inject_write(struct file * file,
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
-	make_it_fail = simple_strtol(buffer, &end, 0);
-	if (*end == '\n')
-		end++;
+	make_it_fail = simple_strtol(strstrip(buffer), &end, 0);
+	if (*end)
+		return -EINVAL;
 	task = get_proc_task(file->f_dentry->d_inode);
 	if (!task)
 		return -ESRCH;
 	task->make_it_fail = make_it_fail;
 	put_task_struct(task);
-	if (end - buffer == 0)
-		return -EIO;
-	return end - buffer;
+
+	return count;
 }
 
 static const struct file_operations proc_fault_inject_operations = {
@@ -2253,18 +2252,15 @@ static ssize_t proc_coredump_filter_write(struct file *file,
 		goto out_no_task;
 
 	ret = -EINVAL;
-	val = (unsigned int)simple_strtoul(buffer, &end, 0);
-	if (*end == '\n')
-		end++;
-	if (end - buffer == 0)
-		goto out_no_task;
+	val = (unsigned int)simple_strtoul(strstrip(buffer), &end, 0);
+	if (*end)
+		return ret;
 
 	ret = -ESRCH;
 	task = get_proc_task(file->f_dentry->d_inode);
 	if (!task)
 		goto out_no_task;
 
-	ret = end - buffer;
 	mm = get_task_mm(task);
 	if (!mm)
 		goto out_no_mm;
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 6f61b7c..957b266 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -477,10 +477,10 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
-	if (!simple_strtol(buffer, &end, 0))
+	if (!simple_strtol(strstrip(buffer), &end, 0))
+		return -EINVAL;
+	if (*end)
 		return -EINVAL;
-	if (*end == '\n')
-		end++;
 	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
 		return -ESRCH;
@@ -502,9 +502,8 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 		mmput(mm);
 	}
 	put_task_struct(task);
-	if (end - buffer == 0)
-		return -EIO;
-	return end - buffer;
+
+	return count;
 }
 
 const struct file_operations proc_clear_refs_operations = {
-- 
1.6.0.4

