Return-Path: <linux-kernel-owner+w=401wt.eu-S936457AbYD1QLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936457AbYD1QLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936280AbYD1QKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:10:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936360AbYD1QKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:10:48 -0400
Date: Mon, 28 Apr 2008 09:08:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-aio <linux-aio@kvack.org>, Zach Brown <zach.brown@oracle.com>,
       Clark Williams <williams@redhat.com>
Subject: Re: AIO/DIO lockup/crash
Message-Id: <20080428090857.beb19a20.akpm@linux-foundation.org>
In-Reply-To: <1209385782.13978.17.camel@twins>
References: <1209385782.13978.17.camel@twins>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 14:29:42 +0200 Peter Zijlstra <peterz@infradead.org> wrote:

> Hi guys,
> 
> I'm getting this (and various variations thereof - like crashing in the
> PI chain code on -rt) when running aio-dio-invalidate-failure for a few
> hours.
> 
> (dual core opteron - single spindle - ext3)
> 
> Is this a known issue?
> 
> I'll run the same on current -git overnight to see if it went away :-)
> 
> 
> [ 1796.238953] BUG: soft lockup - CPU#1 stuck for 11s! [aio-dio-invalid:3037]
> [ 1796.245794] CPU 1:
> [ 1796.247802] Modules linked in: autofs4 binfmt_misc ext2 psmouse evbug evdev i2c_piix4 i2c_core pcspkr thermal processor button sr_mod cdrom sg shpchp pci_hotplug sd_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd usbcore
> [ 1796.267532] Pid: 3037, comm: aio-dio-invalid Not tainted 2.6.24.4 #194
> [ 1796.274023] RIP: 0010:[<ffffffff804a7993>]  [<ffffffff804a7993>] _spin_lock_irqsave+0x63/0x90
> [ 1796.282517] RSP: 0018:ffff81007fba7ce0  EFLAGS: 00000246
> [ 1796.287800] RAX: 0000000000000000 RBX: ffff81007fba7cf0 RCX: 0000000000001000
> [ 1796.294895] RDX: 0000000000000213 RSI: ffff810067dbc740 RDI: 0000000000000001
> [ 1796.301993] RBP: ffff81007fba7c60 R08: 0000000000000101 R09: 000000000169aa28
> [ 1796.309090] R10: 000000000169aa28 R11: 0000000000000003 R12: ffffffff8020d0c6
> [ 1796.316187] R13: ffff81007fba7c60 R14: ffff81007eaddc00 R15: ffff81007eaddf24
> [ 1796.323283] FS:  00002b489f45db00(0000) GS:ffff81007fb6cac0(0000) knlGS:0000000000000000
> [ 1796.331330] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 1796.337043] CR2: 00000000008c7f1c CR3: 0000000068610000 CR4: 00000000000006e0
> [ 1796.344140] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1796.351237] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 1796.358334]
> [ 1796.358334] Call Trace:
> [ 1796.362244]  <IRQ>  [<ffffffff802dee4a>] dio_bio_end_aio+0x3a/0xe0
> [ 1796.368405]  [<ffffffff802dac79>] bio_endio+0x19/0x40
> [ 1796.373430]  [<ffffffff8034fe8e>] req_bio_endio+0x4e/0xa0
> [ 1796.378800]  [<ffffffff80350084>] __end_that_request_first+0x1a4/0x3c0
> [ 1796.385292]  [<ffffffff803502a9>] end_that_request_chunk+0x9/0x10
> [ 1796.391354]  [<ffffffff803e95fb>] scsi_end_request+0x3b/0x110
> [ 1796.397069]  [<ffffffff803e99d5>] scsi_io_completion+0xa5/0x3b0
> [ 1796.402958]  [<ffffffff804a7e06>] _spin_unlock_irqrestore+0x16/0x40
> [ 1796.409192]  [<ffffffff803e3479>] scsi_finish_command+0x99/0xf0
> [ 1796.415079]  [<ffffffff803ea515>] scsi_softirq_done+0x115/0x150
> [ 1796.420967]  [<ffffffff803536db>] blk_done_softirq+0x6b/0x80
> [ 1796.426598]  [<ffffffff802458c4>] __do_softirq+0x64/0xd0
> [ 1796.431883]  [<ffffffff8020d61c>] call_softirq+0x1c/0x30
> [ 1796.437166]  [<ffffffff8020efbd>] do_softirq+0x3d/0x90
> [ 1796.442276]  [<ffffffff802457d8>] irq_exit+0x88/0xa0
> [ 1796.447213]  [<ffffffff8020f095>] do_IRQ+0x85/0x100
> [ 1796.452064]  [<ffffffff8020c971>] ret_from_intr+0x0/0xa
> [ 1796.457258]  <EOI>  [<ffffffff804a799e>] _spin_lock_irqsave+0x6e/0x90
> [ 1796.463678]  [<ffffffff804a796e>] _spin_lock_irqsave+0x3e/0x90
> [ 1796.469479]  [<ffffffff802ddded>] dio_bio_submit+0x2d/0x90
> [ 1796.474935]  [<ffffffff802ddeee>] dio_send_cur_page+0x9e/0xa0
> [ 1796.480648]  [<ffffffff802ddf2e>] submit_page_section+0x3e/0x130
> [ 1796.486623]  [<ffffffff802deb39>] __blockdev_direct_IO+0x979/0xc50
> [ 1796.492783]  [<ffffffff8806591f>] :ext3:ext3_direct_IO+0xaf/0x1c0
> [ 1796.498847]  [<ffffffff88063ad0>] :ext3:ext3_get_block+0x0/0x110
> [ 1796.504825]  [<ffffffff802851ba>] generic_file_direct_IO+0xba/0x160
> [ 1796.511059]  [<ffffffff802852cf>] generic_file_direct_write+0x6f/0x130
> [ 1796.517551]  [<ffffffff80285e13>] __generic_file_aio_write_nolock+0x383/0x440
> [ 1796.524650]  [<ffffffff80285f34>] generic_file_aio_write+0x64/0xd0
> [ 1796.530802]  [<ffffffff88060a26>] :ext3:ext3_file_write+0x26/0xc0
> [ 1796.536865]  [<ffffffff88060a00>] :ext3:ext3_file_write+0x0/0xc0
> [ 1796.542841]  [<ffffffff802cce4f>] aio_rw_vect_retry+0x6f/0x180
> [ 1796.548642]  [<ffffffff802ccde0>] aio_rw_vect_retry+0x0/0x180
> [ 1796.554355]  [<ffffffff802cda19>] aio_run_iocb+0x49/0x110
> [ 1796.559725]  [<ffffffff802ce663>] io_submit_one+0x1d3/0x3f0
> [ 1796.565268]  [<ffffffff802cf22e>] sys_io_submit+0xde/0x140
> [ 1796.570725]  [<ffffffff8020c5dc>] tracesys+0xdc/0xe1

erk, that's dio->bio_lock, isn't it?

That lock is super-simple and hasn't changed in quite some time.  If there
has been major memory wreckage and we're simply grabbing at a "lock" in
random memory then I'd expect the bug to maninfest in different ways on
different runs?

I assume you have lots of runtime debugging options enabled.

