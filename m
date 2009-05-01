Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbZEABtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbZEABtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 21:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbZEABtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 21:49:22 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:20892 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbZEABtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 21:49:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nx5MjtGD5p4Pyj/yNag5BswBFcmlYCH+1yqOkW6USOuizxLD3mlmcSeSxTOOJNma2m
         BsCcf8D8TyQgeUq+gcUXqcIdu/ni888sS/Jsbqo+enteH7tK/mxQ1WH1JpgxeT/eQIvl
         uMKhC+7bM/DzhL70cTP5IReZJ8imDcue+gksg=
Message-ID: <49FA5519.9000107@gmail.com>
Date: Thu, 30 Apr 2009 19:49:13 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Matthew Wilcox <willy@linux.intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Tejun Heo <tj@kernel.org>,
       Alex Buell <alex.buell@munted.org.uk>, Jeff Garzik <jeff@garzik.org>,
       "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: No NCQ support on X61s Ultrabay?  (Intel ICH8 SATA controller
   question)
References: <E1LzLgA-0004j6-9W@closure.thunk.org> <49F90CA2.4080602@garzik.org> <20090430083309.437f9248@lithium.local.net> <49F95719.10701@kernel.org> <20090430144702.46415b90@lxorguk.ukuu.org.uk> <20090430153508.GA10704@linux.intel.com> <20090430154701.GA27737@srcf.ucam.org>
In-Reply-To: <20090430154701.GA27737@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Thu, Apr 30, 2009 at 08:35:08AM -0700, Matthew Wilcox wrote:
>> On Thu, Apr 30, 2009 at 02:47:02PM +0100, Alan Cox wrote:
>>>> So, at the point of driver load, there just isn't much we can do about
>>>> the missing ABAR.  It's sad.  Dunno why some laptop manufacturers
>>>> still program the thing into piix mode.  :-(
>>> Forcing out of PIIX mode would need to go into the PCI quirks and be a
>>> boot option not a module one - at that point its doable as a header quirk.
>> I think Matthew Garrett already has code to do this.
> 
> Yeah, but some testers reported that it broke after using it for a 
> while. The most recent version I have is this:

We should likely have something like this in the kernel, but it should 
default to off. For one thing, some machines seem to have BIOS code that 
tries to poke the controller for some reason during suspend/shutdown 
events, etc. which would likely go nuts if the controller was 
unexpectedly in AHCI mode..

> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index a807797..9e7b460 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -893,6 +893,52 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_SATA, quirk
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_amd_ide_mode);
>  DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_amd_ide_mode);
>  
> +static void __devinit quirk_ahci_sata(struct pci_dev *pdev)
> +{
> +	u32 sir, newval;
> +	u16 mode;
> +
> +	/* Make sure we're in AHCI mode */
> +	pci_read_config_word(pdev, 0x90, &mode);
> +	pci_write_config_word(pdev, 0x90, 0x40);
> +
> +	/* Need to set the SCRAE bit */
> +	pci_read_config_dword(pdev, 0x94, &sir);
> +	newval = (sir | 0x200);
> +	pci_write_config_dword(pdev, 0x94, newval);
> +
> +	/* Set PCI_CLASS_STORAGE_SATA */
> +	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE) {
> +		pci_write_config_byte(pdev, PCI_CLASS_PROG, 0x01);
> +		pci_write_config_byte(pdev, PCI_CLASS_DEVICE, 0x06);
> +		pdev->class = PCI_CLASS_STORAGE_SATA_AHCI;
> +	}
> +
> +	pci_read_config_word(pdev, PCI_DEVICE_ID, &pdev->device);
> +	pci_assign_resource(pdev, 5);
> +
> +	printk (KERN_INFO "Quirked PIIX device to AHCI mode\n");
> +}	
> +
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x2652, quirk_ahci_sata);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x2653, quirk_ahci_sata);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x2680, quirk_ahci_sata);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x27c4, quirk_ahci_sata);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x2828, quirk_ahci_sata);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x2928, quirk_ahci_sata);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x292d, quirk_ahci_sata);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x292e, quirk_ahci_sata);
> +
> +#if 0
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x2651, quirk_ahci_sata);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x27c0, quirk_ahci_sata);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x2820, quirk_ahci_sata);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x2825, quirk_ahci_sata);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x2920, quirk_ahci_sata);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x2921, quirk_ahci_sata);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x2926, quirk_ahci_sata);
> +#endif
> +
>  /*
>   *	Serverworks CSB5 IDE does not fully support native mode
>   */
> 

