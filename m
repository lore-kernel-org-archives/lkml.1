Return-Path: <linux-kernel-owner+w=401wt.eu-S2993119AbXDYXFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993119AbXDYXFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423399AbXDYXFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:05:55 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754508AbXDYXFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:05:54 -0400
Date: Wed, 25 Apr 2007 16:05:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: William Heimbigner <icxcnika@mar.tar.cc>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Christoph Hellwig <hch@lst.de>, linux-ide@vger.kernel.org
Subject: Re: BUG: Null pointer dereference in fs/open.c
Message-Id: <20070425160534.00c3a3d4.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704251701290.25153@server.thyself>
References: <Pine.LNX.4.64.0704222310030.25153@server.thyself>
	<20070423010032.c89e8d32.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704231356480.25153@server.thyself>
	<Pine.LNX.4.64.0704231633210.25153@server.thyself>
	<Pine.LNX.4.64.0704240347470.25153@server.thyself>
	<20070423215810.5a24ed9a.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704240507110.25153@server.thyself>
	<20070423221726.ccfa982c.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704240527030.25153@server.thyself>
	<20070425004816.bd0c240a.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704251701290.25153@server.thyself>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 22:53:00 +0000 (GMT) William Heimbigner <icxcnika@mar.tar.cc> wrote:

> On Wed, 25 Apr 2007, Andrew Morton wrote:
> <snip>
> > OK.  I am able to use the pktcdvd driver OK in mainline with a piix/sata
> > drive.  It could be that something is going wrong at the IDE level for you.
> Perhaps; I'll try an external usb cd burner, and see where that goes.
> 
> > Are you able to identify the most recent kernel which actually worked?
> No, because I haven't set packet writing up in Linux before - however, I do know 
> that I've successfully set up packet writing (using 2 of the 3 cd burners I 
> have) in another operating system before. I'll try 2.6.18 and see if that gets
> me anywhere different, though.

OK.

A quick summary: mainline's pktcdvd isn't working for William using IDE. 
It is working for me using sata.

> dmesg.1.txt is the dmesg output from immediately after system finishes booting 
> (the unusually large printk times are due to kexec)
> 
> # pktsetup 0 /dev/hdc
> [19861.831160] pktcdvd: writer pktcdvd0 mapped to hdc
> [19861.837138]
> [19861.837142] =============================================
> [19861.844343] [ INFO: possible recursive locking detected ]
> [19861.849738] 2.6.21-rc7 #2
> [19861.852361] ---------------------------------------------
> [19861.857750] vol_id/4433 is trying to acquire lock:
> [19861.862533]  (&bdev->bd_mutex){--..}, at: [<c019bb8f>] do_open+0x4f/0x2c0
> [19861.869386]
> [19861.869387] but task is already holding lock:
> [19861.875225]  (&bdev->bd_mutex){--..}, at: [<c019bb8f>] do_open+0x4f/0x2c0
> [19861.882070]
> [19861.882071] other info that might help us debug this:
> [19861.888602] 2 locks held by vol_id/4433:
> [19861.892518]  #0:  (&bdev->bd_mutex){--..}, at: [<c019bb8f>] 
> do_open+0x4f/0x2c0
> [19861.899813]  #1:  (&ctl_mutex#2){--..}, at: [<c04c615c>] mutex_lock+0x1c/0x20
> [19861.907046]
> [19861.907047] stack backtrace:
> [19861.911415]  [<c010521a>] show_trace_log_lvl+0x1a/0x30
> [19861.916569]  [<c0105952>] show_trace+0x12/0x20
> [19861.921021]  [<c0105a46>] dump_stack+0x16/0x20
> [19861.925475]  [<c013ede0>] __lock_acquire+0xbc0/0x1040
> [19861.930542]  [<c013f2d0>] lock_acquire+0x70/0x90
> [19861.935169]  [<c04c61de>] mutex_lock_nested+0x7e/0x2e0
> [19861.940315]  [<c019bb8f>] do_open+0x4f/0x2c0
> [19861.944595]  [<c019be79>] __blkdev_get+0x79/0x90
> [19861.949222]  [<c019bea5>] blkdev_get+0x15/0x20
> [19861.953674]  [<c032a987>] pkt_open+0xb7/0xd80
> [19861.958050]  [<c019bbc5>] do_open+0x85/0x2c0
> [19861.962330]  [<c019c023>] blkdev_open+0x33/0x70
> [19861.966870]  [<c0175084>] __dentry_open+0xf4/0x220
> [19861.971678]  [<c0175255>] nameidata_to_filp+0x35/0x40
> [19861.976738]  [<c01752a9>] do_filp_open+0x49/0x50
> [19861.981365]  [<c01752f7>] do_sys_open+0x47/0xd0
> [19861.985904]  [<c01753bc>] sys_open+0x1c/0x20
> [19861.990184]  [<c01041c6>] sysenter_past_esp+0x5f/0x99
> [19861.995243]  =======================

Yeah, I'm not worrying about that one for now.

> # pktsetup 1 /dev/hdd
> [19909.635795] cdrom: This disc doesn't have any tracks I recognize!
> [19909.689394] pktcdvd: writer pktcdvd1 mapped to hdd
> [19909.820337] drivers/ide/ide-cd.c:729: setting error to 2
> [19909.825649]  [<c010521a>] show_trace_log_lvl+0x1a/0x30
> [19909.830810]  [<c0105952>] show_trace+0x12/0x20
> [19909.835263]  [<c0105a46>] dump_stack+0x16/0x20
> [19909.839716]  [<c033f6e4>] cdrom_decode_status+0x1f4/0x3b0
> [19909.845131]  [<c033fae8>] cdrom_newpc_intr+0x38/0x320
> [19909.850190]  [<c0331106>] ide_intr+0x96/0x200
> [19909.854557]  [<c0150cf8>] handle_IRQ_event+0x28/0x60
> [19909.859538]  [<c0151f96>] handle_edge_irq+0xa6/0x130
> [19909.864511]  [<c0106449>] do_IRQ+0x49/0xa0
> [19909.868618]  [<c0104c3a>] common_interrupt+0x2e/0x34
> [19909.873591]  [<c01022d2>] mwait_idle+0x12/0x20
> [19909.878044]  [<c01023ca>] cpu_idle+0x4a/0x80
> [19909.882324]  [<c0101147>] rest_init+0x37/0x40
> [19909.886690]  [<c068ac7b>] start_kernel+0x34b/0x420
> [19909.891499]  [<00000000>] 0x0
> [19909.894488]  =======================
> [19909.921518] pktcdvd: pkt_get_last_written failed
> 
> # pktsetup 2 /dev/sr0
> [19982.934793] drivers/scsi/scsi_lib.c:838: setting error to 134217730
> [19982.941070]  [<c010521a>] show_trace_log_lvl+0x1a/0x30
> [19982.946256]  [<c0105952>] show_trace+0x12/0x20
> [19982.950744]  [<c0105a46>] dump_stack+0x16/0x20
> [19982.955232]  [<c034543a>] scsi_io_completion+0x28a/0x3a0
> [19982.960586]  [<c034556b>] scsi_blk_pc_done+0x1b/0x30
> [19982.965594]  [<c0340d0c>] scsi_finish_command+0x4c/0x60
> [19982.970861]  [<c0345c07>] scsi_softirq_done+0x77/0xe0
> [19982.975955]  [<c0257f8b>] blk_done_softirq+0x6b/0x80
> [19982.980962]  [<c01243a2>] __do_softirq+0x62/0xc0
> [19982.985624]  [<c0124455>] do_softirq+0x55/0x60
> [19982.990112]  [<c0124be5>] ksoftirqd+0x65/0x100
> [19982.994599]  [<c0132963>] kthread+0xa3/0xd0
> [19982.998827]  [<c0104e17>] kernel_thread_helper+0x7/0x10
> [19983.004095]  =======================
> [19983.009065] cdrom: This disc doesn't have any tracks I recognize!

So what has happened here is that this code, in ide-cd.c's
cdrom_decode_status() is now triggering:

	} else if (blk_pc_request(rq) || rq->cmd_type == REQ_TYPE_ATA_PC) {
		/* All other functions, except for READ. */
		unsigned long flags;

		/*
		 * if we have an error, pass back CHECK_CONDITION as the
		 * scsi status byte
		 */
		if (blk_pc_request(rq) && !rq->errors)
			rq->errors = SAM_STAT_CHECK_CONDITION;


I suspect this is a bug introduced by
406c9b605cbc45151c03ac9a3f95e9acf050808c (in which case it'll be the third
bug so far).

Perhaps the IDE driver was previously not considering these requests to be
of type blk_pc_request(), and after
406c9b605cbc45151c03ac9a3f95e9acf050808c it _is_ treating them as
blk_pc_request() and is incorrectly reporting an error.  Or something like
that.

Guys: help!
