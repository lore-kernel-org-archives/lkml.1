Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab0BVLPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 06:15:20 -0500
Received: from cantor.suse.de ([195.135.220.2]:57803 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab0BVLPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 06:15:17 -0500
Date: Mon, 22 Feb 2010 22:15:10 +1100
From: Nick Piggin <npiggin@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] vfs: notify_changes() error handling
Message-ID: <20100222111510.GT9738@laptop>
References: <1266608845-13212-1-git-send-email-dmonakhov@openvz.org>
 <20100222103516.GA5131@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100222103516.GA5131@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 11:35:17AM +0100, Jan Kara wrote:
>   Hi Dmitry,
> 
> > Current inode attr setting path looks like follows
> > 
> >  ret = inode_change_ok()
> >  if(ret)
> >      goto out;
> >  /*
> >   perform private-fs specific logic here
> >   */
> >  if(ia_valid & ATTR_UID || ...)
> >     ret = vfs_dq_transfer()
> > 
> >  /*
> >    more private-fs specific logic
> >    for example update on_disk data structures.
> >    */
> > 
> >   ret = inode_setattr()
> > 
> > In fact inode_setattr() call vmtruncate() which may fail in number
> > of reasons IS_SWAPFILE, RLIMIT_FSIZE. After this many filesystem is
> > unable to rollback changes. And just live inode in inconsistent
> > state. We may check IS_SWAPFILE at the very beginning(currently it
> > is not checked), but RLIMIT_FSIZE may changed under our feet.
> > In order make things straight. Let's divide vmtruncate() in to
> > two parts which perform all checks, and second which can not fail.
> > After this notify_change() perform all necessary checks inside
> > inode_change_ok() and simply call nofail version of vmtruncate().
>   Actually, there are more problems than these in the truncate path.  Some
> filesystems can decide to fail truncate only in their .truncate method but that
> is called only after i_size is set which is too late.  Nick Piggin has a patch
> set which was addressing this problem and should be basically a superset of
> your changes. But I'm not sure whether the patch series is available somewhere
> or what it's current status. Nick?

I think Al is happy with it in principle, I changed it as he suggested.
Maybe it was put on hold for other reasons. Anyway, here is the core
patch again. It now is basically just adding more helpers, so it's not
so intrusive.

Al, what are your thoughts on merging? It doesn't appear to conflict
with the -vfs tree.

Dmitry, this doesn't solve your quota problem, but they obviously clash
rather heavily. Do you see any problems with the way my patch goes?
--
From: Nick Piggin <npiggin@suse.de>
Subject: [PATCH] truncate: introduce new sequence

Introduce a new truncate calling sequence into fs/mm subsystems. Rather than
setattr > vmtruncate > truncate, have filesystems call their truncate sequence
from ->setattr if filesystem specific operations are required. vmtruncate is
deprecated, and truncate_pagecache and inode_newsize_ok helpers introduced
previously should be used.

simple_setattr is introduced for simple in-ram filesystems to implement
the new truncate sequence. Eventually all filesystems should be converted
to implement a setattr, and the default code in notify_change should go
away.

simple_setsize is also introduced to perform just the ATTR_SIZE portion
of simple_setattr (ie. changing i_size and trimming pagecache).

To implement the new truncate sequence:
- filesystem specific manipulations (eg freeing blocks) must be done in
  the setattr method rather than ->truncate.
- vmtruncate can not be used by core code to trim blocks past i_size in
  the event of write failure after allocation, so this must be performed
  in the fs code.
- convert usage of helpers block_write_begin, nobh_write_begin,
  cont_write_begin, and *blockdev_direct_IO* to use _newtrunc postfixed
  variants. These avoid calling vmtruncate to trim blocks (see previous).
- inode_setattr should not be used. generic_setattr is a new function
  to be used to copy simple attributes into the generic inode.
- make use of the better opportunity to handle errors with the new sequence.

Big problem with the previous calling sequence: the filesystem is not called
until i_size has already changed.  This means it is not allowed to fail the
call, and also it does not know what the previous i_size was. Also, generic
code calling vmtruncate to truncate allocated blocks in case of error had
no good way to return a meaningful error (or, for example, atomically handle
block deallocation).

Cc: Christoph Hellwig <hch@lst.de>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 Documentation/filesystems/vfs.txt |    7 +-
 fs/attr.c                         |   50 ++++++++++++---
 fs/buffer.c                       |  123 ++++++++++++++++++++++++++++++--------
 fs/direct-io.c                    |   61 ++++++++++++------
 fs/libfs.c                        |   83 +++++++++++++++++++++++++
 include/linux/buffer_head.h       |    9 ++
 include/linux/fs.h                |   27 ++++++++
 mm/truncate.c                     |   10 +--
 8 files changed, 307 insertions(+), 63 deletions(-)

Index: linux-2.6/Documentation/filesystems/vfs.txt
===================================================================
--- linux-2.6.orig/Documentation/filesystems/vfs.txt
+++ linux-2.6/Documentation/filesystems/vfs.txt
@@ -401,11 +401,16 @@ otherwise noted.
   	started might not be in the page cache at the end of the
   	walk).
 
-  truncate: called by the VFS to change the size of a file.  The
+  truncate: Deprecated. This will not be called if ->setsize is defined.
+	Called by the VFS to change the size of a file.  The
  	i_size field of the inode is set to the desired size by the
  	VFS before this method is called.  This method is called by
  	the truncate(2) system call and related functionality.
 
+	Note: ->truncate and vmtruncate are deprecated. Do not add new
+	instances/calls of these. Filesystems should be converted to do their
+	truncate sequence via ->setattr().
+
   permission: called by the VFS to check for access rights on a POSIX-like
   	filesystem.
 
Index: linux-2.6/fs/attr.c
===================================================================
--- linux-2.6.orig/fs/attr.c
+++ linux-2.6/fs/attr.c
@@ -68,14 +68,14 @@ EXPORT_SYMBOL(inode_change_ok);
  * @offset:	the new size to assign to the inode
  * @Returns:	0 on success, -ve errno on failure
  *
+ * inode_newsize_ok must be called with i_mutex held.
+ *
  * inode_newsize_ok will check filesystem limits and ulimits to check that the
  * new inode size is within limits. inode_newsize_ok will also send SIGXFSZ
  * when necessary. Caller must not proceed with inode size change if failure is
  * returned. @inode must be a file (not directory), with appropriate
  * permissions to allow truncate (inode_newsize_ok does NOT check these
  * conditions).
- *
- * inode_newsize_ok must be called with i_mutex held.
  */
 int inode_newsize_ok(const struct inode *inode, loff_t offset)
 {
@@ -105,17 +105,25 @@ out_big:
 }
 EXPORT_SYMBOL(inode_newsize_ok);
 
-int inode_setattr(struct inode * inode, struct iattr * attr)
+/**
+ * generic_setattr - copy simple metadata updates into the generic inode
+ * @inode:	the inode to be updated
+ * @attr:	the new attributes
+ *
+ * generic_setattr must be called with i_mutex held.
+ *
+ * generic_setattr updates the inode's metadata with that specified
+ * in attr. Noticably missing is inode size update, which is more complex
+ * as it requires pagecache updates. See simple_setsize.
+ *
+ * The inode is not marked as dirty after this operation. The rationale is
+ * that for "simple" filesystems, the struct inode is the inode storage.
+ * The caller is free to mark the inode dirty afterwards if needed.
+ */
+void generic_setattr(struct inode *inode, const struct iattr *attr)
 {
 	unsigned int ia_valid = attr->ia_valid;
 
-	if (ia_valid & ATTR_SIZE &&
-	    attr->ia_size != i_size_read(inode)) {
-		int error = vmtruncate(inode, attr->ia_size);
-		if (error)
-			return error;
-	}
-
 	if (ia_valid & ATTR_UID)
 		inode->i_uid = attr->ia_uid;
 	if (ia_valid & ATTR_GID)
@@ -136,6 +144,28 @@ int inode_setattr(struct inode * inode,
 			mode &= ~S_ISGID;
 		inode->i_mode = mode;
 	}
+}
+EXPORT_SYMBOL(generic_setattr);
+
+/*
+ * note this function is deprecated, the new truncate sequence should be
+ * used instead -- see eg. simple_setsize, generic_setattr.
+ */
+int inode_setattr(struct inode *inode, const struct iattr *attr)
+{
+	unsigned int ia_valid = attr->ia_valid;
+
+	if (ia_valid & ATTR_SIZE &&
+	    attr->ia_size != i_size_read(inode)) {
+		int error;
+
+		error = vmtruncate(inode, attr->ia_size);
+		if (error)
+			return error;
+	}
+
+	generic_setattr(inode, attr);
+
 	mark_inode_dirty(inode);
 
 	return 0;
Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c
+++ linux-2.6/fs/buffer.c
@@ -1957,14 +1957,11 @@ static int __block_commit_write(struct i
 }
 
 /*
- * block_write_begin takes care of the basic task of block allocation and
- * bringing partial write blocks uptodate first.
- *
- * If *pagep is not NULL, then block_write_begin uses the locked page
- * at *pagep rather than allocating its own. In this case, the page will
- * not be unlocked or deallocated on failure.
+ * Filesystems implementing the new truncate sequence should use the
+ * _newtrunc postfix variant which won't incorrectly call vmtruncate.
+ * The filesystem needs to handle block truncation upon failure.
  */
-int block_write_begin(struct file *file, struct address_space *mapping,
+int block_write_begin_newtrunc(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata,
 			get_block_t *get_block)
@@ -2000,20 +1997,50 @@ int block_write_begin(struct file *file,
 			unlock_page(page);
 			page_cache_release(page);
 			*pagep = NULL;
-
-			/*
-			 * prepare_write() may have instantiated a few blocks
-			 * outside i_size.  Trim these off again. Don't need
-			 * i_size_read because we hold i_mutex.
-			 */
-			if (pos + len > inode->i_size)
-				vmtruncate(inode, inode->i_size);
 		}
 	}
 
 out:
 	return status;
 }
+EXPORT_SYMBOL(block_write_begin_newtrunc);
+
+/*
+ * block_write_begin takes care of the basic task of block allocation and
+ * bringing partial write blocks uptodate first.
+ *
+ * If *pagep is not NULL, then block_write_begin uses the locked page
+ * at *pagep rather than allocating its own. In this case, the page will
+ * not be unlocked or deallocated on failure.
+ */
+int block_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata,
+			get_block_t *get_block)
+{
+	int ret;
+
+	ret = block_write_begin_newtrunc(file, mapping, pos, len, flags,
+					pagep, fsdata, get_block);
+
+	/*
+	 * prepare_write() may have instantiated a few blocks
+	 * outside i_size.  Trim these off again. Don't need
+	 * i_size_read because we hold i_mutex.
+	 *
+	 * Filesystems which pass down their own page also cannot
+	 * call into vmtruncate here because it would lead to lock
+	 * inversion problems (*pagep is locked). This is a further
+	 * example of where the old truncate sequence is inadequate.
+	 */
+	if (unlikely(ret) && *pagep == NULL) {
+		loff_t isize = mapping->host->i_size;
+		if (pos + len > isize)
+			vmtruncate(mapping->host, isize);
+	}
+
+	return ret;
+}
 EXPORT_SYMBOL(block_write_begin);
 
 int block_write_end(struct file *file, struct address_space *mapping,
@@ -2332,7 +2359,7 @@ out:
  * For moronic filesystems that do not allow holes in file.
  * We may have to extend the file.
  */
-int cont_write_begin(struct file *file, struct address_space *mapping,
+int cont_write_begin_newtrunc(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata,
 			get_block_t *get_block, loff_t *bytes)
@@ -2353,11 +2380,30 @@ int cont_write_begin(struct file *file,
 	}
 
 	*pagep = NULL;
-	err = block_write_begin(file, mapping, pos, len,
+	err = block_write_begin_newtrunc(file, mapping, pos, len,
 				flags, pagep, fsdata, get_block);
 out:
 	return err;
 }
+EXPORT_SYMBOL(cont_write_begin_newtrunc);
+
+int cont_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata,
+			get_block_t *get_block, loff_t *bytes)
+{
+	int ret;
+
+	ret = cont_write_begin_newtrunc(file, mapping, pos, len, flags,
+					pagep, fsdata, get_block, bytes);
+	if (unlikely(ret)) {
+		loff_t isize = mapping->host->i_size;
+		if (pos + len > isize)
+			vmtruncate(mapping->host, isize);
+	}
+
+	return ret;
+}
 EXPORT_SYMBOL(cont_write_begin);
 
 int block_prepare_write(struct page *page, unsigned from, unsigned to,
@@ -2389,7 +2435,7 @@ EXPORT_SYMBOL(block_commit_write);
  *
  * We are not allowed to take the i_mutex here so we have to play games to
  * protect against truncate races as the page could now be beyond EOF.  Because
- * vmtruncate() writes the inode size before removing pages, once we have the
+ * truncate writes the inode size before removing pages, once we have the
  * page lock we can determine safely if the page is beyond EOF. If it is not
  * beyond EOF, then the page is guaranteed safe against truncation until we
  * unlock the page.
@@ -2472,10 +2518,11 @@ static void attach_nobh_buffers(struct p
 }
 
 /*
- * On entry, the page is fully not uptodate.
- * On exit the page is fully uptodate in the areas outside (from,to)
+ * Filesystems implementing the new truncate sequence should use the
+ * _newtrunc postfix variant which won't incorrectly call vmtruncate.
+ * The filesystem needs to handle block truncation upon failure.
  */
-int nobh_write_begin(struct file *file, struct address_space *mapping,
+int nobh_write_begin_newtrunc(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata,
 			get_block_t *get_block)
@@ -2508,8 +2555,8 @@ int nobh_write_begin(struct file *file,
 		unlock_page(page);
 		page_cache_release(page);
 		*pagep = NULL;
-		return block_write_begin(file, mapping, pos, len, flags, pagep,
-					fsdata, get_block);
+		return block_write_begin_newtrunc(file, mapping, pos, len,
+					flags, pagep, fsdata, get_block);
 	}
 
 	if (PageMappedToDisk(page))
@@ -2613,8 +2660,34 @@ out_release:
 	page_cache_release(page);
 	*pagep = NULL;
 
-	if (pos + len > inode->i_size)
-		vmtruncate(inode, inode->i_size);
+	return ret;
+}
+EXPORT_SYMBOL(nobh_write_begin_newtrunc);
+
+/*
+ * On entry, the page is fully not uptodate.
+ * On exit the page is fully uptodate in the areas outside (from,to)
+ */
+int nobh_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata,
+			get_block_t *get_block)
+{
+	int ret;
+
+	ret = nobh_write_begin_newtrunc(file, mapping, pos, len, flags,
+					pagep, fsdata, get_block);
+
+	/*
+	 * prepare_write() may have instantiated a few blocks
+	 * outside i_size.  Trim these off again. Don't need
+	 * i_size_read because we hold i_mutex.
+	 */
+	if (unlikely(ret)) {
+		loff_t isize = mapping->host->i_size;
+		if (pos + len > isize)
+			vmtruncate(mapping->host, isize);
+	}
 
 	return ret;
 }
Index: linux-2.6/fs/direct-io.c
===================================================================
--- linux-2.6.orig/fs/direct-io.c
+++ linux-2.6/fs/direct-io.c
@@ -1087,27 +1087,8 @@ direct_io_worker(int rw, struct kiocb *i
 	return ret;
 }
 
-/*
- * This is a library function for use by filesystem drivers.
- *
- * The locking rules are governed by the flags parameter:
- *  - if the flags value contains DIO_LOCKING we use a fancy locking
- *    scheme for dumb filesystems.
- *    For writes this function is called under i_mutex and returns with
- *    i_mutex held, for reads, i_mutex is not held on entry, but it is
- *    taken and dropped again before returning.
- *    For reads and writes i_alloc_sem is taken in shared mode and released
- *    on I/O completion (which may happen asynchronously after returning to
- *    the caller).
- *
- *  - if the flags value does NOT contain DIO_LOCKING we don't use any
- *    internal locking but rather rely on the filesystem to synchronize
- *    direct I/O reads/writes versus each other and truncate.
- *    For reads and writes both i_mutex and i_alloc_sem are not held on
- *    entry and are never taken.
- */
 ssize_t
-__blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
+__blockdev_direct_IO_newtrunc(int rw, struct kiocb *iocb, struct inode *inode,
 	struct block_device *bdev, const struct iovec *iov, loff_t offset, 
 	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
 	int flags)
@@ -1199,9 +1180,46 @@ __blockdev_direct_IO(int rw, struct kioc
 	retval = direct_io_worker(rw, iocb, inode, iov, offset,
 				nr_segs, blkbits, get_block, end_io, dio);
 
+out:
+	return retval;
+}
+EXPORT_SYMBOL(__blockdev_direct_IO_newtrunc);
+
+/*
+ * This is a library function for use by filesystem drivers.
+ *
+ * The locking rules are governed by the flags parameter:
+ *  - if the flags value contains DIO_LOCKING we use a fancy locking
+ *    scheme for dumb filesystems.
+ *    For writes this function is called under i_mutex and returns with
+ *    i_mutex held, for reads, i_mutex is not held on entry, but it is
+ *    taken and dropped again before returning.
+ *    For reads and writes i_alloc_sem is taken in shared mode and released
+ *    on I/O completion (which may happen asynchronously after returning to
+ *    the caller).
+ *
+ *  - if the flags value does NOT contain DIO_LOCKING we don't use any
+ *    internal locking but rather rely on the filesystem to synchronize
+ *    direct I/O reads/writes versus each other and truncate.
+ *    For reads and writes both i_mutex and i_alloc_sem are not held on
+ *    entry and are never taken.
+ */
+ssize_t
+__blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
+	struct block_device *bdev, const struct iovec *iov, loff_t offset,
+	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
+	int flags)
+{
+	ssize_t retval;
+
+	retval = __blockdev_direct_IO_newtrunc(rw, iocb, inode, bdev, iov,
+				offset, nr_segs, get_block, end_io, flags);
 	/*
 	 * In case of error extending write may have instantiated a few
 	 * blocks outside i_size. Trim these off again for DIO_LOCKING.
+	 * NOTE: DIO_NO_LOCK/DIO_OWN_LOCK callers have to handle this in
+	 * their own manner. This is a further example of where the old
+	 * truncate sequence is inadequate.
 	 *
 	 * NOTE: filesystems with their own locking have to handle this
 	 * on their own.
@@ -1209,12 +1227,13 @@ __blockdev_direct_IO(int rw, struct kioc
 	if (flags & DIO_LOCKING) {
 		if (unlikely((rw & WRITE) && retval < 0)) {
 			loff_t isize = i_size_read(inode);
+			loff_t end = offset + iov_length(iov, nr_segs);
+
 			if (end > isize)
 				vmtruncate(inode, isize);
 		}
 	}
 
-out:
 	return retval;
 }
 EXPORT_SYMBOL(__blockdev_direct_IO);
Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c
+++ linux-2.6/fs/libfs.c
@@ -7,6 +7,7 @@
 #include <linux/pagemap.h>
 #include <linux/mount.h>
 #include <linux/vfs.h>
+#include <linux/quotaops.h>
 #include <linux/mutex.h>
 #include <linux/exportfs.h>
 #include <linux/writeback.h>
@@ -329,6 +330,88 @@ int simple_rename(struct inode *old_dir,
 	return 0;
 }
 
+/**
+ * simple_setsize - handle core mm and vfs requirements for file size change
+ * @inode: inode
+ * @newsize: new file size
+ *
+ * Returns 0 on success, -error on failure.
+ *
+ * simple_setsize must be called with inode_mutex held.
+ *
+ * simple_setsize will check that the requested new size is OK (see
+ * inode_newsize_ok), and then will perform the necessary i_size update
+ * and pagecache truncation (if necessary). It will be typically be called
+ * from the filesystem's setattr function when ATTR_SIZE is passed in.
+ *
+ * The inode itself must have correct permissions and attributes to allow
+ * i_size to be changed, this function then just checks that the new size
+ * requested is valid.
+ *
+ * In the case of simple in-memory filesystems with inodes stored solely
+ * in the inode cache, and file data in the pagecache, nothing more needs
+ * to be done to satisfy a truncate request. Filesystems with on-disk
+ * blocks for example will need to free them in the case of truncate, in
+ * that case it may be easier not to use simple_setsize (but each of its
+ * components will likely be required at some point to update pagecache
+ * and inode etc).
+ */
+int simple_setsize(struct inode *inode, loff_t newsize)
+{
+	loff_t oldsize;
+	int error;
+
+	error = inode_newsize_ok(inode, newsize);
+	if (error)
+		return error;
+
+	oldsize = inode->i_size;
+	i_size_write(inode, newsize);
+	truncate_pagecache(inode, oldsize, newsize);
+
+	return error;
+}
+EXPORT_SYMBOL(simple_setsize);
+
+/**
+ * simple_setattr - setattr for simple in-memory filesystem
+ * @dentry: dentry
+ * @iattr: iattr structure
+ *
+ * Returns 0 on success, -error on failure.
+ *
+ * simple_setattr implements setattr for an in-memory filesystem which
+ * does not store its own file data or metadata (eg. uses the page cache
+ * and inode cache as its data store).
+ */
+int simple_setattr(struct dentry *dentry, struct iattr *iattr)
+{
+	struct inode *inode = dentry->d_inode;
+	int error;
+
+	error = inode_change_ok(inode, iattr);
+	if (error)
+		return error;
+
+	if ((iattr->ia_valid & ATTR_UID && iattr->ia_uid != inode->i_uid) ||
+	    (iattr->ia_valid & ATTR_GID && iattr->ia_gid != inode->i_gid)) {
+		error = vfs_dq_transfer(inode, iattr) ? -EDQUOT : 0;
+		if (error)
+			return error;
+	}
+
+	if (iattr->ia_valid & ATTR_SIZE) {
+		error = simple_setsize(inode, iattr->ia_size);
+		if (error)
+			return error;
+	}
+
+	generic_setattr(inode, iattr);
+
+	return error;
+}
+EXPORT_SYMBOL(simple_setattr);
+
 int simple_readpage(struct file *file, struct page *page)
 {
 	clear_highpage(page);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -2244,6 +2244,10 @@ static inline int xip_truncate_page(stru
 #endif
 
 #ifdef CONFIG_BLOCK
+ssize_t __blockdev_direct_IO_newtrunc(int rw, struct kiocb *iocb, struct inode *inode,
+	struct block_device *bdev, const struct iovec *iov, loff_t offset,
+	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
+	int lock_type);
 ssize_t __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	struct block_device *bdev, const struct iovec *iov, loff_t offset,
 	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
@@ -2257,6 +2261,24 @@ enum {
 	DIO_SKIP_HOLES	= 0x02,
 };
 
+static inline ssize_t blockdev_direct_IO_newtrunc(int rw, struct kiocb *iocb,
+	struct inode *inode, struct block_device *bdev, const struct iovec *iov,
+	loff_t offset, unsigned long nr_segs, get_block_t get_block,
+	dio_iodone_t end_io)
+{
+	return __blockdev_direct_IO_newtrunc(rw, iocb, inode, bdev, iov, offset,
+				    nr_segs, get_block, end_io,
+				    DIO_LOCKING | DIO_SKIP_HOLES);
+}
+
+static inline ssize_t blockdev_direct_IO_no_locking_newtrunc(int rw, struct kiocb *iocb,
+	struct inode *inode, struct block_device *bdev, const struct iovec *iov,
+	loff_t offset, unsigned long nr_segs, get_block_t get_block,
+	dio_iodone_t end_io)
+{
+	return __blockdev_direct_IO_newtrunc(rw, iocb, inode, bdev, iov, offset,
+				nr_segs, get_block, end_io, 0);
+}
 static inline ssize_t blockdev_direct_IO(int rw, struct kiocb *iocb,
 	struct inode *inode, struct block_device *bdev, const struct iovec *iov,
 	loff_t offset, unsigned long nr_segs, get_block_t get_block,
@@ -2327,12 +2349,14 @@ extern int dcache_dir_open(struct inode
 extern int dcache_dir_close(struct inode *, struct file *);
 extern loff_t dcache_dir_lseek(struct file *, loff_t, int);
 extern int dcache_readdir(struct file *, void *, filldir_t);
+extern int simple_setattr(struct dentry *dentry, struct iattr *attr);
 extern int simple_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int simple_statfs(struct dentry *, struct kstatfs *);
 extern int simple_link(struct dentry *, struct inode *, struct dentry *);
 extern int simple_unlink(struct inode *, struct dentry *);
 extern int simple_rmdir(struct inode *, struct dentry *);
 extern int simple_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
+extern int simple_setsize(struct inode *inode, loff_t newsize);
 extern int simple_sync_file(struct file *, struct dentry *, int);
 extern int simple_empty(struct dentry *);
 extern int simple_readpage(struct file *file, struct page *page);
@@ -2367,7 +2391,8 @@ extern int buffer_migrate_page(struct ad
 
 extern int inode_change_ok(const struct inode *, struct iattr *);
 extern int inode_newsize_ok(const struct inode *, loff_t offset);
-extern int __must_check inode_setattr(struct inode *, struct iattr *);
+extern int __must_check inode_setattr(struct inode *, const struct iattr *);
+extern void generic_setattr(struct inode *inode, const struct iattr *attr);
 
 extern void file_update_time(struct file *file);
 
Index: linux-2.6/mm/truncate.c
===================================================================
--- linux-2.6.orig/mm/truncate.c
+++ linux-2.6/mm/truncate.c
@@ -547,18 +547,18 @@ EXPORT_SYMBOL(truncate_pagecache);
  * NOTE! We have to be ready to update the memory sharing
  * between the file and the memory map for a potential last
  * incomplete page.  Ugly, but necessary.
+ *
+ * This function is deprecated and simple_setsize or truncate_pagecache
+ * should be used instead.
  */
 int vmtruncate(struct inode *inode, loff_t offset)
 {
-	loff_t oldsize;
 	int error;
 
-	error = inode_newsize_ok(inode, offset);
+	error = simple_setsize(inode, offset);
 	if (error)
 		return error;
-	oldsize = inode->i_size;
-	i_size_write(inode, offset);
-	truncate_pagecache(inode, oldsize, offset);
+
 	if (inode->i_op->truncate)
 		inode->i_op->truncate(inode);
 
Index: linux-2.6/include/linux/buffer_head.h
===================================================================
--- linux-2.6.orig/include/linux/buffer_head.h
+++ linux-2.6/include/linux/buffer_head.h
@@ -203,6 +203,9 @@ int block_write_full_page_endio(struct p
 int block_read_full_page(struct page*, get_block_t*);
 int block_is_partially_uptodate(struct page *page, read_descriptor_t *desc,
 				unsigned long from);
+int block_write_begin_newtrunc(struct file *, struct address_space *,
+				loff_t, unsigned, unsigned,
+				struct page **, void **, get_block_t*);
 int block_write_begin(struct file *, struct address_space *,
 				loff_t, unsigned, unsigned,
 				struct page **, void **, get_block_t*);
@@ -214,6 +217,9 @@ int generic_write_end(struct file *, str
 				struct page *, void *);
 void page_zero_new_buffers(struct page *page, unsigned from, unsigned to);
 int block_prepare_write(struct page*, unsigned, unsigned, get_block_t*);
+int cont_write_begin_newtrunc(struct file *, struct address_space *, loff_t,
+			unsigned, unsigned, struct page **, void **,
+			get_block_t *, loff_t *);
 int cont_write_begin(struct file *, struct address_space *, loff_t,
 			unsigned, unsigned, struct page **, void **,
 			get_block_t *, loff_t *);
@@ -225,6 +231,9 @@ void block_sync_page(struct page *);
 sector_t generic_block_bmap(struct address_space *, sector_t, get_block_t *);
 int block_truncate_page(struct address_space *, loff_t, get_block_t *);
 int file_fsync(struct file *, struct dentry *, int);
+int nobh_write_begin_newtrunc(struct file *, struct address_space *,
+				loff_t, unsigned, unsigned,
+				struct page **, void **, get_block_t*);
 int nobh_write_begin(struct file *, struct address_space *,
 				loff_t, unsigned, unsigned,
 				struct page **, void **, get_block_t*);

