Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbYIIGTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbYIIGTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 02:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbYIIGTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 02:19:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48144 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbYIIGTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 02:19:04 -0400
Subject: Re: [RFC PATCH v2 0/7] Tunable sched_mc_power_savings=n
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <20080909012039.GO14481@linux-os.sc.intel.com>
References: <20080908131334.3221.61302.stgit@drishya.in.ibm.com>
	 <1220880346.12278.17.camel@twins.programming.kicks-ass.net>
	 <20080908134843.GA4053@dirshya.in.ibm.com>
	 <1220882169.12278.23.camel@twins.programming.kicks-ass.net>
	 <20080909012039.GO14481@linux-os.sc.intel.com>
Content-Type: text/plain
Date: Tue, 09 Sep 2008 08:18:17 +0200
Message-Id: <1220941097.18239.927.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-08 at 18:20 -0700, Suresh Siddha wrote:
> On Mon, Sep 08, 2008 at 06:56:09AM -0700, Peter Zijlstra wrote:
> > On Mon, 2008-09-08 at 19:18 +0530, Vaidyanathan Srinivasan wrote:
> > > * Peter Zijlstra <a.p.zijlstra@chello.nl> [2008-09-08 15:25:46]:
> > >
> > > > May I again ask to first clean up the current power saving code before
> > > > stacking more on top of it?
> > >
> > > :) I understand that you have asked for two things with respect to the
> > > current power save balance code:
> > >
> > > 1. Detailed documentation
> > 
> > Preferably in the form of in-code comments and code structure, this
> > Documentation/* stuff always gets lost on me.
> 
> Peter, Almost every if() stmt/basic block  in the power savings code has
> comments around it. And also power-savings code is 50 lines (mostly comments)
> in 320 lines of that function.

Sure, and those comments only tell me what it does, not why it does it.
Also, 1/6-th is still a significant amount.

> > But I also prefer to get rid of that power savings tweak in
> > cpu_coregroup_map().
> 
> Why? Based on the power vs perf, we wanted to construct topologies
> differently. Reason for the complexity is, in some of the Intel cpu's,
> while the cores share the same package they have different last level caches.
> So for performance, we want to differentiate based on last level caches
> and for power, we want to consolidate based on the package information.

But then why not add a domain level that represents the packages and
power schedule on that? That way you dont have to change the domain
structure depending on the load balance goals.

Also, that justification is just wrong - AMD has similar constructs in
its cpus, and god knows what other architectures do, so hiding this in
arch/x86 is wrong too.

> > But above all, readable code ;-)
> > 
> > find_busiest_group() is the stuff of nightmares.
> 
> power-savings code is very small part of that nightmare :) That code
> became complex over years with HT, smp-nice etc.

Yes I understand, but we really need to do something about it - and
everybody with interests in it should be looking at ways to reduce the
nightmare, not add to it.

> I haven't been following recent sched changes. I can take a look at it
> and see what I can do to better organize find_busiest_group()

You and me both then :-)

I've been looking at the history of that function - it started out quite
readable - but has, over the years, grown into a monstrosity.

One of the things I'm currently looking at is getting rid of the
small_imbalance stuff - that made sense when we balanced based on
nr_running, but now that we're weight based and willing to over-balance
a little I'm not sure that it still does.

Also, it looks to me that Christoph Lameters fix
0a2966b48fb784e437520e400ddc94874ddbd4e8 introduced a bug. By skipping
the cpu in the group accumulation the group average computation below
needs to be adjusted, because it uses the group power stuff, which
assumes all cpus contributed.

Then there is this whole sched_group stuff, which I intent to have a
hard look at, afaict its unneeded and we can iterate over the
sub-domains just as well.

Finally, we should move all this stuff into sched_fair and get rid of
that iterator interface and fix up all nr_running etc.. usages to refer
to cfs.nr_running and similar.

Then there is the idea Andi proposed, splitting up the performance and
power balancer into two separate functions, something that is worth
looking into imho.

