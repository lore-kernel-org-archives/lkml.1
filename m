Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYIIH7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYIIH7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756626AbYIIH7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:59:33 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:27090 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756581AbYIIH7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:59:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=hEyMguZwJ/U7+HNx55VjXWclHM77bj4EY1znMMTyl1A/Uc6VtkRZZfyMVqclBJQhJPnNM1e1EbNqweARWEidh9x7RsJffvLkNvpv86StHnuGUpo2LTWIC3Z76RvajlXpa0CTnQn4UXbgaSPpRZ8JrdSr3FvdIvYX2sjgoKiFTUI=  ;
X-YMail-OSG: zhIfxgkVM1lY4NgfeBZQQrkxaREThq9u3AmWDaTNH7PzGGIyAJFpQWNldl1dhPh3S8p3y2eJjX0JB3maGOF2UO80Y2H2UbMvbxVXqkLy2VJN9bYY57tpJWOdDi8sgXX.9v0-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH v2 0/7] Tunable sched_mc_power_savings=n
Date: Tue, 9 Sep 2008 17:59:12 +1000
User-Agent: KMail/1.9.5
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
References: <20080908131334.3221.61302.stgit@drishya.in.ibm.com> <200809091631.48820.nickpiggin@yahoo.com.au> <1220943240.18239.977.camel@twins.programming.kicks-ass.net>
In-Reply-To: <1220943240.18239.977.camel@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091759.13327.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 16:54, Peter Zijlstra wrote:
> On Tue, 2008-09-09 at 16:31 +1000, Nick Piggin wrote:
> > On Tuesday 09 September 2008 16:18, Peter Zijlstra wrote:
> > > I've been looking at the history of that function - it started out
> > > quite readable - but has, over the years, grown into a monstrosity.
> >
> > I agree it is terrible, and subsequent "features" weren't really properly
> > written or integrated into the sched domains idea.
> >
> > > Then there is this whole sched_group stuff, which I intent to have a
> > > hard look at, afaict its unneeded and we can iterate over the
> > > sub-domains just as well.
> >
> > What sub-domains? The domains-minus-groups are just a graph (in existing
> > setup code AFAIK just a line) of cpumasks. You have to group because you
> > want enough control for example not to pull load from an unusually busy
> > CPU from one group if it's load should actually be spread out over a
> > smaller domain (ie. probably other CPUs within the group we're looking
> > at).
> >
> > It would be nice if you could make it simpler of course, but I just don't
> > understand you or maybe you thought of some other way to solve this or
> > why it doesn't matter...
>
> Right, I get the domain stuff - that's good stuff.
>
> But, let my try and confuse you with ASCII-art ;-)
>
>              Domain [0-7]
>        group [0-3]  group [4-7]
>
>      Domain [0-3]
>   group[0-1]  [group2-3]
>
> Domain [0-1]
> group 0 group 1
>
> (right hand side not drawn due to lack of space etc...)
>
> So we have this tree of domains, which is cool stuff. But then we have
> these groups in there, which closely match up with the domain's child
> domains.

But it's all per-cpu, so you'd have to iterate down other CPU's child
domains. Which may get dirtied by that CPU. So you get cacheline
bounces.

You also lose flexibility (although nobody really takes full advantage
of it) of totally arbitrary topology on a per-cpu basis.


> So my idea was to ditch the groups and just iterate over the child
> domains.

I'm not saying you couldn't do it (reasonably well -- cacheline bouncing
might be a problem if you propose to traverse other CPU's domains), but
what exactly does that gain you?


> > > Finally, we should move all this stuff into sched_fair and get rid of
> > > that iterator interface and fix up all nr_running etc.. usages to refer
> > > to cfs.nr_running and similar.
> > >
> > > Then there is the idea Andi proposed, splitting up the performance and
> > > power balancer into two separate functions, something that is worth
> > > looking into imho.
> >
> > That's what *I* suggested. Before it even went in. Of course there was no
> > attempt made at all and it went in despite my reservations, but what's
> > new
> >
> > :)
>
> Even more reason to make it happen.

Yes it would be great if it happens.
