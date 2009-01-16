Return-Path: <linux-kernel-owner+w=401wt.eu-S937520AbZAPUuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937520AbZAPUuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 15:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756984AbZAPUtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 15:49:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35222 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933AbZAPUto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 15:49:44 -0500
Date: Fri, 16 Jan 2009 15:49:42 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.26.6-rt11: BUGs (sleeping function called from invalid
 context)
In-Reply-To: <1232136975.6326.32.camel@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0901161548290.8586@gandalf.stny.rr.com>
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

Could you try this patch and see if it fixes your issue.

Thanks,

-- Steve

---
 drivers/ata/libata-sff.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6.26.8-rt13/drivers/ata/libata-sff.c
===================================================================
--- linux-2.6.26.8-rt13.orig/drivers/ata/libata-sff.c	2009-01-16 15:47:38.000000000 -0500
+++ linux-2.6.26.8-rt13/drivers/ata/libata-sff.c	2009-01-16 15:48:07.000000000 -0500
@@ -740,9 +740,9 @@ unsigned int ata_sff_data_xfer_noirq(str
 	unsigned long flags;
 	unsigned int consumed;
 
-	local_irq_save(flags);
+	local_irq_save_nort(flags);
 	consumed = ata_sff_data_xfer(dev, buf, buflen, rw);
-	local_irq_restore(flags);
+	local_irq_restore_nort(flags);
 
 	return consumed;
 }
@@ -780,7 +780,7 @@ static void ata_pio_sector(struct ata_qu
 		unsigned long flags;
 
 		/* FIXME: use a bounce buffer */
-		local_irq_save(flags);
+		local_irq_save_nort(flags);
 		buf = kmap_atomic(page, KM_IRQ0);
 
 		/* do the actual data transfer */
@@ -788,7 +788,7 @@ static void ata_pio_sector(struct ata_qu
 				       do_write);
 
 		kunmap_atomic(buf, KM_IRQ0);
-		local_irq_restore(flags);
+		local_irq_restore_nort(flags);
 	} else {
 		buf = page_address(page);
 		ap->ops->sff_data_xfer(qc->dev, buf + offset, qc->sect_size,
@@ -918,14 +918,14 @@ next_sg:
 		unsigned long flags;
 
 		/* FIXME: use bounce buffer */
-		local_irq_save(flags);
+		local_irq_save_nort(flags);
 		buf = kmap_atomic(page, KM_IRQ0);
 
 		/* do the actual data transfer */
 		consumed = ap->ops->sff_data_xfer(dev,  buf + offset, count, rw);
 
 		kunmap_atomic(buf, KM_IRQ0);
-		local_irq_restore(flags);
+		local_irq_restore_nort(flags);
 	} else {
 		buf = page_address(page);
 		consumed = ap->ops->sff_data_xfer(dev,  buf + offset, count, rw);
