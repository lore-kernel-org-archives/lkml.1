Return-Path: <linux-kernel-owner+w=401wt.eu-S1759158AbXHNK2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158AbXHNK2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 06:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbXHNK2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 06:28:11 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60434 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753104AbXHNK2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 06:28:09 -0400
X-Sasl-enc: C1mS9Xh0GpVu6Cf6JwX/AAmeztVdJCE+HJIYkyv/juZp 1187087287
Subject: [PATCH] autofs4: deadlock during create
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@osdl.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 18:28:00 +0800
Message-Id: <1187087280.4963.18.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Due to inconsistent locking in the VFS between calls to lookup and
revalidate deadlock can occur in the automounter.

The inconsistency is that the directory inode mutex is held for both
lookup and revalidate calls when called via lookup_hash whereas it is
held only for lookup during a path walk. Consequently, if the mutex
is held during a call to revalidate autofs4 can't release the mutex
to callback the daemon as it can't know whether it owns the mutex.

This situation happens when a process tries to create a directory
within an automount and a second process also tries to create the
same directory between the lookup and the mkdir. Since the first
process has dropped the mutex for the daemon callback, the second
process takes it during revalidate leading to deadlock between the
autofs daemon and the second process when the daemon tries to create
the mount point directory.

After spending quite a bit of time trying to resolve this on more than
one occassion, using rather complex and ulgy approaches, it turns out
that just delaying the hashing of the dentry until the create operation
work fine.

Signed-off-by: Ian Kent <raven@themaw.net>

---
--- linux-2.6.23-rc2-mm2/fs/autofs4/root.c.lookup-delay-hash	2007-08-14 16:41:57.000000000 +0800
+++ linux-2.6.23-rc2-mm2/fs/autofs4/root.c	2007-08-14 17:18:46.000000000 +0800
@@ -587,19 +587,20 @@ static struct dentry *autofs4_lookup(str
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
@@ -615,7 +616,6 @@ static struct dentry *autofs4_lookup(str
 			autofs4_wait(sbi, unhashed, NFY_NONE);
 			DPRINTK("request completed");
 		}
-		d_rehash(unhashed);
 		dentry = unhashed;
 	}
 
@@ -658,7 +658,7 @@ static struct dentry *autofs4_lookup(str
 	 * for all system calls, but it should be OK for the operations
 	 * we permit from an autofs.
 	 */
-	if (dentry->d_inode && d_unhashed(dentry)) {
+	if (!oz_mode && d_unhashed(dentry)) {
 		/*
 		 * A user space application can (and has done in the past)
 		 * remove and re-create this directory during the callback.
@@ -716,7 +716,7 @@ static int autofs4_dir_symlink(struct in
 	strcpy(cp, symname);
 
 	inode = autofs4_get_inode(dir->i_sb, ino);
-	d_instantiate(dentry, inode);
+	d_add(dentry, inode);
 
 	if (dir == dir->i_sb->s_root->d_inode)
 		dentry->d_op = &autofs4_root_dentry_operations;
@@ -844,7 +844,7 @@ static int autofs4_dir_mkdir(struct inod
 		return -ENOSPC;
 
 	inode = autofs4_get_inode(dir->i_sb, ino);
-	d_instantiate(dentry, inode);
+	d_add(dentry, inode);
 
 	if (dir == dir->i_sb->s_root->d_inode)
 		dentry->d_op = &autofs4_root_dentry_operations;


