Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081AbZHLX3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbZHLX3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 19:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbZHLX3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 19:29:55 -0400
Received: from sparc.brc.ubc.ca ([137.82.2.12]:55179 "EHLO sparc.brc.ubc.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbZHLX3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 19:29:54 -0400
From: Vincent Li <macli@brc.ubc.ca>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Vincent Li <macli@brc.ubc.ca>
Subject: [PATCH] fs/proc/task_mmu.c v1: fix clear_refs_write() input sanity check
Date: Wed, 12 Aug 2009 16:29:54 -0700
Message-Id: <1250119794-8016-1-git-send-email-macli@brc.ubc.ca>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1 fix the compiling errors and keep the type variable name.

Andrew Morton pointed out similar string hacking and obfuscated check for zero-length input
at the end of the function, David Rientjes suggested to use strict_strtol to replace
simple_strtol, this patch cover above suggestions, add removing of leading and trailing
whitespace from user input. It does not change function behavious.

This patch is rebased on mmotm-2009-08-04-14-22.

Signed-off-by: Vincent Li <macli@brc.ubc.ca>
---
 fs/proc/task_mmu.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 2079969..c7cf8f3 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -491,21 +491,20 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
 	struct task_struct *task;
-	char buffer[PROC_NUMBUF], *end;
+	char buffer[PROC_NUMBUF];
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
-	int type;
+	long type;
 
 	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
-	type = simple_strtol(buffer, &end, 0);
+	if (strict_strtol(strstrip(buffer), 10, &type))
+		return -EINVAL;
 	if (type < CLEAR_REFS_ALL || type > CLEAR_REFS_MAPPED)
 		return -EINVAL;
-	if (*end == '\n')
-		end++;
 	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
 		return -ESRCH;
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

