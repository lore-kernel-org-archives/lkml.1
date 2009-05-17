Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbZEQNc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbZEQNc1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 09:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZEQNcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 09:32:16 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:17058 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbZEQNcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 09:32:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wyb7r1THqPLxTIZftW3WFaBeU2oahxpgOF/PiJ7sEJwfN2761PXsuOjme4mnaKUnAL
         HU6t3oYhCWMc6KryKYKdThUbh1jFxaf5MJIIxO0MlAyqAi6FjMBYa6JJi9L/gG6JunKk
         FclzaFapIQuQTuyIBUwDU//g4deTeuXgJWfpo=
Date: Sun, 17 May 2009 15:32:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Helge Deller <deller@gmx.de>,
       Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: 2.6.30-rc6: Reported regressions from 2.6.29
Message-ID: <20090517133210.GB4640@nowhere>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <20090517073327.GC1583@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090517073327.GC1583@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 17, 2009 at 09:33:27AM +0200, Ingo Molnar wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13297
> > Subject		: kernel panic -  not syncing : fatel exception in interupt
> > Submitter	: rob <rob1@housetosell.net>
> > Date		: 2009-05-12 19:34 (5 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124216126903309&w=4
> 
> tainted crash, but probably legit. It does show some badness in an 
> old-IDE legacy codepath:
> 
> [<c0371865>] error_code+0x65/0x6c
> [<c0110155>] do_page_fault+0x0/0x1e0
> [<c027dafc>] ide_complete_rq+0xf/0x3b
> [<c02870a0>] cdrom_newpc_intr+0x64d/0x6cd
> [<c0286a53>] cdrom_newpc_intr+0x0/0x6cd
> [<c027dcc2>] ide_intr+0x109/0x161
> [<c0132298>] handle_IRQ_event+0x54/0xc7
> [<c013354a>] handle_level_irq+0x4f/0x85
> [<c0103df7>] handle_irq+0x17/0x20
> [<c0103da5>] do_IRQ+0x2b/0x66
> [<c0102be9>] common_interupt+0x29/0x30
> [<c0480000>] cmd40x_init+0x2ac/0x38d
> [<c0106db3>] default_idle+0x25/0x38
> [<c01019be>] cpu_idle+0x19/0x2d
> [<c0468907>] start_kernel+0x23f/0x242
> 
> report subject line is too unspecific, it should be changed to 
> something like:
> 
>   legacy IDE cmd40x related bootup crash


It seems the crash has been rewritten by hand. I don't see
any cmd40x_init(), I guess it's about cmd640 chipset, then
cmd640x_init()

I don't see very recent changes in drivers/ide/cmd640.c
But there are some in drivers/ide/ide-io.c and drivers/ide/ide-cd.c
for this cycle.

Especially commit a1f9a89c90b4ac143c5b6054c2a157572b272cd2 which
fixed in -rc2:

 Kernel Fault: Code=26 regs=8ed34c40 (Addr=00000024)
     IASQ: 00000000 00000000 IAOQ: 1034b5ac 1034b5b0
     IIR: 4ab30048    ISR: 00000000  IOR: 00000024
     CPU:        0   CR30: 8ed34000 CR31: ffff55ff
     ORIG_R28: 00000000
     IAOQ[0]: ide_complete_rq+0x2c/0x70
     IAOQ[1]: ide_complete_rq+0x30/0x70
     RP(r2): cdrom_newpc_intr+0x178/0x46c
    Backtrace:
     [<1035c608>] cdrom_newpc_intr+0x178/0x46c
     [<1034c494>] ide_intr+0x1b0/0x214
     [<1016d284>] handle_IRQ_event+0x70/0x150
     [<1016d4b0>] __do_IRQ+0x14c/0x1cc
     [<102f7864>] superio_interrupt+0x88/0xbc
     [<1016d284>] handle_IRQ_event+0x70/0x150
     [<1016d4b0>] __do_IRQ+0x14c/0x1cc
     [<10112efc>] do_cpu_irq_mask+0x9c/0xd0
     [<10116068>] intr_return+0x0/0x4

Looks very similar. But the crash reported in this ticket is for -rc4, which means the
issue was still there after this fix or it's another one.
Adding some more Cc's.

Frederic.

