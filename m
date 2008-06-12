Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbYFLHQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbYFLHQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 03:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbYFLHPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 03:15:53 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:22000 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753575AbYFLHPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 03:15:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aSgtpqxysVKTgE8cUM9xOEyobdm6cEs74ZzZKOvdEFV3OblZYsvGU05gIC8sdEeTRmL8Gz1w+FmJNN7cQeXsNBcRVKCOkflpoYSyrZ/F0+BfTkwiVyWpGbqjmUoL6j6FTjN6dXIJG1VoW3mQB1LrOao3h/NUceJZXzVBGFT/rA4=  ;
X-YMail-OSG: 2YKY43gVM1kCfR53mj0W6cG7b3QvMXyrui4JdOL37v8oWJEMr9Qb6J7vz_.VYq1eMpC8ZmRRsEdajzdjm9ptp9ItN1GZZThkpu0k2jC5TiWLNQJADg0bnXBNmWxLC.oNoi0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Subject: Re: [PATCH] gpio: gpio driver for max7301 SPI GPIO expander
Date: Thu, 12 Jun 2008 00:15:50 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
References: <Pine.LNX.4.64.0806061625260.3338@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0806061625260.3338@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200806120015.50953.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some comments about one routine; presumably more to follow:


On Friday 06 June 2008, Guennadi Liakhovetski wrote:
> +/**
> + * max7301_read - Read back register content
> + * @spi: The SPI device
> + * @reg: Register offset
> + *
> + * A read from the MAX7301 means one message with two transfers

That's not what you implement though ... what it needs is:

	- transfer #1:
		* select
		* write 16 bit command, discard rx data
		* deselect
	- transfer #2
		* select
		* write 16 bit command, saving rx data
		* deselect

That's from the data sheet.  Now, that *could* be implemented
with a single message ... or, as you do, with two messages.

You should at least correct the comment, if you don't want to
switch to a slightly faster single-message implementation.  :)


> + *
> + * Returns positive 8 bit value from device if successfull or a
> + * negative value on error

Actually it returns a 16 bit value... also, "successful" has one "l".
You seem to have forgotten to mask off the high byte ...


> + */
> +static int max7301_read(struct spi_device *spi, unsigned int reg)
> +{
> +       int ret;
> +       u16 word;
> +
> +       word = 0x8000 | (reg << 8);
> +       if ((ret = spi_write(spi, (const u8*)&word, siz

> eof(word))) != 0) 
> +               return ret;
> +       /*
> +        * FIXME: This read should write 0x0000 (=NOOP at MAX7301 side)

Take out this FIXME, and just replace it with a note that this relies
on the fact that TX always shifts out zeroes if there's no data specified.

> +        */
> +       if ((ret = spi_read(spi, (u8*)&word, sizeof(word))))
> +               return ret;
> +       return word;
> +}
> +


Oh, and in the probe():

> +       spi->master->setup(spi);

should be

	ret = spi_setup(spi);
	if (ret < 0)
		return ret;

It's quite possible that something get misconfigured, so you end up trying
to talk through a spi_master controller that doesn't support 16-bit words.

- Dave

