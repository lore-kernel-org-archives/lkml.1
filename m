Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbYIIIZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbYIIIZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 04:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbYIIIZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 04:25:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:37419 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbYIIIZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 04:25:45 -0400
Subject: Re: [RFC PATCH v2 0/7] Tunable sched_mc_power_savings=n
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>
In-Reply-To: <200809091759.13327.nickpiggin@yahoo.com.au>
References: <20080908131334.3221.61302.stgit@drishya.in.ibm.com>
	 <200809091631.48820.nickpiggin@yahoo.com.au>
	 <1220943240.18239.977.camel@twins.programming.kicks-ass.net>
	 <200809091759.13327.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Tue, 09 Sep 2008 10:25:23 +0200
Message-Id: <1220948723.18239.1091.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-09 at 17:59 +1000, Nick Piggin wrote:
> On Tuesday 09 September 2008 16:54, Peter Zijlstra wrote:
> > On Tue, 2008-09-09 at 16:31 +1000, Nick Piggin wrote:
> > > On Tuesday 09 September 2008 16:18, Peter Zijlstra wrote:
> > > > I've been looking at the history of that function - it started out
> > > > quite readable - but has, over the years, grown into a monstrosity.
> > >
> > > I agree it is terrible, and subsequent "features" weren't really properly
> > > written or integrated into the sched domains idea.
> > >
> > > > Then there is this whole sched_group stuff, which I intent to have a
> > > > hard look at, afaict its unneeded and we can iterate over the
> > > > sub-domains just as well.
> > >
> > > What sub-domains? The domains-minus-groups are just a graph (in existing
> > > setup code AFAIK just a line) of cpumasks. You have to group because you
> > > want enough control for example not to pull load from an unusually busy
> > > CPU from one group if it's load should actually be spread out over a
> > > smaller domain (ie. probably other CPUs within the group we're looking
> > > at).
> > >
> > > It would be nice if you could make it simpler of course, but I just don't
> > > understand you or maybe you thought of some other way to solve this or
> > > why it doesn't matter...
> >
> > Right, I get the domain stuff - that's good stuff.
> >
> > But, let my try and confuse you with ASCII-art ;-)
> >
> >              Domain [0-7]
> >        group [0-3]  group [4-7]
> >
> >      Domain [0-3]
> >   group[0-1]  [group2-3]
> >
> > Domain [0-1]
> > group 0 group 1
> >
> > (right hand side not drawn due to lack of space etc...)
> >
> > So we have this tree of domains, which is cool stuff. But then we have
> > these groups in there, which closely match up with the domain's child
> > domains.
> 
> But it's all per-cpu, so you'd have to iterate down other CPU's child
> domains. Which may get dirtied by that CPU. So you get cacheline
> bounces.

Humm, are you saying each cpu has its own domain tree? My understanding
was that its a global structure, eg. given:

   domain[0-1]

domain[0] domain[1]

cpu0's parent domain is the same instance as cpu1's.

> You also lose flexibility (although nobody really takes full advantage
> of it) of totally arbitrary topology on a per-cpu basis.

Afaict the only flexibility you loose is that you cannot make groups
larger/smaller than the child domain - which given that the whole
premesis of the groups existence is that the inner-group balancing
should be done by the level below - doesn't make sense anyway.

> > So my idea was to ditch the groups and just iterate over the child
> > domains.
> 
> I'm not saying you couldn't do it (reasonably well -- cacheline bouncing
> might be a problem if you propose to traverse other CPU's domains), but
> what exactly does that gain you?

Those cacheline bounces could be mitigated by splitting sched_domain
into two parts with a cacheline aligned dummy and keep the rarely
modified data separate from the frequently modified data.

As to the gains - a graph walk with a single type seems more elegant to
me.

