Return-Path: <linux-kernel-owner+w=401wt.eu-S932180AbZHCUhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbZHCUhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932092AbZHCUhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:37:05 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42925 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090AbZHCUhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:37:03 -0400
Subject: Re: mnt_want_write_file() has problem?
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <8763d4ivi5.fsf@devron.myhome.or.jp>
References: <871vnt7vac.fsf@devron.myhome.or.jp>
	 <1249324312.26977.1336.camel@nimitz>  <8763d4ivi5.fsf@devron.myhome.or.jp>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 13:37:00 -0700
Message-Id: <1249331820.26977.1746.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 03:48 +0900, OGAWA Hirofumi wrote:
> Dave Hansen <dave@linux.vnet.ibm.com> writes:
> 
> > On Mon, 2009-08-03 at 06:36 +0900, OGAWA Hirofumi wrote:
> >> While I'm reading some code, I suspected that mnt_want_write_file() may
> >> have wrong assumption.  I think mnt_want_write_file() is assuming it
> >> increments ->mnt_writers if (file->f_mode & FMODE_WRITE). But, if it's
> >> special_file(), it is false?
> >> 
> >> Sorry, I'm still not checking all of those though. E.g. I'm thinking the
> >> below.
> >> 
> >> static inline int __get_file_write_access(struct inode *inode,
> >> 					  struct vfsmount *mnt)
> >> {
> >> [...]
> >> 	if (!special_file(inode->i_mode)) {
> >> 		/*
> >> 		 * Balanced in __fput()
> >> 		 */
> >> 		error = mnt_want_write(mnt);
> >> 		if (error)
> >> 			put_write_access(inode);
> >> 	}
> >> 	return error;
> >> }
> >
> > In practice I don't think this is an issue.  We were never supposed to
> > do mnt_want_write(mnt) for any 'struct file' that was a special_file(),
> > specifically because of what you mention.
> >
> > Nick's use of mnt_want_write_file() was a 1:1 drop-in for
> > mnt_want_write().  So, if all is well in the world, there should not be
> > any call sites where mnt_want_write_file() gets called on a
> > special_file().
> 
> void file_update_time(struct file *file)
> sys_fchmod()
> sys_fchown()
> sys_fsetxattr()
> sys_fremovexattr()
> 
> Um..., the users of mnt_want_write_file() seems to be those. I think
> all of those filp can be special file?

OK, I see where you're going now.  I think the race goes like this:

Let's say we have a process with /dev/null opened with FMODE_WRITE.  It
is the only file open on the filesystem and so the /dev mount has a 0
mnt_writers count.  That process goes to f_chmod() its fd to /dev/null.
The code checks and notices that (file->f_mode & FMODE_WRITE), and goes
to mnt_clone_write().

At the same time, another process tries to 'mount -o remount,ro /dev'.
That process never sees mnt_clone_write()'s mnt_writers bump and allows
the remount,ro, even though there's an elevated mnt_writers count.

Here's a completely untested/uncompiled patch.  I'll see if I can find a
test case that triggers this bug with the BUG_ON() in this patch.

diff --git a/fs/namespace.c b/fs/namespace.c
index 277c28a..a4714c4 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
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
+	BUG_ON(count_mnt_writers(mnt) > 0);
+	*/
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
+	    !special_file(inode))
+		return mnt_clone_write(path->mnt);
+
+	return mnt_want_write(path->mnt);
 }
 EXPORT_SYMBOL_GPL(mnt_want_write_file);
 


-- Dave

