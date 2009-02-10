Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbZBJTjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbZBJTjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbZBJTjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:39:10 -0500
Received: from woodchuck.wormnet.eu ([77.75.105.223]:50707 "EHLO
	woodchuck.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbZBJTjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:39:09 -0500
Date: Tue, 10 Feb 2009 19:39:04 +0000
From: Alexander Clouter <alex@digriz.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCHv2] hw_random: add timeriomem-rng driver
Message-ID: <20090210193904.GT11872@woodchuck>
References: <20090207095317.GB8800@woodchuck> <20090210045748.GA17236@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210045748.GA17236@gondor.apana.org.au>
Organization: diGriz
X-URL: http://www.digriz.org.uk/
X-JabberID: jimdigriz@jabber.earth.li
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Herbert Xu <herbert@gondor.apana.org.au> [2009-02-10 15:57:49+1100]:
> 
> On Sat, Feb 07, 2009 at 09:53:17AM +0000, Alexander Clouter wrote:
> >
> > +/*
> > + * have data return 1, however return 0 if we have nothing
> > + */
> > +static int timeriomem_rng_data_present(struct hwrng *rng, int wait)
> > +{
> > +	s32 delay;
> > +
> > +	if (rng->priv == 0)
> > +		return 1;
> > +
> > +	if (del_timer_sync(&timeriomem_rng_timer)) {
> > +		if (!wait)
> > +			return 0;
> > +
> > +		delay = timeriomem_rng_timer.expires - jiffies;
> > +
> > +		schedule_timeout_uninterruptible(delay);
> > +	}
> 
> Sorry, but this just doesn't work for O_NONBLOCK reads.  What'll
> happen is that the first failed read will return -EAGAIN, and when
> we're called again immediately (because hwrng polling support is
> non-existant), it'll just read the data right away because now
> there is no timer.
>
My original code[1] approach, with timer_pending() in there, would have 
been okay then, right?
----
if (timer_pending(&timeriomem_rng_timer)) {
  if (!wait)
    return 0;

  del_timer_sync(&timeriomem_rng_timer);
  delay = timeriomem_rng_timer.expires - jiffies;

  schedule_timeout_uninterruptible(delay);
}
----
 
> > +static int timeriomem_rng_data_read(struct hwrng *rng, u32 *data)
> > +{
> > +	unsigned long cur;
> > +	s32 delay;
> > +
> > +	*data = readl(timeriomem_rng_data->address);
> > +
> > +	if (rng->priv != 0) {
> > +		cur = jiffies;
> > +
> > +		delay = cur - timeriomem_rng_timer.expires;
> > +		delay = rng->priv - (delay % rng->priv);
> > +
> > +		timeriomem_rng_timer.expires = cur + delay;
> > +		add_timer(&timeriomem_rng_timer);
> > +	}
> 
> Instead of deleting the timer above, why not create a rng->present
> variable which you set to zero here, and the timer sets it to
> non-zero.  Then you just need to return rng->present in your
> data_present function.
> 
Sounds fair, better than the timer_pending approach and easier to 
understand.

> > +static void timeriomem_rng_trigger(unsigned long dummy)
> > +{
> > +	del_timer_sync(&timeriomem_rng_timer);
> > +}
> 
> This is going to create an infinite loop.  There is no point in
> deleting yourself.
> 
Noted.

Cheers
