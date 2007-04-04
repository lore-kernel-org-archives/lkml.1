Return-Path: <linux-kernel-owner+w=401wt.eu-S2992831AbXDDKbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992831AbXDDKbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 06:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992834AbXDDKbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 06:31:20 -0400
Received: from hosting4p.com ([81.0.235.160]:47107 "EHLO micron1.hosting4p.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992831AbXDDKbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 06:31:18 -0400
Message-ID: <46137E7D.8090809@slax.org>
Date: Wed, 04 Apr 2007 12:31:25 +0200
From: Tomas M <tomas@slax.org>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ken Chen <kenchen@google.com>
Subject: Re: [patch] remove artificial software max_loop limit
References: <b040c32a0703300053u110063b0u80ee0e7b9dd158c2@mail.gmail.com>	 <b040c32a0703300148w479cf4cdw667cf464edf7c725@mail.gmail.com>	 <Pine.LNX.4.61.0703301105190.31834@yvahk01.tjqt.qr>	 <b040c32a0703300225r3f8b1daah2f95e8af26c0d867@mail.gmail.com>	 <20070330141524.5f6cff29.akpm@linux-foundation.org>	 <20070331170743.GB14596@kroah.com>	 <20070331104144.46c85f27.akpm@linux-foundation.org> <b040c32a0703312116y56bad12h9d370a8a2c99b245@mail.gmail.com>
In-Reply-To: <b040c32a0703312116y56bad12h9d370a8a2c99b245@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > OK, here is a re-spin patch that I tested as module or
 > link-in-vmlinux.  Both produce satisfactory result for me.

Is there a plan to include this brilliant code in mainline Kernel?
It works excellent, tested with 15000 loop devices, it's simply cool.

Thank you for your consideration.

Tomas M
slax.org



Ken Chen wrote:
> On 3/31/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>> > Yes, the distros do, and they recommend it to their users a lot.
>>
>> Thanks.  In that case I think we should retain the max_loop module 
>> parameter
>> for now.
>>
>> Ken, when you respin that patch could you restore max_loop, and make its
>> use trigger a warning along the lines of "loop: the max_loop option is 
>> obsolete
>> and will be removed in March 2008"?
> 
> OK, here is a re-spin patch that I tested as module or
> link-in-vmlinux.  Both produce satisfactory result for me.  I also
> enclosed the patch as an attachment just in case my email client
> decide to eat away white spaces for the in-line text.
> 
> ------------------------------------------------------
> Subject: remove artificial software max_loop limit
> From: "Ken Chen" <kenchen@google.com>
> 
> Remove artificial maximum 256 loop device that can be created due to a
> legacy device number limit.  Searching through lkml archive, there are
> several instances where users complained about the artificial limit
> that the loop driver impose.  There is no reason to have such limit.
> 
> This patch rid the limit entirely and make loop device and associated
> block queue instantiation on demand.  With on-demand instantiation, it
> also gives the benefit of not wasting memory if these devices are not
> in use (compare to current implementation that always create 8 loop
> devices), a net improvement in both areas.  This version is both
> tested with creation of large number of loop devices and is compatible
> with existing losetup/mount user land tools.
> 
> There are a number of people who worked on this and provided valuable
> suggestions, in no particular order, by:
> 
> Jens Axboe
> Jan Engelhardt
> Christoph Hellwig
> Thomas M
> 
> Signed-off-by: Ken Chen <kenchen@google.com>
> Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>
> Cc: Christoph Hellwig <hch@lst.de>
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 6b5b642..605c1d3 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -77,9 +77,8 @@
> 
> #include <asm/uaccess.h>
> 
> -static int max_loop = 8;
> -static struct loop_device *loop_dev;
> -static struct gendisk **disks;
> +static LIST_HEAD(loop_devices);
> +static DEFINE_MUTEX(loop_devices_mutex);
> 
> /*
>  * Transfer functions
> @@ -183,7 +182,7 @@ figure_loop_size(struct loop_device *lo)
>     if (unlikely((loff_t)x != size))
>         return -EFBIG;
> 
> -    set_capacity(disks[lo->lo_number], x);
> +    set_capacity(lo->lo_disk, x);
>     return 0;                   
> }
> 
> @@ -812,7 +811,7 @@ static int loop_set_fd
>     lo->lo_queue->queuedata = lo;
>     lo->lo_queue->unplug_fn = loop_unplug;
> 
> -    set_capacity(disks[lo->lo_number], size);
> +    set_capacity(lo->lo_disk, size);
>     bd_set_size(bdev, size << 9);
> 
>     set_blocksize(bdev, lo_blocksize);
> @@ -832,7 +831,7 @@ out_clr:
>     lo->lo_device = NULL;
>     lo->lo_backing_file = NULL;
>     lo->lo_flags = 0;
> -    set_capacity(disks[lo->lo_number], 0);
> +    set_capacity(lo->lo_disk, 0);
>     invalidate_bdev(bdev, 0);
>     bd_set_size(bdev, 0);
>     mapping_set_gfp_mask(mapping, lo->old_gfp_mask);
> @@ -918,7 +917,7 @@ static int loop_clr_fd
>     memset(lo->lo_crypt_name, 0, LO_NAME_SIZE);
>     memset(lo->lo_file_name, 0, LO_NAME_SIZE);
>     invalidate_bdev(bdev, 0);
> -    set_capacity(disks[lo->lo_number], 0);
> +    set_capacity(lo->lo_disk, 0);
>     bd_set_size(bdev, 0);
>     mapping_set_gfp_mask(filp->f_mapping, gfp);
>     lo->lo_state = Lo_unbound;
> @@ -1322,6 +1321,18 @@ static long lo_compat_ioctl
> }
> #endif
> 
> +static struct loop_device *loop_find_dev(int number)
> +{
> +    struct loop_device *lo;
> +
> +    list_for_each_entry(lo, &loop_devices, lo_list) {
> +        if (lo->lo_number == number)
> +            return lo;
> +    }
> +    return NULL;
> +}
> +
> +static struct loop_device *loop_init_one(int i);
> static int lo_open(struct inode *inode, struct file *file)
> {
>     struct loop_device *lo = inode->i_bdev->bd_disk->private_data;
> @@ -1330,6 +1341,11 @@ static int lo_open
>     lo->lo_refcnt++;
>     mutex_unlock(&lo->lo_ctl_mutex);
> 
> +    mutex_lock(&loop_devices_mutex);
> +    if (!loop_find_dev(lo->lo_number + 1))
> +        loop_init_one(lo->lo_number + 1);
> +    mutex_unlock(&loop_devices_mutex);
> +
>     return 0;
> }
> 
> @@ -1357,8 +1373,9 @@ static struct block_device_operations lo_fops = {
> /*
>  * And now the modules code and kernel interface.
>  */
> +static int max_loop;
> module_param(max_loop, int, 0);
> -MODULE_PARM_DESC(max_loop, "Maximum number of loop devices (1-256)");
> +MODULE_PARM_DESC(max_loop, "obsolete, loop device is created on-demand");
> MODULE_LICENSE("GPL");
> MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);
> 
> @@ -1383,7 +1400,7 @@ int loop_unregister_transfer(int number)
> 
>     xfer_funcs[n] = NULL;
> 
> -    for (lo = &loop_dev[0]; lo < &loop_dev[max_loop]; lo++) {
> +    list_for_each_entry(lo, &loop_devices, lo_list) {
>         mutex_lock(&lo->lo_ctl_mutex);
> 
>         if (lo->lo_encryption == xfer)
> @@ -1398,91 +1415,110 @@ int loop_unregister_transfer(int number)
> EXPORT_SYMBOL(loop_register_transfer);
> EXPORT_SYMBOL(loop_unregister_transfer);
> 
> -static int __init loop_init(void)
> +static struct loop_device *loop_init_one(int i)
> +{
> +    struct loop_device *lo;
> +    struct gendisk *disk;
> +
> +    lo = kzalloc(sizeof(*lo), GFP_KERNEL);
> +    if (!lo)
> +        goto out;
> +
> +    lo->lo_queue = blk_alloc_queue(GFP_KERNEL);
> +    if (!lo->lo_queue)
> +        goto out_free_dev;
> +
> +    disk = lo->lo_disk = alloc_disk(1);
> +    if (!disk)
> +        goto out_free_queue;
> +
> +    mutex_init(&lo->lo_ctl_mutex);
> +    lo->lo_number        = i;
> +    lo->lo_thread        = NULL;
> +    init_waitqueue_head(&lo->lo_event);
> +    spin_lock_init(&lo->lo_lock);
> +    disk->major        = LOOP_MAJOR;
> +    disk->first_minor    = i;
> +    disk->fops        = &lo_fops;
> +    disk->private_data    = lo;
> +    disk->queue        = lo->lo_queue;
> +    sprintf(disk->disk_name, "loop%d", i);
> +    add_disk(disk);
> +    list_add_tail(&lo->lo_list, &loop_devices);
> +    return lo;
> +
> +out_free_queue:
> +    blk_cleanup_queue(lo->lo_queue);
> +out_free_dev:
> +    kfree(lo);
> +out:
> +    return ERR_PTR(-ENOMEM);
> +}
> +
> +static void loop_del_one(struct loop_device *lo)
> {
> -    int    i;
> +    del_gendisk(lo->lo_disk);
> +    blk_cleanup_queue(lo->lo_queue);
> +    put_disk(lo->lo_disk);
> +    list_del(&lo->lo_list);
> +    kfree(lo);
> +}
> 
> -    if (max_loop < 1 || max_loop > 256) {
> -        printk(KERN_WARNING "loop: invalid max_loop (must be between"
> -                    " 1 and 256), using default (8)\n");
> -        max_loop = 8;
> -    }
> +static struct kobject *loop_probe(dev_t dev, int *part, void *data)
> +{
> +    unsigned int number = dev & MINORMASK;
> +    struct loop_device *lo;
> +
> +    mutex_lock(&loop_devices_mutex);
> +    lo = loop_find_dev(number);
> +    if (lo == NULL)
> +        lo = loop_init_one(number);
> +    mutex_unlock(&loop_devices_mutex);
> +
> +    *part = 0;
> +    if (IS_ERR(lo))
> +        return (void *)lo;
> +    else
> +        return &lo->lo_disk->kobj;
> +}
> +
> +static int __init loop_init(void)
> +{
> +    struct loop_device *lo;
> 
>     if (register_blkdev(LOOP_MAJOR, "loop"))
>         return -EIO;
> +    blk_register_region(MKDEV(LOOP_MAJOR, 0), 1UL << MINORBITS,
> +                  THIS_MODULE, loop_probe, NULL, NULL);
> 
> -    loop_dev = kmalloc(max_loop * sizeof(struct loop_device), GFP_KERNEL);
> -    if (!loop_dev)
> -        goto out_mem1;
> -    memset(loop_dev, 0, max_loop * sizeof(struct loop_device));
> +    lo = loop_init_one(0);
> +    if (IS_ERR(lo))
> +        goto out;
> 
> -    disks = kmalloc(max_loop * sizeof(struct gendisk *), GFP_KERNEL);
> -    if (!disks)
> -        goto out_mem2;
> +    if (max_loop) {
> +        printk(KERN_INFO "loop: the max_loop option is obsolete "
> +                 "and will be removed in March 2008\n");
> 
> -    for (i = 0; i < max_loop; i++) {
> -        disks[i] = alloc_disk(1);
> -        if (!disks[i])
> -            goto out_mem3;
>     }
> -
> -    for (i = 0; i < max_loop; i++) {
> -        struct loop_device *lo = &loop_dev[i];
> -        struct gendisk *disk = disks[i];
> -
> -        memset(lo, 0, sizeof(*lo));
> -        lo->lo_queue = blk_alloc_queue(GFP_KERNEL);
> -        if (!lo->lo_queue)
> -            goto out_mem4;
> -        mutex_init(&lo->lo_ctl_mutex);
> -        lo->lo_number = i;
> -        lo->lo_thread = NULL;
> -        init_waitqueue_head(&lo->lo_event);
> -        spin_lock_init(&lo->lo_lock);
> -        disk->major = LOOP_MAJOR;
> -        disk->first_minor = i;
> -        disk->fops = &lo_fops;
> -        sprintf(disk->disk_name, "loop%d", i);
> -        disk->private_data = lo;
> -        disk->queue = lo->lo_queue;
> -    }
> -
> -    /* We cannot fail after we call this, so another loop!*/
> -    for (i = 0; i < max_loop; i++)
> -        add_disk(disks[i]);
> -    printk(KERN_INFO "loop: loaded (max %d devices)\n", max_loop);
> +    printk(KERN_INFO "loop: module loaded\n");
>     return 0;
> 
> -out_mem4:
> -    while (i--)
> -        blk_cleanup_queue(loop_dev[i].lo_queue);
> -    i = max_loop;
> -out_mem3:
> -    while (i--)
> -        put_disk(disks[i]);
> -    kfree(disks);
> -out_mem2:
> -    kfree(loop_dev);
> -out_mem1:
> +out:
>     unregister_blkdev(LOOP_MAJOR, "loop");
>     printk(KERN_ERR "loop: ran out of memory\n");
>     return -ENOMEM;
> }
> 
> -static void loop_exit(void)
> +static void __exit loop_exit(void)
> {
> -    int i;
> +    struct loop_device *lo, *next;
> 
> -    for (i = 0; i < max_loop; i++) {
> -        del_gendisk(disks[i]);
> -        blk_cleanup_queue(loop_dev[i].lo_queue);
> -        put_disk(disks[i]);
> -    }
> +    list_for_each_entry_safe(lo, next, &loop_devices, lo_list)
> +        loop_del_one(lo);
> +
> +    blk_unregister_region(MKDEV(LOOP_MAJOR, 0), 1UL << MINORBITS);
>     if (unregister_blkdev(LOOP_MAJOR, "loop"))
>         printk(KERN_WARNING "loop: cannot unregister blkdev\n");
> -
> -    kfree(disks);
> -    kfree(loop_dev);
> }
> 
> module_init(loop_init);
> diff --git a/include/linux/loop.h b/include/linux/loop.h
> index 191a595..0b99b31 100644
> --- a/include/linux/loop.h
> +++ b/include/linux/loop.h
> @@ -64,6 +64,8 @@ struct loop_device {
>     wait_queue_head_t    lo_event;
> 
>     request_queue_t        *lo_queue;
> +    struct gendisk        *lo_disk;
> +    struct list_head    lo_list;
> };
> 
> #endif /* __KERNEL__ */
> 
> 
> ------------------------------------------------------------------------
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 6b5b642..605c1d3 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -77,9 +77,8 @@
>  
>  #include <asm/uaccess.h>
>  
> -static int max_loop = 8;
> -static struct loop_device *loop_dev;
> -static struct gendisk **disks;
> +static LIST_HEAD(loop_devices);
> +static DEFINE_MUTEX(loop_devices_mutex);
>  
>  /*
>   * Transfer functions
> @@ -183,7 +182,7 @@ figure_loop_size(struct loop_device *lo)
>  	if (unlikely((loff_t)x != size))
>  		return -EFBIG;
>  
> -	set_capacity(disks[lo->lo_number], x);
> +	set_capacity(lo->lo_disk, x);
>  	return 0;					
>  }
>  
> @@ -812,7 +811,7 @@ static int loop_set_fd
>  	lo->lo_queue->queuedata = lo;
>  	lo->lo_queue->unplug_fn = loop_unplug;
>  
> -	set_capacity(disks[lo->lo_number], size);
> +	set_capacity(lo->lo_disk, size);
>  	bd_set_size(bdev, size << 9);
>  
>  	set_blocksize(bdev, lo_blocksize);
> @@ -832,7 +831,7 @@ out_clr:
>  	lo->lo_device = NULL;
>  	lo->lo_backing_file = NULL;
>  	lo->lo_flags = 0;
> -	set_capacity(disks[lo->lo_number], 0);
> +	set_capacity(lo->lo_disk, 0);
>  	invalidate_bdev(bdev, 0);
>  	bd_set_size(bdev, 0);
>  	mapping_set_gfp_mask(mapping, lo->old_gfp_mask);
> @@ -918,7 +917,7 @@ static int loop_clr_fd
>  	memset(lo->lo_crypt_name, 0, LO_NAME_SIZE);
>  	memset(lo->lo_file_name, 0, LO_NAME_SIZE);
>  	invalidate_bdev(bdev, 0);
> -	set_capacity(disks[lo->lo_number], 0);
> +	set_capacity(lo->lo_disk, 0);
>  	bd_set_size(bdev, 0);
>  	mapping_set_gfp_mask(filp->f_mapping, gfp);
>  	lo->lo_state = Lo_unbound;
> @@ -1322,6 +1321,18 @@ static long lo_compat_ioctl
>  }
>  #endif
>  
> +static struct loop_device *loop_find_dev(int number)
> +{
> +	struct loop_device *lo;
> +
> +	list_for_each_entry(lo, &loop_devices, lo_list) {
> +		if (lo->lo_number == number)
> +			return lo;
> +	}
> +	return NULL;
> +}
> +
> +static struct loop_device *loop_init_one(int i);
>  static int lo_open(struct inode *inode, struct file *file)
>  {
>  	struct loop_device *lo = inode->i_bdev->bd_disk->private_data;
> @@ -1330,6 +1341,11 @@ static int lo_open
>  	lo->lo_refcnt++;
>  	mutex_unlock(&lo->lo_ctl_mutex);
>  
> +	mutex_lock(&loop_devices_mutex);
> +	if (!loop_find_dev(lo->lo_number + 1))
> +		loop_init_one(lo->lo_number + 1);
> +	mutex_unlock(&loop_devices_mutex);
> +
>  	return 0;
>  }
>  
> @@ -1357,8 +1373,9 @@ static struct block_device_operations lo_fops = {
>  /*
>   * And now the modules code and kernel interface.
>   */
> +static int max_loop;
>  module_param(max_loop, int, 0);
> -MODULE_PARM_DESC(max_loop, "Maximum number of loop devices (1-256)");
> +MODULE_PARM_DESC(max_loop, "obsolete, loop device is created on-demand");
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);
>  
> @@ -1383,7 +1400,7 @@ int loop_unregister_transfer(int number)
>  
>  	xfer_funcs[n] = NULL;
>  
> -	for (lo = &loop_dev[0]; lo < &loop_dev[max_loop]; lo++) {
> +	list_for_each_entry(lo, &loop_devices, lo_list) {
>  		mutex_lock(&lo->lo_ctl_mutex);
>  
>  		if (lo->lo_encryption == xfer)
> @@ -1398,91 +1415,110 @@ int loop_unregister_transfer(int number)
>  EXPORT_SYMBOL(loop_register_transfer);
>  EXPORT_SYMBOL(loop_unregister_transfer);
>  
> -static int __init loop_init(void)
> +static struct loop_device *loop_init_one(int i)
> +{
> +	struct loop_device *lo;
> +	struct gendisk *disk;
> +
> +	lo = kzalloc(sizeof(*lo), GFP_KERNEL);
> +	if (!lo)
> +		goto out;
> +
> +	lo->lo_queue = blk_alloc_queue(GFP_KERNEL);
> +	if (!lo->lo_queue)
> +		goto out_free_dev;
> +
> +	disk = lo->lo_disk = alloc_disk(1);
> +	if (!disk)
> +		goto out_free_queue;
> +
> +	mutex_init(&lo->lo_ctl_mutex);
> +	lo->lo_number		= i;
> +	lo->lo_thread		= NULL;
> +	init_waitqueue_head(&lo->lo_event);
> +	spin_lock_init(&lo->lo_lock);
> +	disk->major		= LOOP_MAJOR;
> +	disk->first_minor	= i;
> +	disk->fops		= &lo_fops;
> +	disk->private_data	= lo;
> +	disk->queue		= lo->lo_queue;
> +	sprintf(disk->disk_name, "loop%d", i);
> +	add_disk(disk);
> +	list_add_tail(&lo->lo_list, &loop_devices);
> +	return lo;
> +
> +out_free_queue:
> +	blk_cleanup_queue(lo->lo_queue);
> +out_free_dev:
> +	kfree(lo);
> +out:
> +	return ERR_PTR(-ENOMEM);
> +}
> +
> +static void loop_del_one(struct loop_device *lo)
>  {
> -	int	i;
> +	del_gendisk(lo->lo_disk);
> +	blk_cleanup_queue(lo->lo_queue);
> +	put_disk(lo->lo_disk);
> +	list_del(&lo->lo_list);
> +	kfree(lo);
> +}
>  
> -	if (max_loop < 1 || max_loop > 256) {
> -		printk(KERN_WARNING "loop: invalid max_loop (must be between"
> -				    " 1 and 256), using default (8)\n");
> -		max_loop = 8;
> -	}
> +static struct kobject *loop_probe(dev_t dev, int *part, void *data)
> +{
> +	unsigned int number = dev & MINORMASK;
> +	struct loop_device *lo;
> +
> +	mutex_lock(&loop_devices_mutex);
> +	lo = loop_find_dev(number);
> +	if (lo == NULL)
> +		lo = loop_init_one(number);
> +	mutex_unlock(&loop_devices_mutex);
> +
> +	*part = 0;
> +	if (IS_ERR(lo))
> +		return (void *)lo;
> +	else
> +		return &lo->lo_disk->kobj;
> +}
> +
> +static int __init loop_init(void)
> +{
> +	struct loop_device *lo;
>  
>  	if (register_blkdev(LOOP_MAJOR, "loop"))
>  		return -EIO;
> +	blk_register_region(MKDEV(LOOP_MAJOR, 0), 1UL << MINORBITS,
> +				  THIS_MODULE, loop_probe, NULL, NULL);
>  
> -	loop_dev = kmalloc(max_loop * sizeof(struct loop_device), GFP_KERNEL);
> -	if (!loop_dev)
> -		goto out_mem1;
> -	memset(loop_dev, 0, max_loop * sizeof(struct loop_device));
> +	lo = loop_init_one(0);
> +	if (IS_ERR(lo))
> +		goto out;
>  
> -	disks = kmalloc(max_loop * sizeof(struct gendisk *), GFP_KERNEL);
> -	if (!disks)
> -		goto out_mem2;
> +	if (max_loop) {
> +		printk(KERN_INFO "loop: the max_loop option is obsolete "
> +				 "and will be removed in March 2008\n");
>  
> -	for (i = 0; i < max_loop; i++) {
> -		disks[i] = alloc_disk(1);
> -		if (!disks[i])
> -			goto out_mem3;
>  	}
> -
> -	for (i = 0; i < max_loop; i++) {
> -		struct loop_device *lo = &loop_dev[i];
> -		struct gendisk *disk = disks[i];
> -
> -		memset(lo, 0, sizeof(*lo));
> -		lo->lo_queue = blk_alloc_queue(GFP_KERNEL);
> -		if (!lo->lo_queue)
> -			goto out_mem4;
> -		mutex_init(&lo->lo_ctl_mutex);
> -		lo->lo_number = i;
> -		lo->lo_thread = NULL;
> -		init_waitqueue_head(&lo->lo_event);
> -		spin_lock_init(&lo->lo_lock);
> -		disk->major = LOOP_MAJOR;
> -		disk->first_minor = i;
> -		disk->fops = &lo_fops;
> -		sprintf(disk->disk_name, "loop%d", i);
> -		disk->private_data = lo;
> -		disk->queue = lo->lo_queue;
> -	}
> -
> -	/* We cannot fail after we call this, so another loop!*/
> -	for (i = 0; i < max_loop; i++)
> -		add_disk(disks[i]);
> -	printk(KERN_INFO "loop: loaded (max %d devices)\n", max_loop);
> +	printk(KERN_INFO "loop: module loaded\n");
>  	return 0;
>  
> -out_mem4:
> -	while (i--)
> -		blk_cleanup_queue(loop_dev[i].lo_queue);
> -	i = max_loop;
> -out_mem3:
> -	while (i--)
> -		put_disk(disks[i]);
> -	kfree(disks);
> -out_mem2:
> -	kfree(loop_dev);
> -out_mem1:
> +out:
>  	unregister_blkdev(LOOP_MAJOR, "loop");
>  	printk(KERN_ERR "loop: ran out of memory\n");
>  	return -ENOMEM;
>  }
>  
> -static void loop_exit(void)
> +static void __exit loop_exit(void)
>  {
> -	int i;
> +	struct loop_device *lo, *next;
>  
> -	for (i = 0; i < max_loop; i++) {
> -		del_gendisk(disks[i]);
> -		blk_cleanup_queue(loop_dev[i].lo_queue);
> -		put_disk(disks[i]);
> -	}
> +	list_for_each_entry_safe(lo, next, &loop_devices, lo_list)
> +		loop_del_one(lo);
> +
> +	blk_unregister_region(MKDEV(LOOP_MAJOR, 0), 1UL << MINORBITS);
>  	if (unregister_blkdev(LOOP_MAJOR, "loop"))
>  		printk(KERN_WARNING "loop: cannot unregister blkdev\n");
> -
> -	kfree(disks);
> -	kfree(loop_dev);
>  }
>  
>  module_init(loop_init);
> diff --git a/include/linux/loop.h b/include/linux/loop.h
> index 191a595..0b99b31 100644
> --- a/include/linux/loop.h
> +++ b/include/linux/loop.h
> @@ -64,6 +64,8 @@ struct loop_device {
>  	wait_queue_head_t	lo_event;
>  
>  	request_queue_t		*lo_queue;
> +	struct gendisk		*lo_disk;
> +	struct list_head	lo_list;
>  };
>  
>  #endif /* __KERNEL__ */

