Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYJXHng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYJXHng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 03:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYJXHn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 03:43:28 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:58489 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbYJXHn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 03:43:27 -0400
X-BigFish: VPS-7(zz936eQzzzzz2dh6bh34h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,5,
Message-ID: <49017C08.8080304@e2s.net>
Date: Fri, 24 Oct 2008 09:40:56 +0200
From: Matthias Kaehlcke <mkaehlcke@e2s.net>
Organization: Electronic Engineering Solutions
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: loop: possible circular locking dependency detected
Content-Type: multipart/mixed;
	boundary="------------080008050408040209020804"
X-OriginalArrivalTime: 24 Oct 2008 07:43:05.0850 (UTC) FILETIME=[26CEBDA0:01C935AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------080008050408040209020804
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

lockdep reports a possible circular locking in the following use case:

1) setup a loop device backed by a partition on a mass storage device

2) mount loop device

3) read from the loop device

4) unplug the mass storage device while reading (i know this is nasty, 
but users do this kind of stuff ...)


[42950404.410000] usb 1-3: USB disconnect, address 3
[42950404.460000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT 
driverbyte=DRIVER_OK,SUGGEST_OK
[42950404.470000] end_request: I/O error, dev sdb, sector 181704
[42950404.470000] Buffer I/O error on device sdb1, logical block 22709
[42950404.480000] Buffer I/O error on device sdb1, logical block 22710
[42950404.480000] Buffer I/O error on device sdb1, logical block 22711
[42950404.490000] Buffer I/O error on device sdb1, logical block 22712
[42950404.500000] Buffer I/O error on device sdb1, logical block 22717
[42950404.500000] Buffer I/O error on device sdb1, logical block 22718
[42950404.500000] Buffer I/O error on device sdb1, logical block 22719
[42950404.500000] Buffer I/O error on device sdb1, logical block 22720
[42950404.500000] Buffer I/O error on device sdb1, logical block 22721
[42950404.500000] Buffer I/O error on device sdb1, logical block 22722
[42950404.540000] watchdog: executing timer ...
[42950404.540000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT 
driverbyte=DRIVER_OK,SUGGEST_OK
[42950404.550000] end_request: I/O error, dev sdb, sector 181736
[42950405.250000]
[42950405.250000] =======================================================
[42950405.250000] [ INFO: possible circular locking dependency detected ]
[42950405.250000] 2.6.26.3 #20
[42950405.250000] -------------------------------------------------------
[42950405.250000] exe/7044 is trying to acquire lock:
[42950405.250000]  (&bdev->bd_mutex){--..}, at: [<c00dcaf0>] 
__blkdev_put+0x28/0x158
[42950405.250000]
[42950405.250000] but task is already holding lock:
[42950405.250000]  (&lo->lo_ctl_mutex){--..}, at: [<c01a0fb0>] 
lo_ioctl+0x3c/0x8c0
[42950405.250000]
[42950405.250000] which lock already depends on the new lock.
[42950405.250000]
[42950405.250000]
[42950405.250000] the existing dependency chain (in reverse order) is:
[42950405.250000]
[42950405.250000] -> #1 (&lo->lo_ctl_mutex){--..}:
[42950405.250000]        [<c007b810>] lock_acquire+0x8c/0xa8
[42950405.250000]        [<c02a512c>] mutex_lock_nested+0xa8/0x2b0
[42950405.250000]        [<c01a04ac>] lo_open+0x28/0x44
[42950405.250000]        [<c00dce14>] do_open+0x98/0x2e8
[42950405.250000]        [<c00dd2c0>] blkdev_open+0x38/0x78
[42950405.250000]        [<c00ad668>] __dentry_open+0x10c/0x2b0
[42950405.250000]        [<c00ad850>] nameidata_to_filp+0x44/0x50
[42950405.250000]        [<c00bb700>] do_filp_open+0x1cc/0x774
[42950405.250000]        [<c00ad45c>] do_sys_open+0x58/0xe4
[42950405.250000]        [<c00ad520>] sys_open+0x24/0x28
[42950405.250000]        [<c003bb60>] ret_fast_syscall+0x0/0x2c
[42950405.250000]
[42950405.250000] -> #0 (&bdev->bd_mutex){--..}:
[42950405.250000]        [<c007b810>] lock_acquire+0x8c/0xa8
[42950405.250000]        [<c02a512c>] mutex_lock_nested+0xa8/0x2b0
[42950405.250000]        [<c00dcaf0>] __blkdev_put+0x28/0x158
[42950405.250000]        [<c00dcc34>] blkdev_put+0x14/0x18
[42950405.250000]        [<c00dd8c8>] blkdev_close+0x30/0x44
[42950405.250000]        [<c00b07c4>] __fput+0xbc/0x1b4
[42950405.250000]        [<c00b0bd0>] fput+0x34/0x38
[42950405.250000]        [<c01a0ac4>] loop_clr_fd+0x120/0x15c
[42950405.250000]        [<c01a118c>] lo_ioctl+0x218/0x8c0
[42950405.250000]        [<c01512f0>] blkdev_driver_ioctl+0x80/0x8c
[42950405.250000]        [<c0151554>] blkdev_ioctl+0x258/0x884
[42950405.250000]        [<c00dc38c>] block_ioctl+0x2c/0x30
[42950405.250000]        [<c00bcb2c>] vfs_ioctl+0x38/0x9c
[42950405.250000]        [<c00bcc00>] do_vfs_ioctl+0x70/0x304
[42950405.250000]        [<c00bced4>] sys_ioctl+0x40/0x64
[42950405.250000]        [<c003bb60>] ret_fast_syscall+0x0/0x2c
[42950405.250000]
[42950405.250000] other info that might help us debug this:
[42950405.250000]
[42950405.250000] 1 lock held by exe/7044:
[42950405.250000]  #0:  (&lo->lo_ctl_mutex){--..}, at: [<c01a0fb0>] 
lo_ioctl+0x3c/0x8c0
[42950405.250000]
[42950405.250000] stack backtrace:
[42950405.250000] [<c003fee4>] (dump_stack+0x0/0x14) from [<c0078c44>] 
(print_circular_bug_tail+0x80/0x94)
[42950405.250000] [<c0078bc4>] (print_circular_bug_tail+0x0/0x94) from 
[<c007b46c>] (__lock_acquire+0xce4/0xffc)
[42950405.250000]  r5:c1c98418 r4:c1c983e0
[42950405.250000] [<c007a788>] (__lock_acquire+0x0/0xffc) from 
[<c007b810>] (lock_acquire+0x8c/0xa8)
[42950405.250000] [<c007b784>] (lock_acquire+0x0/0xa8) from [<c02a512c>] 
(mutex_lock_nested+0xa8/0x2b0)
[42950405.250000]  r6:c191c000 r5:60000013 r4:c0fc0ccc
[42950405.250000] [<c02a5084>] (mutex_lock_nested+0x0/0x2b0) from 
[<c00dcaf0>] (__blkdev_put+0x28/0x158)
[42950405.250000] [<c00dcac8>] (__blkdev_put+0x0/0x158) from 
[<c00dcc34>] (blkdev_put+0x14/0x18)
[42950405.250000] [<c00dcc20>] (blkdev_put+0x0/0x18) from [<c00dd8c8>] 
(blkdev_close+0x30/0x44)
[42950405.250000] [<c00dd898>] (blkdev_close+0x0/0x44) from [<c00b07c4>] 
(__fput+0xbc/0x1b4)
[42950405.250000]  r4:00000008
[42950405.250000] [<c00b0708>] (__fput+0x0/0x1b4) from [<c00b0bd0>] 
(fput+0x34/0x38)
[42950405.250000] [<c00b0b9c>] (fput+0x0/0x38) from [<c01a0ac4>] 
(loop_clr_fd+0x120/0x15c)
[42950405.250000] [<c01a09a4>] (loop_clr_fd+0x0/0x15c) from [<c01a118c>] 
(lo_ioctl+0x218/0x8c0)
[42950405.250000] [<c01a0f74>] (lo_ioctl+0x0/0x8c0) from [<c01512f0>] 
(blkdev_driver_ioctl+0x80/0x8c)
[42950405.250000] [<c0151270>] (blkdev_driver_ioctl+0x0/0x8c) from 
[<c0151554>] (blkdev_ioctl+0x258/0x884)
[42950405.250000] [<c01512fc>] (blkdev_ioctl+0x0/0x884) from 
[<c00dc38c>] (block_ioctl+0x2c/0x30)
[42950405.250000] [<c00dc360>] (block_ioctl+0x0/0x30) from [<c00bcb2c>] 
(vfs_ioctl+0x38/0x9c)
[42950405.250000]  r4:c128e2e0
[42950405.250000] [<c00bcaf4>] (vfs_ioctl+0x0/0x9c) from [<c00bcc00>] 
(do_vfs_ioctl+0x70/0x304)
[42950405.250000]  r6:00000000 r5:c128e2e0 r4:c1b120ec
[42950405.250000] [<c00bcb90>] (do_vfs_ioctl+0x0/0x304) from 
[<c00bced4>] (sys_ioctl+0x40/0x64)
[42950405.250000]  r8:c003bd04 r7:00000036 r6:00004c01 r5:fffffff7 
r4:c128e2e0
[42950405.250000] [<c00bce94>] (sys_ioctl+0x0/0x64) from [<c003bb60>] 
(ret_fast_syscall+0x0/0x2c)
[42950405.250000]  r6:00000000 r5:00000001 r4:00000003

the kernel version  is 2.6.26.3 (can't test with 2.6.27 due to an USB 
issue) running on a ep9307 (ARM) CPU

--------------080008050408040209020804
Content-Type: text/x-vcard; charset="utf-8"; name="mkaehlcke.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="mkaehlcke.vcf"

begin:vcard
fn:Matthias Kaehlcke
n:Kaehlcke;Matthias
org:Electronic Engineering Solutions;Dept. de Software
adr:;;C/ Sant Ferran, 10-16 bajos;Barcelona;;08031;Spain
email;internet:mkaehlcke@e2s.net
title:Ingeniero de Firmware
tel;work:93 407 30 80
tel;fax:93 433 56 71
x-mozilla-html:FALSE
url:http://www.e2s.net
version:2.1
end:vcard


--------------080008050408040209020804--
