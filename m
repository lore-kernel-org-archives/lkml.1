Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbZBJTuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbZBJTuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:50:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbZBJTuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:50:00 -0500
Received: from woodchuck.wormnet.eu ([77.75.105.223]:54889 "EHLO
	woodchuck.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573AbZBJTt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:49:59 -0500
Date: Tue, 10 Feb 2009 19:49:55 +0000
From: Alexander Clouter <alex@digriz.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCHv2] hw_random: add timeriomem-rng driver
Message-ID: <20090210194955.GU11872@woodchuck>
References: <20090207095317.GB8800@woodchuck> <20090210045748.GA17236@gondor.apana.org.au> <20090210193904.GT11872@woodchuck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210193904.GT11872@woodchuck>
Organization: diGriz
X-URL: http://www.digriz.org.uk/
X-JabberID: jimdigriz@jabber.earth.li
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Alexander Clouter <alex@digriz.org.uk> [2009-02-10 19:39:04+0000]:
> 
> * Herbert Xu <herbert@gondor.apana.org.au> [2009-02-10 15:57:49+1100]:
> > 
> > Sorry, but this just doesn't work for O_NONBLOCK reads.  What'll
> > happen is that the first failed read will return -EAGAIN, and when
> > we're called again immediately (because hwrng polling support is
> > non-existant), it'll just read the data right away because now
> > there is no timer.
> >
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
> ----
> 
> [snipped]
> > 
> > Instead of deleting the timer above, why not create a rng->present
> > variable which you set to zero here, and the timer sets it to
> > non-zero.  Then you just need to return rng->present in your
> > data_present function.
> > 
> Sounds fair, better than the timer_pending approach and easier to 
> understand.
> 
Actually, as timer_pending() just reads a field in timer_list (or so 
says the 'manual'), would it not be a waste to have a second effectively 
duplicate variable?  In a blocking read of data_presnt you would have to 
have del_timer_sync() anyway...the two approaches would be identical 
except for the rng->present variable approach would force us to waste a 
whole extra bit of ram?

Should I keep with my old original timer_pending() approach?

Of course I could be talking rubbish...

Cheers

-- 
Alexander Clouter
.sigmonster says: So many men; so little time.
