Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbYGOM7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbYGOM7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbYGOM7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:59:13 -0400
Received: from bu3sch.de ([62.75.166.246]:49074 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbYGOM7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:59:12 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add dynamic MMC-over-SPI-GPIO driver
Date: Tue, 15 Jul 2008 14:58:40 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, david-b@pacbell.net,
       piotr.skamruk@gmail.com, drzeus-mmc@drzeus.cx,
       openwrt-devel@lists.openwrt.org
References: <200807142109.19360.mb@bu3sch.de> <20080714135441.e3ef9b0b.akpm@linux-foundation.org>
In-Reply-To: <20080714135441.e3ef9b0b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807151458.41007.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 July 2008 22:54:41 Andrew Morton wrote:
> > +static int gpiommc_probe(struct platform_device *pdev)
> > +{
> > +	static int instance;
> > +	struct gpiommc_device *d = platform_get_drvdata(pdev);
> > +	struct spi_gpio_platform_data pdata;
> > +	int err = -ENOMEM;
> > +
> > +	d->spi_pdev = platform_device_alloc("spi-gpio", instance++);
> > +	if (!d->spi_pdev)
> > +		goto out;
> 
> I guess that incrementing `instance' even if the allocation failed is
> somewhat wrong.

Well, I guess it doesn't matter much. The number is pretty random anyway.

> > +static struct gpiommc_device *gpiommc_alloc(struct platform_device *pdev,
> > +					    const char *name,
> > +					    const struct gpiommc_pins *pins,
> > +					    u8 mode)
> > +{
> > +	struct gpiommc_device *d;
> > +
> > +	d = kmalloc(sizeof(*d), GFP_KERNEL);
> > +	if (!d)
> > +		return NULL;
> > +
> > +	strcpy(d->name, name);
> 
> No check for overruns?

The caller checks the length, but it is a good idea to double-check here.
Good catch.

> > +	memcpy(&d->pins, pins, sizeof(d->pins));
> 
> If this had used the typesafe
> 
> 	d->pins = *pins;
> 
> I wouldn't have needed to run all around the place working out if
> overflow/underflow checks were needed here.

Yeah well, can use this.

> > +static ssize_t gpiommc_add_store(struct device_driver *drv,
> > +				 const char *buf, size_t count)
> > +{
> > +	int res, err;
> > +	char name[GPIOMMC_MAX_NAMELEN + 1];
> > +	struct gpiommc_pins pins;
> > +	unsigned int mode;
> > +
> > +	res = sscanf(buf, "%" GPIOMMC_MAX_NAMELEN_STR "s %u,%u,%u,%u %u",
> > +		     name, &pins.gpio_di, &pins.gpio_do,
> > +		     &pins.gpio_clk, &pins.gpio_cs, &mode);
> 
> What's going on here?  So new kernel/userspace ABI.

The whole point of the module is to create a new userspace interface for
creating the device. The module does just glue several modules together
and create an actual device.

> Not documented in 
> changelog, not documented in code comments, not documented in
> Documentation/ABI.  This forces reviewers to reverse-engineer the
> interface design from the implementation and then attempt to review
> that design.  Reviewers not happy!

Yeah well, as I said, I will do docs later. I didn't have any time
to write documentation, yet.
by. ;)

> > +static ssize_t gpiommc_remove_show(struct device_driver *drv,
> > +				   char *buf)
> > +{
> > +	return snprintf(buf, PAGE_SIZE, "write device-name to remove the device\n");
> > +}
> 
> Now that is one weird way in which to document the interface!  What a
> waste of kernel text :(

Yeah, well. Better than nothing ;)
As I already said in the original patch announcement. This is by no way the
final version of the patch. Docs will be moved to Documentation/

-- 
Greetings Michael.
