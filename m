Return-Path: <linux-kernel-owner+w=401wt.eu-S1760721AbXEMUu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760721AbXEMUu7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 16:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760434AbXEMUuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 16:50:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:51175 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759418AbXEMUut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 16:50:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=la28uMpAPSI8HWpjW4CHYDE0CABrGH7AG1UJIAeECJil5OVkl3odhfW1qIJvebKUQ1thnmZoDlB5N9t2NP2hrJWclR1O8+onltnmEhQLt0QfmCbcrOL2De8IGL0MX81HgX1fOBZXDItzl0uOVCCf9JUH0v6DEXjuCOK12GIltl4=
Date: Mon, 14 May 2007 00:51:21 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: 2.6.22-rc1: loop.c
Message-ID: <20070513205121.GA5814@martell.zuzino.mipt.ru>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2007 at 08:20:35PM -0700, Linus Torvalds wrote:
> Ok, the merge window has closed, and 2.6.22-rc1 is out there.

1. Should loop.c create max_loop or 8 devices for compatability?
   I'm asking because quite a few people after upgrade will try
   to find out where the hell is right place to create device
   nodes like loop0 in distro of choice.

   Offending line in my setup is

   /portage	/usr/portage	auto	loop,noatime	0 0


2. After (so far) manual invocations of mknod and mount -a, lockdep spit
   the following:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.22-rc1 #1
-------------------------------------------------------
mount/6168 is trying to acquire lock:
 (block_subsys_lock){--..}, at: [<c0290b1d>] kobj_map+0x94/0xf3

but task is already holding lock:
 (loop_devices_mutex){--..}, at: [<c0292364>] loop_lock+0xd/0x13

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (loop_devices_mutex){--..}:
       [<c012566f>] add_lock_to_list+0x68/0x8d
       [<c0126cbb>] debug_check_no_locks_freed+0x10a/0x127
       [<c0127963>] __lock_acquire+0x993/0xafa
       [<c0292364>] loop_lock+0xd/0x13
       [<c0127e74>] lock_acquire+0x54/0x6b
       [<c0292364>] loop_lock+0xd/0x13
       [<c034c7fc>] __mutex_lock_slowpath+0xd9/0x254
       [<c0292364>] loop_lock+0xd/0x13
       [<c034c96f>] __mutex_lock_slowpath+0x24c/0x254
       [<c02909ff>] kobj_lookup+0x34/0xbe
       [<c0292364>] loop_lock+0xd/0x13
       [<c0290a49>] kobj_lookup+0x7e/0xbe
       [<c0293355>] loop_probe+0x0/0x12e
       [<c0167ba0>] blkdev_open+0x0/0x4f
       [<c0232a1e>] get_gendisk+0x11/0x1c
       [<c01677d8>] do_open+0x2e/0x261
       [<c0167ba0>] blkdev_open+0x0/0x4f
       [<c034de80>] _spin_unlock+0x28/0x42
       [<c0167ba0>] blkdev_open+0x0/0x4f
       [<c0167bc7>] blkdev_open+0x27/0x4f
       [<c0147c0e>] __dentry_open+0x9a/0x142
       [<c0147d2c>] nameidata_to_filp+0x24/0x33
       [<c0147d72>] do_filp_open+0x37/0x3e
       [<c0147ae3>] get_unused_fd+0x1e/0xaf
       [<c034de80>] _spin_unlock+0x28/0x42
       [<c0147b6a>] get_unused_fd+0xa5/0xaf
       [<c0147db5>] do_sys_open+0x3c/0x6f
       [<c0147e23>] sys_open+0x1c/0x20
       [<c01025c6>] sysenter_past_esp+0x5f/0x99
       [<ffffffff>] 0xffffffff

-> #0 (block_subsys_lock){--..}:
       [<c012784f>] __lock_acquire+0x87f/0xafa
       [<c034df55>] _spin_unlock_irqrestore+0x37/0x5d
       [<c0127e74>] lock_acquire+0x54/0x6b
       [<c0290b1d>] kobj_map+0x94/0xf3
       [<c034c7fc>] __mutex_lock_slowpath+0xd9/0x254
       [<c0290b1d>] kobj_map+0x94/0xf3
       [<c0126b8e>] trace_hardirqs_on+0x118/0x13b
       [<c0126cbb>] debug_check_no_locks_freed+0x10a/0x127
       [<c0290b1d>] kobj_map+0x94/0xf3
       [<c0232a84>] blk_register_region+0x2f/0x34
       [<c0232224>] exact_match+0x0/0x4
       [<c0232954>] exact_lock+0x0/0x13
       [<c0232ab8>] add_disk+0x2f/0x41
       [<c0232224>] exact_match+0x0/0x4
       [<c0232954>] exact_lock+0x0/0x13
       [<c029342c>] loop_probe+0xd7/0x12e
       [<c0290a64>] kobj_lookup+0x99/0xbe
       [<c0293355>] loop_probe+0x0/0x12e
       [<c0167ba0>] blkdev_open+0x0/0x4f
       [<c0232a1e>] get_gendisk+0x11/0x1c
       [<c01677d8>] do_open+0x2e/0x261
       [<c0167ba0>] blkdev_open+0x0/0x4f
       [<c034de80>] _spin_unlock+0x28/0x42
       [<c0167ba0>] blkdev_open+0x0/0x4f
       [<c0167bc7>] blkdev_open+0x27/0x4f
       [<c0147c0e>] __dentry_open+0x9a/0x142
       [<c0147d2c>] nameidata_to_filp+0x24/0x33
       [<c0147d72>] do_filp_open+0x37/0x3e
       [<c0147ae3>] get_unused_fd+0x1e/0xaf
       [<c034de80>] _spin_unlock+0x28/0x42
       [<c0147b6a>] get_unused_fd+0xa5/0xaf
       [<c0147db5>] do_sys_open+0x3c/0x6f
       [<c0147e23>] sys_open+0x1c/0x20
       [<c01025c6>] sysenter_past_esp+0x5f/0x99
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by mount/6168:
 #0:  (loop_devices_mutex){--..}, at: [<c0292364>] loop_lock+0xd/0x13

stack backtrace:
 [<c0126134>] print_circular_bug_tail+0x5e/0x66
 [<c012784f>] __lock_acquire+0x87f/0xafa
 [<c034df55>] _spin_unlock_irqrestore+0x37/0x5d
 [<c0127e74>] lock_acquire+0x54/0x6b
 [<c0290b1d>] kobj_map+0x94/0xf3
 [<c034c7fc>] __mutex_lock_slowpath+0xd9/0x254
 [<c0290b1d>] kobj_map+0x94/0xf3
 [<c0126b8e>] trace_hardirqs_on+0x118/0x13b
 [<c0126cbb>] debug_check_no_locks_freed+0x10a/0x127
 [<c0290b1d>] kobj_map+0x94/0xf3
 [<c0232a84>] blk_register_region+0x2f/0x34
 [<c0232224>] exact_match+0x0/0x4
 [<c0232954>] exact_lock+0x0/0x13
 [<c0232ab8>] add_disk+0x2f/0x41
 [<c0232224>] exact_match+0x0/0x4
 [<c0232954>] exact_lock+0x0/0x13
 [<c029342c>] loop_probe+0xd7/0x12e
 [<c0290a64>] kobj_lookup+0x99/0xbe
 [<c0293355>] loop_probe+0x0/0x12e
 [<c0167ba0>] blkdev_open+0x0/0x4f
 [<c0232a1e>] get_gendisk+0x11/0x1c
 [<c01677d8>] do_open+0x2e/0x261
 [<c0167ba0>] blkdev_open+0x0/0x4f
 [<c034de80>] _spin_unlock+0x28/0x42
 [<c0167ba0>] blkdev_open+0x0/0x4f
 [<c0167bc7>] blkdev_open+0x27/0x4f
 [<c0147c0e>] __dentry_open+0x9a/0x142
 [<c0147d2c>] nameidata_to_filp+0x24/0x33
 [<c0147d72>] do_filp_open+0x37/0x3e
 [<c0147ae3>] get_unused_fd+0x1e/0xaf
 [<c034de80>] _spin_unlock+0x28/0x42
 [<c0147b6a>] get_unused_fd+0xa5/0xaf
 [<c0147db5>] do_sys_open+0x3c/0x6f
 [<c0147e23>] sys_open+0x1c/0x20
 [<c01025c6>] sysenter_past_esp+0x5f/0x99
 =======================
EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended

