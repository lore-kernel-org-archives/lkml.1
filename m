Return-Path: <linux-kernel-owner+w=401wt.eu-S1752140AbYLHSmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbYLHSmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 13:42:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbYLHSm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 13:42:28 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42959 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbYLHSm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 13:42:27 -0500
Date: Mon, 8 Dec 2008 10:42:23 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org, tglx@linutronix.de
Subject: Re: [PATCH, RFC] v7 scalable classic RCU implementation
Message-ID: <20081208184223.GA18260@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <20080915160221.GA9660@linux.vnet.ibm.com> <20080923235340.GA12166@linux.vnet.ibm.com> <20081010160930.GA9777@linux.vnet.ibm.com> <20081017083452.GA23228@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017083452.GA23228@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 02:04:52PM +0530, Gautham R Shenoy wrote:
> On Fri, Oct 10, 2008 at 09:09:30AM -0700, Paul E. McKenney wrote:
> > +static void __cpuinit rcu_online_cpu(int cpu)
> > +{
> > +#ifdef CONFIG_NO_HZ
> > +	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
> > +
> > +	rdtp->dynticks_nesting = 1;
> > +	rdtp->dynticks |= 1; 	/* need consecutive #s even for hotplug. */
> > +	rdtp->dynticks_nmi = (rdtp->dynticks + 1) & ~0x1;
>
> =>	rdtp->dynticks is odd. Hence rdtp->dynticks + 1 should be even.
> 	Why is the additional & ~0x1 ?

Because this line should instead be:

	rdtp->dynticks_nmi = (rdtp->dynticks_nmi + 1) & ~0x1;

Well spotted, even if it did take me a good long time to figure out
that this really was a bug in my code!  ;-)

That said, you would have to really work to exercise this one...  Near as
I can tell, you would need to wrap the ->dynticks counter, which would
then cause the dynticks_nmi counter to appear to go backwards.  And then
you would have to prevent the newly onlined CPU from ever passing through
a quiescent state, which would cause a failure in any case.

Still, good to fix, even if I can't figure out how it would result in
a failure.  Real hardware and software tends to be -much- better than me
at finding such failures!

							Thanx, Paul
