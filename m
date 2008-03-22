Return-Path: <linux-kernel-owner+w=401wt.eu-S1758419AbYCVVz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419AbYCVVz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 17:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbYCVVzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 17:55:13 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:54994 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbYCVVzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 17:55:10 -0400
Date: Sat, 22 Mar 2008 22:54:51 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: ext Andrew Morton <akpm@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Tejun Heo <htejun@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.25-rc6: kernel BUG at fs/sysfs/file.c:89
In-Reply-To: <alpine.DEB.1.00.0803221942050.4470@sheep.housecafe.de>
Message-ID: <alpine.DEB.1.00.0803222128570.6948@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803212319130.17137@sheep.housecafe.de> <200803220226.35552.rjw@sisk.pl> <20080321222606.16407d74.akpm@linux-foundation.org> <alpine.DEB.1.00.0803221942050.4470@sheep.housecafe.de>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2008, Christian Kujau wrote:
>> If so, the below (already merged) patch should fix this crash.
>> If this patch does not fix it then please apply this debug patch:
>> http://userweb.kernel.org/~akpm/mmotm/broken-out/gregkh-driver-driver-core-debug-for-bad-dev_attr_show-return-value.patch
>> then rerun the test.
>
> Ah, sorry, I misread your post: I applied the aforementioned dm-crypt 
> patch[0] and Greg's debug patch and got quite nasty SCSI errors, leading to a 
> complete lockup. I'll try again and only apply Neil's patch...stay tuned...

Hm, this was strange: I applied Neil's patch (and the dm-crypt patch) on 
2.6.25-rc6 and I kept getting SCSI errors (and lockups) when doing "tar 
-cf - | dd of=/dev/null" - which I did to generate disk I/O.

Doing the same as a normal user, nothing bad happened (except a
"possible circular locking dependency" warning, copied below) and the box 
is still up & running for a few hours now, with a constant read of ~30MB/s
across (md-)disks (running tar, rsync). So all in all I'm very happy, 
because with these two patches applied, 2.6.25-rc seems to be usable 
again.

Of course, it'd be interesting to know where the scsi errors come from, 
but that's another story I guess...

Thanks to all involved,
Christian.

[ 4657.715881] =======================================================
[ 4657.716512] [ INFO: possible circular locking dependency detected ]
[ 4657.716895] 2.6.25-rc6 #5
[ 4657.717170] -------------------------------------------------------
[ 4657.717552] rsync/14184 is trying to acquire lock:
[ 4657.717892]  (iprune_mutex){--..}, at: [<c017b672>] shrink_icache_memory+0x72/0x220
[ 4657.718239] 
[ 4657.718239] but task is already holding lock:
[ 4657.718463]  (&(&ip->i_iolock)->mr_lock){----}, at: [<c027a766>] xfs_ilock+0x96/0xb0
[ 4657.718714] 
[ 4657.718715] which lock already depends on the new lock.
[ 4657.718716] 
[ 4657.719047] 
[ 4657.719047] the existing dependency chain (in reverse order) is:
[ 4657.719291] 
[ 4657.719292] -> #1 (&(&ip->i_iolock)->mr_lock){----}:
[ 4657.719526]        [<c01369f4>] add_lock_to_list+0x44/0xc0
[ 4657.719779]        [<c0139486>] __lock_acquire+0xc26/0x10b0
[ 4657.720142]        [<c027a766>] xfs_ilock+0x96/0xb0
[ 4657.720483]        [<c013826d>] mark_held_locks+0x3d/0x70
[ 4657.720483]        [<c013996e>] lock_acquire+0x5e/0x80
[ 4657.720483]        [<c027a766>] xfs_ilock+0x96/0xb0
[ 4657.720483]        [<c012fc81>] down_write_nested+0x41/0x60
[ 4657.720483]        [<c027a766>] xfs_ilock+0x96/0xb0
[ 4657.720483]        [<c027a766>] xfs_ilock+0x96/0xb0
[ 4657.720483]        [<c027a8fa>] xfs_ireclaim+0x1a/0x60
[ 4657.720483]        [<c02987b3>] xfs_finish_reclaim+0x53/0x1a0
[ 4657.720483]        [<c02a7c6e>] xfs_fs_clear_inode+0x5e/0x90
[ 4657.720483]        [<c017b279>] clear_inode+0xa9/0x130
[ 4657.720483]        [<c017ac40>] destroy_inode+0x20/0x40
[ 4657.720483]        [<c017b55a>] dispose_list+0x1a/0xc0
[ 4657.720483]        [<c017b7e2>] shrink_icache_memory+0x1e2/0x220
[ 4657.720483]        [<c0150211>] shrink_slab+0x101/0x160
[ 4657.720483]        [<c01507a8>] kswapd+0x298/0x3f0
[ 4657.720483]        [<c014f140>] isolate_pages_global+0x0/0x60
[ 4657.720483]        [<c012c710>] autoremove_wake_function+0x0/0x40
[ 4657.720483]        [<c01383bc>] trace_hardirqs_on+0x9c/0x110
[ 4657.720483]        [<c0150510>] kswapd+0x0/0x3f0
[ 4657.720483]        [<c012c442>] kthread+0x42/0x70
[ 4657.720483]        [<c012c400>] kthread+0x0/0x70
[ 4657.720483]        [<c0103a1f>] kernel_thread_helper+0x7/0x18
[ 4657.720483]        [<ffffffff>] 0xffffffff
[ 4657.720483] 
[ 4657.720483] -> #0 (iprune_mutex){--..}:
[ 4657.720483]        [<c0136c80>] print_circular_bug_entry+0x40/0x50
[ 4657.720483]        [<c0139287>] __lock_acquire+0xa27/0x10b0
[ 4657.720483]        [<c01389ef>] __lock_acquire+0x18f/0x10b0
[ 4657.720483]        [<c013996e>] lock_acquire+0x5e/0x80
[ 4657.720483]        [<c017b672>] shrink_icache_memory+0x72/0x220
[ 4657.720483]        [<c043e2f9>] mutex_lock_nested+0x89/0x240
[ 4657.720483]        [<c017b672>] shrink_icache_memory+0x72/0x220
[ 4657.720483]        [<c017b672>] shrink_icache_memory+0x72/0x220
[ 4657.720483]        [<c017b672>] shrink_icache_memory+0x72/0x220
[ 4657.720483]        [<c0150131>] shrink_slab+0x21/0x160
[ 4657.720483]        [<c0150211>] shrink_slab+0x101/0x160
[ 4657.720483]        [<c01503c2>] try_to_free_pages+0x152/0x230
[ 4657.720483]        [<c014f140>] isolate_pages_global+0x0/0x60
[ 4657.720483]        [<c014ba3b>] __alloc_pages+0x14b/0x370
[ 4657.720483]        [<c043fa20>] _read_unlock_irq+0x20/0x30
[ 4657.720483]        [<c01466e1>] __grab_cache_page+0x81/0xc0
[ 4657.720483]        [<c01897d6>] block_write_begin+0x76/0xe0
[ 4657.720483]        [<c029ed56>] xfs_vm_write_begin+0x46/0x50
[ 4657.720483]        [<c029f5a0>] xfs_get_blocks+0x0/0x30
[ 4657.720483]        [<c0147377>] generic_file_buffered_write+0x117/0x650
[ 4657.720483]        [<c01846c3>] __mark_inode_dirty+0x53/0x180
[ 4657.720483]        [<c043f6b9>] _spin_lock+0x29/0x40
[ 4657.720483]        [<c01846c3>] __mark_inode_dirty+0x53/0x180
[ 4657.720483]        [<c02a74ac>] xfs_write+0x7ac/0x8a0
[ 4657.720483]        [<c0174ba1>] core_sys_select+0x21/0x350
[ 4657.720483]        [<c02a339c>] xfs_file_aio_write+0x5c/0x70
[ 4657.720483]        [<c0167cd5>] do_sync_write+0xd5/0x120
[ 4657.720483]        [<c012c710>] autoremove_wake_function+0x0/0x40
[ 4657.720483]        [<c019d0b5>] dnotify_parent+0x35/0x90
[ 4657.720483]        [<c0167c00>] do_sync_write+0x0/0x120
[ 4657.720483]        [<c016854f>] vfs_write+0x9f/0x140
[ 4657.720483]        [<c0168b01>] sys_write+0x41/0x70
[ 4657.720483]        [<c0102dee>] sysenter_past_esp+0x5f/0xa5
[ 4657.720483]        [<ffffffff>] 0xffffffff
[ 4657.720483] 
[ 4657.720483] other info that might help us debug this:
[ 4657.720483] 
[ 4657.720483] 3 locks held by rsync/14184:
[ 4657.720483]  #0:  (&sb->s_type->i_mutex_key#12){--..}, at: [<c02a70f9>] xfs_write+0x3f9/0x8a0
[ 4657.720483]  #1:  (&(&ip->i_iolock)->mr_lock){----}, at: [<c027a766>] xfs_ilock+0x96/0xb0
[ 4657.720483]  #2:  (shrinker_rwsem){----}, at: [<c0150131>] shrink_slab+0x21/0x160
[ 4657.720483] 
[ 4657.720483] stack backtrace:
[ 4657.720483] Pid: 14184, comm: rsync Not tainted 2.6.25-rc6 #5
[ 4657.720483]  [<c0137502>] print_circular_bug_tail+0x72/0x80
[ 4657.720483]  [<c0139287>] __lock_acquire+0xa27/0x10b0
[ 4657.720483]  [<c01389ef>] __lock_acquire+0x18f/0x10b0
[ 4657.720483]  [<c013996e>] lock_acquire+0x5e/0x80
[ 4657.720483]  [<c017b672>] shrink_icache_memory+0x72/0x220
[ 4657.720483]  [<c043e2f9>] mutex_lock_nested+0x89/0x240
[ 4657.720483]  [<c017b672>] shrink_icache_memory+0x72/0x220
[ 4657.720483]  [<c017b672>] shrink_icache_memory+0x72/0x220
[ 4657.720483]  [<c017b672>] shrink_icache_memory+0x72/0x220
[ 4657.720483]  [<c0150131>] shrink_slab+0x21/0x160
[ 4657.720483]  [<c0150211>] shrink_slab+0x101/0x160
[ 4657.720483]  [<c01503c2>] try_to_free_pages+0x152/0x230
[ 4657.720483]  [<c014f140>] isolate_pages_global+0x0/0x60
[ 4657.720483]  [<c014ba3b>] __alloc_pages+0x14b/0x370
[ 4657.720483]  [<c043fa20>] _read_unlock_irq+0x20/0x30
[ 4657.720483]  [<c01466e1>] __grab_cache_page+0x81/0xc0
[ 4657.720483]  [<c01897d6>] block_write_begin+0x76/0xe0
[ 4657.720483]  [<c029ed56>] xfs_vm_write_begin+0x46/0x50
[ 4657.720483]  [<c029f5a0>] xfs_get_blocks+0x0/0x30
[ 4657.720483]  [<c0147377>] generic_file_buffered_write+0x117/0x650
[ 4657.720483]  [<c01846c3>] __mark_inode_dirty+0x53/0x180
[ 4657.720483]  [<c043f6b9>] _spin_lock+0x29/0x40
[ 4657.720483]  [<c01846c3>] __mark_inode_dirty+0x53/0x180
[ 4657.720483]  [<c02a74ac>] xfs_write+0x7ac/0x8a0
[ 4657.720483]  [<c0174ba1>] core_sys_select+0x21/0x350
[ 4657.720483]  [<c02a339c>] xfs_file_aio_write+0x5c/0x70
[ 4657.720483]  [<c0167cd5>] do_sync_write+0xd5/0x120
[ 4657.720483]  [<c012c710>] autoremove_wake_function+0x0/0x40
[ 4657.720483]  [<c019d0b5>] dnotify_parent+0x35/0x90
[ 4657.720483]  [<c0167c00>] do_sync_write+0x0/0x120
[ 4657.720483]  [<c016854f>] vfs_write+0x9f/0x140
[ 4657.720483]  [<c0168b01>] sys_write+0x41/0x70
[ 4657.720483]  [<c0102dee>] sysenter_past_esp+0x5f/0xa5
[ 4657.720483]  =======================

-- 
BOFH excuse #197:

I'm sorry a pentium won't do, you need an SGI to connect with us.
