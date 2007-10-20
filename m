Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbXJTEZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbXJTEZw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 00:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbXJTEZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 00:25:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:64489 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbXJTEZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 00:25:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=bz3m9DOwgnHRvxuWTGeq/K6iIle3ZZoSyJkUc0V+ATPoJQ4dgsAkp3m8Gomjay1lCRFOm2TyMKu63odKB80HsV167H5WUNGbW45xFlNDY96lIqBqUjWoo/EVflQLTuBp0PYW8dtRkgumH7hxUCZt3GOKS121OYSgNeWPa2RWOI8=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: benh@kernel.crashing.org
Subject: Re: [PATCH] synchronize_irq needs a barrier
Date: Sat, 20 Oct 2007 06:24:58 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
References: <1192670742.12879.5.camel@pasglop> <200710200402.43106.maximlevitsky@gmail.com> <1192852561.17235.23.camel@pasglop>
In-Reply-To: <1192852561.17235.23.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710200624.58261.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 October 2007 05:56:01 Benjamin Herrenschmidt wrote:
> 
> > I have read this thread and I concluded few things:
> > 
> > 1) It is impossible to know that the card won't send more interrupts:
> > Even if I do a read from the device, the IRQ can be pending in the bus/APIC
> > It is even possible (and likely) that the IRQ line will be shared, thus the 
> > handler can be called by non-relevant device.
> > 
> > 2) the synchronize_irq(); in .suspend is useless:
> > an IRQ can happen immediately after this synchronize_irq();
> > and interrupt even the .suspend()
> > (At least theoretically)
> 
> It's not totally useless not. It guarantees that by the time your
> are out of your suspend(), a simultaneous instance of the IRQ handler
> is either finished, or it (or any subsequent occurence) have seen
> your insuspend flag set to 1.
> 
> > Thus I now understand that .suspend() should do:
> > 
> > 	saa_writel(SAA7134_IRQ1, 0);
> > 	saa_writel(SAA7134_IRQ2, 0);
> > 	saa_writel(SAA7134_MAIN_CTRL, 0);
> > 
> > 	dev->insuspend = 1;
> > 	smp_wmb();
> > 
> > 	/* at that point the _request to disable card's IRQs was issued, we don't know 
> > 	   that there will be no irqs anymore.
> > 	   the smp_mb(); guaranties that the IRQ handler will bail out in that case. */
> > 	
> > 	/* .......*/
> > 
> > 	pci_save_state(pci_dev);
> > 	pci_set_power_state(pci_dev, pci_choose_state(pci_dev, state));
> > 	return 0;
> 
> The above doesn't handle the case where the IRQ handle just passed the
> if (insuspend) test. You may end up calling pci_set_power_state() while
> in the middle of some further HW accesses in the handler.
> 
> You still need synchronize_irq() for that reason. Or use a spinlock.
> 
> > and the interrupt handler:
> > 
> > 	smp_rmb();
> > 	if (dev->insuspend)
> > 		goto out;
> > 
> > Am I right?
> 
> Not quite :-)
> 
> Also not that the work we are doing with synchronize_irq, if it gets
> merged, renders it unnecessary for you to add those two memory barriers,
> synchronize_irq will pretty much do the ordering for you.
> 
> Cheers,
> Ben.
> 
> 


Fine, I Agree, and this is why I used it in first place, I just forgot.
To wait for already running IRQ handler, that tested the dev->insuspend.
(And I assumed that interrupts are disabled on the cpu that runs .suspend, but I know now
that this isn't true.)

Besides that can I ask few more .suspend/resume questions:

1) some drivers use pci_disable_device(), and pci_enable_device().
should I use it too?

2) I accidentally did this:
	pci_set_power_state(pci_dev, pci_choose_state(pci_dev, state));
	pci_save_state(pci_dev);

I somehow thought that this is correct, that I should save the pci config state
after the power-down, but now I know that it isn't correct.
I now need to send a patch for dmfe.c network driver that has the same commands written by me.
(but it works perfectly anyway)
Is it possible to access pci configuration space in D3?

And lastly speaking of network drivers, one issue came to my mind:
most network drivars has a packet queue and in case of dmfe it is located in main memory,
and card does dma from it.


in .suspend I ignore that some packets may be in that queue, and I want
to ask, whenever there are better ways to do that.


this is my dmfe .suspend routine.

	/* Disable upper layer interface */
	netif_device_detach(dev);

	/* Disable Tx/Rx */
	db->cr6_data &= ~(CR6_RXSC | CR6_TXSC);
	update_cr6(db->cr6_data, dev->base_addr);

	/* Disable Interrupt */
	outl(0, dev->base_addr + DCR7);
	outl(inl (dev->base_addr + DCR5), dev->base_addr + DCR5);

	/* Fre RX buffers */
	dmfe_free_rxbuffer(db);

	/* Enable WOL */
	pci_read_config_dword(pci_dev, 0x40, &tmp);
	tmp &= ~(DMFE_WOL_LINKCHANGE|DMFE_WOL_MAGICPACKET);

	if (db->wol_mode & WAKE_PHY)
		tmp |= DMFE_WOL_LINKCHANGE;
	if (db->wol_mode & WAKE_MAGIC)
		tmp |= DMFE_WOL_MAGICPACKET;

	pci_write_config_dword(pci_dev, 0x40, tmp);

	pci_enable_wake(pci_dev, PCI_D3hot, 1);
	pci_enable_wake(pci_dev, PCI_D3cold, 1);

	/* Power down device*/
	pci_set_power_state(pci_dev, pci_choose_state (pci_dev,state));
	pci_save_state(pci_dev);


I guess, everybody makes mistakes... :-)

Other network drivers has a bit more complicated .suspend/.resume routines, 
but I didn't see a driver waiting for output queue to finish

Best regards,
	Maxim Levitsky


