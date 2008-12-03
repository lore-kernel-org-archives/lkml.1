Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbYLCDh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbYLCDh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 22:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbYLCDhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 22:37:17 -0500
Received: from usul.saidi.cx ([204.11.33.34]:51015 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753236AbYLCDhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 22:37:15 -0500
Message-ID: <4935FEDD.3080807@overt.org>
Date: Tue, 02 Dec 2008 19:37:01 -0800
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux kernel <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx,
       Pierre Ossman <drzeus@drzeus.cx>, Frank Seidel <fseidel@suse.de>,
       Mathias Weyland <weyland@library.ethz.ch>
Subject: Re: [PATCH] ricoh_mmc: Handle newer models of Ricoh controllers 
 (resend)
References: <60069.67.164.5.76.1228094870.squirrel@overt.org> <20081202181043.8173d657.akpm@linux-foundation.org>
In-Reply-To: <20081202181043.8173d657.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>
>> diff --git a/drivers/mmc/host/ricoh_mmc.c b/drivers/mmc/host/ricoh_mmc.c
>> index a16d760..be9e7b3 100644
>> --- a/drivers/mmc/host/ricoh_mmc.c
>> +++ b/drivers/mmc/host/ricoh_mmc.c
>> @@ -11,9 +11,10 @@
>>
>>  /*
>>   * This is a conceptually ridiculous driver, but it is required by the way
>> - * the Ricoh multi-function R5C832 works. This chip implements firewire
>> - * and four different memory card controllers. Two of those controllers are
>> - * an SDHCI controller and a proprietary MMC controller. The linux SDHCI
>> + * the Ricoh multi-function chips (R5CXXX) work. These chips implement
>> + * the four main memory card controllers (SD, MMC, MS, xD) and one or both
>> + * of cardbus or firewire. It happens that they implement SD and MMC
>> + * support as separate controllers (and PCI functions). The linux SDHCI
>>   * driver supports MMC cards but the chip detects MMC cards in hardware
>>   * and directs them to the MMC controller - so the SDHCI driver never sees
>>   * them. To get around this, we must disable the useless MMC controller.
>> @@ -21,8 +22,10 @@
>>   * a detection event occurs immediately, even if the MMC card is already
>>   * in the reader.
>>   *
>> - * The relevant registers live on the firewire function, so this is unavoidably
>> - * ugly. Such is life.
>> + * It seems to be the case that the relevant PCI registers to deactivate the
>> + * MMC controller live on PCI function 0, which might be the cardbus controller
>> + * or the firewire controller, depending on the particular chip in question. As
>> + * such, it makes what this driver has to do unavoidably ugly. Such is life.
>>   */
>>
>>  #include <linux/pci.h>
> 
> The above two hunks already are in linux-next.
> 
>> @@ -143,6 +146,7 @@ static int __devinit ricoh_mmc_probe(struct pci_dev *pdev,
>>  		pci_get_device(PCI_VENDOR_ID_RICOH,
>>  			PCI_DEVICE_ID_RICOH_RL5C476, fw_dev))) {
>>  		if (PCI_SLOT(pdev->devfn) == PCI_SLOT(fw_dev->devfn) &&
>> +		    PCI_FUNC(fw_dev->devfn) == 0 &&
>>  		    pdev->bus == fw_dev->bus) {
>>  			if (ricoh_mmc_disable(fw_dev) != 0)
>>  				return -ENODEV;
>> @@ -160,6 +164,7 @@ static int __devinit ricoh_mmc_probe(struct pci_dev *pdev,
>>  	    (fw_dev = pci_get_device(PCI_VENDOR_ID_RICOH,
>>  					PCI_DEVICE_ID_RICOH_R5C832, fw_dev))) {
>>  		if (PCI_SLOT(pdev->devfn) == PCI_SLOT(fw_dev->devfn) &&
>> +		    PCI_FUNC(fw_dev->devfn) == 0 &&
>>  		    pdev->bus == fw_dev->bus) {
>>  			if (ricoh_mmc_disable(fw_dev) != 0)
>>  				return -ENODEV;
>> @@ -172,7 +177,7 @@ static int __devinit ricoh_mmc_probe(struct pci_dev *pdev,
>>
>>  	if (!ctrlfound) {
>>  		printk(KERN_WARNING DRIVER_NAME
>> -		       ": Main firewire function not found. Cannot disable controller.\n");
>> +		       ": Main Ricoh function not found. Cannot disable controller.\n");
>>  		return -ENODEV;
>>  	}
> 
> Those three are not.
> 

Indeed. Pierre, seems like the patch didn't git-apply properly. It's this way in your
tree too. Did you apply the previous garbled version?

--phil
