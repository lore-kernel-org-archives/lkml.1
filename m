Return-Path: <linux-kernel-owner+w=401wt.eu-S932259AbYBVXcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259AbYBVXcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 18:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbYBVXcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 18:32:13 -0500
Received: from postfix1-g20.free.fr ([212.27.60.42]:34753 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbYBVXcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 18:32:11 -0500
Message-ID: <47BF5AFC.4060809@free.fr>
Date: Sat, 23 Feb 2008 00:30:04 +0100
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
To: ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: possible circular locking in reiserfs_removexattr
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've got this while running beagle. /home is mounted with the following options:

/dev/mapper/vglinux1-lvhome /home reiserfs rw,noatime,nodiratime,user_xattr 0 0

This still happens with latest kernel (next-20080222), I can't tell when it 
first appears.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.25-rc1 #15
-------------------------------------------------------
beagled/3781 is trying to acquire lock:
 (&REISERFS_I(inode)->xattr_sem){----}, at: [<e1ac02fa>] reiserfs_removexattr+0x42/0xbf [reiserfs]

but task is already holding lock:
 (&sb->s_type->i_mutex_key#8){--..}, at: [<c016f006>] vfs_removexattr+0x59/0xc2

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&sb->s_type->i_mutex_key#8){--..}:
       [<c01311f5>] __lock_acquire+0x8d9/0xa83
       [<e1aacd0e>] reiserfs_file_release+0x171/0x3b2 [reiserfs]
       [<c01316f2>] lock_acquire+0x4c/0x63
       [<e1aacd0e>] reiserfs_file_release+0x171/0x3b2 [reiserfs]
       [<c0290e57>] mutex_lock_nested+0xa9/0x219
       [<e1aacd0e>] reiserfs_file_release+0x171/0x3b2 [reiserfs]
       [<e1aacd0e>] reiserfs_file_release+0x171/0x3b2 [reiserfs]
       [<c015a01b>] __fput+0x90/0x155
       [<e1ac0ebd>] reiserfs_xattr_set+0x2a2/0x2c5 [reiserfs]
       [<e1ac0858>] reiserfs_setxattr+0x7a/0xe3 [reiserfs]
       [<e1ac07de>] reiserfs_setxattr+0x0/0xe3 [reiserfs]
       [<c016f3de>] vfs_setxattr+0x74/0xe4
       [<c016f4fb>] setxattr+0xad/0xc7
       [<c0292243>] _spin_unlock+0x25/0x3a
       [<c01bfb26>] _atomic_dec_and_lock+0x22/0x2c
       [<c016aeee>] mntput_no_expire+0x11/0x5b
       [<c0160fc2>] link_path_walk+0xa5/0xaf
       [<c010492b>] restore_nocheck+0x12/0x15
       [<c01122d0>] do_page_fault+0x0/0x484
       [<c0130556>] trace_hardirqs_on+0xdd/0xfd
       [<c0155b72>] kmem_cache_free+0x53/0x5a
       [<c0130556>] trace_hardirqs_on+0xdd/0xfd
       [<c01619e7>] __user_walk_fd+0x37/0x3f
       [<c016f58a>] sys_lsetxattr+0x37/0x4a
       [<c010492b>] restore_nocheck+0x12/0x15
       [<c01122d0>] do_page_fault+0x0/0x484
       [<c0130556>] trace_hardirqs_on+0xdd/0xfd
       [<c010492b>] restore_nocheck+0x12/0x15
       [<c0104842>] sysenter_past_esp+0x5f/0xa5
       [<ffffffff>] 0xffffffff

-> #1 (&REISERFS_SB(s)->xattr_dir_sem){----}:
       [<c01311f5>] __lock_acquire+0x8d9/0xa83
       [<e1ac0846>] reiserfs_setxattr+0x68/0xe3 [reiserfs]
       [<c01316f2>] lock_acquire+0x4c/0x63
       [<e1ac0846>] reiserfs_setxattr+0x68/0xe3 [reiserfs]
       [<c0291367>] down_write+0x17/0x2f
       [<e1ac0846>] reiserfs_setxattr+0x68/0xe3 [reiserfs]
       [<e1ac0846>] reiserfs_setxattr+0x68/0xe3 [reiserfs]
       [<e1ac07de>] reiserfs_setxattr+0x0/0xe3 [reiserfs]
       [<c016f3de>] vfs_setxattr+0x74/0xe4
       [<c016f4fb>] setxattr+0xad/0xc7
       [<c0292243>] _spin_unlock+0x25/0x3a
       [<c01bfb26>] _atomic_dec_and_lock+0x22/0x2c
       [<c016aeee>] mntput_no_expire+0x11/0x5b
       [<c0160fc2>] link_path_walk+0xa5/0xaf
       [<c010492b>] restore_nocheck+0x12/0x15
       [<c01122d0>] do_page_fault+0x0/0x484
       [<c0130556>] trace_hardirqs_on+0xdd/0xfd
       [<c0155b72>] kmem_cache_free+0x53/0x5a
       [<c0130556>] trace_hardirqs_on+0xdd/0xfd
       [<c01619e7>] __user_walk_fd+0x37/0x3f
       [<c016f58a>] sys_lsetxattr+0x37/0x4a
       [<c010492b>] restore_nocheck+0x12/0x15
       [<c01122d0>] do_page_fault+0x0/0x484
       [<c0130556>] trace_hardirqs_on+0xdd/0xfd
       [<c010492b>] restore_nocheck+0x12/0x15
       [<c0104842>] sysenter_past_esp+0x5f/0xa5
       [<ffffffff>] 0xffffffff

-> #0 (&REISERFS_I(inode)->xattr_sem){----}:
       [<c0131115>] __lock_acquire+0x7f9/0xa83
       [<c01316f2>] lock_acquire+0x4c/0x63
       [<e1ac02fa>] reiserfs_removexattr+0x42/0xbf [reiserfs]
       [<c0291367>] down_write+0x17/0x2f
       [<e1ac02fa>] reiserfs_removexattr+0x42/0xbf [reiserfs]
       [<e1ac02fa>] reiserfs_removexattr+0x42/0xbf [reiserfs]
       [<c016f014>] vfs_removexattr+0x67/0xc2
       [<c016f0ac>] removexattr+0x3d/0x4a
       [<c0292243>] _spin_unlock+0x25/0x3a
       [<c01bfb26>] _atomic_dec_and_lock+0x22/0x2c
       [<c016aeee>] mntput_no_expire+0x11/0x5b
       [<c0160fc2>] link_path_walk+0xa5/0xaf
       [<c010487d>] sysenter_past_esp+0x9a/0xa5
       [<c0130556>] trace_hardirqs_on+0xdd/0xfd
       [<c0155b72>] kmem_cache_free+0x53/0x5a
       [<c0130556>] trace_hardirqs_on+0xdd/0xfd
       [<c01619e7>] __user_walk_fd+0x37/0x3f
       [<c016f114>] sys_lremovexattr+0x2b/0x3c
       [<c010487d>] sysenter_past_esp+0x9a/0xa5
       [<c0130556>] trace_hardirqs_on+0xdd/0xfd
       [<c010487d>] sysenter_past_esp+0x9a/0xa5
       [<c0104842>] sysenter_past_esp+0x5f/0xa5
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by beagled/3781:
 #0:  (&sb->s_type->i_mutex_key#8){--..}, at: [<c016f006>] vfs_removexattr+0x59/0xc2

stack backtrace:
Pid: 3781, comm: beagled Not tainted 2.6.25-rc1 #15
 [<c012fafa>] print_circular_bug_tail+0x56/0x60
 [<c0131115>] __lock_acquire+0x7f9/0xa83
 [<c01316f2>] lock_acquire+0x4c/0x63
 [<e1ac02fa>] reiserfs_removexattr+0x42/0xbf [reiserfs]
 [<c0291367>] down_write+0x17/0x2f
 [<e1ac02fa>] reiserfs_removexattr+0x42/0xbf [reiserfs]
 [<e1ac02fa>] reiserfs_removexattr+0x42/0xbf [reiserfs]
 [<c016f014>] vfs_removexattr+0x67/0xc2
 [<c016f0ac>] removexattr+0x3d/0x4a
 [<c0292243>] _spin_unlock+0x25/0x3a
 [<c01bfb26>] _atomic_dec_and_lock+0x22/0x2c
 [<c016aeee>] mntput_no_expire+0x11/0x5b
 [<c0160fc2>] link_path_walk+0xa5/0xaf
 [<c010487d>] sysenter_past_esp+0x9a/0xa5
 [<c0130556>] trace_hardirqs_on+0xdd/0xfd
 [<c0155b72>] kmem_cache_free+0x53/0x5a
 [<c0130556>] trace_hardirqs_on+0xdd/0xfd
 [<c01619e7>] __user_walk_fd+0x37/0x3f
 [<c016f114>] sys_lremovexattr+0x2b/0x3c
 [<c010487d>] sysenter_past_esp+0x9a/0xa5
 [<c0130556>] trace_hardirqs_on+0xdd/0xfd
 [<c010487d>] sysenter_past_esp+0x9a/0xa5
 [<c0104842>] sysenter_past_esp+0x5f/0xa5
 =======================

step to reproduce:
- mount /home as reiserfs with user_xattr option.
- run "beagled --fg --debug --indexing-delay 5", and wait 10 seconds.


~~
laurent
