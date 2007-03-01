Return-Path: <linux-kernel-owner+w=401wt.eu-S1030405AbXCAWCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030405AbXCAWCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 17:02:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030402AbXCAWCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 17:02:06 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:54794 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030399AbXCAWCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 17:02:05 -0500
Date: Thu, 1 Mar 2007 13:58:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: kven709@cse.unsw.edu.au (Kandan Venkataraman)
Cc: linux-kernel@vger.kernel.org, kandan.venkataraman@omxgroup.com
Subject: Re: [PATCH] Loop device - Tracking page writes made to a loop
 device through mmap
Message-Id: <20070301135820.2b02f421.randy.dunlap@oracle.com>
In-Reply-To: <1070301052516.11639@cse.unsw.edu.au>
References: <1070301052516.11639@cse.unsw.edu.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2007 16:25:16 +1100 Kandan Venkataraman wrote:

Sorry, I missed seeing your reposted patch when I replied to the
earlier patch.

> The patch is for tracking writes made to a loop device made through mmap. 

How did you test this?  (what program(s))

> Two new ioctls have been added.
>  
> The ioctl cmd LOOP_GET_PGWRITES retrieves the page offsets of pages that have been written to.
> The ioctl cmd LOOP_CLR_PGWRITES empties the red-black tree

I don't quite understand:  what software would use these ioctls?

> This functionality would allow us to have a read only version and a write version of memory by doing the following:
> Associate a normal file as backing storage for  the loop device and mmap to the loop device. Call this mmapped address space as area1.
> Mmap to a normal file of identical size. Call this mmapped address space as area2.
>  
> Changes made to area1 can be periodically copied to area2 using the ioctl cmds (retreive dirty page offsets and copy the dirty pages from area1 to area2). This facility would provide a quick way of updating the read only version.
> 
> Please CC your reply to kandan.venkataraman@omxgroup.com
>  
> The following patch is against vanilla linux-2.6.19.2
>  
> Signed-off-by: Kandan Venkataraman kandan.venkataraman@omxgroup.com
> 
> 
> diff -uprN linux-2.6.19.2/drivers/block/loop.c linux-2.6.19.2-new/drivers/block/loop.c
> --- linux-2.6.19.2/drivers/block/loop.c	2007-01-11 06:10:37.000000000 +1100
> +++ linux-2.6.19.2-new/drivers/block/loop.c	2007-02-27 17:23:18.000000000 +1100
> @@ -74,12 +74,16 @@
>  #include <linux/highmem.h>
>  #include <linux/gfp.h>
>  #include <linux/kthread.h>
> +#include <linux/mm.h>
>  
>  #include <asm/uaccess.h>
>  
>  static int max_loop = 8;
>  static struct loop_device *loop_dev;
>  static struct gendisk **disks;
> +static kmem_cache_t *pgoff_elem_cache;
> +static char*  cache_name = "loop_pgoff_elem_cache";

Use style/format as 2 lines above:
static char *cache_name = "loop_pgoff_elem_cache";

> +static struct file_operations loop_fops;
>  
>  /*
>   * Transfer functions
> @@ -646,6 +650,73 @@ static void do_loop_switch(struct loop_d
>  	complete(&p->wait);
>  }
>  
> +
> +
> +static int loop_get_pgwrites(struct loop_device *lo, struct loop_pgoff_array __user *arg)
> +{
> +	struct file *filp = lo->lo_backing_file;
> +	struct loop_pgoff_array array;
> +	loff_t i = 0;
> +	struct rb_node *rb_node  = rb_first(&lo->pgoff_tree);
> +
> +	if (lo->lo_state != Lo_bound)
> +		return -ENXIO;
> +
> +	if (filp == NULL)
> +		return -EINVAL;
> +
> +	if (!lo->lo_track_pgwrite)
> +	  return 0;

Indent above with 2 tabs, please.

> +
> +	if (copy_from_user(&array, arg, sizeof (struct loop_pgoff_array)))
> +		return -EFAULT;
> +
> +	while (i < array.max && rb_node != NULL) {
> +
> +	  if (put_user(rb_entry(rb_node, struct pgoff_elem, node)->offset, array.pgoff + i))
> +		 return -EFAULT;
> +
> +	  ++i;
> +	  rb_node = rb_next(rb_node);

Indent with tabs, not spaces.

> +	}
> +	array.num = i;
> +
> +	if (copy_to_user(arg, &array, sizeof(array)))
> +	  return -EFAULT;

indentation...

> +
> +	return 0;
> +}
>  
>  /*
>   * loop_change_fd switched the backing store of a loopback device to
> @@ -969,6 +1046,14 @@ loop_set_status(struct loop_device *lo, 
>  			return -EFBIG;
>  	}
>  
> +	if (info->lo_track_pgwrite)
> +	  lo->lo_track_pgwrite = 1;
> +	else {
> +	  if (lo->lo_track_pgwrite)
> +		 pgoff_tree_clear(&lo->pgoff_tree);
> +	  lo->lo_track_pgwrite = 0;
> +	}

indentation

> +
>  	memcpy(lo->lo_file_name, info->lo_file_name, LO_NAME_SIZE);
>  	memcpy(lo->lo_crypt_name, info->lo_crypt_name, LO_NAME_SIZE);
>  	lo->lo_file_name[LO_NAME_SIZE-1] = 0;
> @@ -1322,10 +1416,68 @@ static long lo_compat_ioctl(struct file 
>  }
>  #endif
>  
> +static int pgoff_tree_insert(struct rb_root *rb_root, unsigned long offset)
> +{
> +	struct rb_node ** p = &rb_root->rb_node;
> +	struct rb_node * parent = NULL;

No space after "**" and "*" above.

> +	struct pgoff_elem *pgoff_elem;
> +
> +	while (*p)
> +	{

Don't put { on separate line, just put it after while:
	while (*p) {

> +		parent = *p;
> +		pgoff_elem = rb_entry(parent, struct pgoff_elem, node);
> +
> +		if (offset < pgoff_elem->offset)
> +			p = &(*p)->rb_left;
> +		else if (offset > pgoff_elem->offset)
> +			p = &(*p)->rb_right;
> +		else
> +			return 0;
> +	}
> +
> +	pgoff_elem = kmem_cache_alloc(pgoff_elem_cache, GFP_KERNEL);
> +	if (!pgoff_elem)
> +	  return -ENOMEM;

indentation.

> +	pgoff_elem->offset = offset;
> +
> +	rb_link_node(&pgoff_elem->node, parent, p);
> +	rb_insert_color(&pgoff_elem->node, rb_root);
> +
> +	return 0;
> +}
> +
> +
> +struct vm_operations_struct loop_file_vm_ops = {
> +	.nopage		= filemap_nopage,
> +	.populate	= filemap_populate,
> +	.page_mkwrite = loop_track_pgwrites
> +};
> +
> +static int loop_file_mmap(struct file * file, struct vm_area_struct * vma)
> +{
> +	/* This is used for a general mmap of a disk file */
> +  int err = generic_file_mmap(file, vma);
> +
> +  if (err)
> +	 return err;
> +

Odd/inconsistent indentation above/below.  Above lines should be
indented with one tab (2 tabs on 'return').

> +	vma->vm_ops = &loop_file_vm_ops;
> +	return 0;
> +}
> +
> @@ -1401,6 +1553,12 @@ EXPORT_SYMBOL(loop_unregister_transfer);
>  static int __init loop_init(void)
>  {
>  	int	i;
> +	struct inode inode;
> +
> +	/* a roundabout way to retrieve def_blk_fops but avoids undefined reference warning */

Should there be a clean kernel API instead of this roundabout way?

> +	init_special_inode(&inode, S_IFBLK, 0);
> +	loop_fops = *(inode.i_fop);
> +	loop_fops.mmap = loop_file_mmap;
>  
>  	if (max_loop < 1 || max_loop > 256) {
>  		printk(KERN_WARNING "loop: invalid max_loop (must be between"
> @@ -1411,6 +1569,10 @@ static int __init loop_init(void)
>  	if (register_blkdev(LOOP_MAJOR, "loop"))
>  		return -EIO;
>  
> +	pgoff_elem_cache = kmem_cache_create(cache_name, sizeof(struct pgoff_elem), 0, SLAB_HWCACHE_ALIGN, NULL, NULL);

line too long.

> +	if (!pgoff_elem_cache)
> +	  goto out_mem0;

indentation.

> +
>  	loop_dev = kmalloc(max_loop * sizeof(struct loop_device), GFP_KERNEL);
>  	if (!loop_dev)
>  		goto out_mem1;
> diff -uprN linux-2.6.19.2/include/linux/loop.h linux-2.6.19.2-new/include/linux/loop.h
> --- linux-2.6.19.2/include/linux/loop.h	2007-01-11 06:10:37.000000000 +1100
> +++ linux-2.6.19.2-new/include/linux/loop.h	2007-02-27 17:23:28.000000000 +1100
> @@ -66,6 +69,12 @@ struct loop_device {
>  	request_queue_t		*lo_queue;
>  };
>  
> +struct pgoff_elem {
> +

no blank line here.

> +  struct rb_node	node;
> +  unsigned long offset;
> +};
> +
>  #endif /* __KERNEL__ */
>  
>  /*
> @@ -105,12 +114,20 @@ struct loop_info64 {
>  	__u32		   lo_encrypt_type;
>  	__u32		   lo_encrypt_key_size;		/* ioctl w/o */
>  	__u32		   lo_flags;			/* ioctl r/o */
> +	__u32			lo_track_pgwrite; 

Make the fields align.  And that line ends with trailing space.
(There are 2 new patch lines like that; please don't do that.)

>  	__u8		   lo_file_name[LO_NAME_SIZE];
>  	__u8		   lo_crypt_name[LO_NAME_SIZE];
>  	__u8		   lo_encrypt_key[LO_KEY_SIZE]; /* ioctl w/o */
>  	__u64		   lo_init[2];
>  };
>  
> +struct loop_pgoff_array {
> +  __u64 max; /* size of array passed by user */
> +  __u64 num; /* number of entries filled in by driver */
> +  __u64 *pgoff; /* array of page offsets of pages written to by mmap */
> +};
> +
> +
>  /*
>   * Loop filter types
>   */
> @@ -157,5 +174,7 @@ int loop_unregister_transfer(int number)
>  #define LOOP_SET_STATUS64	0x4C04
>  #define LOOP_GET_STATUS64	0x4C05
>  #define LOOP_CHANGE_FD		0x4C06
> +#define LOOP_GET_PGWRITES	0x4C07
> +#define LOOP_CLR_PGWRITES	0x4C08
>  
>  #endif
> -

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
