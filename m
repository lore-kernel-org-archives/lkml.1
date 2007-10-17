Return-Path: <linux-kernel-owner+w=401wt.eu-S1759393AbXJQSDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393AbXJQSDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 14:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754941AbXJQSDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 14:03:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47466 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513AbXJQSDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 14:03:10 -0400
Date: Wed, 17 Oct 2007 20:02:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
Message-ID: <20071017180255.GA8375@elte.hu>
References: <20071017154655.GA13394@elte.hu> <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org> <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk> <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk> <alpine.LFD.0.999.0710171053180.26902@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710171053180.26902@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> But I think the rest of your changes are simply bad.
> 
> The fix to block/ll_rw_block.c should likely be something like the 
> appended instead:
> 
>  - remove the "memset()" you had added earlier. It's bogus. It cannot be 
>    the right thing. If the sg list wasn't initialized correctly much 
>    earlier, trying to initialize it late is pointless - it contains crap.
> 
>  - the old code was fine, but let's initialize "sg" to NULL to make it 
>    clear that the initial value of sg is pointless, and only "next_sg" 
>    matters (since sg had better be assigned from that).
> 
> Hmm?

built and booted your patch (removed Jens's) but it still crashes in 
blk_rq_map_sg() - see below. Should i have left something from Jens's 
patch?

	Ingo

------------------->
[   34.698199] VFS: Mounted root (ext3 filesystem) readonly.
[   34.703917] Freeing unused kernel memory: 372k freed
[   34.746609] BUG: unable to handle kernel paging request at virtual address 6e616872
[   34.754106] printing eip: 7840503b *pde = 00000000 
[   34.758960] Oops: 0000 [#1] DEBUG_PAGEALLOC
[   34.763120] 
[   34.764594] Pid: 1, comm: swapper Not tainted (2.6.23 #7)
[   34.769965] EIP: 0060:[<7840503b>] EFLAGS: 00010006 CPU: 0
[   34.775429] EIP is at blk_rq_map_sg+0xbb/0x170
[   34.779845] EAX: 3ffcd000 EBX: 7c88a68c ECX: 3ffce000 EDX: 007ff9a0
[   34.786085] ESI: 6e616862 EDI: 798ea9a0 EBP: 00001000 ESP: 7b421bf4
[   34.792324]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   34.797697] Process swapper (pid: 1, ti=7b420000 task=7b416000 task.ti=7b420000)
[   34.804890] Stack: 00000046 7b520000 00002000 3ffcf000 7c88ac80 00000001 00000001 00000001 
[   34.813209]        7c88a600 01000000 7c88ab00 7b521d1c 7c88a708 7b520000 784c7ac5 7b520000 
[   34.821529]        784c75ca 7c88a708 7b524ce4 7b521d1c 7c88a708 784e4570 7b416000 7813661b 
[   34.829847] Call Trace:
[   34.832448]  [<784c7ac5>] scsi_init_io+0x55/0xe0
[   34.837042]  [<784c75ca>] scsi_get_cmd_from_req+0x2a/0x40
[   34.842414]  [<784e4570>] sd_prep_fn+0x80/0x940
[   34.846920]  [<7813661b>] __lock_acquire+0x4ab/0xe20
[   34.851860]  [<781450a6>] add_to_page_cache+0x66/0xb0
[   34.856887]  [<78404633>] elv_dispatch_sort+0x23/0xe0
[   34.861912]  [<784041a0>] elv_next_request+0xa0/0x130
[   34.866938]  [<784c8c04>] scsi_request_fn+0x1e4/0x370
[   34.871965]  [<78120f02>] del_timer+0x62/0x70
[   34.876298]  [<78407445>] __generic_unplug_device+0x25/0x30
[   34.881844]  [<78407715>] generic_unplug_device+0x15/0x30
[   34.887217]  [<78404e00>] blk_backing_dev_unplug+0x0/0x10
[   34.892590]  [<78404e0c>] blk_backing_dev_unplug+0xc/0x10
[   34.897963]  [<78180a9d>] block_sync_page+0x2d/0x40
[   34.902817]  [<78144dc9>] sync_page+0x29/0x40
[   34.907150]  [<7876f5bc>] __wait_on_bit_lock+0x3c/0x70
[   34.912263]  [<78144da0>] sync_page+0x0/0x40
[   34.916509]  [<78144d82>] __lock_page+0x52/0x60
[   34.921016]  [<7812adb0>] wake_bit_function+0x0/0x60
[   34.925955]  [<7814554c>] do_generic_mapping_read+0x21c/0x450
[   34.931675]  [<78144b10>] file_read_actor+0x0/0x130
[   34.936528]  [<78147107>] generic_file_aio_read+0x137/0x180
[   34.942074]  [<78144b10>] file_read_actor+0x0/0x130
[   34.946927]  [<78161245>] do_sync_read+0xd5/0x120
[   34.951607]  [<78135646>] mark_lock+0x76/0x550
[   34.956027]  [<7812ad70>] autoremove_wake_function+0x0/0x40
[   34.961573]  [<78155026>] __vma_link+0x36/0x70
[   34.965993]  [<78161170>] do_sync_read+0x0/0x120
[   34.970586]  [<78161ae3>] vfs_read+0xb3/0x110
[   34.974919]  [<781652cd>] kernel_read+0x3d/0x60
[   34.979425]  [<7816539f>] prepare_binprm+0xaf/0xe0
[   34.984192]  [<78166973>] do_execve+0x123/0x1c0
[   34.988698]  [<78100f1f>] sys_execve+0x2f/0x90
[   34.993118]  [<781028a2>] syscall_call+0x7/0xb
[   34.997538]  [<78106f1c>] kernel_execve+0x1c/0x30
[   35.002217]  [<7810016e>] init_post+0x9e/0xe0
[   35.006550]  [<78a147b3>] kernel_init+0x163/0x280
[   35.011230]  [<78a14650>] kernel_init+0x0/0x280
[   35.015736]  [<78103a97>] kernel_thread_helper+0x7/0x10
[   35.020936]  =======================
[   35.024489] Code: 29 c1 c1 f9 05 c1 e1 0c 03 4a 08 8b 52 04 01 ca 89 54 24 0c 8b 3b 89 fa 29 c2 89 d0 c1 f8 05 c1 e0 0c 03 43 08 39 44 24 0c 74 7e <8b> 46 10 8d 56 10 a8 01 75 4c 89 3e 89 6e 0c 8b 43 08 89 46 04 
[   35.043294] EIP: [<7840503b>] blk_rq_map_sg+0xbb/0x170 SS:ESP 0068:7b421bf4
[   35.050228] Kernel panic - not syncing: Attempted to kill init!
