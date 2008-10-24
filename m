Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbYJXLnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbYJXLnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 07:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYJXLm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 07:42:56 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:19061 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbYJXLmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 07:42:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=SNjdpvgHR86ogW+ILw/NAqYpqAzHOUsfn9COuZT+GSQxTqTpEfh+mdL9YUkTgdOm6N
         mkB9EgqEQXpVN0vDlS11Pe6z/KhNMCOd5sIY/EFVUC669YJWoXMCj29ZP8LPiPG2nJ7E
         8MUJ54NjMEW+8ZuQ6k45n5BdD5kOZNis/op7o=
Date: Fri, 24 Oct 2008 15:46:06 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk
Subject: [PATCH] proc: stop using BKL
Message-ID: <20081024114606.GA21904@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[added to proc.git]

commit e137447fbf30784a86b79707ef0d76de8c6bcf8d
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Fri Oct 24 15:30:36 2008 +0400

    proc: stop using BKL
    
    There are four BKL users in proc: de_put(), proc_lookup_de(),
    proc_readdir_de(), proc_root_readdir(),
    
    1) de_put()
    -----------
    de_put() is classic atomic_dec_and_test() refcount wrapper -- no BKL
    needed. BKL doesn't matter to possible refcount leak as well.
    
    2) proc_lookup_de()
    -------------------
    Walking PDE list is protected by proc_subdir_lock(), proc_get_inode() is
    potentially blocking, all callers of proc_lookup_de() eventually end up
    from ->lookup hooks which is protected by directory's ->i_mutex -- BKL
    doesn't protect anything.
    
    3) proc_readdir_de()
    --------------------
    "." and ".." part doesn't need BKL, walking PDE list is under
    proc_subdir_lock, calling filldir callback is potentially blocking
    because it writes to luserspace. All proc_readdir_de() callers
    eventually come from ->readdir hook which is under directory's
    ->i_mutex -- BKL doesn't protect anything.
    
    4) proc_root_readdir_de()
    -------------------------
    proc_root_readdir_de is ->readdir hook, see (3).
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 60a359b..988a807 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -14,7 +14,6 @@
 #include <linux/stat.h>
 #include <linux/module.h>
 #include <linux/mount.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/idr.h>
 #include <linux/namei.h>
@@ -379,7 +378,6 @@ struct dentry *proc_lookup_de(struct proc_dir_entry *de, struct inode *dir,
 	struct inode *inode = NULL;
 	int error = -ENOENT;
 
-	lock_kernel();
 	spin_lock(&proc_subdir_lock);
 	for (de = de->subdir; de ; de = de->next) {
 		if (de->namelen != dentry->d_name.len)
@@ -397,7 +395,6 @@ struct dentry *proc_lookup_de(struct proc_dir_entry *de, struct inode *dir,
 	}
 	spin_unlock(&proc_subdir_lock);
 out_unlock:
-	unlock_kernel();
 
 	if (inode) {
 		dentry->d_op = &proc_dentry_operations;
@@ -432,8 +429,6 @@ int proc_readdir_de(struct proc_dir_entry *de, struct file *filp, void *dirent,
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	int ret = 0;
 
-	lock_kernel();
-
 	ino = inode->i_ino;
 	i = filp->f_pos;
 	switch (i) {
@@ -487,7 +482,7 @@ int proc_readdir_de(struct proc_dir_entry *de, struct file *filp, void *dirent,
 			spin_unlock(&proc_subdir_lock);
 	}
 	ret = 1;
-out:	unlock_kernel();
+out:
 	return ret;	
 }
 
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 2543fd0..3e76bb9 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -35,16 +35,13 @@ struct proc_dir_entry *de_get(struct proc_dir_entry *de)
  */
 void de_put(struct proc_dir_entry *de)
 {
-	lock_kernel();
 	if (!atomic_read(&de->count)) {
 		printk("de_put: entry %s already free!\n", de->name);
-		unlock_kernel();
 		return;
 	}
 
 	if (atomic_dec_and_test(&de->count))
 		free_proc_entry(de);
-	unlock_kernel();
 }
 
 /*
diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index 7bc296f..a7bd61e 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -18,7 +18,6 @@
 #include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
-#include <linux/smp_lock.h>
 #include <linux/mount.h>
 #include <linux/nsproxy.h>
 #include <net/net_namespace.h>
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 7761602..f6299a2 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -16,7 +16,6 @@
 #include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
-#include <linux/smp_lock.h>
 #include <linux/mount.h>
 #include <linux/pid_namespace.h>
 
@@ -162,17 +161,12 @@ static int proc_root_readdir(struct file * filp,
 	unsigned int nr = filp->f_pos;
 	int ret;
 
-	lock_kernel();
-
 	if (nr < FIRST_PROCESS_ENTRY) {
 		int error = proc_readdir(filp, dirent, filldir);
-		if (error <= 0) {
-			unlock_kernel();
+		if (error <= 0)
 			return error;
-		}
 		filp->f_pos = FIRST_PROCESS_ENTRY;
 	}
-	unlock_kernel();
 
 	ret = proc_pid_readdir(filp, dirent, filldir);
 	return ret;
