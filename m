Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbYGDESr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbYGDESr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 00:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbYGDESi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 00:18:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:1554 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbYGDESh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 00:18:37 -0400
Date: Thu, 3 Jul 2008 22:17:58 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Chen Gong <G.Chen@freescale.com>
Cc: david-b@pacbell.net, fabrizio.garetto@gmail.com, linuxppc-dev@ozlabs.org,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/5] spi: Add OF binding support for SPI busses
Message-ID: <20080704041758.GH12945@secretlab.ca>
References: <20080703005749.26187.71719.stgit@trillian.secretlab.ca> <20080703010313.26187.99119.stgit@trillian.secretlab.ca> <58A20A281BAF1047B4EAE68DE5C0BDC2010121B7@zch01exm21.fsl.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58A20A281BAF1047B4EAE68DE5C0BDC2010121B7@zch01exm21.fsl.freescale.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 11:54:57AM +0800, Chen Gong wrote:
> Grant Likely wrote:
> > +		/* Mode (clock phase/polarity/etc.) */
> > +		if (of_find_property(nc, "spi,cpha", NULL))
> > +			spi->mode |= SPI_CPHA;
> > +		if (of_find_property(nc, "spi,cpol", NULL))
> > +			spi->mode |= SPI_CPOL;
> 
> so becuase in function spi_alloc_deive, spi is allocated by kzalloc,
> how about writing as follows:
> 		/* Mode (clock phase/polarity/etc.) */
> 		prop = of_get_property(nc, "spi,cpha", NULL))
>                         if (prop)
> 			spi->mode |= *prop;
> 		prop = of_get_property(nc, "spi,cpol", NULL))
>                         if (prop)
> 			spi->mode |= *prop;

spi,cpha and spi,cpol are defined as empty properties.  The presence of
the property in the node means I need to set the flag in the spi_device.

> > +		/* Select device driver */
> > +		sprop = of_get_property(nc, "linux,modalias", &len);
> > +		if (sprop && len > 0)
> > +			strncpy(spi->modalias, sprop, KOBJ_NAME_LEN);
> > +		else
> > +			strncpy(spi->modalias, "spidev", KOBJ_NAME_LEN);
> > +
>  how about writing as follows:
> 
> 		if (sprop && len > 0)
> 			strncpy(spi->modalias, sprop, KOBJ_NAME_LEN -
> 1);
> 		else
> 			strncpy(spi->modalias, "spidev", KOBJ_NAME_LEN -
> 1);

Actually, neither are very good.  What it should really be is:

	if (sprop && len > 0)
		strlcpy(spi->modalias, sprop, sizeof (spi->modalias));
	else
		strlcpy(spi->modalias, "spidev", sizeof (spi->modalias));

This ensures that the string is always null terminated and always the
right size.

... But the whole argument is a bit moot.  The fact that I even defined
a "linux,modalias" property is a great big hairy hack that I would
never want my mother to see.  Instead, I need a method to bind to an SPI
driver based on the compatible list.  Jon Smirl has done some work
in this regard for i2c, but I haven't looked at it very deeply, and so
do not at all understand it (yet).

Thanks for the comments.
g.
