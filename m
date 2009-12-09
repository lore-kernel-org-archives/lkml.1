Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbZLIR4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbZLIR4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 12:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZLIR4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 12:56:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52004 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbZLIR4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 12:56:09 -0500
Date: Wed, 9 Dec 2009 18:55:53 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, daniel@caiaq.de,
       dbrownell@users.sourceforge.net, s.hauer@pengutronix.de,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: + spi-imx-correct-check-for-platform_get_irq-failing.patch
	added to -mm tree
Message-ID: <20091209175553.GA25451@pengutronix.de>
References: <200912082330.nB8NU4IO016215@imap1.linux-foundation.org> <fa686aa40912081638m734e97c3r2c3f412898d293b@mail.gmail.com> <20091209074533.GB8136@pengutronix.de> <fa686aa40912090708g45879802l6cea7b401b1434e3@mail.gmail.com> <20091209153241.GB1389@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091209153241.GB1389@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 04:32:41PM +0100, Uwe Kleine-König wrote:
> On Wed, Dec 09, 2009 at 08:08:19AM -0700, Grant Likely wrote:
> > (resend because I forgot to cc the mailing list)
> > 
> > 2009/12/9 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> > > Hello Grant,
> > >
> > > On Tue, Dec 08, 2009 at 05:38:57PM -0700, Grant Likely wrote:
> > >> > diff -puN drivers/spi/spi_imx.c~spi-imx-correct-check-for-platform_get_irq-failing drivers/spi/spi_imx.c
> > >> > --- a/drivers/spi/spi_imx.c~spi-imx-correct-check-for-platform_get_irq-failing
> > >> > +++ a/drivers/spi/spi_imx.c
> > >> > @@ -554,7 +554,7 @@ static int __init spi_imx_probe(struct p
> > >> >        }
> > >> >
> > >> >        spi_imx->irq = platform_get_irq(pdev, 0);
> > >> > -       if (!spi_imx->irq) {
> > >> > +       if (spi_imx->irq < 0) {
> > >>
> > >> This changes the old behaviour.  Is that what you intended?  '<= 0' perhaps?
> > > Yes, the old check was wrong.  What if the irq to use is 0?  I thought
> > > the commit log to be understandable.  platform_get_irq returns -ENXIO on
> > > error and an irq number on success.  So 0 has to be interpreted as valid
> > > irq, not an error.
> > 
> > 0 is not a valid IRQ
> Hmm, on my x86 I have:
> 
> 	$ grep '\<0:' /proc/interrupts 
> 	   0:      24330   IO-APIC-edge      timer
> 
> arm/davinci starts at 0, too.  As does arm/ns9xxx.  arm/pxa seems to
> start at 1.  realview starts at 1, too.  So four out of five make are
> wrong?  Seems like a big area for cleanup.
I've read a bit and I think the best for a driver writer (i.e. the role
I have when changing drivers/spi/spi_imx.c) is to accept what
platform_get_irq returns to me.  If the platform specified 

	struct resource mydevicesresources[] = {
		...
		{
			.start = 0,
			.end = 0,
			.flags = IORESOURCE_IRQ,
		},
		...
	};

then the best thing to do is to take irq0, isn't it.  So as
platform_get_irq is implemented as

	int platform_get_irq(struct platform_device *dev, unsigned int num)
	{
	        struct resource *r = platform_get_resource(dev, IORESOURCE_IRQ, num);

        	return r ? r->start : -ENXIO;
	}

testing for <0 seems right to me.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
