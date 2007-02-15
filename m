Return-Path: <linux-kernel-owner+w=401wt.eu-S1751681AbXBOVuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbXBOVuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 16:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbXBOVuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 16:50:54 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:37531 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbXBOVux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 16:50:53 -0500
Date: Thu, 15 Feb 2007 13:50:48 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Carl Love <cel@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, oprofile-list@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling	updated	patch
Message-ID: <20070215215047.GE1913@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1171497138.23691.8.camel@dyn9047021078.beaverton.ibm.com> <200702151537.51202.arnd@arndb.de> <1171570918.31179.36.camel@dyn9047021078.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171570918.31179.36.camel@dyn9047021078.beaverton.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 12:21:58PM -0800, Carl Love wrote:
> On Thu, 2007-02-15 at 15:37 +0100, Arnd Bergmann wrote:

[ . . . ]

> > I agree with Milton that it would be far nicer even to calculate
> > the value from user space, but since you say that would
> > violate the oprofile interface conventions, let's not go there.
> > In order to make this code nicer on the user, you should probably
> > insert a 'cond_resched()' somewhere in the loop, maybe every
> > 500 iterations or so.
> > 
> > it also looks like there is whitespace damage in the code here.
> 
> I will double check on the whitespace damage.  I thought I had gotten
> all that out.  
> 
> I have done some quick measurements.  The above method limits the loop
> to at most 2^16 iterations.  Based on running the algorithm in user
> space, it takes about 3ms of computation time to do the loop 2^16 times.
> 
> At the vary least, we need to put the resched in say every 10,000
> iterations which would be about every 0.5ms.  Should we do a resched
> more often?  
> 
> Additionally we could up the size of the table to 512 which would reduce
> the maximum time to about 1.5ms.  What do people think about increasing
> the table size?

Is this 1.5ms with interrupts disabled?  This time period is problematic
from a realtime perspective if so -- need to be able to preempt.

						Thanx, Paul

> A little more general discussion about the logarithmic algorithm and
> limiting the range.  The hardware supports a 24 bit LFSR value. This
> means the user can say is capture a sample every N cycles, where N is in
> the range of 1 to 2^24.  The OProfile user tool enforces a minimum value
> of N to make sure the overhead of OProfile doesn't bring the machine to
> its knees.  The minimum values is not intended to guarantee the
> performance impact of OProfile will not be significant.  It is left as
> an exercise for the user to pick an N that will give minimal performance
> impact.  We set the lower limit for N for SPU profiling to 100,000. This
> is actually high enough that we don't seem to see much performance
> impact when running OProfile.  If the user picked N=2^24 then for a
> 3.2GHz machine you would get about 200 samples per second on each node.
> Where a sample consists of the PC value for all 8 SPUs on the node.  If
> the user wanted to do a relatively long OProfile run, I can see where
> they might use N=2^24 to avoid gathering too much data.  My gut feeling
> is that the sampling frequency for N=2^24 is not low enough that someone
> would never want to use it when doing long runs.  Hence, we should not
> arbitrarily reduce the maximum value for N.  Although I would expect
> that the typical value for N will be in the range of several hundred
> thousand to a few million.
> 
> As for using a logarithmic spacing of the precomputed values, this
> approach means that the space between the precomputed values at the high
> end would be much larger then 2^14, assuming 256 precomputed values.
> That means it could take much longer then 3ms to get the needed LFSR
> value for a large N.  By evenly spacing the precomputed values, we can
> ensure that for all N it will take less then 3ms to get the value.
> Personally, I am more comfortable with a hard limit on the compute time
> then a variable time that could get much bigger then the 1ms threshold
> that Arnd wants for resched.  Any thoughts?
> 
> > 
> > > +
> > > +/* This interface allows a profiler (e.g., OProfile) to store
> > > + * spu_context information needed for profiling, allowing it to
> > > + * be saved across context save/restore operation.
> > > + *
> > > + * Assumes the caller has already incremented the ref count to
> > > + * profile_info; then spu_context_destroy must call kref_put
> > > + * on prof_info_kref.
> > > + */
> > > +void spu_set_profile_private(struct spu_context * ctx, void * profile_info,
> > > +			     struct kref * prof_info_kref,
> > > +			     void (* prof_info_release) (struct kref * kref))
> > > +{
> > > +	ctx->profile_private = profile_info;
> > > +	ctx->prof_priv_kref = prof_info_kref;
> > > +	ctx->prof_priv_release = prof_info_release;
> > > +}
> > > +EXPORT_SYMBOL_GPL(spu_set_profile_private);
> > 
> > I think you don't need the profile_private member here, if you just use
> > container_of with ctx->prof_priv_kref in all users.
> > 
> > 	Arnd <><
> 
> _______________________________________________
> cbe-oss-dev mailing list
> cbe-oss-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/cbe-oss-dev
