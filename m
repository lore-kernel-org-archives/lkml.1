Return-Path: <linux-kernel-owner+w=401wt.eu-S1761597AbYCSUmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761597AbYCSUmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757993AbYCSTms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:42:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752274AbYCSTmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:42:43 -0400
Date: Tue, 18 Mar 2008 13:54:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: axboe@suse.de, linux-kernel@vger.kernel.org, Laurent.Vivier@bull.net
Subject: Re: [PATCH][RESEND][v3] Modify loop device to be able to manage
 partitions of the disk image
Message-Id: <20080318135423.6c7b745f.akpm@linux-foundation.org>
In-Reply-To: <12058427603971-git-send-email-Laurent.Vivier@bull.net>
References: <12058427603971-git-send-email-Laurent.Vivier@bull.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008 13:19:20 +0100
Laurent Vivier <Laurent.Vivier@bull.net> wrote:

> v3 is an updated version of v2, replacing a "%d" by a "%lu".
> 
> This patch allows to use loop device with partitionned disk image.
> 
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
> ...
>
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

This shouldn't be needed.

> @@ -1360,6 +1367,8 @@ static struct block_device_operations lo_fops = {
>  static int max_loop;
>  module_param(max_loop, int, 0);
>  MODULE_PARM_DESC(max_loop, "Maximum number of loop devices");
> +module_param(loop_max_part, int, 0);
> +MODULE_PARM_DESC(loop_max_part, "Maximum number of partitions per loop device");

Because this module_param() gives us the loop.loop_max_part=N kernel boot
parameter.

Given which, I think we could rename it to just "max_part":

	modprobe loop max_part=4

	kernel vmlinuz-... loop.max_part=4

?

>  __setup("max_loop=", max_loop_setup);

That could go away in the same way, but we have a back-compat problem.

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

