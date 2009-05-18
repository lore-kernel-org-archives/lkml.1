Return-Path: <linux-kernel-owner+w=401wt.eu-S1753007AbZERSqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbZERSqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 14:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbZERSqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 14:46:45 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46245 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbZERSqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 14:46:43 -0400
Subject: Re: [Jfs-discussion] JFS locking problem detected (kernel 2.6.30)
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: jfs-discussion@lists.sourceforge.net, LKLM <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20090517174828.7777a54c.krzysztof.h1@wp.pl>
References: <20090517174828.7777a54c.krzysztof.h1@wp.pl>
Content-Type: text/plain
Date: Mon, 18 May 2009 13:46:20 -0500
Message-Id: <1242672380.7853.6.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-17 at 17:48 +0200, Krzysztof Helt wrote:
> Hi,
> 
> The problem log is attached below. It happened with current 2.6.30-rc6 kernel.
> 
> It happens with heavy disk IO. It is easy to trigger with kernel compilation in one 
> console and git operations on the same tree in another.

The lockdep stuff still confuses me, as I'm not spending as much time in
the file system as I used to.  Suggestions from linux-fsdevel &
elsewhere are appreciated.  :-)

> Regards,
> Krzysztof
> 
> =================================
> [ INFO: inconsistent lock state ]
> 2.6.30-rc6 #60
> ---------------------------------
> inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
> kswapd0/181 [HC0[0]:SC0[0]:HE1:SE1] takes:
>  (&jfs_ip->rdwrlock#2){++++?+}, at: [<c02d8d47>] jfs_get_block+0x47/0x280
> {RECLAIM_FS-ON-W} state was registered at:

Anybody care to explain what this means in English?

>   [<c0241c95>] mark_held_locks+0x55/0x70
>   [<c02421e6>] lockdep_trace_alloc+0x86/0xb0
>   [<c0278cc1>] kmem_cache_alloc+0x21/0xe0
>   [<c031650b>] radix_tree_preload+0x1b/0x60
>   [<c0257351>] add_to_page_cache_locked+0x21/0xb0
>   [<c0257408>] add_to_page_cache_lru+0x28/0x70

read_cache_page_async() calls the static function __read_cache_page(),
which calls add_to_page_cache_lru() with GFP_KERNEL.  Would changing
this to GFP_FS fix the problem?  Are there any downsides to this?  Am I
completely missing the point?

>   [<c02575a8>] read_cache_page_async+0xa8/0x140
>   [<c0257652>] read_cache_page+0x12/0x60
>   [<c02f176e>] __get_metapage+0x10e/0x3f0
>   [<c02e699d>] dbAllocAG+0x12d/0x490
>   [<c02e717b>] dbAlloc+0x1fb/0x590
>   [<c02f05e3>] extAlloc+0x1f3/0x5c0
>   [<c02d8f27>] jfs_get_block+0x227/0x280
>   [<c029d130>] nobh_write_begin+0x130/0x3e0
>   [<c02d876d>] jfs_write_begin+0x3d/0x50
>   [<c02579d2>] generic_file_buffered_write+0xe2/0x2a0
>   [<c0257fe4>] __generic_file_aio_write_nolock+0x244/0x4a0
>   [<c0258506>] generic_file_aio_write+0x66/0xe0
>   [<c027c66c>] do_sync_write+0xcc/0x110
>   [<c027cf26>] vfs_write+0x96/0x140
>   [<c027d3cd>] sys_write+0x3d/0x70
>   [<c0202c65>] syscall_call+0x7/0xb
>   [<ffffffff>] 0xffffffff
> irq event stamp: 852417
> hardirqs last  enabled at (852417): [<c0278d3b>] kmem_cache_alloc+0x9b/0xe0
> hardirqs last disabled at (852416): [<c0278ccf>] kmem_cache_alloc+0x2f/0xe0
> softirqs last  enabled at (851380): [<c0225201>] __do_softirq+0xb1/0x100
> softirqs last disabled at (851371): [<c0225296>] do_softirq+0x46/0x50
> 
> other info that might help us debug this:
> no locks held by kswapd0/181.

maybe, but I don't really understand what the warning is trying to tell
me.

> stack backtrace:
> Pid: 181, comm: kswapd0 Tainted: G        W  2.6.30-rc6 #60
> Call Trace:
>  [<c0241646>] print_usage_bug+0x166/0x1b0
>  [<c0241c05>] mark_lock+0x575/0x5b0
>  [<c0243169>] ? validate_chain+0xe9/0xfd0
>  [<c02455e0>] ? check_usage_forwards+0x0/0xa0
>  [<c02444a0>] __lock_acquire+0x450/0x9e0
>  [<c0244aa4>] lock_acquire+0x74/0xa0
>  [<c02d8d47>] ? jfs_get_block+0x47/0x280
>  [<c02375ae>] down_write_nested+0x4e/0x70
>  [<c02d8d47>] ? jfs_get_block+0x47/0x280
>  [<c02d8d47>] jfs_get_block+0x47/0x280
>  [<c044e41d>] ? _spin_unlock+0x1d/0x20
>  [<c029a287>] ? create_empty_buffers+0x77/0x90
>  [<c029bb63>] __block_write_full_page+0xe3/0x310
>  [<c02d8d00>] ? jfs_get_block+0x0/0x280
>  [<c029be57>] block_write_full_page_endio+0xc7/0xe0
>  [<c029cac0>] ? end_buffer_async_write+0x0/0x160
>  [<c02d8d00>] ? jfs_get_block+0x0/0x280
>  [<c0241de2>] ? trace_hardirqs_on_caller+0x132/0x180
>  [<c029be82>] block_write_full_page+0x12/0x20
>  [<c029cac0>] ? end_buffer_async_write+0x0/0x160
>  [<c02d87df>] jfs_writepage+0xf/0x20
>  [<c02612ff>] shrink_page_list+0x30f/0x630
>  [<c02605c0>] ? isolate_pages_global+0x0/0x1f0
>  [<c02617da>] shrink_list+0x1ba/0x490
>  [<c0244309>] ? __lock_acquire+0x2b9/0x9e0
>  [<c0261d18>] shrink_zone+0x268/0x2e0
>  [<c02626b6>] kswapd+0x4d6/0x510
>  [<c02605c0>] ? isolate_pages_global+0x0/0x1f0
>  [<c02339d0>] ? autoremove_wake_function+0x0/0x40
>  [<c02621e0>] ? kswapd+0x0/0x510
>  [<c023372a>] kthread+0x4a/0x80
>  [<c02336e0>] ? kthread+0x0/0x80
>  [<c0203477>] kernel_thread_helper+0x7/0x10

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

