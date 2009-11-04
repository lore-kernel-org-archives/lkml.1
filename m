Return-Path: <linux-kernel-owner+w=401wt.eu-S1757819AbZKDSdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbZKDSdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 13:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757738AbZKDSdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 13:33:32 -0500
Received: from mga12.intel.com ([143.182.124.36]:59353 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757727AbZKDSdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 13:33:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,681,1249282800"; 
   d="scan'208";a="207579892"
Date: Wed, 4 Nov 2009 19:35:08 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] mfd/mc13783: near complete rewrite
Message-ID: <20091104183507.GH3607@sortiz.org>
References: <1257195385-15595-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1257276673-30518-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1257276673-30518-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Tue, Nov 03, 2009 at 08:31:13PM +0100, Uwe Kleine-König wrote:
> This fixes several things while still providing the old API:
> 
>  - simplify and fix locking
>  - better error handling
>  - don't ack all irqs making it impossible to detect a reset of the
>    rtc
>  - use a timeout variant to wait for completion of ADC conversion
>  - provide platform-data to regulator subdevice (This allows making
>    struct mc13783 opaque for other drivers after the regulator driver is
>    updated to use its platform_data.)
>  - expose all interrupts
>  - use threaded irq
> 
> After all users in mainline are converted to the new API, some things
> (e.g. mc13783-private.h) can go away.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
> Hello,
> 
> compared to the first submission I squashed in the patch
> 
> 	mfd/mc13783: change type of irq handlers to irq_handler_t
> 
> sent earlier in that thread and fixed a few whitespace issues reported
> by checkpatch.pl.
> 
> I'd be happy if this patch would make it in now.
The patch looks mostly ok, thanks for this work.
I have a few comments though.

> - * Copyright 2009 Pengutronix, Sascha Hauer <s.hauer@pengutronix.de>
Even though this looks like a major rewrite, I still think it's unfair to
remove Sascha from there.


> +void mc13783_lock(struct mc13783 *mc13783)
> +{
> +	if (!mutex_trylock(&mc13783->lock)) {
> +		dev_dbg(&mc13783->spidev->dev, "wait for %s from %pf\n",
> +			__func__, __builtin_return_address(0));
> +
> +		mutex_lock(&mc13783->lock);
That is just for debugging purposes, right ?


> +static int mc13783_prep_read_transfer(struct mc13783 *mc13783,
> +		struct spi_transfer *t, u32 *buf,
> +		unsigned int offset, u32 *val
What is val used for in that function ?

)
> +{
> +	if (offset > MC13783_NUMREGS)
>  		return -EINVAL;
> -	return len - m.actual_length;
> +
> +	buf[0] = offset << 25;
Could we have a define for that 25 ?


> +	memset(t, 0, sizeof(*t));
> +
> +	t->tx_buf = buf;
> +	t->rx_buf = buf;
> +	t->len = sizeof(u32);
> +
> +	return 1;
>  }
>  
> -static int mc13783_read(struct mc13783 *mc13783, int reg_num, u32 *reg_val)
> +static int mc13783_eval_read_transfer(struct mc13783 *mc13783,
> +		struct spi_transfer *t, u32 *buf,
> +		unsigned int offset, u32 *val)
>  {
> -	unsigned int frame = 0;
> -	int ret = 0;
> +	BUG_ON(t->tx_buf != buf || t->rx_buf != buf);
your SPI read will be on t->rx_buf. I could understand that you want to check
for t->rx_buf not being NULL (although a BUG_ON() seems too much here), but
checking for t->rx_buf pointing to buf really looks akward to me.

why not:

BUG_ON(t->rx_buf == NULL)

*val = *((u32 *)t->rx_buf) & 0xffffff;

> -static int mc13783_write(struct mc13783 *mc13783, int reg_num, u32 reg_val)
> +static int mc13783_eval_write_transfer(struct mc13783 *mc13783,
> +		struct spi_transfer *t, u32 *buf,
> +		unsigned int offset, u32 val)
>  {
> -	unsigned int frame = 0;
> +	BUG_ON(t->tx_buf != buf || t->rx_buf != buf);
>  
> -	if (reg_num > MC13783_MAX_REG_NUM)
> -		return -EINVAL;
> +	return 1;
> +}
I dont get the point of mc13783_eval_write_transfer().


> +int mc13783_reg_read(struct mc13783 *mc13783, unsigned int offset, u32 *val)
> +{
> +	u32 buf;
> +	struct spi_transfer t;
> +	struct spi_message m;
> +	int ret;
> +
> +	BUG_ON(!mutex_is_locked(&mc13783->lock));
> +
> +	ret = mc13783_prep_read_transfer(mc13783, &t, &buf, offset, val);
Do you really need buf here ?
I think mc13783_prep_read_transfer(mc13783, &t, val, offset); should be
enough.


> +	if (ret < 0)
> +		return ret;
> +
> +	spi_message_init(&m);
> +	spi_message_add_tail(&t, &m);
> +
> +	ret = spi_sync(mc13783->spidev, &m);
>  
> -	frame |= (1 << MC13783_WRITE_BIT_SHIFT);
> -	frame |= reg_num << MC13783_REG_NUM_SHIFT;
> -	frame |= reg_val & MC13783_FRAME_MASK;
> +	/* error in message.status implies error return from spi_sync */
> +	BUG_ON(!ret && m.status);
So, you really want to crash your board because of an SPI inconsistency ?
Seems like an overkill to me.


> -	return spi_rw(mc13783->spi_device, (u8 *)&frame, 4);
> +	if (ret)
> +		return ret;
> +
> +	ret = mc13783_eval_read_transfer(mc13783, &t, &buf, offset, val);
> +
> +	dev_vdbg(&mc13783->spidev->dev, "[0x%02x] -> 0x%06x\n", offset, *val);
> +
> +	return ret < 0 ? ret : 0;
>  }
> +EXPORT_SYMBOL(mc13783_reg_read);
>  
> -int mc13783_reg_read(struct mc13783 *mc13783, int reg_num, u32 *reg_val)
> +int mc13783_reg_write(struct mc13783 *mc13783, unsigned int offset, u32 val)
>  {
> +	u32 buf;
> +	struct spi_transfer t;
> +	struct spi_message m;
>  	int ret;
>  
> -	mutex_lock(&mc13783->io_lock);
> -	ret = mc13783_read(mc13783, reg_num, reg_val);
> -	mutex_unlock(&mc13783->io_lock);
> +	BUG_ON(!mutex_is_locked(&mc13783->lock));
>  
> -	return ret;
> +	dev_vdbg(&mc13783->spidev->dev, "[0x%02x] <- 0x%06x\n", offset, val);
> +
> +	ret = mc13783_prep_write_transfer(mc13783, &t, &buf, offset, val);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	spi_message_init(&m);
> +	spi_message_add_tail(&t, &m);
> +
> +	ret = spi_sync(mc13783->spidev, &m);
> +
> +	BUG_ON(!ret && m.status);
> +
> +	if (ret)
> +		return ret;
> +
> +	ret = mc13783_eval_write_transfer(mc13783, &t, &buf, offset, val);
Again, I dont see the point of this function.

The rest of the code looks fine to me.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
