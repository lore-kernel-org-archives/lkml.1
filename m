Return-Path: <linux-kernel-owner+w=401wt.eu-S1752199AbXCNRHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbXCNRHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 13:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbXCNRHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 13:07:46 -0400
Received: from smtp.osdl.org ([65.172.181.24]:46029 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbXCNRHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 13:07:42 -0400
Date: Wed, 14 Mar 2007 10:07:16 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       michal.k.k.piotrowski@gmail.com, linux-ide@vger.kernel.org,
       tglx@linutronix.de, mlord@pobox.com, linux-pm@lists.osdl.org
Subject: Re: [PATCH/RFC] PCI prepare/activate instead of enable to avoid IRQ
 storm and rogue DMA access
Message-ID: <20070314100716.5965dca1@freekitty>
In-Reply-To: <20070314152302.GB15600@htj.dyndns.org>
References: <20070314152302.GB15600@htj.dyndns.org>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007 00:23:02 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Hello, all.
> 
> This patch started off from the following thread.
> 
>   http://thread.gmane.org/gmane.linux.ide/16899
> 
> The problem is that a PCI device can be in any arbitrary when it gets
> enabled and the device has to be enabled for its driver to
> initialize/reset it.  The most common case this causes headache is as
> follows.
> 
> Let's assume there's a device which shares its INTX IRQ line with
> another device and the other one is already initialized.  During boot,
> due to BIOS's fault, bad hardware design or sheer bad luck, the device
> has got a pending IRQ.  When its driver enables the device, the
> pending IRQ hits INTX.  The IRQ line has been enabled by the other
> driver sharing the IRQ but IRQ handler for this device hasn't been
> registered yet.  So, screaming interrupts.  IRQ subsystem shuts up the
> IRQ line in an attempt to save the machine from complete lockup and
> both devices end up dead.
> 
> There seem to be other scenarios that this can be triggered as,
> reportedly, similar behavior is also observed when IRQ line is not
> shared.  I suspect similar thing can and is more likely to happen
> while resuming as the device can really be in any random state.
> 
> The dilemma here is that 1. the device needs to be enabled to be
> initialized/reset 2. enabling the device may cause all hell to break
> loose.  Note that bus mastering has similar risks and we are currently
> dealing with that by doing pci_set_master() from each driver after
> certain initialization steps are taken.
> 
> This patch expands the pci_set_master() approach.  Instead of enabling
> the device in one go, it's done in two steps - prepare and activate.
> 'prepare' enables access to PCI configuration, IO, MMIO but prohibits
> the device from bus mastering or raising IRQ by adjusting respective
> PCI control bits prior to enabling the device.  The second step
> 'activate' allows the device to bus master and raise IRQs.  Typical
> initialization would look like the following.
> 
>   static int __devinit my_init_one(blah blah)
>   {
> 	...
> 
> 	rc = pcim_prepare_device(pdev);
> 	if (rc)
> 		return rc;
> 
> 	/*
> 	 * reset the controller and initialize msi/msix, whatnot
> 	 */
> 
> 	rc = devm_request_irq(&pdev->dev, blah blah);
> 	if (rc)
> 		return rc;
> 
> 	rc = pcim_activate_device(pdev);
> 	if (rc)
> 		return rc;
> 
> 	/*
> 	 * register to upper layer, probe sub devices, etc...
> 	 */
> 
> 	return 0;
> }
> 
> I've implemented it only as part of resource managed interface because
> I didn't want to multiply interface functions with permutations && PCI
> devres already has some of the needed feature.  If non-managed
> interface is ever necessary, that should be doable.
> 
> Anyways, pcim_prepare_device() makes sure bus master is off, INTX (see
> gotchas below), MSI and MSIX are disabled, then enables the device.
> When it returns, the driver can access the device to initialize it but
> the device can't havoc the rest of the system during initialization.
> 
> After most things are set up and IRQ handler is registered, the driver
> calls pcim_activate_device() which allows the device to master bus and
> raise IRQs.  Note that PCI layer keeps track of which IRQ mechanism is
> in use and enable only that one.
> 
> Similar thing is done during resume.  pci_restore_state() restores PCI
> configuration space but makes sure bus master and IRQ mechanisms are
> disabled.  Driver has to call pcim_activate_device() after it has
> restored the device into sane state.
> 
> This change makes init and resume more safe & robust without adding
> too much complexity and easily applicable to existing drivers.
> 
> I've converted skge and sky2 as example.  skge is only compile tested
> and sky2 is lightly tested.
> 
> ** GOTCHAS
> 
> * DISABLE_INTX is relatively new thing.  Older devices don't support
>   the bit and there seems to be no way whether to determine this bit
>   is implemented or not.
> 
> * Currently bus master bit is set unconditonally on activation.  Is
>   this okay?
> 
> * MSI IRQ masking isn't considered during activation.  Can be fixed
>   easily.
> 
> * Hmmm... prepare/activate?  Any better names?
> 
> The patch is against linus #master[M] as of today and converts skge
> and sky2 to use new prepare/activate model.
> 
> So, what do you think?
> 

The problem is the BIOS is busted on these machines. How much effort
do we want to put into dealing with systems with broken BIOS?
I would rather have the root cause fixed than creating a bandaid that
has to be maintained for all the other architectures and platforms.

What if the device with the IRQ problem is never loaded? Sometimes
devices aren't loaded until after boot.

If you use MSI interrupts, they aren't shared so there isn't a problem.
Maybe the root cause of this is bad MSI emulation handling in BIOS.

Any change like this has to be done without changing device drivers.
Changing the skge/sky2 drivers as special case is not acceptable.


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
