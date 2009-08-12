Return-Path: <linux-kernel-owner+w=401wt.eu-S1752050AbZHLWEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbZHLWEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 18:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZHLWEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 18:04:51 -0400
Received: from sparc.brc.ubc.ca ([137.82.2.12]:65005 "EHLO sparc.brc.ubc.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbZHLWEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 18:04:50 -0400
From: Vincent Li <macli@brc.ubc.ca>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Vincent Li <macli@brc.ubc.ca>
Subject: [PATCH] fs/proc/task_mmu.c: fix clear_refs_write() input sanity check
Date: Wed, 12 Aug 2009 15:04:50 -0700
Message-Id: <1250114690-24829-1-git-send-email-macli@brc.ubc.ca>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton pointed out similar string hacking and obfuscated check for zero-length input
at the end of the function, David Rientjes suggested to use strict_strtol to replace
simple_strtol, this patch cover above suggestions, add removing of leading and trailing
whitespace from user input. It does not change function behavious. 

This patch is rebased on mmotm-2009-08-04-14-22.

Signed-off-by: Vincent Li <macli@brc.ubc.ca>
---
 fs/proc/task_mmu.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 2079969..026b532 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -494,18 +494,17 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 	char buffer[PROC_NUMBUF], *end;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
-	int type;
+	long res;
 
 	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
-	type = simple_strtol(buffer, &end, 0);
-	if (type < CLEAR_REFS_ALL || type > CLEAR_REFS_MAPPED)
+	if (strict_strtol(strstrip(buffer), 10, &res)
+		return -EINVAL;
+	if (res < CLEAR_REFS_ALL || res > CLEAR_REFS_MAPPED)
 		return -EINVAL;
-	if (*end == '\n')
-		end++;
 	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
 		return -ESRCH;
@@ -529,9 +528,9 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 			 * Writing 3 to /proc/pid/clear_refs only affects file
 			 * mapped pages.
 			 */
-			if (type == CLEAR_REFS_ANON && vma->vm_file)
+			if (res == CLEAR_REFS_ANON && vma->vm_file)
 				continue;
-			if (type == CLEAR_REFS_MAPPED && !vma->vm_file)
+			if (res == CLEAR_REFS_MAPPED && !vma->vm_file)
 				continue;
 			walk_page_range(vma->vm_start, vma->vm_end,
 					&clear_refs_walk);
@@ -541,9 +540,8 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
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

