Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbYEZLt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbYEZLt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 07:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbYEZLtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 07:49:18 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:11813 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754313AbYEZLtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 07:49:17 -0400
Date: Mon, 26 May 2008 15:49:15 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Gary Jennejohn <garyj@denx.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org,
       Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [RFC PATCH 2/2] mmc: add OpenFirmware bindings for the mmc_spi
	driver
Message-ID: <20080526114914.GA26288@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080523182754.GA26891@polina.dev.rtsoft.ru> <20080523182842.GB469@polina.dev.rtsoft.ru> <fa686aa40805232219x7e888d80y394958f1c0a0fad0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <fa686aa40805232219x7e888d80y394958f1c0a0fad0@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 11:19:28PM -0600, Grant Likely wrote:
> Yup, I like this approach better.  I had been thinking about putting
> this all in the same file (drivers/mmc/host/mmc_spi.c) instead of
> exporting the probe/remove symbols and by using clear comment blocks
> to divide the sections, but I've got no issues with this approach.
> 
> This is good work.  Some comments below.  (I won't repeat Stephen's comments)

Thanks!

> On Fri, May 23, 2008 at 12:28 PM, Anton Vorontsov
> <avorontsov@ru.mvista.com> wrote:
> > This patch depends on the Grant Likely's SPI patches, so this is
> > for RFC only.
> >
> > Also, later we'll able to remove OF_GPIO dependency.
> >
> > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> > ---
> >  Documentation/powerpc/booting-without-of.txt |   24 ++++
> >  drivers/mmc/host/Kconfig                     |    7 ++
> >  drivers/mmc/host/Makefile                    |    2 +-
> >  drivers/mmc/host/of_mmc_spi.c                |  151 ++++++++++++++++++++++++++
> >  4 files changed, 183 insertions(+), 1 deletions(-)
> >  create mode 100644 drivers/mmc/host/of_mmc_spi.c
> >
> > diff --git a/Documentation/powerpc/booting-without-of.txt b/Documentation/powerpc/booting-without-of.txt
> > index 423cb2b..7d0ef80 100644
> > --- a/Documentation/powerpc/booting-without-of.txt
> > +++ b/Documentation/powerpc/booting-without-of.txt
> > @@ -3151,7 +3151,31 @@ platforms are moved over to use the flattened-device-tree model.
> >                        };
> >                };
> >
> > +    ...) MMC-over-SPI
> >
> > +      Required properties:
> > +      - #address-cells : should be 0.
> > +      - #size-cells : should be 0.
> 
> Are these properties required at all?  Will this node have any children.

Yeah, my weakness for #a/#s, I always insert it where unnecessary. :-)
Will fix.

> > +      - compatible : should be "linux,mmc-spi".
> > +      - linux,modalias  - should be "of_mmc_spi".
> 
> I'm not even sure if the whole linux,modalias is even a good idea.  I
> had kind of thrown it in there as a convenient way to override
> compatible when needed, but I haven't really thought it out very well
> and I think it is rather a hack.
> 
> The real problem is we don't yet have good method (or place) to apply
> a translation table from compatible values to modaliases.  Ideally,
> the translations should be part of the drivers themselves, but that
> causes a chicken and egg problem of needing to load the driver to get
> access to the table to know if it is the correct driver... Of course,
> I'm really not very familiar with the whole module autoloading
> mechanism.  Regardless; binding should be based on compatible, not on
> a hacky and bogus linux,modalias property.

I fully agree. Though, I just tried to use your spi_of with a belief
that you'll implement compatible->modalias translation in spi_of. :-)

> > +      - reg : should specify SPI address (chip-select number).
> > +      - max-speed : (optional) maximum frequency for this device (Hz).
> > +      - linux,mmc-ocr-mask : (optional) Linux-specific MMC OCR mask
> > +        (slot voltage).
> 
> Should this property be better defined?

Yes, will do. Was a bit lazy to do this for the RFC.

[...]
> > +static int mmc_get_cd(struct device *dev)
> > +{
> > +       struct of_mmc_spi *oms = dev->archdata.of_node->data;
> > +
> > +       return gpio_get_value(oms->cd_gpio);
> > +}
> > +
> > +static int of_mmc_spi_probe(struct spi_device *spi)
> > +{
> > +       int ret = -EINVAL;
> > +       struct device_node *np = spi->dev.archdata.of_node;
> > +       struct device *dev = &spi->dev;
> > +       struct of_mmc_spi *oms = kzalloc(sizeof(*oms), GFP_KERNEL);
> > +       const u32 *ocr_mask;
> > +       int size;
> > +
> > +       if (!oms)
> > +               return -ENOMEM;
> > +
> > +       /* Somebody occupied node's data? */
> > +       WARN_ON(spi->dev.archdata.of_node->data);
> 
> Perhaps bail at this point to avoid corruption?  Would it be better to
> use container_of() instead for getting a pointer back to the private
> structure from the pdata pointer?

Using platform_data with container_of isn't always safe (e.g. for
platform bus we can't use it, this is done so that board's platform_data
definitions could be made __initdata).

David, would you [not] suggest us to use platform_data with
container_of, that is, are there any plans to make SPI core copy
the platform_data instead of passing a pointer directly?

> > +
> > +       /*
> > +        * mmc_spi_probe will use drvdata, so we can't use it. Use node's
> > +        * data instead.
> > +        */
> > +       spi->dev.archdata.of_node->data = oms;
> > +
[...]

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
