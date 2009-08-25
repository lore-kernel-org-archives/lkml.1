Return-Path: <linux-kernel-owner+w=401wt.eu-S1752269AbZHYIil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbZHYIil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZHYIij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:38:39 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:3519 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbZHYIii convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:38:38 -0400
X-SpamScore: -16
X-BigFish: VPS-16(z1857r34a4j8deiz1432R14c3L98dN936eM4015L655N13f4ja594izz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KOXC04-02-63G-02
X-M-MSG: 
Date: Tue, 25 Aug 2009 10:38:28 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Gautham Shenoy <ego@in.ibm.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [PATCH 8/15] sched: Add parameter sched_mn_power_savings to
	control MN domain sched policy
Message-ID: <20090825083828.GE20811@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com> <20090820133914.GW29327@alberich.amd.com> <1251125778.7538.268.camel@twins> <20090825062432.GB20811@alberich.amd.com> <1251182496.7538.1055.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1251182496.7538.1055.camel@twins>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Aug 2009 08:38:29.0421 (UTC) FILETIME=[6BCD2DD0:01CA255F]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 08:41:36AM +0200, Peter Zijlstra wrote:
> On Tue, 2009-08-25 at 08:24 +0200, Andreas Herrmann wrote:
> > On Mon, Aug 24, 2009 at 04:56:18PM +0200, Peter Zijlstra wrote:
> > > On Thu, 2009-08-20 at 15:39 +0200, Andreas Herrmann wrote:
> > > > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > > > ---
> > > 
> > > > +#ifdef CONFIG_SCHED_MN
> > > > +	if (!err && mc_capable())
> > > > +		err = sysfs_create_file(&cls->kset.kobj,
> > > > +					&attr_sched_mn_power_savings.attr);
> > > > +#endif
> > > 
> > > *sigh* another crappy sysfs file
> > > 
> > > Guys, can't we come up with anything better than sched_*_power_saving=n?
> > 
> > Thought this is a settled thing. At least there are already two
> > such parameters. So using the existing convention is an obvious
> > thing, no?
> 
> Well, yes its the obvious thing, but I'm questioning whether its the
> best thing ;-)

Ok.

> > > This configuration space is _way_ too large, and now it gets even
> > > crazier.
> > 
> > I don't fully agree.
> > 
> > Having one control interface for each domain level is just one
> > approach. It gives the user full control of scheduling policies.
> > It just might have to be properly documented.
> > 
> > In another mail Vaidy mentioned that
> > 
> >   "at some point we wanted to change the interface to
> >    sched_power_savings=N and and set the flags according to system
> >    topology".
> > 
> > But how you'll decide at which domain level you have to do power
> > savings scheduling?
> 
> The user isn't interested in knowing about domains and cpu topology in
> 99% of the cases, all they want is the machine not burning power like
> there's no tomorrow.
> 
> Users (me including) have no interest exploring a 27-state power
> configuration space in order to find out what works best for them, I'd
> throw up my hands and not bother, really.

If we have only a single knob (with 0==performance, 1==power savings)
then the arch-specific code must properly set the required SD flags
after CPU/topology detection. Only this will allow the scheduler code
to do the right thing.

Imagine you have following "virtual" CPU topology in a server

- more than one thread per core (sharing cache, FPU, whatsoever)
- multiple cores per internal node (sharing cache, maybe same memory channels)
- multiple internal nodes per socket
- multiple sockets

For power savings scheduling you can choose one or more option from

(a) You might save power when first utilizing all threads of one core, but
    degrade performance by not using other cores.

(b) You might save power when first utilizing all cores of an internal node,
    but you degrade performance by not using other internal nodes.

(c) You might save power when first utilizing all internal nodes of one socket
    before using another socket.

With only a single knob, would you switch on (a) and (b) and (c)?
Or do you decide to switch on only (c) because performance degradation
is too high with (a) and (b)?

One solution could be to have
- two sysfs attributes:
  * sched_power_domain, value=one of {SMT, MC, MN}
  * sched_power_level, value=one of {0, 1, 2})
- and an implicit rule that (a) implies (b) and (b) implies (c).
- Note: this implies that its impossible to switch on only (a).

> > Using sched_mn_power_savings=1 is quite different from
> > sched_smt_power_savings=1. Probably, the most power you save if you
> > switch on power saving scheduling on each domain level. I.e. first
> > filling threads of one core, then filling all cores on one internal
> > node, then filling all internal nodes of one socket.
> > 
> > But for performance reasons a user might just want to use power
> > savings in the MN domain. How you'd allow the user to configure that
> > with just one interface? Passing the domain level to
> > sched_power_savings, e.g.  sched_power_savings=MC instead of the power
> > saving level?
> 
> Sure its different, it reduces the configuration space, that gives less
> choice, but does make it accessible.
> 
> Ask joe-admin what he prefers.
> 
> If you're really really worried people might miss the joy of fine tuning
> their power scheduling, then we can provide a dual interface, one for
> dumb people like me, and one for crazy people like you ;-)

> > Besides that, don't we have to keep the user-interface stable, i.e.
> > stick to sched_smt_power_savings and sched_mc_power_savings?
> 
> Don't ever defend crappy stuff with interface stability, that's just
> lame ;-)

Yep, I have no problem with changing interfaces if they are considered
crappy.

But we should have an approriate replacement.


Thanks,

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


