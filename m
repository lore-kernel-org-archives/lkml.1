Return-Path: <linux-kernel-owner+w=401wt.eu-S934188AbXCVSpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934188AbXCVSpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 14:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934186AbXCVSpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 14:45:43 -0400
Received: from brick.kernel.dk ([62.242.22.158]:12119 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934184AbXCVSpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 14:45:42 -0400
Date: Thu, 22 Mar 2007 19:41:57 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: linux@horizon.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.20.3 AMD64 oops in CFQ code
Message-ID: <20070322184155.GY19922@kernel.dk>
References: <20070322123821.7843.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322123821.7843.qmail@science.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22 2007, linux@horizon.com wrote:
> This is a uniprocessor AMD64 system running software RAID-5 and RAID-10
> over multiple PCIe SiI3132 SATA controllers.  The hardware has been very
> stable for a long time, but has been acting up of late since I upgraded
> to 2.6.20.3.  ECC memory should preclude the possibility of bit-flip
> errors.
> 
> Kernel 2.6.20.3 + linuxpps patches (confined to drivers/serial, and not
> actually in use as I stole the serial port for a console).
> 
> It takes half a day to reproduce the problem, so bisecting would be painful.
> 
> BackupPC_dump mostly writes to a large (1.7 TB) ext3 RAID5 partition.
> 
> 
> Here are two oopes, a few minutes (16:31, to be precise) apart.
> Unusually, it oopsed twice *without* locking up the system..  Usually,
> I see this followed by an error from drivers/input/keyboard/atkbd.c:
>                         printk(KERN_WARNING "atkbd.c: Spurious %s on %s. "
>                                "Some program might be trying access hardware directly.\n",
> emitted at 1 Hz with the keyboard LEDs flashing and the system
> unresponsive to keyboard or pings.
> (I think it was spurious ACK on serio/input0, but my memory may be faulty.)
> 
> 
> If anyone has any suggestions, they'd be gratefully received.
> 
> 
> Unable to handle kernel NULL pointer dereference at 0000000000000098 RIP: 
>  [<ffffffff8031504a>] cfq_dispatch_insert+0x18/0x68
> PGD 777e9067 PUD 78774067 PMD 0 
> Oops: 0000 [1] 
> CPU 0 
> Modules linked in: ecb
> Pid: 2837, comm: BackupPC_dump Not tainted 2.6.20.3-g691f5333 #40
> RIP: 0010:[<ffffffff8031504a>]  [<ffffffff8031504a>] cfq_dispatch_insert+0x18/0x68
> RSP: 0018:ffff8100770bbaf8  EFLAGS: 00010092
> RAX: ffff81007fb36c80 RBX: 0000000000000000 RCX: 0000000000000001
> RDX: 000000010003e4e7 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff81007fb37a00 R08: 00000000ffffffff R09: ffff81005d390298
> R10: ffff81007fcb4f80 R11: ffff81007fcb4f80 R12: ffff81007facd280
> R13: 0000000000000004 R14: 0000000000000001 R15: 0000000000000000
> FS:  00002b322d120d30(0000) GS:ffffffff805de000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000098 CR3: 000000007bcf0000 CR4: 00000000000006e0
> Process BackupPC_dump (pid: 2837, threadinfo ffff8100770ba000, task ffff81007fc5d8e0)
> Stack:  0000000000000000 ffff8100770f39f0 0000000000000000 0000000000000004
>  0000000000000001 ffffffff80315253 ffffffff803b2607 ffff81005da2bc40
>  ffff81007fac3800 ffff81007facd280 ffff81007facd280 ffff81005d390298
> Call Trace:
>  [<ffffffff80315253>] cfq_dispatch_requests+0x152/0x512
>  [<ffffffff803b2607>] scsi_done+0x0/0x18
>  [<ffffffff8030d9f1>] elv_next_request+0x137/0x147
>  [<ffffffff803b7ce0>] scsi_request_fn+0x6a/0x33a
>  [<ffffffff8024d407>] generic_unplug_device+0xa/0xe
>  [<ffffffff80407ced>] unplug_slaves+0x5b/0x94
>  [<ffffffff80223d65>] sync_page+0x0/0x40
>  [<ffffffff80223d9b>] sync_page+0x36/0x40
>  [<ffffffff80256d45>] __wait_on_bit_lock+0x36/0x65
>  [<ffffffff80237496>] __lock_page+0x5e/0x64
>  [<ffffffff8028061d>] wake_bit_function+0x0/0x23
>  [<ffffffff802074de>] find_get_page+0xe/0x2d
>  [<ffffffff8020b38e>] do_generic_mapping_read+0x1c2/0x40d
>  [<ffffffff8020bd80>] file_read_actor+0x0/0x118
>  [<ffffffff8021422e>] generic_file_aio_read+0x15c/0x19e
>  [<ffffffff8020bafa>] do_sync_read+0xc9/0x10c
>  [<ffffffff80210342>] may_open+0x5b/0x1c6
>  [<ffffffff802805ef>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff8020a857>] vfs_read+0xaa/0x152
>  [<ffffffff8020faf3>] sys_read+0x45/0x6e
>  [<ffffffff8025041e>] system_call+0x7e/0x83

3 (I think) seperate instances of this, each involving raid5. Is your
array degraded or fully operational?


-- 
Jens Axboe

