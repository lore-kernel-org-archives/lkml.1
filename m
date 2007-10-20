Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbXJTFE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbXJTFE4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 01:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbXJTFEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 01:04:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:33237 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbXJTFEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 01:04:48 -0400
Subject: Re: [PATCH] synchronize_irq needs a barrier
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
In-Reply-To: <200710200624.58261.maximlevitsky@gmail.com>
References: <1192670742.12879.5.camel@pasglop>
	 <200710200402.43106.maximlevitsky@gmail.com>
	 <1192852561.17235.23.camel@pasglop>
	 <200710200624.58261.maximlevitsky@gmail.com>
Content-Type: text/plain
Date: Sat, 20 Oct 2007 15:04:35 +1000
Message-Id: <1192856675.6745.5.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 1) some drivers use pci_disable_device(), and pci_enable_device().
> should I use it too?

I generally don't do the former, and I would expect the late to be done
by pci_restore_state() for you. pci_disable_device(), last I looked,
only cleared the bus master bit though, which might be a good idea to
do.

People in ACPI/x86 land, are there more good reasons to do one or the
other ?

That reminds me that I volunteered to write a documentation on how
drivers should do all that stuff at KS and didn't get to actually doing
it yet. shame ... I'll try to start something asap.

> 2) I accidentally did this:
> 	pci_set_power_state(pci_dev, pci_choose_state(pci_dev, state));
> 	pci_save_state(pci_dev);
> 
> I somehow thought that this is correct, that I should save the pci config state
> after the power-down, but now I know that it isn't correct.

Right, you need to do the save_state before the power down. You need to
avoid pretty much any access to the device after the save state other
than the pending set_power_state on resume.

> I now need to send a patch for dmfe.c network driver that has the same commands written by me.
> (but it works perfectly anyway)

On x86 desktop... might have surprises on others.

> Is it possible to access pci configuration space in D3?

It's only really safe to access the PM register itself, though I suppose
you should be able to walk the capability chain to do that. But I
wouldnt recommend doing anything else.

> And lastly speaking of network drivers, one issue came to my mind:
> most network drivars has a packet queue and in case of dmfe it is located in main memory,
> and card does dma from it.

Note that the network stack nowadays does a fair bit of cleaning up for
you before your suspend routine is called....
> 
> in .suspend I ignore that some packets may be in that queue, and I want
> to ask, whenever there are better ways to do that.
> 
> 
> this is my dmfe .suspend routine.
> 
> 	/* Disable upper layer interface */
> 	netif_device_detach(dev);

The above -might- not be needed any more, I have to check. I used to do
it too on my drivers.

> 	/* Disable Tx/Rx */
> 	db->cr6_data &= ~(CR6_RXSC | CR6_TXSC);
> 	update_cr6(db->cr6_data, dev->base_addr);
> 
> 	/* Disable Interrupt */
> 	outl(0, dev->base_addr + DCR7);
> 	outl(inl (dev->base_addr + DCR5), dev->base_addr + DCR5);
> 
> 	/* Fre RX buffers */
> 	dmfe_free_rxbuffer(db);
> 
> 	/* Enable WOL */
> 	pci_read_config_dword(pci_dev, 0x40, &tmp);
> 	tmp &= ~(DMFE_WOL_LINKCHANGE|DMFE_WOL_MAGICPACKET);
> 
> 	if (db->wol_mode & WAKE_PHY)
> 		tmp |= DMFE_WOL_LINKCHANGE;
> 	if (db->wol_mode & WAKE_MAGIC)
> 		tmp |= DMFE_WOL_MAGICPACKET;
> 
> 	pci_write_config_dword(pci_dev, 0x40, tmp);
> 
> 	pci_enable_wake(pci_dev, PCI_D3hot, 1);
> 	pci_enable_wake(pci_dev, PCI_D3cold, 1);
> 
> 	/* Power down device*/
> 	pci_set_power_state(pci_dev, pci_choose_state (pci_dev,state));
> 	pci_save_state(pci_dev);
> 

Looks allright on a quick glance appart from the bits we already
discussed.

> I guess, everybody makes mistakes... :-)
> 
> Other network drivers has a bit more complicated .suspend/.resume routines, 
> but I didn't see a driver waiting for output queue to finish

I think the network stack does that nowadays but we'll have to double
check, that's based on what DaveM told me at KS.

Ben. 

