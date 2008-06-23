Return-Path: <linux-kernel-owner+w=401wt.eu-S1755061AbYFWWJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbYFWWJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 18:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYFWWJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 18:09:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43096 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbYFWWJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 18:09:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.26-rc7-git1: possible circular locking dependency with RAID1
Date: Tue, 24 Jun 2008 00:10:35 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806240010.35866.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Today I was rebuilding software RAID arrays on one of my boxes and I did

# mdadm /dev/md4 --fail /dev/sdb7 --remove /dev/sdb7

and then I thought it was a bad idea and did

# mdadm /dev/md4 --add /dev/sdb7

That resulted in the following lockdep report, although the operation seemed
to have completed successfully otherwise:

raid1: Disk failure on sdb7, disabling device.
raid1: Operation continuing on 1 devices.
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:1, o:0, dev:sdb7
 disk 1, wo:0, o:1, dev:sda7
RAID1 conf printout:
 --- wd:1 rd:2
 disk 1, wo:0, o:1, dev:sda7
md: unbind<sdb7>
md: export_rdev(sdb7)

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.26-rc7 #196
-------------------------------------------------------
mdadm/5973 is trying to acquire lock:
 (&type->s_umount_key#17){----}, at: [<ffffffff802b2409>] get_super+0x69/0xc0

but task is already holding lock:
 (&bdev->bd_mutex){--..}, at: [<ffffffff802de882>] do_open+0x72/0x320

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&bdev->bd_mutex){--..}:
       [<ffffffff8025ee64>] __lock_acquire+0xc44/0x10d0
       [<ffffffff8025f347>] lock_acquire+0x57/0x80
       [<ffffffff804ebad3>] mutex_lock_nested+0xa3/0x290
       [<ffffffff802de882>] do_open+0x72/0x320
       [<ffffffff802debbb>] __blkdev_get+0x8b/0xb0
       [<ffffffff802debeb>] blkdev_get+0xb/0x10
       [<ffffffff802df07c>] open_by_devnum+0x3c/0x60
       [<ffffffffa0214dd5>] journal_init+0x225/0xa20 [reiserfs]
       [<ffffffffa020426b>] reiserfs_fill_super+0x2db/0xa20 [reiserfs]
       [<ffffffff802b34b4>] get_sb_bdev+0x134/0x170
       [<ffffffffa02013e3>] get_super_block+0x13/0x20 [reiserfs]
       [<ffffffff802b3179>] vfs_kern_mount+0x79/0x160
       [<ffffffff802b32ce>] do_kern_mount+0x4e/0x100
       [<ffffffff802cd1b9>] do_new_mount+0x89/0xb0
       [<ffffffff802cd3c0>] do_mount+0x1e0/0x240
       [<ffffffff802cd4b4>] sys_mount+0x94/0xe0
       [<ffffffff8020b6cb>] system_call_after_swapgs+0x7b/0x80
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&type->s_umount_key#17){----}:
       [<ffffffff8025ecae>] __lock_acquire+0xa8e/0x10d0
       [<ffffffff8025f347>] lock_acquire+0x57/0x80
       [<ffffffff804ec1ae>] down_read+0x3e/0x50
       [<ffffffff802b2409>] get_super+0x69/0xc0
       [<ffffffff802ddeaf>] __invalidate_device+0x1f/0x60
       [<ffffffff802ddf38>] check_disk_change+0x48/0x90
       [<ffffffff8043d732>] md_open+0x72/0x90
       [<ffffffff802dea7f>] do_open+0x26f/0x320
       [<ffffffff802dedce>] blkdev_open+0x3e/0x80
       [<ffffffff802aea1b>] __dentry_open+0xdb/0x2d0
       [<ffffffff802aec54>] nameidata_to_filp+0x44/0x60
       [<ffffffff802bd8d4>] do_filp_open+0x1e4/0x9e0
       [<ffffffff802ae84c>] do_sys_open+0x5c/0xf0
       [<ffffffff802ae90b>] sys_open+0x1b/0x20
       [<ffffffff8020b6cb>] system_call_after_swapgs+0x7b/0x80
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

1 lock held by mdadm/5973:
 #0:  (&bdev->bd_mutex){--..}, at: [<ffffffff802de882>] do_open+0x72/0x320

stack backtrace:
Pid: 5973, comm: mdadm Not tainted 2.6.26-rc7 #196

Call Trace:
 [<ffffffff8025cc33>] print_circular_bug_tail+0x83/0x90
 [<ffffffff8025ecae>] __lock_acquire+0xa8e/0x10d0
 [<ffffffff8025f347>] lock_acquire+0x57/0x80
 [<ffffffff802b2409>] ? get_super+0x69/0xc0
 [<ffffffff804ec1ae>] down_read+0x3e/0x50
 [<ffffffff802b2409>] get_super+0x69/0xc0
 [<ffffffff802ddeaf>] __invalidate_device+0x1f/0x60
 [<ffffffff802ddf38>] check_disk_change+0x48/0x90
 [<ffffffff8043d732>] md_open+0x72/0x90
 [<ffffffff802dea7f>] do_open+0x26f/0x320
 [<ffffffff804ed396>] ? _spin_unlock+0x26/0x30
 [<ffffffff802dedce>] blkdev_open+0x3e/0x80
 [<ffffffff802aea1b>] __dentry_open+0xdb/0x2d0
 [<ffffffff802ded90>] ? blkdev_open+0x0/0x80
 [<ffffffff802aec54>] nameidata_to_filp+0x44/0x60
 [<ffffffff802bd8d4>] do_filp_open+0x1e4/0x9e0
 [<ffffffff802aac61>] ? check_poison_obj+0x31/0x210
 [<ffffffff802ae7c5>] ? get_unused_fd_flags+0x105/0x130
 [<ffffffff802ae84c>] do_sys_open+0x5c/0xf0
 [<ffffffff802ae90b>] sys_open+0x1b/0x20
 [<ffffffff8020b6cb>] system_call_after_swapgs+0x7b/0x80

VFS: busy inodes on changed media.
md: bind<sdb7>
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:1, o:1, dev:sdb7
 disk 1, wo:0, o:1, dev:sda7
md: recovery of RAID array md4
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
md: using 128k window, over a total of 33551616 blocks.

Thanks,
Rafael
