Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbYINUrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbYINUrJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 16:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbYINUqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 16:46:54 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:62469 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753736AbYINUqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 16:46:53 -0400
Date: Sun, 14 Sep 2008 21:46:16 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: PCI: Add ALI M5229 comaptibility mode quirk
Message-ID: <20080914204616.GE1916@fluff.org.uk>
References: <20080912112252.505651015@fluff.org.uk> <48CBCD1D.4090300@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48CBCD1D.4090300@garzik.org>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2008 at 10:24:29AM -0400, Jeff Garzik wrote:
> Ben Dooks wrote:
>> The libata driver will not work with an M5229 set into native IDE
>> mode (the old drivers/pci one does) if the M5229 does not provide
>> it's own IRQ.
>>
>> The M5229 implementation embedded into the ALI M1543 uses the
>> M1543's ISA PIC to provide the interrupts and thus does not have
>> an valid PCI IRQ set. This quirk detects the abscence of IRQ and
>> sets the M5229 back into compatibility mode to use IRQs 14 and 15
>> so that libata works correctly.
>>
>> Note, I belive that the check for an valid interrupt line is
>> correct, I only have an M5229 in an ALI M1543 to check this
>> on. It would be useful to confirm that a M5229 with an valid IRQ
>> does not trigger this quirk.
>>
>> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
>>
>> Index: linux-2.6.27-rc6-cats1/drivers/pci/quirks.c
>> ===================================================================
>> --- linux-2.6.27-rc6-cats1.orig/drivers/pci/quirks.c	2008-09-11 11:26:35.000000000 +0100
>> +++ linux-2.6.27-rc6-cats1/drivers/pci/quirks.c	2008-09-12 12:18:05.000000000 +0100
>> @@ -905,6 +905,34 @@ static void __devinit quirk_svwks_csb5id
>>  }
>>  DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_CSB5IDE, quirk_svwks_csb5ide);
>>  +/* Some systems set the ALI M5229 in the ALI M1543 bridge to native 
>> mode,
>> + * which cannot be supported by the pata_ali.c driver (the old drivers/ide
>> + * makes a compatibility effort to change the IDE interrupts).
>> + */
>> +static void __devinit quirk_ali_ide_compatibility(struct pci_dev *pdev)
>> +{
>> +	u8 tmp;
>> +
>> +	/* pdev->irq and pdev->pin have yet to be initialised, so check
>> +	 * by reading from the configuration header to see if we've got
>> +	 * a valid interrupt line. */
>> +
>> +	pci_read_config_byte(pdev, PCI_INTERRUPT_LINE, &tmp);
>> +	if (tmp != 0xff)
>> +		return;
>> +
>> +	pci_read_config_byte(pdev, PCI_CLASS_PROG, &tmp);
>> +	if (tmp & 0x5) {
>> +		dev_info(&pdev->dev, "quirk: changing to IDE compatibility mode\n");
>> +
>> +		tmp &= ~0x05;
>> +		pdev->class &= ~0x05;
>> +		pci_write_config_byte(pdev, PCI_CLASS_PROG, tmp);
>> +	}
>> +}
>> +
>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M5229, quirk_ali_ide_compatibility);
>
>
> This is a bit surprising, considering that libata works for all IDE mode  
> of other controllers...

The problem is that when the M5229 is embedded into an M1543, the
PCI IRQ is ignored, and the IRQ is routed directly into the ISA-PIC
in the M1543. This routing is done via a different set of configuration
registers, so that each channel can have its own IRQ.

This means that in pci-native mode, there is no pcidev.irq field set,
as there is no PCI IRQ setup. Alan Cox has stated that this is too
broken to be worked around in libata.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
