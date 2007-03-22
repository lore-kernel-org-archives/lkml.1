Return-Path: <linux-kernel-owner+w=401wt.eu-S965636AbXCVDtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965636AbXCVDtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 23:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965640AbXCVDtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 23:49:13 -0400
Received: from smtp.osdl.org ([65.172.181.24]:37592 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965636AbXCVDtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 23:49:11 -0400
Date: Wed, 21 Mar 2007 20:45:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [1/6] 2.6.21-rc4: known regressions
In-Reply-To: <20070318184908.GU752@stusta.de>
Message-ID: <Pine.LNX.4.64.0703212023550.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
 <20070318184908.GU752@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 18 Mar 2007, Adrian Bunk wrote:
> 
> Subject    : weird system hangs
> References : http://lkml.org/lkml/2007/3/16/288
> Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
>              Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> Status     : unknown

According to the console log, it seems to be hung because a lot of 
processes are stuck in D state in various variations of this:

	Call Trace:
	 [<c01ba134>] start_this_handle+0x2d7/0x355
	 [<c01ba265>] journal_start+0xb3/0xe1
	 [<c01b2837>] ext3_journal_start_sb+0x48/0x4a
	 [<c01b0924>] ext3_create+0x47/0xe2
	 [<c017820c>] vfs_create+0xcd/0x13e
	 [<c017ab6e>] open_namei+0x176/0x5b5
	 [<c0170026>] do_filp_open+0x26/0x3b
	 [<c017007e>] do_sys_open+0x43/0xc2
	 [<c0170135>] sys_open+0x1c/0x1e
	 [<c0104064>] syscall_call+0x7/0xb

and then you have "kget" (whatever that is) which is doing

	Call Trace:
	 [<c0318981>] schedule_timeout+0x70/0x8e
	 [<c03189b4>] schedule_timeout_uninterruptible+0x15/0x17
	 [<c01b964a>] journal_stop+0xe2/0x1e6
	 [<c01ba2b0>] journal_force_commit+0x1d/0x1f
	 [<c01b29fb>] ext3_force_commit+0x22/0x24
	 [<c01ad607>] ext3_write_inode+0x34/0x3a
	 [<c0189f74>] __writeback_single_inode+0x1c5/0x2cb
	 [<c018a096>] sync_inode+0x1c/0x2e
	 [<c01a9ff7>] ext3_sync_file+0xab/0xc0
	 [<c018c8c5>] do_fsync+0x4b/0x98
	 [<c018c932>] __do_fsync+0x20/0x2f
	 [<c018c951>] sys_fdatasync+0x10/0x12
	 [<c0104064>] syscall_call+0x7/0xb

with kjournald in D sleep at

	 [<c01bb7b2>] journal_commit_transaction+0x15d/0x11d3
	 [<c01bfcbe>] kjournald+0xab/0x1e8
	 [<c01333dd>] kthread+0xb5/0xe0
	 [<c0104cd3>] kernel_thread_helper+0x7/0x10

which certainly looks like something is waiting for an IO to finish.

In contrast, the hang reported by Mariusz Kozlowski has a slightly 
different feel to it, but there's a tantalizing pattern in there too:

  http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/1243.html

	Call Trace:
	[<c03ec87e>] io_schedule+0x42/0x59
	[<c0184915>] sleep_on_buffer+0x8/0xc
	[<c03ed217>] __wait_on_bit+0x47/0x6c
	[<c03ed297>] out_of_line_wait_on_bit+0x5b/0x64
	[<c01848a8>] __wait_on_buffer+0x27/0x2d
	[<c01b4228>] journal_commit_transaction+0x707/0x127f
	[<c01b868b>] kjournald+0xac/0x1ed
	[<c0126af5>] kthread+0xa2/0xc9
	[<c010422b>] kernel_thread_helper+0x7/0x1c

which certainly also looks like an IO never completed (or completed but 
never woke anything up).

It also seems to be related to *buffers*. Maybe the whole bh layer thing 
is a fluke, but it's not waiting for normal data, it's very much waiting 
for those journal things that all use buffer heads.Which just makes me 
worry about those patches by Nick (which did come in through Andrew). I 
don't think it's the memorder one (it looks safe and shouldn't matter on 
x86 anyway!), but what about the

	fs: fix __block_write_full_page error case buffer submission

locking change for example? Or that "fs: fix nobh data leak" thing with 
its fix? It uses "SetPageUptodate(page);" without waking up anybody who 
might wait for it (but the waiters here seem to wait on buffers, so that's 
probably not it)..

Alternatively, maybe it really is an _io_ problem (and the buffer-head 
thing is just a red herring, and it could happen to other IO, it's just 
that metadata IO uses buffer heads), and it's the scheduler changes since 
2.6.20..

Jens, Nick.. Could you take a look?

		Linus
