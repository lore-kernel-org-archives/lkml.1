Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbYLVPcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbYLVPcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 10:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbYLVPcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 10:32:06 -0500
Received: from mail.work.de ([212.12.32.20]:50531 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710AbYLVPcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 10:32:05 -0500
Message-ID: <494FB2DF.9090504@gmail.com>
Date: Mon, 22 Dec 2008 19:31:43 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: Grant Grundler <grundler@parisc-linux.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: MSI messages
References: <49438290.1080502@gmail.com>	 <20081214081210.GC13371@colo.lackof.org> <4944EAC3.1020407@gmail.com>	 <20081214185239.GA2039@colo.lackof.org>  <494D5FF7.50807@gmail.com>	 <1229897516.8269.8.camel@localhost>  <494EC98A.5020700@gmail.com> <1229901752.8269.17.camel@localhost>
In-Reply-To: <1229901752.8269.17.camel@localhost>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman wrote:
> On Mon, 2008-12-22 at 02:56 +0400, Manu Abraham wrote:
>> Michael Ellerman wrote:
>>> On Sun, 2008-12-21 at 01:13 +0400, Manu Abraham wrote:
>>>> Grant Grundler wrote:
>>>>> On Sun, Dec 14, 2008 at 03:15:15PM +0400, Manu Abraham wrote:
>>>>> ...
>>>>>>> A "GSI" (Generic Sys Interrupt?) is associated with each entry in
>>>>>>> the MSI-X table. Driver then calls request_irq() to bind an interrupt
>>>>>>> handler to each GSI. So the driver never directly sees the "message".
>>>>>> Oh, you mean the array of irq_handlers in the MSI-X table should 
>>>>>> correspond to a particular message ?
>>>>> No. I mean each MSI-X entry has an address+message pair and each MSI-X entry
>>>>> is associated with the parameters passed to each call of request_irq().
>>>>> Pass in unique private data to each call of request_irq() and the driver
>>>>> can determine which message was delivered when the ISR gets called.
>>>>> (ISR == Interrupt Service Routine, aka driver IRQ handler)
>>>> Is it possible that even when the config space says that multiple messages 
>>>> are supported, you cannot enable MSI-X ?
>>> Yes, absolutely. Have a look at pci_msi_check_device() for starters. MSI
>>> can be disabled globally, or per-device by a quirk, the bridges above
>>> your device might not support MSI and the arch code may prevent
>>> MSI/MSI-X for some reason (ie. platform doesn't support it).
>>>
>>> There's also a check in pci_enable_msix() to make sure the entries you
>>> pass in are valid.
>>>
>>>>  ------------- with MSI-X -------------
>>>>
>>>> saa716x_pci_init (0): found a NEMO reference board PCIe card
>>>> ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 19 (level, low) -> IRQ 19
>>>> PCI: Setting latency timer of device 0000:05:00.0 to 64
>>>> saa716x_request_irq (0): Using MSI-X mode
>>>> saa716x_enable_msix (0): MSI-X request failed
>>> For starters you should print the error code returned by
>>> pci_enable_msix() - unfortunately it returns EINVAL for many different
>>> reasons, but it will narrow it down a bit.
>> It does return -22
> 
> If you're curious you could try this patch.


There's a missing opening brace. I did add it and added more of kernel hacking
for debugging and loaded the modules after that, which did cause a complete 
freeze of the machine.

Currently, digging into what would have caused that freeze.

The same module without the debug (kernel hack + pci debug) doesn't cause the
freeze and results in the original log that i attached some mails earlier.
(No trace/log results, results in a complete freeze immediately on module 
(saa716x_hybrid) load)


Regards,
Manu


> 
>>From bd27f10c9acd24bb849d14b6fc373444322c7405 Mon Sep 17 00:00:00 2001
> From: Michael Ellerman <michael@ellerman.id.au>
> Date: Mon, 22 Dec 2008 10:21:27 +1100
> Subject: [PATCH] MSI debug
> 
> ---
>  drivers/pci/msi.c |   52 ++++++++++++++++++++++++++++++++++++++++------------
>  1 files changed, 40 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 74801f7..575cca9 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -517,17 +517,26 @@ static int pci_msi_check_device(struct pci_dev* dev, int nvec, int type)
>  	struct pci_bus *bus;
>  	int ret;
>  
> +	if (!dev) {
> +		printk(KERN_DEBUG, "MSI: null device\n");
> +		return -ENODEV;
> +	}
> +
>  	/* MSI must be globally enabled and supported by the device */
> -	if (!pci_msi_enable || !dev || dev->no_msi)
> +	if (!pci_msi_enable || dev->no_msi)


Missing opening brace in here.


> +		dev_printk(KERN_DEBUG, &dev->dev, "MSI: MSI disabled\n");
>  		return -EINVAL;
> +	}
>  
>  	/*
>  	 * You can't ask to have 0 or less MSIs configured.
>  	 *  a) it's stupid ..
>  	 *  b) the list manipulation code assumes nvec >= 1.
>  	 */
> -	if (nvec < 1)
> +	if (nvec < 1) {
> +		dev_printk(KERN_DEBUG, &dev->dev, "MSI: < 1 MSI requested\n");
>  		return -ERANGE;
> +	}
>  
>  	/* Any bridge which does NOT route MSI transactions from it's
>  	 * secondary bus to it's primary bus must set NO_MSI flag on
> @@ -535,16 +544,24 @@ static int pci_msi_check_device(struct pci_dev* dev, int nvec, int type)
>  	 * We expect only arch-specific PCI host bus controller driver
>  	 * or quirks for specific PCI bridges to be setting NO_MSI.
>  	 */
> -	for (bus = dev->bus; bus; bus = bus->parent)
> -		if (bus->bus_flags & PCI_BUS_FLAGS_NO_MSI)
> +	for (bus = dev->bus; bus; bus = bus->parent) {
> +		if (bus->bus_flags & PCI_BUS_FLAGS_NO_MSI) {
> +			dev_printk(KERN_DEBUG, &dev->dev,
> +				   "MSI: bus check failed\n");
>  			return -EINVAL;
> +		}
> +	}
>  
>  	ret = arch_msi_check_device(dev, nvec, type);
> -	if (ret)
> +	if (ret) {
> +		dev_printk(KERN_DEBUG, &dev->dev, "MSI: arch check failed\n");
>  		return ret;
> +	}
>  
> -	if (!pci_find_capability(dev, type))
> +	if (!pci_find_capability(dev, type)) {
> +		dev_printk(KERN_DEBUG, &dev->dev, "MSI: no capability found\n");
>  		return -EINVAL;
> +	}
>  
>  	return 0;
>  }
> @@ -669,26 +686,37 @@ int pci_enable_msix(struct pci_dev* dev, struct msix_entry *entries, int nvec)
>  	int i, j;
>  	u16 control;
>  
> -	if (!entries)
> - 		return -EINVAL;
> -
>  	status = pci_msi_check_device(dev, nvec, PCI_CAP_ID_MSIX);
>  	if (status)
>  		return status;
>  
> +	if (!entries) {
> +		dev_printk(KERN_DEBUG, &dev->dev, "MSI: null entries\n");
> +		return -EINVAL;
> +	}
> +
>  	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
>  	pci_read_config_word(dev, msi_control_reg(pos), &control);
>  	nr_entries = multi_msix_capable(control);
> -	if (nvec > nr_entries)
> +	if (nvec > nr_entries) {
> +		dev_printk(KERN_DEBUG, &dev->dev, "MSI: too many entries\n");
>  		return -EINVAL;
> +	}
>  
>  	/* Check for any invalid entries */
>  	for (i = 0; i < nvec; i++) {
> -		if (entries[i].entry >= nr_entries)
> +		if (entries[i].entry >= nr_entries) {
> +			dev_printk(KERN_DEBUG, &dev->dev,
> +				   "MSI: invalid entry %d\n", i);
>  			return -EINVAL;		/* invalid entry */
> +		}
>  		for (j = i + 1; j < nvec; j++) {
> -			if (entries[i].entry == entries[j].entry)
> +			if (entries[i].entry == entries[j].entry) {
> +				dev_printk(KERN_DEBUG, &dev->dev,
> +					   "MSI: duplicate entries %d, %d\n",
> +					   i, j);
>  				return -EINVAL;	/* duplicate entry */
> +			}
>  		}
>  	}
>  	WARN_ON(!!dev->msix_enabled);

