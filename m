Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452Ab0A2Uxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0A2Uxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801Ab0A2UvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:51:18 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:42647 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab0A2UvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:51:11 -0500
Message-Id: <20100129205004.405949705@quilx.com>
References: <20100129204931.789743493@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Jan 2010 14:49:42 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>, Miklos Szeredi <miklos@szeredi.hu>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org
Subject: inodes: Support generic defragmentation
Content-Disposition: inline; filename=defrag_fs_generic
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements the ability to remove inodes in a particular slab
from inode caches. In order to remove an inode we may have to write out
the pages of an inode, the inode itself and remove the dentries referring
to the node.

Provide generic functionality that can be used by filesystems that have
their own inode caches to also tie into the defragmentation functions
that are made available here.

FIXES NEEDED!

Note Miklos comments on the patch at http://lkml.indiana.edu/hypermail/linux/kernel/0810.1/2003.html

The way we obtain a reference to a inode entry may be unreliable since inode
refcounting works in different ways. Also a reference to the superblock is necessary
in order to be able to operate on the inodes.

Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Alexander Viro <viro@ftp.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 fs/inode.c         |  123 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |    6 ++
 2 files changed, 129 insertions(+)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-01-29 12:03:04.000000000 -0600
+++ linux-2.6/fs/inode.c	2010-01-29 12:03:25.000000000 -0600
@@ -1538,6 +1538,128 @@ static int __init set_ihash_entries(char
 __setup("ihash_entries=", set_ihash_entries);
 
 /*
+ * Obtain a refcount on a list of struct inodes pointed to by v. If the
+ * inode is in the process of being freed then zap the v[] entry so that
+ * we skip the freeing attempts later.
+ *
+ * This is a generic function for the ->get slab defrag callback.
+ */
+void *get_inodes(struct kmem_cache *s, int nr, void **v)
+{
+	int i;
+
+	spin_lock(&inode_lock);
+	for (i = 0; i < nr; i++) {
+		struct inode *inode = v[i];
+
+		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE))
+			v[i] = NULL;
+		else
+			__iget(inode);
+	}
+	spin_unlock(&inode_lock);
+	return NULL;
+}
+EXPORT_SYMBOL(get_inodes);
+
+/*
+ * Function for filesystems that embedd struct inode into their own
+ * fs inode. The offset is the offset of the struct inode in the fs inode.
+ *
+ * The function adds to the pointers in v[] in order to make them point to
+ * struct inode. Then get_inodes() is used to get the refcount.
+ * The converted v[] pointers can then also be passed to the kick() callback
+ * without further processing.
+ */
+void *fs_get_inodes(struct kmem_cache *s, int nr, void **v,
+						unsigned long offset)
+{
+	int i;
+
+	for (i = 0; i < nr; i++)
+		v[i] += offset;
+
+	return get_inodes(s, nr, v);
+}
+EXPORT_SYMBOL(fs_get_inodes);
+
+/*
+ * Generic callback function slab defrag ->kick methods. Takes the
+ * array with inodes where we obtained refcounts using fs_get_inodes()
+ * or get_inodes() and tries to free them.
+ */
+void kick_inodes(struct kmem_cache *s, int nr, void **v, void *private)
+{
+	struct inode *inode;
+	int i;
+	int abort = 0;
+	LIST_HEAD(freeable);
+	int active;
+
+	for (i = 0; i < nr; i++) {
+		inode = v[i];
+		if (!inode)
+			continue;
+
+		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
+			if (remove_inode_buffers(inode))
+				/*
+				 * Should we really be doing this? Or
+				 * limit the writeback here to only a few pages?
+				 *
+				 * Possibly an expensive operation but we
+				 * cannot reclaim the inode if the pages
+				 * are still present.
+				 */
+				invalidate_mapping_pages(&inode->i_data,
+								0, -1);
+		}
+
+		/* Invalidate children and dentry */
+		if (S_ISDIR(inode->i_mode)) {
+			struct dentry *d = d_find_alias(inode);
+
+			if (d) {
+				d_invalidate(d);
+				dput(d);
+			}
+		}
+
+		if (inode->i_state & I_DIRTY)
+			write_inode_now(inode, 1);
+
+		d_prune_aliases(inode);
+	}
+
+	mutex_lock(&iprune_mutex);
+	for (i = 0; i < nr; i++) {
+		inode = v[i];
+
+		if (!inode)
+			/* inode is alrady being freed */
+			continue;
+
+		active = inode->i_sb->s_flags & MS_ACTIVE;
+		iput(inode);
+		if (abort || !active)
+			continue;
+
+		spin_lock(&inode_lock);
+		abort =  !can_unuse(inode);
+
+		if (!abort) {
+			list_move(&inode->i_list, &freeable);
+			inode->i_state |= I_FREEING;
+			inodes_stat.nr_unused--;
+		}
+		spin_unlock(&inode_lock);
+	}
+	dispose_list(&freeable);
+	mutex_unlock(&iprune_mutex);
+}
+EXPORT_SYMBOL(kick_inodes);
+
+/*
  * Initialize the waitqueues and inode hash table.
  */
 void __init inode_init_early(void)
@@ -1576,6 +1698,7 @@ void __init inode_init(void)
 					 SLAB_MEM_SPREAD),
 					 init_once);
 	register_shrinker(&icache_shrinker);
+	kmem_cache_setup_defrag(inode_cachep, get_inodes, kick_inodes);
 
 	/* Hash may have been set up in inode_init_early */
 	if (!hashdist)
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-01-29 12:03:04.000000000 -0600
+++ linux-2.6/include/linux/fs.h	2010-01-29 12:03:25.000000000 -0600
@@ -2466,5 +2466,11 @@ int __init get_filesystem_list(char *buf
 #define ACC_MODE(x) ("\004\002\006\006"[(x)&O_ACCMODE])
 #define OPEN_FMODE(flag) ((__force fmode_t)((flag + 1) & O_ACCMODE))
 
+/* Helper functions for inode defragmentation support in filesystems */
+extern void kick_inodes(struct kmem_cache *, int, void **, void *);
+extern void *get_inodes(struct kmem_cache *, int nr, void **);
+extern void *fs_get_inodes(struct kmem_cache *, int nr, void **,
+						unsigned long offset);
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_FS_H */

-- 
