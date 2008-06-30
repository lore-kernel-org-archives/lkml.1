Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbYF3HRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbYF3HRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 03:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYF3HRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 03:17:31 -0400
Received: from gpo5.cc.swin.edu.au ([136.186.1.225]:49178 "EHLO swin.edu.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752035AbYF3HR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 03:17:29 -0400
X-Greylist: delayed 2146 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jun 2008 03:17:29 EDT
Date: Mon, 30 Jun 2008 15:55:40 +1000 (EST)
From: Tim Connors <tconnors@astro.swin.edu.au>
X-X-Sender: tconnors@pentane.ssi.swin.edu.au
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
cc: David Collier-Brown <davecb@sun.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <peterz@infradead.org>, dipankar@in.ibm.com,
       balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
In-Reply-To: <20080630043327.GA6276@dirshya.in.ibm.com>
Message-ID: <Pine.LNX.4.61.0806301539380.3549@pentane.ssi.swin.edu.au>
References: <4863AF57.3040005@linux.vnet.ibm.com> <4863DB29.1020304@firstfloor.org>
 <20080626185254.GA12416@dirshya.in.ibm.com> <4863F93C.9040102@firstfloor.org>
 <20080626210025.GB26167@in.ibm.com> <48640C04.9020600@firstfloor.org>
 <1214516584.12265.10.camel@twins.programming.kicks-ass.net>
 <48641A7D.6080204@firstfloor.org> <12146282628495-twc@hexane.ssi.swin.edu.au>
 <4867CE52.8040204@sun.com> <20080630043327.GA6276@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008, Vaidyanathan Srinivasan wrote:

> * David Collier-Brown <davecb@sun.com> [2008-06-29 14:02:58]:
> 
> > Andi Kleen <andi@firstfloor.org> said on Fri, 27 Jun 2008 00:38:53 +0200:
> >>> Peter Zijlstra wrote:
> >>>>> And your workload manager could just nice processes. It should probably
> >>>>> do that anyways to tell ondemand you don't need full frequency.
> >>>>
> >>>> Except that I want my nice 19 distcc processes to utilize as much cpu as
> >>>> possible, but just not bother any other stuff I might be doing...
> >>>
> >>> They already won't do that if you run ondemand and cpufreq. It won't
> >>> crank up the frequency for niced processes.
> >
> >
> > Tim Connors then wrote:
> >> Shouldn't there be a powernice, just as there is an ionice and a nice?
> > Hmmn, how about:
> >
> > User Commands                                             nice(1)
> >
> > NAME
> >     nice - invoke a command with an altered  priority
> >
> > SYNOPSIS
> >     /usr/bin/nice [-increment | -n increment]  [-s|-i|-e|-p] command  [argu-
> >     ment...]
> >
> > DESCRIPTION
> >     The nice utility invokes command, requesting that it be  run
> >     with a different  priority.  If -i is specified, the priority
> >     of (disk) I/O is modified. If -e is specified, ethernet (or
> >     other networking) priority is changed. If -p is specified, power
> >     usage priority is changed and if  -s is specified, or none of -1, 
                                                                   -i ^^^
> > -e or -p  is specified, then system scheduling priority
> >     is modified...
> 
> This is good.  We are exploring powernice.  'Generally' cpu, io and
> power nice values should be similar: high or low.  Can we comeup with
> use cases where we want to have conflicting nice values for cpu, io
> and power?
> 
>                 CPU     IO      POWER
> distcc:         low     low     low
> firefox:        low     high    high
> ssh/shell:      high    high    high       
> X:              high    high    low

What's "high" mean?  High priority, or high niceness?

Looks like you're referring to priority there.  Although, if those are 
real examples, then it demonstrates why different people would set 
different priororities (I's say firefox would be both high CPU and power 
nice).

distcc wants to be high CPU "nice" (low CPU priority - let other desktop 
etc things get done first).  But low niceness for power and probably io 
(get it over and done with sooner, and IO traffic is burst, so won't 
interfere so much with other IO).

> How should we interpret the POWER parameter in a datacenter with power
> constraint as mentioned in this thread?  Or in a simple case of AC vs
> battery in a laptop.

On laptop battery, background tasks like firefox redrawing crappy 
animations -- high power nice, high cpu nice (ie, if it was the only thing 
running, and it still wanted to chew 100% cpu, it'll only be chewing 
850MHz of 100% cpu on my Core2 Duo).  My shell though, will be running at 
the default io=cpu=power nice of 0. 

Datacentre running with little loading because it's approaching midnight 
localtime, so lets run the general background tasks at high power nice, 
medium cpu nice, medium IO nice.  During peak times, the main transaction 
tasks running at low power nice, low cpu and low io nice, will be busy, 
and so the cpus all go up a notch or three.  It's not just a matter of 
installing powersaved and saying "performance" vs "ondemand", at various 
times of the day, because it's better to adjust dynamically based on real 
load.

-- 
Tim Connors

