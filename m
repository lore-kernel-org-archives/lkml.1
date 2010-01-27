Return-Path: <linux-kernel-owner+w=401wt.eu-S1752382Ab0A0LpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab0A0LpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 06:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755Ab0A0LpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 06:45:15 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36224 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab0A0LpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 06:45:13 -0500
Date: Wed, 27 Jan 2010 03:44:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       arjan@infradead.org
Subject: Re: [PATCH RFC tip/core/rcu] accelerate grace period if last
	non-dynticked CPU
Message-ID: <20100127114459.GP6807@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100125034816.GA14043@linux.vnet.ibm.com> <873a1sft9q.fsf@basil.nowhere.org> <20100127052050.GC6807@linux.vnet.ibm.com> <20100127094336.GA12522@basil.fritz.box> <20100127100136.GM6807@linux.vnet.ibm.com> <20100127101342.GC12522@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100127101342.GC12522@basil.fritz.box>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 11:13:42AM +0100, Andi Kleen wrote:
> > > Can't you simply check that at runtime then?
> > > 
> > > if (num_possible_cpus() > 20) 
> > > 	...
> > > 
> > > BTW the new small is large. This years high end desktop PC will come with 
> > > upto 12 CPU threads. It would likely be challenging to find a good
> > > number for 20 that holds up with the future.
> > 
> > And this was another line of reasoning that lead me to the extra kernel
> > config parameter.
> 
> Which doesn't solve the problem at all.

Depending on what you consider the problem to be, of course.

>From what I can see, most people would want RCU_FAST_NO_HZ=n.  Only
people with extreme power-consumption concerns would likely care enough
to select this.

> > > Or better perhaps have some threshold that you don't do it 
> > > that often, or only do it when you expect to be idle for a long
> > > enough time that the CPU can enter deeper idle states
> > > 
> > > (I higher idle states some more wakeups typically don't matter
> > > that much)
> > > 
> > > The cpufreq/cstate governour have a reasonable good idea
> > > now how "idle" the system is and will be. Maybe you can reuse
> > > that information somehow.
> > 
> > My first thought was to find an existing "I am a small device running on
> > battery power" or "low power consumption is critical to me" config
> > parameter.  I didn't find anything that looked like that.  If there was
> > one, I would make RCU_FAST_NO_HZ depend on it.
> > 
> > Or did I miss some kernel parameter or API?
> 
> There are a few for scalability (e.g. numa_distance()), but they're 
> obscure.  The really good ones are just known somewhere.
> 
> But I think in this case scalability is not the key thing to check
> for, but expected idle latency. Even on a large system if near all
> CPUs are idle spending some time to keep them idle even longer is a good
> thing. But only if the CPUs actually benefit from long idle.

The larger the number of CPUs, the lower the probability of all of them
going idle, so the less difference this patch makes.  Perhaps some
larger system will care about this on a per-socket basis, but I have yet
to hear any requests.

> There's the "pm_qos_latency" frame work that could be used for this
> in theory, but it's not 100% the right match because it's not
> dynamic.
> 
> Unfortunately last time I looked the interfaces were rather clumpsy
> (e.g. don't allow interrupt level notifiers)

I do need to query from interrupt context, but could potentially have a
notifier set up state for me.  Still, the real question is "how important
is a small reduction in power consumption?"

> Better would be some insight into the expected future latency:
> look at exporting this information from the various frequency/idle 
> governours. 
> 
> Perhaps pm_qos_latency could be extended to support that?
> CC Arjan, maybe he has some ideas on that.
> 
> After all of that there would be still of course the question 
> what the right latency threshold would be, but at least that's
> a much easier question that number of CPUs.

Hmmm...  I am still believing that very few people want RCU_FAST_NO_HZ,
and that those who want it can select it for their devices.

Trying to apply this to server-class machines gets into questions like
"where are the core/socket boundaries", "can this hardware turn entire
cores/sockets off", "given the current workload, does it really make sense
to try to turn off entire cores/sockets", and "is a few ticks important
when migrating processes, irqs, timers, and whatever else is required to
actually turn off a given core or socket for a significant time period".

I took a quick look at te pm_qos_latency, and, as you note, it doesn't
really seem to be designed to handle this situation.

And we really should not be gold-plating this thing.  I have one requester
(off list) who needs it badly, and who is willing to deal with a kernel
configuration parameter.  I have no other requesters, and therefore
cannot reasonably anticipate their needs.  As a result, we cannot justify
building any kind of infrastructure beyond what is reasonable for the
single requester.

Maybe the situation will be different next year.  But if so, we would
then have some information on what people really need.  So, if it turns
out that more will be needed in 2011, I will be happy to do something
about it once I have some hard information on what will really be needed.

Fair enough?

							Thanx, Paul
