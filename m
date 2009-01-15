Return-Path: <linux-kernel-owner+w=401wt.eu-S1763053AbZAOKPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763053AbZAOKPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757449AbZAOKPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:15:25 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54860 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbZAOKPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:15:21 -0500
Message-ID: <496F0CA8.7040001@jp.fujitsu.com>
Date: Thu, 15 Jan 2009 19:15:04 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] PCI PCIe portdrv: Fix allocation of interrupts (rev.
 3)
References: <200901131457.58164.rjw@sisk.pl> <496EE4C5.7030802@jp.fujitsu.com> <496EEB36.1010005@jp.fujitsu.com>
In-Reply-To: <496EEB36.1010005@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> Kenji Kaneshige wrote:
>> Rafael J. Wysocki wrote:
>>> Hi,
>>>
>>> The patch below fixes the problem with MSI-X vectors allocation by the PCIe
>>> port driver.  It applies on top of the series of PCIe port driver cleanups and
>>> bug fixes I've just sent.
>>>
>>> Please review.
>>>
>> The patch seems to still have the following assumptions.
>>
>>  - The number of MSI-X table entries is less than or equal to two.
>>  - MSI-X table entries are mapped only to PME/HP and/or AER.
> 
> It is not true.
> 

Maybe I should have said:

The patch will not work if any of PME/HP or AER requires entry
other than first two.

> If any of PME/HP and AER requires entry other than first two ([0],[1]),
> this code will give up MSI-X and fall back to MSI (or INTx).
> 

Yes. My opinion is MSI-X should work even if PME/HP or AER requires
entry other than first two.

> In other words, the portdrv will use MSI-X only if entries for PME/PM
> and AER is in the first two entries of the MSI-X table.
> 

This is exactly my worry, and it's why I want to eliminate the
assumptions above.

Thanks,
Kenji Kaneshige


> Thanks,
> H.Seto
> 
>>> Thanks,
>>> Rafael
>>>
>>> ---
>>> Subject: PCI PCIe portdrv: Fix allocation of interrupts (rev. 3)
>>> From: Rafael J. Wysocki <rjw@sisk.pl>
>>>
>>> If MSI-X interrupt mode is used by the PCI Express port driver, too
>>> many vectors are allocated and it is not ensured that the right
>>> vectors will be used for the right services.  Namely, the PCI Express
>>> specification states that both PCI Express native PME and PCI Express
>>> hotplug will always use the same MSI or MSI-X message for signalling
>>> interrupts, which implies that the same vector will be used by both
>>> of them.  Also, the VC service does not use interrupts at all.
>>> Moreover, is not clear which of the vectors allocated by
>>> pci_enable_msix() will be used for PME and hotplug and which of them
>>> will be used for AER if all of these services are configured.
>>>
>>> For these reasons, rework the allocation of interrupts for PCI
>>> Express ports so that at most two vectors are allocated and ensure
>>> that the right vector will be used for the right purpose.
>>>
>>> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>>> ---
>>>  drivers/pci/pcie/portdrv.h      |    2 
>>>  drivers/pci/pcie/portdrv_core.c |  142 +++++++++++++++++++++++++++++-----------
>>>  include/linux/pcieport_if.h     |   12 ++-
>>>  3 files changed, 114 insertions(+), 42 deletions(-)
>>>
>>> Index: linux-2.6/drivers/pci/pcie/portdrv_core.c
>>> ===================================================================
>>> --- linux-2.6.orig/drivers/pci/pcie/portdrv_core.c
>>> +++ linux-2.6/drivers/pci/pcie/portdrv_core.c
>>> @@ -31,6 +31,72 @@ static void release_pcie_device(struct d
>>>  }
>>>  
>>>  /**
>>> + * pcie_port_enable_msix - try to set up MSI-X as interrupt mode for given port
>>> + * @dev: PCI Express port to handle
>>> + * @vectors: Array of interrupt vectors to populate
>>> + * @nvec: Number of interrupt vectors to allocate
>>> + *
>>> + * Return value: 0 on success, error code on failure
>>> + */
>>> +static int pcie_port_enable_msix(struct pci_dev *dev, int *vectors, int nvec)
>>> +{
>>> +	struct msix_entry msix_entries[PCIE_PORT_DEVICE_MAXINTERRUPTS] = {
>>> +		{ 0, },
>>> +	};
>>> +	int status, pos, i;
>>> +	u16 reg16;
>>> +	u32 reg32;
>>> +
>>> +	for (i = 0; i < nvec; i++)
>>> +		msix_entries[i].entry = i;
>>> +
>>> +	status = pci_enable_msix(dev, msix_entries, nvec);
>>> +	if (status)
>>> +		return status;
>>> +
>>> +	/*
>>> +	 * The code below follows the PCI Express Base Specification 2.0 clearly
>>> +	 * stating in Section 6.1.6 that "PME and Hot-Plug Event interrupts
>>> +	 * (when both are implemented) always share the same MSI or MSI-X
>>> +	 * vector, as indicated by the Interrupt Message Number field in the PCI
>>> +	 * Express Capabilities register", where according to Section 7.8.2 of
>>> +	 * the Specification "For MSI-X, the value in this field indicates which
>>> +	 * MSI-X Table entry is used to generate the interrupt message."
>>> +	 */
>>> +	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
>>> +	pci_read_config_word(dev, pos + PCIE_CAPABILITIES_REG, &reg16);
>>> +	i = (reg16 >> 9) & PCIE_PORT_MSI_VECTOR_MASK;
>>> +	if (i >= nvec) {
>>> +		goto Error;
>>> +	} else {
>>> +		vectors[PCIE_PORT_SERVICE_PME_SHIFT] = msix_entries[i].vector;
>>> +		vectors[PCIE_PORT_SERVICE_HP_SHIFT] = msix_entries[i].vector;
>>> +	}
>>> +
>>> +	/*
>>> +	 * The code below follows Section 7.10.10 of the PCI Express Base
>>> +	 * Specification 2.0 stating that bits 31-27 of the Root Error Status
>>> +	 * Register contain a value indicating which of the MSI/MSI-X vectors
>>> +	 * assigned to the port is going to be used for AER, where "For MSI-X,
>>> +	 * the value in this register indicates which MSI-X Table entry is used
>>> +	 * to generate the interrupt message."
>>> +	 */
>>> +	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
>>> +	pci_read_config_dword(dev, pos + PCI_ERR_ROOT_STATUS, &reg32);
>>> +	i = (reg32 >> 27) & PCIE_PORT_MSI_VECTOR_MASK;
>>> +	if (i >= nvec)
>>> +		goto Error;
>>> +	else
>>> +		vectors[PCIE_PORT_SERVICE_AER_SHIFT] = msix_entries[i].vector;
>>> +
>>> +	return 0;
>>> +
>>> + Error:
>>> +	pci_disable_msix(dev);
>>> +	return -EIO;
>>> +}
>>> +
>>> +/**
>>>   * assign_interrupt_mode - choose interrupt mode for PCI Express port services
>>>   *                         (INTx, MSI-X, MSI) and set up vectors
>>>   * @dev: PCI Express port to handle
>>> @@ -42,49 +108,49 @@ static void release_pcie_device(struct d
>>>  static int assign_interrupt_mode(struct pci_dev *dev, int *vectors, int mask)
>>>  {
>>>  	struct pcie_port_data *port_data = pci_get_drvdata(dev);
>>> -	int i, pos, nvec, status = -EINVAL;
>>> -	int interrupt_mode = PCIE_PORT_NO_IRQ;
>>> +	int nvec, irq, interrupt_mode = PCIE_PORT_NO_IRQ;
>>> +	int i;
>>>  
>>> -	/* Set INTx as default */
>>> -	for (i = 0, nvec = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {
>>> -		if (mask & (1 << i)) 
>>> -			nvec++;
>>> -		vectors[i] = dev->irq;
>>> -	}
>>> -	if (dev->pin)
>>> -		interrupt_mode = PCIE_PORT_INTx_MODE;
>>> +	/*
>>> +	 * Determine the number of vectors to allocate.
>>> +	 *
>>> +	 * According to the PCI Express specification both PME and PCI Express
>>> +	 * hotplug always use the same interrupt vector, while AER can use
>>> +	 * a different one.
>>> +	 */
>>> +	nvec = 0;
>>> +	if (mask & (PCIE_PORT_SERVICE_PME | PCIE_PORT_SERVICE_HP))
>>> +		nvec++;
>>> +	if (mask & PCIE_PORT_SERVICE_AER)
>>> +		nvec++;
>>> +	if (!nvec)
>>> +		return PCIE_PORT_NO_IRQ;
>>>  
>>>  	/* Check MSI quirk */
>>>  	if (port_data->port_type == PCIE_RC_PORT && pcie_mch_quirk)
>>> -		return interrupt_mode;
>>> +		goto Fallback;
>>> +
>>> +	/* For nvec > 1 use MSI-X if supported */
>>> +	if (nvec > 1 && !pcie_port_enable_msix(dev, vectors, nvec)) {
>>> +		interrupt_mode = PCIE_PORT_MSIX_MODE;
>>> +		goto Exit;
>>> +	}
>>> +
>>> +	/* We're not going to use MSI-X, so try MSI and fall back to INTx */
>>> +	if (!pci_enable_msi(dev))
>>> +		interrupt_mode = PCIE_PORT_MSI_MODE;
>>> +
>>> + Fallback:
>>> +	if (interrupt_mode == PCIE_PORT_NO_IRQ && dev->pin)
>>> +		interrupt_mode = PCIE_PORT_INTx_MODE;
>>> +
>>> +	irq = interrupt_mode != PCIE_PORT_NO_IRQ ? dev->irq : -1;
>>> +	for (i = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++)
>>> +		vectors[i] = irq;
>>> +
>>> + Exit:
>>> +	vectors[PCIE_PORT_SERVICE_VC_SHIFT] = -1;
>>>  
>>> -	/* Select MSI-X over MSI if supported */		
>>> -	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
>>> -	if (pos) {
>>> -		struct msix_entry msix_entries[PCIE_PORT_DEVICE_MAXSERVICES] = 
>>> -			{{0, 0}, {0, 1}, {0, 2}, {0, 3}};
>>> -		status = pci_enable_msix(dev, msix_entries, nvec);
>>> -		if (!status) {
>>> -			int j = 0;
>>> -
>>> -			interrupt_mode = PCIE_PORT_MSIX_MODE;
>>> -			for (i = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {
>>> -				if (mask & (1 << i)) 
>>> -					vectors[i] = msix_entries[j++].vector;
>>> -			}
>>> -		}
>>> -	} 
>>> -	if (status) {
>>> -		pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
>>> -		if (pos) {
>>> -			status = pci_enable_msi(dev);
>>> -			if (!status) {
>>> -				interrupt_mode = PCIE_PORT_MSI_MODE;
>>> -				for (i = 0;i < PCIE_PORT_DEVICE_MAXSERVICES;i++)
>>> -					vectors[i] = dev->irq;
>>> -			}
>>> -		}
>>> -	} 
>>>  	return interrupt_mode;
>>>  }
>>>  
>>> Index: linux-2.6/include/linux/pcieport_if.h
>>> ===================================================================
>>> --- linux-2.6.orig/include/linux/pcieport_if.h
>>> +++ linux-2.6/include/linux/pcieport_if.h
>>> @@ -16,10 +16,14 @@
>>>  #define PCIE_ANY_PORT			7
>>>  
>>>  /* Service Type */
>>> -#define PCIE_PORT_SERVICE_PME		1	/* Power Management Event */
>>> -#define PCIE_PORT_SERVICE_AER		2	/* Advanced Error Reporting */
>>> -#define PCIE_PORT_SERVICE_HP		4	/* Native Hotplug */
>>> -#define PCIE_PORT_SERVICE_VC		8	/* Virtual Channel */
>>> +#define PCIE_PORT_SERVICE_PME_SHIFT	0	/* Power Management Event */
>>> +#define PCIE_PORT_SERVICE_PME		(1 << PCIE_PORT_SERVICE_PME_SHIFT)
>>> +#define PCIE_PORT_SERVICE_AER_SHIFT	1	/* Advanced Error Reporting */
>>> +#define PCIE_PORT_SERVICE_AER		(1 << PCIE_PORT_SERVICE_AER_SHIFT)
>>> +#define PCIE_PORT_SERVICE_HP_SHIFT	2	/* Native Hotplug */
>>> +#define PCIE_PORT_SERVICE_HP		(1 << PCIE_PORT_SERVICE_HP_SHIFT)
>>> +#define PCIE_PORT_SERVICE_VC_SHIFT	3	/* Virtual Channel */
>>> +#define PCIE_PORT_SERVICE_VC		(1 << PCIE_PORT_SERVICE_VC_SHIFT)
>>>  
>>>  /* Root/Upstream/Downstream Port's Interrupt Mode */
>>>  #define PCIE_PORT_NO_IRQ		(-1)
>>> Index: linux-2.6/drivers/pci/pcie/portdrv.h
>>> ===================================================================
>>> --- linux-2.6.orig/drivers/pci/pcie/portdrv.h
>>> +++ linux-2.6/drivers/pci/pcie/portdrv.h
>>> @@ -25,6 +25,8 @@
>>>  #define PCIE_CAPABILITIES_REG		0x2
>>>  #define PCIE_SLOT_CAPABILITIES_REG	0x14
>>>  #define PCIE_PORT_DEVICE_MAXSERVICES	4
>>> +#define PCIE_PORT_DEVICE_MAXINTERRUPTS	2
>>> +#define PCIE_PORT_MSI_VECTOR_MASK	0x1f
>>>  
>>>  #define get_descriptor_id(type, service) (((type - 4) << 4) | service)
>>>  
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
> 
> 
> 


