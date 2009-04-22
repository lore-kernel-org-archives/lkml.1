Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbZDVJvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbZDVJvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 05:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbZDVJu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 05:50:56 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:59230 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbZDVJuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 05:50:55 -0400
Message-ID: <49EEE873.10805@in.ibm.com>
Date: Wed, 22 Apr 2009 15:20:43 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, peterz@infradead.org
Subject: Re: [Bug #13068] Lockdep warning in inotify_dev_queue_event
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <nY3-4PrO6XH.A.4dB.pw85JB@chimera>
In-Reply-To: <nY3-4PrO6XH.A.4dB.pw85JB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13068
> Subject		: Lockdep warining in inotify_dev_queue_event
> Submitter	: Sachin Sant <sachinp@in.ibm.com>
> Date		: 2009-04-05 12:37 (12 days old)
> References	: http://marc.info/?l=linux-kernel&m=123893439229272&w=4
I can recreate this with 2.6.30-rc3 as well.

=================================
[ INFO: inconsistent lock state ]
2.6.30-rc3 #1
---------------------------------
inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
inotify02/31550 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&inode->inotify_mutex){+.+.?.}, at: [<c0000000001668ec>] 
.inotify_inode_queue_event+0x6c/0x160
{IN-RECLAIM_FS-W} state was registered at:
  [<c00000000009bb1c>] .lock_acquire+0x108/0x154
  [<c0000000005a8be4>] .mutex_lock_nested+0x88/0x460
  [<c000000000166b04>] .inotify_inode_is_dead+0x38/0xc8
  [<c000000000142708>] .dentry_iput+0xa0/0x128
  [<c000000000142904>] .d_kill+0x5c/0xa0
  [<c000000000142c4c>] .__shrink_dcache_sb+0x304/0x3d0
  [<c000000000142e5c>] .shrink_dcache_memory+0x144/0x244
  [<c0000000000f580c>] .shrink_slab+0x15c/0x228
  [<c0000000000f60f8>] .kswapd+0x4c4/0x67c
  [<c000000000088ba4>] .kthread+0x80/0xcc
  [<c00000000002c194>] .kernel_thread+0x54/0x70
irq event stamp: 2267
hardirqs last  enabled at (2267): [<c000000000120490>] 
.kmem_cache_alloc+0xec/0x1b4
hardirqs last disabled at (2266): [<c000000000120418>] 
.kmem_cache_alloc+0x74/0x1b4
softirqs last  enabled at (1654): [<c00000000002be8c>] 
.call_do_softirq+0x14/0x24
softirqs last disabled at (1639): [<c00000000002be8c>] 
.call_do_softirq+0x14/0x24

other info that might help us debug this:
4 locks held by inotify02/31550:
 #0:  (&type->i_mutex_dir_key#4){+.+.+.}, at: [<c00000000013d41c>] 
.do_filp_open+0x1a4/0x964
 #1:  (&inode->inotify_mutex){+.+.?.}, at: [<c0000000001668ec>] 
.inotify_inode_queue_event+0x6c/0x160
 #2:  (&ih->mutex){+.+...}, at: [<c000000000166920>] 
.inotify_inode_queue_event+0xa0/0x160
 #3:  (&dev->ev_mutex){+.+...}, at: [<c00000000016822c>] 
.inotify_dev_queue_event+0x50/0x1cc

stack backtrace:
Call Trace:
[c00000001816b4b0] [c000000000011a54] .show_stack+0x6c/0x16c (unreliable)
[c00000001816b560] [c000000000098544] .print_usage_bug+0x1c0/0x1f4
[c00000001816b620] [c0000000000988f8] .mark_lock+0x380/0x6e4
[c00000001816b6d0] [c000000000098cd0] .mark_held_locks+0x74/0xc0
[c00000001816b770] [c000000000098de0] .lockdep_trace_alloc+0xc4/0xf4
[c00000001816b7f0] [c000000000122090] .__kmalloc+0x100/0x274
[c00000001816b8a0] [c000000000168140] .kernel_event+0xb8/0x154
[c00000001816b940] [c0000000001682fc] .inotify_dev_queue_event+0x120/0x1cc
[c00000001816b9f0] [c000000000166970] .inotify_inode_queue_event+0xf0/0x160
[c00000001816bac0] [c000000000139acc] .vfs_create+0x170/0x1dc
[c00000001816bb60] [c00000000013d4d4] .do_filp_open+0x25c/0x964
[c00000001816bd10] [c00000000012b37c] .do_sys_open+0x80/0x140
[c00000001816bdc0] [c00000000012b258] .SyS_creat+0x18/0x2c
[c00000001816be30] [c000000000008554] syscall_exit+0x0/0x40

Let me know if i could provide any other information.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

