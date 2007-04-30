Return-Path: <linux-kernel-owner+w=401wt.eu-S1031471AbXD3Isl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031471AbXD3Isl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 04:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031473AbXD3Isl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 04:48:41 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52324 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031471AbXD3Isj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 04:48:39 -0400
Date: Mon, 30 Apr 2007 14:18:33 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: 2.6.21-rc7-mm2 "irqpoll" seems to be broken
Message-ID: <20070430084833.GA16173@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070426093620.GB2626@in.ibm.com> <20070426082405.67a0fdd2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426082405.67a0fdd2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 08:24:05AM -0700, Andrew Morton wrote:
> On Thu, 26 Apr 2007 15:06:20 +0530 Vivek Goyal <vgoyal@in.ibm.com> wrote:
> 
> > Hi,
> > 
> > I am booting 2.6.21-rc7-mm2 on x86_64 box with "irqpoll" command line option
> > and it panics. I can reproduce this problem easily on this box. Please
> > let me know if serial console output is required.
> > 
> > 2.6.21-rc7 works just fine. So problem seems to be in some -mm patch.
> > 
> > Unable to handle kernel NULL pointer dereference at 0000000000000009 RIP:
> >  [<ffffffff8025bc5e>] note_interrupt+0x5d/0x21b
> > PGD 1032c5067 PUD 1032c4067 PMD 0
> > Oops: 0000 [1] SMP
> > CPU 1
> > Modules linked in:
> > Pid: 0, comm: swapper Not tainted 2.6.21-rc7-mm2 #1
> > RIP: 0010:[<ffffffff8025bc5e>]  [<ffffffff8025bc5e>] note_interrupt+0x5d/0x21b
> > RSP: 0018:ffff810100cbff08  EFLAGS: 00010002
> > RAX: 0000000000000000 RBX: ffffffff807e2d40 RCX: 0000000000000000
> > RDX: 0000000000000000 RSI: ffffffff807e2d40 RDI: 0000000000000004
> > RBP: ffffffff807e2d40 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000010 R11: 00000000000000a0 R12: ffff810104192f40
> > R13: ffffffff807e2d84 R14: 0000000000000000 R15: 0000000000000000
> > FS:  0000000000000000(0000) GS:ffff810100854140(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > CR2: 0000000000000009 CR3: 00000001032c6000 CR4: 00000000000006e0
> > Process swapper (pid: 0, threadinfo ffff810100cb8000, task ffff810100cb7500)
> > Stack:  0000000000000004 0000000400000000 0000000000000000 ffffffff807e2d40
> >  0000000000000004 ffff810104192f40 ffffffff807e2d84 0000000000000000
> >  0000000000000000 ffffffff8025c7c5 ffff810100cb9e98 ffff810100cb9e98
> > Call Trace:
> >  [<ffffffff8025c7c5>] handle_edge_irq+0xf9/0x127
> >  [<ffffffff8020c2f9>] do_IRQ+0xf1/0x160
> >  [<ffffffff8020a141>] ret_from_intr+0x0/0xa
> >  [<ffffffff80208fd9>] mwait_idle+0x42/0x45
> >  [<ffffffff80208f2f>] cpu_idle+0xbd/0xe0
> > 
> > 
> > Code: f6 40 09 10 75 09 45 85 ff 0f 85 3d 01 00 00 49 c7 c4 c0 2b
> > RIP  [<ffffffff8025bc5e>] note_interrupt+0x5d/0x21b
> >  RSP <ffff810100cbff08>
> > CR2: 0000000000000009
> > Kernel panic - not syncing: Aiee, killing interrupt handler!
> > 
> 
> hm.  I'd be suspecting
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/broken-out/add-irqf_irqpoll-flag-common-code.patch
> and
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/broken-out/add-irqf_irqpoll-flag-on-x86_64.patch
> 
> But because x86_64 doesn't implement IRQ_PER_CPU it's hard to see how we
> got into note_interrupt as a result of that patch.
> 
> Adding the `noirqdebug' boot option would be interesting, perhaps.

"noirqdebug" gets rid of the problem. But that also effectively nullifies
"irqpoll" parameter.

Interestingly on another x86_64 machine this problem does not occur. So
something is dependent on hardware.

I put some debug statements on note_interrupt() and found that desc->action
is a NULL pointer and that's why the problem. Above patch acesses
desc->action->flags, hence it ends up accessing a NULL pointer.

handle_edge_irq() already makes sure that desc->action is not null, still
note_interrupt() is receiving desc->action as null, that's strange. On my 
system this is happening for irq 4 and /proc/interrupt shows that it is
coming from "serial".

Thanks
Vivek

