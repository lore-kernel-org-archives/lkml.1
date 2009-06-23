Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbZFWToj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbZFWToj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 15:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbZFWToc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 15:44:32 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:25429 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753998AbZFWToc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:44:32 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jun 2009 15:44:31 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=YHy/rZvowUhb4Mv1aWHRDiY7KIAfZvTNxoJdq8qZCcQFULBGcSNFIglhHSTGtdJQ1pb12Na7SjNZYVGaQpVlcSvW8J4Ji6BQaSPFJB9vqM0ywqEz2Ox3nIXTV8bVJ9kxhkGF0lWJvtm86H0mexd2CjqRnCwb39zexuZA0qjIuIc=  ;
X-YMail-OSG: Qe77QQUVM1niB9L_dhkBX2mSgvBOJh37_yiIoxPTWIwTWIei4QavVLIFYA2DVHTx4qiec_rxALCEuIlk_vRuHI93qPya5sioYCPEVfJ4tjoqBunEQcNBSr5hGoiCeXhK_bj2Lru_TyKYxNKnQBTkPS0R832nsU_32wHstXm1wsA60rswX0PQnbditfU6IsXc9_PyfgM0D74cMSEVuWslvyGHtNiLGkJNNXM59DfYj5Frx9givVG2iTgrw.70b8CYd5SRNRYIEw2XyybKLxWZ_UdE0jhp1OAJ.u_z...6UMbCDvfMZ2cWrPg0_wsnNazDA4miDPWdlj8FBLmyjhZyu8_Z5DYIYQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Richard =?iso-8859-1?q?R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
Subject: Re: [RESEND][PATCH] SPI: xilinx_spi: Added platform driver and support for DS570
Date: Tue, 23 Jun 2009 12:37:54 -0700
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <4A366622.2050606@mocean-labs.com>
In-Reply-To: <4A366622.2050606@mocean-labs.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906231237.54278.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 June 2009, Richard Röjfors wrote:
> This patch splits xilinx_spi into three parts, an OF and a platform
> driver and generic part.
> 
> The generic part now also works on X86 and also supports the Xilinx
> SPI IP DS570

Your Kconfig still mentions only DS464.

Is there any reason the platform driver shouldn't also build on x86?
Surely *any* system should be able to talk to an FPGA which exports
this register interface?


> 
> Signed-off-by: Richard Röjfors <richard.rojfors.ext@mocean-labs.com>

I'll second Andrew's comments.  Also, for my review, it'd be
better to split OF bits out from the rest ... but maybe that's
not practical given the previous xilinx_spi code.  At least
future patches will have a more-sane structure to build on.


> +config SPI_XILINX_OF
> +	tristate "Xilinx SPI controller OF device"
> +	depends on SPI_XILINX && XILINX_VIRTEX
> +	help
> +	  This exposes the SPI controller IP from the Xilinx EDK.

If it's IP, then why is it dependent on VIRTEX?  Surely
the same IP should work on Spartan etc.  I'd think just
depending on something like OF should suffice.


> +
> +	  See the "OPB Serial Peripheral Interface (SPI) (v1.00e)"
> +	  Product Specification document (DS464) for hardware details.
> +
> +config SPI_XILINX_PLTFM
> +	tristate "Xilinx SPI controller platform device"
> +	depends on SPI_XILINX

This should go first in the Kconfig, so that you don't goof up
the dependency display ... the OF bits depend on it.


> --- linux-2.6.30-rc7-spi/drivers/spi/xilinx_spi_of.c	(revision 0)
> +++ linux-2.6.30-rc7-spi/drivers/spi/xilinx_spi_of.c	(revision 912)
> @@ -0,0 +1,123 @@
> 	...

> +
> +/* work with hotplug and coldplug */
> +MODULE_ALIAS("platform:" XILINX_SPI_NAME);

This is clearly inappropriate for a file with an OpenFirmware driver.
For that matter, it's not needed with platform devices any more either;
so take it out of your platform driver code too.


> --- linux-2.6.30-rc7-spi/include/linux/spi/xilinx_spi.h	(revision 0)
> +++ linux-2.6.30-rc7-spi/include/linux/spi/xilinx_spi.h	(revision 912)
> @@ -0,0 +1,19 @@
> +#ifndef __LINUX_SPI_XILINX_SPI_H
> +#define __LINUX_SPI_XILINX_SPI_H
> +
> +#define XILINX_SPI_MODEL_DS464 0
> +#define XILINX_SPI_MODEL_DS570 1
> +
> +/* SPI Controller IP */
> +struct xspi_platform_data {
> +	s16 bus_num;

Not needed on the platform_bus; pdev->id suffices.
This is specific to the OF glue, yes?


> +	u16 num_chipselect;
> +	u8 model;
> +	u8 bits_per_word;

Synthesis data that's not explicitly visible in
the IP registers, I guess.


> +	/* devices to add to the bus when the host is up */
> +	struct spi_board_info *devices;
> +	u8 num_devices;

This is duplicating functionality in the SPI core code.
That's not really the way to fly.  That may also be
specific to the OF glue.


> +};
> +
> +#endif /* __LINUX_SPI_XILINX_SPI_H */
> +
> 
> 


