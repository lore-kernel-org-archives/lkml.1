Return-Path: <linux-kernel-owner+w=401wt.eu-S1759221AbXI0UyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221AbXI0UyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 16:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbXI0Uxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 16:53:55 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56927 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824AbXI0Uxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 16:53:52 -0400
Subject: [RFC][PATCH] make reiserfs stop using 'struct file' for internal
	xattr operations
From: Dave Hansen <haveblue@us.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Laurent Riffard <laurent.riffard@free.fr>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-devel@vger.kernel.org
In-Reply-To: <20070927202607.GA3812@infradead.org>
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
	 <46FC021F.8060109@free.fr>
	 <20070927124833.d2691813.akpm@linux-foundation.org>
	 <20070927202607.GA3812@infradead.org>
Content-Type: text/plain
Date: Thu, 27 Sep 2007 13:53:39 -0700
Message-Id: <1190926419.7344.27.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-27 at 21:26 +0100, Christoph Hellwig wrote:
> 
> Dave will probably find a bandaid to work around this, but the
> right fix is to stop using a file struct here entirely.  If you
> look at reiserfs_xattr_set it's not actually used at all except
> for passing it to ->prepare_write and ->commit_write which then
> don't use it at all.  All that crap should be rewritten to just
> pass the dentry around.  Note that all this should not acquire
> writer counts on the vfsmount - we have done this already
> before calling into the xattr methods.

I'm perplexed as to why a 'struct file' is needed, too.  The 'struct
file' doesn't get used for anything _but_ the dentry, and the functions
to which it is passed (reiserfs_prepate/commit_write()) don't use it.
In fact, some other callers just pass NULL.

This is a completely naive implementation, and I've only tested that it
compiles, but does anybody see a reason we can't just do this?

BTW, do reiserfs developers know that you can put function declarations
in header files?  ;)  4 different .c files have this:

int reiserfs_commit_write(struct page *page, unsigned from, unsigned to);
int reiserfs_prepare_write(struct page *page, unsigned from, unsigned to);

---

 lxc-dave/fs/reiserfs/inode.c |   15 ++++------
 lxc-dave/fs/reiserfs/ioctl.c |   10 ++-----
 lxc-dave/fs/reiserfs/xattr.c |   59 +++++++++++++------------------------------
 3 files changed, 28 insertions(+), 56 deletions(-)

diff -puN fs/open.c~fix-reiserfs-oops fs/open.c
diff -puN fs/file_table.c~fix-reiserfs-oops fs/file_table.c
diff -puN include/linux/mount.h~fix-reiserfs-oops include/linux/mount.h
diff -puN fs/reiserfs/xattr.c~fix-reiserfs-oops fs/reiserfs/xattr.c
--- lxc/fs/reiserfs/xattr.c~fix-reiserfs-oops	2007-09-27 13:36:38.000000000 -0700
+++ lxc-dave/fs/reiserfs/xattr.c	2007-09-27 13:49:02.000000000 -0700
@@ -194,27 +194,6 @@ static struct dentry *get_xa_file_dentry
 	return xafile;
 }
 
-/* Opens a file pointer to the attribute associated with inode */
-static struct file *open_xa_file(const struct inode *inode, const char *name,
-				 int flags)
-{
-	struct dentry *xafile;
-	struct file *fp;
-
-	xafile = get_xa_file_dentry(inode, name, flags);
-	if (IS_ERR(xafile))
-		return ERR_PTR(PTR_ERR(xafile));
-	else if (!xafile->d_inode) {
-		dput(xafile);
-		return ERR_PTR(-ENODATA);
-	}
-
-	fp = dentry_open(xafile, NULL, O_RDWR);
-	/* dentry_open dputs the dentry if it fails */
-
-	return fp;
-}
-
 /*
  * this is very similar to fs/reiserfs/dir.c:reiserfs_readdir, but
  * we need to drop the path before calling the filldir struct.  That
@@ -426,10 +405,8 @@ static inline __u32 xattr_hash(const cha
 	return csum_partial(msg, len, 0);
 }
 
-int reiserfs_commit_write(struct file *f, struct page *page,
-			  unsigned from, unsigned to);
-int reiserfs_prepare_write(struct file *f, struct page *page,
-			   unsigned from, unsigned to);
+int reiserfs_commit_write(struct page *page, unsigned from, unsigned to);
+int reiserfs_prepare_write(struct page *page, unsigned from, unsigned to);
 
 
 /* Generic extended attribute operations that can be used by xa plugins */
@@ -442,7 +419,7 @@ reiserfs_xattr_set(struct inode *inode, 
 		   size_t buffer_size, int flags)
 {
 	int err = 0;
-	struct file *fp;
+	struct dentry *dentry;
 	struct page *page;
 	char *data;
 	struct address_space *mapping;
@@ -460,18 +437,18 @@ reiserfs_xattr_set(struct inode *inode, 
 		xahash = xattr_hash(buffer, buffer_size);
 
       open_file:
-	fp = open_xa_file(inode, name, flags);
-	if (IS_ERR(fp)) {
-		err = PTR_ERR(fp);
+	dentry = get_xa_file_dentry(inode, name, flags);
+	if (IS_ERR(dentry)) {
+		err = PTR_ERR(dentry);
 		goto out;
 	}
 
-	xinode = fp->f_path.dentry->d_inode;
+	xinode = dentry->d_inode;
 	REISERFS_I(inode)->i_flags |= i_has_xattr_dir;
 
 	/* we need to copy it off.. */
 	if (xinode->i_nlink > 1) {
-		fput(fp);
+		dput(dentry);
 		err = reiserfs_xattr_del(inode, name);
 		if (err < 0)
 			goto out;
@@ -485,7 +462,7 @@ reiserfs_xattr_set(struct inode *inode, 
 	newattrs.ia_size = buffer_size;
 	newattrs.ia_valid = ATTR_SIZE | ATTR_CTIME;
 	mutex_lock(&xinode->i_mutex);
-	err = notify_change(fp->f_path.dentry, &newattrs);
+	err = notify_change(dentry, &newattrs);
 	if (err)
 		goto out_filp;
 
@@ -518,13 +495,13 @@ reiserfs_xattr_set(struct inode *inode, 
 			rxh->h_hash = cpu_to_le32(xahash);
 		}
 
-		err = reiserfs_prepare_write(fp, page, page_offset,
+		err = reiserfs_prepare_write(page, page_offset,
 					    page_offset + chunk + skip);
 		if (!err) {
 			if (buffer)
 				memcpy(data + skip, buffer + buffer_pos, chunk);
 			err =
-			    reiserfs_commit_write(fp, page, page_offset,
+			    reiserfs_commit_write(page, page_offset,
 						  page_offset + chunk +
 						  skip);
 		}
@@ -548,7 +525,7 @@ reiserfs_xattr_set(struct inode *inode, 
 
       out_filp:
 	mutex_unlock(&xinode->i_mutex);
-	fput(fp);
+	dput(dentry);
 
       out:
 	return err;
@@ -562,7 +539,7 @@ reiserfs_xattr_get(const struct inode *i
 		   size_t buffer_size)
 {
 	ssize_t err = 0;
-	struct file *fp;
+	struct dentry *dentry;
 	size_t isize;
 	size_t file_pos = 0;
 	size_t buffer_pos = 0;
@@ -578,13 +555,13 @@ reiserfs_xattr_get(const struct inode *i
 	if (get_inode_sd_version(inode) == STAT_DATA_V1)
 		return -EOPNOTSUPP;
 
-	fp = open_xa_file(inode, name, FL_READONLY);
-	if (IS_ERR(fp)) {
-		err = PTR_ERR(fp);
+	dentry = get_xa_file_dentry(inode, name, FL_READONLY);
+	if (IS_ERR(dentry)) {
+		err = PTR_ERR(dentry);
 		goto out;
 	}
 
-	xinode = fp->f_path.dentry->d_inode;
+	xinode = dentry->d_inode;
 	isize = xinode->i_size;
 	REISERFS_I(inode)->i_flags |= i_has_xattr_dir;
 
@@ -652,7 +629,7 @@ reiserfs_xattr_get(const struct inode *i
 	}
 
       out_dput:
-	fput(fp);
+	dput(dentry);
 
       out:
 	return err;
diff -puN fs/reiserfs/inode.c~fix-reiserfs-oops fs/reiserfs/inode.c
--- lxc/fs/reiserfs/inode.c~fix-reiserfs-oops	2007-09-27 13:39:47.000000000 -0700
+++ lxc-dave/fs/reiserfs/inode.c	2007-09-27 13:45:03.000000000 -0700
@@ -19,10 +19,8 @@
 #include <linux/quotaops.h>
 #include <linux/swap.h>
 
-int reiserfs_commit_write(struct file *f, struct page *page,
-			  unsigned from, unsigned to);
-int reiserfs_prepare_write(struct file *f, struct page *page,
-			   unsigned from, unsigned to);
+int reiserfs_commit_write(struct page *page,  unsigned from, unsigned to);
+int reiserfs_prepare_write(struct page *page, unsigned from, unsigned to);
 
 void reiserfs_delete_inode(struct inode *inode)
 {
@@ -550,14 +548,14 @@ static int convert_tail_for_hole(struct 
 	 ** won't trigger a get_block in this case.
 	 */
 	fix_tail_page_for_writing(tail_page);
-	retval = reiserfs_prepare_write(NULL, tail_page, tail_start, tail_end);
+	retval = reiserfs_prepare_write(tail_page, tail_start, tail_end);
 	if (retval)
 		goto unlock;
 
 	/* tail conversion might change the data in the page */
 	flush_dcache_page(tail_page);
 
-	retval = reiserfs_commit_write(NULL, tail_page, tail_start, tail_end);
+	retval = reiserfs_commit_write(tail_page, tail_start, tail_end);
 
       unlock:
 	if (tail_page != hole_page) {
@@ -2613,8 +2611,7 @@ static int reiserfs_write_begin(struct f
 	return ret;
 }
 
-int reiserfs_prepare_write(struct file *f, struct page *page,
-			   unsigned from, unsigned to)
+int reiserfs_prepare_write(struct page *page, unsigned from, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
 	int ret;
@@ -2761,7 +2758,7 @@ static int reiserfs_write_end(struct fil
 	goto out;
 }
 
-int reiserfs_commit_write(struct file *f, struct page *page,
+int reiserfs_commit_write(struct page *page,
 			  unsigned from, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
diff -puN fs/reiserfs/ioctl.c~fix-reiserfs-oops fs/reiserfs/ioctl.c
--- lxc/fs/reiserfs/ioctl.c~fix-reiserfs-oops	2007-09-27 13:42:07.000000000 -0700
+++ lxc-dave/fs/reiserfs/ioctl.c	2007-09-27 13:45:17.000000000 -0700
@@ -143,10 +143,8 @@ long reiserfs_compat_ioctl(struct file *
 }
 #endif
 
-int reiserfs_commit_write(struct file *f, struct page *page,
-			  unsigned from, unsigned to);
-int reiserfs_prepare_write(struct file *f, struct page *page,
-			   unsigned from, unsigned to);
+int reiserfs_commit_write(struct page *page, unsigned from, unsigned to);
+int reiserfs_prepare_write(struct page *page, unsigned from, unsigned to);
 /*
 ** reiserfs_unpack
 ** Function try to convert tail from direct item into indirect.
@@ -194,13 +192,13 @@ static int reiserfs_unpack(struct inode 
 	if (!page) {
 		goto out;
 	}
-	retval = reiserfs_prepare_write(NULL, page, write_from, write_from);
+	retval = reiserfs_prepare_write(page, write_from, write_from);
 	if (retval)
 		goto out_unlock;
 
 	/* conversion can change page contents, must flush */
 	flush_dcache_page(page);
-	retval = reiserfs_commit_write(NULL, page, write_from, write_from);
+	retval = reiserfs_commit_write(page, write_from, write_from);
 	REISERFS_I(inode)->i_flags |= i_nopack_mask;
 
       out_unlock:
_


-- Dave

