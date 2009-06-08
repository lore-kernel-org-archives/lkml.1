Return-Path: <linux-kernel-owner+w=401wt.eu-S1751829AbZFHDXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbZFHDXr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 23:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbZFHDXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 23:23:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46067 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbZFHDXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 23:23:38 -0400
Message-ID: <4A2C8429.2020401@jp.fujitsu.com>
Date: Mon, 08 Jun 2009 12:23:21 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 07/11] ACPI: acpi_pci_unbind should clean up	properly
 after acpi_pci_bind
References: <20090604054504.18802.21690.stgit@bob.kio> <20090604055852.18802.22743.stgit@bob.kio> <4A2788FA.2050606@jp.fujitsu.com> <20090604233521.GA12900@ethanol>
In-Reply-To: <20090604233521.GA12900@ethanol>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>>>  
>> I have a concern about this change.
>>
>> The acpi_pci_irq_del_prt() against dev->bus removes not only
>> the _PRT entries for PCI function corresponding to specified
>> acpi_device, but also other _PRT entries for working PCI
>> devices/functions on the same bus. As a result, interrupt
>> initialization for those PCI functions would no longer work
>> properly after that.
>>
>> So I think we should not call acpi_pci_irq_del_prt() against
>> dev->bus.
> 
> Thanks for the review. I agree with you.
> 
> Here is a respun version of this patch.
> 
> From: Alex Chiang <achiang@hp.com>
> 
> ACPI: acpi_pci_unbind should clean up properly after acpi_pci_bind
> 
> In acpi_pci_bind, we set device->ops.bind and device->ops.unbind, but
> never clear them out.
> 
> Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> diff --git a/drivers/acpi/pci_bind.c b/drivers/acpi/pci_bind.c
> index 62cb383..c9cc650 100644
> --- a/drivers/acpi/pci_bind.c
> +++ b/drivers/acpi/pci_bind.c
> @@ -109,11 +109,13 @@ static int acpi_pci_unbind(struct acpi_device *device)
>  	struct pci_dev *dev;
>  
>  	dev = acpi_get_pci_dev(device->handle);
> -	if (!dev)
> +	if (!dev || !dev->subordinate)
>  		return 0;

This would leak the pci_dev's refcount
if dev != NULL && dev->subordinate == NULL.

Thanks,
Kenji Kaneshige


>  
> -	if (dev->subordinate)
> -		acpi_pci_irq_del_prt(dev->subordinate);
> +	acpi_pci_irq_del_prt(dev->subordinate);
> +
> +	device->ops.bind = NULL;
> +	device->ops.unbind = NULL;
>  
>  	pci_dev_put(dev);
>  	return 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


