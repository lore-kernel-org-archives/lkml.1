Return-Path: <linux-kernel-owner+w=401wt.eu-S1760659AbXITIrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659AbXITIrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbXITIrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:47:37 -0400
Received: from sacred.ru ([62.205.161.221]:47781 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbXITIrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:47:36 -0400
Message-ID: <46F2330E.4040107@openvz.org>
Date: Thu, 20 Sep 2007 12:45:02 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: "J. Bruce Fields" <bfields@fieldses.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH] Rework /proc/locks via seq_files and seq_list helpers (v2)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 20 Sep 2007 12:47:22 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently /proc/locks is shown with a proc_read function, but
its behavior is rather complex as it has to manually handle
current offset and buffer length. On the other hand, files 
that show objects from lists can be easily reimplemented using
the sequential files and the seq_list_XXX() helpers.

This saves (as usually) 16 lines of code and more than 200 from
the .text section.

This patch looks rather ugly, as diff often uses curly braces
as not-changed lines, but I haven't managed to organize the 
code to make diff look better. Except for move the whole proc
related stuff upper/lower in the locks.c file...

Fixed the problem, spotted by J. Bruce Fields, about the fl
variable reuse.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/fs/locks.c b/fs/locks.c
index a1c1c01..d5b9653 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1354,6 +1354,7 @@ int fcntl_getlease(struct file *filp)
 int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
 {
 	struct file_lock *fl, **before, **my_before = NULL, *lease;
+	struct file_lock *new_fl = NULL;
 	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	int error, rdlease_count = 0, wrlease_count = 0;
@@ -1380,6 +1381,11 @@ int generic_setlease(struct file *filp, 
 		|| (atomic_read(&inode->i_count) > 1)))
 		goto out;
 
+	error = -ENOMEM;
+	new_fl = locks_alloc_lock();
+	if (new_fl == NULL)
+		goto out;
+
 	/*
 	 * At this point, we know that if there is an exclusive
 	 * lease on this file, then we hold it on this filp
@@ -1422,18 +1428,15 @@ int generic_setlease(struct file *filp, 
 	if (!leases_enable)
 		goto out;
 
-	error = -ENOMEM;
-	fl = locks_alloc_lock();
-	if (fl == NULL)
-		goto out;
-
-	locks_copy_lock(fl, lease);
-
-	locks_insert_lock(before, fl);
+	locks_copy_lock(new_fl, lease);
+	locks_insert_lock(before, new_fl);
 
 	*flp = fl;
-	error = 0;
+	return 0;
+
 out:
+	if (new_fl != NULL)
+		locks_free_lock(new_fl);
 	return error;
 }
 EXPORT_SYMBOL(generic_setlease);
