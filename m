Return-Path: <linux-kernel-owner+w=401wt.eu-S1761239AbXH2WsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761239AbXH2WsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 18:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755598AbXH2Wrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 18:47:55 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:41202 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751579AbXH2Wry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 18:47:54 -0400
Date: Thu, 30 Aug 2007 00:47:54 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Hua Zhong <hzhong@gmail.com>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       Ian Kent <raven@themaw.net>, autofs@linux.kernel.org
Subject: Re: regression of autofs for current git?
Message-ID: <20070829224754.GW26410@stusta.de>
References: <00f401c7ea7f$6db9fc80$492df580$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <00f401c7ea7f$6db9fc80$492df580$@com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2007 at 01:58:58PM -0700, Hua Zhong wrote:

> Hi,

Hi Hua,

> I am wondering if this is a known issue, but I just built the current git
> and several autofs mounts mysteriously disappeared. Restarting autofs could
> fix some, but then lose others. 2.6.22 was fine.
> 
> Is there anything I could check other than bisect? (It may take some time
> for me to get to it)

the commit below is the only autofs4 patch that went into the git tree 
since 2.6.22.

Does reverting it fix your problems?

> Thanks for your help.
> 
> Hua

cu
Adrian


commit 1864f7bd58351732593def024e73eca1f75bc352
Author: Ian Kent <raven@themaw.net>
Date:   Wed Aug 22 14:01:54 2007 -0700

    autofs4: deadlock during create
    
    Due to inconsistent locking in the VFS between calls to lookup and
    revalidate deadlock can occur in the automounter.
    
    The inconsistency is that the directory inode mutex is held for both lookup
    and revalidate calls when called via lookup_hash whereas it is held only
    for lookup during a path walk.  Consequently, if the mutex is held during a
    call to revalidate autofs4 can't release the mutex to callback the daemon
    as it can't know whether it owns the mutex.
    
    This situation happens when a process tries to create a directory within an
    automount and a second process also tries to create the same directory
    between the lookup and the mkdir.  Since the first process has dropped the
    mutex for the daemon callback, the second process takes it during
    revalidate leading to deadlock between the autofs daemon and the second
    process when the daemon tries to create the mount point directory.
    
    After spending quite a bit of time trying to resolve this on more than one
    occassion, using rather complex and ulgy approaches, it turns out that just
    delaying the hashing of the dentry until the create operation works fine.
    
    Signed-off-by: Ian Kent <raven@themaw.net>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 2d4c8a3..45ff3d6 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -587,19 +587,20 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 	unhashed = autofs4_lookup_unhashed(sbi, dentry->d_parent, &dentry->d_name);
 	if (!unhashed) {
 		/*
-		 * Mark the dentry incomplete, but add it. This is needed so
-		 * that the VFS layer knows about the dentry, and we can count
-		 * on catching any lookups through the revalidate.
-		 *
-		 * Let all the hard work be done by the revalidate function that
-		 * needs to be able to do this anyway..
-		 *
-		 * We need to do this before we release the directory semaphore.
+		 * Mark the dentry incomplete but don't hash it. We do this
+		 * to serialize our inode creation operations (symlink and
+		 * mkdir) which prevents deadlock during the callback to
+		 * the daemon. Subsequent user space lookups for the same
+		 * dentry are placed on the wait queue while the daemon
+		 * itself is allowed passage unresticted so the create
+		 * operation itself can then hash the dentry. Finally,
+		 * we check for the hashed dentry and return the newly
+		 * hashed dentry.
 		 */
 		dentry->d_op = &autofs4_root_dentry_operations;
 
 		dentry->d_fsdata = NULL;
-		d_add(dentry, NULL);
+		d_instantiate(dentry, NULL);
 	} else {
 		struct autofs_info *ino = autofs4_dentry_ino(unhashed);
 		DPRINTK("rehash %p with %p", dentry, unhashed);
@@ -607,15 +608,17 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 		 * If we are racing with expire the request might not
 		 * be quite complete but the directory has been removed
 		 * so it must have been successful, so just wait for it.
+		 * We need to ensure the AUTOFS_INF_EXPIRING flag is clear
+		 * before continuing as revalidate may fail when calling
+		 * try_to_fill_dentry (returning EAGAIN) if we don't.
 		 */
-		if (ino && (ino->flags & AUTOFS_INF_EXPIRING)) {
+		while (ino && (ino->flags & AUTOFS_INF_EXPIRING)) {
 			DPRINTK("wait for incomplete expire %p name=%.*s",
 				unhashed, unhashed->d_name.len,
 				unhashed->d_name.name);
 			autofs4_wait(sbi, unhashed, NFY_NONE);
 			DPRINTK("request completed");
 		}
-		d_rehash(unhashed);
 		dentry = unhashed;
 	}
 
@@ -658,7 +661,7 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 	 * for all system calls, but it should be OK for the operations
 	 * we permit from an autofs.
 	 */
-	if (dentry->d_inode && d_unhashed(dentry)) {
+	if (!oz_mode && d_unhashed(dentry)) {
 		/*
 		 * A user space application can (and has done in the past)
 		 * remove and re-create this directory during the callback.
@@ -716,7 +719,7 @@ static int autofs4_dir_symlink(struct inode *dir,
 	strcpy(cp, symname);
 
 	inode = autofs4_get_inode(dir->i_sb, ino);
-	d_instantiate(dentry, inode);
+	d_add(dentry, inode);
 
 	if (dir == dir->i_sb->s_root->d_inode)
 		dentry->d_op = &autofs4_root_dentry_operations;
@@ -844,7 +847,7 @@ static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		return -ENOSPC;
 
 	inode = autofs4_get_inode(dir->i_sb, ino);
-	d_instantiate(dentry, inode);
+	d_add(dentry, inode);
 
 	if (dir == dir->i_sb->s_root->d_inode)
 		dentry->d_op = &autofs4_root_dentry_operations;
