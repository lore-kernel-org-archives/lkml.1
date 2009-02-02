Return-Path: <linux-kernel-owner+w=401wt.eu-S1759063AbZBBXTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063AbZBBXTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 18:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbZBBXT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 18:19:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752913AbZBBXT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 18:19:27 -0500
Date: Mon, 2 Feb 2009 15:18:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: PCI PM: Restore standard config registers of all devices early
In-Reply-To: <200902022331.49131.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0902021508340.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <200902022239.02453.rjw@sisk.pl> <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain> <200902022331.49131.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Feb 2009, Rafael J. Wysocki wrote:
> > 
> > 	b) disable_device_irq()'s: things are live, but device interrupts 
> > 	   are turned off by essentially looping over the irq_desc_ptr[] 
> > 	   table. 
> 
> Well, do we actually need to turn off all device interrupts?
> 
> Shared interrupts are the source of the problem, so perhaps we can
> only disable interrupts of devices that use interrupt pins at this point
> (MSI/MSI-X need not be disabled, for example, and the timer interrupts most
> probably too)?

We could try that, yes.

> > 	d) disable CPU interrupts.
> 
> At what point do we disable the other CPUs?

I left it out, because I don't much care or think it matters. So take your 
pick. I'd suggest keeping the current setup, and literally just insert the 
new point between "device_power_off()" and "sysdev_suspend()", with _zero_ 
other changes.

> Well, it means reworking the entire suspend sequence (again) or we will
> break assumptions made by some existing drivers (interrupts off during
> suspend_late and resume_early).  And that affects all drivers, not only PCI.

No it doesn't.

No changes AT ALL to the suspend sequence. We do everything in the same 
order: look at my patch. The only difference is that instead of doing that 
"cli" we do the "for_each_irq(disable_irq)" instead (and do the 'cli' a 
bit later).

ZERO effect on drivers. The calling convention is 100% the same as far as 
the driver is concerned: ->suspend() is called with interrupts on and a 
fully working machine, and ->suspend_late() called with interrupts off.

The only difference is the _mechanism_ of turning interrupts off. NOTHING 
else.

> I first would like to understand what _exactly_ breaks on the iBook reported to
> have problems.

I bet it's code like the USB one:

	int usb_hcd_pci_resume(struct pci_dev *dev)
	{

	#ifdef CONFIG_PPC_PMAC
	        /* Reenable ASIC clocks for USB */
	        if (machine_is(powermac)) {
	                struct device_node *of_node;

	                of_node = pci_device_to_OF_node(dev);
	                if (of_node)
	                        pmac_call_feature(PMAC_FTR_USB_ENABLE,
	                                                of_node, 0, 1);
	        }
	#endif
	..
	        retval = pci_enable_device(dev);  

and now pci_enable_device() calls pci_raw_set_power_state(), which does:

	        if (dev->current_state == state) {
	                /* we're already there */
	                return 0;
		} else ..

which means that it doesn't actually _do_ anything, because it thinks that 
'current_state' was already PCI_D0. But if the device was totally turned 
off, that's wrong. 

(background: pci_restore_standard_config() will have done 
pci_raw_set_power_state(PCI_D0) with the device clocks off, which wouldn't 
actualyl have _done_ anythign to the device, but then it does

	dev->current_state = PCI_D0;

Maybe the simplest thing to do migth be to replace that with a

	pci_update_current_state(dev, PCI_D0);

instead, to try to read back the state explicitly in 
pci_restore_standard_config()).

Best test:

Ben, does this trivial patch make any difference for those powermacs?

		Linus
---
 drivers/pci/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 17bd932..97e1c38 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1419,7 +1419,7 @@ int pci_restore_standard_config(struct pci_dev *dev)
 		}
 	}
 
-	dev->current_state = PCI_D0;
+	pci_update_current_state(dev, PCI_D0);
 
 	return 0;
 }
