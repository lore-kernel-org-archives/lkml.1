Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbZI1UUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbZI1UUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 16:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbZI1UUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 16:20:35 -0400
Received: from smtp-out.google.com ([216.239.33.17]:39033 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbZI1UUd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 16:20:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=VY1ccpXqMoWlDGA6JM286n7OdHyGW/MA3RoF1Q9paTp/sItnlhQtDfbD6RqMfTUyj
	TNqvY4SXbQjXzPXqsUZlA==
MIME-Version: 1.0
In-Reply-To: <200909281734.11090.bzolnier@gmail.com>
References: <20090917204935.GA7432@havoc.gtf.org> <200909202305.06199.bzolnier@gmail.com> 
	<8b5805ff0909211936s4968d11fnd3e6604d38e31c79@mail.gmail.com> 
	<200909281734.11090.bzolnier@gmail.com>
From: "Jung-Ik (John) Lee" <jilee@google.com>
Date: Mon, 28 Sep 2009 13:20:13 -0700
Message-ID: <8b5805ff0909281320x57660c0cvb6e72290c6781a99@mail.gmail.com>
Subject: Re: [git patches] libata updates
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Grant Grundler <grundler@google.com>,
       Gwendal Gringo <gwendal@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 8:34 AM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> On Tuesday 22 September 2009 04:36:13 Jung-Ik (John) Lee wrote:
>> On Sun, Sep 20, 2009 at 2:05 PM, Bartlomiej Zolnierkiewicz
>> <bzolnier@gmail.com> wrote:
>> > On Thursday 17 September 2009 22:49:35 Jeff Garzik wrote:
>> >>
>> >> Bug fixes, and a new driver.
>> >>
>> >>
>> >>
>> >> Please pull from 'upstream-linus' branch of
>> >> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus
>> >>
>> >> to receive the following updates:
>> >>
>> >>  drivers/ata/Kconfig        |    9 +
>> >>  drivers/ata/Makefile       |    1 +
>> >>  drivers/ata/ahci.c         |    4 +-
>> >>  drivers/ata/libata-core.c  |    4 +-
>> >>  drivers/ata/pata_amd.c     |    3 +
>> >>  drivers/ata/pata_atp867x.c |  548 ++++++++++++++++++++++++++++++++++++++++++++
>> >>  drivers/ata/sata_promise.c |  155 +++++++++++--
>> >>  include/linux/pci_ids.h    |    2 +
>> >>  8 files changed, 704 insertions(+), 22 deletions(-)
>> >>  create mode 100644 drivers/ata/pata_atp867x.c
>> >>
>> >> John(Jung-Ik) Lee (1):
>> >>       libata: Add pata_atp867x driver for Artop/Acard ATP867X controllers
>> >
>> > That was really fast..  Not necessarily a bad thing but this driver would
>> > benefit from few polishing touches..
>> >
>> >> diff --git a/drivers/ata/pata_atp867x.c b/drivers/ata/pata_atp867x.c
>> >> new file mode 100644
>> >> index 0000000..7990de9
>> >> --- /dev/null
>> >> +++ b/drivers/ata/pata_atp867x.c
>> >> @@ -0,0 +1,548 @@
>> >> +/*
>> >> + * pata_atp867x.c - ARTOP 867X 64bit 4-channel UDMA133 ATA controller driver
>> >> + *
>> >> + *   (C) 2009 Google Inc. John(Jung-Ik) Lee <jilee@google.com>
>> >> + *
>> >> + * Per Atp867 data sheet rev 1.2, Acard.
>> >> + * Based in part on early ide code from
>> >> + *   2003-2004 by Eric Uhrhane, Google, Inc.
>> >> + *
>> >> + * This program is free software; you can redistribute it and/or modify
>> >> + * it under the terms of the GNU General Public License as published by
>> >> + * the Free Software Foundation; either version 2 of the License, or
>> >> + * (at your option) any later version.
>> >> + *
>> >> + * This program is distributed in the hope that it will be useful,
>> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> >> + * GNU General Public License for more details.
>> >> + *
>> >> + * You should have received a copy of the GNU General Public License
>> >> + * along with this program; if not, write to the Free Software
>> >> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
>> >> + *
>> >> + *
>> >> + * TODO:
>> >> + *   1. RAID features [comparison, XOR, striping, mirroring, etc.]
>> >> + */
>> >> +
>> >> +#include <linux/kernel.h>
>> >> +#include <linux/module.h>
>> >> +#include <linux/pci.h>
>> >> +#include <linux/init.h>
>> >> +#include <linux/blkdev.h>
>> >> +#include <linux/delay.h>
>> >> +#include <linux/device.h>
>> >> +#include <scsi/scsi_host.h>
>> >> +#include <linux/libata.h>
>> >> +
>> >> +#define      DRV_NAME        "pata_atp867x"
>> >> +#define      DRV_VERSION     "0.7.5"
>> >> +
>> >> +/*
>> >> + * IO Registers
>> >> + * Note that all runtime hot priv ports are cached in ap private_data
>> >> + */
>> >> +
>> >> +enum {
>> >> +     ATP867X_IO_CHANNEL_OFFSET       = 0x10,
>> >> +
>> >> +     /*
>> >> +      * IO Register Bitfields
>> >> +      */
>> >> +
>> >> +     ATP867X_IO_PIOSPD_ACTIVE_SHIFT  = 4,
>> >> +     ATP867X_IO_PIOSPD_RECOVER_SHIFT = 0,
>> >> +
>> >> +     ATP867X_IO_DMAMODE_MSTR_SHIFT   = 0,
>> >> +     ATP867X_IO_DMAMODE_MSTR_MASK    = 0x07,
>> >> +     ATP867X_IO_DMAMODE_SLAVE_SHIFT  = 4,
>> >> +     ATP867X_IO_DMAMODE_SLAVE_MASK   = 0x70,
>> >> +
>> >> +     ATP867X_IO_DMAMODE_UDMA_6       = 0x07,
>> >> +     ATP867X_IO_DMAMODE_UDMA_5       = 0x06,
>> >> +     ATP867X_IO_DMAMODE_UDMA_4       = 0x05,
>> >> +     ATP867X_IO_DMAMODE_UDMA_3       = 0x04,
>> >> +     ATP867X_IO_DMAMODE_UDMA_2       = 0x03,
>> >> +     ATP867X_IO_DMAMODE_UDMA_1       = 0x02,
>> >> +     ATP867X_IO_DMAMODE_UDMA_0       = 0x01,
>> >> +     ATP867X_IO_DMAMODE_DISABLE      = 0x00,
>> >> +
>> >> +     ATP867X_IO_SYS_INFO_66MHZ       = 0x04,
>> >> +     ATP867X_IO_SYS_INFO_SLOW_UDMA5  = 0x02,
>> >> +     ATP867X_IO_SYS_MASK_RESERVED    = (~0xf1),
>> >> +
>> >> +     ATP867X_IO_PORTSPD_VAL          = 0x1143,
>> >> +     ATP867X_PREREAD_VAL             = 0x0200,
>> >> +
>> >> +     ATP867X_NUM_PORTS               = 4,
>> >> +     ATP867X_BAR_IOBASE              = 0,
>> >> +     ATP867X_BAR_ROMBASE             = 6,
>> >> +};
>> >> +
>> >> +#define ATP867X_IOBASE(ap)           ((ap)->host->iomap[0])
>> >> +#define ATP867X_SYS_INFO(ap)         (0x3F + ATP867X_IOBASE(ap))
>> >> +
>> >> +#define ATP867X_IO_PORTBASE(ap, port)        (0x00 + ATP867X_IOBASE(ap) + \
>> >> +                                     (port) * ATP867X_IO_CHANNEL_OFFSET)
>> >> +#define ATP867X_IO_DMABASE(ap, port) (0x40 + \
>> >> +                                     ATP867X_IO_PORTBASE((ap), (port)))
>> >> +
>> >> +#define ATP867X_IO_STATUS(ap, port)  (0x07 + \
>> >> +                                     ATP867X_IO_PORTBASE((ap), (port)))
>> >> +#define ATP867X_IO_ALTSTATUS(ap, port)       (0x0E + \
>> >> +                                     ATP867X_IO_PORTBASE((ap), (port)))
>> >> +
>> >> +/*
>> >> + * hot priv ports
>> >> + */
>> >> +#define ATP867X_IO_MSTRPIOSPD(ap, port)      (0x08 + \
>> >> +                                     ATP867X_IO_DMABASE((ap), (port)))
>> >> +#define ATP867X_IO_SLAVPIOSPD(ap, port)      (0x09 + \
>> >> +                                     ATP867X_IO_DMABASE((ap), (port)))
>> >> +#define ATP867X_IO_8BPIOSPD(ap, port)        (0x0A + \
>> >> +                                     ATP867X_IO_DMABASE((ap), (port)))
>> >> +#define ATP867X_IO_DMAMODE(ap, port) (0x0B + \
>> >> +                                     ATP867X_IO_DMABASE((ap), (port)))
>> >> +
>> >> +#define ATP867X_IO_PORTSPD(ap, port) (0x4A + \
>> >> +                                     ATP867X_IO_PORTBASE((ap), (port)))
>> >> +#define ATP867X_IO_PREREAD(ap, port) (0x4C + \
>> >> +                                     ATP867X_IO_PORTBASE((ap), (port)))
>> >> +
>> >> +struct atp867x_priv {
>> >> +     void __iomem *dma_mode;
>> >> +     void __iomem *mstr_piospd;
>> >> +     void __iomem *slave_piospd;
>> >> +     void __iomem *eightb_piospd;
>> >> +     int             pci66mhz;
>> >> +};
>> >> +
>> >> +static inline u8 atp867x_speed_to_mode(u8 speed)
>> >> +{
>> >> +     return speed - XFER_UDMA_0 + 1;
>> >> +}
>> >> +
>> >> +static void atp867x_set_dmamode(struct ata_port *ap, struct ata_device *adev)
>> >> +{
>> >> +     struct pci_dev *pdev    = to_pci_dev(ap->host->dev);
>> >> +     struct atp867x_priv *dp = ap->private_data;
>> >> +     u8 speed = adev->dma_mode;
>> >> +     u8 b;
>> >> +     u8 mode;
>> >> +
>> >> +     mode = atp867x_speed_to_mode(speed);
>> >
>> > The driver currently doesn't support MWDMA modes but claims otherwise
>> > (fixed in the attached patch).
>> >
>> >> +     /*
>> >> +      * Doc 6.6.9: decrease the udma mode value by 1 for safer UDMA speed
>> >> +      * on 66MHz bus
>> >> +      *   rev-A: UDMA_1~4 (5, 6 no change)
>> >> +      *   rev-B: all UDMA modes
>> >> +      *   UDMA_0 stays not to disable UDMA
>> >> +      */
>> >> +     if (dp->pci66mhz && mode > ATP867X_IO_DMAMODE_UDMA_0  &&
>> >> +        (pdev->device == PCI_DEVICE_ID_ARTOP_ATP867B ||
>> >> +         mode < ATP867X_IO_DMAMODE_UDMA_5))
>> >> +             mode--;
>> >> +
>> >> +     b = ioread8(dp->dma_mode);
>> >> +     if (adev->devno & 1) {
>> >> +             b = (b & ~ATP867X_IO_DMAMODE_SLAVE_MASK) |
>> >> +                     (mode << ATP867X_IO_DMAMODE_SLAVE_SHIFT);
>> >> +     } else {
>> >> +             b = (b & ~ATP867X_IO_DMAMODE_MSTR_MASK) |
>> >> +                     (mode << ATP867X_IO_DMAMODE_MSTR_SHIFT);
>> >> +     }
>> >> +     iowrite8(b, dp->dma_mode);
>> >> +}
>> >> +
>> >> +static int atp867x_get_active_clocks_shifted(unsigned int clk)
>> >> +{
>> >> +     unsigned char clocks = clk;
>> >> +
>> >> +     switch (clocks) {
>> >> +     case 0:
>> >> +             clocks = 1;
>> >> +             break;
>> >> +     case 1 ... 7:
>> >> +             break;
>> >> +     case 8 ... 12:
>> >> +             clocks = 7;
>> >
>> > Shouldn't "clocks = 0" (the default case) be used here?
>>
>> The clocks value 0 sets it to 8 clocks, while value 7 sets to 12 clocks.
>
> This would explain it but then there is no need to use "clocks = 7"
> for the _input_ "clocks == 7".
>
>> I cleaned up a bit on clocks_shift. See the patch below.
>>
>> > Otherwise it seems to result in underclocked timings for dp->pci66mhz == 0.
>> >
>> >> +             break;
>> >> +     default:
>> >> +             printk(KERN_WARNING "ATP867X: active %dclk is invalid. "
>> >> +                     "Using default 8clk.\n", clk);
>> >> +             clocks = 0;     /* 8 clk */
>> >> +             break;
>> >> +     }
>> >> +     return clocks << ATP867X_IO_PIOSPD_ACTIVE_SHIFT;
>> >> +}
>> >> +
>> >> +static int atp867x_get_recover_clocks_shifted(unsigned int clk)
>> >> +{
>> >> +     unsigned char clocks = clk;
>> >> +
>> >> +     switch (clocks) {
>> >> +     case 0:
>> >> +             clocks = 1;
>> >> +             break;
>> >> +     case 1 ... 11:
>> >> +             break;
>> >> +     case 12:
>> >> +             clocks = 0;
>> >> +             break;
>> >> +     case 13: case 14:
>> >> +             --clocks;
>> >> +             break;
>> >
>> > Is "clocks == 14" a reserved setting?
>>
>> 12 is reserved for the default (== 0), and 13, 14 are set to value 12,
>> 13 respectively.
>
> I meant the _output_ "clocks == 14" here.
>
>> >
>> > If so a comment documenting it would be appreciated.
>>
>> Sure. see the new patch below.
>>
>> >
>> >> +     case 15:
>> >> +             break;
>> >> +     default:
>> >> +             printk(KERN_WARNING "ATP867X: recover %dclk is invalid. "
>> >> +                     "Using default 15clk.\n", clk);
>> >> +             clocks = 0;     /* 12 clk */
>> >
>> > Shouldn't it use "clocks == 15" setting?
>> It was a typo. 12 is the right default.
>>
>> >
>> >> +             break;
>> >> +     }
>> >> +     return clocks << ATP867X_IO_PIOSPD_RECOVER_SHIFT;
>> >> +}
>> >> +
>> >> +static void atp867x_set_piomode(struct ata_port *ap, struct ata_device *adev)
>> >> +{
>> >> +     struct ata_device *peer = ata_dev_pair(adev);
>> >> +     struct atp867x_priv *dp = ap->private_data;
>> >> +     u8 speed = adev->pio_mode;
>> >> +     struct ata_timing t, p;
>> >> +     int T, UT;
>> >> +     u8 b;
>> >> +
>> >> +     T = 1000000000 / 33333;
>> >> +     UT = T / 4;
>> >> +
>> >> +     ata_timing_compute(adev, speed, &t, T, UT);
>> >> +     if (peer && peer->pio_mode) {
>> >> +             ata_timing_compute(peer, peer->pio_mode, &p, T, UT);
>> >> +             ata_timing_merge(&p, &t, &t, ATA_TIMING_8BIT);
>> >> +     }
>> >> +
>> >> +     b = ioread8(dp->dma_mode);
>> >> +     if (adev->devno & 1)
>> >> +             b = (b & ~ATP867X_IO_DMAMODE_SLAVE_MASK);
>> >> +     else
>> >> +             b = (b & ~ATP867X_IO_DMAMODE_MSTR_MASK);
>> >> +     iowrite8(b, dp->dma_mode);
>> >> +
>> >> +     b = atp867x_get_active_clocks_shifted(t.active) |
>> >> +             atp867x_get_recover_clocks_shifted(t.recover);
>> >> +     if (dp->pci66mhz)
>> >> +             b += 0x10;
>> >
>> > What is the purpose of the above hack?
>>
>> For safe PIO mode according to spec.
>>
>> >
>> > AFAICS (I don't have a datasheet) it may result in invalid active
>> > clocks being used for t.active > 12 and 0x80 bit being set incorrectly
>> > for t.active values 7..12 (unless it was the purpose of the hack).
>>
>> See the patch below..
>>
>> >
>> >> +     if (adev->devno & 1)
>> >> +             iowrite8(b, dp->slave_piospd);
>> >> +     else
>> >> +             iowrite8(b, dp->mstr_piospd);
>> >> +
>> >> +     /*
>> >> +      * use the same value for comand timing as for PIO timimg
>> >> +      */
>> >> +     iowrite8(b, dp->eightb_piospd);
>> >
>> > This is incorrect if slave/master devices use different PIO modes
>> > or if PIO mode <= 2 is used by any device.
>> >
>> > Timing based on t.act8b and t.rec8b values should be used instead.
>>
>> act8b and rec8b have the same values as active, recovery of the port.
>
> Please take a look at drivers/ata/libata-core.c::ata_timing[] table:
>
> ...
>        { XFER_PIO_0,     70, 290, 240, 600, 165, 150, 0,  600,   0 },
>        { XFER_PIO_1,     50, 290,  93, 383, 125, 100, 0,  383,   0 },
>        { XFER_PIO_2,     30, 290,  40, 330, 100,  90, 0,  240,   0 },
>        { XFER_PIO_3,     30,  80,  70, 180,  80,  70, 0,  180,   0 },
>        { XFER_PIO_4,     25,  70,  25, 120,  70,  25, 0,  120,   0 },
>        { XFER_PIO_5,     15,  65,  25, 100,  65,  25, 0,  100,   0 },
>        { XFER_PIO_6,     10,  55,  20,  80,  55,  20, 0,   80,   0 },
> ...
>
> For PIO modes <= 2 (or if master/slave devices use different PIO modes)
> we'll have different values, i.e. for PIO2 in case of a single device on
> the port using standard timings we'll have:
>
> t.active   =  4
> t.recovery =  4
> t.act8b    = 10
> t.rec8b    =  2
>
> Most likely we won't see much use of this driver with older devices,
> however this should not stop us from supporting them and at the same
> time making the driver easier to maintain.
>
>> If a:r=3:1 then they become 4:1 on 66mhz for safer transfer, and
>> a8:r8=3:1, which is identical but the a8 should be incremented by 1.
>> I can use a8:r8 with 66mhz fixup but it becomes the same as using a:r.
>> Take a look at the patch below.
>>
>> >
>> > On the somehow related note:
>> >
>> > * I don't see how PIO0-2 command timings can be met with only 3 bits
>> >  used for active clocks.  Could it be that dp->eight_piospd should be
>> >  programmed in a slightly different way than dp->{mstr,slave}_piospd?
>> >
>>
>> See new patch on clocks_shift below.
>>
>> > * The controller allows higher clocks values for recovery timings but
>> >  ata_timing_compute() tries to fairly increase both recovery and active
>> >  timings to meet the required cycle timing.
>> >
>> >> +}
>> >> +
>> >> +static int atp867x_cable_detect(struct ata_port *ap)
>> >> +{
>> >> +     return ATA_CBL_PATA40_SHORT;
>> >> +}
>> >
>> > As noticed by Robert and Alan already:
>> >
>> > This should use ATA_CBL_PATA_UNK and rely on the driver-side cable detection.
>>
>> I modified cable_detect() to use override; on a certain
>> subsystem_vendor|device, its 40short, others, unknown.
>>
>> >
>> >
>> > One last thing: Power Management support is missing from this driver
>> > (I tried addressing this in the separately posted patch but it needs
>> > testing by somebody with the hardware).
>> >
>> >
>> > MWDMA fix:
>> >
>> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> > Subject: [PATCH] pata_atp867x: fix it to not claim MWDMA support
>> >
>> > MWDMA modes are not supported by this driver currently.
>> >
>> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> > ---
>> >  drivers/ata/pata_atp867x.c |   10 +---------
>> >  1 file changed, 1 insertion(+), 9 deletions(-)
>> >
>> > Index: b/drivers/ata/pata_atp867x.c
>> > ===================================================================
>> > --- a/drivers/ata/pata_atp867x.c
>> > +++ b/drivers/ata/pata_atp867x.c
>> > @@ -118,20 +118,13 @@ struct atp867x_priv {
>> >        int             pci66mhz;
>> >  };
>> >
>> > -static inline u8 atp867x_speed_to_mode(u8 speed)
>> > -{
>> > -       return speed - XFER_UDMA_0 + 1;
>> > -}
>> > -
>> >  static void atp867x_set_dmamode(struct ata_port *ap, struct ata_device *adev)
>> >  {
>> >        struct pci_dev *pdev    = to_pci_dev(ap->host->dev);
>> >        struct atp867x_priv *dp = ap->private_data;
>> >        u8 speed = adev->dma_mode;
>> >        u8 b;
>> > -       u8 mode;
>> > -
>> > -       mode = atp867x_speed_to_mode(speed);
>> > +       u8 mode = speed - XFER_UDMA_0 + 1;
>> >
>> >        /*
>> >         * Doc 6.6.9: decrease the udma mode value by 1 for safer UDMA speed
>> > @@ -471,7 +464,6 @@ static int atp867x_init_one(struct pci_d
>> >        static const struct ata_port_info info_867x = {
>> >                .flags          = ATA_FLAG_SLAVE_POSS,
>> >                .pio_mask       = ATA_PIO4,
>> > -               .mwdma_mask     = ATA_MWDMA2,
>>
>> This looks good to me. thx.
>>
>> >                .udma_mask      = ATA_UDMA6,
>> >                .port_ops       = &atp867x_ops,
>> >        };
>> >
>>
>>
>> From: John(Jung-Ik) Lee <jilee@google.com>
>>
>> clarifications in timings calculations and cable detection
>>
>> Signed-off-by: John(Jung-Ik) Lee <jilee@google.com>
>> ---
>>
>>  pata_atp867x.c |   50 +++++++++++++++++++++++++++++++++++++-------------
>>  1 files changed, 37 insertions, 13 deletions
>>
>> diff --git a/drivers/ata/pata_atp867x.c b/drivers/ata/pata_atp867x.c
>> index e6c4706..c1c691f 100644
>> --- a/drivers/ata/pata_atp867x.c
>> +++ b/drivers/ata/pata_atp867x.c
>> @@ -156,8 +156,10 @@ static void atp867x_set_dmamode(struct ata_port
>> *ap, struct ata_device *adev)
>>       iowrite8(b, dp->dma_mode);
>>  }
>>
>> -static int atp867x_get_active_clocks_shifted(unsigned int clk)
>> +static int atp867x_get_active_clocks_shifted(struct ata_port *ap,
>> +     unsigned int clk)
>>  {
>> +     struct atp867x_priv *dp = ap->private_data;
>>       unsigned char clocks = clk;
>>
>>       switch (clocks) {
>> @@ -166,15 +168,25 @@ static int
>> atp867x_get_active_clocks_shifted(unsigned int clk)
>>               break;
>>       case 1 ... 7:
>>               break;
>> -     case 8 ... 12:
>> +     case 9 ... 12:
>>               clocks = 7;
>>               break;
>>       default:
>>               printk(KERN_WARNING "ATP867X: active %dclk is invalid. "
>>                       "Using default 8clk.\n", clk);
>> -             clocks = 0;     /* 8 clk */
>> -             break;
>> +     case 8: /* default 8 clk */
>> +             clocks = 0;
>> +             goto active_clock_shift_done;
>>       }
>> +
>> +     /*
>> +      * Doc 6.6.9: increase the clock value by 1 for safer PIO speed
>> +      * on 66MHz bus
>> +      */
>> +     if (dp->pci66mhz && clocks < 7)
>> +             clocks++;
>> +
>> +active_clock_shift_done:
>>       return clocks << ATP867X_IO_PIOSPD_ACTIVE_SHIFT;
>>  }
>>
>> @@ -188,20 +200,19 @@ static int
>> atp867x_get_recover_clocks_shifted(unsigned int clk)
>>               break;
>>       case 1 ... 11:
>>               break;
>> -     case 12:
>> -             clocks = 0;
>> -             break;
>>       case 13: case 14:
>> -             --clocks;
>> +             --clocks;       /* by the spec */
>>               break;
>>       case 15:
>>               break;
>>       default:
>>               printk(KERN_WARNING "ATP867X: recover %dclk is invalid. "
>>                       "Using default 12clk.\n", clk);
>> -             clocks = 0;     /* 12 clk */
>> +     case 12:        /* default 12 clk */
>> +             clocks = 0;
>>               break;
>>       }
>> +
>>       return clocks << ATP867X_IO_PIOSPD_RECOVER_SHIFT;
>>  }
>>
>> @@ -230,10 +241,8 @@ static void atp867x_set_piomode(struct ata_port
>> *ap, struct ata_device *adev)
>>               b = (b & ~ATP867X_IO_DMAMODE_MSTR_MASK);
>>       iowrite8(b, dp->dma_mode);
>>
>> -     b = atp867x_get_active_clocks_shifted(t.active) |
>> +     b = atp867x_get_active_clocks_shifted(ap, t.active) |
>>               atp867x_get_recover_clocks_shifted(t.recover);
>> -     if (dp->pci66mhz)
>> -             b += 0x10;
>>
>>       if (adev->devno & 1)
>>               iowrite8(b, dp->slave_piospd);
>> @@ -246,9 +255,24 @@ static void atp867x_set_piomode(struct ata_port
>> *ap, struct ata_device *adev)
>>       iowrite8(b, dp->eightb_piospd);
>>  }
>>
>> +static int atp867x_cable_override(struct pci_dev *pdev)
>> +{
>> +     if (pdev->subsystem_vendor == PCI_VENDOR_ID_ARTOP &&
>> +             (pdev->subsystem_device == PCI_DEVICE_ID_ARTOP_ATP867A ||
>> +              pdev->subsystem_device == PCI_DEVICE_ID_ARTOP_ATP867B)) {
>> +             return 1;
>> +     }
>> +     return 0;
>> +}
>> +
>>  static int atp867x_cable_detect(struct ata_port *ap)
>>  {
>> -     return ATA_CBL_PATA40_SHORT;
>> +     struct pci_dev *pdev = to_pci_dev(ap->host->dev);
>> +
>> +     if (atp867x_cable_override(pdev))
>> +             return ATA_CBL_PATA40_SHORT;
>> +
>> +     return ATA_CBL_PATA_UNK;
>>  }
>>
>>  static struct scsi_host_template atp867x_sht = {
>
> Thanks, your patch looks good to me but since there are still some
> leftover issues left we would also need something like the incremental
> patch below:

[resending - bounced back from -ide, -kernel]

your patch below looks good to me.
-John

>
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] pata_atp867x: PIO support fixes
>
> * use  8 clk setting for active clocks == 7 (was 12 clk)
> * use 12 clk setting for active clocks > 12 (was  8 clk)
> * do 66MHz bus fixup before mapping active clocks
> * fix setup of PIO command timings
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ata/pata_atp867x.c |   36 +++++++++++++++++++-----------------
>  1 file changed, 19 insertions(+), 17 deletions(-)
>
> Index: b/drivers/ata/pata_atp867x.c
> ===================================================================
> --- a/drivers/ata/pata_atp867x.c
> +++ b/drivers/ata/pata_atp867x.c
> @@ -155,30 +155,31 @@ static int atp867x_get_active_clocks_shi
>        struct atp867x_priv *dp = ap->private_data;
>        unsigned char clocks = clk;
>
> +       /*
> +        * Doc 6.6.9: increase the clock value by 1 for safer PIO speed
> +        * on 66MHz bus
> +        */
> +       if (dp->pci66mhz)
> +               clocks++;
> +
>        switch (clocks) {
>        case 0:
>                clocks = 1;
>                break;
> -       case 1 ... 7:
> -               break;
> -       case 9 ... 12:
> -               clocks = 7;
> +       case 1 ... 6:
>                break;
>        default:
>                printk(KERN_WARNING "ATP867X: active %dclk is invalid. "
> -                       "Using default 8clk.\n", clk);
> +                       "Using 12clk.\n", clk);
> +       case 9 ... 12:
> +               clocks = 7;     /* 12 clk */
> +               break;
> +       case 7:
>        case 8: /* default 8 clk */
>                clocks = 0;
>                goto active_clock_shift_done;
>        }
>
> -       /*
> -        * Doc 6.6.9: increase the clock value by 1 for safer PIO speed
> -        * on 66MHz bus
> -        */
> -       if (dp->pci66mhz && clocks < 7)
> -               clocks++;
> -
>  active_clock_shift_done:
>        return clocks << ATP867X_IO_PIOSPD_ACTIVE_SHIFT;
>  }
> @@ -193,7 +194,8 @@ static int atp867x_get_recover_clocks_sh
>                break;
>        case 1 ... 11:
>                break;
> -       case 13: case 14:
> +       case 13:
> +       case 14:
>                --clocks;       /* by the spec */
>                break;
>        case 15:
> @@ -235,16 +237,16 @@ static void atp867x_set_piomode(struct a
>        iowrite8(b, dp->dma_mode);
>
>        b = atp867x_get_active_clocks_shifted(ap, t.active) |
> -               atp867x_get_recover_clocks_shifted(t.recover);
> +           atp867x_get_recover_clocks_shifted(t.recover);
>
>        if (adev->devno & 1)
>                iowrite8(b, dp->slave_piospd);
>        else
>                iowrite8(b, dp->mstr_piospd);
>
> -       /*
> -        * use the same value for comand timing as for PIO timimg
> -        */
> +       b = atp867x_get_active_clocks_shifted(ap, t.act8b) |
> +           atp867x_get_recover_clocks_shifted(t.rec8b);
> +
>        iowrite8(b, dp->eightb_piospd);
>  }
>
>
