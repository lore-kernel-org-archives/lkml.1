Return-Path: <linux-kernel-owner+w=401wt.eu-S1753652Ab0A0KNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab0A0KNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 05:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930Ab0A0KNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 05:13:50 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37039 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab0A0KNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 05:13:50 -0500
Date: Wed, 27 Jan 2010 11:13:42 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, arjan@infradead.org
Subject: Re: [PATCH RFC tip/core/rcu] accelerate grace period if last
	non-dynticked CPU
Message-ID: <20100127101342.GC12522@basil.fritz.box>
References: <20100125034816.GA14043@linux.vnet.ibm.com> <873a1sft9q.fsf@basil.nowhere.org> <20100127052050.GC6807@linux.vnet.ibm.com> <20100127094336.GA12522@basil.fritz.box> <20100127100136.GM6807@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100127100136.GM6807@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Can't you simply check that at runtime then?
> > 
> > if (num_possible_cpus() > 20) 
> > 	...
> > 
> > BTW the new small is large. This years high end desktop PC will come with 
> > upto 12 CPU threads. It would likely be challenging to find a good
> > number for 20 that holds up with the future.
> 
> And this was another line of reasoning that lead me to the extra kernel
> config parameter.

Which doesn't solve the problem at all.

> > Or better perhaps have some threshold that you don't do it 
> > that often, or only do it when you expect to be idle for a long
> > enough time that the CPU can enter deeper idle states
> > 
> > (I higher idle states some more wakeups typically don't matter
> > that much)
> > 
> > The cpufreq/cstate governour have a reasonable good idea
> > now how "idle" the system is and will be. Maybe you can reuse
> > that information somehow.
> 
> My first thought was to find an existing "I am a small device running on
> battery power" or "low power consumption is critical to me" config
> parameter.  I didn't find anything that looked like that.  If there was
> one, I would make RCU_FAST_NO_HZ depend on it.
> 
> Or did I miss some kernel parameter or API?

There are a few for scalability (e.g. numa_distance()), but they're 
obscure.  The really good ones are just known somewhere.

But I think in this case scalability is not the key thing to check
for, but expected idle latency. Even on a large system if near all
CPUs are idle spending some time to keep them idle even longer is a good
thing. But only if the CPUs actually benefit from long idle.

There's the "pm_qos_latency" frame work that could be used for this
in theory, but it's not 100% the right match because it's not
dynamic.

Unfortunately last time I looked the interfaces were rather clumpsy
(e.g. don't allow interrupt level notifiers)

Better would be some insight into the expected future latency:
look at exporting this information from the various frequency/idle 
governours. 

Perhaps pm_qos_latency could be extended to support that?
CC Arjan, maybe he has some ideas on that.

After all of that there would be still of course the question 
what the right latency threshold would be, but at least that's
a much easier question that number of CPUs.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
