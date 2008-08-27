Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbYH0Ail@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbYH0Ail (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 20:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbYH0Aib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 20:38:31 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53295 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbYH0Aia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 20:38:30 -0400
Subject: Re: [PATCH, RFC, tip/core/rcu] scalable classic RCU implementation
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, schamp@sgi.com, niv@us.ibm.com, dvhltc@us.ibm.com,
       ego@in.ibm.com, laijs@cn.fujitsu.com, rostedt@goodmis.org
In-Reply-To: <20080826160530.GB6656@linux.vnet.ibm.com>
References: <20080821234318.GA1754@linux.vnet.ibm.com>
	 <1219447772.5197.98.camel@josh-work.beaverton.ibm.com>
	 <20080823015336.GP6744@linux.vnet.ibm.com>
	 <1219701750.12334.29.camel@josh-work.beaverton.ibm.com>
	 <20080826160530.GB6656@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 26 Aug 2008 17:38:36 -0700
Message-Id: <1219797516.6911.6.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-26 at 09:05 -0700, Paul E. McKenney wrote:
> On Mon, Aug 25, 2008 at 03:02:30PM -0700, Josh Triplett wrote:
> > On Fri, 2008-08-22 at 18:53 -0700, Paul E. McKenney wrote:
> > > On Fri, Aug 22, 2008 at 04:29:32PM -0700, Josh Triplett wrote:
> > > > On Thu, 2008-08-21 at 16:43 -0700, Paul E. McKenney wrote:
> > > > > @@ -658,14 +806,19 @@ int rcu_needs_cpu(int cpu)
> > > > >  	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
> > > > >  	struct rcu_data *rdp_bh = &per_cpu(rcu_bh_data, cpu);
> > > > > 
> > > > > -	return !!rdp->nxtlist || !!rdp_bh->nxtlist || rcu_pending(cpu);
> > > > > +	return !!*rdp->nxttail[RCU_DONE_TAIL] ||
> > > > > +	       !!*rdp_bh->nxttail[RCU_DONE_TAIL] ||
> > > > > +	       rcu_pending(cpu);
> > > > 
> > > > !! seems unnecessary here.
> > > 
> > > Someone once told me why this was necessary, but I forget.  It was in the
> > > original, and I didn't put it there.  Some weirdness about conversion
> > > to 32-bit integer when the lower 32 bits of the pointer was zero or
> > > some such.  So if your pointer value was 0x100000000, for example,
> > > so that conversion to int gives zero.
> > 
> > Good point!  That doesn't apply if you use ||, though.  If you just did
> > "return somepointer" that could potentially cause the problem you
> > describe.  In any case, it can't *hurt* to have it; GCC should do the
> > sane thing.
> 
> OK.  I will review this towards the end, leaving it there to remind me
> in the meantime.
> 
> So, would I need the !! on the left-hand operand of the first || due
> to short-circuiting?

No.  || will always return 1 or 0.  You only need the !! if you want to
directly return the boolean value of a potentially 64-bit pointer.

- Josh Triplett


