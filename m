Return-Path: <linux-kernel-owner+w=401wt.eu-S1761637AbZAQAhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761637AbZAQAhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 19:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbZAQAhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 19:37:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58752 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbZAQAhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 19:37:18 -0500
Date: Fri, 16 Jan 2009 19:37:14 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.26.6-rt11: BUGs (sleeping function called from invalid
 context)
In-Reply-To: <1232147180.3081.4.camel@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0901161935130.9232@gandalf.stny.rr.com>
References: <1226083858.20569.14.camel@localhost.localdomain>  <alpine.DEB.1.10.0811071400570.3711@gandalf.stny.rr.com>  <1232136975.6326.32.camel@localhost.localdomain>  <alpine.DEB.1.10.0901161548290.8586@gandalf.stny.rr.com>
 <1232147180.3081.4.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 16 Jan 2009, Fernando Lopez-Lezcano wrote:

> On Fri, 2009-01-16 at 15:49 -0500, Steven Rostedt wrote:
> > On Fri, 16 Jan 2009, Fernando Lopez-Lezcano wrote:
> > 
> > > On Fri, 2008-11-07 at 14:01 -0500, Steven Rostedt wrote:
> > > > Peter, I think we've seen this before. It is the highmem code sleeping.
> > > > 
> > > > On Fri, 7 Nov 2008, Fernando Lopez-Lezcano wrote:
> > > > 
> > > > > Three BUGs while booting 2.6.26.7 + rt11 (same hardware: no problems
> > > > > with 2.6.24.7-rt21):
> > > > > 
> > > > > Nov  7 10:31:19 host kernel: BUG: sleeping function called from invalid
> > > > > context IRQ-22(540) at arch/x86/mm/highmem_32.c:8
> > > > > Nov  7 10:31:19 host kernel: in_atomic():0 [00000000], irqs_disabled():1
> > > > > Nov  7 10:31:19 host kernel: Pid: 540, comm: IRQ-22 Not tainted
> > > > > 2.6.26.7-1.rt11.1fc9.ccrma.i686.rt #1
> > > > > Nov  7 10:31:19 host kernel: [<c041ff88>] __might_sleep+0xe8/0xed
> > > > > Nov  7 10:31:19 host kernel: [<c041cd55>] kmap+0x42/0x55
> > > > 
> > > > As here.
> > > 
> > > Still happening in 2.6.26.8-rt13...
> > 
> > Could you try this patch and see if it fixes your issue.
> 
> That particular BUG seems to be gone, so far with no side effects (no
> hard disk explosions or anything like that, hopefully). Thanks!!!

Great to hear!

> 
> Hmmm, I don't remember seeing this before (but I could be wrong):
> 
> irq 19: nobody cared (try booting with the "irqpoll" option)
> Pid: 479, comm: IRQ-19 Not tainted
> 2.6.26.8-1.rt13.2.fc9.ccrma.i686.rtPAE #1
>  [<c0461b70>] __report_bad_irq+0x2e/0x6f
>  [<c0461d6c>] note_interrupt+0x1bb/0x20b
>  [<c0460f6c>] ? handle_IRQ_event+0x49/0xe6
>  [<c046128c>] thread_simple_irq+0x68/0x7c
>  [<c04612a0>] ? do_irqd+0x0/0x229
>  [<c046134f>] do_irqd+0xaf/0x229
>  [<c04612a0>] ? do_irqd+0x0/0x229
>  [<c043b023>] kthread+0x3b/0x61
>  [<c043afe8>] ? kthread+0x0/0x61
>  [<c040481f>] kernel_thread_helper+0x7/0x10
>  =======================
> handlers:
> [<c058d680>] (usb_hcd_irq+0x0/0x61)
> turning off IO-APIC fast mode.
> irq 19: nobody cared (try booting with the "irqpoll" option)
> Pid: 479, comm: IRQ-19 Not tainted
> 2.6.26.8-1.rt13.2.fc9.ccrma.i686.rtPAE #1
>  [<c0461b70>] __report_bad_irq+0x2e/0x6f
>  [<c0461d6c>] note_interrupt+0x1bb/0x20b
>  [<c0460f6c>] ? handle_IRQ_event+0x49/0xe6
>  [<c046128c>] thread_simple_irq+0x68/0x7c
>  [<c04612a0>] ? do_irqd+0x0/0x229
>  [<c046134f>] do_irqd+0xaf/0x229
>  [<c04612a0>] ? do_irqd+0x0/0x229
>  [<c043b023>] kthread+0x3b/0x61
>  [<c043afe8>] ? kthread+0x0/0x61
>  [<c040481f>] kernel_thread_helper+0x7/0x10
>  =======================
> handlers:
> [<c058d680>] (usb_hcd_irq+0x0/0x61)
> 
> Related?

No, but that looks like a boot interrupt issue.

See this (huge) thread for details:

 http://marc.info/?t=123154237900002&r=1&w=2

-- Steve

