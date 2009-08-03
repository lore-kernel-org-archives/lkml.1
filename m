Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbZHCV7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbZHCV7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbZHCV7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:59:44 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34838 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbZHCV7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:59:43 -0400
Subject: [RFC][PATCH 2/2] fix mnt_want_write_file() on special files
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Mon, 03 Aug 2009 14:59:42 -0700
References: <20090803215940.DF984602@kernel>
In-Reply-To: <20090803215940.DF984602@kernel>
Message-Id: <20090803215942.0C3462FF@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mnt_want_write_file() uses the basic assumption that
we can use a refernce to a 'struct file' with
FMODE_WRITE set in lieu of all of the expensive checks
to avoid remount,ro races.

The problem is that FMODE_WRITE is not enough.  Special
files never had a mnt_want_write() done for them, so
we have to exclude them.

This also adds a commented-out BUG_ON() that will
reliably detect if anyone tries this again.  However,
it comes at the cost of destroying any and all
performance gains that mnt_clone_write() would have
offered (and then some).

---

 linux-2.6.git-dave/fs/namespace.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff -puN fs/namespace.c~mnt_want_write_file-0 fs/namespace.c
--- linux-2.6.git/fs/namespace.c~mnt_want_write_file-0	2009-08-03 14:51:51.000000000 -0700
+++ linux-2.6.git-dave/fs/namespace.c	2009-08-03 14:52:39.000000000 -0700
@@ -294,9 +294,17 @@ EXPORT_SYMBOL_GPL(mnt_want_write);
  *
  * After finished, mnt_drop_write must be called as usual to
  * drop the reference.
+ *
+ * Be very careful using this.  You must *guarantee* that
+ * this vfsmount has at least one existing, persistent writer
+ * that can not possibly go away, before calling this.
  */
 int mnt_clone_write(struct vfsmount *mnt)
 {
+	/* This would kill the performance
+	 * optimization in this function
+	BUG_ON(count_mnt_writers(mnt) <= 0);
+	 */
 	/* superblock may be r/o */
 	if (__mnt_is_readonly(mnt))
 		return -EROFS;
@@ -312,14 +320,20 @@ EXPORT_SYMBOL_GPL(mnt_clone_write);
  * @file: the file who's mount on which to take a write
  *
  * This is like mnt_want_write, but it takes a file and can
- * do some optimisations if the file is open for write already
+ * do some optimisations if the file is open for write already.
+ * We do not do mnt_want_write() on read-only or special files,
+ * so we can not use mnt_clone_write() for them.
  */
 int mnt_want_write_file(struct file *file)
 {
-	if (!(file->f_mode & FMODE_WRITE))
-		return mnt_want_write(file->f_path.mnt);
-	else
-		return mnt_clone_write(file->f_path.mnt);
+	struct path *path = &file->f_path;
+	struct inode *inode = path->dentry->d_inode;
+
+	if ((file->f_mode & FMODE_WRITE) &&
+	    !special_file(inode->i_mode))
+		return mnt_clone_write(path->mnt);
+
+	return mnt_want_write(path->mnt);
 }
 EXPORT_SYMBOL_GPL(mnt_want_write_file);
 
diff -puN ./lib/Kconfig.debug~mnt_want_write_file-0 ./lib/Kconfig.debug
_
