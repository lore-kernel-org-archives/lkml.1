Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbYLHW43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbYLHW43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 17:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbYLHW4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 17:56:22 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58501 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbYLHW4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 17:56:21 -0500
Date: Mon, 8 Dec 2008 23:58:01 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Paul.Clements@steeleye.com
Subject: Re: warn-on from nbd in 2.6.28-rc7 from sysfs_add_one()
Message-ID: <20081208225758.GA2872@elf.ucw.cz>
References: <20081208213542.GA10134@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081208213542.GA10134@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-12-08 22:35:42, Pavel Machek wrote:
> 
> sysfs_add_one() complains about entry already existing.

Aha, luckily this is very reproducible:

root@amd:/home/pavel/misc# cat /dev/zero | head -c 10000000 >
/tmp/delme.fstest.fs
root@amd:/home/pavel/misc# nbd-server 9100 -l /anyone.can.connect
/tmp/delme.fstest.fs &
[1] 2360
root@amd:/home/pavel/misc#
** (process:2360): WARNING **: Could not parse config file: Could not
open config file.

[1]+  Done                    nbd-server 9100 -l /anyone.can.connect
/tmp/delme.fstest.fs
root@amd:/home/pavel/misc# sleep 1
sleep 1
root@amd:/home/pavel/misc# sleep 1
root@amd:/home/pavel/misc# nbd-client localhost 9100 /dev/nd0
Error: Can not open NBD: No such device or address
root@amd:/home/pavel/misc# insmod /data/l/b-linux/drivers/block/nbd.ko
nbd: registered device at major 43
root@amd:/home/pavel/misc# nbd-client localhost 9100 /dev/nd0
Negotiation: ..size = 9765KB
bs=1024, sz=9765

^Z
[1]+  Stopped                 nbd-client localhost 9100 /dev/nd0
root@amd:/home/pavel/misc# bg
[1]+ nbd-client localhost 9100 /dev/nd0 &
root@amd:/home/pavel/misc# nbd-client localhost 9100 /dev/nd0
Negotiation: ..size = 9765KB
bs=1024, sz=9765
------------[ cut here ]------------
WARNING: at /data/l/linux/fs/sysfs/dir.c:462 sysfs_add_one+0x4a/0x50()
sysfs: duplicate filename 'pid' can not be created
Modules linked in: nbd
Pid: 2757, comm: nbd-client Not tainted 2.6.28-rc7 #422
Call Trace:

...no, running two clients at the same time is not exactly clever. 

 								Pavel

> wlan0: associated
> nbd: registered device at major 43
> ------------[ cut here ]------------
> WARNING: at /data/l/linux/fs/sysfs/dir.c:462 sysfs_add_one+0x4a/0x50()
> sysfs: duplicate filename 'pid' can not be created
> Modules linked in: nbd
> Pid: 8280, comm: nbd-client Not tainted 2.6.28-rc7 #422
> Call Trace:
>  [<c022e8d6>] warn_slowpath+0x76/0x90
>  [<c024e3d1>] __lock_acquire+0x181/0x930
>  [<c024e3d1>] __lock_acquire+0x181/0x930
>  [<c0298b9f>] ifind+0x8f/0xa0
>  [<c07bcff4>] _spin_unlock+0x14/0x20
>  [<c02ca151>] sysfs_find_dirent+0x21/0x30
>  [<c02ca17c>] __sysfs_add_one+0x1c/0x80
>  [<c02ca22a>] sysfs_add_one+0x4a/0x50
>  [<c02c9a50>] sysfs_add_file_mode+0x50/0x90
>  [<c02c9aa0>] sysfs_add_file+0x10/0x20
>  [<f8794e43>] nbd_ioctl+0x423/0x8e0 [nbd]
>  [<f87947d0>] nbd_thread+0x0/0x250 [nbd]
>  [<c021db8a>] __change_page_attr_set_clr+0xba/0x520
>  [<c03c90ea>] delay_tsc+0x2a/0x50
>  [<c03c9086>] __delay+0x6/0x10
>  [<c03cd72a>] _raw_spin_lock+0xfa/0x190
>  [<c021db8a>] __change_page_attr_set_clr+0xba/0x520
>  [<c03ba15a>] __blkdev_driver_ioctl+0x7a/0x90
>  [<c03ba229>] blkdev_ioctl+0x99/0x9e0
>  [<c024e3d1>] __lock_acquire+0x181/0x930
>  [<c0267dd6>] get_page_from_freelist+0x266/0x430
>  [<c0262a71>] find_get_page+0x91/0xd0
>  [<c024e3d1>] __lock_acquire+0x181/0x930
>  [<c02629e0>] find_get_page+0x0/0xd0
>  [<c0262cbb>] find_lock_page+0x1b/0x60
>  [<c02713a0>] __do_fault+0x1a0/0x3c0
>  [<c02713a9>] __do_fault+0x1a9/0x3c0
>  [<c02ab6a7>] block_ioctl+0x37/0x50
>  [<c02ab670>] block_ioctl+0x0/0x50
>  [<c0293bbb>] vfs_ioctl+0x2b/0x90
>  [<c0293c7c>] do_vfs_ioctl+0x5c/0x490
>  [<c02457f6>] down_read_trylock+0x56/0x60
>  [<c021cbd0>] do_page_fault+0x0/0x6a0
>  [<c021ce4c>] do_page_fault+0x27c/0x6a0
>  [<c02940ed>] sys_ioctl+0x3d/0x70
>  [<c0203d52>] syscall_call+0x7/0xb
> ---[ end trace 0cbc102fb0629d93 ]---
> nbd: sysfs_create_file failed!<6>nbd-server[8255]: segfault at 7 ip b7e61e97 sp bfc265d0 error 4 in libglib-2.0.so.0.1600.5[b7e37000+b4000]
> nbd0: Receive control failed (result -32)
> nbd0: queue cleared
> nbd-server[8297]: segfault at 7 ip b7f18e97 sp bfbde2c0 error 4 in libglib-2.0.so.0.1600.5[b7eee000+b4000]
> nbd0: Receive control failed (result -32)
> nbd0: shutting down socket
> nbd0: queue cleared
> nbd-server[8338]: segfault at 7 ip b7f26e97 sp bfeebdd0 error 4 in libglib-2.0.so.0.1600.5[b7efc000+b4000]
> nbd0: Receive control failed (result -32)
> nbd0: shutting down socket
> nbd0: queue cleared
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
