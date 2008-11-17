Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbYKQUeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbYKQUeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 15:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbYKQUeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 15:34:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55260 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbYKQUeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 15:34:16 -0500
Date: Mon, 17 Nov 2008 15:34:13 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Large stack usage in fs code (especially for PPC64)
Message-ID: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've been hitting stack overflows on a PPC64 box, so I ran the ftrace 
stack_tracer and part of the problem with that box is that it can nest 
interrupts too deep. But what also worries me is that there's some heavy 
hitters of stacks in generic code. Namely the fs directory has some.

Here's the full dump of the stack (PPC64):

root@electra ~> cat /debug/tracing/stack_trace 
        Depth   Size      Location    (56 entries)
        -----   ----      --------
  0)    14032     112   ftrace_call+0x4/0x14
  1)    13920     128   .sched_clock+0x20/0x60
  2)    13792     128   .sched_clock_cpu+0x34/0x50
  3)    13664     144   .cpu_clock+0x3c/0xa0
  4)    13520     144   .get_timestamp+0x2c/0x50
  5)    13376     192   .softlockup_tick+0x100/0x220
  6)    13184     128   .run_local_timers+0x34/0x50
  7)    13056     160   .update_process_times+0x44/0xb0
  8)    12896     176   .tick_sched_timer+0x8c/0x120
  9)    12720     160   .__run_hrtimer+0xd8/0x130
 10)    12560     240   .hrtimer_interrupt+0x16c/0x220
 11)    12320     160   .timer_interrupt+0xcc/0x110
 12)    12160     240   decrementer_common+0xe0/0x100
 13)    11920     576   0x80
 14)    11344     160   .usb_hcd_irq+0x94/0x150
 15)    11184     160   .handle_IRQ_event+0x80/0x120
 16)    11024     160   .handle_fasteoi_irq+0xd8/0x1e0
 17)    10864     160   .do_IRQ+0xbc/0x150
 18)    10704     144   hardware_interrupt_entry+0x1c/0x3c
 19)    10560     672   0x0
 20)     9888     144   ._spin_unlock_irqrestore+0x84/0xd0
 21)     9744     160   .scsi_dispatch_cmd+0x170/0x360
 22)     9584     208   .scsi_request_fn+0x324/0x5e0
 23)     9376     144   .blk_invoke_request_fn+0xc8/0x1b0
 24)     9232     144   .__blk_run_queue+0x48/0x60
 25)     9088     144   .blk_run_queue+0x40/0x70
 26)     8944     192   .scsi_run_queue+0x3a8/0x3e0
 27)     8752     160   .scsi_next_command+0x58/0x90
 28)     8592     176   .scsi_end_request+0xd4/0x130
 29)     8416     208   .scsi_io_completion+0x15c/0x500
 30)     8208     160   .scsi_finish_command+0x15c/0x190
 31)     8048     160   .scsi_softirq_done+0x138/0x1e0
 32)     7888     160   .blk_done_softirq+0xd0/0x100
 33)     7728     192   .__do_softirq+0xe8/0x1e0
 34)     7536     144   .do_softirq+0xa4/0xd0
 35)     7392     144   .irq_exit+0xb4/0xf0
 36)     7248     160   .do_IRQ+0x114/0x150
 37)     7088     752   hardware_interrupt_entry+0x1c/0x3c
 38)     6336     144   .blk_rq_init+0x28/0xc0
 39)     6192     208   .get_request+0x13c/0x3d0
 40)     5984     240   .get_request_wait+0x60/0x170
 41)     5744     192   .__make_request+0xd4/0x560
 42)     5552     192   .generic_make_request+0x210/0x300
 43)     5360     208   .submit_bio+0x168/0x1a0
 44)     5152     160   .submit_bh+0x188/0x1e0
 45)     4992    1280   .block_read_full_page+0x23c/0x430
 46)     3712    1280   .do_mpage_readpage+0x43c/0x740
 47)     2432     352   .mpage_readpages+0x130/0x1c0
 48)     2080     160   .ext3_readpages+0x50/0x80
 49)     1920     256   .__do_page_cache_readahead+0x1e4/0x340
 50)     1664     160   .do_page_cache_readahead+0x94/0xe0
 51)     1504     240   .filemap_fault+0x360/0x530
 52)     1264     256   .__do_fault+0xb8/0x600
 53)     1008     240   .handle_mm_fault+0x190/0x920
 54)      768     320   .do_page_fault+0x3d4/0x5f0
 55)      448     448   handle_page_fault+0x20/0x5c


Notice at line 45 and 46 the stack usage of block_read_full_page and 
do_mpage_readpage. They each use 1280 bytes of stack! Looking at the start 
of these two:

int block_read_full_page(struct page *page, get_block_t *get_block)
{
	struct inode *inode = page->mapping->host;
	sector_t iblock, lblock;
	struct buffer_head *bh, *head, *arr[MAX_BUF_PER_PAGE];
	unsigned int blocksize;
	int nr, i;
	int fully_mapped = 1;
[...]

static struct bio *
do_mpage_readpage(struct bio *bio, struct page *page, unsigned nr_pages,
		sector_t *last_block_in_bio, struct buffer_head *map_bh,
		unsigned long *first_logical_block, get_block_t get_block)
{
	struct inode *inode = page->mapping->host;
	const unsigned blkbits = inode->i_blkbits;
	const unsigned blocks_per_page = PAGE_CACHE_SIZE >> blkbits;
	const unsigned blocksize = 1 << blkbits;
	sector_t block_in_file;
	sector_t last_block;
	sector_t last_block_in_file;
	sector_t blocks[MAX_BUF_PER_PAGE];
	unsigned page_block;
	unsigned first_hole = blocks_per_page;
	struct block_device *bdev = NULL;
	int length;
	int fully_mapped = 1;
	unsigned nblocks;
	unsigned relative_block;


The thing that hits my eye on both is the MAX_BUF_PER_PAGE usage. That is 
defined as: 

define MAX_BUF_PER_PAGE (PAGE_CACHE_SIZE / 512)

Where PAGE_CACHE_SIZE is the same as PAGE_SIZE.

On PPC64 I'm told that the page size is 64K, which makes the above equal 
to: 64K / 512 = 128  multiply that by 8 byte words, we have 1024 bytes.

The problem with PPC64 is that the stack size is not equal to the page 
size. The stack size is only 16K not 64K.

The above stack trace was taken right after boot up and it was already at 
14K, not too far from the 16k limit.

Note, I was using a default config that had CONFIG_IRQSTACKS off and
CONFIG_PPC_64K_PAGES on.

-- Steve


