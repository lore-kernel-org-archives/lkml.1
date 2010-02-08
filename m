Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab0BHOIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 09:08:40 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:40056 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab0BHOIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 09:08:38 -0500
Date: Mon, 8 Feb 2010 15:08:37 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kswapd continuously active
Message-ID: <20100208140837.GN1025@kernel.dk>
References: <alpine.LSU.2.01.1001230037350.20442@obet.zrqbmnf.qr> <20100125130627.GO13771@kernel.dk> <alpine.LSU.2.01.1001251416340.8189@obet.zrqbmnf.qr> <alpine.LSU.2.01.1002051329090.7843@obet.zrqbmnf.qr> <20100205130002.GI1025@kernel.dk> <alpine.LSU.2.01.1002051408280.23211@obet.zrqbmnf.qr> <20100205131220.GK1025@kernel.dk> <alpine.LSU.2.01.1002051423020.23211@obet.zrqbmnf.qr> <alpine.LSU.2.01.1002071148150.26546@obet.zrqbmnf.qr> <alpine.LSU.2.01.1002080106240.11078@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LSU.2.01.1002080106240.11078@obet.zrqbmnf.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 08 2010, Jan Engelhardt wrote:
> 
> On Sunday 2010-02-07 11:50, Jan Engelhardt wrote:
> >On Friday 2010-02-05 14:24, Jan Engelhardt wrote:
> >>>> The ext4 filesystem is already mounted with barrier=0. If there
> >>>> is any block-level barriers I also can turn off, what would be
> >>>> the command?
> >>>
> >>>barrier=0 is enough. I do wonder why your writeback rate is that slow,
> >>>then. The disk has write back caching enabled?
> >>
> >>Yes, that seems to be the case at least. In fact the box is all fluffy 
> >>when nobody runs sync(1), which is what makes it so strange.
> >>
> >>sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
> >>support DPO or FUA
> >
> >Here is an alternate trace that just happened.
> >
> >INFO: task flush-8:0:343 blocked for more than 120 seconds.
> >"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >flush-8:0     D 0000000000555930  6664   343      2 0x18000000000
> >Call Trace:
> > [00000000005555f4] start_this_handle+0x324/0x4b0
> > [0000000000555930] jbd2_journal_start+0x94/0xc0
> > [000000000052ddb8] ext4_da_writepages+0x1e0/0x460
> > [000000000049bf30] do_writepages+0x28/0x48
> > [00000000004e6d58] writeback_single_inode+0xf0/0x330
> > [00000000004e7b24] writeback_inodes_wb+0x4c8/0x5d8
> > [00000000004e7da4] wb_writeback+0x170/0x1ec
> > [00000000004e8074] wb_do_writeback+0x188/0x1a4
> > [00000000004e80b8] bdi_writeback_task+0x28/0xa0
> > [00000000004a76c8] bdi_start_fn+0x64/0xc4
> > [0000000000475f84] kthread+0x58/0x6c
> > [000000000042ade0] kernel_thread+0x30/0x48
> > [0000000000475ee0] kthreadd+0xb8/0x104
> 
> Could it be that there is something synchronize_rcu()-like in the
> game that ??? as a result of how RCU works ??? just takes ages with 24
> VCPUs?

The only synchronize_rcu() involved in the writeback code happens when a
bdi exits, so you should not hit that. It'll do call_rcu() for work
completions, but 1) you should not see a lot of work entries, and 2)
lots of other kernel code will do that, too.

Are you seeing a lot of CPU usage? What does eg perf top -a say?

And what setup is this, I didn't realize you were running a virtualized
setup?

-- 
Jens Axboe

