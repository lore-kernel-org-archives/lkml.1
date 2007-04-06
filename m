Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbXDFGxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbXDFGxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 02:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932442AbXDFGxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 02:53:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:61302 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbXDFGxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 02:53:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type;
        b=LCcWB3cU3vwUia5a9Pkm04OeQrZ2rhCc0vO7umkB9V7Fb7Mg8SZ5+YGo7ciO6bvhq+X2djuHJ+iIbiHVK04G4vmQSjtDz/kFRKTlm84hrP6L8klHx/Zf5yNpCPF8Wm+ZDFKe46mwqYOJFVPqvfuBX/nmK/eBM4kPRM5zGb3iRK4=
Message-ID: <4615EE4E.9020502@gmail.com>
Date: Fri, 06 Apr 2007 10:53:02 +0400
From: Ignatich <ignatich@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: reiserfs-list@namesys.com
CC: linux-kernel@vger.kernel.org
Subject: REISER4: tracking down opps in reiser4_do_readpage_extent
Content-Type: multipart/mixed;
 boundary="------------080306080202050406070500"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080306080202050406070500
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I've been trying to narrow down  the possible sources of oppses in 
reiser4_do_readpage_extent (vs-1426, nikita-2688) patch by patch. 
Reverting reiser4-use-generic-file-read.patch & friends didn't have any 
effect, downgrading kernel from 2.6.21-rc5 to 2.6.20 too. Eventually it 
all came down to 0046-reiser4-drop-unused-semaphores.patch. I don't have 
a reliable way to trigger the bug, but one of my vmware sandboxes with 
reiser4 root always oppses when I do emerge binutils right after boot. 
With this patch reverted it no longer happens. **

You can find original patch at:
http://laurent.riffard.free.fr/reiser4/reiser4-for-2.6.21-rc1/broken-out/

I attached patch that adds mutex_write back to reiser4_inode, but as 
real mutex now instead of semaphore. Cryptcompress rw semaphore is not 
added back. Updated reiser4-fix-write_extent.patch with proper 
identation is also attached.

Perhaps this is not a proper fix and only hides real culprit, but at 
least I do not see oppses now. I do not yet know if this also solves 
problem with zeroed out files.

    Max

--------------080306080202050406070500
Content-Type: text/plain;
 name="reiser4-add-write-mutex.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="reiser4-add-write-mutex.patch"

diff -u -r --exclude='*.cmd' --exclude='*.o' --exclude='*.orig' --exclude='*.rej' linux-2.6.21-rc4-git7/fs/reiser4/inode.h linux-2.6.20.4/fs/reiser4/inode.h
--- linux-2.6.21-rc4-git7/fs/reiser4/inode.h	2007-03-23 14:40:53.445156464 +0300
+++ linux-2.6.20.4/fs/reiser4/inode.h	2007-04-06 04:02:40.000000000 +0400
@@ -136,6 +136,17 @@
 		cryptcompress_info_t cryptcompress_info;
 	} file_plugin_data;
 
+ 	/* this semaphore is used to serialize writes of any file plugin,
+	 * and should be invariant during file plugin conversion (which
+	 * is going in the context of ->write()).
+ 	 * inode->i_mutex can not be used for the serialization, because
+ 	 * write_unix_file uses get_user_pages which is to be used under
+ 	 * mm->mmap_sem and because it is required to take mm->mmap_sem before
+ 	 * inode->i_mutex, so inode->i_mutex would have to be up()-ed before
+ 	 * calling to get_user_pages which is unacceptable.
+	 */
+ 	struct mutex mutex_write;
+
 	/* this semaphore is to serialize readers and writers of @pset->file
 	 * when file plugin conversion is enabled
 	 */
diff -u -r --exclude='*.cmd' --exclude='*.o' --exclude='*.orig' --exclude='*.rej' linux-2.6.21-rc4-git7/fs/reiser4/plugin/file/file.c linux-2.6.20.4/fs/reiser4/plugin/file/file.c
--- linux-2.6.21-rc4-git7/fs/reiser4/plugin/file/file.c	2007-03-24 01:14:45.000000000 +0300
+++ linux-2.6.20.4/fs/reiser4/plugin/file/file.c	2007-04-06 04:02:40.000000000 +0400
@@ -1937,6 +1933,7 @@
 
 	uf_info = unix_file_inode_data(inode);
 
+	mutex_lock(&reiser4_inode_data(inode)->mutex_write);
 	get_exclusive_access(uf_info);
 
 	if (!IS_RDONLY(inode) && (vma->vm_flags & (VM_MAYWRITE | VM_SHARED))) {
@@ -1948,6 +1945,7 @@
 		result = find_file_state(inode, uf_info);
 		if (result != 0) {
 			drop_exclusive_access(uf_info);
+			mutex_unlock(&reiser4_inode_data(inode)->mutex_write);
 			reiser4_exit_context(ctx);
 			return result;
 		}
@@ -1963,6 +1961,7 @@
 			result = check_pages_unix_file(file, inode);
 			if (result) {
 				drop_exclusive_access(uf_info);
+				mutex_unlock(&reiser4_inode_data(inode)->mutex_write);
 				reiser4_exit_context(ctx);
 				return result;
 			}
@@ -1977,6 +1976,7 @@
 	result = reiser4_grab_space_force(needed, BA_CAN_COMMIT);
 	if (result) {
 		drop_exclusive_access(uf_info);
+		mutex_unlock(&reiser4_inode_data(inode)->mutex_write);
 		reiser4_exit_context(ctx);
 		return result;
 	}
@@ -1988,6 +1988,7 @@
 	}
 
 	drop_exclusive_access(uf_info);
+	mutex_unlock(&reiser4_inode_data(inode)->mutex_write);
 	reiser4_exit_context(ctx);
 	return result;
 }
@@ -2369,6 +2370,7 @@
 	if (in_reiser4 == 0) {
 		uf_info = unix_file_inode_data(inode);
 
+		mutex_lock(&reiser4_inode_data(inode)->mutex_write);
 		get_exclusive_access(uf_info);
 		if (atomic_read(&file->f_dentry->d_count) == 1 &&
 		    uf_info->container == UF_CONTAINER_EXTENTS &&
@@ -2384,6 +2386,7 @@
 			}
 		}
 		drop_exclusive_access(uf_info);
+		mutex_unlock(&reiser4_inode_data(inode)->mutex_write);
 	} else {
 		/*
 		   we are within reiser4 context already. How latter is
@@ -2678,9 +2681,11 @@
 			return PTR_ERR(ctx);
 
 		uf_info = unix_file_inode_data(dentry->d_inode);
+		mutex_lock(&reiser4_inode_data(dentry->d_inode)->mutex_write);
 		get_exclusive_access(uf_info);
 		result = setattr_truncate(dentry->d_inode, attr);
 		drop_exclusive_access(uf_info);
+		mutex_unlock(&reiser4_inode_data(dentry->d_inode)->mutex_write);
 		context_set_commit_async(ctx);
 		reiser4_exit_context(ctx);
 	} else
diff -u -r --exclude='*.cmd' --exclude='*.o' --exclude='*.orig' --exclude='*.rej' linux-2.6.21-rc4-git7/fs/reiser4/super_ops.c linux-2.6.20.4/fs/reiser4/super_ops.c
--- linux-2.6.21-rc4-git7/fs/reiser4/super_ops.c	2007-03-23 14:40:53.818099768 +0300
+++ linux-2.6.20.4/fs/reiser4/super_ops.c	2007-04-06 04:02:40.000000000 +0400
@@ -44,6 +44,7 @@
 		 * etc. that will be added to our private inode part.
 		 */
 		INIT_LIST_HEAD(get_readdir_list(&info->vfs_inode));
+		mutex_init(&info->p.mutex_write);
 		init_rwsem(&info->p.conv_sem);
 		/* init semaphore which is used during inode loading */
 		loading_init_once(&info->p);
--- original/fs/reiser4/plugin/file/cryptcompress.c	2007-04-06 08:00:28.000000000 +0400
+++ current/fs/reiser4/plugin/file/cryptcompress.c	2007-04-06 10:20:25.000000000 +0400
@@ -2783,7 +2783,7 @@
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
- 	mutex_lock(&inode->i_mutex);
+ 	mutex_lock(&reiser4_inode_data(inode)->mutex_write);
 
 	result = generic_write_checks(file, &pos, &count, 0);
   	if (unlikely(result != 0))
@@ -2803,7 +2803,7 @@
   	/* update position in a file */
   	*off = pos + result;
  out:
-	mutex_unlock(&inode->i_mutex);
+	mutex_unlock(&reiser4_inode_data(inode)->mutex_write);
 
 	context_set_commit_async(ctx);
 	reiser4_exit_context(ctx);

--------------080306080202050406070500
Content-Type: text/plain;
 name="reiser4-fix-write_extent.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="reiser4-fix-write_extent.patch"

--- original/fs/reiser4/plugin/item/extent_file_ops.c	2007-04-06 08:00:28.000000000 +0400
+++ current/fs/reiser4/plugin/item/extent_file_ops.c	2007-04-06 09:23:45.000000000 +0400
@@ -941,15 +941,15 @@
  * reiser4_write_extent - write method of extent item plugin
  * @file: file to write to
  * @buf: address of user-space buffer
- * @write_amount: number of bytes to write
- * @off: position in file to write to
+ * @count: number of bytes to write
+ * @pos: position in file to write to
  *
  */
 ssize_t reiser4_write_extent(struct file *file, const char __user *buf,
 			     size_t count, loff_t *pos)
 {
 	int have_to_update_extent;
-	int nr_pages;
+	int nr_pages, nr_dirty;
 	struct page *page;
 	jnode *jnodes[WRITE_GRANULARITY + 1];
 	struct inode *inode;
@@ -958,7 +958,7 @@
 	int i;
 	int to_page, page_off;
 	size_t left, written;
-	int result;
+	int result = 0;
 
 	inode = file->f_dentry->d_inode;
 	if (write_extent_reserve_space(inode))
@@ -972,10 +972,12 @@
 
 	BUG_ON(get_current_context()->trans->atom != NULL);
 
+	left = count;
 	index = *pos >> PAGE_CACHE_SHIFT;
 	/* calculate number of pages which are to be written */
       	end = ((*pos + count - 1) >> PAGE_CACHE_SHIFT);
 	nr_pages = end - index + 1;
+	nr_dirty = 0;
 	assert("", nr_pages <= WRITE_GRANULARITY + 1);
 
 	/* get pages and jnodes */
@@ -983,22 +985,18 @@
 		page = find_or_create_page(inode->i_mapping, index + i,
 					   reiser4_ctx_gfp_mask_get());
 		if (page == NULL) {
-			while(i --) {
-				unlock_page(jnode_page(jnodes[i]));
-				page_cache_release(jnode_page(jnodes[i]));
-			}
-			return RETERR(-ENOMEM);
+			nr_pages = i;
+			result = RETERR(-ENOMEM);
+			goto out;
 		}
 
 		jnodes[i] = jnode_of_page(page);
 		if (IS_ERR(jnodes[i])) {
 			unlock_page(page);
 			page_cache_release(page);
-			while (i --) {
-				jput(jnodes[i]);
-				page_cache_release(jnode_page(jnodes[i]));
-			}
-			return RETERR(-ENOMEM);
+			nr_pages = i;
+			result = RETERR(-ENOMEM);
+			goto out;
 		}
 		/* prevent jnode and page from disconnecting */
 		JF_SET(jnodes[i], JNODE_WRITE_PREPARED);
@@ -1009,7 +1007,6 @@
 
 	have_to_update_extent = 0;
 
-	left = count;
 	page_off = (*pos & (PAGE_CACHE_SIZE - 1));
 	for (i = 0; i < nr_pages; i ++) {
 		to_page = PAGE_CACHE_SIZE - page_off;
@@ -1052,12 +1049,19 @@
 		}
 
 		written = filemap_copy_from_user(page, page_off, buf, to_page);
+		if (unlikely(written != to_page)) {
+			unlock_page(page);
+			result = RETERR(-EFAULT);
+			break;
+		}
+
 		flush_dcache_page(page);
 		reiser4_set_page_dirty_internal(page);
 		unlock_page(page);
+		nr_dirty++;
+
 		mark_page_accessed(page);
 		SetPageUptodate(page);
-		page_cache_release(page);
 
 		if (jnodes[i]->blocknr == 0)
 			have_to_update_extent ++;
@@ -1069,25 +1073,29 @@
 	}
 
 	if (have_to_update_extent) {
-		update_extents(file, jnodes, nr_pages, *pos);
+		update_extents(file, jnodes, nr_dirty, *pos);
 	} else {
-		for (i = 0; i < nr_pages; i ++) {
+		for (i = 0; i < nr_dirty; i ++) {
+			int ret;
 			spin_lock_jnode(jnodes[i]);
-			result = reiser4_try_capture(jnodes[i],
+			ret = reiser4_try_capture(jnodes[i],
 						     ZNODE_WRITE_LOCK, 0);
-			BUG_ON(result != 0);
+			BUG_ON(ret != 0);
 			jnode_make_dirty_locked(jnodes[i]);
 			spin_unlock_jnode(jnodes[i]);
 		}
 	}
-
+out:
 	for (i = 0; i < nr_pages; i ++) {
+		page_cache_release(jnode_page(jnodes[i]));
 		JF_CLR(jnodes[i], JNODE_WRITE_PREPARED);
 		jput(jnodes[i]);
 	}
 
-	/* the only error handled so far is EFAULT on copy_from_user  */
-	return (count - left) ? (count - left) : -EFAULT;
+	/* the only errors handled so far is ENOMEM and
+	   EFAULT on copy_from_user  */
+
+	return (count - left) ? (count - left) : result;
 }
 
 static inline void zero_page(struct page *page)

--------------080306080202050406070500--
