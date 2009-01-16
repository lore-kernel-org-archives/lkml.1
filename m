Return-Path: <linux-kernel-owner+w=401wt.eu-S933031AbZAPXGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031AbZAPXGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 18:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758415AbZAPXG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 18:06:29 -0500
Received: from smtp5.Stanford.EDU ([171.67.219.85]:47902 "EHLO
	smtp5.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757102AbZAPXG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 18:06:28 -0500
Subject: Re: 2.6.26.6-rt11: BUGs (sleeping function called from invalid
	context)
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <alpine.DEB.1.10.0901161548290.8586@gandalf.stny.rr.com>
References: <1226083858.20569.14.camel@localhost.localdomain>
	 <alpine.DEB.1.10.0811071400570.3711@gandalf.stny.rr.com>
	 <1232136975.6326.32.camel@localhost.localdomain>
	 <alpine.DEB.1.10.0901161548290.8586@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 15:06:20 -0800
Message-Id: <1232147180.3081.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-16 at 15:49 -0500, Steven Rostedt wrote:
> On Fri, 16 Jan 2009, Fernando Lopez-Lezcano wrote:
> 
> > On Fri, 2008-11-07 at 14:01 -0500, Steven Rostedt wrote:
> > > Peter, I think we've seen this before. It is the highmem code sleeping.
> > > 
> > > On Fri, 7 Nov 2008, Fernando Lopez-Lezcano wrote:
> > > 
> > > > Three BUGs while booting 2.6.26.7 + rt11 (same hardware: no problems
> > > > with 2.6.24.7-rt21):
> > > > 
> > > > Nov  7 10:31:19 host kernel: BUG: sleeping function called from invalid
> > > > context IRQ-22(540) at arch/x86/mm/highmem_32.c:8
> > > > Nov  7 10:31:19 host kernel: in_atomic():0 [00000000], irqs_disabled():1
> > > > Nov  7 10:31:19 host kernel: Pid: 540, comm: IRQ-22 Not tainted
> > > > 2.6.26.7-1.rt11.1fc9.ccrma.i686.rt #1
> > > > Nov  7 10:31:19 host kernel: [<c041ff88>] __might_sleep+0xe8/0xed
> > > > Nov  7 10:31:19 host kernel: [<c041cd55>] kmap+0x42/0x55
> > > 
> > > As here.
> > 
> > Still happening in 2.6.26.8-rt13...
> 
> Could you try this patch and see if it fixes your issue.

That particular BUG seems to be gone, so far with no side effects (no
hard disk explosions or anything like that, hopefully). Thanks!!!

Hmmm, I don't remember seeing this before (but I could be wrong):

irq 19: nobody cared (try booting with the "irqpoll" option)
Pid: 479, comm: IRQ-19 Not tainted
2.6.26.8-1.rt13.2.fc9.ccrma.i686.rtPAE #1
 [<c0461b70>] __report_bad_irq+0x2e/0x6f
 [<c0461d6c>] note_interrupt+0x1bb/0x20b
 [<c0460f6c>] ? handle_IRQ_event+0x49/0xe6
 [<c046128c>] thread_simple_irq+0x68/0x7c
 [<c04612a0>] ? do_irqd+0x0/0x229
 [<c046134f>] do_irqd+0xaf/0x229
 [<c04612a0>] ? do_irqd+0x0/0x229
 [<c043b023>] kthread+0x3b/0x61
 [<c043afe8>] ? kthread+0x0/0x61
 [<c040481f>] kernel_thread_helper+0x7/0x10
 =======================
handlers:
[<c058d680>] (usb_hcd_irq+0x0/0x61)
turning off IO-APIC fast mode.
irq 19: nobody cared (try booting with the "irqpoll" option)
Pid: 479, comm: IRQ-19 Not tainted
2.6.26.8-1.rt13.2.fc9.ccrma.i686.rtPAE #1
 [<c0461b70>] __report_bad_irq+0x2e/0x6f
 [<c0461d6c>] note_interrupt+0x1bb/0x20b
 [<c0460f6c>] ? handle_IRQ_event+0x49/0xe6
 [<c046128c>] thread_simple_irq+0x68/0x7c
 [<c04612a0>] ? do_irqd+0x0/0x229
 [<c046134f>] do_irqd+0xaf/0x229
 [<c04612a0>] ? do_irqd+0x0/0x229
 [<c043b023>] kthread+0x3b/0x61
 [<c043afe8>] ? kthread+0x0/0x61
 [<c040481f>] kernel_thread_helper+0x7/0x10
 =======================
handlers:
[<c058d680>] (usb_hcd_irq+0x0/0x61)

Related?
-- Fernando

> ---
>  drivers/ata/libata-sff.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6.26.8-rt13/drivers/ata/libata-sff.c
> ===================================================================
> --- linux-2.6.26.8-rt13.orig/drivers/ata/libata-sff.c	2009-01-16 15:47:38.000000000 -0500
> +++ linux-2.6.26.8-rt13/drivers/ata/libata-sff.c	2009-01-16 15:48:07.000000000 -0500
> @@ -740,9 +740,9 @@ unsigned int ata_sff_data_xfer_noirq(str
>  	unsigned long flags;
>  	unsigned int consumed;
>  
> -	local_irq_save(flags);
> +	local_irq_save_nort(flags);
>  	consumed = ata_sff_data_xfer(dev, buf, buflen, rw);
> -	local_irq_restore(flags);
> +	local_irq_restore_nort(flags);
>  
>  	return consumed;
>  }
> @@ -780,7 +780,7 @@ static void ata_pio_sector(struct ata_qu
>  		unsigned long flags;
>  
>  		/* FIXME: use a bounce buffer */
> -		local_irq_save(flags);
> +		local_irq_save_nort(flags);
>  		buf = kmap_atomic(page, KM_IRQ0);
>  
>  		/* do the actual data transfer */
> @@ -788,7 +788,7 @@ static void ata_pio_sector(struct ata_qu
>  				       do_write);
>  
>  		kunmap_atomic(buf, KM_IRQ0);
> -		local_irq_restore(flags);
> +		local_irq_restore_nort(flags);
>  	} else {
>  		buf = page_address(page);
>  		ap->ops->sff_data_xfer(qc->dev, buf + offset, qc->sect_size,
> @@ -918,14 +918,14 @@ next_sg:
>  		unsigned long flags;
>  
>  		/* FIXME: use bounce buffer */
> -		local_irq_save(flags);
> +		local_irq_save_nort(flags);
>  		buf = kmap_atomic(page, KM_IRQ0);
>  
>  		/* do the actual data transfer */
>  		consumed = ap->ops->sff_data_xfer(dev,  buf + offset, count, rw);
>  
>  		kunmap_atomic(buf, KM_IRQ0);
> -		local_irq_restore(flags);
> +		local_irq_restore_nort(flags);
>  	} else {
>  		buf = page_address(page);
>  		consumed = ap->ops->sff_data_xfer(dev,  buf + offset, count, rw);

