Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbYH0Ulz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbYH0Ulz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 16:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYH0Uln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 16:41:43 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:33447 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbYH0Uln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 16:41:43 -0400
Date: Wed, 27 Aug 2008 13:41:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josht@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, schamp@sgi.com, niv@us.ibm.com, dvhltc@us.ibm.com,
       ego@in.ibm.com, laijs@cn.fujitsu.com, rostedt@goodmis.org
Subject: Re: [PATCH, RFC, tip/core/rcu] scalable classic RCU implementation
Message-ID: <20080827204120.GM6711@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <1219447772.5197.98.camel@josh-work.beaverton.ibm.com> <20080823015336.GP6744@linux.vnet.ibm.com> <1219701750.12334.29.camel@josh-work.beaverton.ibm.com> <20080826160530.GB6656@linux.vnet.ibm.com> <1219797516.6911.6.camel@josh-work.beaverton.ibm.com> <20080827183446.GL6711@linux.vnet.ibm.com> <1219868608.10880.5.camel@josh-work.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219868608.10880.5.camel@josh-work.beaverton.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 01:23:28PM -0700, Josh Triplett wrote:
> On Wed, 2008-08-27 at 11:34 -0700, Paul E. McKenney wrote:
> > On Tue, Aug 26, 2008 at 05:38:36PM -0700, Josh Triplett wrote:
> > > On Tue, 2008-08-26 at 09:05 -0700, Paul E. McKenney wrote:
> > > > On Mon, Aug 25, 2008 at 03:02:30PM -0700, Josh Triplett wrote:
> > > > > On Fri, 2008-08-22 at 18:53 -0700, Paul E. McKenney wrote:
> > > > > > On Fri, Aug 22, 2008 at 04:29:32PM -0700, Josh Triplett wrote:
> > > > > > > On Thu, 2008-08-21 at 16:43 -0700, Paul E. McKenney wrote:
> > > > > > > > @@ -658,14 +806,19 @@ int rcu_needs_cpu(int cpu)
> > > > > > > >  	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
> > > > > > > >  	struct rcu_data *rdp_bh = &per_cpu(rcu_bh_data, cpu);
> > > > > > > > 
> > > > > > > > -	return !!rdp->nxtlist || !!rdp_bh->nxtlist || rcu_pending(cpu);
> > > > > > > > +	return !!*rdp->nxttail[RCU_DONE_TAIL] ||
> > > > > > > > +	       !!*rdp_bh->nxttail[RCU_DONE_TAIL] ||
> > > > > > > > +	       rcu_pending(cpu);
> > > > > > > 
> > > > > > > !! seems unnecessary here.
> > > > > > 
> > > > > > Someone once told me why this was necessary, but I forget.  It was in the
> > > > > > original, and I didn't put it there.  Some weirdness about conversion
> > > > > > to 32-bit integer when the lower 32 bits of the pointer was zero or
> > > > > > some such.  So if your pointer value was 0x100000000, for example,
> > > > > > so that conversion to int gives zero.
> > > > > 
> > > > > Good point!  That doesn't apply if you use ||, though.  If you just did
> > > > > "return somepointer" that could potentially cause the problem you
> > > > > describe.  In any case, it can't *hurt* to have it; GCC should do the
> > > > > sane thing.
> > > > 
> > > > OK.  I will review this towards the end, leaving it there to remind me
> > > > in the meantime.
> > > > 
> > > > So, would I need the !! on the left-hand operand of the first || due
> > > > to short-circuiting?
> > > 
> > > No.  || will always return 1 or 0.  You only need the !! if you want to
> > > directly return the boolean value of a potentially 64-bit pointer.
> > 
> > Even if one argument of || is long and the other int or some fool thing
> > like that?  (What, me paranoid???)
> 
> What, you don't know exactly how C behaves in every strange corner
> case? ;)

I used to, back when identifiers were only guaranteed to be
differentiated by their first 8 characters (6 or 7 if extern).  ;-)

> || always produces a result of type int, and it compares each of its two
> arguments to 0 independently; to the best of my knowledge the size of
> those arguments never matters.

I suppose I should read the spec.

							Thanx, Paul
