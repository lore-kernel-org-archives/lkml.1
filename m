Return-Path: <linux-kernel-owner+w=401wt.eu-S1756013AbZBKN1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbZBKN1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 08:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbZBKN11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 08:27:27 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:44260 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750808AbZBKN10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 08:27:26 -0500
Date: Thu, 12 Feb 2009 00:27:22 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Alexander Clouter <alex@digriz.org.uk>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCHv2] hw_random: add timeriomem-rng driver
Message-ID: <20090211132722.GA3258@gondor.apana.org.au>
References: <20090207095317.GB8800@woodchuck> <20090210045748.GA17236@gondor.apana.org.au> <20090210193904.GT11872@woodchuck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210193904.GT11872@woodchuck>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 07:39:04PM +0000, Alexander Clouter wrote:
>
> My original code[1] approach, with timer_pending() in there, would have 
> been okay then, right?
> ----
> if (timer_pending(&timeriomem_rng_timer)) {
>   if (!wait)
>     return 0;
> 
>   del_timer_sync(&timeriomem_rng_timer);
>   delay = timeriomem_rng_timer.expires - jiffies;
> 
>   schedule_timeout_uninterruptible(delay);
> }

Yes probably but it is racy.  Also it's better if we can avoid
the expires - jiffies calculation if only because then we won't
have to tell Andrew why it can't be negative :)

> > Instead of deleting the timer above, why not create a rng->present
> > variable which you set to zero here, and the timer sets it to
> > non-zero.  Then you just need to return rng->present in your
> > data_present function.
>
> Sounds fair, better than the timer_pending approach and easier to 
> understand.

Oh I forgot about the blocking case.  We can probably add a
completion object to handle that.  So something like

	if (!wait || rng->present)
		return rng->present;

	wait_for_completion(&rng->completion);
	return 1;

The timer would do

	rng->present = 1;
	complete(&rng->completion);

And the reader would do

	rng->present = 0;
	INIT_COMPLETION(rng->completion);
	add_timer(...)

Note that everything but the timer is completely serialised by
the hwrng mutex so we only need to worry about racing against
the timer.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
