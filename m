Return-Path: <linux-kernel-owner+w=401wt.eu-S932090AbZAPUmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090AbZAPUmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 15:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbZAPUl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 15:41:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36322 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbZAPUl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 15:41:56 -0500
Date: Fri, 16 Jan 2009 15:41:54 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.26.6-rt11: BUGs (sleeping function called from invalid
 context)
In-Reply-To: <1232136975.6326.32.camel@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0901161533520.22303@gandalf.stny.rr.com>
References: <1226083858.20569.14.camel@localhost.localdomain>  <alpine.DEB.1.10.0811071400570.3711@gandalf.stny.rr.com> <1232136975.6326.32.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 16 Jan 2009, Fernando Lopez-Lezcano wrote:

> On Fri, 2008-11-07 at 14:01 -0500, Steven Rostedt wrote:
> > Peter, I think we've seen this before. It is the highmem code sleeping.
> > 
> > On Fri, 7 Nov 2008, Fernando Lopez-Lezcano wrote:
> > 
> > > Three BUGs while booting 2.6.26.7 + rt11 (same hardware: no problems
> > > with 2.6.24.7-rt21):
> > > 
> > > Nov  7 10:31:19 host kernel: BUG: sleeping function called from invalid
> > > context IRQ-22(540) at arch/x86/mm/highmem_32.c:8
> > > Nov  7 10:31:19 host kernel: in_atomic():0 [00000000], irqs_disabled():1
> > > Nov  7 10:31:19 host kernel: Pid: 540, comm: IRQ-22 Not tainted
> > > 2.6.26.7-1.rt11.1fc9.ccrma.i686.rt #1
> > > Nov  7 10:31:19 host kernel: [<c041ff88>] __might_sleep+0xe8/0xed
> > > Nov  7 10:31:19 host kernel: [<c041cd55>] kmap+0x42/0x55
> > 
> > As here.
> 
> Still happening in 2.6.26.8-rt13...

Fernando,

Thanks for reporting this. Looks like we need to fix the ata driver:

2.6.26.8-rt13:

drivers/ata/libata-sff.c:

 ata_sff_hsm_move()
 calls ata_pio_sectors(), calls

   ata_pio_sector()

		/* FIXME: use a bounce buffer */
		local_irq_save(flags);
		buf = kmap_atomic(page, KM_IRQ0);

This code is in 2.6.24-rt but in libata-core.c
It is slightly different, prehaps you were just lucky?

-- Steve

