Return-Path: <linux-kernel-owner+w=401wt.eu-S1755791AbYLHMCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbYLHMCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 07:02:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYLHMCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 07:02:10 -0500
Received: from h155.mvista.com ([63.81.120.155]:32655 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751963AbYLHMCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 07:02:06 -0500
Message-ID: <493D0CB8.3060900@ru.mvista.com>
Date: Mon, 08 Dec 2008 15:02:00 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Shane McDonald <mcdonald.shane@gmail.com>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Resurrect IT8172 IDE controller driver
References: <E1L4UpB-0007ro-1g@localhost> <492A8306.9000400@ru.mvista.com> <b2b2f2320812031839q43eb6102jbae0fbddd9a1cf75@mail.gmail.com>
In-Reply-To: <b2b2f2320812031839q43eb6102jbae0fbddd9a1cf75@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Shane McDonald wrote:

>  I have made some of the required changes, but I have some questions.
>  See in-line for my resolution / questions for each comment.
>
> On Mon, Nov 24, 2008 at 4:33 AM, Sergei Shtylyov
> <sshtylyov@ru.mvista.com> wrote:
>   
>> Hello.
>>
>> Shane McDonald wrote:
>>
>>     
>>> diff -uprN a/drivers/ide/it8172.c b/drivers/ide/it8172.c
>>> --- a/drivers/ide/it8172.c      1969-12-31 18:00:00.000000000 -0600
>>> +++ b/drivers/ide/it8172.c      2008-11-23 01:06:01.000000000 -0600
>>> @@ -0,0 +1,205 @@
>>> +/*
>>> + *
>>> + * BRIEF MODULE DESCRIPTION
>>> + *      IT8172 IDE controller support
>>> + *
>>> + * Copyright 2000 MontaVista Software Inc.
>>> + * Author: MontaVista Software, Inc.
>>> + *              stevel@mvista.com or source@mvista.com
>>>
>>>       
>>  You can remove the former address, Steve Longerbeam is no longer with MV
>> (quit long ago). And I think you may add your own copyright now.
>>     
>
> OK, I will update accordingly.
>
>   
>>> +/*
>>> + * Prototypes
>>> + */
>>>       
>>  I see no prototypes here...
>>     
>
> Ah yes, the prototypes were removed, but not the comment.  I will remove this.
>
>   
>>> +static void it8172_set_pio_mode(ide_drive_t *drive, const u8 pio)
>>> +{
>>> +       ide_hwif_t *hwif        = HWIF(drive);
>>> +       struct pci_dev *dev     = to_pci_dev(hwif->dev);
>>> +       int is_slave            = (&hwif->drives[1] == drive);
>>>       
>>   Use simpler "drive->dn & 1" (and drop the useless parens please) -- & can
>> be dropped though as the controller has only a single channel...
>>     
>
>   I don't believe it can be dropped entirely -- although the
> controller only has a single channel, it does support two drives on
> that channel.  Unless I understand incorrectly, I will make the
> "drive->dn & 1" change.
>   

   Believe it or not, drive->dn will be 0 or 1 in this case, so & is 
superfluous. :-)
   I don't insist on dropping it though...

>>> +       /*
>>> +        * Enable port 0x44. The IT8172 spec is confused; it calls
>>> +        * this register the "Slave IDE Timing Register", but in fact,
>>> +        * it controls timing for both master and slave drives.
>>> +        */
>>> +       drive_enables |= 0x4000;
>>>       
>>  This is strange because this IDE controller seems to be a clone of the one
>> in the Intel PIIX chip. However, the spec. I have tellm it's not an exact
>> clone.
>>     

   I just don't undestand what this bit is good for in IT8172G... 
Perhaps by clearing it once could achieve PIO0 timings, just like by 
clearing the fast timing bits on PIIX?

>> I suggest that you take a close look at drivers/ide/piix.c...
>>     
>
> The specs I have indicate that it is not the same.  For example, bits
> 13:12 in the IDETIM register at offset 0x40-0x41 of the PIIX give the
> IORDY Sample Point, but the same function is found in bits 19-17 in
> the SLVT register at offset 0x44-0x47 in the IT8172.  Perhaps better
> comments are in order, or perhaps these bitfields should be defined in
> a .h file?
>   

   No, IT8172G just implements them differently. But you can still find 
in this driver a good example of how things should be done...

>>> +       if (is_slave) {
>>> +               drive_enables &= 0xc006;
>>> +               if (pio > 1)
>>> +                       /* enable prefetch and IORDY sample-point */
>>> +                       drive_enables |= 0x0060;
>>>       
>>  IORDY sampling shouldn't be enabled for PIO mode 2 always, only if the
>> drive supports it.
>>  Prefetch should only be enabled for ATA disks, not the ATAPI devices
>>     
>
> OK, I will update accordingly.  Am I correct that prefetch should be
> enabled if "drive->media == ide_disk", and not otherwise?
>   

   Yes, you're correct.

> I am not sure how to determine if IORDY sampling is supported by a
>   

   I think Bart has replied to thia already...

> drive.  If I'm reading the code correctly, other drivers only check
> that the PIO mode is > 2 (not > 1 as in my driver) -- that seems to be
> the case for at least piix.c, siimage.c, and it8213.c.
>   

   That's because PIO modes above 2 necessiate IORDY, while for mode 2 
the drive can require it optionally.

>>> +static void it8172_set_dma_mode(ide_drive_t *drive, const u8 speed)
>>> +{
>>> +       ide_hwif_t *hwif        = HWIF(drive);
>>> +       struct pci_dev *dev     = to_pci_dev(hwif->dev);
>>> +       int a_speed             = 3 << (drive->dn * 4);
>>> +       int u_flag              = 1 << drive->dn;
>>> +       int u_speed             = 0;
>>> +       u8 reg48, reg4a;
>>> +
>>> +       const u8 mwdma_to_pio[] = { 0, 3, 4 };
>>> +       u8 pio;
>>> +
>>> +       pci_read_config_byte(dev, 0x48, &reg48);
>>> +       pci_read_config_byte(dev, 0x4a, &reg4a);
>>> +
>>> +       if (speed >= XFER_UDMA_0) {
>>> +
>>> +               /* Setting the DMA cycle time to 2 or 3 PCI clocks
>>> +                * (60 and 91 nsec at 33 MHz PCI clock) seems to cause
>>> +                * BadCRC errors during DMA transfers on some drives,
>>>       
>>  Sigh, such drives should have been blacklisted...
>>     
>
> Do you think I should keep this code in here?  It kind of seems silly
> to run drivers at UDMA0 speeds just because of a few bad drives back
> in 2000 when the driver was originally written.

   If was only happening for some drives, you probably shouldn't keep it...

> Should this not be
> handled in userspace by hdparm?  Other drivers don't seem to do
> something similar.
>   

   This is usually handled by blacklisting the drives for the user's 
convenience.

>>> +                * even though both numbers meet the minimum ATAPI-4 spec
>>> +                * of 73 and 54 nsec for UDMA 1 and 2 respectively.
>>> +                * So the faster times are not implemented here.
>>> +                * The good news is that the slower cycle time has
>>> +                * very little affect on transfer performance.
>>>       
>>  This should only affect the write performance, reads.
>>     

   "On reads the drive dictatees the timings" I was going to write. :-)


>>> +static unsigned int __devinit init_chipset_it8172(struct pci_dev *dev)
>>> +{
>>> +       unsigned char progif;
>>> +
>>> +       /*
>>> +        * Place both IDE interfaces into PCI "native" mode
>>> +        */
>>> +       pci_read_config_byte(dev, PCI_CLASS_PROG, &progif);
>>> +       pci_write_config_byte(dev, PCI_CLASS_PROG, progif | 0x05);
>>> +
>>> +       return dev->irq;
>>> +}
>>>
>>>       
>>  As Alan have said, you can't do that here.
>>     
>
> I will remove this.
>   

   You'll probably need to add this as a quirk to drivers/pci/quirks.c 
-- unless the bootloader sets the controller to native mode itself.

>>> +static const struct ide_port_info it8172_chipset __devinitdata = {
>>> +       .name           = DRV_NAME,
>>> +       .init_chipset   = init_chipset_it8172,
>>> +       .port_ops       = &it8172_port_ops,
>>> +       .enablebits     = {{0x00, 0x00, 0x00}, {0x40, 0x00, 0x01} },
>>>
>>>       
>>  Wrong, should be:
>>
>>        .enablebits     = {{0x41, 0x80, 0x80}, {0x00, 0x00, 0x00}},
>>
>>  If that doesn't work (firmware doesn't enable the channel), you can leave
>> it all 0s...
>>     

   Er, I was wrong here -- you actiually can't do that as the channel 
will remain disabled.

> Well, mine is clearly wrong.  Am I correct that {0x41, 0x80, 0x80} is
> checking that the IDE Decode Enable bit is set?  This bit is in the
> same location in both the PIIX and the IT8172.
>   

   Yes, you're correct. You should add the code to force it enabled if 
the bootloader doesn't do that.

>>>        .host_flags     = IDE_HFLAG_SINGLE,
>>> +       .pio_mask       = ATA_PIO4,
>>>       

   I'm not seeing how PIO mode 0 is supportable.

>>> +       .swdma_mask     = ATA_SWDMA2_ONLY,
>>>       

  The SWDMA support could be dropped altogether -- these modes are slow 
and long obsolete.

>>> +       .mwdma_mask     = ATA_MWDMA12_ONLY,
>>>       
>>  More modes are supportable...
>>     
>
> I will update accordingly.
>   

   These masks were stolen from the piix.c driver and are determined by 
the limitation of the timing register fileds being only 2-bit wide. 
IT8172G has these bits implemented differently, hence the limitation 
shouldn't apply. You shouldn't just update the masks without doing 
anythiung about programming the modes...

>>> +MODULE_AUTHOR("SteveL@mvista.com");
>>>       
>>  I wonder why Steve didn't specify his full name... :-)
>>     
>
> I will change this to my name.
>   

   I don't think it would be a legitimate change...

> Thank you for your time!
>   

   If you could give me more free time instead... :-)

MBR, Sergei


