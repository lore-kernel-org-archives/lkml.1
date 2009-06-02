Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbZFBQyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbZFBQyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 12:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbZFBQxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 12:53:55 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:35405 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbZFBQxy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 12:53:54 -0400
MIME-Version: 1.0
In-Reply-To: <4A1FFEFB.6050104@drewtech.com>
References: <c8284b5b0905281440hd2e4993re3d0d8c590713fa0@mail.gmail.com>
	 <4A1FFEFB.6050104@drewtech.com>
Date: Tue, 2 Jun 2009 09:53:54 -0700
X-Google-Sender-Auth: 106f8b3eb4eb94e1
Message-ID: <c8284b5b0906020953o7c112b4hc264b5520cc3aed1@mail.gmail.com>
Subject: Re: [PATCH] New AT91 MCI Driver that supports both MCI slots used at 
	the same time
From: Rob Emanuele <poorarm@shoreis.com>
To: Joey Oravec <joravec@drewtech.com>
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings Joey,

On Fri, May 29, 2009 at 8:27 AM, Joey Oravec <joravec@drewtech.com> wrote:
> Rob Emanuele wrote:
>>
>> This patch creates a new AT91 Multimedia Card Interface (MCI) driver
>> that supports using both MCI slots at the same time.  I'm looking for
>> others to test this patch on other boards within the same family of
>> chips.
>>
>> This driver is a port the Atmel AVR32 MCI driver which uses similar
>> silicon.
>>
>
> I made all necessary adjustments to test this on my at91sam9261.
> Unfortunately it didn't want to initialize my card so I wasn't able to try
> some of the failures that I experience with the existing driver. I sent you
> a private email with the logs.
>

I'll have a further look at your logs and see if I can distingush why
the driver does not initialize for for you.  Unfortunately the only
hardware I have access to is a AT91SAM9G20-EK Rev. B and a
AT91SAM9XE-EK (maybe Rev A  which is also the same board as what is
used for the AT91SAM9620).  Either way I'll try to be as much help as
I can.  I will provide in my next version of the patch a full
board-sam9g20-dualslot.c file to show how I am initializing the board.

>> +config MMC_AT91GEN2
>> +       tristate "Atmel AT91 Multimedia Card Interface support 2nd gen"
>> +       depends on ARCH_AT91
>> +       help
>>
>
> On linux-arm-kernel I've detailed a lot of problems involving
> WRITE_MULTIPLE_BLOCK using the at91 mmc/sd controller. In the end you might
> need to exclude certain processors or else have a gigantic warning. You can
> talk to me offline for details on my testing.

I will look into this as it might be important to some of the errors I
see.  If you can point me to those messages in one of the archives,
I'd appreciate it.

>
>> +struct at91_mmc_slot_pdata {
>> +        unsigned int            bus_width;
>> +        int                     detect_pin;
>> +        int                     wp_pin;
>> +        int                     vcc_pin;
>> +};
>>
>
> Notice in 2.6.29 that at91_mci and most other structures call it "det_pin"
> rather than "detect_pin"
>

I changed the pin name for my next patch.

>> +       if (host->need_reset) {
>> +               at91_mci_write(host, AT91_MCI_CR, AT91_MCI_SWRST);
>> +               at91_mci_write(host, AT91_MCI_CR, AT91_MCI_MCIEN);
>> +               at91_mci_write(host, AT91_MCI_MR, host->mode_reg);
>> +               host->need_reset = false;
>> +       }
>>
>
> In my experience some at91s need a reset after every single command,
> otherwise bad things happen. I think the need_reset logic is too
> conservative in this driver.
>

I'll try this and probably make it an option to always reset before
each command.

>> +               /*
>> +                * WRPROOF and RDPROOF prevent overruns/underruns by
>> +                * stopping the clock when the FIFO is full/empty.
>> +                * This state is not expected to last for long.
>> +                */
>> +               host->mode_reg = (AT91_MCI_CLKDIV & clkdiv) |
>> AT91_MCI_WRPROOF
>> +                                       | AT91_MCI_RDPROOF;
>>
>
> These registers are not in all at91 chips especially the at91sam9261.

I'll look into this but will not be able to test every case.

>
>> +       if (pdata->slot[0].bus_width) {
>> +               ret = at91mci_init_slot(host, &pdata->slot[0],
>> +                               AT91_MCI_SDCSEL & 0x0, 0);
>> +               if (!ret)
>> +                       nr_slots++;
>> +       }
>> +       if (pdata->slot[1].bus_width) {
>> +               ret = at91mci_init_slot(host, &pdata->slot[1],
>> +                               AT91_MCI_SDCSEL & 0x1, 1);
>> +               if (!ret)
>> +                       nr_slots++;
>> +       }
>> +
>> +       if (!nr_slots)
>> +               goto err_init_slot;
>>
>
> The original pdata had "wire4" which worked (but defaulted to 1-wire) as
> default uninitialized. With this new variable it's easy to register
> mmc_slot_pdata with bus_width set to zero. The difference bit me when
> testing and at least deserves a printk if not a change.
>

I'm happy to add a printk saying that the port was disabled by a bus
width of zero.

Thanks for you interest in this work,

Rob
