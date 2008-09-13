Return-Path: <linux-kernel-owner+w=401wt.eu-S1753073AbYIMRbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbYIMRbq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 13:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYIMRbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 13:31:34 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:35145 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYIMRbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 13:31:33 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=QSdRsYuzykgZXMnJddIA:9 a=WAboloLgHrBUfwVtSRwA:7 a=jD5P6RM6ChrL1H2Y-o61wsT3SeAA:4 a=XCHgF3Esco0A:10 a=oWG72qQcp8QA:10 a=tP3kHmU_FAoA:10
Message-ID: <48CBF8EF.7030909@shaw.ca>
Date: Sat, 13 Sep 2008 11:31:27 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: PCI: Add ALI M5229 comaptibility mode quirk
References: <fa.5x39Eh02m9rtrn5GDRnZ3IcV/z8@ifi.uio.no> <fa.bfF4DSr1eMYmEl5E90sppi2wbuU@ifi.uio.no>
In-Reply-To: <fa.bfF4DSr1eMYmEl5E90sppi2wbuU@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
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
>> --- linux-2.6.27-rc6-cats1.orig/drivers/pci/quirks.c    2008-09-11 
>> 11:26:35.000000000 +0100
>> +++ linux-2.6.27-rc6-cats1/drivers/pci/quirks.c    2008-09-12 
>> 12:18:05.000000000 +0100
>> @@ -905,6 +905,34 @@ static void __devinit quirk_svwks_csb5id
>>  }
>>  DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, 
>> PCI_DEVICE_ID_SERVERWORKS_CSB5IDE, quirk_svwks_csb5ide);
>>  
>> +/* Some systems set the ALI M5229 in the ALI M1543 bridge to native 
>> mode,
>> + * which cannot be supported by the pata_ali.c driver (the old 
>> drivers/ide
>> + * makes a compatibility effort to change the IDE interrupts).
>> + */
>> +static void __devinit quirk_ali_ide_compatibility(struct pci_dev *pdev)
>> +{
>> +    u8 tmp;
>> +
>> +    /* pdev->irq and pdev->pin have yet to be initialised, so check
>> +     * by reading from the configuration header to see if we've got
>> +     * a valid interrupt line. */
>> +
>> +    pci_read_config_byte(pdev, PCI_INTERRUPT_LINE, &tmp);
>> +    if (tmp != 0xff)
>> +        return;
>> +
>> +    pci_read_config_byte(pdev, PCI_CLASS_PROG, &tmp);
>> +    if (tmp & 0x5) {
>> +        dev_info(&pdev->dev, "quirk: changing to IDE compatibility 
>> mode\n");
>> +
>> +        tmp &= ~0x05;
>> +        pdev->class &= ~0x05;
>> +        pci_write_config_byte(pdev, PCI_CLASS_PROG, tmp);
>> +    }
>> +}
>> +
>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M5229, 
>> quirk_ali_ide_compatibility);
> 
> 
> This is a bit surprising, considering that libata works for all IDE mode 
> of other controllers...
> 
>     Jeff

Not if the controller has no native-mode IRQ assigned, it won't..
