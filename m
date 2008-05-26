Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbYEZL6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbYEZL6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 07:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbYEZL62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 07:58:28 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:11895 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754625AbYEZL62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 07:58:28 -0400
Date: Mon, 26 May 2008 15:58:26 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>, linuxppc-dev@ozlabs.org,
       Gary Jennejohn <garyj@denx.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] mmc: add OpenFirmware bindings for the mmc_spi
	driver
Message-ID: <20080526115826.GB26288@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080523182754.GA26891@polina.dev.rtsoft.ru> <20080523182842.GB469@polina.dev.rtsoft.ru> <20080524123527.04794974.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080524123527.04794974.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 12:35:27PM +1000, Stephen Rothwell wrote:
> Hi Anton,
> 
> On Fri, 23 May 2008 22:28:42 +0400 Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> >
> > +++ b/drivers/mmc/host/of_mmc_spi.c
> 
> > +static int of_mmc_spi_probe(struct spi_device *spi)
> 
> > +	/*
> > +	 * mmc_spi_probe will use drvdata, so we can't use it. Use node's
> > +	 * data instead.
> > +	 */
> > +	spi->dev.archdata.of_node->data = oms;
> 
> If you delay this assignment, you may not have to clean it up in the
> error path.

No, if I delay it I'll have to clean it up anyway, just a bit later
(after mmc_spi_probe() fail).

> > +	ocr_mask = of_get_property(np, "linux,mmc-ocr-mask", &size);
> 
> You should really explicitly include linux/of.h to use of_get_property etc

Thanks, will do.

> > +int __devexit of_mmc_spi_remove(struct spi_device *spi)
> > +{
> > +	struct of_mmc_spi *oms = spi->dev.archdata.of_node->data;
> > +	int ret;
> > +
> > +	ret = mmc_spi_remove(spi);
> > +	if (ret)
> > +		return ret;
> 
> Maybe you should do this last so that you don't leak more than necessary
> if mmc_spi_remove fails. (I don't know what state mmc_spi_remove leaves
> stuff in if it fails ...)

If I do this last, then of_mmc_spi_remove() would be not safe to call
multiple times on non-fatal errors (e.g. when mmc_spi_remove() returns
-EBUSY (despite that currently mmc_spi_remove can't fail)).

Also, if I do this last, then there will be a potential use-after-free
in the mmc_spi driver.

> > +static struct spi_driver of_mmc_spi_driver = {
> > +	.driver = {
> > +		.name = "of_mmc_spi",
> > +		.bus = &spi_bus_type,
> 
> This is initialised by spi_register_driver().

This was straight copy from the mmc_spi.c. Will fix.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
