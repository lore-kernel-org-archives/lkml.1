Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbYIIGy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbYIIGy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 02:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbYIIGyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 02:54:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:51395 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbYIIGyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 02:54:49 -0400
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
In-Reply-To: <200809091631.48820.nickpiggin@yahoo.com.au>
References: <20080908131334.3221.61302.stgit@drishya.in.ibm.com>
	 <20080909012039.GO14481@linux-os.sc.intel.com>
	 <1220941097.18239.927.camel@twins.programming.kicks-ass.net>
	 <200809091631.48820.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Tue, 09 Sep 2008 08:54:00 +0200
Message-Id: <1220943240.18239.977.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-09 at 16:31 +1000, Nick Piggin wrote:
> On Tuesday 09 September 2008 16:18, Peter Zijlstra wrote:
> 
> > I've been looking at the history of that function - it started out quite
> > readable - but has, over the years, grown into a monstrosity.
> 
> I agree it is terrible, and subsequent "features" weren't really properly
> written or integrated into the sched domains idea.
> 
> 
> > Then there is this whole sched_group stuff, which I intent to have a
> > hard look at, afaict its unneeded and we can iterate over the
> > sub-domains just as well.
> 
> What sub-domains? The domains-minus-groups are just a graph (in existing
> setup code AFAIK just a line) of cpumasks. You have to group because you
> want enough control for example not to pull load from an unusually busy
> CPU from one group if it's load should actually be spread out over a
> smaller domain (ie. probably other CPUs within the group we're looking at).
> 
> It would be nice if you could make it simpler of course, but I just don't
> understand you or maybe you thought of some other way to solve this or
> why it doesn't matter...

Right, I get the domain stuff - that's good stuff.

But, let my try and confuse you with ASCII-art ;-)

             Domain [0-7]
       group [0-3]  group [4-7]

     Domain [0-3]      
  group[0-1]  [group2-3]

Domain [0-1]
group 0 group 1

(right hand side not drawn due to lack of space etc...)

So we have this tree of domains, which is cool stuff. But then we have
these groups in there, which closely match up with the domain's child
domains.

So my idea was to ditch the groups and just iterate over the child
domains.

> > Finally, we should move all this stuff into sched_fair and get rid of
> > that iterator interface and fix up all nr_running etc.. usages to refer
> > to cfs.nr_running and similar.
> >
> > Then there is the idea Andi proposed, splitting up the performance and
> > power balancer into two separate functions, something that is worth
> > looking into imho.
> 
> That's what *I* suggested. Before it even went in. Of course there was no
> attempt made at all and it went in despite my reservations, but what's new
> :)

Even more reason to make it happen.

