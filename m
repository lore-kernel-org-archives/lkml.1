Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbYLVHvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbYLVHvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 02:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYLVHvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 02:51:04 -0500
Received: from mail-gx0-f13.google.com ([209.85.217.13]:50643 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbYLVHvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 02:51:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hwePyKVzs5+pVuyZM+aPGlkK918bd9/SimZBWxqeevW/m+08Ep73wWU1XmGPM3E8F3
         Iuwoo1y/0IEbuc+/079XGuwBvsWxMHd1KJ6Keq0iZOc7fSeJkphmdnO7BTkhfX92qPp1
         268/mEg5gUk6f84hh3TWZRmBadYlGM/Skb5To=
Message-ID: <b2b2f2320812212350w3225e6dfp276091a25b8aaa66@mail.gmail.com>
Date: Mon, 22 Dec 2008 01:50:59 -0600
From: "Shane McDonald" <mcdonald.shane@gmail.com>
To: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] Resurrect IT8172 IDE controller driver
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <493D0CB8.3060900@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1L4UpB-0007ro-1g@localhost> <492A8306.9000400@ru.mvista.com>
	 <b2b2f2320812031839q43eb6102jbae0fbddd9a1cf75@mail.gmail.com>
	 <493D0CB8.3060900@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have updated this driver with a version 3 of the patch, taking into
account all of these comments.
See resolutions below.  The updated patch will follow shortly.

On Mon, Dec 8, 2008 at 6:02 AM, Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:
>
> Shane McDonald wrote:
>
>> On Mon, Nov 24, 2008 at 4:33 AM, Sergei Shtylyov
>> <sshtylyov@ru.mvista.com> wrote:
>>
>>>> +static void it8172_set_pio_mode(ide_drive_t *drive, const u8 pio)
>>>> +{
>>>> +       ide_hwif_t *hwif        = HWIF(drive);
>>>> +       struct pci_dev *dev     = to_pci_dev(hwif->dev);
>>>> +       int is_slave            = (&hwif->drives[1] == drive);
>>>>
>>>
>>>  Use simpler "drive->dn & 1" (and drop the useless parens please) -- & can
>>> be dropped though as the controller has only a single channel...
>>>
>>
>>  I don't believe it can be dropped entirely -- although the
>> controller only has a single channel, it does support two drives on
>> that channel.  Unless I understand incorrectly, I will make the
>> "drive->dn & 1" change.
>>
>
>  Believe it or not, drive->dn will be 0 or 1 in this case, so & is superfluous. :-)
>  I don't insist on dropping it though...

Of course!  I will drop the &.  Also, because this variable is only
used once, I'll drop the
variable entirely.

>>>> +       /*
>>>> +        * Enable port 0x44. The IT8172 spec is confused; it calls
>>>> +        * this register the "Slave IDE Timing Register", but in fact,
>>>> +        * it controls timing for both master and slave drives.
>>>> +        */
>>>> +       drive_enables |= 0x4000;
>>>
>>>  This is strange because this IDE controller seems to be a clone of the one
>>> in the Intel PIIX chip. However, the spec. I have tellm it's not an exact
>>> clone.
>>>
>
>  I just don't undestand what this bit is good for in IT8172G... Perhaps by clearing it once could achieve PIO0 timings, just like by clearing the fast timing bits on PIIX?

That would make sense, but there is nothing in the spec that states
that.  The bit does need
to be set, so I'll leave this in.

>>> I suggest that you take a close look at drivers/ide/piix.c...
>>
>> The specs I have indicate that it is not the same.  For example, bits
>> 13:12 in the IDETIM register at offset 0x40-0x41 of the PIIX give the
>> IORDY Sample Point, but the same function is found in bits 19-17 in
>> the SLVT register at offset 0x44-0x47 in the IT8172.  Perhaps better
>> comments are in order, or perhaps these bitfields should be defined in
>> a .h file?
>>
>
>  No, IT8172G just implements them differently. But you can still find in this driver a good example of how things should be done...

I have updated the driver to add in the proper handling of the various
PIO modes,
in a similar manner to what the PIIX driver does.

>>>> +static void it8172_set_dma_mode(ide_drive_t *drive, const u8 speed)
>>>> +{
>>>> +       ide_hwif_t *hwif        = HWIF(drive);
>>>> +       struct pci_dev *dev     = to_pci_dev(hwif->dev);
>>>> +       int a_speed             = 3 << (drive->dn * 4);
>>>> +       int u_flag              = 1 << drive->dn;
>>>> +       int u_speed             = 0;
>>>> +       u8 reg48, reg4a;
>>>> +
>>>> +       const u8 mwdma_to_pio[] = { 0, 3, 4 };
>>>> +       u8 pio;
>>>> +
>>>> +       pci_read_config_byte(dev, 0x48, &reg48);
>>>> +       pci_read_config_byte(dev, 0x4a, &reg4a);
>>>> +
>>>> +       if (speed >= XFER_UDMA_0) {
>>>> +
>>>> +               /* Setting the DMA cycle time to 2 or 3 PCI clocks
>>>> +                * (60 and 91 nsec at 33 MHz PCI clock) seems to cause
>>>> +                * BadCRC errors during DMA transfers on some drives,
>>>>
>>>
>>>  Sigh, such drives should have been blacklisted...
>>>
>>
>> Do you think I should keep this code in here?  It kind of seems silly
>> to run drivers at UDMA0 speeds just because of a few bad drives back
>> in 2000 when the driver was originally written.
>
>  If was only happening for some drives, you probably shouldn't keep it...

Code removed.

>>>> +static const struct ide_port_info it8172_chipset __devinitdata = {
>>>> +       .name           = DRV_NAME,
>>>> +       .init_chipset   = init_chipset_it8172,
>>>> +       .port_ops       = &it8172_port_ops,
>>>> +       .enablebits     = {{0x00, 0x00, 0x00}, {0x40, 0x00, 0x01} },
>>>
>>>  Wrong, should be:
>>>
>>>       .enablebits     = {{0x41, 0x80, 0x80}, {0x00, 0x00, 0x00}},
>>>
>> Well, mine is clearly wrong.  Am I correct that {0x41, 0x80, 0x80} is
>> checking that the IDE Decode Enable bit is set?  This bit is in the
>> same location in both the PIIX and the IT8172.
>
>  Yes, you're correct. You should add the code to force it enabled if the bootloader doesn't do that.

Updated accordingly.

>>>>       .host_flags     = IDE_HFLAG_SINGLE,
>>>> +       .pio_mask       = ATA_PIO4,
>>>>
>
>  I'm not seeing how PIO mode 0 is supportable.

I'll indicate PIO mode 0 is not supported.

>>>> +       .swdma_mask     = ATA_SWDMA2_ONLY,
>>>>
>
>  The SWDMA support could be dropped altogether -- these modes are slow and long obsolete.

Dropped!

>>>> +       .mwdma_mask     = ATA_MWDMA12_ONLY,
>>>
>>>  More modes are supportable...
>>
>> I will update accordingly.
>
>  These masks were stolen from the piix.c driver and are determined by the limitation of the timing register fileds being only 2-bit wide. IT8172G has these bits implemented differently, hence the limitation shouldn't apply. You shouldn't just update the masks without doing anythiung about programming the modes...

Mode programming added, and mask now set to ATA_MWDMA2

>>>> +MODULE_AUTHOR("SteveL@mvista.com");
>>>
>>>  I wonder why Steve didn't specify his full name... :-)

I've changed it to "Steve Longerbeam", and I removed the obsolete email address.

Shane
