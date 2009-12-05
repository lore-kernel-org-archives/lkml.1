Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbZLEKiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbZLEKiO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 05:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZLEKiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 05:38:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:52233 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbZLEKiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 05:38:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,346,1257148800"; 
   d="scan'208";a="520033080"
Subject: Re: [PATCH v6] x86/apic: limit irq affinity
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Miller <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <m1eina9vw1.fsf@fess.ebiederm.org>
References: <alpine.LFD.2.00.0911241443110.24119@localhost.localdomain>
	 <20091124065022.6933be1a@infradead.org>	<m1ws1f6csh.fsf@fess.ebiederm.org>
	 <20091125074033.4c46c1b0@infradead.org>	<20091203165004.GA14665@sgi.com>
	 <Pine.WNT.4.64.0912030851500.13880@ppwaskie-MOBL2.amr.corp.intel.com>
	 <20091203170149.GA15151@sgi.com>
	 <Pine.WNT.4.64.0912030905530.16084@ppwaskie-MOBL2.amr.corp.intel.com>
	 <20091203171946.GC15151@sgi.com>
	 <Pine.WNT.4.64.0912031048590.8104@ppwaskie-MOBL2.amr.corp.intel.com>
	 <20091204164227.GA28378@sgi.com> <1259961477.23199.39.camel@localhost>
	 <m1eina9vw1.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Dec 2009 02:38:09 -0800
Message-Id: <1260009489.3565.34.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-04 at 15:12 -0800, Eric W. Biederman wrote:
> Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com> writes:
> 
> >
> >> > 
> >> > > 
> >> > > Also, can we add a restricted mask as I mention above into this scheme?  If we can't send an IRQ to some node, we don't want to bother attempting to change affinity to cpus on that node (hopefully code in the kernel will eventually restrict this).
> >> > > 
> >> > 
> >> > The interface allows you to put in any CPU mask.  The way it's written 
> >> > now, whatever mask you put in, irqbalance *only* balances within that 
> >> > mask.  It won't ever try and go outside that mask.
> >> 
> >> OK.  Given that, it might be nice to combine the restricted cpus that I'm describing with your node_affinity mask, but we could expose them as separate masks (node_affinity and restricted_affinity, as I describe above).
> >> 
> >
> > I think this might be getting too complicated.  The only thing
> > irqbalance is lacking today, in my mind, is the feedback mechanism,
> > telling it what subset of CPU masks to balance within.
> 
> You mean besides knowing that devices can have more than one irq?

Why does it matter if it does or doesn't?  The interrupts have to go
somewhere.

> You mean besides making good on it's promise not to move networking
> irqs?  A policy of BALANCE_CORE sure doesn't look like a policy of
> don't touch.

Not moving network irqs is something Arjan said could be a bug, and he'd
be happy to either look into it, or welcome a patch if it really is
broken.   As for BALANCE_CORE, I have no idea what you're talking about.

> You mean besides realizing that irqs can only be directed at one cpu on
> x86?  At least when you have more than 8 logical cores in the system, the
> cases that matter.
> 

Huh?  I can have all of my interrupts directed to a single CPU on x86.
Can you give me an example here?

> > There is a
> > allowed_mask, but that is used for a different purpose.  Hence why I
> > added another.  But I think your needs can be met 100% with what I have
> > already, and we can come up with a different name that's more generic.
> > The flows would be something like this:
> 
> Two masks?  You are asking the kernel to move irqs for you then?

Absolutely not.  Were you not following this thread earlier when this
was being discussed with Thomas?

> > Driver:
> > - Driver comes online, allocates memory in a sensible NUMA fashion
> > - Driver requests kernel for interrupts, ties them into handlers
> > - Driver now sets a NUMA-friendly affinity for each interrupt, to match
> > with its initial memory allocation
> > - irqbalance balances interrupts within their new "hinted" affinities.
> >
> > Other:
> > - System comes online
> > - In your case, interrupts must be kept away from certain CPUs.
> > - Some mechanism in your architecture init can set the "hinted" affinity
> > mask for each interrupt.
> > - irqbalance will not move interrupts to the CPUs you left out of the
> > "hinted" affinity.
> >
> > Does this make more sense?
> 
> 
> >> > > As a matter of fact, driver's allocating rings, buffers, queues on other nodes should optimally be made aware of the restriction.
> >> > 
> >> > The idea is that the driver will do its memory allocations for everything 
> >> > across nodes.  When it does that, it will use the kernel interface 
> >> > (function call) to set the corresponding mask it wants for those queue 
> >> > resources.  That is my end-goal for this code.
> >> > 
> >> 
> >> OK, but we will eventually have to reject any irqbalance attempts to send irqs to restricted nodes.
> >
> > See above.
> 
> Either I am parsing this conversation wrong or there is a strong
> reality distortion field in place.  It appears you are asking that we
> depend on a user space application to not attempt the physically
> impossible, when we could just as easily ignore or report -EINVAL to.
> 

You are parsing this conversation incorrectly.  I also don't understand
why you always have a very negative view of how impossible everything
is.  Do you think we get no work done in the kernel?  We deal with
countless issues across the kernel that are hard.  Being hard doesn't
mean they're impossible, it just means we may have to try something new
and unknown.

What I'm asking is we make some mechanism for drivers to manage their
interrupt affinities.  Today drivers have no influence or control where
their interrupts land.  This is a limitation, plain and simple.  We need
a mechanism to allow a driver to say "hey, this interrupt needs to run
only on these CPUs.  Going elsewhere can severely impact performance of
your network."  Whatever listens and acts on that mechanism is
irrelevant.

> We really have two separate problems hear.
> - How to avoid the impossible.

Really man, this type of view is neither helpful or useful.  Either help
people solve problems, or keep your negative views on proposed solutions
to problems to yourself.

> - How to deal with NUMA affinity.

More generally, how to deal with a device's preferred affinity.  That is
the real issue I'm trying to solve.

Cheers,
-PJ

