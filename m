Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbZCUB17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbZCUB17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 21:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbZCUB1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 21:27:49 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49414 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbZCUB1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 21:27:48 -0400
Date: Fri, 20 Mar 2009 18:27:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: dipankar@in.ibm.com, linux-input@vger.kernel.org,
       dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Question about usage of RCU in the input layer
Message-ID: <20090321012746.GM6698@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090318215812.15496a86@infradead.org> <20090319085628.GA6167@in.ibm.com> <20090319071841.63334eff@infradead.org> <20090320020750.GA6807@linux.vnet.ibm.com> <20090319202032.4c971d92@infradead.org> <20090320044541.GE6807@linux.vnet.ibm.com> <20090320065058.65d01771@infradead.org> <20090320143104.GA6698@linux.vnet.ibm.com> <20090320111354.679ab53d@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320111354.679ab53d@infradead.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 11:13:54AM -0700, Arjan van de Ven wrote:
> On Fri, 20 Mar 2009 07:31:04 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > > 
> > > that'd be throwing out the baby with the bathwater... I'm trying to
> > > use the other cpus to do some of the boot work (so that the total
> > > goes faster); not using the other cpus would be counter productive
> > > to that. (As is just sitting in synchronize_rcu() when the other
> > > cpu is working.. hence this discussion ;-)
> > 
> > OK, so you are definitely running multiple CPUs when the offending
> > synchronize_rcu() executes, then?
> 
> absolutely. 
> (and I'm using bootgraph.pl in scripts to track who's stalling etc)
> > 
> > If so, here are some follow-on questions:
> > 
> > 1.	How many synchronize_rcu() calls are you seeing on the
> > 	critical boot path
> 
> I've seen only this (input) one to take a long time

Ouch!!!  A -single- synchronize_rcu() taking a full second???  That
indicates breakage.

> >  and what value of HZ are you running?
> 
> 1000

K, in absence of readers for RCU_CLASSIC, we should see a handful
of milliseconds for synchronize_rcu().

> > 	If each synchronize_rcu() is taking (say) tens of jiffies,
> > then, as Peter Zijlstra notes earlier in this thread, we need to focus
> > 	on what is taking too long to get through its RCU read-side
> > 	critical sections
> 
> I know that "the other guy" is not optimal and takes waaay too long.

That could explain why Peter focused on this case.  ;-)

> >  Otherwise, if each synchronize_rcu() is
> > 	in the 3-5 jiffy range, I may finally be forced to create an
> > 	expedited version of the synchronize_rcu() API.
> 
> I think a simplified API for the "add to a list" case might make sense.
> Because the request isn't for a full sync for sure...
> 
> (independent of that .. the open question is if this specific case is
> even needed; I think the code confused "send to others" with "wait
> until everyone sees"; afaik synchronize_rcu() has no pushing behavior
> at all, nor should it)

Quite possibly, perhaps Dmitry will come up with something.

> > 2.	If expediting is required, then the code calling
> > synchronize_rcu() might or might not have any idea whether or not
> > expediting is appropriate.  If it does not, then we would need some
> > sort of way to tell synchronize_rcu() that it should act more
> > aggressively, perhaps /proc flag or kernel global variable indicating
> > that boot is in progress.
> > 
> > 	No, we do not want to make synchronize_rcu() aggressive all
> > the time, as this would harm performance and energy efficiency in
> > 	the normal runtime situation.
> > 
> > 	So, if it turns out that synchronize_rcu()'s caller does not
> > 	know whether or not expediting is appropriate, can the boot
> > path manipulate such a flag or variable?
> > 
> > 3.	Which RCU implementation are you using?  CONFIG_CLASSIC_RCU,
> > 	CONFIG_TREE_RCU, or CONFIG_PREEMPT_RCU?
> 
> CLASSIC

OK, it usually has the fastest synchronize_rcu() at the moment, though
I will be giving TREE_RCU some more help.

Sounds like I should hold off in favor of Dmitry's and Peter's efforts.

							Thanx, Paul
