Return-Path: <linux-kernel-owner+w=401wt.eu-S1759000AbZKEW3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000AbZKEW3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 17:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758955AbZKEW3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 17:29:14 -0500
Received: from mga10.intel.com ([192.55.52.92]:46188 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758929AbZKEW3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 17:29:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,688,1249282800"; 
   d="scan'208";a="744283760"
Date: Thu, 5 Nov 2009 23:31:04 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] mfd/mc13783: near complete rewrite
Message-ID: <20091105223103.GB22366@sortiz.org>
References: <1257195385-15595-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1257276673-30518-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20091104183507.GH3607@sortiz.org>
 <20091104222839.GA15988@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091104222839.GA15988@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Wed, Nov 04, 2009 at 11:28:39PM +0100, Uwe Kleine-König wrote:
> > > +void mc13783_lock(struct mc13783 *mc13783)
> > > +{
> > > +	if (!mutex_trylock(&mc13783->lock)) {
> > > +		dev_dbg(&mc13783->spidev->dev, "wait for %s from %pf\n",
> > > +			__func__, __builtin_return_address(0));
> > > +
> > > +		mutex_lock(&mc13783->lock);
> > That is just for debugging purposes, right ?
> Yes, the intention is to see lock contentions.  I thought about making
> this
> 
> 	#if defined(DEBUG)
> 		if (!mutex_trylock(&mc13783->lock)) {
> 			...
> 		}
> 		dev_dbg(...)
> 	#else
> 		mutex_lock(...);
> 	#endif
> 
> but it didn't feel right to have a different locking scheme depending on
> DEBUG or not.  Does your question imply that I should change something
> here?
No, I was just curious. This is much nicer than the ifdef DEBUG solution,
definitely.

 
> > > +static int mc13783_prep_read_transfer(struct mc13783 *mc13783,
> > > +		struct spi_transfer *t, u32 *buf,
> > > +		unsigned int offset, u32 *val
> > What is val used for in that function ?
> It's there for symmetry with mc13783_eval_read_transfer.
> 
> > )
> > > +{
> > > +	if (offset > MC13783_NUMREGS)
> > >  		return -EINVAL;
> > > -	return len - m.actual_length;
> > > +
> > > +	buf[0] = offset << 25;
> > Could we have a define for that 25 ?
> Yes, will do.
>  
> > > +	memset(t, 0, sizeof(*t));
> > > +
> > > +	t->tx_buf = buf;
> > > +	t->rx_buf = buf;
> > > +	t->len = sizeof(u32);
> > > +
> > > +	return 1;
> > >  }
> > >  
> > > -static int mc13783_read(struct mc13783 *mc13783, int reg_num, u32 *reg_val)
> > > +static int mc13783_eval_read_transfer(struct mc13783 *mc13783,
> > > +		struct spi_transfer *t, u32 *buf,
> > > +		unsigned int offset, u32 *val)
> > >  {
> > > -	unsigned int frame = 0;
> > > -	int ret = 0;
> > > +	BUG_ON(t->tx_buf != buf || t->rx_buf != buf);
> > your SPI read will be on t->rx_buf. I could understand that you want to check
> > for t->rx_buf not being NULL (although a BUG_ON() seems too much here), but
> > checking for t->rx_buf pointing to buf really looks akward to me.
> The intention here is to assert that mc13783_eval_read_transfer is
> called for a transfer prepared by mc13783_prep_read_transfer.  As this
> sets up t->tx_buf = t->rx_buf = buf, it seems to be the right assertion.
It is the right assertion. I'm just saying that this looks quite paranoid to
me: you're running those checks from a non exported function, that is only
called once in your code, from a routine where you specifically set tx_buf and
rx_buf properly. I think it makes the code more complicated to read and follow
than what is should.

 
> > why not:
> > 
> > BUG_ON(t->rx_buf == NULL)
> > 
> > *val = *((u32 *)t->rx_buf) & 0xffffff;
> > 
> > > -static int mc13783_write(struct mc13783 *mc13783, int reg_num, u32 reg_val)
> > > +static int mc13783_eval_write_transfer(struct mc13783 *mc13783,
> > > +		struct spi_transfer *t, u32 *buf,
> > > +		unsigned int offset, u32 val)
> > >  {
> > > -	unsigned int frame = 0;
> > > +	BUG_ON(t->tx_buf != buf || t->rx_buf != buf);
> > >  
> > > -	if (reg_num > MC13783_MAX_REG_NUM)
> > > -		return -EINVAL;
> > > +	return 1;
> > > +}
> > I dont get the point of mc13783_eval_write_transfer().
> The idea here is that I could setup, send and receive multi-transfer
> messages with a single buffer array.  Then the return value would tell me how
> much to advance in the buffer for the next result.  Maybe that's just
> paranoid over-engineering.
I'm glad we agree :) This routine is just not neede, for the mere fact that it
does nothing. Unless you have bigger plans for this driver, right now you're
doing simple SPI register reads and writes, afaict.

> > > +	/* error in message.status implies error return from spi_sync */
> > > +	BUG_ON(!ret && m.status);
> > So, you really want to crash your board because of an SPI inconsistency ?
> > Seems like an overkill to me.
> This only bugs if spi_sync succeeds even though the message wasn't
> transfered correctly.  Sascha's driver had:
> 
> 	if (spi_sync(spi, &m) != 0 || m.status != 0)
> 		return -EINVAL;
> 
> If I understand spi_sync correctly m.status != 0 implies spi_sync
> returning != 0, so the above should be equivalent to:
> 
> 	if (spi_sync(spi, &m) != 0)
> 		return -EINVAL;
> 
> So my BUG_ON is only for the case that Sascha saw something I missed.
Oh, dont get me wrong: I'm not saying the check is bogus, I'm just saying that
I would just have a WARN_ON() here. I wouldnt be happy if my board would crash
because of an SPI read error.

  
> > > +	ret = mc13783_eval_write_transfer(mc13783, &t, &buf, offset, val);
> > Again, I dont see the point of this function.
> Do you insist on fixing that?  It might look a bit strange (which is
> subjective) but I don't see much benefit in changing it because I expect
> the compiler to produce similar code.  Currently all
> mc13783_{prep,eval}_{read,write}_transfer calls are inlined by my
> compiler anyhow.
The only one I'd like to be removed is mc13783_eval_write_transfer(). It might
look a bit strange, but it looks even stranger to me when I see a routine
that basically does nothing but returning 1.


> Best regards and thanks for your comments,
Thanks for your patch, sorry for the late comments.

Cheers,
Samuel.


> Uwe
> 
> -- 
> Pengutronix e.K.                              | Uwe Kleine-König            |
> Industrial Linux Solutions                    | http://www.pengutronix.de/  |

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
