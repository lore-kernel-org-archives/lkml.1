Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYA2VI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYA2VI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 16:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYA2VIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 16:08:50 -0500
Received: from avexch1.qlogic.com ([198.70.193.115]:13316 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbYA2VIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 16:08:49 -0500
Date: Tue, 29 Jan 2008 13:08:38 -0800
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mike.miller@hp.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com
Subject: Re: kernel BUG at drivers/block/cciss.c:1260! (with recent
	linux-2.6  tree)
Message-ID: <20080129210837.GA21785@plap3.qlogic.org>
References: <20080129175426.GJ12400@plap3.qlogic.org> <20080129180242.GZ15220@kernel.dk> <20080129180537.GA15220@kernel.dk> <20080129182217.GK12400@plap3.qlogic.org> <20080129182833.GG15220@kernel.dk> <20080129183705.GL12400@plap3.qlogic.org> <20080129184442.GK15220@kernel.dk> <20080129184929.GN12400@plap3.qlogic.org> <20080129185358.GM15220@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129185358.GM15220@kernel.dk>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 29 Jan 2008 21:08:48.0058 (UTC) FILETIME=[23E389A0:01C862BB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008, Jens Axboe wrote:

> Great, thanks for confirming. It does look like a clear bug in cciss, it
> just got exposed now that it uses proper end request handling. We never
> need to clear ->data_len, since for blk_fs_request() it will be cleared
> on init. So just setting a residual count there for blk_fs_request()
> like cciss does is fine.
> 
> Anyway, it's in my pending queue for Linus.
> 


Hmm, probably not related to the block changes in your tree, but I'm
seeing yet another problem after working (compile jobs) the machine:

	[   61.423922] BUG: spinlock recursion on CPU#2, kjournald/2317
	[   61.427843]  lock: ffff81042c5a4988, .magic: dead4ead, .owner: kjournald/2317, .owner_cpu: 2
	[   61.427843] Pid: 2317, comm: kjournald Not tainted 2.6.24 #45
	[   61.427843] 
	[   61.427843] Call Trace:
	[   61.427843]  [<ffffffff803332e1>] _raw_spin_lock+0xe9/0x12a
	[   61.427843]  [<ffffffff80324ccf>] as_merged_requests+0xfe/0x115
	[   61.427843]  [<ffffffff8031b558>] elv_merge_requests+0x1f/0x45
	[   61.427843]  [<ffffffff8031e6f7>] attempt_merge+0x281/0x347
	[   61.427843]  [<ffffffff8031f153>] __make_request+0x1e6/0x598
	[   61.427843]  [<ffffffff8031d6ea>] generic_make_request+0x1c8/0x276
	[   61.427843]  [<ffffffff8031d7f9>] submit_bio+0x61/0xdb
	[   61.427843]  [<ffffffff8029b0d2>] submit_bh+0xe2/0x118
	[   61.427843]  [<ffffffff802f69f3>] journal_do_submit_data+0x28/0x39
	[   61.427843]  [<ffffffff802f77da>] journal_commit_transaction+0xdbe/0x1394
	[   61.427843]  [<ffffffff802381a8>] lock_timer_base+0x26/0x4e
	[   61.427843]  [<ffffffff802fb85f>] kjournald+0x104/0x373
	[   61.427843]  [<ffffffff80242087>] autoremove_wake_function+0x0/0x2e
	[   61.427843]  [<ffffffff802fb75b>] kjournald+0x0/0x373
	[   61.427843]  [<ffffffff80241cd4>] kthread+0x3d/0x61
	[   61.427843]  [<ffffffff8020c0e8>] child_rip+0xa/0x12
	[   61.427843]  [<ffffffff80241c97>] kthread+0x0/0x61
	[   61.427843]  [<ffffffff8020c0de>] child_rip+0x0/0x12
	[   61.427843] 
	[  124.555789] BUG: soft lockup - CPU#6 stuck for 61s! [as:7191]
	[  124.555789] CPU 6:
	[  124.555789] Modules linked in:
	[  124.555789] Pid: 7191, comm: as Not tainted 2.6.24 #45
	[  124.555789] RIP: 0010:[<ffffffff8033329d>]  [<ffffffff8033329d>] _raw_spin_lock+0xa5/0x12a
	[  124.555789] RSP: 0018:ffff81042b50be18  EFLAGS: 00000246
	[  124.555789] RAX: 0000000000000000 RBX: 000000000ef44415 RCX: 000000002b543897
	[  124.555789] RDX: 000000000000009c RSI: ffff81042c87b868 RDI: 0000000000000001
	[  124.555789] RBP: 00002b0273879000 R08: 00007fff38107000 R09: ffffffff805739c4
	[  124.555789] R10: ffff81042f33ed78 R11: ffff81042f33ed78 R12: ffff81042b50f3c0
	[  124.555789] R13: 0000001000000000 R14: 0000000000008000 R15: 0000000000000000
	[  124.555789] FS:  00002b02736f3ef0(0000) GS:ffff81042f98a560(0000) knlGS:0000000000000000
	[  124.555789] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
	[  124.555789] CR2: 000000000085d018 CR3: 000000042cb0e000 CR4: 00000000000006e0
	[  124.555789] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
	[  124.555789] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
	[  124.555789] 
	[  124.555789] Call Trace:
	[  124.555789]  [<ffffffff803332ab>] _raw_spin_lock+0xb3/0x12a
	[  124.555789]  [<ffffffff802171a6>] flush_tlb_others+0x4b/0xa8
	[  124.555789]  [<ffffffff80217531>] flush_tlb_mm+0x4a/0x99
	[  124.555789]  [<ffffffff802688fe>] unmap_region+0x10a/0x141
	[  124.555789]  [<ffffffff80269655>] do_munmap+0x1fd/0x2b9
	[  124.555789]  [<ffffffff8047d1d1>] __down_write_nested+0xa0/0xb0
	[  124.555789]  [<ffffffff8026974c>] sys_munmap+0x3b/0x57
	[  124.555789]  [<ffffffff8020b2ce>] system_call+0x7e/0x83
	[  124.555789] 
	[  124.555789] BUG: soft lockup - CPU#14 stuck for 61s! [cc1:7190]
	[  124.555789] CPU 14:
	[  124.555789] Modules linked in:
	[  124.555789] Pid: 7190, comm: cc1 Not tainted 2.6.24 #45
	[  124.555789] RIP: 0010:[<ffffffff802171d0>]  [<ffffffff802171d0>] flush_tlb_others+0x75/0xa8
	[  124.555789] RSP: 0018:ffff81042b965e48  EFLAGS: 00000202
	[  124.555789] RAX: 0000000000000010 RBX: 0000000000000006 RCX: 0000000000000003
	[  124.555789] RDX: 0000000000000010 RSI: ffff81042b965df8 RDI: 0000000000000002
	[  124.555789] RBP: ffff810011cc2658 R08: 00002aea0f72d000 R09: ffffffff80573dc4
	[  124.555789] R10: ffff81042e65b7b8 R11: ffff81042e65b7b8 R12: ffffffff80630640
	[  124.555789] R13: 0000000000000000 R14: ffffffff80264d07 R15: ffff81042e0dd960
	[  124.555789] FS:  00002aea0fafb6f0(0000) GS:ffff81042fb01cc0(0000) knlGS:0000000000000000
	[  124.555789] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	[  124.555789] CR2: 00002aea117fe000 CR3: 000000042b537000 CR4: 00000000000006e0
	[  124.555789] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
	[  124.555789] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
	[  124.555789] 
	[  124.555789] Call Trace:
	[  124.555789]  [<ffffffff802171c4>] flush_tlb_others+0x69/0xa8
	[  124.555789]  [<ffffffff80217531>] flush_tlb_mm+0x4a/0x99
	[  124.555789]  [<ffffffff802688fe>] unmap_region+0x10a/0x141
	[  124.555789]  [<ffffffff80269655>] do_munmap+0x1fd/0x2b9
	[  124.555789]  [<ffffffff8047d1d1>] __down_write_nested+0xa0/0xb0
	[  124.555789]  [<ffffffff8026974c>] sys_munmap+0x3b/0x57

I'll try to get more info when I return...

