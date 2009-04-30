Return-Path: <linux-kernel-owner+w=401wt.eu-S1763246AbZD3OGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763246AbZD3OGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757984AbZD3OGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:06:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47093 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757922AbZD3OGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:06:19 -0400
Date: Thu, 30 Apr 2009 16:05:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nikanth Karthikesan <knikanth@novell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Detect and warn on atomic_inc/atomic_dec wrapping
	around
Message-ID: <20090430140559.GA14696@elte.hu>
References: <200904291221.40361.knikanth@novell.com> <200904301859.27199.knikanth@novell.com> <20090430133757.GA8329@elte.hu> <200904301921.44615.knikanth@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904301921.44615.knikanth@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nikanth Karthikesan <knikanth@novell.com> wrote:

> On Thursday 30 April 2009 19:07:57 Ingo Molnar wrote:
> > * Nikanth Karthikesan <knikanth@novell.com> wrote:
> > > > Then there could be a single, straightforward value check:
> > > >
> > > > static inline void atomic_inc(atomic_t *v)
> > > > {
> > > > 	debug_atomic_check_value(v);
> > > > 	raw_atomic_inc(v);
> > > > }
> > > >
> > > > Where debug_atomic_check_value() is just an atomic_read():
> > > >
> > > > static inline void debug_atomic_check_value(atomic_t *v)
> > > > {
> > > > 	WARN_ONCE(in_range(atomic_read(v), UINT_MAX/4, UINT_MAX/4*3),
> > > > 		  KERN_ERR "atomic counter check failure!");
> > > > }
> > >
> > > I do not understand, why UINT_MAX/4 to UINT_MAX/4*3?
> > > Roughly,
> > > UINT_MAX/4 = INT_MAX/2
> > > UINT_MAX/4*3 = INT_MAX/2*3 which we will never reach with an int.
> >
> > i mean:
> >
> >  	WARN_ONCE(in_range((u32)atomic_read(v), UINT_MAX/4, UINT_MAX/4*3),
> >  		  KERN_ERR "atomic counter check failure!");
> >
> > that's a single range check on an u32, selecting 'too large' and
> > 'too small' s32 values.
> >
> > > > It's a constant check.
> > > >
> > > > If are overflowing on such a massive rate, it doesnt matter how
> > > > early or late we check the value.
> > >
> > > UINT_MAX/4 early, might be too early. And if it doesn't matter how
> > > early or late, why try to be over-cautious and produce false
> > > warnings. ;-)
> >
> > UINT_MAX/4 is ~1 billion. If we reach a value of 1 billion we are
> > leaking. Your check basically is a sharp test for the specific case
> > of overflowing the boundary - but it makes the code slower (it uses
> > more complex atomic ops) and uglifies it via #ifdefs as well.
> >
> > It doesnt matter whether we wrap over at around +2 billion into -2
> > billion, or treat the whole above-1-billion and
> > below-minus-1-billion range as invalid. (other than we'll catch bugs
> > sooner via this method, and have faster and cleaner code)
> >
> 
> Ah.. got it. But, range checking is not required as we are just 
> verifying it during increment and decrement, not atomic_add, 
> atomic_sub etc... Should we add debug checks to those operations 
> as well? If we want to test those operations as well, range check 
> would be useful.

Good point! Indeed the checks can be even simpler that way - a 
single test.

> Here is a patch, without the overhead of a costly atomic operation 
> which would warn if it goes out of [INT_MIN/2 .. INT_MAX/2].

> +static inline void atomic_inc(atomic_t *v)
> +{
> +#ifdef CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP
> +	WARN_ONCE((atomic_read(v) > (INT_MAX / 2)),
> +		KERN_ERR "atomic counter check failure!");

here the message can be more specific i think:

		KERN_ERR "atomic inc overflow!");

> +#endif
> +	raw_atomic_inc(v);
> +}
> +
> +/**
> + * atomic_dec - decrement atomic variable
> + * @v: pointer of type atomic_t
> + *
> + * Atomically decrements @v by 1.
> + */
> +static inline void atomic_dec(atomic_t *v)
> +{
> +#ifdef CONFIG_ENABLE_WARN_ATOMIC_INC_WRAP
> +	WARN_ONCE((atomic_read(v) < (INT_MIN / 2)),
> +		KERN_ERR "atomic counter check failure!");
> +#endif

and here:

		KERN_ERR "atomic inc underflow!");

other than these two small details this is looking really nice now.

	Ingo
