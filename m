Return-Path: <linux-kernel-owner+w=401wt.eu-S932965AbXHAOuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbXHAOuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbXHAOuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:50:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42007 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757721AbXHAOuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:50:03 -0400
Subject: Re: CFS review
From: Peter Zijlstra <peterz@infradead.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708010439050.1817@scrub.home>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
	 <20070711211638.GE18767@one.firstfloor.org>
	 <20070711214649.GK14435@v2.random>
	 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0707130415520.1818@scrub.home>
	 <1184302024.6709.11.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0707131728070.1817@scrub.home>
	 <1184389456.6632.13.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0708010439050.1817@scrub.home>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 16:49:56 +0200
Message-Id: <1185979796.12034.92.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roman,

Took me most of today trying to figure out WTH you did in fs2.c, more
math and fundamental explanations would have been good. So please bear
with me as I try to recap this thing. (No, your code was very much _not_
obvious, a few comments and broken out functions would have made a world
of a difference)


So, for each task we keep normalised time

 normalised time := time/weight

using Bresenham's algorithm we can do this prefectly (up until a renice
- where you'd get errors)

        avg_frac += weight_inv
        
        weight_inv = X / weight
        
        avg = avg_frac / weight0_inv
        
        weight0_inv = X / weight0
        
        avg = avg_frac / (X / weight0) 
            = (X / weight) / (X / weight0) 
            = X / weight * weight0 / X 
            = weight0 / weight
        

So avg ends up being in units of [weight0/weight].

Then, in order to allow sleeping, we need to have a global clock to sync
with. Its this global clock that gave me headaches to reconstruct.

We're looking for a time like this:

  rq_time := sum(time)/sum(weight)

And you commented that the /sum(weight) part is where CFS obtained its
accumulating rounding error? (I'm inclined to believe the error will
statistically be 0, but I'll readily accept otherwise if you can show a
practical 'exploit')

Its not obvious how to do this using modulo logic like Bresenham because
that would involve using a gcm of all possible weights.

What you ended up with is quite interesting if correct.

	sum_avg_frac += weight_inv_{i}

however by virtue of the scheduler minimising:

  avg_{i} - avg_{j} | i != j

this gets a factor of:

  weight_{i}/sum_{j}^{N}(weight_{j})

 ( seems correct, needs more analysis though, this is very much a
   statistical step based on the previous constraint. this might
   very well introduce some errors )

resulting in:

        sum_avg_frac += sum_{i}^{N}(weight_inv_{i} *
        weight_{i}/sum_{j}^{N}(weight_{j}))
        
        weight_inv = X / weight
        
        sum_avg = sum_avg_frac / sum(weight0_inv)
                = sum_avg_frac / N*weight0_inv
        
        weight0_inv = X / weight0
        
        sum_avg = sum_avg_frac / N*weight0_inv
                = sum_{i}^{N}(weight_inv_{i} *
        weight_{i}/sum_{j}^{N}(weight_{j})) / N*weight0_inv
                = sum_{i}^{N}(X/weight_{i} *
        weight_{i}/sum_{j}^{N}(weight_{j})) / N*(X/weight0)
                = N*X / sum_{j}(weight_{j}) * weight0/N*X
                = weight0 / sum_{j}(weight_{j})

Exactly the unit we were looking for [weight0/sum(weight)]

 ( the extra weight0 matching the one we had in the per task normalised
   time )

I'm not sure all this is less complex than CFS, I'd be inclined to say
it is more so.

Also, I think you have an accumulating error on wakeup where you sync
with the global clock but fully discard the fraction.

Anyway, as said a more detailed explanation and certainly a proof of
your math would be nice. Is this something along the lines of what you
intended to convey?

If so, in the future please use more understandable language, we were
taught math for a reason :-)

Regards,
Peter



