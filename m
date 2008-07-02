Return-Path: <linux-kernel-owner+w=401wt.eu-S1761240AbYGBIiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240AbYGBIiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbYGBIh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:37:56 -0400
Received: from brick.kernel.dk ([87.55.233.238]:8331 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbYGBIhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:37:54 -0400
Date: Wed, 2 Jul 2008 10:37:52 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ming.m.lin@intel.com,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: [PATCH] Properly notify block layer of sync writes
Message-ID: <20080702083752.GI20055@kernel.dk>
References: <20080627131830.GC20826@kernel.dk> <20080701163949.d0cdf740.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701163949.d0cdf740.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01 2008, Andrew Morton wrote:
> On Fri, 27 Jun 2008 15:18:31 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > Hi,
> > 
> > fsync_buffers_list() and sync_dirty_buffer() both issue async writes and
> > then immediately wait on them. Conceptually, that makes them sync writes
> > and we should treat them as such so that the IO schedulers can handle
> > them appropriately.
> > 
> > This patch fixes a write starvation issue that Lin Ming reported, where
> > xx is stuck for more than 2 minutes because of a large number of
> > synchronous IO in the system:
> > 
> > INFO: task kjournald:20558 blocked for more than 120 seconds.
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> > message.
> > kjournald     D ffff810010820978  6712 20558      2
> > ffff81022ddb1d10 0000000000000046 ffff81022e7baa10 ffffffff803ba6f2
> > ffff81022ecd0000 ffff8101e6dc9160 ffff81022ecd0348 000000008048b6cb
> > 0000000000000086 ffff81022c4e8d30 0000000000000000 ffffffff80247537
> > Call Trace:
> > [<ffffffff803ba6f2>] kobject_get+0x12/0x17
> > [<ffffffff80247537>] getnstimeofday+0x2f/0x83
> > [<ffffffff8029c1ac>] sync_buffer+0x0/0x3f
> > [<ffffffff8066d195>] io_schedule+0x5d/0x9f
> > [<ffffffff8029c1e7>] sync_buffer+0x3b/0x3f
> > [<ffffffff8066d3f0>] __wait_on_bit+0x40/0x6f
> > [<ffffffff8029c1ac>] sync_buffer+0x0/0x3f
> > [<ffffffff8066d48b>] out_of_line_wait_on_bit+0x6c/0x78
> > [<ffffffff80243909>] wake_bit_function+0x0/0x23
> > [<ffffffff8029e3ad>] sync_dirty_buffer+0x98/0xcb
> > [<ffffffff8030056b>] journal_commit_transaction+0x97d/0xcb6
> > [<ffffffff8023a676>] lock_timer_base+0x26/0x4b
> > [<ffffffff8030300a>] kjournald+0xc1/0x1fb
> > [<ffffffff802438db>] autoremove_wake_function+0x0/0x2e
> > [<ffffffff80302f49>] kjournald+0x0/0x1fb
> > [<ffffffff802437bb>] kthread+0x47/0x74
> > [<ffffffff8022de51>] schedule_tail+0x28/0x5d
> > [<ffffffff8020cac8>] child_rip+0xa/0x12
> > [<ffffffff80243774>] kthread+0x0/0x74
> > [<ffffffff8020cabe>] child_rip+0x0/0x12
> > 
> > Lin Ming confirms that this patch fixes the issue. I've run tests with
> > it for the past week and no ill effects have been observed, so I'm
> > proposing it for inclusion into 2.6.26.
> 
> I expect we'll be wanting this in 2.6.25.x also?

Yeah, I think so.

-- 
Jens Axboe

