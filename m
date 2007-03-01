Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbXCAFbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbXCAFbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 00:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbXCAFbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 00:31:06 -0500
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:56285 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752201AbXCAFbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 00:31:05 -0500
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2007 00:31:04 EST
From: kven709@cse.unsw.edu.au (Kandan Venkataraman)
To: linux-kernel@vger.kernel.org
Date: Thu, 1 Mar 2007 16:25:16 +1100
Message-Id: <1070301052516.11639@cse.unsw.edu.au>
Subject: [PATCH] Loop device - Tracking page writes made to a loop device through mmap
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is for tracking writes made to a loop device made through mmap. 
 
A  file_operations structure variable called loop_fops is initialised with the default block device file operations (def_blk_fops).
The mmap operation is overriden with a new function called loop_file_mmap. 
 
A vm_operations structure variable called loop_file_vm_ops is initialised with the default operations for a disk file.
The page_mkwrite operation in this variable is initialised to a new function called loop_track_pgwrites.
 
In the function lo_open, the file operations pointer of the device file is initialised with the address of loop_fops.
 
The function loop_file_mmap simply calls generic_file_mmap and then initialises the vm_ops of the vma with address of loop_file_vm_ops.
 
The function loop_track_pgwrites stores the page offset of the page that is being written to,  in a red-black tree within the loop device.
 
A flag lo_track_pgwrite has been added to the structs loop_device and loop_info64 to turn on/off tracking of page writes.
 
Two new ioctls have been added.
 
The ioctl cmd LOOP_GET_PGWRITES retrieves the page offsets of pages that have been written to.
The ioctl cmd LOOP_CLR_PGWRITES empties the red-black tree
 
This functionality would allow us to have a read only version and a write version of memory by doing the following:
Associate a normal file as backing storage for  the loop device and mmap to the loop device. Call this mmapped address space as area1.
Mmap to a normal file of identical size. Call this mmapped address space as area2.
 
Changes made to area1 can be periodically copied to area2 using the ioctl cmds (retreive dirty page offsets and copy the dirty pages from area1 to area2). This facility would provide a quick way of updating the read only version.

Please CC your reply to kandan.venkataraman@omxgroup.com
 
The following patch is against vanilla linux-2.6.19.2
 
Signed-off-by: Kandan Venkataraman kandan.venkataraman@omxgroup.com


diff -uprN linux-2.6.19.2/drivers/block/loop.c linux-2.6.19.2-new/drivers/block/loop.c
--- linux-2.6.19.2/drivers/block/loop.c	2007-01-11 06:10:37.000000000 +1100
+++ linux-2.6.19.2-new/drivers/block/loop.c	2007-02-27 17:23:18.000000000 +1100
@@ -74,12 +74,16 @@
 #include <linux/highmem.h>
 #include <linux/gfp.h>
 #include <linux/kthread.h>
+#include <linux/mm.h>
 
 #include <asm/uaccess.h>
 
 static int max_loop = 8;
 static struct loop_device *loop_dev;
 static struct gendisk **disks;
+static kmem_cache_t *pgoff_elem_cache;
+static char*  cache_name = "loop_pgoff_elem_cache";
+static struct file_operations loop_fops;
 
 /*
  * Transfer functions
@@ -646,6 +650,73 @@ static void do_loop_switch(struct loop_d
 	complete(&p->wait);
 }
 
+static void pgoff_tree_clear(struct rb_root *rb_root)
+{
+	struct rb_node *rb_node  = rb_root->rb_node;
+
+	while (rb_node != NULL) {
+
+		rb_erase(rb_node, rb_root); 
+		kmem_cache_free(pgoff_elem_cache, rb_entry(rb_node, struct pgoff_elem, node));
+		rb_node = rb_root->rb_node;
+	}
+
+  *rb_root = RB_ROOT;
+}
+
+
+static int loop_clr_pgwrites(struct loop_device *lo)
+{
+	struct file *filp = lo->lo_backing_file;
+
+	if (lo->lo_state != Lo_bound)
+		return -ENXIO;
+
+	if (filp == NULL)
+		return -EINVAL;
+
+	if (!lo->lo_track_pgwrite)
+	  return 0;
+
+	pgoff_tree_clear(&lo->pgoff_tree);
+
+	return 0;
+}
+
+static int loop_get_pgwrites(struct loop_device *lo, struct loop_pgoff_array __user *arg)
+{
+	struct file *filp = lo->lo_backing_file;
+	struct loop_pgoff_array array;
+	loff_t i = 0;
+	struct rb_node *rb_node  = rb_first(&lo->pgoff_tree);
+
+	if (lo->lo_state != Lo_bound)
+		return -ENXIO;
+
+	if (filp == NULL)
+		return -EINVAL;
+
+	if (!lo->lo_track_pgwrite)
+	  return 0;
+
+	if (copy_from_user(&array, arg, sizeof (struct loop_pgoff_array)))
+		return -EFAULT;
+
+	while (i < array.max && rb_node != NULL) {
+
+	  if (put_user(rb_entry(rb_node, struct pgoff_elem, node)->offset, array.pgoff + i))
+		 return -EFAULT;
+
+	  ++i;
+	  rb_node = rb_next(rb_node);
+	}
+	array.num = i;
+
+	if (copy_to_user(arg, &array, sizeof(array)))
+	  return -EFAULT;
+
+	return 0;
+}
 
 /*
  * loop_change_fd switched the backing store of a loopback device to
@@ -692,6 +763,8 @@ static int loop_change_fd(struct loop_de
 	if (get_loop_size(lo, file) != get_loop_size(lo, old_file))
 		goto out_putf;
 
+	pgoff_tree_clear(&lo->pgoff_tree);
+
 	/* and ... switch */
 	error = loop_switch(lo, file);
 	if (error)
@@ -799,6 +872,8 @@ static int loop_set_fd(struct loop_devic
 	lo->transfer = transfer_none;
 	lo->ioctl = NULL;
 	lo->lo_sizelimit = 0;
+	lo->lo_track_pgwrite = 0;
+	lo->pgoff_tree = RB_ROOT;
 	lo->old_gfp_mask = mapping_gfp_mask(mapping);
 	mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
 
@@ -913,6 +988,8 @@ static int loop_clr_fd(struct loop_devic
 	lo->lo_sizelimit = 0;
 	lo->lo_encrypt_key_size = 0;
 	lo->lo_flags = 0;
+	lo->lo_track_pgwrite = 0;
+	pgoff_tree_clear(&lo->pgoff_tree);
 	lo->lo_thread = NULL;
 	memset(lo->lo_encrypt_key, 0, LO_KEY_SIZE);
 	memset(lo->lo_crypt_name, 0, LO_NAME_SIZE);
@@ -969,6 +1046,14 @@ loop_set_status(struct loop_device *lo, 
 			return -EFBIG;
 	}
 
+	if (info->lo_track_pgwrite)
+	  lo->lo_track_pgwrite = 1;
+	else {
+	  if (lo->lo_track_pgwrite)
+		 pgoff_tree_clear(&lo->pgoff_tree);
+	  lo->lo_track_pgwrite = 0;
+	}
+
 	memcpy(lo->lo_file_name, info->lo_file_name, LO_NAME_SIZE);
 	memcpy(lo->lo_crypt_name, info->lo_crypt_name, LO_NAME_SIZE);
 	lo->lo_file_name[LO_NAME_SIZE-1] = 0;
@@ -1011,6 +1096,7 @@ loop_get_status(struct loop_device *lo, 
 	info->lo_offset = lo->lo_offset;
 	info->lo_sizelimit = lo->lo_sizelimit;
 	info->lo_flags = lo->lo_flags;
+	info->lo_track_pgwrite = lo->lo_track_pgwrite;
 	memcpy(info->lo_file_name, lo->lo_file_name, LO_NAME_SIZE);
 	memcpy(info->lo_crypt_name, lo->lo_crypt_name, LO_NAME_SIZE);
 	info->lo_encrypt_type =
@@ -1036,6 +1122,7 @@ loop_info64_from_old(const struct loop_i
 	info64->lo_encrypt_type = info->lo_encrypt_type;
 	info64->lo_encrypt_key_size = info->lo_encrypt_key_size;
 	info64->lo_flags = info->lo_flags;
+	info64->lo_track_pgwrite = 0;
 	info64->lo_init[0] = info->lo_init[0];
 	info64->lo_init[1] = info->lo_init[1];
 	if (info->lo_encrypt_type == LO_CRYPT_CRYPTOAPI)
@@ -1159,6 +1246,12 @@ static int lo_ioctl(struct inode * inode
 	case LOOP_GET_STATUS64:
 		err = loop_get_status64(lo, (struct loop_info64 __user *) arg);
 		break;
+	case LOOP_GET_PGWRITES:
+		err = loop_get_pgwrites(lo, (struct loop_pgoff_array __user *) arg);
+		break;
+	case LOOP_CLR_PGWRITES:
+		err = loop_clr_pgwrites(lo);
+		break;
 	default:
 		err = lo->ioctl ? lo->ioctl(lo, cmd, arg) : -EINVAL;
 	}
@@ -1205,6 +1298,7 @@ loop_info64_from_compat(const struct com
 	info64->lo_encrypt_type = info.lo_encrypt_type;
 	info64->lo_encrypt_key_size = info.lo_encrypt_key_size;
 	info64->lo_flags = info.lo_flags;
+	info64->lo_track_pgwrite = 0;
 	info64->lo_init[0] = info.lo_init[0];
 	info64->lo_init[1] = info.lo_init[1];
 	if (info.lo_encrypt_type == LO_CRYPT_CRYPTOAPI)
@@ -1322,10 +1416,68 @@ static long lo_compat_ioctl(struct file 
 }
 #endif
 
+static int pgoff_tree_insert(struct rb_root *rb_root, unsigned long offset)
+{
+	struct rb_node ** p = &rb_root->rb_node;
+	struct rb_node * parent = NULL;
+	struct pgoff_elem *pgoff_elem;
+
+	while (*p)
+	{
+		parent = *p;
+		pgoff_elem = rb_entry(parent, struct pgoff_elem, node);
+
+		if (offset < pgoff_elem->offset)
+			p = &(*p)->rb_left;
+		else if (offset > pgoff_elem->offset)
+			p = &(*p)->rb_right;
+		else
+			return 0;
+	}
+
+	pgoff_elem = kmem_cache_alloc(pgoff_elem_cache, GFP_KERNEL);
+	if (!pgoff_elem)
+	  return -ENOMEM;
+	pgoff_elem->offset = offset;
+
+	rb_link_node(&pgoff_elem->node, parent, p);
+	rb_insert_color(&pgoff_elem->node, rb_root);
+
+	return 0;
+}
+
+static int loop_track_pgwrites(struct vm_area_struct *vma, struct page *page)
+{
+	struct file *file = vma->vm_file;
+	struct inode *inode = file->f_dentry->d_inode;
+	struct loop_device *lo = inode->i_bdev->bd_disk->private_data;
+
+	return pgoff_tree_insert(&lo->pgoff_tree, page->index);
+}
+
+struct vm_operations_struct loop_file_vm_ops = {
+	.nopage		= filemap_nopage,
+	.populate	= filemap_populate,
+	.page_mkwrite = loop_track_pgwrites
+};
+
+static int loop_file_mmap(struct file * file, struct vm_area_struct * vma)
+{
+	/* This is used for a general mmap of a disk file */
+  int err = generic_file_mmap(file, vma);
+
+  if (err)
+	 return err;
+
+	vma->vm_ops = &loop_file_vm_ops;
+	return 0;
+}
+
 static int lo_open(struct inode *inode, struct file *file)
 {
 	struct loop_device *lo = inode->i_bdev->bd_disk->private_data;
 
+	file->f_op = &loop_fops;
 	mutex_lock(&lo->lo_ctl_mutex);
 	lo->lo_refcnt++;
 	mutex_unlock(&lo->lo_ctl_mutex);
@@ -1401,6 +1553,12 @@ EXPORT_SYMBOL(loop_unregister_transfer);
 static int __init loop_init(void)
 {
 	int	i;
+	struct inode inode;
+
+	/* a roundabout way to retrieve def_blk_fops but avoids undefined reference warning */
+	init_special_inode(&inode, S_IFBLK, 0);
+	loop_fops = *(inode.i_fop);
+	loop_fops.mmap = loop_file_mmap;
 
 	if (max_loop < 1 || max_loop > 256) {
 		printk(KERN_WARNING "loop: invalid max_loop (must be between"
@@ -1411,6 +1569,10 @@ static int __init loop_init(void)
 	if (register_blkdev(LOOP_MAJOR, "loop"))
 		return -EIO;
 
+	pgoff_elem_cache = kmem_cache_create(cache_name, sizeof(struct pgoff_elem), 0, SLAB_HWCACHE_ALIGN, NULL, NULL);
+	if (!pgoff_elem_cache)
+	  goto out_mem0;
+
 	loop_dev = kmalloc(max_loop * sizeof(struct loop_device), GFP_KERNEL);
 	if (!loop_dev)
 		goto out_mem1;
@@ -1464,6 +1626,8 @@ out_mem3:
 out_mem2:
 	kfree(loop_dev);
 out_mem1:
+	kmem_cache_destroy(pgoff_elem_cache);
+out_mem0:
 	unregister_blkdev(LOOP_MAJOR, "loop");
 	printk(KERN_ERR "loop: ran out of memory\n");
 	return -ENOMEM;
@@ -1483,6 +1647,7 @@ static void loop_exit(void)
 
 	kfree(disks);
 	kfree(loop_dev);
+	kmem_cache_destroy(pgoff_elem_cache);
 }
 
 module_init(loop_init);
diff -uprN linux-2.6.19.2/include/linux/loop.h linux-2.6.19.2-new/include/linux/loop.h
--- linux-2.6.19.2/include/linux/loop.h	2007-01-11 06:10:37.000000000 +1100
+++ linux-2.6.19.2-new/include/linux/loop.h	2007-02-27 17:23:28.000000000 +1100
@@ -18,6 +18,7 @@
 #include <linux/blkdev.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
+#include <linux/rbtree.h>
 
 /* Possible states of device */
 enum {
@@ -34,6 +35,8 @@ struct loop_device {
 	loff_t		lo_offset;
 	loff_t		lo_sizelimit;
 	int		lo_flags;
+	int		lo_track_pgwrite;	
+	struct rb_root	pgoff_tree;
 	int		(*transfer)(struct loop_device *, int cmd,
 				    struct page *raw_page, unsigned raw_off,
 				    struct page *loop_page, unsigned loop_off,
@@ -66,6 +69,12 @@ struct loop_device {
 	request_queue_t		*lo_queue;
 };
 
+struct pgoff_elem {
+
+  struct rb_node	node;
+  unsigned long offset;
+};
+
 #endif /* __KERNEL__ */
 
 /*
@@ -105,12 +114,20 @@ struct loop_info64 {
 	__u32		   lo_encrypt_type;
 	__u32		   lo_encrypt_key_size;		/* ioctl w/o */
 	__u32		   lo_flags;			/* ioctl r/o */
+	__u32			lo_track_pgwrite; 
 	__u8		   lo_file_name[LO_NAME_SIZE];
 	__u8		   lo_crypt_name[LO_NAME_SIZE];
 	__u8		   lo_encrypt_key[LO_KEY_SIZE]; /* ioctl w/o */
 	__u64		   lo_init[2];
 };
 
+struct loop_pgoff_array {
+  __u64 max; /* size of array passed by user */
+  __u64 num; /* number of entries filled in by driver */
+  __u64 *pgoff; /* array of page offsets of pages written to by mmap */
+};
+
+
 /*
  * Loop filter types
  */
@@ -157,5 +174,7 @@ int loop_unregister_transfer(int number)
 #define LOOP_SET_STATUS64	0x4C04
 #define LOOP_GET_STATUS64	0x4C05
 #define LOOP_CHANGE_FD		0x4C06
+#define LOOP_GET_PGWRITES	0x4C07
+#define LOOP_CLR_PGWRITES	0x4C08
 
 #endif
