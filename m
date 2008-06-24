Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbYFXFyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbYFXFyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 01:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbYFXFyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 01:54:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbYFXFyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 01:54:08 -0400
Date: Tue, 24 Jun 2008 01:54:05 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
cc: davem@davemloft.net
Subject: [10 PATCHES] inline functions to avoid stack overflow
Message-ID: <Pine.LNX.4.64.0806240136200.27784@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here I'm sending 10 patches to inline various functions.

To give you some understanding of sparc64, every function there uses big 
stack frame (at least 192 bytes). 128 bytes are required by architecture 
(16 64-bit registers), 48 bytes are there due to mistake of Sparc64 ABI 
designers (calling function has to allocate 48 bytes for called function) 
and 16 bytes are some dubious padding.

So, on sparc64, if you have a simple function that passes arguments to 
other function it still takes 192 byte --- regardless of how simple the 
function is. Tail-call may be used, but it is disabled in kernel if 
debugging is enabled (Makefile: ifdef CONFIG_FRAME_POINTER
KBUILD_CFLAGS += -fno-omit-frame-pointer -fno-optimize-sibling-calls).

The stack trace has 75 nested functions, that totals to at least 14400 
bytes --- and it kills the 16k stack space on sparc. In the stack trace, 
there are many function which do nothing but pass parameters to other 
function. In this series of patches, I found 10 such functions and turned 
them to inlines, saving 1920 bytes. Especially waking wait queue is bad, 
it calls 8 nested functions, 7 of which do nothing. I turned 5 of them to 
inline.

I'll post those 10 patches in next emails.

Some of the patches fix cases that could be optimized with tail-calling. 
If you want to drop the patches, you should enable tail-calling by 
removing -fno-optimize-sibling-calls from Makefile (it makes debugging a 
bit harder).

This was the trace:

linux_sparc_syscall32
sys_read
vfs_read
do_sync_read
generic_file_aio_read
generic_file_direct_io
filemap_write_and_wait
filemap_fdatawrite
__filemap_fdatawrite_range
do_writepages
generic_writepages
write_cache_pages
__writepage
blkdev_writepage
block_write_full_page
__block_write_fiull_page
submit_bh
submit_bio
generic_make_request
dm_request
__split_bio
__map_bio
origin_map
start_copy
dm_kcopyd_copy
dispatch_job
wake
queue_work
__queue_work
__spin_unlock_irqrestore
sys_call_table
timer_interrupt
irq_exit
do_softirq
__do_softirq
run_timer_softirq
__spin_unlock_irq
sys_call_table
handler_irq
handler_fasteoi_irq
handle_irq_event
ide_intr
ide_dma_intr
task_end_request
ide_end_request
__ide_end_request
__blk_end_request
__end_that_request_first
req_bio_endio
bio_endio
clone_endio
dec_pending
bio_endio
clone_endio
dec_pending
bio_endio
clone_endio
dec_pending
bio_endio
end_bio_bh_io_sync
end_buffer_read_sync
__end_buffer_read_notouch
unlock_buffer
wake_up_bit
__wake_up_bit
__wake_up
__wake_up_common
wake_bio_function
autoremove_wake_function
default_wake_function
try_to_wake_up
task_rq_lock
__spin_lock
lock_acquire
__lock_acquire
*** crash ***
