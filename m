Return-Path: <linux-kernel-owner+w=401wt.eu-S1030565AbXEAObO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030565AbXEAObO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 10:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXEAObO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 10:31:14 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:2991 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbXEAObJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 10:31:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=TEbuzu2Pv4Bj+21X01qRPnrJsFci8F8w6vmi4/OlDhxz/7Byze+QVpc6atwiehdGCe1P57FvTsFzSB//qe4eLtXpzEH02U79DmCbdKhFfNFfQ7xJjTCc7ym6tvqvnsHwhR9NVVX1zYb/YyyjkfoQkqX4IyOJi7hZGpASc9PjfP8=
Date: Tue, 1 May 2007 23:25:14 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] procfs: use simple_read_from_buffer()
Message-ID: <20070501142514.GA3807@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup using simple_read_from_buffer() in procfs.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 fs/proc/base.c |   35 +++++++----------------------------
 1 file changed, 7 insertions(+), 28 deletions(-)

Index: 2.6-mm/fs/proc/base.c
===================================================================
--- 2.6-mm.orig/fs/proc/base.c
+++ 2.6-mm/fs/proc/base.c
@@ -652,7 +652,6 @@ static ssize_t oom_adjust_read(struct fi
 	char buffer[PROC_NUMBUF];
 	size_t len;
 	int oom_adjust;
-	loff_t __ppos = *ppos;
 
 	if (!task)
 		return -ESRCH;
@@ -660,14 +659,8 @@ static ssize_t oom_adjust_read(struct fi
 	put_task_struct(task);
 
 	len = snprintf(buffer, sizeof(buffer), "%i\n", oom_adjust);
-	if (__ppos >= len)
-		return 0;
-	if (count > len-__ppos)
-		count = len-__ppos;
-	if (copy_to_user(buf, buffer + __ppos, count))
-		return -EFAULT;
-	*ppos = __ppos + count;
-	return count;
+
+	return simple_read_from_buffer(buf, count, ppos, buffer, len);
 }
 
 static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
@@ -781,7 +774,6 @@ static ssize_t seccomp_read(struct file 
 {
 	struct task_struct *tsk = get_proc_task(file->f_dentry->d_inode);
 	char __buf[20];
-	loff_t __ppos = *ppos;
 	size_t len;
 
 	if (!tsk)
@@ -789,14 +781,8 @@ static ssize_t seccomp_read(struct file 
 	/* no need to print the trailing zero, so use only len */
 	len = sprintf(__buf, "%u\n", tsk->seccomp.mode);
 	put_task_struct(tsk);
-	if (__ppos >= len)
-		return 0;
-	if (count > len - __ppos)
-		count = len - __ppos;
-	if (copy_to_user(buf, __buf + __ppos, count))
-		return -EFAULT;
-	*ppos = __ppos + count;
-	return count;
+
+	return simple_read_from_buffer(buf, count, ppos, __buf, len);
 }
 
 static ssize_t seccomp_write(struct file *file, const char __user *buf,
@@ -855,7 +841,6 @@ static ssize_t proc_fault_inject_read(st
 	char buffer[PROC_NUMBUF];
 	size_t len;
 	int make_it_fail;
-	loff_t __ppos = *ppos;
 
 	if (!task)
 		return -ESRCH;
@@ -863,14 +848,8 @@ static ssize_t proc_fault_inject_read(st
 	put_task_struct(task);
 
 	len = snprintf(buffer, sizeof(buffer), "%i\n", make_it_fail);
-	if (__ppos >= len)
-		return 0;
-	if (count > len-__ppos)
-		count = len-__ppos;
-	if (copy_to_user(buf, buffer + __ppos, count))
-		return -EFAULT;
-	*ppos = __ppos + count;
-	return count;
+
+	return simple_read_from_buffer(buf, count, ppos, buffer, len);
 }
 
 static ssize_t proc_fault_inject_write(struct file * file,
@@ -934,7 +913,7 @@ static int do_proc_readlink(struct dentr
 
 	if (!tmp)
 		return -ENOMEM;
-		
+
 	inode = dentry->d_inode;
 	path = d_path(dentry, mnt, tmp, PAGE_SIZE);
 	len = PTR_ERR(path);
