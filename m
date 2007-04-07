Return-Path: <linux-kernel-owner+w=401wt.eu-S965844AbXDGVRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965844AbXDGVRY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 17:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966345AbXDGVRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 17:17:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49466 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965844AbXDGVRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 17:17:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: [RFC][PATCH -mm] swsusp: Use rbtree for tracking allocated swap
Date: Sat, 7 Apr 2007 23:20:39 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <ncunningham@linuxmail.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704072320.40238.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some time ago we discussed the possibility of simplifying the swsusp's approach
towards tracking the swap pages allocated by it for saving the image (so that
they can be freed if there's an error).

I think we can get back to it now, as it is a nice optimization that should
allow us to use less memory (almost always) and improve performance a bit.

Greetings,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Make swsusp use extents instead of a bitmap to trace swap pages allocated for
saving the image (the tracking is only needed in case there's an error, so that
the allocated swap pages can be released).

This should allow us to reduce the memory usage, practically always, and
improve performance.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/power.h  |   27 +---------
 kernel/power/swap.c   |   18 +-----
 kernel/power/swsusp.c |  135 ++++++++++++++++++++++++++------------------------
 kernel/power/user.c   |   22 +-------
 4 files changed, 85 insertions(+), 117 deletions(-)

Index: linux-2.6.21-rc6/kernel/power/swsusp.c
===================================================================
--- linux-2.6.21-rc6.orig/kernel/power/swsusp.c
+++ linux-2.6.21-rc6/kernel/power/swsusp.c
@@ -50,6 +50,7 @@
 #include <linux/syscalls.h>
 #include <linux/highmem.h>
 #include <linux/time.h>
+#include <linux/rbtree.h>
 
 #include "power.h"
 
@@ -74,72 +75,69 @@ static inline unsigned int count_highmem
 /**
  *	The following functions are used for tracing the allocated
  *	swap pages, so that they can be freed in case of an error.
- *
- *	The functions operate on a linked bitmap structure defined
- *	in power.h
  */
 
-void free_bitmap(struct bitmap_page *bitmap)
-{
-	struct bitmap_page *bp;
+struct swsusp_extent {
+	struct rb_node node;
+	unsigned long start;
+	unsigned long end;
+};
 
-	while (bitmap) {
-		bp = bitmap->next;
-		free_page((unsigned long)bitmap);
-		bitmap = bp;
-	}
-}
+static struct rb_root swsusp_extents = RB_ROOT;
 
-struct bitmap_page *alloc_bitmap(unsigned int nr_bits)
+static int swsusp_extents_insert(unsigned long swap_offset)
 {
-	struct bitmap_page *bitmap, *bp;
-	unsigned int n;
-
-	if (!nr_bits)
-		return NULL;
-
-	bitmap = (struct bitmap_page *)get_zeroed_page(GFP_KERNEL);
-	bp = bitmap;
-	for (n = BITMAP_PAGE_BITS; n < nr_bits; n += BITMAP_PAGE_BITS) {
-		bp->next = (struct bitmap_page *)get_zeroed_page(GFP_KERNEL);
-		bp = bp->next;
-		if (!bp) {
-			free_bitmap(bitmap);
-			return NULL;
+	struct rb_node **new = &(swsusp_extents.rb_node);
+	struct rb_node *parent = NULL;
+	struct swsusp_extent *ext;
+
+	/* Figure out where to put the new node */
+	while (*new) {
+		ext = container_of(*new, struct swsusp_extent, node);
+		parent = *new;
+		if (swap_offset < ext->start) {
+			/* Try to merge */
+			if (swap_offset == ext->start - 1) {
+				ext->start--;
+				return 0;
+			}
+			new = &((*new)->rb_left);
+		} else if (swap_offset > ext->end) {
+			/* Try to merge */
+			if (swap_offset == ext->end + 1) {
+				ext->end++;
+				return 0;
+			}
+			new = &((*new)->rb_right);
+		} else {
+			/* It already is in the tree */
+			return -EINVAL;
 		}
 	}
-	return bitmap;
-}
-
-static int bitmap_set(struct bitmap_page *bitmap, unsigned long bit)
-{
-	unsigned int n;
-
-	n = BITMAP_PAGE_BITS;
-	while (bitmap && n <= bit) {
-		n += BITMAP_PAGE_BITS;
-		bitmap = bitmap->next;
-	}
-	if (!bitmap)
-		return -EINVAL;
-	n -= BITMAP_PAGE_BITS;
-	bit -= n;
-	n = 0;
-	while (bit >= BITS_PER_CHUNK) {
-		bit -= BITS_PER_CHUNK;
-		n++;
-	}
-	bitmap->chunks[n] |= (1UL << bit);
+	/* Add the new node and rebalance the tree. */
+	ext = kzalloc(sizeof(struct swsusp_extent), GFP_KERNEL);
+	if (!ext)
+		return -ENOMEM;
+
+	ext->start = swap_offset;
+	ext->end = swap_offset;
+	rb_link_node(&ext->node, parent, new);
+	rb_insert_color(&ext->node, &swsusp_extents);
 	return 0;
 }
 
-sector_t alloc_swapdev_block(int swap, struct bitmap_page *bitmap)
+/**
+ *	alloc_swapdev_block - allocate a swap page and register that it has
+ *	been allocated, so that it can be freed in case of an error.
+ */
+
+sector_t alloc_swapdev_block(int swap)
 {
 	unsigned long offset;
 
 	offset = swp_offset(get_swap_page_of_type(swap));
 	if (offset) {
-		if (bitmap_set(bitmap, offset))
+		if (swsusp_extents_insert(offset))
 			swap_free(swp_entry(swap, offset));
 		else
 			return swapdev_block(swap, offset);
@@ -147,23 +145,34 @@ sector_t alloc_swapdev_block(int swap, s
 	return 0;
 }
 
-void free_all_swap_pages(int swap, struct bitmap_page *bitmap)
+/**
+ *	free_all_swap_pages - free swap pages allocated for saving image data.
+ *	It also frees the extents used to register which swap entres had been
+ *	allocated.
+ */
+
+void free_all_swap_pages(int swap)
 {
-	unsigned int bit, n;
-	unsigned long test;
+	struct rb_node *node;
 
-	bit = 0;
-	while (bitmap) {
-		for (n = 0; n < BITMAP_PAGE_CHUNKS; n++)
-			for (test = 1UL; test; test <<= 1) {
-				if (bitmap->chunks[n] & test)
-					swap_free(swp_entry(swap, bit));
-				bit++;
-			}
-		bitmap = bitmap->next;
+	while ((node = swsusp_extents.rb_node)) {
+		struct swsusp_extent *ext;
+		unsigned long offset;
+
+		ext = container_of(node, struct swsusp_extent, node);
+		rb_erase(node, &swsusp_extents);
+		for (offset = ext->start; offset <= ext->end; offset++)
+			swap_free(swp_entry(swap, offset));
+
+		kfree(ext);
 	}
 }
 
+int swsusp_swap_in_use(void)
+{
+	return (swsusp_extents.rb_node != NULL);
+}
+
 /**
  *	swsusp_show_speed - print the time elapsed between two events represented by
  *	@start and @stop
Index: linux-2.6.21-rc6/kernel/power/power.h
===================================================================
--- linux-2.6.21-rc6.orig/kernel/power/power.h
+++ linux-2.6.21-rc6/kernel/power/power.h
@@ -144,30 +144,9 @@ struct resume_swap_area {
 /* If unset, the snapshot device cannot be open. */
 extern atomic_t snapshot_device_available;
 
-/**
- *	The bitmap is used for tracing allocated swap pages
- *
- *	The entire bitmap consists of a number of bitmap_page
- *	structures linked with the help of the .next member.
- *	Thus each page can be allocated individually, so we only
- *	need to make 0-order memory allocations to create
- *	the bitmap.
- */
-
-#define BITMAP_PAGE_SIZE	(PAGE_SIZE - sizeof(void *))
-#define BITMAP_PAGE_CHUNKS	(BITMAP_PAGE_SIZE / sizeof(long))
-#define BITS_PER_CHUNK		(sizeof(long) * 8)
-#define BITMAP_PAGE_BITS	(BITMAP_PAGE_CHUNKS * BITS_PER_CHUNK)
-
-struct bitmap_page {
-	unsigned long		chunks[BITMAP_PAGE_CHUNKS];
-	struct bitmap_page	*next;
-};
-
-extern void free_bitmap(struct bitmap_page *bitmap);
-extern struct bitmap_page *alloc_bitmap(unsigned int nr_bits);
-extern sector_t alloc_swapdev_block(int swap, struct bitmap_page *bitmap);
-extern void free_all_swap_pages(int swap, struct bitmap_page *bitmap);
+extern sector_t alloc_swapdev_block(int swap);
+extern void free_all_swap_pages(int swap);
+extern int swsusp_swap_in_use(void);
 
 extern int swsusp_check(void);
 extern int swsusp_shrink_memory(void);
Index: linux-2.6.21-rc6/kernel/power/user.c
===================================================================
--- linux-2.6.21-rc6.orig/kernel/power/user.c
+++ linux-2.6.21-rc6/kernel/power/user.c
@@ -33,7 +33,6 @@
 static struct snapshot_data {
 	struct snapshot_handle handle;
 	int swap;
-	struct bitmap_page *bitmap;
 	int mode;
 	char frozen;
 	char ready;
@@ -69,7 +68,6 @@ static int snapshot_open(struct inode *i
 		data->swap = -1;
 		data->mode = O_WRONLY;
 	}
-	data->bitmap = NULL;
 	data->frozen = 0;
 	data->ready = 0;
 	data->platform_suspend = 0;
@@ -84,8 +82,7 @@ static int snapshot_release(struct inode
 	swsusp_free();
 	free_basic_memory_bitmaps();
 	data = filp->private_data;
-	free_all_swap_pages(data->swap, data->bitmap);
-	free_bitmap(data->bitmap);
+	free_all_swap_pages(data->swap);
 	if (data->frozen) {
 		mutex_lock(&pm_mutex);
 		thaw_processes();
@@ -300,14 +297,7 @@ static int snapshot_ioctl(struct inode *
 			error = -ENODEV;
 			break;
 		}
-		if (!data->bitmap) {
-			data->bitmap = alloc_bitmap(count_swap_pages(data->swap, 0));
-			if (!data->bitmap) {
-				error = -ENOMEM;
-				break;
-			}
-		}
-		offset = alloc_swapdev_block(data->swap, data->bitmap);
+		offset = alloc_swapdev_block(data->swap);
 		if (offset) {
 			offset <<= PAGE_SHIFT;
 			error = put_user(offset, (sector_t __user *)arg);
@@ -321,13 +311,11 @@ static int snapshot_ioctl(struct inode *
 			error = -ENODEV;
 			break;
 		}
-		free_all_swap_pages(data->swap, data->bitmap);
-		free_bitmap(data->bitmap);
-		data->bitmap = NULL;
+		free_all_swap_pages(data->swap);
 		break;
 
 	case SNAPSHOT_SET_SWAP_FILE:
-		if (!data->bitmap) {
+		if (!swsusp_swap_in_use()) {
 			/*
 			 * User space encodes device types as two-byte values,
 			 * so we need to recode them
@@ -426,7 +414,7 @@ static int snapshot_ioctl(struct inode *
 		break;
 
 	case SNAPSHOT_SET_SWAP_AREA:
-		if (data->bitmap) {
+		if (swsusp_swap_in_use()) {
 			error = -EPERM;
 		} else {
 			struct resume_swap_area swap_area;
Index: linux-2.6.21-rc6/kernel/power/swap.c
===================================================================
--- linux-2.6.21-rc6.orig/kernel/power/swap.c
+++ linux-2.6.21-rc6/kernel/power/swap.c
@@ -241,7 +241,6 @@ struct swap_map_page {
 struct swap_map_handle {
 	struct swap_map_page *cur;
 	sector_t cur_swap;
-	struct bitmap_page *bitmap;
 	unsigned int k;
 };
 
@@ -250,9 +249,6 @@ static void release_swap_writer(struct s
 	if (handle->cur)
 		free_page((unsigned long)handle->cur);
 	handle->cur = NULL;
-	if (handle->bitmap)
-		free_bitmap(handle->bitmap);
-	handle->bitmap = NULL;
 }
 
 static int get_swap_writer(struct swap_map_handle *handle)
@@ -260,12 +256,7 @@ static int get_swap_writer(struct swap_m
 	handle->cur = (struct swap_map_page *)get_zeroed_page(GFP_KERNEL);
 	if (!handle->cur)
 		return -ENOMEM;
-	handle->bitmap = alloc_bitmap(count_swap_pages(root_swap, 0));
-	if (!handle->bitmap) {
-		release_swap_writer(handle);
-		return -ENOMEM;
-	}
-	handle->cur_swap = alloc_swapdev_block(root_swap, handle->bitmap);
+	handle->cur_swap = alloc_swapdev_block(root_swap);
 	if (!handle->cur_swap) {
 		release_swap_writer(handle);
 		return -ENOSPC;
@@ -282,7 +273,7 @@ static int swap_write_page(struct swap_m
 
 	if (!handle->cur)
 		return -EINVAL;
-	offset = alloc_swapdev_block(root_swap, handle->bitmap);
+	offset = alloc_swapdev_block(root_swap);
 	error = write_page(buf, offset, bio_chain);
 	if (error)
 		return error;
@@ -291,7 +282,7 @@ static int swap_write_page(struct swap_m
 		error = wait_on_bio_chain(bio_chain);
 		if (error)
 			goto out;
-		offset = alloc_swapdev_block(root_swap, handle->bitmap);
+		offset = alloc_swapdev_block(root_swap);
 		if (!offset)
 			return -ENOSPC;
 		handle->cur->next_swap = offset;
@@ -428,7 +419,8 @@ int swsusp_write(void)
 		}
 	}
 	if (error)
-		free_all_swap_pages(root_swap, handle.bitmap);
+		free_all_swap_pages(root_swap);
+
 	release_swap_writer(&handle);
  out:
 	swsusp_close();
