Return-Path: <linux-kernel-owner+w=401wt.eu-S1763945AbXESTSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763945AbXESTSR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 15:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbXESTSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 15:18:09 -0400
Received: from muan.mtu.ru ([195.34.34.229]:1317 "EHLO muan.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912AbXESTSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 15:18:08 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
To: Ray Lee <ray-lk@madrabbit.org>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, uwe.bugla@gmx.de,
       Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 19 May 2007 23:17:50 +0400
References: <464F42F3.1080300@madrabbit.org>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20070519191751.E51233A23A2@muan.mtu.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:

> Hey there,
> 
> On 5/19/07, Uwe Bugla <uwe.bugla@gmx.de> wrote:
>  > I am running Debian Etch 4.0 stable in connection with udev.
>  >
>  > In kernel 2.6.22-rc2 the number of available loop mounts is reduced
>  > from 8 (conventional standard of preceding 2.6 kernels) to 1.
>  >
>  > Symptom: If you try to mount more than one single iso-image with
>  > the loop parameter you are receiving the following message during
>  > system boot:
>  >
>  > "mount: could not find any free loop device"
>  >
>  > Kernel 2.6.20.11 does not show that problem.
>  >
>  > Question: Can someone reading this confirm and reproduce that problem?
> 
> I can reproduce the problem pretty trivially with:
> 
> mkdir a m1 m2
> touch a/1
> genisoimage -o cd1.iso a || mkisofs -o cd1.iso a
> cp cd1.iso cd2.iso
> sudo mount -o loop cd1.iso m1
> sudo mount -o loop cd2.iso m2
> 
> ...and the last mount fails. That used to work, at least as of 2.6.15,
> which is the only other 2.6 kernel I have running on a machine that I can
> log into at the moment.
> 


This is unfortunate case of user-space breakage.

Now when we do not have specific loop device limit, we also do not
pre-register loop devices:

{pts/0}% LC_ALL=C ll /dev/loop*
brw-rw---- 1 root disk 7, 0 May 19 20:33 /dev/loop0

(I wonder where loop0 comes from at all :) but losetup & Co unfortunately
need preexisting device node :(

Trivial workaround for those who need it now - wrapper that creates node and
calls real losetup. I am not sure this actually works with loop mount
though.

Real fix is to add special control node and change losetup to use it instead
(or in addition) to opening /dev/loop%d. But as it stands now I'd call it
big regression. 

-andrey

> Looking at the changelogs between 2.6.20 and current tip shows at least
> three significant patches to loop.c. The first was supposedly tested
> heavily, so we'll leave that alone for now. (They all were applied after
> 2.6.21 was released, so it's probably fine.)
> 
> Anyway, could you try reverting the two patches below (in order: the
> first, then the second) and see if that fixes it? The second one looks
> iffy to me, but if this fixes it then I'm sure Al can sort out why.
> 
> Ray
> 
> 
> 
> commit 705962ccc9d21a08b74b6b6e1d3cf10f98968a67
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Sun May 13 05:52:32 2007 -0400
> 
>      fix deadlock in loop.c
> 
>      ... doh
> 
>      Jeremy Fitzhardinge noted that the recent loop.c cleanups worked, but
>      cause lockdep to complain.
> 
>      Ouch.  OK, the deadlock is real and yes, I'm an idiot.  Speaking of
>      which, we probably want to s/lock/pin/ in drivers/base/map.c to avoid
>      such
>      brainos again.  And yes, this stuff needs clear documentation.  Will
>      try to put one together once I get some sleep...
> 
>      Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>      Cc: Jeremy Fitzhardinge <jeremy@goop.org>
>      Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index e2fc4b6..5526ead 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -1399,6 +1399,11 @@ static struct loop_device *loop_init_one(int i)
>   struct loop_device *lo;
>   struct gendisk *disk;
> 
> +     list_for_each_entry(lo, &loop_devices, lo_list) {
> +             if (lo->lo_number == i)
> +                     return lo;
> +     }
> +
>   lo = kzalloc(sizeof(*lo), GFP_KERNEL);
>   if (!lo)
>   goto out;
> @@ -1443,17 +1448,13 @@ static void loop_del_one(struct loop_device *lo)
>   kfree(lo);
>   }
> 
> -static int loop_lock(dev_t dev, void *data)
> -{
> -     mutex_lock(&loop_devices_mutex);
> -     return 0;
> -}
> -
>   static struct kobject *loop_probe(dev_t dev, int *part, void *data)
>   {
> -     struct loop_device *lo = loop_init_one(dev & MINORMASK);
> +     struct loop_device *lo;
>   struct kobject *kobj;
> 
> +     mutex_lock(&loop_devices_mutex);
> +     lo = loop_init_one(dev & MINORMASK);
>   kobj = lo ? get_disk(lo->lo_disk) : ERR_PTR(-ENOMEM);
>   mutex_unlock(&loop_devices_mutex);
> 
> @@ -1466,7 +1467,7 @@ static int __init loop_init(void)
>   if (register_blkdev(LOOP_MAJOR, "loop"))
>   return -EIO;
>   blk_register_region(MKDEV(LOOP_MAJOR, 0), 1UL << MINORBITS,
> -                               THIS_MODULE, loop_probe, loop_lock, NULL);
> +                               THIS_MODULE, loop_probe, NULL, NULL);
> 
>   if (max_loop) {
>   printk(KERN_INFO "loop: the max_loop option is obsolete "
> 
> 
> 
> 
> 
> commit 07002e995638b83a6987180f43722a0eb39d4932
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Sat May 12 16:23:15 2007 -0400
> 
>      fix the dynamic allocation and probe in loop.c
> 
>      Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>      Acked-by: Ken Chen <kenchen@google.com>
>      Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 18cdd8c..e2fc4b6 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -1317,18 +1317,6 @@ static long lo_compat_ioctl(struct file *file,
> unsigned int cmd, unsigned long a
>   }
>   #endif
> 
> -static struct loop_device *loop_find_dev(int number)
> -{
> -     struct loop_device *lo;
> -
> -     list_for_each_entry(lo, &loop_devices, lo_list) {
> -             if (lo->lo_number == number)
> -                     return lo;
> -     }
> -     return NULL;
> -}
> -
> -static struct loop_device *loop_init_one(int i);
>   static int lo_open(struct inode *inode, struct file *file)
>   {
>   struct loop_device *lo = inode->i_bdev->bd_disk->private_data;
> @@ -1337,11 +1325,6 @@ static int lo_open(struct inode *inode, struct file
> *file)
>   lo->lo_refcnt++;
>   mutex_unlock(&lo->lo_ctl_mutex);
> 
> -     mutex_lock(&loop_devices_mutex);
> -     if (!loop_find_dev(lo->lo_number + 1))
> -             loop_init_one(lo->lo_number + 1);
> -     mutex_unlock(&loop_devices_mutex);
> -
>   return 0;
>   }
> 
> @@ -1448,7 +1431,7 @@ out_free_queue:
>   out_free_dev:
>   kfree(lo);
>   out:
> -     return ERR_PTR(-ENOMEM);
> +     return NULL;
>   }
> 
>   static void loop_del_one(struct loop_device *lo)
> @@ -1460,36 +1443,30 @@ static void loop_del_one(struct loop_device *lo)
>   kfree(lo);
>   }
> 
> +static int loop_lock(dev_t dev, void *data)
> +{
> +     mutex_lock(&loop_devices_mutex);
> +     return 0;
> +}
> +
>   static struct kobject *loop_probe(dev_t dev, int *part, void *data)
>   {
> -     unsigned int number = dev & MINORMASK;
> -     struct loop_device *lo;
> +     struct loop_device *lo = loop_init_one(dev & MINORMASK);
> +     struct kobject *kobj;
> 
> -     mutex_lock(&loop_devices_mutex);
> -     lo = loop_find_dev(number);
> -     if (lo == NULL)
> -             lo = loop_init_one(number);
> +     kobj = lo ? get_disk(lo->lo_disk) : ERR_PTR(-ENOMEM);
>   mutex_unlock(&loop_devices_mutex);
> 
>   *part = 0;
> -     if (IS_ERR(lo))
> -             return (void *)lo;
> -     else
> -             return &lo->lo_disk->kobj;
> +     return kobj;
>   }
> 
>   static int __init loop_init(void)
>   {
> -     struct loop_device *lo;
> -
>   if (register_blkdev(LOOP_MAJOR, "loop"))
>   return -EIO;
>   blk_register_region(MKDEV(LOOP_MAJOR, 0), 1UL << MINORBITS,
> -                               THIS_MODULE, loop_probe, NULL, NULL);
> -
> -     lo = loop_init_one(0);
> -     if (IS_ERR(lo))
> -             goto out;
> +                               THIS_MODULE, loop_probe, loop_lock, NULL);
> 
>   if (max_loop) {
>   printk(KERN_INFO "loop: the max_loop option is obsolete "
> @@ -1498,11 +1475,6 @@ static int __init loop_init(void)
>   }
>   printk(KERN_INFO "loop: module loaded\n");
>   return 0;
> -
> -out:
> -     unregister_blkdev(LOOP_MAJOR, "loop");
> -     printk(KERN_ERR "loop: ran out of memory\n");
> -     return -ENOMEM;
>   }
> 
>   static void __exit loop_exit(void)


