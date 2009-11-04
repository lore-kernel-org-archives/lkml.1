Return-Path: <linux-kernel-owner+w=401wt.eu-S1758337AbZKDW3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337AbZKDW3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 17:29:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758328AbZKDW3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 17:29:08 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40604 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758325AbZKDW3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 17:29:07 -0500
Date: Wed, 4 Nov 2009 23:28:39 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] mfd/mc13783: near complete rewrite
Message-ID: <20091104222839.GA15988@pengutronix.de>
References: <1257195385-15595-1-git-send-email-u.kleine-koenig@pengutronix.de> <1257276673-30518-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091104183507.GH3607@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091104183507.GH3607@sortiz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Samuel,

On Wed, Nov 04, 2009 at 07:35:08PM +0100, Samuel Ortiz wrote:
> > - * Copyright 2009 Pengutronix, Sascha Hauer <s.hauer@pengutronix.de>
> Even though this looks like a major rewrite, I still think it's unfair to
> remove Sascha from there.
OK.
 
> > +void mc13783_lock(struct mc13783 *mc13783)
> > +{
> > +	if (!mutex_trylock(&mc13783->lock)) {
> > +		dev_dbg(&mc13783->spidev->dev, "wait for %s from %pf\n",
> > +			__func__, __builtin_return_address(0));
> > +
> > +		mutex_lock(&mc13783->lock);
> That is just for debugging purposes, right ?
Yes, the intention is to see lock contentions.  I thought about making
this

	#if defined(DEBUG)
		if (!mutex_trylock(&mc13783->lock)) {
			...
		}
		dev_dbg(...)
	#else
		mutex_lock(...);
	#endif

but it didn't feel right to have a different locking scheme depending on
DEBUG or not.  Does your question imply that I should change something
here?

> > +static int mc13783_prep_read_transfer(struct mc13783 *mc13783,
> > +		struct spi_transfer *t, u32 *buf,
> > +		unsigned int offset, u32 *val
> What is val used for in that function ?
It's there for symmetry with mc13783_eval_read_transfer.

> )
> > +{
> > +	if (offset > MC13783_NUMREGS)
> >  		return -EINVAL;
> > -	return len - m.actual_length;
> > +
> > +	buf[0] = offset << 25;
> Could we have a define for that 25 ?
Yes, will do.
 
> > +	memset(t, 0, sizeof(*t));
> > +
> > +	t->tx_buf = buf;
> > +	t->rx_buf = buf;
> > +	t->len = sizeof(u32);
> > +
> > +	return 1;
> >  }
> >  
> > -static int mc13783_read(struct mc13783 *mc13783, int reg_num, u32 *reg_val)
> > +static int mc13783_eval_read_transfer(struct mc13783 *mc13783,
> > +		struct spi_transfer *t, u32 *buf,
> > +		unsigned int offset, u32 *val)
> >  {
> > -	unsigned int frame = 0;
> > -	int ret = 0;
> > +	BUG_ON(t->tx_buf != buf || t->rx_buf != buf);
> your SPI read will be on t->rx_buf. I could understand that you want to check
> for t->rx_buf not being NULL (although a BUG_ON() seems too much here), but
> checking for t->rx_buf pointing to buf really looks akward to me.
The intention here is to assert that mc13783_eval_read_transfer is
called for a transfer prepared by mc13783_prep_read_transfer.  As this
sets up t->tx_buf = t->rx_buf = buf, it seems to be the right assertion.

> why not:
> 
> BUG_ON(t->rx_buf == NULL)
> 
> *val = *((u32 *)t->rx_buf) & 0xffffff;
> 
> > -static int mc13783_write(struct mc13783 *mc13783, int reg_num, u32 reg_val)
> > +static int mc13783_eval_write_transfer(struct mc13783 *mc13783,
> > +		struct spi_transfer *t, u32 *buf,
> > +		unsigned int offset, u32 val)
> >  {
> > -	unsigned int frame = 0;
> > +	BUG_ON(t->tx_buf != buf || t->rx_buf != buf);
> >  
> > -	if (reg_num > MC13783_MAX_REG_NUM)
> > -		return -EINVAL;
> > +	return 1;
> > +}
> I dont get the point of mc13783_eval_write_transfer().
The idea here is that I could setup, send and receive multi-transfer
messages with a single buffer array.  Then the return value would tell me how
much to advance in the buffer for the next result.  Maybe that's just
paranoid over-engineering.

> > +int mc13783_reg_read(struct mc13783 *mc13783, unsigned int offset, u32 *val)
> > +{
> > +	u32 buf;
> > +	struct spi_transfer t;
> > +	struct spi_message m;
> > +	int ret;
> > +
> > +	BUG_ON(!mutex_is_locked(&mc13783->lock));
> > +
> > +	ret = mc13783_prep_read_transfer(mc13783, &t, &buf, offset, val);
> Do you really need buf here ?
> I think mc13783_prep_read_transfer(mc13783, &t, val, offset); should be
> enough.
Yes, should work.
 
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	spi_message_init(&m);
> > +	spi_message_add_tail(&t, &m);
> > +
> > +	ret = spi_sync(mc13783->spidev, &m);
> >  
> > -	frame |= (1 << MC13783_WRITE_BIT_SHIFT);
> > -	frame |= reg_num << MC13783_REG_NUM_SHIFT;
> > -	frame |= reg_val & MC13783_FRAME_MASK;
> > +	/* error in message.status implies error return from spi_sync */
> > +	BUG_ON(!ret && m.status);
> So, you really want to crash your board because of an SPI inconsistency ?
> Seems like an overkill to me.
This only bugs if spi_sync succeeds even though the message wasn't
transfered correctly.  Sascha's driver had:

	if (spi_sync(spi, &m) != 0 || m.status != 0)
		return -EINVAL;

If I understand spi_sync correctly m.status != 0 implies spi_sync
returning != 0, so the above should be equivalent to:

	if (spi_sync(spi, &m) != 0)
		return -EINVAL;

So my BUG_ON is only for the case that Sascha saw something I missed.
 
> > +	ret = mc13783_eval_write_transfer(mc13783, &t, &buf, offset, val);
> Again, I dont see the point of this function.
Do you insist on fixing that?  It might look a bit strange (which is
subjective) but I don't see much benefit in changing it because I expect
the compiler to produce similar code.  Currently all
mc13783_{prep,eval}_{read,write}_transfer calls are inlined by my
compiler anyhow.

Best regards and thanks for your comments,
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
