Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbXLEOlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbXLEOlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 09:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbXLEOlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 09:41:12 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:54844 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbXLEOlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 09:41:10 -0500
Date: Wed, 5 Dec 2007 20:10:43 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       viro@zeniv.linux.org.uk, Christoph Hellwig <hch@lst.de>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: [RFC PATCH 4/5] Directory seek support
Message-ID: <20071205144043.GG2471@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20071205143718.GC2471@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205143718.GC2471@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Directory seek support.

Define the seek behaviour on the stored cache of dirents.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 fs/read_write.c       |   11 ---
 fs/union.c            |  171 +++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/fs.h    |    8 ++
 include/linux/union.h |   25 +++++++
 4 files changed, 205 insertions(+), 10 deletions(-)

--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -16,6 +16,7 @@
 #include <linux/syscalls.h>
 #include <linux/pagemap.h>
 #include <linux/splice.h>
+#include <linux/union.h>
 #include "read_write.h"
 
 #include <asm/uaccess.h>
@@ -116,15 +117,7 @@ EXPORT_SYMBOL(default_llseek);
 
 loff_t vfs_llseek(struct file *file, loff_t offset, int origin)
 {
-	loff_t (*fn)(struct file *, loff_t, int);
-
-	fn = no_llseek;
-	if (file->f_mode & FMODE_LSEEK) {
-		fn = default_llseek;
-		if (file->f_op && file->f_op->llseek)
-			fn = file->f_op->llseek;
-	}
-	return fn(file, offset, origin);
+	return do_llseek(file, offset, origin);
 }
 EXPORT_SYMBOL(vfs_llseek);
 
--- a/fs/union.c
+++ b/fs/union.c
@@ -614,6 +614,7 @@ static int rdcache_add_entry(struct rdst
 	this->dtype = d_type;
 	INIT_LIST_HEAD(&this->list);
 	list_add_tail(&this->list, list);
+	r->cur_dirent = this;
 	return 0;
 }
 
@@ -636,18 +637,96 @@ static int filldir_union(void *buf, cons
 	if (rdcache_find_entry(&r->dirent_cache, name, namlen))
 		return 0;
 
-	err =  cb->filldir(cb->buf, name, namlen, r->cur_off,
+	/* We come here with NULL cb->filldir from lseek path */
+	if (cb->filldir)
+		err =  cb->filldir(cb->buf, name, namlen, r->cur_off,
 				ino, d_type);
 	if (err >= 0) {
 		rdcache_add_entry(r, &r->dirent_cache,
 			name, namlen, offset, ino, d_type);
 		r->cur_off = ++r->last_off;
 		r->nr_dirents++;
+		if (r->cur_off == r->fill_off) {
+			/* We filled up to the required seek offset */
+			r->fill_off = 0;
+			err = -EINVAL;
+		}
 	}
 	cb->error = err;
 	return err;
 }
 
+/*
+ * This is called when current offset in rdcache gets changed and when
+ * we need to change the current underlying directory in the rdstate
+ * to match the current offset.
+ */
+static void update_rdstate(struct file *file)
+{
+	struct rdstate *r = file->f_rdstate;
+	loff_t off = r->cur_off;
+	struct union_mount *um;
+
+	if (!(r->flags & RDSTATE_NEED_UPDATE))
+		return;
+
+	spin_lock(&union_lock);
+	um = union_lookup(file->f_path.dentry, file->f_path.mnt);
+	spin_unlock(&union_lock);
+	if (!um)
+		goto out;
+	off -= um->nr_dirents;
+	path_put(&r->cur_path);
+	r->cur_path = file->f_path;
+	path_get(&r->cur_path);
+
+	while (off > 0) {
+		spin_lock(&union_lock);
+		um = union_lookup(r->cur_path.dentry, r->cur_path.mnt);
+		spin_unlock(&union_lock);
+		if (!um)
+			goto out;
+		off -= um->nr_dirents;
+		path_put(&r->cur_path);
+		r->cur_path = um->u_next;
+		path_get(&r->cur_path);
+	}
+out:
+	r->file_off = r->cur_dirent->off;
+}
+
+/*
+ * Returns dirents from rdcache to userspace.
+ */
+static int readdir_rdcache(struct file *file, struct rdcache_callback *cb)
+{
+	struct rdstate *r = cb->rdstate;
+	struct rdcache_entry *tmp = r->cur_dirent;
+	int err = 0;
+
+	BUG_ON(r->cur_off > r->last_off);
+
+	/* If offsets already uptodate, just return */
+	if (likely(r->cur_off == r->last_off))
+		return 0;
+
+	/*
+	 * return the entries from cur_off till last_off from rdcache to
+	 * user space.
+	 */
+	list_for_each_entry_from(tmp, &r->dirent_cache, list) {
+		err =  cb->filldir(cb->buf, tmp->name.name, tmp->name.len,
+				r->cur_off, tmp->ino, tmp->dtype);
+		r->cur_dirent = tmp;
+		if (err < 0)
+			break;
+		r->cur_off++;
+		r->flags |= RDSTATE_NEED_UPDATE;
+	}
+	update_rdstate(file);
+	return err;
+}
+
 /* Called from last fput() */
 void put_rdstate(struct rdstate *rdstate)
 {
@@ -710,6 +789,10 @@ int readdir_union(struct file *file, voi
 	cb.rdstate = rdstate;
 	cb.error = 0;
 
+	err = readdir_rdcache(file, &cb);
+	if (err)
+		return err;
+
 	offset = rdstate->file_off;
 
 	/* Read from the topmost directory */
@@ -796,6 +879,92 @@ out:
 	return err;
 }
 
+static void rdcache_rewind(struct file *file, struct rdstate *r, loff_t offset)
+{
+	struct rdcache_entry *tmp = r->cur_dirent;
+
+	list_for_each_entry_reverse_from(tmp, &r->dirent_cache, list) {
+		if (r->cur_off == offset)
+			break;
+		r->cur_dirent = tmp;
+		r->cur_off--;
+		r->flags |= RDSTATE_NEED_UPDATE;
+	}
+	update_rdstate(file);
+}
+
+static void rdcache_forward(struct file *file, struct rdstate *r, loff_t offset)
+{
+	struct rdcache_entry *tmp = r->cur_dirent;
+
+	list_for_each_entry_continue(tmp, &r->dirent_cache, list) {
+		if (r->cur_off == offset)
+			break;
+		r->cur_dirent = tmp;
+		r->cur_off++;
+		r->flags |= RDSTATE_NEED_UPDATE;
+	}
+	update_rdstate(file);
+}
+
+loff_t llseek_union(struct file *file, loff_t offset, int origin)
+{
+	loff_t err;
+	struct rdstate *r = file->f_rdstate;
+	loff_t orig_off = file->f_rdstate->cur_off;
+
+	if (!r)
+		return -EINVAL;
+
+	switch (origin) {
+	case SEEK_END:
+		/*
+		 * To support this, we need to know the end of the directory,
+		 * which may need reading _all_ the entries from the filesystem
+		 * to readdir cache, which can be expensive.
+		 *
+		 * After we have the last entry in the cache, do
+		 * offset += r->last_off;
+		 */
+		err = -EINVAL;
+		goto out;
+	case SEEK_CUR:
+		offset += r->cur_off;
+		break;
+	}
+	err = -EINVAL;
+	if (offset < 0)
+		goto out;
+
+	if (offset > r->cur_off) {
+		/* Seek forward into the cache */
+		rdcache_forward(file, r, offset);
+		if (offset > r->cur_off) {
+			/*
+			 * Need to seek beyond the cache, read dirents from into
+			 * underlying directories into rdcache.
+			 */
+			r->fill_off = offset;
+			err = readdir_union(file, NULL, NULL);
+			if (err < 0)
+				goto out;
+
+			/* readdir() failed, restore the original offset. */
+			if (offset != r->cur_off) {
+				rdcache_rewind(file, r, orig_off);
+				err = -EINVAL;
+				goto out;
+			}
+			err = offset;
+		}
+	} else {
+		rdcache_rewind(file, r, offset);
+		err = offset;
+	}
+out:
+	return err;
+}
+
 /*
  * Union mount copyup support
  */
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -803,9 +803,17 @@ struct rdstate {
 	loff_t last_off;	/* Offset to last dirent in rdcache */
 	loff_t nr_dirents;	/* Number of entries from current underlying
 				   directory in rdcache */
+	loff_t fill_off;	/* Fill cache upto this offset. Used during
+				   seek */
 	struct list_head dirent_cache;	/* cache of directory entries */
+	struct rdcache_entry *cur_dirent;	/* pointer to current directory
+				entry in rdcache which corresponds to cur_off */
+	int flags;
 };
 
+#define RDSTATE_STALE		0x01
+#define RDSTATE_NEED_UPDATE	0x02
+
 extern void put_rdstate(struct rdstate *rdstate);
 
 #else
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -55,6 +55,7 @@ extern int attach_mnt_union(struct vfsmo
 			    struct dentry *);
 extern void detach_mnt_union(struct vfsmount *);
 extern int readdir_union(struct file *, void *, filldir_t);
+extern loff_t llseek_union(struct file *, loff_t, int);
 extern int last_union_is_root(struct path *);
 extern int is_dir_unioned(struct path *);
 extern int union_relookup_topmost(struct nameidata *, int);
@@ -110,5 +111,29 @@ static inline int do_readdir(struct file
 	return res;
 }
 
+static inline loff_t do_llseek(struct file *file, loff_t offset, int origin)
+{
+	long long res;
+#ifdef CONFIG_UNION_MOUNT
+	if (IS_MNT_UNION(file->f_path.mnt) && is_dir_unioned(&file->f_path)) {
+		mutex_lock(&union_rdmutex);
+		res = llseek_union(file, offset, origin);
+		mutex_unlock(&union_rdmutex);
+	} else
+#endif
+	{
+		loff_t (*fn)(struct file *, loff_t, int);
+
+		fn = no_llseek;
+		if (file->f_mode & FMODE_LSEEK) {
+			fn = default_llseek;
+			if (file->f_op && file->f_op->llseek)
+				fn = file->f_op->llseek;
+		}
+		res = fn(file, offset, origin);
+	}
+	return res;
+}
+
 #endif	/* __KERNEL__ */
 #endif	/* __LINUX_UNION_H */
