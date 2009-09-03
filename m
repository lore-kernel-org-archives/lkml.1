Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbZICKV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbZICKV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 06:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbZICKV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 06:21:56 -0400
Received: from kuber.nabble.com ([216.139.236.158]:34917 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbZICKVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 06:21:55 -0400
Message-ID: <25273217.post@talk.nabble.com>
Date: Thu, 3 Sep 2009 03:21:57 -0700 (PDT)
From: zamir <zamir.alam@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Booting issue on Omap3430 due to Initrd
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: zamir.alam@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I am trying to boot Linux on a TI OMAP3430 based device. The device boots up
to a point where it tries to find the initrd image but cannot find it.

My kernel version is 2.6.27. I am using a custom NAND flashing utility to
flash the device with the bootloader, initrd image and kernel. My bootloader
creates ATAGS, copies the kernel and initrd image to RAM and then jumps to
the kernel.

The kernel boots up fine to a point where it tries to mount root. Then it
gives the following error:

No filesystem could mount root, tried: ext3 ext2 msdos vfat

<0>Kernel panic - not syncing: VFS: Unable to mount root fs on
unknown-block(1,0)

On debugging I found that the following function call returns -2 (-ENOENT)
	in_fd = sys_open(from, O_RDONLY, 0);

This is called in file \init\do_mounts_rd.c inside function:
int __init rd_load_image(char *from)

This in turn is called from do_mounts_initrd.c 
	if (rd_load_image("/initrd.image") && ROOT_DEV != Root_RAM0)


I found that initrd.image is created in \init\initramfs.c 
static int __init populate_rootfs(void)
{
...
if (initrd_start) {
...

		fd = sys_open("/initrd.image", O_WRONLY|O_CREAT, 0700);
...

Here initrd_start is always zero so this condition never gets true. So
initrd.image is never created.


In short, while booting sys_open("/initrd.image", O_RDONLY, 0); fails with
-2.

I have checked the initrd image is present at the memory location specified
in kernel tags when kernel starts.


Can anybody point to what could be the possible reason for this problem?


Regards,
Zamir
-- 
View this message in context: http://www.nabble.com/Booting-issue-on-Omap3430-due-to-Initrd-tp25273217p25273217.html
Sent from the linux-kernel mailing list archive at Nabble.com.

