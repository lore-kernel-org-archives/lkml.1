Return-Path: <linux-kernel-owner+w=401wt.eu-S965547AbXCAT5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965547AbXCAT5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 14:57:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965550AbXCAT5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 14:57:04 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:10374 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965549AbXCAT5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 14:57:03 -0500
Date: Thu, 1 Mar 2007 11:52:57 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Kandan Venkataraman" <Kandan.Venkataraman@omxgroup.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Loop device - Tracking page writes made to a loop
 device through mmap
Message-Id: <20070301115257.2ac549ab.randy.dunlap@oracle.com>
In-Reply-To: <2EA76CB0517BD6428BD88A6D2FA68223759FA0@SE06CORPEVS01.corp.ad.local>
References: <2EA76CB0517BD6428BD88A6D2FA68223759FA0@SE06CORPEVS01.corp.ad.local>
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

On Thu, 1 Mar 2007 02:40:41 +0100 Kandan Venkataraman wrote:

> The patch is for tracking writes made to a loop device made through
> mmap. 
>  
> A  file_operations structure variable called loop_fops is initialised
> with the default block device file operations (def_blk_fops).
> The mmap operation is overriden with a new function called
> loop_file_mmap. 
>  
> A vm_operations structure variable called loop_file_vm_ops is
> initialised with the default operations for a disk file.
> The page_mkwrite operation in this variable is initialised to a new
> function called loop_track_pgwrites.
>  
> In the function lo_open, the file operations pointer of the device file
> is initialised with the address of loop_fops.
>  
> The function loop_file_mmap simply calls generic_file_mmap and then
> initialises the vm_ops of the vma with address of loop_file_vm_ops.
>  
> The function loop_track_pgwrites stores the page offset of the page that
> is being written to,  in a red-black tree within the loop device.
>  
> A flag lo_track_pgwrite has been added to the structs loop_device and
> loop_info64 to turn on/off tracking of page writes.
>  
> Two new ioctls have been added.
>  
> The ioctl cmd LOOP_GET_PGWRITES retrieves the page offsets of pages that
> have been written to.
> The ioctl cmd LOOP_CLR_PGWRITES empties the red-black tree
>  
> This functionality would allow us to have a read only version and a
> write version of memory by doing the following:
> Associate a normal file as backing storage for  the loop device and mmap
> to the loop device. Call this mmapped address space as area1.
> Mmap to a normal file of identical size. Call this mmapped address space
> as area2.
>  
> Changes made to area1 can be periodically copied to area2 using the
> ioctl cmds (retreive dirty page offsets and copy the dirty pages from
> area1 to area2). This facility would provide a quick way of updating the
> read only version.
>  
> The following patch is against vanilla linux-2.6.19.2

Patches should be made against current mainline (Linus's tree)
unless (1) they are specifically for one of the stable trees
or (2) they are specifically for the -mm patchset.


> Signed-off-by: Kandan Venkataraman kandan.venkataraman@omxgroup.com
>  
>  
> diff -uprN linux-2.6.19.2/drivers/block/loop.c
> linux-2.6.19.2-new/drivers/block/loop.c
> --- linux-2.6.19.2/drivers/block/loop.c 2007-01-11 06:10:37.000000000
> +1100

Long lines above & below were split somewhere along the way
(likely by some mail s/w)...

> +++ linux-2.6.19.2-new/drivers/block/loop.c 2007-02-27
> 17:23:18.000000000 +1100
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
> +static struct file_operations loop_fops;
>  
>  /*
>   * Transfer functions
> @@ -646,6 +650,73 @@ static void do_loop_switch(struct loop_d
>   complete(&p->wait);
>  }
>  
> +static void pgoff_tree_clear(struct rb_root *rb_root)
> +{
> + struct rb_node *rb_node  = rb_root->rb_node;
> +
> + while (rb_node != NULL) {
> +
> +  rb_erase(rb_node, rb_root); 
> +  kmem_cache_free(pgoff_elem_cache, rb_entry(rb_node, struct
> pgoff_elem, node));

another long line (bad) split above.  There are more of these,
but I won't continue to point out all of them.

And all tabs from the source have been converted to spaces, again
by some mail s/w somewhere along the way... so the patch does not
apply cleanly.

> +  rb_node = rb_root->rb_node;
> + }
> +
> +  *rb_root = RB_ROOT;
> +}
> +
> +
> +static int loop_get_pgwrites(struct loop_device *lo, struct
> loop_pgoff_array __user *arg)

Please try to keep source lines < 80 columns.  It's OK to split
a function declaration into multiple lines, e.g.:

static int loop_get_pgwrites(struct loop_device *lo,
			     struct loop_pgoff_array __user *arg)

> +{
> +}

> @@ -1401,6 +1553,12 @@ EXPORT_SYMBOL(loop_unregister_transfer);
>  static int __init loop_init(void)
>  {
>   int i;
> + struct inode inode;
> +
> + /* a roundabout way to retrieve def_blk_fops but avoids undefined
> reference warning */

Does there need to be a legitimate API for retrieving this pointer?

> + init_special_inode(&inode, S_IFBLK, 0);
> + loop_fops = *(inode.i_fop);
> + loop_fops.mmap = loop_file_mmap;
>  
>   if (max_loop < 1 || max_loop > 256) {
>    printk(KERN_WARNING "loop: invalid max_loop (must be between"
> @@ -1411,6 +1569,10 @@ static int __init loop_init(void)
>   if (register_blkdev(LOOP_MAJOR, "loop"))
>    return -EIO;
>  
> + pgoff_elem_cache = kmem_cache_create(cache_name, sizeof(struct
> pgoff_elem), 0, SLAB_HWCACHE_ALIGN, NULL, NULL);

Line too long.

> + if (!pgoff_elem_cache)
> +   goto out_mem0;
> +
>   loop_dev = kmalloc(max_loop * sizeof(struct loop_device), GFP_KERNEL);
>   if (!loop_dev)
>    goto out_mem1;


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
