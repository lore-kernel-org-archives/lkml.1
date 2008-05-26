Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbYEZOe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbYEZOe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 10:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755273AbYEZOeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 10:34:20 -0400
Received: from smtp1.hosting90.cz ([81.0.225.81]:59424 "EHLO
	smtp1.hosting90.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbYEZOeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 10:34:20 -0400
X-Greylist: delayed 3286 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 May 2008 10:34:19 EDT
Message-ID: <483ABD88.3070403@prepere.com>
Date: Mon, 26 May 2008 15:39:20 +0200
From: Miloslav Semler <majkls@prepere.com>
User-Agent: IceDove 1.5.0.14eol (X11/20080509)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: bunk@kernel.org, bunk@stusta.de
Subject: [PATCH] fix SMP ordering hole in fcntl_setlk() (CVE-2008-1669)
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-Scan-Signature: 0cecb1c45ef38e31157820f40e6cd418
X-authenticated-id: miloslav.semler@hosting90.cz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

backport of:
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=commitdiff;h=c493a1dd8b3a93b57208319a77a8238f76dabca2
fcntl_setlk()/close() race prevention has a subtle hole - we need to
 make sure that if we *do* have an fcntl/close race on SMP box, the
 access to descriptor table and inode->i_flock won't get reordered.
 
 As it is, we get STORE inode->i_flock, LOAD descriptor table entry vs.
 STORE descriptor table entry, LOAD inode->i_flock with not a single
 lock in common on both sides.  We do have BKL around the first STORE,
 but check in locks_remove_posix() is outside of BKL and for a good
 reason - we don't want BKL on common path of close(2).
 
 Solution is to hold ->file_lock around fcheck() in there; that orders
 us wrt removal from descriptor table that preceded locks_remove_posix()
 on close path and we either come first (in which case eviction will be
 handled by the close side) or we'll see the effect of close and do
 eviction ourselves.  Note that even though it's read-only access,
 we do need ->file_lock here - rcu_read_lock() won't be enough to
 order the things.


Signed-off-by: Miloslav Semler
---
diff -uprN linux-2.6.16.60/fs/locks.c linux-2.6.16.60-new/fs/locks.c
--- linux-2.6.16.60/fs/locks.c  2008-01-27 17:58:41.000000000 +0100
+++ linux-2.6.16.60-new/fs/locks.c      2008-05-10 17:41:19.000000000 +0200
@@ -1615,6 +1615,7 @@ int fcntl_setlk(unsigned int fd, struct
        struct file_lock *file_lock = locks_alloc_lock();
        struct flock flock;
        struct inode *inode;
+       struct file *f;
        int error;

        if (file_lock == NULL)
@@ -1689,7 +1690,15 @@ again:
         * Attempt to detect a close/fcntl race and recover by
         * releasing the lock that was just acquired.
         */
-       if (!error && fcheck(fd) != filp && flock.l_type != F_UNLCK) {
+       /*
+        * we need that spin_lock here - it prevents reordering between
+        * update of inode->i_flock and check for it done in close().
+        * rcu_read_lock() wouldn't do.
+        */
+       spin_lock(&current->files->file_lock);
+       f = fcheck(fd);
+       spin_unlock(&current->files->file_lock);
+       if (!error && f != filp && flock.l_type != F_UNLCK) {
                flock.l_type = F_UNLCK;
                goto again;
        }
@@ -1758,6 +1767,7 @@ int fcntl_setlk64(unsigned int fd, struc
        struct file_lock *file_lock = locks_alloc_lock();
        struct flock64 flock;
        struct inode *inode;
+       struct file *f;
        int error;

        if (file_lock == NULL)
@@ -1832,7 +1842,10 @@ again:
         * Attempt to detect a close/fcntl race and recover by
         * releasing the lock that was just acquired.
         */
-       if (!error && fcheck(fd) != filp && flock.l_type != F_UNLCK) {
+       spin_lock(&current->files->file_lock);
+       f = fcheck(fd);
+       spin_unlock(&current->files->file_lock);
+       if (!error && f != filp && flock.l_type != F_UNLCK) {
                flock.l_type = F_UNLCK;
                goto again;
        }

