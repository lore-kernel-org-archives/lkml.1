Return-Path: <linux-kernel-owner+w=401wt.eu-S965500AbXJQPuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965500AbXJQPuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 11:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762188AbXJQPun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 11:50:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56778 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761586AbXJQPum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 11:50:42 -0400
Date: Wed, 17 Oct 2007 17:50:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
Message-ID: <20071017155032.GA15215@elte.hu>
References: <20071017154655.GA13394@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017154655.GA13394@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> i tried another bootup with the same kernel and the crash did not 
> reoccur, so it seems to be spurious. This crash could be related to 
> the scsi or block merges done in the past few days - never saw this 
> before.

managed to trigger it a second time, so it seems rather reproducible:

[  328.771333] kjournald starting.  Commit interval 5 seconds
[  328.776963] EXT3 FS on sda5, internal journal
[  328.781172] EXT3-fs: mounted filesystem with ordered data mode.
[  329.689493] BUG: unable to handle kernel paging request at virtual address 7d516000
[  329.696990] printing eip: 78406669 *pde = 00ddd027 *pte = 05516000 
[  329.703230] Oops: 0000 [#1] DEBUG_PAGEALLOC
[  329.707390] 
[  329.708863] Pid: 0, comm: swapper Not tainted (2.6.23 #45)
[  329.714321] EIP: 0060:[<78406669>] EFLAGS: 00010006 CPU: 0
[  329.719787] EIP is at blk_rq_map_sg+0xb9/0x170
[  329.724202] EAX: 2f6df000 EBX: 7d6af880 ECX: 34d55000 EDX: 005edbe0
[  329.730441] ESI: 7d515ff0 EDI: 796d8be0 EBP: 00001000 ESP: 78a13db0
[  329.736680]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  329.742054] Process swapper (pid: 0, ti=78a12000 task=7893c400 task.ti=78a12000)
[  329.749246] Stack: 00000020 7b520000 00002000 34d56000 7d515fe0 00000007 00000001 00000000 
[  329.757565]        7d6af800 01000000 7d515e00 7b522b94 7d84f58c 7b520000 784c89b5 7b520000 
[  329.765885]        784c843a 7d84f58c 7b520f20 7b522b94 7d84f58c 784e54a0 784f394b 00000000 
[  329.774204] Call Trace:
[  329.776804]  [<784c89b5>] scsi_init_io+0x55/0xe0
[  329.781398]  [<784c843a>] scsi_get_cmd_from_req+0x2a/0x40
[  329.786770]  [<784e54a0>] sd_prep_fn+0x80/0x940
[  329.791277]  [<784f394b>] ata_bmdma_start+0xb/0x20
[  329.796043]  [<784ef344>] ata_qc_issue_prot+0x164/0x1e0
[  329.801243]  [<78405c63>] elv_dispatch_sort+0x23/0xe0
[  329.806268]  [<784057d0>] elv_next_request+0xa0/0x130
[  329.811295]  [<787715b8>] _spin_lock_irq+0x38/0x50
[  329.816062]  [<784c9af4>] scsi_request_fn+0x1e4/0x370
[  329.821088]  [<784097f6>] blk_run_queue+0x36/0x80
[  329.825768]  [<784c8370>] scsi_next_command+0x30/0x50
[  329.830794]  [<784c84fb>] scsi_end_request+0xab/0xe0
[  329.835733]  [<784c9249>] scsi_io_completion+0xa9/0x3d0
[  329.840933]  [<78135de7>] trace_hardirqs_on+0x67/0xb0
[  329.845960]  [<784068c5>] blk_done_softirq+0x45/0x80
[  329.850900]  [<784068f3>] blk_done_softirq+0x73/0x80
[  329.855839]  [<7811d3f3>] __do_softirq+0x53/0xb0
[  329.860432]  [<7811d4b8>] do_softirq+0x68/0x70
[  329.864852]  [<78105351>] do_IRQ+0x51/0x90
[  329.868925]  [<78135e1c>] trace_hardirqs_on+0x9c/0xb0
[  329.873951]  [<7810388e>] common_interrupt+0x2e/0x40
[  329.878891]  [<78100c55>] cpu_idle+0x35/0x60
[  329.883138]  [<78a14b35>] start_kernel+0x265/0x300
[  329.887904]  [<78a14380>] unknown_bootoption+0x0/0x1e0
[  329.893016]  =======================
[  329.896570] Code: 05 c1 e1 0c 03 4a 08 8b 52 04 01 ca 89 54 24 0c 8b 3b 89 fa 29 c2 89 d0 c1 f8 05 c1 e0 0c 03 43 08 39 44 24 0c 0f 84 7e 00 00 00 <8b> 46 10 8d 56 10 a8 01 75 4c 89 3e 89 6e 0c 8b 43 08 89 46 04 
[  329.915375] EIP: [<78406669>] blk_rq_map_sg+0xb9/0x170 SS:ESP 0068:78a13db0
[  329.922309] Kernel panic - not syncing: Fatal exception in interrupt

	Ingo
