Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbZCDN21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbZCDN21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 08:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbZCDN2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 08:28:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44552 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZCDN2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 08:28:15 -0500
Subject: Re: lockdep warning with 2.6.29-rc6-mm1 (mmotm 24-feb-2009)
From: Peter Zijlstra <peterz@infradead.org>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Eric Paris <eparis@redhat.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20090304125709.GA6251@balbir.in.ibm.com>
References: <20090304125709.GA6251@balbir.in.ibm.com>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 14:27:47 +0100
Message-Id: <1236173267.5330.7487.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 18:27 +0530, Balbir Singh wrote:
> I see the following on my machine. My understanding is that the
> lockdep warning is complaining about a potential deadlock while
> reclaiming, where we could end up waiting on holding inotify_mutex,
> and we could end up calling reclaim with inotify_mutex held.
> 
> The race seems rare, since one path shows a new inode being created
> and the other one being deleted. It seems like a false positive unless
> the inode's in question turn out to be potentially the same.

Its not a false positive until you can guarantee the inodes will _never_
be the same.

This thing has been reported numerous times, Ingo even posted a
potential fix for it, Nick poked the inotify people to speak up, but
they have so far been silent on the issue :-(

Eric, can you help us out?, you seem to be the one who touched it
last :-)

If this is an inode life-time thingy, where there is a clear distinction
between active inodes and inactive (ready to be reclaimed) inodes, the
proper annotation would be to move inode->inotify->mutex in a different
class whenever this transition takes place.

[ small note to everybody mailing lockdep splats, please don't word
  wrap them ]

> =================================
> [ INFO: inconsistent lock state ]
> 2.6.29-rc6-mm1-g3d748a4-dirty #36
> ---------------------------------
> inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
> yum-updatesd-he/4004 [HC0[0]:SC0[0]:HE1:SE1] takes:
>  (&inode->inotify_mutex){+.+.?.}, at: [<ffffffff802e70fd>] inotify_inode_queue_event+0x4f/0xe0
> {IN-RECLAIM_FS-W} state was registered at:
>   [<ffffffff802630e5>] __lock_acquire+0x640/0x7ec
>   [<ffffffff80263316>] lock_acquire+0x85/0xa9
>   [<ffffffff805dc50b>] mutex_lock_nested+0x5b/0x2d9
>   [<ffffffff802e71f1>] inotify_inode_is_dead+0x29/0x90
>   [<ffffffff802ce797>] dentry_iput+0x7c/0xbb
>   [<ffffffff802ce8ca>] d_kill+0x50/0x71
>   [<ffffffff802ceb07>] __shrink_dcache_sb+0x21c/0x2c3
>   [<ffffffff802cecbb>] shrink_dcache_memory+0xfe/0x18e
>   [<ffffffff8029585d>] shrink_slab+0x114/0x192
>   [<ffffffff8029650c>] kswapd+0x38b/0x593
>   [<ffffffff8025413a>] kthread+0x88/0x92
>   [<ffffffff8020ce1a>] child_rip+0xa/0x20
>   [<ffffffffffffffff>] 0xffffffffffffffff
> irq event stamp: 220969
> hardirqs last  enabled at (220969): [<ffffffff802b6a53>] kmem_cache_alloc+0xa2/0xca
> hardirqs last disabled at (220968): [<ffffffff802b66dd>] __slab_alloc+0x1fa/0x3ed
> softirqs last  enabled at (219310): [<ffffffff80245683>] __do_softirq+0x16e/0x17b
> softirqs last disabled at (219305): [<ffffffff8020cf1c>] call_softirq+0x1c/0x34
> 
> other info that might help us debug this:
> 4 locks held by yum-updatesd-he/4004:
>  #0:  (&type->i_mutex_dir_key#4){+.+.+.}, at: [<ffffffff802caba8>] do_filp_open+0x181/0x7cf
>  #1:  (&inode->inotify_mutex){+.+.?.}, at: [<ffffffff802e70fd>] inotify_inode_queue_event+0x4f/0xe0
>  #2:  (&ih->mutex){+.+...}, at: [<ffffffff802e712b>] inotify_inode_queue_event+0x7d/0xe0
>  #3:  (&dev->ev_mutex){+.+...}, at: [<ffffffff802e8087>] inotify_dev_queue_event+0x36/0x155
> 
> stack backtrace:
> Pid: 4004, comm: yum-updatesd-he Not tainted
> 2.6.29-rc6-mm1-g3d748a4-dirty #36
> Call Trace:
>  [<ffffffff8025ffe9>] print_usage_bug+0x1b6/0x1c7
>  [<ffffffff802616b8>] ? check_usage_backwards+0x0/0x9e
>  [<ffffffff802602ff>] mark_lock+0x305/0x58c
>  [<ffffffff802e7fe5>] ? kernel_event+0xaa/0x116
>  [<ffffffff802605cf>] mark_held_locks+0x49/0x69
>  [<ffffffff8026120c>] lockdep_trace_alloc+0x75/0x77
>  [<ffffffff802b82e0>] __kmalloc+0x61/0x10a
>  [<ffffffff802e7fe5>] kernel_event+0xaa/0x116
>  [<ffffffff802e812b>] inotify_dev_queue_event+0xda/0x155
>  [<ffffffff802e7159>] inotify_inode_queue_event+0xab/0xe0
>  [<ffffffff802c8671>] vfs_create+0xb3/0xc3
>  [<ffffffff802cac6f>] do_filp_open+0x248/0x7cf
>  [<ffffffff802d3649>] ? alloc_fd+0x10f/0x11e
>  [<ffffffff805ddd66>] ? _spin_unlock+0x26/0x2a
>  [<ffffffff802be6f8>] do_sys_open+0x53/0xda
>  [<ffffffff802be7a8>] sys_open+0x1b/0x1d
>  [<ffffffff8020bddb>] system_call_fastpath+0x16/0x1b


