Return-Path: <linux-kernel-owner+w=401wt.eu-S1758386AbZDSJg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386AbZDSJg0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 05:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZDSJgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 05:36:16 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:58351 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbZDSJgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 05:36:14 -0400
Message-ID: <49EAF08A.2020407@in.ibm.com>
Date: Sun, 19 Apr 2009 15:06:10 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13068] Lockdep warining in inotify_dev_queue_event
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <nY3-4PrO6XH.A.4dB.pw85JB@chimera>
In-Reply-To: <nY3-4PrO6XH.A.4dB.pw85JB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13068
> Subject		: Lockdep warining in inotify_dev_queue_event
> Submitter	: Sachin Sant <sachinp@in.ibm.com>
> Date		: 2009-04-05 12:37 (12 days old)
> References	: http://marc.info/?l=linux-kernel&m=123893439229272&w=4
>   
I can recreate this with latest kernel. Easiest way is to use the LTP mm 
tests (runltp -f mm )

=================================
[ INFO: inconsistent lock state ]
2.6.30-rc2-git4 #4
---------------------------------
inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
kswapd0/334 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&inode->inotify_mutex){+.+.?.}, at: [<c000000000166cc0>] 
.inotify_inode_is_dead+0x38/0xc8
{RECLAIM_FS-ON-W} state was registered at:
  [<c000000000098d74>] .lockdep_trace_alloc+0xc4/0xf4
  [<c000000000122128>] .__kmalloc+0x100/0x274
  [<c0000000001682fc>] .kernel_event+0xb8/0x154
  [<c0000000001684b8>] .inotify_dev_queue_event+0x120/0x1cc
  [<c000000000166b2c>] .inotify_inode_queue_event+0xf0/0x160
  [<c000000000139c08>] .vfs_create+0x170/0x1dc
  [<c00000000013d5c0>] .do_filp_open+0x25c/0x964
  [<c00000000012b414>] .do_sys_open+0x80/0x140
  [<c00000000012b2f0>] .SyS_creat+0x18/0x2c
  [<c000000000008554>] syscall_exit+0x0/0x40
irq event stamp: 75815
hardirqs last  enabled at (75815): [<c0000000000cb824>] 
.__call_rcu+0x128/0x15c
hardirqs last disabled at (75814): [<c0000000000cb748>] 
.__call_rcu+0x4c/0x15c
softirqs last  enabled at (73084): [<c00000000002be8c>] 
.call_do_softirq+0x14/0x24
softirqs last disabled at (73071): [<c00000000002be8c>] 
.call_do_softirq+0x14/0x24

other info that might help us debug this:
2 locks held by kswapd0/334:
 #0:  (shrinker_rwsem){++++..}, at: [<c0000000000f57c8>] 
.shrink_slab+0x5c/0x228
 #1:  (&type->s_umount_key#15){++++..}, at: [<c000000000142f00>] 
.shrink_dcache_memory+0xfc/0x244

stack backtrace:
Call Trace:
[c00000004473b440] [c000000000011a54] .show_stack+0x6c/0x16c (unreliable)
[c00000004473b4f0] [c0000000000984d8] .print_usage_bug+0x1c0/0x1f4
[c00000004473b5b0] [c00000000009888c] .mark_lock+0x380/0x6e4
[c00000004473b660] [c00000000009a99c] .__lock_acquire+0x7a8/0x17b4
[c00000004473b760] [c00000000009bab0] .lock_acquire+0x108/0x154
[c00000004473b820] [c0000000005a8bac] .mutex_lock_nested+0x88/0x460
[c00000004473b920] [c000000000166cc0] .inotify_inode_is_dead+0x38/0xc8
[c00000004473b9d0] [c0000000001427f4] .dentry_iput+0xa0/0x128
[c00000004473ba60] [c0000000001429f0] .d_kill+0x5c/0xa0
[c00000004473baf0] [c000000000142d38] .__shrink_dcache_sb+0x304/0x3d0
[c00000004473bbd0] [c000000000142f48] .shrink_dcache_memory+0x144/0x244
[c00000004473bcb0] [c0000000000f58c8] .shrink_slab+0x15c/0x228
[c00000004473bd70] [c0000000000f61a4] .kswapd+0x4c0/0x678
[c00000004473bf00] [c000000000088ba4] .kthread+0x80/0xcc
[c00000004473bf90] [c00000000002c194] .kernel_thread+0x54/0x70

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

