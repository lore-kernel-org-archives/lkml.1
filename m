Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbZBSWDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbZBSWDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 17:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbZBSWCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 17:02:55 -0500
Received: from relais.videotron.ca ([24.201.245.36]:34072 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbZBSWCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 17:02:54 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Thu, 19 Feb 2009 17:02:32 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Andrew Morton <akpm@linux-foundation.org>
Cc: drzeus-mmc@drzeus.cx, lkml <linux-kernel@vger.kernel.org>,
       Maen Suleiman <maen@marvell.com>
Subject: Re: [PATCH] SDIO driver for Marvell SoCs
In-reply-to: <20090219124418.dfc4dc9a.akpm@linux-foundation.org>
Message-id: <alpine.LFD.2.00.0902191625120.5511@xanadu.home>
References: <alpine.LFD.2.00.0902172338110.32550@xanadu.home>
 <20090219124418.dfc4dc9a.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Feb 2009, Andrew Morton wrote:

> On Tue, 17 Feb 2009 23:46:21 -0500 (EST)
> Nicolas Pitre <nico@cam.org> wrote:
> 
> > From: Maen Suleiman <maen@marvell.com>
> > 
> > This supports MMC/SD/SDIO currently found on the Kirkwood 88F6281 and
> > 88F6192 SoC controllers.
> > 
> > Signed-off-by: Nicolas Pitre <nico@marvell.com>
> 
> It would be nice to have Maen's signoff.

Sure, I can add it if this is Maen's wish.  Still, this single signoff 
was made in conformity with option B of the Developer's Certificate of 
Origin 1.1 as found in Documentation/SubmittingPatches.  It is actually 
my duty at Marvell to act as such.

> >
> > ...
> >
> > +#define mvsd_write(offs, val)	writel(val, iobase + (offs))
> > +#define mvsd_read(offs)		readl(iobase + (offs))
> 
> It's rather grotty to have a macro which secretly relies upon the
> presence of a particularly-named local variable.

My call.  Otherwise the code becomes bloated with repeated iobase noise 
everywhere, making many lines bust the 80 column limit imposed by the 
checkpatch.pl.  The alternative is to split those statement on multiple 
lines making things not prettier.  So, unless you want to help 
maintaining this driver, I prefer this grottiness to remains as is.

> > +static int __init mvsd_probe(struct platform_device *pdev)
> > +{
> > +	struct mmc_host *mmc = NULL;
> > +	struct mvsd_host *host = NULL;
> > +	const struct mvsdio_platform_data *mvsd_data;
> > +	struct resource *r;
> > +	int ret, irq;
> > +
> > +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	irq = platform_get_irq(pdev, 0);
> > +	mvsd_data = pdev->dev.platform_data;
> > +	if (!r || irq < 0 || !mvsd_data)
> > +		return -ENXIO;
> > +
> > +	r = request_mem_region(r->start, SZ_1K, DRIVER_NAME);
> > +	if (!r)
> > +		return -EBUSY;
> > +
> > +	mmc = mmc_alloc_host(sizeof(struct mvsd_host), &pdev->dev);
> > +	if (!mmc) {
> > +		ret = -ENOMEM;
> > +		goto out;
> 
> Resource `r' is leaked here.

Good catch, thanks.

> > +static int __exit mvsd_remove(struct platform_device *pdev)
> > +{
> > +	struct mmc_host *mmc = platform_get_drvdata(pdev);
> > +
> > +	if (mmc) {
> > +		struct mvsd_host *host = mmc_priv(mmc);
> > +
> > +		if (host->gpio_card_detect) {
> > +			free_irq(gpio_to_irq(host->gpio_card_detect), host);
> > +			gpio_free(host->gpio_card_detect);
> > +		}
> > +		mmc_remove_host(mmc);
> > +		free_irq(host->irq, host);
> > +		if (host->gpio_write_protect)
> > +			gpio_free(host->gpio_write_protect);
> > +		del_timer_sync(&host->timer);
> > +		mvsd_power_down(host);
> > +		iounmap(host->base);
> > +		release_resource(host->res);
> > +		mmc_free_host(mmc);
> 
> Perhaps this function and the error path ("out:") in the preceding
> function could share code.

Well, one is marked __init and the other __exit.  Having common code 
would mean this needs to be in a non discardable section which is a 
waste.


Nicolas
