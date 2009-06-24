Return-Path: <linux-kernel-owner+w=401wt.eu-S1752526AbZFXIJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbZFXIJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 04:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZFXIJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 04:09:41 -0400
Received: from customer-relay.songnetworks.se ([195.42.210.9]:36857 "EHLO
	customer-relay.songnetworks.se" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751560AbZFXIJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 04:09:39 -0400
Message-ID: <4A41DF44.4060705@mocean-labs.com>
Date: Wed, 24 Jun 2009 10:09:40 +0200
From: =?ISO-8859-15?Q?Richard_R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
Cc: spi-devel-general@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND][PATCH] SPI: xilinx_spi: Added platform driver and support
 for DS570
References: <4A366622.2050606@mocean-labs.com> <200906231237.54278.david-b@pacbell.net>
In-Reply-To: <200906231237.54278.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-06-23 21.37, David Brownell wrote:
> On Monday 15 June 2009, Richard Röjfors wrote:
>> This patch splits xilinx_spi into three parts, an OF and a platform
>> driver and generic part.
>>
>> The generic part now also works on X86 and also supports the Xilinx
>> SPI IP DS570
> 
> Your Kconfig still mentions only DS464.

Correct, will update.


> Is there any reason the platform driver shouldn't also build on x86?
> Surely *any* system should be able to talk to an FPGA which exports
> this register interface?

The platform _builds_ on X86, previously the driver only built on PPC.

That's one of my updates.


>> Signed-off-by: Richard Röjfors <richard.rojfors.ext@mocean-labs.com>
> 
> I'll second Andrew's comments.  Also, for my review, it'd be
> better to split OF bits out from the rest ... but maybe that's
> not practical given the previous xilinx_spi code.  At least
> future patches will have a more-sane structure to build on.

Ah I will generate three patches in the future. (generic, platform, of).


>> +config SPI_XILINX_OF
>> +	tristate "Xilinx SPI controller OF device"
>> +	depends on SPI_XILINX && XILINX_VIRTEX
>> +	help
>> +	  This exposes the SPI controller IP from the Xilinx EDK.
> 
> If it's IP, then why is it dependent on VIRTEX?  Surely
> the same IP should work on Spartan etc.  I'd think just
> depending on something like OF should suffice.

Actually I left the OF part with the same dependencies as the whole
driver had before.

We run the IP on a spartan, so you are completely right :)

Will update to OF-something.


>> +
>> +	  See the "OPB Serial Peripheral Interface (SPI) (v1.00e)"
>> +	  Product Specification document (DS464) for hardware details.
>> +
>> +config SPI_XILINX_PLTFM
>> +	tristate "Xilinx SPI controller platform device"
>> +	depends on SPI_XILINX
> 
> This should go first in the Kconfig, so that you don't goof up
> the dependency display ... the OF bits depend on it.

The OF parts only depend on SPI_XILINX, not SPI_XILINX_PLTFM. But
I can change the order anyway(?)


>> --- linux-2.6.30-rc7-spi/drivers/spi/xilinx_spi_of.c	(revision 0)
>> +++ linux-2.6.30-rc7-spi/drivers/spi/xilinx_spi_of.c	(revision 912)
>> @@ -0,0 +1,123 @@
>> 	...
> 
>> +
>> +/* work with hotplug and coldplug */
>> +MODULE_ALIAS("platform:" XILINX_SPI_NAME);
> 
> This is clearly inappropriate for a file with an OpenFirmware driver.
> For that matter, it's not needed with platform devices any more either;
> so take it out of your platform driver code too.

Oops, my mistake, will remove it.


>> --- linux-2.6.30-rc7-spi/include/linux/spi/xilinx_spi.h	(revision 0)
>> +++ linux-2.6.30-rc7-spi/include/linux/spi/xilinx_spi.h	(revision 912)
>> @@ -0,0 +1,19 @@
>> +#ifndef __LINUX_SPI_XILINX_SPI_H
>> +#define __LINUX_SPI_XILINX_SPI_H
>> +
>> +#define XILINX_SPI_MODEL_DS464 0
>> +#define XILINX_SPI_MODEL_DS570 1
>> +
>> +/* SPI Controller IP */
>> +struct xspi_platform_data {
>> +	s16 bus_num;
> 
> Not needed on the platform_bus; pdev->id suffices.
> This is specific to the OF glue, yes?

Good point, it can be removed, and pdev->id used instead.


>> +	u16 num_chipselect;
>> +	u8 model;
>> +	u8 bits_per_word;
> 
> Synthesis data that's not explicitly visible in
> the IP registers, I guess.

Exactly, its built into the IP and can not be read.


>> +	/* devices to add to the bus when the host is up */
>> +	struct spi_board_info *devices;
>> +	u8 num_devices;
> 
> This is duplicating functionality in the SPI core code.
> That's not really the way to fly.

I have discussed the same problem in the I2C list.

We have a PCIe device which is a MFD (multifunction device).

Several MFD devices could be connected to a standard PC ->
we don't know the bus numbers in advance, and there could be
several PCIe devices connected. Which mean the we can not use
spi_register_board_info.

We can not call spi_add_device from the MFD because when it's
probed the drivers for the SPI bus might not be available.

So the solution in the I2C case was to add this into the driver
and if this tend to be a generic problem some generic solution might
be implemented.

So I would like to have the same thing in here.

--Richard
