Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbYA2UL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbYA2UL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 15:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764631AbYA2ULn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 15:11:43 -0500
Received: from brick.kernel.dk ([87.55.233.238]:7717 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106AbYA2ULl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 15:11:41 -0500
Date: Tue, 29 Jan 2008 21:11:36 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org
Subject: Re: system hang on latest git
Message-ID: <20080129201136.GX15220@kernel.dk>
References: <1FE6DD409037234FAB833C420AA843EC75736A@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FE6DD409037234FAB833C420AA843EC75736A@orsmsx424.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29 2008, Luck, Tony wrote:
> I pulled Linus' tree this morning (git head = 0ba6c33bcddc64a54b5f1c25a696c4767dc76292)
> and built for ia64 (using arch/ia64/configs/tiger_defconfig).   System booted
> OK, but when I stressed it a little (building another kernel with "make -j32")
> it hung.
> 
> The console has a bunch (98) of warnings about tasks blocked for more than 120
> seconds like this:
> INFO: task grep:9168 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> 
> Call Trace:
>  [<a000000100704120>] schedule+0x11c0/0x1340
>                                 sp=e0000001ed8afbf0 bsp=e0000001ed8a1280
>  [<a00000010024e720>] do_get_write_access+0x660/0xbe0
>                                 sp=e0000001ed8afc20 bsp=e0000001ed8a1208
>  [<a00000010024f060>] journal_get_write_access+0x40/0x80
>                                 sp=e0000001ed8afca0 bsp=e0000001ed8a11c8
>  [<a000000100245db0>] __ext3_journal_get_write_access+0x30/0xa0
>                                 sp=e0000001ed8afca0 bsp=e0000001ed8a1190
>  [<a00000010022dea0>] ext3_reserve_inode_write+0x80/0x120
>                                 sp=e0000001ed8afca0 bsp=e0000001ed8a1158
>  [<a00000010022df70>] ext3_mark_inode_dirty+0x30/0x80
>                                 sp=e0000001ed8afca0 bsp=e0000001ed8a1130
>  [<a000000100232530>] ext3_dirty_inode+0xd0/0x120
>                                 sp=e0000001ed8afcc0 bsp=e0000001ed8a1100
>  [<a000000100170e20>] __mark_inode_dirty+0xa0/0x3e0
>                                 sp=e0000001ed8afcc0 bsp=e0000001ed8a10b0
>  [<a00000010015b570>] touch_atime+0x310/0x340
>                                 sp=e0000001ed8afcc0 bsp=e0000001ed8a1088
>  [<a0000001000d6c20>] do_generic_mapping_read+0x780/0x7a0
>                                 sp=e0000001ed8afce0 bsp=e0000001ed8a0fe0
>  [<a0000001000db250>] generic_file_aio_read+0x290/0x340
>                                 sp=e0000001ed8afce0 bsp=e0000001ed8a0f80
>  [<a00000010012c990>] do_sync_read+0x170/0x200
>                                 sp=e0000001ed8afd10 bsp=e0000001ed8a0f40
>  [<a00000010012cbd0>] vfs_read+0x1b0/0x2e0
>                                 sp=e0000001ed8afe20 bsp=e0000001ed8a0ef0
>  [<a00000010012d250>] sys_read+0x70/0xe0
>                                 sp=e0000001ed8afe20 bsp=e0000001ed8a0e78
>  [<a00000010000a4a0>] ia64_ret_from_syscall+0x0/0x20
>                                 sp=e0000001ed8afe30 bsp=e0000001ed8a0e78
> 
> 
> [The stack trace has several variations ... some from sys_read(), some from
> sys_open(), some from sys_execve(), some from sys_mmap() etc. 84/98 stack
> traces pass through the touch_atime->__mark_inode_dirty path ... all 98
> are attached]
> 
> A quick dig into processor state shows 8 cpus are idle.  7 are spinning
> in __spin_lock_irq() from __make_request() and one is in spin_lock() from
> as_merged_requests().

Looks like a deadlock on queue lock and ioc lock, but I don't see
immediately what the problem is. I can't stick around for longer
tonight, but I'll get to the bottom of this tomorrow.

-- 
Jens Axboe

