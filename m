Return-Path: <linux-kernel-owner+w=401wt.eu-S1423025AbXCBLOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423025AbXCBLOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 06:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423026AbXCBLOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 06:14:54 -0500
Received: from note.orchestra.cse.unsw.EDU.AU ([129.94.242.24]:38647 "EHLO
	note.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423025AbXCBLOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 06:14:53 -0500
From: Kandan Venkataraman <kven709@cse.unsw.EDU.AU>
To: Randy Dunlap <randy.dunlap@oracle.com>
Date: Fri, 2 Mar 2007 22:13:46 +1100 (EST)
X-X-Sender: kven709@williams.orchestra.cse.unsw.EDU.AU
cc: linux-kernel@vger.kernel.org, kandan.venkataraman@omxgroup.com
Subject: Re: [PATCH] Loop device - Tracking page writes made to a loop device
 through mmap
In-Reply-To: <20070301135820.2b02f421.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0703022209450.19671@williams.orchestra.cse.unsw.EDU.AU>
References: <1070301052516.11639@cse.unsw.edu.au> <20070301135820.2b02f421.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am resending the message. The first few lines  in the diff of the
original message seemed to have an extra space added by the time it got to
the mailing list. Hopefully this does not happen the second time around.

Also, I missed out on putting a tab space on one line.


I have incorporated all the changes you mentioned, except for one. Thank you very much for taking the time to 
review the code. I still retreive def_blk_fops as I did before, but I have put this in a separate function for now.


I have included a test program. Before you run the test program, please create the backing storage file
for the loop device as follows

dd if=/dev/zero of=/root/file bs=4K count=10

Set bs to be whatever pagesize is in your machine. In my machine it was 4K.


#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>
#include <assert.h>
#include <signal.h>
#include <errno.h>
#include <linux/loop.h>

int main()
{
 	int maxPages = 10;
 	char* start = 0;
 	int fd;
 	int dfd;
 	int *array = 0;
 	int pageSize;
 	int elemsPerPage;
 	struct loop_info64 info;
 	struct loop_pgoff_array pgarray;

 	pgarray.max = maxPages;

 	pgarray.pgoff = calloc(maxPages, sizeof(long));

 	if (pgarray.pgoff == NULL) {
 		fprintf(stderr, "can't create pgarray\n");
 		exit(1);
 	}

 	pageSize = getpagesize();

 	elemsPerPage = pageSize/sizeof(int);

 	/* open the device file */
 	if ((fd = open ("/dev/loop0", O_RDWR, S_IRWXU)) < 0) {
 		fprintf(stderr, "can't create device file for writing\n");
 		goto out5;
 	}

 	/* open the disk file  to set as backing storage*/
 	if ((dfd = open ("/root/file", O_RDWR, S_IRWXU)) < 0) {
 		fprintf(stderr, "can't create device file for writing\n");
 		goto out4;
 	}

 	if (ioctl(fd, LOOP_SET_FD, dfd) < 0) {
 		perror("ioctl: LOOP_SET_FD");
 		goto out3;
 	}

 	if ((start = mmap(0, maxPages * pageSize, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0)) == MAP_FAILED) {

 		perror("mmap error");
 		goto out2;
 	}

 	if (ioctl(fd, LOOP_GET_STATUS64, &info) < 0) {
 		perror("ioctl: LOOP_CLR_PGWRITES");
 		goto out1;
 	}

 	info.lo_track_pgwrite = 1;

 	if (ioctl(fd, LOOP_SET_STATUS64, &info) < 0) {
 		perror("ioctl: LOOP_SET_STATUS64");
 		goto out1;
 	}

 	if (ioctl(fd, LOOP_CLR_PGWRITES, 0) < 0) {
 		perror("ioctl: LOOP_CLR_PGWRITES");
 		goto out1;
 	}

 	array = (int *)start;

 	array[0] = 5;

 	fprintf(stderr, "value = %d\n", array[0]);

 	array[1] = 9;

 	fprintf(stderr, "value = %d\n", array[1]);

 	array[elemsPerPage] = 14;

 	fprintf(stderr, "value = %d\n", array[elemsPerPage]);

 	array[3*elemsPerPage+60] = 35;

 	fprintf(stderr, "value = %d\n", array[3*elemsPerPage+60]);

 	if (ioctl(fd, LOOP_GET_PGWRITES, &pgarray) < 0) {
 		perror("ioctl: LOOP_GET_PGWRITES");
 		goto out1;
 	}

 	int i;
 	for (i= 0; i < pgarray.num; i++)
 		fprintf(stderr, "offset %ld\n", pgarray.pgoff[i]);

out1:
 	munmap(start, maxPages * pageSize);
out2:
 	ioctl(fd, LOOP_CLR_FD, 0);
out3:
 	close(dfd);
out4:
 	close(fd);
out5:
 	return 0;
}


Now I will explain what kind of software would find the new ioctls useful.

Imagine a business server application which processes messages from clients as they come in (say over a TCP connection).
Some of those messages may be transactions, i.e. they cause data changes in the application. 
Rest of those messages may be queries i.e. they get information from the application.
The application can consist of two processes. One process will handle the transactions.
The other process will handle the queries. Each process will have its own copy of the business data.
The process handling transactions can mmap to the loop device for its copy of the memory. The loop device must have a normal
file for its backing storage.
The process handling queries can mmap to another normal file for its copy of the memory.  Both these memories have identical
data at the beginning.
Queries and transactions can now be handled simultaneously by the respective processes.
The query process can update its memory periodically by obtaining the changes that have have happened to the loop device.
By using the ioctl call to retrieve the dirty page offsets, only the dirty pages need to be copied over to the
query process's copy of memory. We can infact have multiple processes to handle queries sharing the same memory.
During this copy over, the transaction process will hold off processing transactions till the update is complete.

This would be very useful for high speed in-memory transaction systems, where the query load can be passed
of to other processes. Example of such systems would be a stock trading system, where clients buy and sell
stock(equity, options etc). 
At the same time lot of clients would be downloading market data and this can be done independently of the transactions.

This new facility will provide a way of tracking changes made to business data, independent of the application domain.

Signed-off-by: Kandan Venkataraman kandan.venkataraman@omxgroup.com


diff -uprN linux-2.6.19.2/drivers/block/loop.c linux-2.6.19.2-new/drivers/block/loop.c
--- linux-2.6.19.2/drivers/block/loop.c	2007-03-02 22:05:06.000000000 +1100
+++ linux-2.6.19.2-new/drivers/block/loop.c	2007-03-02 22:03:49.000000000 +1100
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
+static char* cache_name = "loop_pgoff_elem_cache";
+static struct file_operations loop_fops;

  /*
   * Transfer functions
@@ -646,6 +650,67 @@ static void do_loop_switch(struct loop_d
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
+	*rb_root = RB_ROOT;
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
+	if (filp == NULL || !lo->lo_track_pgwrite)
+		return -EINVAL;
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
+	if (filp == NULL || !lo->lo_track_pgwrite)
+		return -EINVAL;
+
+	if (copy_from_user(&array, arg, sizeof (struct loop_pgoff_array)))
+		return -EFAULT;
+
+	while (i < array.max && rb_node != NULL) {
+
+		if (put_user(rb_entry(rb_node, struct pgoff_elem, node)->offset, array.pgoff + i))
+			return -EFAULT;
+
+		++i;
+		rb_node = rb_next(rb_node);
+	}
+	array.num = i;
+
+	if (copy_to_user(arg, &array, sizeof(array)))
+		return -EFAULT;
+
+	return 0;
+}

  /*
   * loop_change_fd switched the backing store of a loopback device to
@@ -692,6 +757,8 @@ static int loop_change_fd(struct loop_de
  	if (get_loop_size(lo, file) != get_loop_size(lo, old_file))
  		goto out_putf;

+	pgoff_tree_clear(&lo->pgoff_tree);
+
  	/* and ... switch */
  	error = loop_switch(lo, file);
  	if (error)
@@ -799,6 +866,8 @@ static int loop_set_fd(struct loop_devic
  	lo->transfer = transfer_none;
  	lo->ioctl = NULL;
  	lo->lo_sizelimit = 0;
+	lo->lo_track_pgwrite = 0;
+	lo->pgoff_tree = RB_ROOT;
  	lo->old_gfp_mask = mapping_gfp_mask(mapping);
  	mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));

@@ -913,6 +982,8 @@ static int loop_clr_fd(struct loop_devic
  	lo->lo_sizelimit = 0;
  	lo->lo_encrypt_key_size = 0;
  	lo->lo_flags = 0;
+	lo->lo_track_pgwrite = 0;
+	pgoff_tree_clear(&lo->pgoff_tree);
  	lo->lo_thread = NULL;
  	memset(lo->lo_encrypt_key, 0, LO_KEY_SIZE);
  	memset(lo->lo_crypt_name, 0, LO_NAME_SIZE);
@@ -969,6 +1040,14 @@ loop_set_status(struct loop_device *lo,
  			return -EFBIG;
  	}

+	if (info->lo_track_pgwrite)
+		lo->lo_track_pgwrite = 1;
+	else {
+		if (lo->lo_track_pgwrite)
+			pgoff_tree_clear(&lo->pgoff_tree);
+			lo->lo_track_pgwrite = 0;
+	}
+
  	memcpy(lo->lo_file_name, info->lo_file_name, LO_NAME_SIZE);
  	memcpy(lo->lo_crypt_name, info->lo_crypt_name, LO_NAME_SIZE);
  	lo->lo_file_name[LO_NAME_SIZE-1] = 0;
@@ -1011,6 +1090,7 @@ loop_get_status(struct loop_device *lo,
  	info->lo_offset = lo->lo_offset;
  	info->lo_sizelimit = lo->lo_sizelimit;
  	info->lo_flags = lo->lo_flags;
+	info->lo_track_pgwrite = lo->lo_track_pgwrite;
  	memcpy(info->lo_file_name, lo->lo_file_name, LO_NAME_SIZE);
  	memcpy(info->lo_crypt_name, lo->lo_crypt_name, LO_NAME_SIZE);
  	info->lo_encrypt_type =
@@ -1036,6 +1116,7 @@ loop_info64_from_old(const struct loop_i
  	info64->lo_encrypt_type = info->lo_encrypt_type;
  	info64->lo_encrypt_key_size = info->lo_encrypt_key_size;
  	info64->lo_flags = info->lo_flags;
+	info64->lo_track_pgwrite = 0;
  	info64->lo_init[0] = info->lo_init[0];
  	info64->lo_init[1] = info->lo_init[1];
  	if (info->lo_encrypt_type == LO_CRYPT_CRYPTOAPI)
@@ -1159,6 +1240,12 @@ static int lo_ioctl(struct inode * inode
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
@@ -1205,6 +1292,7 @@ loop_info64_from_compat(const struct com
  	info64->lo_encrypt_type = info.lo_encrypt_type;
  	info64->lo_encrypt_key_size = info.lo_encrypt_key_size;
  	info64->lo_flags = info.lo_flags;
+	info64->lo_track_pgwrite = 0;
  	info64->lo_init[0] = info.lo_init[0];
  	info64->lo_init[1] = info.lo_init[1];
  	if (info.lo_encrypt_type == LO_CRYPT_CRYPTOAPI)
@@ -1313,6 +1401,10 @@ static long lo_compat_ioctl(struct file
  	case LOOP_CHANGE_FD:
  		err = lo_ioctl(inode, file, cmd, arg);
  		break;
+	case LOOP_GET_PGWRITES:
+	case LOOP_CLR_PGWRITES:
+		err = -EINVAL;
+		break;
  	default:
  		err = -ENOIOCTLCMD;
  		break;
@@ -1322,10 +1414,67 @@ static long lo_compat_ioctl(struct file
  }
  #endif

+static int pgoff_tree_insert(struct rb_root *rb_root, unsigned long offset)
+{
+	struct rb_node **p = &rb_root->rb_node;
+	struct rb_node *parent = NULL;
+	struct pgoff_elem *pgoff_elem;
+
+	while (*p) {
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
+		return -ENOMEM;
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
+	int err = generic_file_mmap(file, vma);
+
+	if (err)
+	return err;
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
@@ -1398,10 +1547,23 @@ int loop_unregister_transfer(int number)
  EXPORT_SYMBOL(loop_register_transfer);
  EXPORT_SYMBOL(loop_unregister_transfer);

+static const struct file_operations *get_def_blk_fops(void)
+{
+	struct inode inode;
+
+	/* a roundabout way to retrieve def_blk_fops but avoids undefined reference warning */
+	init_special_inode(&inode, S_IFBLK, 0);
+
+	return inode.i_fop;
+}
+
  static int __init loop_init(void)
  {
  	int	i;

+	loop_fops = *(get_def_blk_fops());
+	loop_fops.mmap = loop_file_mmap;
+
  	if (max_loop < 1 || max_loop > 256) {
  		printk(KERN_WARNING "loop: invalid max_loop (must be between"
  				    " 1 and 256), using default (8)\n");
@@ -1411,6 +1573,11 @@ static int __init loop_init(void)
  	if (register_blkdev(LOOP_MAJOR, "loop"))
  		return -EIO;

+	pgoff_elem_cache = kmem_cache_create(cache_name, sizeof(struct pgoff_elem), 0,
+					     SLAB_HWCACHE_ALIGN, NULL, NULL);
+	if (!pgoff_elem_cache)
+		goto out_mem0;
+
  	loop_dev = kmalloc(max_loop * sizeof(struct loop_device), GFP_KERNEL);
  	if (!loop_dev)
  		goto out_mem1;
@@ -1464,6 +1631,8 @@ out_mem3:
  out_mem2:
  	kfree(loop_dev);
  out_mem1:
+	kmem_cache_destroy(pgoff_elem_cache);
+out_mem0:
  	unregister_blkdev(LOOP_MAJOR, "loop");
  	printk(KERN_ERR "loop: ran out of memory\n");
  	return -ENOMEM;
@@ -1483,6 +1652,7 @@ static void loop_exit(void)

  	kfree(disks);
  	kfree(loop_dev);
+	kmem_cache_destroy(pgoff_elem_cache);
  }

  module_init(loop_init);
diff -uprN linux-2.6.19.2/include/linux/loop.h linux-2.6.19.2-new/include/linux/loop.h
--- linux-2.6.19.2/include/linux/loop.h	2007-03-02 22:04:43.000000000 +1100
+++ linux-2.6.19.2-new/include/linux/loop.h	2007-03-02 21:58:57.000000000 +1100
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
@@ -66,6 +69,11 @@ struct loop_device {
  	request_queue_t		*lo_queue;
  };

+struct pgoff_elem {
+	struct rb_node		node;
+ 	unsigned long		offset;
+};
+
  #endif /* __KERNEL__ */

  /*
@@ -105,12 +113,20 @@ struct loop_info64 {
  	__u32		   lo_encrypt_type;
  	__u32		   lo_encrypt_key_size;		/* ioctl w/o */
  	__u32		   lo_flags;			/* ioctl r/o */
+	__u32		   lo_track_pgwrite;
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
@@ -157,5 +173,7 @@ int loop_unregister_transfer(int number)
  #define LOOP_SET_STATUS64	0x4C04
  #define LOOP_GET_STATUS64	0x4C05
  #define LOOP_CHANGE_FD		0x4C06
+#define LOOP_GET_PGWRITES	0x4C07
+#define LOOP_CLR_PGWRITES	0x4C08

  #endif



