Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbXEaQGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbXEaQGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 12:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbXEaQGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 12:06:40 -0400
Received: from main.gmane.org ([80.91.229.2]:44118 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbXEaQGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 12:06:39 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <wa1ter@myrealbox.com>
Subject: Re: + loop-preallocate-eight-loop-devices.patch added to -mm tree
Date: Thu, 31 May 2007 09:05:16 -0700
Organization: none
Message-ID: <f3mro0$u8p$1@sea.gmane.org>
References: <200705212200.l4LM0tYK021050@shell0.pdx.osdl.net>	 <20070522001851.GE4095@ftp.linux.org.uk>	 <b040c32a0705211830h127dfd8dk8930de6655d37d90@mail.gmail.com>	 <20070522014822.GF4095@ftp.linux.org.uk>	 <b040c32a0705211914w3843bd46o542476be97e0b6cf@mail.gmail.com> <b040c32a0705211940xe7cdf1cnb2c882edacc17a27@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-201-154.dsl.irvnca.pacbell.net
User-Agent: Thunderbird 3.0a1pre (X11/20070531)
In-Reply-To: <b040c32a0705211940xe7cdf1cnb2c882edacc17a27@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ken Chen wrote:
> On 5/21/07, Ken Chen <kenchen@google.com> wrote:
...
> tested, like this?

Ken, your patch below works for me.  Are you going to send this
on to Linus?

> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 5526ead..0ed5470 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -1354,7 +1354,7 @@ #endif
>  */
> static int max_loop;
> module_param(max_loop, int, 0);
> -MODULE_PARM_DESC(max_loop, "obsolete, loop device is created on-demand");
> +MODULE_PARM_DESC(max_loop, "Maximum number of loop devices");
> MODULE_LICENSE("GPL");
> MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);
> 
> @@ -1394,16 +1394,11 @@ int loop_unregister_transfer
> EXPORT_SYMBOL(loop_register_transfer);
> EXPORT_SYMBOL(loop_unregister_transfer);
> 
> -static struct loop_device *loop_init_one(int i)
> +static struct loop_device *loop_alloc(int i)
> {
>     struct loop_device *lo;
>     struct gendisk *disk;
> 
> -    list_for_each_entry(lo, &loop_devices, lo_list) {
> -        if (lo->lo_number == i)
> -            return lo;
> -    }
> -
>     lo = kzalloc(sizeof(*lo), GFP_KERNEL);
>     if (!lo)
>         goto out;
> @@ -1427,8 +1422,6 @@ static struct loop_device *loop_init_one
>     disk->private_data    = lo;
>     disk->queue        = lo->lo_queue;
>     sprintf(disk->disk_name, "loop%d", i);
> -    add_disk(disk);
> -    list_add_tail(&lo->lo_list, &loop_devices);
>     return lo;
> 
> out_free_queue:
> @@ -1439,15 +1432,37 @@ out:
>     return NULL;
> }
> 
> -static void loop_del_one(struct loop_device *lo)
> +static void loop_free(struct loop_device *lo)
> {
> -    del_gendisk(lo->lo_disk);
>     blk_cleanup_queue(lo->lo_queue);
>     put_disk(lo->lo_disk);
>     list_del(&lo->lo_list);
>     kfree(lo);
> }
> 
> +static struct loop_device *loop_init_one(int i)
> +{
> +    struct loop_device *lo;
> +
> +    list_for_each_entry(lo, &loop_devices, lo_list) {
> +        if (lo->lo_number == i)
> +            return lo;
> +    }
> +
> +    lo = loop_alloc(i);
> +    if (lo) {
> +        add_disk(lo->lo_disk);
> +        list_add_tail(&lo->lo_list, &loop_devices);
> +    }
> +    return lo;
> +}
> +
> +static void loop_del_one(struct loop_device *lo)
> +{
> +    del_gendisk(lo->lo_disk);
> +    loop_free(lo);
> +}
> +
> static struct kobject *loop_probe(dev_t dev, int *part, void *data)
> {
>     struct loop_device *lo;
> @@ -1464,28 +1479,77 @@ static struct kobject *loop_probe
> 
> static int __init loop_init(void)
> {
> -    if (register_blkdev(LOOP_MAJOR, "loop"))
> -        return -EIO;
> -    blk_register_region(MKDEV(LOOP_MAJOR, 0), 1UL << MINORBITS,
> -                  THIS_MODULE, loop_probe, NULL, NULL);
> +    int i, nr;
> +    unsigned long range;
> +    struct loop_device *lo, *next;
> +
> +    /*
> +     * loop module now has a feature to instantiate underlying device
> +     * structure on-demand, provided that there is an access dev node.
> +     * However, this will not work well with user space tool that doesn't
> +     * know about such "feature".  In order to not break any existing
> +     * tool, we do the following:
> +     *
> +     * (1) if max_loop is specified, create that many upfront, and this
> +     *     also becomes a hard limit.
> +     * (2) if max_loop is not specified, create 8 loop device on module
> +     *     load, user can further extend loop device by create dev node
> +     *     themselves and have kernel automatically instantiate actual
> +     *     device on-demand.
> +     */
> +    if (max_loop > 1UL << MINORBITS)
> +        return -EINVAL;
> 
>     if (max_loop) {
> -        printk(KERN_INFO "loop: the max_loop option is obsolete "
> -                 "and will be removed in March 2008\n");
> +        nr = max_loop;
> +        range = max_loop;
> +    } else {
> +        nr = 8;
> +        range = 1UL << MINORBITS;
> +    }
> +
> +    if (register_blkdev(LOOP_MAJOR, "loop"))
> +        return -EIO;
> 
> +    for (i = 0; i < nr; i++) {
> +        lo = loop_alloc(i);
> +        if (!lo)
> +            goto Enomem;
> +        list_add_tail(&lo->lo_list, &loop_devices);
>     }
> +
> +    /* point of no return */
> +
> +    list_for_each_entry(lo, &loop_devices, lo_list)
> +        add_disk(lo->lo_disk);
> +
> +    blk_register_region(MKDEV(LOOP_MAJOR, 0), range,
> +                  THIS_MODULE, loop_probe, NULL, NULL);
> +
>     printk(KERN_INFO "loop: module loaded\n");
>     return 0;
> +
> +Enomem:
> +    printk(KERN_INFO "loop: out of memory\n");
> +
> +    list_for_each_entry_safe(lo, next, &loop_devices, lo_list)
> +        loop_free(lo);
> +
> +    unregister_blkdev(LOOP_MAJOR, "loop");
> +    return -ENOMEM;
> }
> 
> static void __exit loop_exit(void)
> {
> +    unsigned long range;
>     struct loop_device *lo, *next;
> 
> +    range = max_loop ? max_loop :  1UL << MINORBITS;
> +
>     list_for_each_entry_safe(lo, next, &loop_devices, lo_list)
>         loop_del_one(lo);
> 
> -    blk_unregister_region(MKDEV(LOOP_MAJOR, 0), 1UL << MINORBITS);
> +    blk_unregister_region(MKDEV(LOOP_MAJOR, 0), range);
>     if (unregister_blkdev(LOOP_MAJOR, "loop"))
>         printk(KERN_WARNING "loop: cannot unregister blkdev\n");
> }



