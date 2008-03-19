Return-Path: <linux-kernel-owner+w=401wt.eu-S938639AbYCSVrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938639AbYCSVrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932066AbYCSUSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:18:32 -0400
Received: from mail.tmr.com ([64.65.253.246]:43194 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766009AbYCSUSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:18:30 -0400
Message-ID: <47E17673.4040302@tmr.com>
Date: Wed, 19 Mar 2008 16:24:19 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: axboe@suse.de, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH][RESEND][v3] Modify loop device to be able to manage partitions
 of the disk image
References: <12058427603971-git-send-email-Laurent.Vivier@bull.net>
In-Reply-To: <12058427603971-git-send-email-Laurent.Vivier@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
> v3 is an updated version of v2, replacing a "%d" by a "%lu".
> 
> This patch allows to use loop device with partitionned disk image.
> 
How does this compare in overhead to using nbd?

> Original behavior of loop is not modified.
> 
> A new parameter is introduced to define how many partition we want to be
> able to manage per loop device. This parameter is "loop_max_part".
> 
> For instance, to manage 63 partitions / loop device, we will do:
> # modprobe loop loop_max_part=63
> # ls -l /dev/loop?
> brw-rw---- 1 root disk 7,   0 2008-03-05 14:55 /dev/loop0
> brw-rw---- 1 root disk 7,  64 2008-03-05 14:55 /dev/loop1
> brw-rw---- 1 root disk 7, 128 2008-03-05 14:55 /dev/loop2
> brw-rw---- 1 root disk 7, 192 2008-03-05 14:55 /dev/loop3
> brw-rw---- 1 root disk 7, 256 2008-03-05 14:55 /dev/loop4
> brw-rw---- 1 root disk 7, 320 2008-03-05 14:55 /dev/loop5
> brw-rw---- 1 root disk 7, 384 2008-03-05 14:55 /dev/loop6
> brw-rw---- 1 root disk 7, 448 2008-03-05 14:55 /dev/loop7
> 
> And to attach a raw partitionned disk image, the original losetup is used:
> 
> # losetup -f etch.img
> EXT3 FS on loop0p1, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> loop: module loaded
>  loop0: p1 p2 < p5 >
> # ls -l /dev/loop?*
> brw-rw---- 1 root disk 7,   0 2008-03-05 14:55 /dev/loop0
> brw-rw---- 1 root disk 7,   1 2008-03-05 14:57 /dev/loop0p1
> brw-rw---- 1 root disk 7,   2 2008-03-05 14:57 /dev/loop0p2
> brw-rw---- 1 root disk 7,   5 2008-03-05 14:57 /dev/loop0p5
> brw-rw---- 1 root disk 7,  64 2008-03-05 14:55 /dev/loop1
> brw-rw---- 1 root disk 7, 128 2008-03-05 14:55 /dev/loop2
> brw-rw---- 1 root disk 7, 192 2008-03-05 14:55 /dev/loop3
> brw-rw---- 1 root disk 7, 256 2008-03-05 14:55 /dev/loop4
> brw-rw---- 1 root disk 7, 320 2008-03-05 14:55 /dev/loop5
> brw-rw---- 1 root disk 7, 384 2008-03-05 14:55 /dev/loop6
> brw-rw---- 1 root disk 7, 448 2008-03-05 14:55 /dev/loop7
> # mount /dev/loop0p1 /mnt
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on loop0p1, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> # ls /mnt
> bench  cdrom  home        lib         mnt   root     srv  usr
> bin    dev    initrd      lost+found  opt   sbin     sys  var
> boot   etc    initrd.img  media       proc  selinux  tmp  vmlinuz
> # umount /mnt
> # losetup -d /dev/loop0
> 
> Of course, the same behavior can be done using kpartx on a loop device,
> but modifying loop avoids to stack several layers of block device (loop +
> device mapper), this is a very light modification (40% of modifications
> are to manage the new parameter).
> 
> Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
> ---
>  Documentation/kernel-parameters.txt |    4 +++
>  drivers/block/loop.c                |   39 ++++++++++++++++++++++++++++++----
>  2 files changed, 38 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 9a5b665..7f2fd52 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1075,6 +1075,10 @@ and is between 256 and 4096 characters. It is defined in the file
>  			be mounted
>  			Format: <1-256>
>  
> +	loop_max_part=	[LOOP] Maximum number of partitions per loopback device.
> +			Should be greater than 0, the maximum value depends
> +			on max_loop.
> +
>  	maxcpus=	[SMP] Maximum number of processors that	an SMP kernel
>  			should make use of.  maxcpus=n : n >= 0 limits the
>  			kernel to using 'n' processors.  n=0 is a special case,
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 91ebb00..16b2aa6 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -82,6 +82,9 @@
>  static LIST_HEAD(loop_devices);
>  static DEFINE_MUTEX(loop_devices_mutex);
>  
> +static int loop_max_part;
> +static int part_shift;
> +
>  /*
>   * Transfer functions
>   */
> @@ -692,6 +695,8 @@ static int loop_change_fd(struct loop_device *lo, struct file *lo_file,
>  		goto out_putf;
>  
>  	fput(old_file);
> +	if (loop_max_part > 0)
> +		ioctl_by_bdev(bdev, BLKRRPART, 0);
>  	return 0;
>  
>   out_putf:
> @@ -819,6 +824,8 @@ static int loop_set_fd(struct loop_device *lo, struct file *lo_file,
>  	}
>  	lo->lo_state = Lo_bound;
>  	wake_up_process(lo->lo_thread);
> +	if (loop_max_part > 0)
> +		ioctl_by_bdev(bdev, BLKRRPART, 0);
>  	return 0;
>  
>  out_clr:
> @@ -1360,6 +1367,8 @@ static struct block_device_operations lo_fops = {
>  static int max_loop;
>  module_param(max_loop, int, 0);
>  MODULE_PARM_DESC(max_loop, "Maximum number of loop devices");
> +module_param(loop_max_part, int, 0);
> +MODULE_PARM_DESC(loop_max_part, "Maximum number of partitions per loop device");
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);
>  
> @@ -1412,7 +1421,7 @@ static struct loop_device *loop_alloc(int i)
>  	if (!lo->lo_queue)
>  		goto out_free_dev;
>  
> -	disk = lo->lo_disk = alloc_disk(1);
> +	disk = lo->lo_disk = alloc_disk(1 << part_shift);
>  	if (!disk)
>  		goto out_free_queue;
>  
> @@ -1422,7 +1431,7 @@ static struct loop_device *loop_alloc(int i)
>  	init_waitqueue_head(&lo->lo_event);
>  	spin_lock_init(&lo->lo_lock);
>  	disk->major		= LOOP_MAJOR;
> -	disk->first_minor	= i;
> +	disk->first_minor	= i << part_shift;
>  	disk->fops		= &lo_fops;
>  	disk->private_data	= lo;
>  	disk->queue		= lo->lo_queue;
> @@ -1502,7 +1511,12 @@ static int __init loop_init(void)
>  	 *     themselves and have kernel automatically instantiate actual
>  	 *     device on-demand.
>  	 */
> -	if (max_loop > 1UL << MINORBITS)
> +
> +	part_shift = 0;
> +	if (loop_max_part > 0)
> +		part_shift = fls(loop_max_part);
> +
> +	if (max_loop > 1UL << (MINORBITS - part_shift))
>  		return -EINVAL;
>  
>  	if (max_loop) {
> @@ -1510,7 +1524,7 @@ static int __init loop_init(void)
>  		range = max_loop;
>  	} else {
>  		nr = 8;
> -		range = 1UL << MINORBITS;
> +		range = 1UL << (MINORBITS - part_shift);
>  	}
>  
>  	if (register_blkdev(LOOP_MAJOR, "loop"))
> @@ -1549,7 +1563,7 @@ static void __exit loop_exit(void)
>  	unsigned long range;
>  	struct loop_device *lo, *next;
>  
> -	range = max_loop ? max_loop :  1UL << MINORBITS;
> +	range = max_loop ? max_loop :  1UL << (MINORBITS - part_shift);
>  
>  	list_for_each_entry_safe(lo, next, &loop_devices, lo_list)
>  		loop_del_one(lo);
> @@ -1569,4 +1583,19 @@ static int __init max_loop_setup(char *str)
>  }
>  
>  __setup("max_loop=", max_loop_setup);
> +
> +static int __init max_part_setup(char *str)
> +{
> +	loop_max_part = simple_strtol(str, NULL, 0);
> +	if (loop_max_part > (1UL << (MINORBITS - 1))) {
> +		/* we must keep at least one bit for loop device number */
> +		printk(KERN_ERR
> +			"loop: loop_max_part cannot be greater than %lu\n",
> +			1UL << (MINORBITS - 1));
> +		return 0;
> +	}
> +	return 1;
> +}
> +
> +__setup("loop_max_part=", max_part_setup);
>  #endif


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
