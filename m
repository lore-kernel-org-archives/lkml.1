Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbZBJE6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbZBJE6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 23:58:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbZBJE54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 23:57:56 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:43342 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750887AbZBJE54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 23:57:56 -0500
Date: Tue, 10 Feb 2009 15:57:49 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Alexander Clouter <alex@digriz.org.uk>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCHv2] hw_random: add timeriomem-rng driver
Message-ID: <20090210045748.GA17236@gondor.apana.org.au>
References: <20090207095317.GB8800@woodchuck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090207095317.GB8800@woodchuck>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 07, 2009 at 09:53:17AM +0000, Alexander Clouter wrote:
>
> +/*
> + * have data return 1, however return 0 if we have nothing
> + */
> +static int timeriomem_rng_data_present(struct hwrng *rng, int wait)
> +{
> +	s32 delay;
> +
> +	if (rng->priv == 0)
> +		return 1;
> +
> +	if (del_timer_sync(&timeriomem_rng_timer)) {
> +		if (!wait)
> +			return 0;
> +
> +		delay = timeriomem_rng_timer.expires - jiffies;
> +
> +		schedule_timeout_uninterruptible(delay);
> +	}

Sorry, but this just doesn't work for O_NONBLOCK reads.  What'll
happen is that the first failed read will return -EAGAIN, and when
we're called again immediately (because hwrng polling support is
non-existant), it'll just read the data right away because now
there is no timer.

> +static int timeriomem_rng_data_read(struct hwrng *rng, u32 *data)
> +{
> +	unsigned long cur;
> +	s32 delay;
> +
> +	*data = readl(timeriomem_rng_data->address);
> +
> +	if (rng->priv != 0) {
> +		cur = jiffies;
> +
> +		delay = cur - timeriomem_rng_timer.expires;
> +		delay = rng->priv - (delay % rng->priv);
> +
> +		timeriomem_rng_timer.expires = cur + delay;
> +		add_timer(&timeriomem_rng_timer);
> +	}

Instead of deleting the timer above, why not create a rng->present
variable which you set to zero here, and the timer sets it to
non-zero.  Then you just need to return rng->present in your
data_present function.

> +static void timeriomem_rng_trigger(unsigned long dummy)
> +{
> +	del_timer_sync(&timeriomem_rng_timer);
> +}

This is going to create an infinite loop.  There is no point in
deleting yourself.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
