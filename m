Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbZA1VGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbZA1VGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:06:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756961AbZA1VFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:05:52 -0500
Received: from sh.osrg.net ([192.16.179.4]:36619 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755896AbZA1VFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:05:51 -0500
Date: Thu, 29 Jan 2009 06:05:20 +0900
To: peterz@infradead.org
Cc: hias@horus.com, linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       tj@kernel.org, fujita.tomonori@lab.ntt.co.jp,
       James.Bottomley@HansenPartnership.com
Subject: Re: 2.6.28 regression: hard lockup when interrupting cdda2wav
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1233162805.10992.60.camel@laptop>
References: <20090128164140.GA5557@horus.com>
	<1233162805.10992.60.camel@laptop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090129060600C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 18:13:25 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2009-01-28 at 17:41 +0100, Matthias Reichl wrote:
> > 
> > I think I found a regression in the 2.6.28 kernel (tested with 2.6.28
> > and 2.6.28.2). With 2.6.27.6 and 2.6.27.13 everything is fine.
> > 
> > If I interrupt cdda2wav (pressing ctrl-c) while extracting an audio
> > track, the kernel locks up. SysReq (or sending a break via the
> > serial console) doesn't work, only pressing reset helps.
> > 
> > I tested with cdda2wav from the original cdrtools code, version
> > 2.01.01a57pre2 and some older versions.
> > 
> > To reproduce this bug, try "cdda2wav -dev=x,y,z 1" and then press
> > ctrl-c while the track is being ripped.
> > 
> > Here are the messages printed to the console:
> > 
> > =============================================
> > [ INFO: possible recursive locking detected ]
> > 2.6.28.2-dbg #1
> > ---------------------------------------------
> > swapper/0 is trying to acquire lock:
> >  (&q->__queue_lock){.+..}, at: [<ffffffff8040e3d5>] blk_put_request+0x25/0x60
> > 
> > but task is already holding lock:
> >  (&q->__queue_lock){.+..}, at: [<ffffffff8040e2ba>] blk_end_io+0x5a/0xa0
> > 
> > other info that might help us debug this:
> > 1 lock held by swapper/0:
> >  #0:  (&q->__queue_lock){.+..}, at: [<ffffffff8040e2ba>] blk_end_io+0x5a/0xa0
> > 
> > stack backtrace:
> > Pid: 0, comm: swapper Not tainted 2.6.28.2-dbg #1
> > Call Trace:
> >  <IRQ>  [<ffffffff8026cbb7>] __lock_acquire+0x1797/0x1930
> >  [<ffffffff806abb3b>] error_exit+0x29/0xa9
> >  [<ffffffff80521be0>] sg_rq_end_io+0x0/0x2e0
> >  [<ffffffff8026cdea>] lock_acquire+0x9a/0xe0
> >  [<ffffffff8040e3d5>] blk_put_request+0x25/0x60
> >  [<ffffffff806ab523>] _spin_lock_irqsave+0x43/0x90
> >  [<ffffffff8040e3d5>] blk_put_request+0x25/0x60
> >  [<ffffffff8040e3d5>] blk_put_request+0x25/0x60
> >  [<ffffffff80520734>] sg_finish_rem_req+0xa4/0x100
> >  [<ffffffff80521e58>] sg_rq_end_io+0x278/0x2e0
> >  [<ffffffff8040e061>] end_that_request_last+0x61/0x260
> >  [<ffffffff8040e2c8>] blk_end_io+0x68/0xa0
> >  [<ffffffff80507e21>] scsi_end_request+0x41/0xd0
> >  [<ffffffff80508510>] scsi_io_completion+0x130/0x470
> >  [<ffffffff804131c5>] blk_done_softirq+0x75/0x90
> >  [<ffffffff802487eb>] __do_softirq+0x9b/0x180
> >  [<ffffffff80213df3>] native_sched_clock+0x13/0x70
> >  [<ffffffff8020d6ec>] call_softirq+0x1c/0x30
> >  [<ffffffff8020f175>] do_softirq+0x65/0xa0
> >  [<ffffffff80248285>] irq_exit+0xa5/0xb0
> >  [<ffffffff8020f467>] do_IRQ+0x107/0x1d0
> >  [<ffffffff8020c7fb>] ret_from_intr+0x0/0xf
> >  <EOI>  [<ffffffff80214ba6>] mwait_idle+0x56/0x60
> >  [<ffffffff80214b9d>] mwait_idle+0x4d/0x60
> >  [<ffffffff8020b353>] cpu_idle+0x63/0xc0
> 
> 
> Indeed, it looks like sg_rq_end_io() goes funny by calling
> blk_put_request() where those without ->end_io() method call
> __blk_put_request().
> 
> CC'ed those who actually know what the code is about.

Sorry about the bug.

Interrupting a program without waiting for a sg response leads to the
special state, the orphan state. Then you hit this. I realized this
bug recently. I'll fix this shortly.

Thanks,
