Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbYLDCkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbYLDCkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 21:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbYLDCj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 21:39:59 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:12601 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYLDCj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 21:39:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lzNRP4LU7xMjb1huZUr2kQRxI45l99EkGmGV3OZR8imY7DxLwO+HFr/48obq8njm1C
         Zqrx3zSeX1OWkCShJAqSyPuEPDYc0r5dK5/Z7Blou690DJVCAlXQAuNT8OjYgezjqCzb
         T7MGm5e6F+bdj7z8NZAsU4JNMc8FcWM3Oyzjs=
Message-ID: <b2b2f2320812031839q43eb6102jbae0fbddd9a1cf75@mail.gmail.com>
Date: Wed, 3 Dec 2008 20:39:56 -0600
From: "Shane McDonald" <mcdonald.shane@gmail.com>
To: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] Resurrect IT8172 IDE controller driver
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <492A8306.9000400@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1L4UpB-0007ro-1g@localhost> <492A8306.9000400@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello:

  I have made some of the required changes, but I have some questions.
 See in-line for my resolution / questions for each comment.

On Mon, Nov 24, 2008 at 4:33 AM, Sergei Shtylyov
<sshtylyov@ru.mvista.com> wrote:
> Hello.
>
> Shane McDonald wrote:
>
>> diff -uprN a/drivers/ide/it8172.c b/drivers/ide/it8172.c
>> --- a/drivers/ide/it8172.c      1969-12-31 18:00:00.000000000 -0600
>> +++ b/drivers/ide/it8172.c      2008-11-23 01:06:01.000000000 -0600
>> @@ -0,0 +1,205 @@
>> +/*
>> + *
>> + * BRIEF MODULE DESCRIPTION
>> + *      IT8172 IDE controller support
>> + *
>> + * Copyright 2000 MontaVista Software Inc.
>> + * Author: MontaVista Software, Inc.
>> + *              stevel@mvista.com or source@mvista.com
>>
>
>  You can remove the former address, Steve Longerbeam is no longer with MV
> (quit long ago). And I think you may add your own copyright now.

OK, I will update accordingly.

>> +/*
>> + * Prototypes
>> + */
>
>  I see no prototypes here...

Ah yes, the prototypes were removed, but not the comment.  I will remove this.

>> +static void it8172_set_pio_mode(ide_drive_t *drive, const u8 pio)
>> +{
>> +       ide_hwif_t *hwif        = HWIF(drive);
>> +       struct pci_dev *dev     = to_pci_dev(hwif->dev);
>> +       int is_slave            = (&hwif->drives[1] == drive);
>
>   Use simpler "drive->dn & 1" (and drop the useless parens please) -- & can
> be dropped though as the controller has only a single channel...

  I don't believe it can be dropped entirely -- although the
controller only has a single channel, it does support two drives on
that channel.  Unless I understand incorrectly, I will make the
"drive->dn & 1" change.

>> +       spin_lock_irqsave(&ide_lock, flags);
>>
>
>  Don't use ide_lock here please. Moreover, since the controller has only one
> channel, you don't need any spinlock here.

I will remove it, and the associated spin_unlock_irqrestore.

>> +       pci_read_config_word(dev, 0x40, &drive_enables);
>> +       pci_read_config_dword(dev, 0x44, &drive_timing);
>> +
>> +       /*
>> +        * FIX! The DIOR/DIOW pulse width and recovery times in port 0x44
>
>  It's usually FIXME. :-)

I will change.  Although, the change to the pulse width of DIOR/DIOW
doesn't seem that difficult to make.  Maybe I should just go ahead and
do that.

>> +        * are being left at the default values of 8 PCI clocks (242 nsec
>> +        * for a 33 MHz clock).
>
>  It's 240, not 242 ns as 33 is actually 33.333.

I will update the comment to reflect reality, unless I implement the FIXME.

>>  These can be safely shortened at higher
>> +        * PIO modes. The DIOR/DIOW pulse width and recovery times only
>> +        * apply to PIO modes, not to the DMA modes.
>> +        */
>
>  Not true. They do apply to SW/MW DMA modes -- and if you look at your own
> code you'll see that.

Hmmm, that's right, that is what the code is doing.  I will update the
comment accordingly.

>> +       /*
>> +        * Enable port 0x44. The IT8172 spec is confused; it calls
>> +        * this register the "Slave IDE Timing Register", but in fact,
>> +        * it controls timing for both master and slave drives.
>> +        */
>> +       drive_enables |= 0x4000;
>
>  This is strange because this IDE controller seems to be a clone of the one
> in the Intel PIIX chip. However, the spec. I have tellm it's not an exact
> clone.
> I suggest that you take a close look at drivers/ide/piix.c...

The specs I have indicate that it is not the same.  For example, bits
13:12 in the IDETIM register at offset 0x40-0x41 of the PIIX give the
IORDY Sample Point, but the same function is found in bits 19-17 in
the SLVT register at offset 0x44-0x47 in the IT8172.  Perhaps better
comments are in order, or perhaps these bitfields should be defined in
a .h file?

>> +       if (is_slave) {
>> +               drive_enables &= 0xc006;
>> +               if (pio > 1)
>> +                       /* enable prefetch and IORDY sample-point */
>> +                       drive_enables |= 0x0060;
>
>  IORDY sampling shouldn't be enabled for PIO mode 2 always, only if the
> drive supports it.
>  Prefetch should only be enabled for ATA disks, not the ATAPI devices

OK, I will update accordingly.  Am I correct that prefetch should be
enabled if "drive->media == ide_disk", and not otherwise?

I am not sure how to determine if IORDY sampling is supported by a
drive.  If I'm reading the code correctly, other drivers only check
that the PIO mode is > 2 (not > 1 as in my driver) -- that seems to be
the case for at least piix.c, siimage.c, and it8213.c.

>> +static void it8172_set_dma_mode(ide_drive_t *drive, const u8 speed)
>> +{
>> +       ide_hwif_t *hwif        = HWIF(drive);
>> +       struct pci_dev *dev     = to_pci_dev(hwif->dev);
>> +       int a_speed             = 3 << (drive->dn * 4);
>> +       int u_flag              = 1 << drive->dn;
>> +       int u_speed             = 0;
>> +       u8 reg48, reg4a;
>> +
>> +       const u8 mwdma_to_pio[] = { 0, 3, 4 };
>> +       u8 pio;
>> +
>> +       pci_read_config_byte(dev, 0x48, &reg48);
>> +       pci_read_config_byte(dev, 0x4a, &reg4a);
>> +
>> +       if (speed >= XFER_UDMA_0) {
>> +
>> +               /* Setting the DMA cycle time to 2 or 3 PCI clocks
>> +                * (60 and 91 nsec at 33 MHz PCI clock) seems to cause
>> +                * BadCRC errors during DMA transfers on some drives,
>
>  Sigh, such drives should have been blacklisted...

Do you think I should keep this code in here?  It kind of seems silly
to run drivers at UDMA0 speeds just because of a few bad drives back
in 2000 when the driver was originally written.  Should this not be
handled in userspace by hdparm?  Other drivers don't seem to do
something similar.

>> +                * even though both numbers meet the minimum ATAPI-4 spec
>> +                * of 73 and 54 nsec for UDMA 1 and 2 respectively.
>> +                * So the faster times are not implemented here.
>> +                * The good news is that the slower cycle time has
>> +                * very little affect on transfer performance.
>
>  This should only affect the write performance, reads.

Unless it is decided to eliminate the slower-cycle-time feature (in
which case this comment would go away), I will update the comment
accordingly as per your clarified email.

>> +                */
>> +
>> +               u_speed = 0 << (drive->dn * 4);
>
>  I think you're actually setting UltraDMA mode 2 timing regardless of the
> mode selected.

Yes, as you said in the follow-on email, this is being set to UDMA
mode 0 regardless of the mode selected, due to the preceeding
slower-cycle-time comment.  I will await your response before changing
this.

>  The below code only applies to non-UltraDMA modes.
>
>> +       if (speed >= XFER_MW_DMA_0)
>> +               pio = mwdma_to_pio[speed - XFER_MW_DMA_0];
>> +       else
>> +               pio = 2;
>> +
>> +       it8172_set_pio_mode(drive, pio);

OK, I will only execute this code if it's a non-UDMA mode.

>  Moreover, I'd suggest to reimplement it as the timing register layout is
> different from the original PIIX and additional DMA modes can be supported:
> MWDMA0 and SWDMA1.

I'm not quite sure what you mean.  I'll implement something and get
your feedback.

>> +static unsigned int __devinit init_chipset_it8172(struct pci_dev *dev)
>> +{
>> +       unsigned char progif;
>> +
>> +       /*
>> +        * Place both IDE interfaces into PCI "native" mode
>> +        */
>> +       pci_read_config_byte(dev, PCI_CLASS_PROG, &progif);
>> +       pci_write_config_byte(dev, PCI_CLASS_PROG, progif | 0x05);
>> +
>> +       return dev->irq;
>> +}
>>
>
>  As Alan have said, you can't do that here.

I will remove this.

>> +static const struct ide_port_info it8172_chipset __devinitdata = {
>> +       .name           = DRV_NAME,
>> +       .init_chipset   = init_chipset_it8172,
>> +       .port_ops       = &it8172_port_ops,
>> +       .enablebits     = {{0x00, 0x00, 0x00}, {0x40, 0x00, 0x01} },
>>
>
>  Wrong, should be:
>
>        .enablebits     = {{0x41, 0x80, 0x80}, {0x00, 0x00, 0x00}},
>
>  If that doesn't work (firmware doesn't enable the channel), you can leave
> it all 0s...

Well, mine is clearly wrong.  Am I correct that {0x41, 0x80, 0x80} is
checking that the IDE Decode Enable bit is set?  This bit is in the
same location in both the PIIX and the IT8172.

>>        .host_flags     = IDE_HFLAG_SINGLE,
>> +       .pio_mask       = ATA_PIO4,
>> +       .swdma_mask     = ATA_SWDMA2_ONLY,
>> +       .mwdma_mask     = ATA_MWDMA12_ONLY,
>
>  More modes are supportable...

I will update accordingly.

>> +static const struct ide_port_info it8172_chipset __devinitdata = {
>
>   Please rename this variable to it8172_port_info.

I will update accordingly.

>> +};
>> +
>> +static int __devinit it8172_init_one(struct pci_dev *dev,
>> +                                       const struct pci_device_id *id)
>> +{
>> +       if ((!(PCI_FUNC(dev->devfn) & 1) ||
>> +               (!((dev->class >> 8) == PCI_CLASS_STORAGE_IDE))))
>>
>
>    Please, don't abuse parens, it should be just:
>
>        if (!(PCI_FUNC(dev->devfn) & 1) ||
>             (dev->class >> 8) != PCI_CLASS_STORAGE_IDE)
>
>
>> +               return -ENODEV; /* IT8172 is more than an IDE controller
>> */
>>
>
>  And I don't get it: why the first check is needed? Is there another IDE
> controller on function 1 that you want to ignore? I doubt it.

I will clean up the parens and remove the first check.

>> +MODULE_AUTHOR("SteveL@mvista.com");
>
>  I wonder why Steve didn't specify his full name... :-)

I will change this to my name.

> MBR, Sergei

Thank you for your time!

Shane
