Return-Path: <linux-kernel-owner+w=401wt.eu-S2992616AbXCBQ4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992616AbXCBQ4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:56:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992619AbXCBQ4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:56:01 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:64595 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992616AbXCBQ4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:56:00 -0500
Date: Fri, 2 Mar 2007 08:52:53 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Kandan Venkataraman <kven709@cse.unsw.EDU.AU>
Cc: linux-kernel@vger.kernel.org, kandan.venkataraman@omxgroup.com
Subject: Re: [PATCH] Loop device - Tracking page writes made to a loop
 device through mmap
Message-Id: <20070302085253.05397b6f.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0703022209450.19671@williams.orchestra.cse.unsw.EDU.AU>
References: <1070301052516.11639@cse.unsw.edu.au>
	<20070301135820.2b02f421.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0703022209450.19671@williams.orchestra.cse.unsw.EDU.AU>
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

On Fri, 2 Mar 2007 22:13:46 +1100 (EST) Kandan Venkataraman wrote:

> I am resending the message. The first few lines  in the diff of the
> original message seemed to have an extra space added by the time it got to
> the mailing list. Hopefully this does not happen the second time around.
> 
> Also, I missed out on putting a tab space on one line.
> 
> 
> I have incorporated all the changes you mentioned, except for one. Thank you very much for taking the time to 
> review the code. I still retreive def_blk_fops as I did before, but I have put this in a separate function for now.

OK, that's a good compromise, at least for now.


> I have included a test program. Before you run the test program, please create the backing storage file
> for the loop device as follows
> 
> dd if=/dev/zero of=/root/file bs=4K count=10
> 
> Set bs to be whatever pagesize is in your machine. In my machine it was 4K.

Thanks.

[snipped]

> Now I will explain what kind of software would find the new ioctls useful.

That's a good explanation, thanks.  And your original patch description
was also thorough (IMO).

> diff -uprN linux-2.6.19.2/drivers/block/loop.c linux-2.6.19.2-new/drivers/block/loop.c
> --- linux-2.6.19.2/drivers/block/loop.c	2007-03-02 22:05:06.000000000 +1100
> +++ linux-2.6.19.2-new/drivers/block/loop.c	2007-03-02 22:03:49.000000000 +1100
> @@ -74,12 +74,16 @@
>   #include <linux/highmem.h>
>   #include <linux/gfp.h>
>   #include <linux/kthread.h>
> +#include <linux/mm.h>

That looks fishy.  Have you tried to apply the patch from this email?
I'm not finding patch (program) happy with the patch file.
(too much leading whitespace on non-patched lines)

> 
>   #include <asm/uaccess.h>
> 
>   static int max_loop = 8;
>   static struct loop_device *loop_dev;
>   static struct gendisk **disks;
> +static kmem_cache_t *pgoff_elem_cache;
> +static char* cache_name = "loop_pgoff_elem_cache";

stataic char *cache_name

> +static struct file_operations loop_fops;
> 
>   /*
>    * Transfer functions
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
> +	if (filp == NULL || !lo->lo_track_pgwrite)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&array, arg, sizeof (struct loop_pgoff_array)))
> +		return -EFAULT;
> +
> +	while (i < array.max && rb_node != NULL) {
> +
> +		if (put_user(rb_entry(rb_node, struct pgoff_elem, node)->offset, array.pgoff + i))

Still need to break (split) several long lines.

> +			return -EFAULT;
> +
> +		++i;
> +		rb_node = rb_next(rb_node);
> +	}
> +	array.num = i;
> +
> +	if (copy_to_user(arg, &array, sizeof(array)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> 
>   /*
>    * loop_change_fd switched the backing store of a loopback device to
> @@ -1322,10 +1414,67 @@ static long lo_compat_ioctl(struct file
>   }
>   #endif
> 
> +static int loop_file_mmap(struct file * file, struct vm_area_struct * vma)
> +{
> +	/* This is used for a general mmap of a disk file */
> +	int err = generic_file_mmap(file, vma);
> +
> +	if (err)
> +	return err;

indentation

> +
> +	vma->vm_ops = &loop_file_vm_ops;
> +	return 0;
> +}
> +


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
