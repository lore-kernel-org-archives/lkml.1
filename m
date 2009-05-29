Return-Path: <linux-kernel-owner+w=401wt.eu-S1760807AbZE2Peo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760807AbZE2Peo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 11:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758835AbZE2Peh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 11:34:37 -0400
Received: from drewtech.com ([66.36.241.150]:38436 "EHLO server.drewtech.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757618AbZE2Peg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 11:34:36 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 May 2009 11:34:36 EDT
Message-ID: <4A1FFEFB.6050104@drewtech.com>
Date: Fri, 29 May 2009 11:27:55 -0400
From: Joey Oravec <joravec@drewtech.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Rob Emanuele <poorarm@shoreis.com>
CC: nicolas.ferre@atmel.com, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] New AT91 MCI Driver that supports both MCI slots used
 at the 	same time
References: <c8284b5b0905281440hd2e4993re3d0d8c590713fa0@mail.gmail.com>
In-Reply-To: <c8284b5b0905281440hd2e4993re3d0d8c590713fa0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Emanuele wrote:
> This patch creates a new AT91 Multimedia Card Interface (MCI) driver
> that supports using both MCI slots at the same time.  I'm looking for
> others to test this patch on other boards within the same family of
> chips.
>
> This driver is a port the Atmel AVR32 MCI driver which uses similar silicon.
>   
I made all necessary adjustments to test this on my at91sam9261. 
Unfortunately it didn't want to initialize my card so I wasn't able to 
try some of the failures that I experience with the existing driver. I 
sent you a private email with the logs.

> +config MMC_AT91GEN2
> +	tristate "Atmel AT91 Multimedia Card Interface support 2nd gen"
> +	depends on ARCH_AT91
> +	help
>   
On linux-arm-kernel I've detailed a lot of problems involving 
WRITE_MULTIPLE_BLOCK using the at91 mmc/sd controller. In the end you 
might need to exclude certain processors or else have a gigantic 
warning. You can talk to me offline for details on my testing.

> +struct at91_mmc_slot_pdata {
> +        unsigned int            bus_width;
> +        int                     detect_pin;
> +        int                     wp_pin;
> +        int                     vcc_pin;
> +};
>   
Notice in 2.6.29 that at91_mci and most other structures call it 
"det_pin" rather than "detect_pin"

> +	if (host->need_reset) {
> +		at91_mci_write(host, AT91_MCI_CR, AT91_MCI_SWRST);
> +		at91_mci_write(host, AT91_MCI_CR, AT91_MCI_MCIEN);
> +		at91_mci_write(host, AT91_MCI_MR, host->mode_reg);
> +		host->need_reset = false;
> +	}
>   
In my experience some at91s need a reset after every single command, 
otherwise bad things happen. I think the need_reset logic is too 
conservative in this driver.

> +		/*
> +		 * WRPROOF and RDPROOF prevent overruns/underruns by
> +		 * stopping the clock when the FIFO is full/empty.
> +		 * This state is not expected to last for long.
> +		 */
> +		host->mode_reg = (AT91_MCI_CLKDIV & clkdiv) | AT91_MCI_WRPROOF
> +					| AT91_MCI_RDPROOF;
>   
These registers are not in all at91 chips especially the at91sam9261.

> +	if (pdata->slot[0].bus_width) {
> +		ret = at91mci_init_slot(host, &pdata->slot[0],
> +				AT91_MCI_SDCSEL & 0x0, 0);
> +		if (!ret)
> +			nr_slots++;
> +	}
> +	if (pdata->slot[1].bus_width) {
> +		ret = at91mci_init_slot(host, &pdata->slot[1],
> +				AT91_MCI_SDCSEL & 0x1, 1);
> +		if (!ret)
> +			nr_slots++;
> +	}
> +
> +	if (!nr_slots)
> +		goto err_init_slot;
>   
The original pdata had "wire4" which worked (but defaulted to 1-wire) as 
default uninitialized. With this new variable it's easy to register 
mmc_slot_pdata with bus_width set to zero. The difference bit me when 
testing and at least deserves a printk if not a change.

-joey
