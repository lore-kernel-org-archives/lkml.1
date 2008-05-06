Return-Path: <linux-kernel-owner+w=401wt.eu-S1764858AbYEFQXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764858AbYEFQXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757295AbYEFQXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:23:36 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33121 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbYEFQXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:23:34 -0400
Date: Tue, 6 May 2008 10:23:32 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>, "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080506162332.GI19219@parisc-linux.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506120934.GH19219@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 06:09:34AM -0600, Matthew Wilcox wrote:
> So the only likely things I can see are:
> 
>  - file locks
>  - fasync

I've wanted to fix file locks for a while.  Here's a first attempt.
It was done quickly, so I concede that it may well have bugs in it.
I found (and fixed) one with LTP.

It takes *no account* of nfsd, nor remote filesystems.  We need to have
a serious discussion about their requirements.

diff --git a/fs/locks.c b/fs/locks.c
index 663c069..cb09765 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -140,6 +140,8 @@ int lease_break_time = 45;
 #define for_each_lock(inode, lockp) \
 	for (lockp = &inode->i_flock; *lockp != NULL; lockp = &(*lockp)->fl_next)
 
+static DEFINE_SPINLOCK(file_lock_lock);
+
 static LIST_HEAD(file_lock_list);
 static LIST_HEAD(blocked_list);
 
@@ -510,9 +512,9 @@ static void __locks_delete_block(struct file_lock *waiter)
  */
 static void locks_delete_block(struct file_lock *waiter)
 {
-	lock_kernel();
+	spin_lock(&file_lock_lock);
 	__locks_delete_block(waiter);
-	unlock_kernel();
+	spin_unlock(&file_lock_lock);
 }
 
 /* Insert waiter into blocker's block list.
@@ -649,7 +651,7 @@ posix_test_lock(struct file *filp, struct file_lock *fl)
 {
 	struct file_lock *cfl;
 
-	lock_kernel();
+	spin_lock(&file_lock_lock);
 	for (cfl = filp->f_path.dentry->d_inode->i_flock; cfl; cfl = cfl->fl_next) {
 		if (!IS_POSIX(cfl))
 			continue;
@@ -662,7 +664,7 @@ posix_test_lock(struct file *filp, struct file_lock *fl)
 			fl->fl_pid = pid_vnr(cfl->fl_nspid);
 	} else
 		fl->fl_type = F_UNLCK;
-	unlock_kernel();
+	spin_unlock(&file_lock_lock);
 	return;
 }
 EXPORT_SYMBOL(posix_test_lock);
@@ -735,18 +737,21 @@ static int flock_lock_file(struct file *filp, struct file_lock *request)
 	int error = 0;
 	int found = 0;
 
-	lock_kernel();
-	if (request->fl_flags & FL_ACCESS)
+	if (request->fl_flags & FL_ACCESS) {
+		spin_lock(&file_lock_lock);
 		goto find_conflict;
+	}
 
 	if (request->fl_type != F_UNLCK) {
 		error = -ENOMEM;
+		
 		new_fl = locks_alloc_lock();
 		if (new_fl == NULL)
-			goto out;
+			goto out_unlocked;
 		error = 0;
 	}
 
+	spin_lock(&file_lock_lock);
 	for_each_lock(inode, before) {
 		struct file_lock *fl = *before;
 		if (IS_POSIX(fl))
@@ -772,10 +777,13 @@ static int flock_lock_file(struct file *filp, struct file_lock *request)
 	 * If a higher-priority process was blocked on the old file lock,
 	 * give it the opportunity to lock the file.
 	 */
-	if (found)
+	if (found) {
+		spin_unlock(&file_lock_lock);
 		cond_resched();
+		spin_lock(&file_lock_lock);
+	}
 
-find_conflict:
+ find_conflict:
 	for_each_lock(inode, before) {
 		struct file_lock *fl = *before;
 		if (IS_POSIX(fl))
@@ -796,8 +804,9 @@ find_conflict:
 	new_fl = NULL;
 	error = 0;
 
-out:
-	unlock_kernel();
+ out:
+	spin_unlock(&file_lock_lock);
+ out_unlocked:
 	if (new_fl)
 		locks_free_lock(new_fl);
 	return error;
@@ -826,7 +835,7 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 		new_fl2 = locks_alloc_lock();
 	}
 
-	lock_kernel();
+	spin_lock(&file_lock_lock);
 	if (request->fl_type != F_UNLCK) {
 		for_each_lock(inode, before) {
 			fl = *before;
@@ -994,7 +1003,7 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 		locks_wake_up_blocks(left);
 	}
  out:
-	unlock_kernel();
+	spin_unlock(&file_lock_lock);
 	/*
 	 * Free any unused locks.
 	 */
@@ -1069,14 +1078,14 @@ int locks_mandatory_locked(struct inode *inode)
 	/*
 	 * Search the lock list for this inode for any POSIX locks.
 	 */
-	lock_kernel();
+	spin_lock(&file_lock_lock);
 	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
 		if (!IS_POSIX(fl))
 			continue;
 		if (fl->fl_owner != owner)
 			break;
 	}
-	unlock_kernel();
+	spin_unlock(&file_lock_lock);
 	return fl ? -EAGAIN : 0;
 }
 
@@ -1190,7 +1199,7 @@ int __break_lease(struct inode *inode, unsigned int mode)
 
 	new_fl = lease_alloc(NULL, mode & FMODE_WRITE ? F_WRLCK : F_RDLCK);
 
-	lock_kernel();
+	spin_lock(&file_lock_lock);
 
 	time_out_leases(inode);
 
@@ -1251,8 +1260,10 @@ restart:
 			break_time++;
 	}
 	locks_insert_block(flock, new_fl);
+	spin_unlock(&file_lock_lock);
 	error = wait_event_interruptible_timeout(new_fl->fl_wait,
 						!new_fl->fl_next, break_time);
+	spin_lock(&file_lock_lock);
 	__locks_delete_block(new_fl);
 	if (error >= 0) {
 		if (error == 0)
@@ -1266,8 +1277,8 @@ restart:
 		error = 0;
 	}
 
-out:
-	unlock_kernel();
+ out:
+	spin_unlock(&file_lock_lock);
 	if (!IS_ERR(new_fl))
 		locks_free_lock(new_fl);
 	return error;
@@ -1323,7 +1334,7 @@ int fcntl_getlease(struct file *filp)
 	struct file_lock *fl;
 	int type = F_UNLCK;
 
-	lock_kernel();
+	spin_lock(&file_lock_lock);
 	time_out_leases(filp->f_path.dentry->d_inode);
 	for (fl = filp->f_path.dentry->d_inode->i_flock; fl && IS_LEASE(fl);
 			fl = fl->fl_next) {
@@ -1332,7 +1343,7 @@ int fcntl_getlease(struct file *filp)
 			break;
 		}
 	}
-	unlock_kernel();
+	spin_unlock(&file_lock_lock);
 	return type;
 }
 
@@ -1363,6 +1374,7 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
 	if (error)
 		return error;
 
+	spin_lock(&file_lock_lock);
 	time_out_leases(inode);
 
 	BUG_ON(!(*flp)->fl_lmops->fl_break);
@@ -1370,10 +1382,11 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
 	lease = *flp;
 
 	if (arg != F_UNLCK) {
+		spin_unlock(&file_lock_lock);
 		error = -ENOMEM;
 		new_fl = locks_alloc_lock();
 		if (new_fl == NULL)
-			goto out;
+			goto out_unlocked;
 
 		error = -EAGAIN;
 		if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
@@ -1382,6 +1395,7 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
 		    && ((atomic_read(&dentry->d_count) > 1)
 			|| (atomic_read(&inode->i_count) > 1)))
 			goto out;
+		spin_lock(&file_lock_lock);
 	}
 
 	/*
@@ -1429,11 +1443,14 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
 
 	locks_copy_lock(new_fl, lease);
 	locks_insert_lock(before, new_fl);
+	spin_unlock(&file_lock_lock);
 
 	*flp = new_fl;
 	return 0;
 
-out:
+ out:
+	spin_unlock(&file_lock_lock);
+ out_unlocked:
 	if (new_fl != NULL)
 		locks_free_lock(new_fl);
 	return error;
@@ -1471,12 +1488,10 @@ int vfs_setlease(struct file *filp, long arg, struct file_lock **lease)
 {
 	int error;
 
-	lock_kernel();
 	if (filp->f_op && filp->f_op->setlease)
 		error = filp->f_op->setlease(filp, arg, lease);
 	else
 		error = generic_setlease(filp, arg, lease);
-	unlock_kernel();
 
 	return error;
 }
@@ -1503,12 +1518,11 @@ int fcntl_setlease(unsigned int fd, struct file *filp, long arg)
 	if (error)
 		return error;
 
-	lock_kernel();
-
 	error = vfs_setlease(filp, arg, &flp);
 	if (error || arg == F_UNLCK)
-		goto out_unlock;
+		return error;
 
+	lock_kernel();
 	error = fasync_helper(fd, filp, 1, &flp->fl_fasync);
 	if (error < 0) {
 		/* remove lease just inserted by setlease */
@@ -1519,7 +1533,7 @@ int fcntl_setlease(unsigned int fd, struct file *filp, long arg)
 	}
 
 	error = __f_setown(filp, task_pid(current), PIDTYPE_PID, 0);
-out_unlock:
+ out_unlock:
 	unlock_kernel();
 	return error;
 }
@@ -2024,7 +2038,7 @@ void locks_remove_flock(struct file *filp)
 			fl.fl_ops->fl_release_private(&fl);
 	}
 
-	lock_kernel();
+	spin_lock(&file_lock_lock);
 	before = &inode->i_flock;
 
 	while ((fl = *before) != NULL) {
@@ -2042,7 +2056,7 @@ void locks_remove_flock(struct file *filp)
  		}
 		before = &fl->fl_next;
 	}
-	unlock_kernel();
+	spin_unlock(&file_lock_lock);
 }
 
 /**
@@ -2057,12 +2071,12 @@ posix_unblock_lock(struct file *filp, struct file_lock *waiter)
 {
 	int status = 0;
 
-	lock_kernel();
+	spin_lock(&file_lock_lock);
 	if (waiter->fl_next)
 		__locks_delete_block(waiter);
 	else
 		status = -ENOENT;
-	unlock_kernel();
+	spin_unlock(&file_lock_lock);
 	return status;
 }
 
@@ -2175,7 +2189,7 @@ static int locks_show(struct seq_file *f, void *v)
 
 static void *locks_start(struct seq_file *f, loff_t *pos)
 {
-	lock_kernel();
+	spin_lock(&file_lock_lock);
 	f->private = (void *)1;
 	return seq_list_start(&file_lock_list, *pos);
 }
@@ -2187,7 +2201,7 @@ static void *locks_next(struct seq_file *f, void *v, loff_t *pos)
 
 static void locks_stop(struct seq_file *f, void *v)
 {
-	unlock_kernel();
+	spin_unlock(&file_lock_lock);
 }
 
 struct seq_operations locks_seq_operations = {
@@ -2215,7 +2229,7 @@ int lock_may_read(struct inode *inode, loff_t start, unsigned long len)
 {
 	struct file_lock *fl;
 	int result = 1;
-	lock_kernel();
+	spin_lock(&file_lock_lock);
 	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
 		if (IS_POSIX(fl)) {
 			if (fl->fl_type == F_RDLCK)
@@ -2232,7 +2246,7 @@ int lock_may_read(struct inode *inode, loff_t start, unsigned long len)
 		result = 0;
 		break;
 	}
-	unlock_kernel();
+	spin_unlock(&file_lock_lock);
 	return result;
 }
 
@@ -2255,7 +2269,7 @@ int lock_may_write(struct inode *inode, loff_t start, unsigned long len)
 {
 	struct file_lock *fl;
 	int result = 1;
-	lock_kernel();
+	spin_lock(&file_lock_lock);
 	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
 		if (IS_POSIX(fl)) {
 			if ((fl->fl_end < start) || (fl->fl_start > (start + len)))
@@ -2270,7 +2284,7 @@ int lock_may_write(struct inode *inode, loff_t start, unsigned long len)
 		result = 0;
 		break;
 	}
-	unlock_kernel();
+	spin_unlock(&file_lock_lock);
 	return result;
 }
 

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
