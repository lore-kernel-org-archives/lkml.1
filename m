Return-Path: <linux-kernel-owner+w=401wt.eu-S1753006AbYHASzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbYHASzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbYHASz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:55:29 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:39223 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbYHASz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:55:27 -0400
Message-Id: <20080801182346.481748122@lameter.com>
References: <20080801182324.572058187@lameter.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 19:21:12 -0700
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>
Cc: andi@firstfloor.org
Cc: Rik van Riel <riel@redhat.com>
Cc: mpm@selenic.com
Cc: Dave Chinner <david@fromorbit.com>
Subject: [patch 11/19] inodes: Support generic defragmentation
Content-Disposition: inline; filename=0025-inodes-Support-generic-defragmentation.patch
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
--- linux-2.6.orig/fs/inode.c	2008-07-31 12:18:12.000000000 -0500
+++ linux-2.6/fs/inode.c	2008-07-31 12:18:15.000000000 -0500
@@ -1363,6 +1363,128 @@
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
@@ -1401,6 +1523,7 @@
 					 SLAB_MEM_SPREAD),
 					 init_once);
 	register_shrinker(&icache_shrinker);
+	kmem_cache_setup_defrag(inode_cachep, get_inodes, kick_inodes);
 
 	/* Hash may have been set up in inode_init_early */
 	if (!hashdist)
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-07-31 12:18:12.000000000 -0500
+++ linux-2.6/include/linux/fs.h	2008-07-31 12:18:15.000000000 -0500
@@ -1844,6 +1844,12 @@
 	__insert_inode_hash(inode, inode->i_ino);
 }
 
+/* Helper functions for inode defragmentation support in filesystems */
+extern void kick_inodes(struct kmem_cache *, int, void **, void *);
+extern void *get_inodes(struct kmem_cache *, int nr, void **);
+extern void *fs_get_inodes(struct kmem_cache *, int nr, void **,
+						unsigned long offset);
+
 extern struct file * get_empty_filp(void);
 extern void file_move(struct file *f, struct list_head *list);
 extern void file_kill(struct file *f);

-- 
