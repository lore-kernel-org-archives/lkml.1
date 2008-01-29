Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbYA2VQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbYA2VQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 16:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYA2VQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 16:16:40 -0500
Received: from brick.kernel.dk ([87.55.233.238]:29962 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbYA2VQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 16:16:39 -0500
Date: Tue, 29 Jan 2008 22:16:34 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mike.miller@hp.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com,
       tony.luck@intel.com
Subject: Re: kernel BUG at drivers/block/cciss.c:1260! (with recent  linux-2.6  tree)
Message-ID: <20080129211634.GB15220@kernel.dk>
References: <20080129175426.GJ12400@plap3.qlogic.org> <20080129180242.GZ15220@kernel.dk> <20080129180537.GA15220@kernel.dk> <20080129182217.GK12400@plap3.qlogic.org> <20080129182833.GG15220@kernel.dk> <20080129183705.GL12400@plap3.qlogic.org> <20080129184442.GK15220@kernel.dk> <20080129184929.GN12400@plap3.qlogic.org> <20080129185358.GM15220@kernel.dk> <20080129210837.GA21785@plap3.qlogic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129210837.GA21785@plap3.qlogic.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29 2008, Andrew Vasquez wrote:
> On Tue, 29 Jan 2008, Jens Axboe wrote:
> 
> > Great, thanks for confirming. It does look like a clear bug in cciss, it
> > just got exposed now that it uses proper end request handling. We never
> > need to clear ->data_len, since for blk_fs_request() it will be cleared
> > on init. So just setting a residual count there for blk_fs_request()
> > like cciss does is fine.
> > 
> > Anyway, it's in my pending queue for Linus.
> > 
> 
> 
> Hmm, probably not related to the block changes in your tree, but I'm
> seeing yet another problem after working (compile jobs) the machine:
> 
> 	[   61.423922] BUG: spinlock recursion on CPU#2, kjournald/2317
> 	[   61.427843]  lock: ffff81042c5a4988, .magic: dead4ead, .owner: kjournald/2317, .owner_cpu: 2
> 	[   61.427843] Pid: 2317, comm: kjournald Not tainted 2.6.24 #45
> 	[   61.427843] 
> 	[   61.427843] Call Trace:
> 	[   61.427843]  [<ffffffff803332e1>] _raw_spin_lock+0xe9/0x12a
> 	[   61.427843]  [<ffffffff80324ccf>] as_merged_requests+0xfe/0x115
> 	[   61.427843]  [<ffffffff8031b558>] elv_merge_requests+0x1f/0x45
> 	[   61.427843]  [<ffffffff8031e6f7>] attempt_merge+0x281/0x347
> 	[   61.427843]  [<ffffffff8031f153>] __make_request+0x1e6/0x598
> 	[   61.427843]  [<ffffffff8031d6ea>] generic_make_request+0x1c8/0x276
> 	[   61.427843]  [<ffffffff8031d7f9>] submit_bio+0x61/0xdb
> 	[   61.427843]  [<ffffffff8029b0d2>] submit_bh+0xe2/0x118
> 	[   61.427843]  [<ffffffff802f69f3>] journal_do_submit_data+0x28/0x39
> 	[   61.427843]  [<ffffffff802f77da>] journal_commit_transaction+0xdbe/0x1394
> 	[   61.427843]  [<ffffffff802381a8>] lock_timer_base+0x26/0x4e
> 	[   61.427843]  [<ffffffff802fb85f>] kjournald+0x104/0x373
> 	[   61.427843]  [<ffffffff80242087>] autoremove_wake_function+0x0/0x2e
> 	[   61.427843]  [<ffffffff802fb75b>] kjournald+0x0/0x373
> 	[   61.427843]  [<ffffffff80241cd4>] kthread+0x3d/0x61
> 	[   61.427843]  [<ffffffff8020c0e8>] child_rip+0xa/0x12
> 	[   61.427843]  [<ffffffff80241c97>] kthread+0x0/0x61
> 	[   61.427843]  [<ffffffff8020c0de>] child_rip+0x0/0x12

Ah crap, I see the problem, nioc is most often equal to rioc. Dang.
Please try this bandaid, will push a real fix now.

diff --git a/block/as-iosched.c b/block/as-iosched.c
index b201d16..5ca55b0 100644
--- a/block/as-iosched.c
+++ b/block/as-iosched.c
@@ -1275,9 +1275,15 @@ static void as_merged_requests(struct request_queue *q, struct request *req,
 			 * Don't copy here but swap, because when anext is
 			 * removed below, it must contain the unused context
 			 */
-			double_spin_lock(&rioc->lock, &nioc->lock, rioc < nioc);
+			if (rioc != nioc)
+				double_spin_lock(&rioc->lock, &nioc->lock, rioc < nioc);
+			else
+				spin_lock(&rioc->lock);
 			swap_io_context(&rioc, &nioc);
-			double_spin_unlock(&rioc->lock, &nioc->lock, rioc < nioc);
+			if (rioc != nioc)
+				double_spin_unlock(&rioc->lock, &nioc->lock, rioc < nioc);
+			else
+				spin_unlock(&rioc->lock);
 		}
 	}
 

-- 
Jens Axboe

