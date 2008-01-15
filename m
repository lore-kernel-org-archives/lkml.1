Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbYAOJZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbYAOJZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 04:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbYAOJZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 04:25:15 -0500
Received: from brick.kernel.dk ([87.55.233.238]:20348 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbYAOJZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 04:25:07 -0500
Date: Tue, 15 Jan 2008 10:25:03 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, peterz@infradead.org
Subject: Re: [PATCH][RFC] fast file mapping for loop
Message-ID: <20080115092503.GV6258@kernel.dk>
References: <20080109085231.GE6650@kernel.dk> <20080114121021.0d392102@think.oraclecorp.com> <20080114175359.GS6258@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Y/WcH0a6A93yCHGr"
Content-Disposition: inline
In-Reply-To: <20080114175359.GS6258@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y/WcH0a6A93yCHGr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 14 2008, Jens Axboe wrote:
> On Mon, Jan 14 2008, Chris Mason wrote:
> > Hello everyone,
> > 
> > Here is a modified version of Jens' patch.  The basic idea is to push
> > the mapping maintenance out of loop and down into the filesystem (ext2
> > in this case).
> > 
> > Two new address_space operations are added, one to map
> > extents and the other to provide call backs into the FS as io is
> > completed.
> > 
> > Still TODO for this patch:
> > 
> > * Add exclusion between filling holes and readers.  This is partly
> > implemented, when a hole is filled by the FS, the extent is flagged as
> > having a hole.  The idea is to check this flag before trying to read
> > the blocks and just send back all zeros.
> > 
> > The flag would be cleared when the blocks filling the hole have been
> > written.
> > 
> > * Exclude page cache readers and writers
> > 
> > * Add a way for the FS to request a commit before telling the higher
> > layers the IO is complete.  This way we can make sure metadata related
> > to holes is on disk before claiming the IO is really done.  COW based
> > filesystems will also needed it.
> > 
> > * Change loop to use fast mapping only when the new address_space op is
> > provided (whoops, forgot about this until just now)
> > 
> > * A few other bits for COW, not really relevant until there
> > is...something COW using it.
> 
> Looks pretty good. Essentially the loop side is 100% the same, it just
> offloads the extent ownership to the fs (where it belongs). So I like
> it. Attaching a small cleanup/fixup patch for loop, don't think it needs
> further explanations.
> 
> One suggestion - free_extent_map(), I would call that put_extent_map()
> instead.

I split and merged the patch into five bits (added ext3 support), so
perhaps that would be easier for people to read/review. Attached and
also exist in the loop-extent_map branch here:

http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=loop-extent_map

-- 
Jens Axboe


--Y/WcH0a6A93yCHGr
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="0001-fs-add-extent_map-library.patch"

>From b179b114b7ef6f4df1520e0013b8efe631ff577d Mon Sep 17 00:00:00 2001
From: Chris Mason <chris.mason@oracle.com>
Date: Tue, 15 Jan 2008 10:04:43 +0100
Subject: [PATCH] fs: add extent_map library

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/Makefile                |    2 +-
 fs/dcache.c                |    2 +
 fs/extent_map.c            |  402 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/extent_map.h |   58 +++++++
 4 files changed, 463 insertions(+), 1 deletions(-)
 create mode 100644 fs/extent_map.c
 create mode 100644 include/linux/extent_map.h

diff --git a/fs/Makefile b/fs/Makefile
index 500cf15..01b37aa 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -11,7 +11,7 @@ obj-y :=	open.o read_write.o file_table.o super.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o aio.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
-		stack.o
+		stack.o extent_map.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
diff --git a/fs/dcache.c b/fs/dcache.c
index d9ca1e5..edd9faa 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -31,6 +31,7 @@
 #include <linux/seqlock.h>
 #include <linux/swap.h>
 #include <linux/bootmem.h>
+#include <linux/extent_map.h>
 #include "internal.h"
 
 
@@ -2170,6 +2171,7 @@ void __init vfs_caches_init(unsigned long mempages)
 
 	dcache_init();
 	inode_init();
+	extent_map_init();
 	files_init(mempages);
 	mnt_init();
 	bdev_cache_init();
diff --git a/fs/extent_map.c b/fs/extent_map.c
new file mode 100644
index 0000000..1e9ff6e
--- /dev/null
+++ b/fs/extent_map.c
@@ -0,0 +1,402 @@
+#include <linux/err.h>
+#include <linux/gfp.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/version.h>
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/extent_map.h>
+
+static struct kmem_cache *extent_map_cache;
+
+int __init extent_map_init(void)
+{
+	extent_map_cache = kmem_cache_create("extent_map",
+					    sizeof(struct extent_map), 0,
+					    SLAB_MEM_SPREAD, NULL);
+	if (!extent_map_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+void __exit extent_map_exit(void)
+{
+	if (extent_map_cache)
+		kmem_cache_destroy(extent_map_cache);
+}
+
+void extent_map_tree_init(struct extent_map_tree *tree)
+{
+	tree->map.rb_node = NULL;
+	tree->last = NULL;
+	rwlock_init(&tree->lock);
+}
+EXPORT_SYMBOL(extent_map_tree_init);
+
+struct extent_map *alloc_extent_map(gfp_t mask)
+{
+	struct extent_map *em;
+	em = kmem_cache_alloc(extent_map_cache, mask);
+	if (!em || IS_ERR(em))
+		return em;
+	atomic_set(&em->refs, 1);
+	em->flags = 0;
+	return em;
+}
+EXPORT_SYMBOL(alloc_extent_map);
+
+void free_extent_map(struct extent_map *em)
+{
+	if (!em)
+		return;
+	if (atomic_dec_and_test(&em->refs))
+		kmem_cache_free(extent_map_cache, em);
+}
+EXPORT_SYMBOL(free_extent_map);
+
+static struct rb_node *tree_insert(struct rb_root *root, u64 offset,
+				   struct rb_node *node)
+{
+	struct rb_node ** p = &root->rb_node;
+	struct rb_node * parent = NULL;
+	struct extent_map *entry;
+
+	while(*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct extent_map, rb_node);
+
+		if (offset < entry->start)
+			p = &(*p)->rb_left;
+		else if (offset >= entry->start + entry->len)
+			p = &(*p)->rb_right;
+		else
+			return parent;
+	}
+
+	entry = rb_entry(node, struct extent_map, rb_node);
+	rb_link_node(node, parent, p);
+	rb_insert_color(node, root);
+	return NULL;
+}
+
+static struct rb_node *__tree_search(struct rb_root *root, u64 offset,
+				   struct rb_node **prev_ret)
+{
+	struct rb_node * n = root->rb_node;
+	struct rb_node *prev = NULL;
+	struct extent_map *entry;
+	struct extent_map *prev_entry = NULL;
+
+	while(n) {
+		entry = rb_entry(n, struct extent_map, rb_node);
+		prev = n;
+		prev_entry = entry;
+
+		if (offset < entry->start)
+			n = n->rb_left;
+		else if (offset >= entry->start + entry->len)
+			n = n->rb_right;
+		else
+			return n;
+	}
+	if (!prev_ret)
+		return NULL;
+	while(prev && (offset >= prev_entry->start + prev_entry->len)) {
+		prev = rb_next(prev);
+		prev_entry = rb_entry(prev, struct extent_map, rb_node);
+	}
+	*prev_ret = prev;
+	return NULL;
+}
+
+static inline struct rb_node *tree_search(struct rb_root *root, u64 offset)
+{
+	struct rb_node *prev;
+	struct rb_node *ret;
+	ret = __tree_search(root, offset, &prev);
+	if (!ret)
+		return prev;
+	return ret;
+}
+
+static int tree_delete(struct rb_root *root, u64 offset)
+{
+	struct rb_node *node;
+	struct extent_map *entry;
+
+	node = __tree_search(root, offset, NULL);
+	if (!node)
+		return -ENOENT;
+	entry = rb_entry(node, struct extent_map, rb_node);
+	rb_erase(node, root);
+	return 0;
+}
+
+static int mergable_maps(struct extent_map *prev, struct extent_map *next)
+{
+	if (extent_map_end(prev) == next->start &&
+	    prev->flags == next->flags &&
+	    ((next->block_start == EXTENT_MAP_HOLE &&
+	      prev->block_start == EXTENT_MAP_HOLE) ||
+	     (next->block_start == EXTENT_MAP_INLINE &&
+	      prev->block_start == EXTENT_MAP_INLINE) ||
+	     (next->block_start == EXTENT_MAP_DELALLOC &&
+	      prev->block_start == EXTENT_MAP_DELALLOC) ||
+	     (next->block_start < EXTENT_MAP_LAST_BYTE - 1 &&
+	      next->block_start == extent_map_block_end(prev)))) {
+		return 1;
+	}
+	return 0;
+}
+
+/*
+ * add_extent_mapping tries a simple forward/backward merge with existing
+ * mappings.  The extent_map struct passed in will be inserted into
+ * the tree directly (no copies made, just a reference taken).
+ */
+int add_extent_mapping(struct extent_map_tree *tree,
+		       struct extent_map *em)
+{
+	int ret = 0;
+	struct extent_map *merge = NULL;
+	struct rb_node *rb;
+	unsigned long flags;
+
+	write_lock_irqsave(&tree->lock, flags);
+	rb = tree_insert(&tree->map, em->start, &em->rb_node);
+	if (rb) {
+		ret = -EEXIST;
+		goto out;
+	}
+	atomic_inc(&em->refs);
+	if (em->start != 0) {
+		rb = rb_prev(&em->rb_node);
+		if (rb)
+			merge = rb_entry(rb, struct extent_map, rb_node);
+		if (rb && mergable_maps(merge, em)) {
+			em->start = merge->start;
+			em->len += merge->len;
+			em->block_start = merge->block_start;
+			rb_erase(&merge->rb_node, &tree->map);
+			free_extent_map(merge);
+		}
+	 }
+	rb = rb_next(&em->rb_node);
+	if (rb)
+		merge = rb_entry(rb, struct extent_map, rb_node);
+	if (rb && mergable_maps(em, merge)) {
+		em->len += merge->len;
+		rb_erase(&merge->rb_node, &tree->map);
+		free_extent_map(merge);
+	}
+	tree->last = em;
+out:
+	write_unlock_irqrestore(&tree->lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL(add_extent_mapping);
+
+/*
+ * lookup_extent_mapping returns the first extent_map struct in the
+ * tree that intersects the [start, len] range.  There may
+ * be additional objects in the tree that intersect, so check the object
+ * returned carefully to make sure you don't need additional lookups.
+ */
+struct extent_map *lookup_extent_mapping(struct extent_map_tree *tree,
+					 u64 start, u64 len)
+{
+	struct extent_map *em;
+	struct extent_map *last;
+	struct rb_node *rb_node;
+	unsigned long flags;
+
+	read_lock_irqsave(&tree->lock, flags);
+	last = tree->last;
+	if (last && start >= last->start &&
+	    start + len <= extent_map_end(last)) {
+		em = last;
+		atomic_inc(&em->refs);
+		goto out;
+	}
+	rb_node = tree_search(&tree->map, start);
+	if (!rb_node) {
+		em = NULL;
+		goto out;
+	}
+	if (IS_ERR(rb_node)) {
+		em = ERR_PTR(PTR_ERR(rb_node));
+		goto out;
+	}
+	em = rb_entry(rb_node, struct extent_map, rb_node);
+	if (extent_map_end(em) <= start || em->start >= start + len) {
+		em = NULL;
+		goto out;
+	}
+	atomic_inc(&em->refs);
+	tree->last = em;
+out:
+	read_unlock_irqrestore(&tree->lock, flags);
+	return em;
+}
+EXPORT_SYMBOL(lookup_extent_mapping);
+
+/*
+ * removes an extent_map struct from the tree.  No reference counts are
+ * dropped, and no checks are done to  see if the range is in use
+ */
+int remove_extent_mapping(struct extent_map_tree *tree, struct extent_map *em)
+{
+	int ret;
+	unsigned long flags;
+
+	write_lock_irqsave(&tree->lock, flags);
+	ret = tree_delete(&tree->map, em->start);
+	tree->last = NULL;
+	write_unlock_irqrestore(&tree->lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL(remove_extent_mapping);
+
+static struct extent_map *__map_extent(struct extent_map_tree *tree,
+				       struct address_space *mapping,
+				       u64 start, u64 len, int create,
+				       gfp_t gfp_mask, get_block_t get_block)
+{
+	struct inode *inode = mapping->host;
+	struct extent_map *em;
+	struct buffer_head result;
+	sector_t start_block;
+	u64 cur_len;
+	int ret;
+
+again:
+	em = lookup_extent_mapping(tree, start, len);
+	if (em) {
+		/*
+		 * we may have found an extent that starts after the
+		 * requested range.  Double check and alter the length
+		 * appropriately
+		 */
+		if (em->start > start) {
+			len = em->start - start;
+		} else if (!create || em->block_start != EXTENT_MAP_HOLE) {
+			return em;
+		}
+		free_extent_map(em);
+
+	}
+	if (gfp_mask & GFP_ATOMIC)
+		return NULL;
+
+	em = alloc_extent_map(GFP_NOFS);
+	if (!em)
+		return ERR_PTR(-ENOMEM);
+
+	len = min_t(u64, len, (size_t)-1);
+	result.b_state = 0;
+	result.b_size = len;
+	start_block = start >> inode->i_blkbits;
+
+	if (len < inode->i_sb->s_blocksize) {
+		printk("warning2: mapping length %Lu\n", len);
+	}
+
+	/*
+	 * FIXME if there are errors later on, we end up exposing stale
+	 * data on disk while filling holes.
+	 */
+	ret = get_block(inode, start_block,
+			&result, create);
+	if (ret < 0) {
+		free_extent_map(em);
+		return ERR_PTR(ret);
+	}
+
+	cur_len = result.b_size;
+	em->start = start;
+	em->len = cur_len;
+	em->bdev = result.b_bdev;
+
+	if (create && buffer_new(&result)) {
+		remove_extent_mappings(tree, em->start, em->len);
+		em->flags = (1 << EXTENT_MAP_HOLE_FILLED);
+	}
+
+	if (buffer_mapped(&result))
+		em->block_start = (u64)result.b_blocknr << inode->i_blkbits;
+	else {
+		em->block_start = EXTENT_MAP_HOLE;
+		if (create) {
+			free_extent_map(em);
+			return ERR_PTR(-EIO);
+		}
+	}
+	ret = add_extent_mapping(tree, em);
+	if (ret == -EEXIST) {
+		free_extent_map(em);
+		goto again;
+	}
+	return em;
+}
+
+struct extent_map *map_extent_get_block(struct extent_map_tree *tree,
+					struct address_space *mapping,
+					u64 start, u64 len, int create,
+					gfp_t gfp_mask, get_block_t get_block)
+{
+	struct extent_map *em;
+	u64 last;
+	u64 map_ahead_len = 0;
+
+	em = __map_extent(tree, mapping, start, len, create,
+			  gfp_mask, get_block);
+
+	/*
+	 * if we're doing a write or we found a large extent, return it
+	 */
+	if (IS_ERR(em) || !em || create || start + len < extent_map_end(em)) {
+		return em;
+	}
+
+	/*
+	 * otherwise, try to walk forward a bit and see if we can build
+	 * something bigger.
+	 */
+	do {
+		last = extent_map_end(em);
+		free_extent_map(em);
+		em = __map_extent(tree, mapping, last, len, create,
+				  gfp_mask, get_block);
+		if (IS_ERR(em) || !em)
+			break;
+		map_ahead_len += extent_map_end(em) - last;
+	} while(em->start <= start && start + len <= extent_map_end(em) &&
+		em->block_start < EXTENT_MAP_LAST_BYTE &&
+		map_ahead_len < (512 * 1024));
+
+	/* make sure we return the extent for this range */
+	if (!em || IS_ERR(em) || em->start > start ||
+	    start + len > extent_map_end(em)) {
+		free_extent_map(em);
+		em = __map_extent(tree, mapping, start, len, create,
+				  gfp_mask, get_block);
+	}
+	return em;
+}
+EXPORT_SYMBOL(map_extent_get_block);
+
+int remove_extent_mappings(struct extent_map_tree *tree,
+			   u64 start, u64 len)
+{
+	struct extent_map *em;
+
+	while((em = lookup_extent_mapping(tree, start, len))) {
+		remove_extent_mapping(tree, em);
+		/* once for us */
+		free_extent_map(em);
+		/* once for the tree */
+		free_extent_map(em);
+	}
+	return 0;
+}
+EXPORT_SYMBOL(remove_extent_mappings);
diff --git a/include/linux/extent_map.h b/include/linux/extent_map.h
new file mode 100644
index 0000000..7cdc71c
--- /dev/null
+++ b/include/linux/extent_map.h
@@ -0,0 +1,58 @@
+#ifndef __EXTENTMAP__
+#define __EXTENTMAP__
+
+#include <linux/rbtree.h>
+
+/* special values for struct extent_map->block_start */
+#define EXTENT_MAP_LAST_BYTE (u64)-4
+#define EXTENT_MAP_HOLE (u64)-3
+#define EXTENT_MAP_INLINE (u64)-2
+#define EXTENT_MAP_DELALLOC (u64)-1
+
+/* bit flags for struct extent_map->flags */
+#define EXTENT_MAP_COMMIT_REQUIRED 1
+#define EXTENT_MAP_HOLE_FILLED 2
+
+struct extent_map_tree {
+	struct rb_root map;
+	rwlock_t lock;
+	struct extent_map *last;
+};
+
+struct extent_map {
+	struct rb_node rb_node;
+	u64 start;
+	u64 len;
+	u64 block_start;
+	struct block_device *bdev;
+	atomic_t refs;
+	unsigned long flags;
+};
+
+static inline u64 extent_map_end(struct extent_map *em)
+{
+	return em->start + em->len;
+}
+
+static inline u64 extent_map_block_end(struct extent_map *em)
+{
+	return em->block_start + em->len;
+}
+
+void extent_map_tree_init(struct extent_map_tree *tree);
+struct extent_map *lookup_extent_mapping(struct extent_map_tree *tree,
+					 u64 start, u64 end);
+struct extent_map *map_extent_get_block(struct extent_map_tree *tree,
+					struct address_space *mapping,
+					u64 start, u64 len, int create,
+					gfp_t gfp_mask, get_block_t get_block);
+int add_extent_mapping(struct extent_map_tree *tree,
+		       struct extent_map *em);
+int remove_extent_mappings(struct extent_map_tree *tree,
+			   u64 start, u64 len);
+int remove_extent_mapping(struct extent_map_tree *tree, struct extent_map *em);
+struct extent_map *alloc_extent_map(gfp_t mask);
+void free_extent_map(struct extent_map *em);
+int __init extent_map_init(void);
+void __exit extent_map_exit(void);
+#endif
-- 
1.5.4.rc2.84.gf85fd


--Y/WcH0a6A93yCHGr
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="0002-fs-add-extent_map-hooks-to-the-address-space-operat.patch"

>From 10a93b6e5a2c7209c34937f946bf4a1e4b36e46d Mon Sep 17 00:00:00 2001
From: Chris Mason <chris.mason@oracle.com>
Date: Tue, 15 Jan 2008 10:05:20 +0100
Subject: [PATCH] fs: add extent_map hooks to the address space operations

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/fs.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index b3ec4a4..faf677c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -439,6 +439,7 @@ static inline size_t iov_iter_count(struct iov_iter *i)
 }
 
 
+struct extent_map;
 struct address_space_operations {
 	int (*writepage)(struct page *page, struct writeback_control *wbc);
 	int (*readpage)(struct file *, struct page *);
@@ -479,6 +480,15 @@ struct address_space_operations {
 	int (*migratepage) (struct address_space *,
 			struct page *, struct page *);
 	int (*launder_page) (struct page *);
+
+	/* raw extent mapping to the disk */
+	struct extent_map *(*map_extent)(struct address_space *mapping,
+					 struct page *page,
+					 size_t page_offset,
+					 u64 start, u64 len, int create,
+					 gfp_t gfp_mask);
+	int (*extent_io_complete)(struct address_space *mapping,
+				  u64 start, u64 len);
 };
 
 /*
-- 
1.5.4.rc2.84.gf85fd


--Y/WcH0a6A93yCHGr
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="0003-ext2-add-support-for-extent_map-API.patch"

>From bf6e48c71803f2c7dfab10196ef43ca1d8f2146f Mon Sep 17 00:00:00 2001
From: Chris Mason <chris.mason@oracle.com>
Date: Tue, 15 Jan 2008 10:05:46 +0100
Subject: [PATCH] ext2: add support for extent_map API

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/ext2/ext2.h   |    3 +++
 fs/ext2/ialloc.c |    1 +
 fs/ext2/inode.c  |   15 +++++++++++++++
 fs/ext2/super.c  |    2 ++
 4 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index c87ae29..13c0f77 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -1,5 +1,6 @@
 #include <linux/fs.h>
 #include <linux/ext2_fs.h>
+#include <linux/extent_map.h>
 
 /*
  * ext2 mount options
@@ -62,6 +63,8 @@ struct ext2_inode_info {
 	struct mutex truncate_mutex;
 	struct inode	vfs_inode;
 	struct list_head i_orphan;	/* unlinked but open inodes */
+
+	struct extent_map_tree extent_tree;
 };
 
 /*
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index 5deb8b7..d3fe368 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -584,6 +584,7 @@ got:
 	ei->i_block_alloc_info = NULL;
 	ei->i_block_group = group;
 	ei->i_dir_start_lookup = 0;
+	extent_map_tree_init(&ei->extent_tree);
 	ei->i_state = EXT2_STATE_NEW;
 	ext2_set_inode_flags(inode);
 	spin_lock(&sbi->s_next_gen_lock);
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index b1ab32a..c3555a3 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -31,6 +31,7 @@
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>
 #include <linux/mpage.h>
+#include <linux/extent_map.h>
 #include "ext2.h"
 #include "acl.h"
 #include "xip.h"
@@ -70,9 +71,11 @@ void ext2_delete_inode (struct inode * inode)
 	if (inode->i_blocks)
 		ext2_truncate (inode);
 	ext2_free_inode (inode);
+	remove_extent_mappings(&EXT2_I(inode)->extent_tree, 0, (u64)-1);
 
 	return;
 no_delete:
+	remove_extent_mappings(&EXT2_I(inode)->extent_tree, 0, (u64)-1);
 	clear_inode(inode);	/* We must guarantee clearing of inode... */
 }
 
@@ -709,6 +712,16 @@ int ext2_get_block(struct inode *inode, sector_t iblock, struct buffer_head *bh_
 
 }
 
+static struct extent_map *ext2_map_extent(struct address_space *mapping,
+					  struct page *page,
+					  size_t page_offset, u64 start,
+					  u64 len, int create, gfp_t gfp_mask)
+{
+	return map_extent_get_block(&EXT2_I(mapping->host)->extent_tree,
+				    mapping, start, len, create, gfp_mask,
+				    ext2_get_block);
+}
+
 static int ext2_writepage(struct page *page, struct writeback_control *wbc)
 {
 	return block_write_full_page(page, ext2_get_block, wbc);
@@ -796,6 +809,7 @@ const struct address_space_operations ext2_aops = {
 	.direct_IO		= ext2_direct_IO,
 	.writepages		= ext2_writepages,
 	.migratepage		= buffer_migrate_page,
+	.map_extent		= ext2_map_extent,
 };
 
 const struct address_space_operations ext2_aops_xip = {
@@ -1242,6 +1256,7 @@ void ext2_read_inode (struct inode * inode)
 	ei->i_state = 0;
 	ei->i_block_group = (ino - 1) / EXT2_INODES_PER_GROUP(inode->i_sb);
 	ei->i_dir_start_lookup = 0;
+	extent_map_tree_init(&ei->extent_tree);
 
 	/*
 	 * NOTE! The in-memory inode i_data array is in little-endian order
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 154e25f..d3bcdc1 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -156,6 +156,7 @@ static struct inode *ext2_alloc_inode(struct super_block *sb)
 
 static void ext2_destroy_inode(struct inode *inode)
 {
+	remove_extent_mappings(&EXT2_I(inode)->extent_tree, 0, (u64)-1);
 	kmem_cache_free(ext2_inode_cachep, EXT2_I(inode));
 }
 
@@ -168,6 +169,7 @@ static void init_once(struct kmem_cache * cachep, void *foo)
 	init_rwsem(&ei->xattr_sem);
 #endif
 	mutex_init(&ei->truncate_mutex);
+	extent_map_tree_init(&ei->extent_tree);
 	inode_init_once(&ei->vfs_inode);
 }
 
-- 
1.5.4.rc2.84.gf85fd


--Y/WcH0a6A93yCHGr
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="0004-ext3-add-support-for-extent_map-API.patch"

>From 0bed11ab335981f8ef9a0fe98785c0d2f0200c52 Mon Sep 17 00:00:00 2001
From: Jens Axboe <jens.axboe@oracle.com>
Date: Tue, 15 Jan 2008 10:06:08 +0100
Subject: [PATCH] ext3: add support for extent_map API

Just a port of Chris' ext2 version.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/ext3/ialloc.c          |    2 ++
 fs/ext3/inode.c           |   18 ++++++++++++++++++
 fs/ext3/super.c           |    2 ++
 include/linux/ext3_fs_i.h |    3 +++
 4 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 1bc8cd8..94fdb46 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -23,6 +23,7 @@
 #include <linux/buffer_head.h>
 #include <linux/random.h>
 #include <linux/bitops.h>
+#include <linux/extent_map.h>
 
 #include <asm/byteorder.h>
 
@@ -579,6 +580,7 @@ got:
 	ei->i_dtime = 0;
 	ei->i_block_alloc_info = NULL;
 	ei->i_block_group = group;
+	extent_map_tree_init(&ei->extent_tree);
 
 	ext3_set_inode_flags(inode);
 	if (IS_DIRSYNC(inode))
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 9b162cd..55e677d 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -36,6 +36,7 @@
 #include <linux/mpage.h>
 #include <linux/uio.h>
 #include <linux/bio.h>
+#include <linux/extent_map.h>
 #include "xattr.h"
 #include "acl.h"
 
@@ -228,8 +229,10 @@ void ext3_delete_inode (struct inode * inode)
 	else
 		ext3_free_inode(handle, inode);
 	ext3_journal_stop(handle);
+	remove_extent_mappings(&EXT3_I(inode)->extent_tree, 0, (u64) -1);
 	return;
 no_delete:
+	remove_extent_mappings(&EXT3_I(inode)->extent_tree, 0, (u64) -1);
 	clear_inode(inode);	/* We must guarantee clearing of inode... */
 }
 
@@ -993,6 +996,17 @@ get_block:
 	return ret;
 }
 
+static struct extent_map *ext3_map_extent(struct address_space *mapping,
+					  struct page *page, size_t page_offset,
+					  u64 start, u64 len, int create,
+					  gfp_t gfp_mask)
+{
+	struct extent_map_tree *tree = &EXT3_I(mapping->host)->extent_tree;
+
+	return map_extent_get_block(tree, mapping, start, len, create, gfp_mask,
+					ext3_get_block);
+}
+
 /*
  * `handle' can be NULL if create is zero
  */
@@ -1780,6 +1794,7 @@ static const struct address_space_operations ext3_ordered_aops = {
 	.releasepage	= ext3_releasepage,
 	.direct_IO	= ext3_direct_IO,
 	.migratepage	= buffer_migrate_page,
+	.map_extent	= ext3_map_extent,
 };
 
 static const struct address_space_operations ext3_writeback_aops = {
@@ -1794,6 +1809,7 @@ static const struct address_space_operations ext3_writeback_aops = {
 	.releasepage	= ext3_releasepage,
 	.direct_IO	= ext3_direct_IO,
 	.migratepage	= buffer_migrate_page,
+	.map_extent	= ext3_map_extent,
 };
 
 static const struct address_space_operations ext3_journalled_aops = {
@@ -1807,6 +1823,7 @@ static const struct address_space_operations ext3_journalled_aops = {
 	.bmap		= ext3_bmap,
 	.invalidatepage	= ext3_invalidatepage,
 	.releasepage	= ext3_releasepage,
+	.map_extent	= ext3_map_extent,
 };
 
 void ext3_set_aops(struct inode *inode)
@@ -2785,6 +2802,7 @@ void ext3_read_inode(struct inode * inode)
 			init_special_inode(inode, inode->i_mode,
 			   new_decode_dev(le32_to_cpu(raw_inode->i_block[1])));
 	}
+	extent_map_tree_init(&ei->extent_tree);
 	brelse (iloc.bh);
 	ext3_set_inode_flags(inode);
 	return;
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index cb14de1..8bc026f 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -469,6 +469,7 @@ static void ext3_destroy_inode(struct inode *inode)
 				false);
 		dump_stack();
 	}
+	remove_extent_mappings(&EXT3_I(inode)->extent_tree, 0, (u64) -1);
 	kmem_cache_free(ext3_inode_cachep, EXT3_I(inode));
 }
 
@@ -481,6 +482,7 @@ static void init_once(struct kmem_cache * cachep, void *foo)
 	init_rwsem(&ei->xattr_sem);
 #endif
 	mutex_init(&ei->truncate_mutex);
+	extent_map_tree_init(&ei->extent_tree);
 	inode_init_once(&ei->vfs_inode);
 }
 
diff --git a/include/linux/ext3_fs_i.h b/include/linux/ext3_fs_i.h
index 7894dd0..db7bab2 100644
--- a/include/linux/ext3_fs_i.h
+++ b/include/linux/ext3_fs_i.h
@@ -20,6 +20,7 @@
 #include <linux/rbtree.h>
 #include <linux/seqlock.h>
 #include <linux/mutex.h>
+#include <linux/extent_map.h>
 
 /* data type for block offset of block group */
 typedef int ext3_grpblk_t;
@@ -142,6 +143,8 @@ struct ext3_inode_info {
 	 */
 	struct mutex truncate_mutex;
 	struct inode vfs_inode;
+
+	struct extent_map_tree extent_tree;
 };
 
 #endif	/* _LINUX_EXT3_FS_I */
-- 
1.5.4.rc2.84.gf85fd


--Y/WcH0a6A93yCHGr
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="0005-loop-fastfs-support.patch"

>From 1f8a7cd25cee70cfa2c022993b371b8d1b8d1abf Mon Sep 17 00:00:00 2001
From: Jens Axboe <jens.axboe@oracle.com>
Date: Tue, 15 Jan 2008 10:06:34 +0100
Subject: [PATCH] loop: fastfs support

Add code to support redirecting IO directly to the filesystem blocks
instead of going through the page cache.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/block/loop.c |  466 +++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/loop.h |   13 ++
 2 files changed, 472 insertions(+), 7 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index b8af22e..ba46149 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -76,6 +76,7 @@
 #include <linux/gfp.h>
 #include <linux/kthread.h>
 #include <linux/splice.h>
+#include <linux/extent_map.h>
 
 #include <asm/uaccess.h>
 
@@ -481,16 +482,55 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
 	return ret;
 }
 
+#define __lo_throttle(wq, lock, condition)				\
+do {									\
+	DEFINE_WAIT(__wait);						\
+	for (;;) {							\
+		prepare_to_wait((wq), &__wait, TASK_UNINTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		spin_unlock_irq((lock));				\
+		io_schedule();						\
+		spin_lock_irq((lock));					\
+	}								\
+	finish_wait((wq), &__wait);					\
+} while (0)								\
+
+static inline int lo_act_bio(struct bio *bio)
+{
+	return bio->bi_bdev != NULL;
+}
+
+#define LO_BIO_THROTTLE	128
+
+/*
+ * A normal block device will throttle on request allocation. Do the same
+ * for loop to prevent millions of bio's queued internally.
+ */
+static void loop_bio_throttle(struct loop_device *lo, struct bio *bio)
+{
+	if (lo_act_bio(bio))
+		__lo_throttle(&lo->lo_bio_wait, &lo->lo_lock,
+				lo->lo_bio_cnt < LO_BIO_THROTTLE);
+}
+
 /*
- * Add bio to back of pending list
+ * Add bio to back of pending list and wakeup thread
  */
 static void loop_add_bio(struct loop_device *lo, struct bio *bio)
 {
+	loop_bio_throttle(lo, bio);
+
 	if (lo->lo_biotail) {
 		lo->lo_biotail->bi_next = bio;
 		lo->lo_biotail = bio;
 	} else
 		lo->lo_bio = lo->lo_biotail = bio;
+
+	if (lo_act_bio(bio))
+		lo->lo_bio_cnt++;
+
+	wake_up(&lo->lo_event);
 }
 
 /*
@@ -510,6 +550,179 @@ static struct bio *loop_get_bio(struct loop_device *lo)
 	return bio;
 }
 
+static void loop_exit_fastfs(struct loop_device *lo)
+{
+	/*
+	 * drop what page cache we instantiated filling holes
+	 */
+	invalidate_inode_pages2(lo->lo_backing_file->f_mapping);
+
+	blk_queue_ordered(lo->lo_queue, QUEUE_ORDERED_NONE, NULL);
+}
+
+static inline u64 lo_bio_offset(struct loop_device *lo, struct bio *bio)
+{
+	return (u64)lo->lo_offset + ((u64)bio->bi_sector << 9);
+}
+
+/*
+ * Find extent mapping this lo device block to the file block on the real
+ * device
+ */
+static struct extent_map *loop_lookup_extent(struct loop_device *lo,
+					     u64 offset, gfp_t gfp_mask)
+{
+	struct address_space *mapping;
+	struct extent_map *em;
+	u64 len = 1 << lo->blkbits;
+
+	mapping = lo->lo_backing_file->f_mapping;
+	em = mapping->a_ops->map_extent(mapping, NULL, 0,
+					offset, len, 0, gfp_mask);
+	return em;
+}
+
+/*
+ * Alloc a hint bio to tell the loop thread to read file blocks for a given
+ * range
+ */
+static void loop_schedule_extent_mapping(struct loop_device *lo,
+					 sector_t sector,
+					 unsigned long len, int wait)
+{
+	struct bio *bio, stackbio;
+
+	/*
+	 * it's ok if we occasionally fail. if called with blocking set,
+	 * then use an on-stack bio since that must not fail.
+	 */
+	if (wait) {
+		bio = &stackbio;
+		bio_init(bio);
+	} else
+		bio = bio_alloc(GFP_ATOMIC, 0);
+
+	if (bio) {
+		DECLARE_COMPLETION_ONSTACK(comp);
+
+		bio->bi_rw = LOOP_EXTENT_RW_MAGIC;
+		bio->bi_sector = sector;
+		bio->bi_size = len;
+
+		loop_add_bio(lo, bio);
+
+		if (wait) {
+			/*
+			 * ok to set here, loop_add_bio() doesn't drop lock
+			 * for this bio (!lo_act_bio(bio))
+			 */
+			bio->bi_private = &comp;
+
+			/*
+			 * never called with wait != 0 where it's not
+			 * allowed to use spin_unlock_irq() which
+			 * unconditionally enables interrupts.
+			 */
+			spin_unlock_irq(&lo->lo_lock);
+			wait_for_completion(&comp);
+			spin_lock_irq(&lo->lo_lock);
+		}
+	}
+}
+
+static void loop_handle_extent_hole(struct loop_device *lo, struct bio *bio)
+{
+	/*
+	 * for a read, just zero the data and end the io
+	 */
+	if (bio_data_dir(bio) == READ) {
+		struct bio_vec *bvec;
+		unsigned long flags;
+		int i;
+
+		bio_for_each_segment(bvec, bio, i) {
+			char *dst = bvec_kmap_irq(bvec, &flags);
+
+			memset(dst, 0, bvec->bv_len);
+			bvec_kunmap_irq(dst, &flags);
+		}
+		bio_endio(bio, 0);
+	} else {
+		/*
+		 * let the page cache handling path do this bio, and then
+		 * lookup the mapped blocks after the io has been issued to
+		 * instantiate extents.
+		 */
+		loop_add_bio(lo, bio);
+	}
+}
+
+static inline int lo_is_switch_bio(struct bio *bio)
+{
+	return !bio->bi_bdev && bio->bi_rw == LOOP_SWITCH_RW_MAGIC;
+}
+
+static inline int lo_is_map_bio(struct bio *bio)
+{
+	return !bio->bi_bdev && bio->bi_rw == LOOP_EXTENT_RW_MAGIC;
+}
+
+/*
+ * Change mapping of the bio, so that it points to the real bdev and offset
+ */
+static int loop_redirect_bio(struct loop_device *lo, struct bio *bio)
+{
+	struct extent_map *lfe;
+	u64 extent_off;
+	u64 disk_block;
+	u64 start = lo_bio_offset(lo, bio);
+
+	lfe = loop_lookup_extent(lo, start, GFP_ATOMIC);
+	if (IS_ERR(lfe))
+		return -EIO;
+
+	while (!lfe) {
+		loop_schedule_extent_mapping(lo, bio->bi_sector,
+					     bio->bi_size, 1);
+		lfe = loop_lookup_extent(lo, start, GFP_ATOMIC);
+		if (IS_ERR(lfe))
+			return -EIO;
+	}
+
+	/*
+	 * handle sparse io
+	 */
+	if (lfe->block_start == EXTENT_MAP_HOLE) {
+		loop_handle_extent_hole(lo, bio);
+		free_extent_map(lfe);
+		return 0;
+	}
+
+	/*
+	 * not a hole, redirect
+	 */
+	disk_block = lfe->block_start;
+	extent_off = start - lfe->start;
+	bio->bi_bdev = lfe->bdev;
+	bio->bi_sector = (disk_block + extent_off) >> 9;
+	free_extent_map(lfe);
+	return 1;
+}
+
+/*
+ * Wait on bio's on our list to complete before sending a barrier bio
+ * to the below device. Called with lo_lock held.
+ */
+static void loop_wait_on_bios(struct loop_device *lo)
+{
+	__lo_throttle(&lo->lo_bio_wait, &lo->lo_lock, !lo->lo_bio);
+}
+
+static void loop_wait_on_switch(struct loop_device *lo)
+{
+	__lo_throttle(&lo->lo_bio_wait, &lo->lo_lock, !lo->lo_switch);
+}
+
 static int loop_make_request(struct request_queue *q, struct bio *old_bio)
 {
 	struct loop_device *lo = q->queuedata;
@@ -525,15 +738,39 @@ static int loop_make_request(struct request_queue *q, struct bio *old_bio)
 		goto out;
 	if (unlikely(rw == WRITE && (lo->lo_flags & LO_FLAGS_READ_ONLY)))
 		goto out;
+	if (lo->lo_flags & LO_FLAGS_FASTFS) {
+		/*
+		 * If we get a barrier bio, then we just need to wait for
+		 * existing bio's to be complete. This can only happen
+		 * on the 'new' extent mapped loop, since that is the only
+		 * one that supports barriers.
+		 */
+		if (bio_barrier(old_bio))
+			loop_wait_on_bios(lo);
+
+		/*
+		 * if file switch is in progress, wait for it to complete
+		 */
+		if (!lo_is_switch_bio(old_bio) && lo->lo_switch)
+			loop_wait_on_switch(lo);
+
+		if (loop_redirect_bio(lo, old_bio))
+			goto out_redir;
+		goto out_end;
+	}
 	loop_add_bio(lo, old_bio);
-	wake_up(&lo->lo_event);
 	spin_unlock_irq(&lo->lo_lock);
 	return 0;
 
 out:
-	spin_unlock_irq(&lo->lo_lock);
 	bio_io_error(old_bio);
+out_end:
+	spin_unlock_irq(&lo->lo_lock);
 	return 0;
+
+out_redir:
+	spin_unlock_irq(&lo->lo_lock);
+	return 1;
 }
 
 /*
@@ -547,21 +784,113 @@ static void loop_unplug(struct request_queue *q)
 	blk_run_address_space(lo->lo_backing_file->f_mapping);
 }
 
+static void loop_unplug_fastfs(struct request_queue *q)
+{
+	struct loop_device *lo = q->queuedata;
+	struct request_queue *rq = bdev_get_queue(lo->fs_bdev);
+
+	clear_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags);
+
+	if (rq->unplug_fn)
+		rq->unplug_fn(rq);
+}
+
 struct switch_request {
 	struct file *file;
 	struct completion wait;
 };
 
 static void do_loop_switch(struct loop_device *, struct switch_request *);
+static int loop_init_fastfs(struct loop_device *);
+
+static void end_bio_hole_filling(struct bio *bio, int err)
+{
+	struct address_space *mapping = bio->bi_bdev->bd_inode->i_mapping;
+	struct bio *orig_bio = bio->bi_private;
+
+	if (mapping->a_ops->extent_io_complete) {
+		u64 start = orig_bio->bi_sector << 9;
+		u64 len = bio->bi_size;
+
+		mapping->a_ops->extent_io_complete(mapping, start, len);
+	}
+
+	bio_put(bio);
+	bio_endio(orig_bio, err);
+}
+
+static int fill_extent_hole(struct loop_device *lo, struct bio *bio)
+{
+	struct address_space *mapping = lo->lo_backing_file->f_mapping;
+	struct bio *new_bio;
+	struct extent_map *em;
+	u64 len = bio->bi_size;
+	u64 start = lo_bio_offset(lo, bio);
+	u64 disk_block;
+	u64 extent_off;
+
+	/*
+	 * change the sector so we can find the correct file offset in our
+	 * endio
+	 */
+	bio->bi_sector = lo_bio_offset(lo, bio) >> 9;
+
+	mutex_lock(&mapping->host->i_mutex);
+
+	em = mapping->a_ops->map_extent(mapping, NULL, 0,
+					start, len, 1, GFP_KERNEL);
+	mark_inode_dirty(mapping->host);
+	mutex_unlock(&mapping->host->i_mutex);
+
+	if (em && !IS_ERR(em)) {
+		disk_block = em->block_start;
+		extent_off = start - em->start;
+
+		/*
+		 * bio_clone() is mempool backed, so if __GFP_WAIT is set
+		 * it wont ever fail
+		 */
+		new_bio = bio_clone(bio, GFP_NOIO);
+		new_bio->bi_sector = (disk_block + extent_off) >> 9;
+		new_bio->bi_bdev = em->bdev;
+		new_bio->bi_private = bio;
+		new_bio->bi_size = bio->bi_size;
+		new_bio->bi_end_io = end_bio_hole_filling;
+		free_extent_map(em);
+
+		generic_make_request(new_bio);
+		return 0;
+	}
+
+	bio_endio(bio, -EIO);
+	return 0;
+}
 
 static inline void loop_handle_bio(struct loop_device *lo, struct bio *bio)
 {
-	if (unlikely(!bio->bi_bdev)) {
+	struct extent_map *lfe;
+
+	if (lo_is_map_bio(bio)) {
+		lfe = loop_lookup_extent(lo, lo_bio_offset(lo, bio),
+					 GFP_KERNEL);
+		free_extent_map(lfe);
+		if (bio->bi_private)
+			complete(bio->bi_private);
+		else
+			bio_put(bio);
+	} else if (lo_is_switch_bio(bio)) {
 		do_loop_switch(lo, bio->bi_private);
 		bio_put(bio);
 	} else {
-		int ret = do_bio_filebacked(lo, bio);
-		bio_endio(bio, ret);
+		int ret;
+
+		if (lo->lo_flags & LO_FLAGS_FASTFS) {
+			/* we only get here when filling holes */
+			ret = fill_extent_hole(lo, bio);
+		} else {
+			ret = do_bio_filebacked(lo, bio);
+			bio_endio(bio, ret);
+		}
 	}
 }
 
@@ -581,6 +910,7 @@ static int loop_thread(void *data)
 {
 	struct loop_device *lo = data;
 	struct bio *bio;
+	int bio_act;
 
 	set_user_nice(current, -20);
 
@@ -588,7 +918,6 @@ static int loop_thread(void *data)
 
 		wait_event_interruptible(lo->lo_event,
 				lo->lo_bio || kthread_should_stop());
-
 		if (!lo->lo_bio)
 			continue;
 		spin_lock_irq(&lo->lo_lock);
@@ -596,7 +925,16 @@ static int loop_thread(void *data)
 		spin_unlock_irq(&lo->lo_lock);
 
 		BUG_ON(!bio);
+
+		bio_act = lo_act_bio(bio);
 		loop_handle_bio(lo, bio);
+
+		spin_lock_irq(&lo->lo_lock);
+		if (bio_act)
+			lo->lo_bio_cnt--;
+		if (lo->lo_bio_cnt < LO_BIO_THROTTLE || !lo->lo_bio)
+			wake_up(&lo->lo_bio_wait);
+		spin_unlock_irq(&lo->lo_lock);
 	}
 
 	return 0;
@@ -617,6 +955,8 @@ static int loop_switch(struct loop_device *lo, struct file *file)
 	w.file = file;
 	bio->bi_private = &w;
 	bio->bi_bdev = NULL;
+	bio->bi_rw = LOOP_SWITCH_RW_MAGIC;
+	lo->lo_switch = 1;
 	loop_make_request(lo->lo_queue, bio);
 	wait_for_completion(&w.wait);
 	return 0;
@@ -630,6 +970,10 @@ static void do_loop_switch(struct loop_device *lo, struct switch_request *p)
 	struct file *file = p->file;
 	struct file *old_file = lo->lo_backing_file;
 	struct address_space *mapping = file->f_mapping;
+	const int fastfs = lo->lo_flags & LO_FLAGS_FASTFS;
+
+	if (fastfs)
+		loop_exit_fastfs(lo);
 
 	mapping_set_gfp_mask(old_file->f_mapping, lo->old_gfp_mask);
 	lo->lo_backing_file = file;
@@ -637,6 +981,13 @@ static void do_loop_switch(struct loop_device *lo, struct switch_request *p)
 		mapping->host->i_bdev->bd_block_size : PAGE_SIZE;
 	lo->old_gfp_mask = mapping_gfp_mask(mapping);
 	mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
+
+	if (fastfs)
+		loop_init_fastfs(lo);
+
+	lo->lo_switch = 0;
+	wake_up(&lo->lo_bio_wait);
+
 	complete(&p->wait);
 }
 
@@ -700,6 +1051,83 @@ static int loop_change_fd(struct loop_device *lo, struct file *lo_file,
 	return error;
 }
 
+/*
+ * See if adding this bvec would cause us to spill into a new extent. If so,
+ * disallow the add to start a new bio. This ensures that the bio we receive
+ * in loop_make_request() never spans two extents or more.
+ */
+static int loop_merge_bvec(struct request_queue *q, struct bio *bio,
+			   struct bio_vec *bvec)
+{
+	struct loop_device *lo = q->queuedata;
+	struct extent_map *lfe;
+	unsigned int ret;
+	u64 start;
+	u64 len;
+
+	start = lo_bio_offset(lo, bio);
+	len = bio->bi_size + bvec->bv_len;
+	ret = bvec->bv_len;
+
+	lfe = loop_lookup_extent(lo, start, GFP_ATOMIC);
+	if (lfe && !IS_ERR(lfe)) {
+		/*
+		 * have extent, disallow if outside that extent
+		 */
+		if (start + len > lfe->start + lfe->len)
+			ret = 0;
+
+		free_extent_map(lfe);
+	} else {
+		if (bio->bi_size)
+			ret = 0;
+	}
+	return ret;
+}
+
+/*
+ * Initialize the members pertaining to extent mapping. We will populate
+ * the tree lazily on demand, as a full scan of a big file can take some
+ * time.
+ */
+static int loop_init_fastfs(struct loop_device *lo)
+{
+	struct file *file = lo->lo_backing_file;
+	struct inode *inode = file->f_mapping->host;
+	struct request_queue *fs_q;
+	int ret;
+
+	if (!S_ISREG(inode->i_mode))
+		return -EINVAL;
+
+	/*
+	 * Need a working extent_map
+	 */
+	if (inode->i_mapping->a_ops->map_extent == NULL)
+		return -EINVAL;
+	/*
+	 * invalidate all page cache belonging to this file, it could become
+	 * stale when we directly overwrite blocks.
+	 */
+	ret = invalidate_inode_pages2(file->f_mapping);
+	if (unlikely(ret))
+		return ret;
+
+	lo->blkbits = inode->i_blkbits;
+	lo->fs_bdev = file->f_mapping->host->i_sb->s_bdev;
+	lo->lo_flags |= LO_FLAGS_FASTFS;
+	lo->lo_queue->unplug_fn = loop_unplug_fastfs;
+
+	blk_queue_merge_bvec(lo->lo_queue, loop_merge_bvec);
+	blk_queue_ordered(lo->lo_queue, QUEUE_ORDERED_DRAIN, NULL);
+
+	fs_q = bdev_get_queue(lo->fs_bdev);
+	blk_queue_stack_limits(lo->lo_queue, fs_q);
+
+	printk(KERN_INFO "loop%d: fast redirect\n", lo->lo_number);
+	return 0;
+}
+
 static inline int is_loop_device(struct file *file)
 {
 	struct inode *i = file->f_mapping->host;
@@ -748,6 +1176,7 @@ static int loop_set_fd(struct loop_device *lo, struct file *lo_file,
 
 	mapping = file->f_mapping;
 	inode = mapping->host;
+	lo->lo_flags = 0;
 
 	if (!(file->f_mode & FMODE_WRITE))
 		lo_flags |= LO_FLAGS_READ_ONLY;
@@ -811,6 +1240,12 @@ static int loop_set_fd(struct loop_device *lo, struct file *lo_file,
 
 	set_blocksize(bdev, lo_blocksize);
 
+	/*
+	 * This needs to be done after setup with another ioctl,
+	 * not automatically like this.
+	 */
+	loop_init_fastfs(lo);
+
 	lo->lo_thread = kthread_create(loop_thread, lo, "loop%d",
 						lo->lo_number);
 	if (IS_ERR(lo->lo_thread)) {
@@ -896,6 +1331,9 @@ static int loop_clr_fd(struct loop_device *lo, struct block_device *bdev)
 
 	kthread_stop(lo->lo_thread);
 
+	if (lo->lo_flags & LO_FLAGS_FASTFS)
+		loop_exit_fastfs(lo);
+
 	lo->lo_backing_file = NULL;
 
 	loop_release_xfer(lo);
@@ -943,6 +1381,9 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	if (info->lo_encrypt_type) {
 		unsigned int type = info->lo_encrypt_type;
 
+		if (lo->lo_flags & LO_FLAGS_FASTFS)
+			return -EINVAL;
+
 		if (type >= MAX_LO_CRYPT)
 			return -EINVAL;
 		xfer = xfer_funcs[type];
@@ -951,6 +1392,13 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	} else
 		xfer = NULL;
 
+	/*
+	 * for remaps, offset must be a multiple of full blocks
+	 */
+	if ((lo->lo_flags & LO_FLAGS_FASTFS) &&
+	    (((1 << lo->blkbits) - 1) & info->lo_offset))
+		return -EINVAL;
+
 	err = loop_init_xfer(lo, xfer, info);
 	if (err)
 		return err;
@@ -1153,6 +1601,9 @@ static int lo_ioctl(struct inode * inode, struct file * file,
 	case LOOP_GET_STATUS64:
 		err = loop_get_status64(lo, (struct loop_info64 __user *) arg);
 		break;
+	case LOOP_SET_FASTFS:
+		err = loop_init_fastfs(lo);
+		break;
 	default:
 		err = lo->ioctl ? lo->ioctl(lo, cmd, arg) : -EINVAL;
 	}
@@ -1412,6 +1863,7 @@ static struct loop_device *loop_alloc(int i)
 	lo->lo_number		= i;
 	lo->lo_thread		= NULL;
 	init_waitqueue_head(&lo->lo_event);
+	init_waitqueue_head(&lo->lo_bio_wait);
 	spin_lock_init(&lo->lo_lock);
 	disk->major		= LOOP_MAJOR;
 	disk->first_minor	= i;
diff --git a/include/linux/loop.h b/include/linux/loop.h
index 26a0a10..7b3cb27 100644
--- a/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -50,22 +50,28 @@ struct loop_device {
 
 	struct file *	lo_backing_file;
 	struct block_device *lo_device;
+	struct block_device *fs_bdev;
 	unsigned	lo_blocksize;
 	void		*key_data; 
+	unsigned int	lo_switch;
 
 	gfp_t		old_gfp_mask;
 
 	spinlock_t		lo_lock;
 	struct bio 		*lo_bio;
 	struct bio		*lo_biotail;
+	unsigned int		lo_bio_cnt;
 	int			lo_state;
 	struct mutex		lo_ctl_mutex;
 	struct task_struct	*lo_thread;
 	wait_queue_head_t	lo_event;
+	wait_queue_head_t	lo_bio_wait;
 
 	struct request_queue	*lo_queue;
 	struct gendisk		*lo_disk;
 	struct list_head	lo_list;
+
+	unsigned int		blkbits;
 };
 
 #endif /* __KERNEL__ */
@@ -76,6 +82,7 @@ struct loop_device {
 enum {
 	LO_FLAGS_READ_ONLY	= 1,
 	LO_FLAGS_USE_AOPS	= 2,
+	LO_FLAGS_FASTFS		= 4,
 };
 
 #include <asm/posix_types.h>	/* for __kernel_old_dev_t */
@@ -159,5 +166,11 @@ int loop_unregister_transfer(int number);
 #define LOOP_SET_STATUS64	0x4C04
 #define LOOP_GET_STATUS64	0x4C05
 #define LOOP_CHANGE_FD		0x4C06
+#define LOOP_SET_FASTFS		0x4C07
+
+enum {
+	LOOP_EXTENT_RW_MAGIC =	0x19283746,
+	LOOP_SWITCH_RW_MAGIC = 	0xfeedbeef,
+};
 
 #endif
-- 
1.5.4.rc2.84.gf85fd


--Y/WcH0a6A93yCHGr--
