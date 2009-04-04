Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbZDDT2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbZDDT2R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 15:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbZDDT17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 15:27:59 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:22694 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753532AbZDDT15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 15:27:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5mB/pfciJbUvLUd373gg2xAAjoN69wsQSp0RZgWsBc4Agcguu8h/+NoEv8HsLJwsZTDwqOo/Rm4U1Aty1Nwl20DiHmQwtYM1PUyGnCK00pP14xR8lnUFIqNN8BD6t3gLNz0P7U/xwaJsn+b+71D28iNb8xVogdgQ448Z9AitvQI=  ;
X-YMail-OSG: r8iK5bUVM1kLXfaFky6rvthSwW8DtR3zu93Zl70_uElZFkxVq5qVrpPohqagHLlFw0xLyIdmOG_uo9yWNNs5z07.6seKMMOv5pglm4rVcYByp6kuep85gdBqrTVIJLVbuNLABzzX8.qwf5iKni.HbKY1xylLkV5Va14xag9ODbpa1Pee0_nDPHi6ux65TW1WvE12Ka3OARVMmOL12ezBBEf6n5EA652VRL6d601L8uM4AuQBjx3CkerxZRMyvTI016HwFjnEF5AqzF2VvjZsMncvxHspBwj_nYWgwSptAE9Ng.37sCwk
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH] spi: Add support for the OpenCores SPI controller.
Date: Sat, 4 Apr 2009 12:27:54 -0700
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <1238054874-28215-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1238054874-28215-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904041227.54687.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm ... Open Hardware, Free Software.  Sounds like a good match!

This driver has some all-too-common failings though:

 (a) doesn't correctly reject invalid device configurations
     in the setup() method

 (b) doesn't correctly reject unsupported per-message options
     in the transfer() method

 (c) the setup() method will trash concurrent transfers, since
     it wrongly assumes there's only one device

There are other minor nits too.


On Thursday 26 March 2009, Thierry Reding wrote:

> +struct spioc {
> +	struct spi_master *master;
> +	struct spioc_info *info;

Nothing in "info" is really needed after probe(); no
point in recording it here.


> static void process_transfers(unsigned long data)

... buggy (by inference), see below


> +static int spioc_setup(struct spi_device *spi)
> +{

Hmm, you seem to have disregarded the Documentation/spi/spi-summary
text describing what this does:

	Unless each SPI slave has its own configuration registers, don't
	change them right away ... otherwise drivers could corrupt I/O
	that's in progress for other SPI devices.

Because:


> +	struct spioc *spioc = spi_master_get_devdata(spi->master);
> +	unsigned long clkdiv = 0x0000ffff;
> +	u32 ctrl = spioc_read(spioc, SPIOC_CTRL);

CTRL is a controller-global register, not a per-chipselect one ...

> +
> +	/* make sure we're not busy */
> +	ctrl &= ~CTRL_BUSY;
> +
> +	if (!spi->bits_per_word)
> +		spi->bits_per_word = 8;
> +
> +	if (spi->mode & SPI_LSB_FIRST)
> +		ctrl |=  CTRL_LSB;
> +	else
> +		ctrl &= ~CTRL_LSB;
> +
> +	/* adapt to clock polarity and phase */
> +	if (spi->mode & SPI_CPOL) {
> +		if (spi->mode & SPI_CPHA) {
> +			ctrl |=  CTRL_TXNEG;
> +			ctrl &= ~CTRL_RXNEG;
> +		} else {
> +			ctrl &= ~CTRL_TXNEG;
> +			ctrl |=  CTRL_RXNEG;
> +		}
> +	} else {
> +		if (spi->mode & SPI_CPHA) {
> +			ctrl &= ~CTRL_TXNEG;
> +			ctrl |=  CTRL_RXNEG;
> +		} else {
> +			ctrl |=  CTRL_TXNEG;
> +			ctrl &= ~CTRL_RXNEG;
> +		}
> +	}

Notice how you're accepting *all* spi->mode bits, instead of
insisting that the only bits set there be ones you support.

Best that you do something along the lines of

/* mask of all SPI options this driver currently handles */
#define MODEBITS (SPI_CPOL|SPI_CPHA|SPI_LSB_FIRST)

	if (spi->mode & ~MODEBITS)
		return -EINVAL;

near the top of this routine.

> +
> +	/* set the clock divider */
> +	if (spi->max_speed_hz)
> +		clkdiv = DIV_ROUND_UP(clk_get_rate(spioc->clk),
> +				2 * spi->max_speed_hz) - 1;
> +
> +	if (clkdiv > 0x0000ffff)
> +		clkdiv = 0x0000ffff;

Shouldn't you just be failing setup() if the slowest clock rate
you support is still too fast for this peripheral?


> +
> +	spioc_write(spioc, SPIOC_DIV, clkdiv);
> +	spioc_write(spioc, SPIOC_CTRL, ctrl);

... here you reprogram parameters in use by the current
transfer.

Probably what you should do instead is compute the values to
be used for those two registers, and save them in a struct
referenced through spi_device.controller_state before you
start any individual transfer.

However, your process_transfers() currently seems to presume
a global setup model; that will need to change.  Minimally
you should set the transfer parameters for the current device.

And it will need to cope with per-transfer overrides for the
word size and bitrate, unless you reject them when messages
get submitted.


> +
> +	/* deassert chip-select */
> +	spioc_chipselect(spioc, NULL);
> +
> +	return 0;
> +}
> +
> +static int spioc_transfer(struct spi_device *spi, struct spi_message *message)
> +{
> +	struct spi_master *master = spi->master;
> +	struct spioc *spioc = spi_master_get_devdata(master);
> +	unsigned long flags;

Here you're accepting all messages, even ones that rely on
mechanisms you don't support.  You should either implement
the per-transfer wordsize, bitrate, and chipselect overrides;
or else scan the transfer list of this message to make sure
that no transfer requires them.

> +
> +	spin_lock_irqsave(&spioc->lock, flags);
> +
> +	list_add_tail(&message->queue, &spioc->queue);
> +	queue_work(spioc->workqueue, &spioc->process_messages);
> +
> +	spin_unlock_irqrestore(&spioc->lock, flags);
> +	return 0;
> +}
> +
> +static void spioc_cleanup(struct spi_device *spi)
> +{

This would be where you should kfree() the struct holding
per-device register settings that your setup() should allocate.

Having such NOP methods should be a sign that something
is wrong...

> +}


> +static int __devinit spioc_probe(struct platform_device *pdev)
> +{
> +	...
> +
> +	res = request_mem_region(res->start, res->end - res->start + 1,
> +			res->name);

I think resource_size(resource) should be used here and in the ioremap
call below.

> +	if (!res) {
> +		dev_err(&pdev->dev, "unable to request memory region\n");
> +		return -ENXIO;
> +	}
> +
> +	mmio = ioremap_nocache(res->start, res->end - res->start + 1);
> +	if (!mmio) {
> +		dev_err(&pdev->dev, "can't remap I/O region\n");
> +		retval = -ENXIO;
> +		goto release;
> +	}
> +	...


> +#ifdef CONFIG_PM
> +static int spioc_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +	return -ENOSYS;
> +}
> +
> +static int spioc_resume(struct platform_device *pdev)
> +{
> +	return -ENOSYS;
> +}

Why are you aborting system suspend transitions instead of
just not supporting PM?  Better IMO to depend on !PM if
this is trying to prevent nasty stuff from happening.


> +
> +struct spioc_info {
> +	s16 bus_num;

Better IMO to just use platform_device.id for this.

> +	u16 num_chipselect;
> +};
> +
> +#endif /* !LINUX_SPI_SPIOC_H */
> +
> 
