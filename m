Return-Path: <linux-kernel-owner+w=401wt.eu-S1759178AbZFNOpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759178AbZFNOpg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 10:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbZFNOp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 10:45:28 -0400
Received: from www.tglx.de ([62.245.132.106]:60264 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849AbZFNOp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 10:45:28 -0400
Date: Sun, 14 Jun 2009 16:45:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
cc: "Benjamin S." <sbenni@gmx.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "js@sig21.net" <js@sig21.net>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>
Subject: RE: 2.6.30 enabling cpu1 on resume fails after suspend to memory
In-Reply-To: <alpine.LFD.2.00.0906141548490.2800@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0906141644190.2800@localhost.localdomain>
References: <20090614120950.116536fa@pluto-lenny.milky.way> <200906141400.27331.rjw@sisk.pl> <alpine.LFD.2.00.0906141405450.2800@localhost.localdomain> <200906141415.16949.rjw@sisk.pl> <20090614143708.32ec250c@pluto-lenny.milky.way>
 <alpine.LFD.2.00.0906141444500.2800@localhost.localdomain> <7E82351C108FA840AB1866AC776AEC4669244187@orsmsx505.amr.corp.intel.com> <alpine.LFD.2.00.0906141514120.2800@localhost.localdomain> <7E82351C108FA840AB1866AC776AEC466924418A@orsmsx505.amr.corp.intel.com>
 <alpine.LFD.2.00.0906141548490.2800@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin,

On Sun, 14 Jun 2009, Thomas Gleixner wrote:
> On Sun, 14 Jun 2009, Pallipadi, Venkatesh wrote:
> > >Benjamin just confirmed that. The logic in disable_device_interrupts()
> > >already skips interrupts marked with IRQF_TIMER, but I suspect that
> > >the hpet/MSI interupts are not marked that way.
> > >
> > 
> > For percpu hpet at offline we will have
> > - clockevent shutdown which will disable the interrupt
> > - free_irq that will unregister on CPU DEAD
> 
> Well, the interupt in question is on the boot cpu which is not going
> through CPU DEAD :)

can you please test the patch below.

Thanks,

	tglx
------------>
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 81408b9..dedc2bd 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -510,7 +510,8 @@ static int hpet_setup_irq(struct hpet_dev *dev)
 {
 
 	if (request_irq(dev->irq, hpet_interrupt_handler,
-			IRQF_DISABLED|IRQF_NOBALANCING, dev->name, dev))
+			IRQF_TIMER | IRQF_DISABLED | IRQF_NOBALANCING,
+			dev->name, dev))
 		return -1;
 
 	disable_irq(dev->irq);
