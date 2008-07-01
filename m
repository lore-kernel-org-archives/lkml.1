Return-Path: <linux-kernel-owner+w=401wt.eu-S1757521AbYGAXkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbYGAXkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 19:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759233AbYGAXkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 19:40:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758494AbYGAXkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 19:40:14 -0400
Date: Tue, 1 Jul 2008 16:39:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, ming.m.lin@intel.com,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: [PATCH] Properly notify block layer of sync writes
Message-Id: <20080701163949.d0cdf740.akpm@linux-foundation.org>
In-Reply-To: <20080627131830.GC20826@kernel.dk>
References: <20080627131830.GC20826@kernel.dk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008 15:18:31 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> Hi,
> 
> fsync_buffers_list() and sync_dirty_buffer() both issue async writes and
> then immediately wait on them. Conceptually, that makes them sync writes
> and we should treat them as such so that the IO schedulers can handle
> them appropriately.
> 
> This patch fixes a write starvation issue that Lin Ming reported, where
> xx is stuck for more than 2 minutes because of a large number of
> synchronous IO in the system:
> 
> INFO: task kjournald:20558 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> message.
> kjournald     D ffff810010820978  6712 20558      2
> ffff81022ddb1d10 0000000000000046 ffff81022e7baa10 ffffffff803ba6f2
> ffff81022ecd0000 ffff8101e6dc9160 ffff81022ecd0348 000000008048b6cb
> 0000000000000086 ffff81022c4e8d30 0000000000000000 ffffffff80247537
> Call Trace:
> [<ffffffff803ba6f2>] kobject_get+0x12/0x17
> [<ffffffff80247537>] getnstimeofday+0x2f/0x83
> [<ffffffff8029c1ac>] sync_buffer+0x0/0x3f
> [<ffffffff8066d195>] io_schedule+0x5d/0x9f
> [<ffffffff8029c1e7>] sync_buffer+0x3b/0x3f
> [<ffffffff8066d3f0>] __wait_on_bit+0x40/0x6f
> [<ffffffff8029c1ac>] sync_buffer+0x0/0x3f
> [<ffffffff8066d48b>] out_of_line_wait_on_bit+0x6c/0x78
> [<ffffffff80243909>] wake_bit_function+0x0/0x23
> [<ffffffff8029e3ad>] sync_dirty_buffer+0x98/0xcb
> [<ffffffff8030056b>] journal_commit_transaction+0x97d/0xcb6
> [<ffffffff8023a676>] lock_timer_base+0x26/0x4b
> [<ffffffff8030300a>] kjournald+0xc1/0x1fb
> [<ffffffff802438db>] autoremove_wake_function+0x0/0x2e
> [<ffffffff80302f49>] kjournald+0x0/0x1fb
> [<ffffffff802437bb>] kthread+0x47/0x74
> [<ffffffff8022de51>] schedule_tail+0x28/0x5d
> [<ffffffff8020cac8>] child_rip+0xa/0x12
> [<ffffffff80243774>] kthread+0x0/0x74
> [<ffffffff8020cabe>] child_rip+0x0/0x12
> 
> Lin Ming confirms that this patch fixes the issue. I've run tests with
> it for the past week and no ill effects have been observed, so I'm
> proposing it for inclusion into 2.6.26.

I expect we'll be wanting this in 2.6.25.x also?

> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  fs/buffer.c        |   13 ++++++++-----
>  include/linux/fs.h |    1 +
>  2 files changed, 9 insertions(+), 5 deletions(-)
> 
> ...
>
