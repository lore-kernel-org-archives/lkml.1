Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbZGNT3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbZGNT3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 15:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbZGNT3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 15:29:16 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:60630 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520AbZGNT3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 15:29:15 -0400
From: Henrik Austad <henrik@austad.us>
To: "James H. Anderson" <anderson@cs.unc.edu>
Date: Tue, 14 Jul 2009 21:28:47 +0200
User-Agent: KMail/1.9.10
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Chris Friesen <cfriesen@nortel.com>, Raistlin <raistlin@linux.it>,
       Douglas Niehaus <niehaus@ittc.ku.edu>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Thomas Gleixner <tglx@linutronix.de>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>,
       Bjoern Brandenburg <bbb@cs.unc.edu>
References: <200907102350.47124.henrik@austad.us> <1247589099.7500.191.camel@twins> <alpine.LRH.2.00.0907141234280.16818@anderson.cs.unc.edu>
In-Reply-To: <alpine.LRH.2.00.0907141234280.16818@anderson.cs.unc.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907142128.48558.henrik@austad.us>
X-SA-Exim-Connect-IP: 212.251.216.90
X-SA-Exim-Mail-From: henrik@austad.us
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:20:07 +0000)
X-SA-Exim-Scanned: Yes (on asterix.frsk.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 July 2009 18:54:13 James H. Anderson wrote:
> On Tue, 14 Jul 2009, Peter Zijlstra wrote:
> > Hi Jim,
> >
> > On Tue, 2009-07-14 at 11:19 -0400, James H. Anderson wrote:
> >> The first email in this thread that I was cc'ed on talked about
> >> implementing global EDF,
> >
> > Hendrik says that its a modified Modified-Least-Laxity-First, so
> > something like M^2-LLF, and I cc'ed you (and I meant to add Bjorn too,
> > but now see I failed to actually do so) in the hope that you would have
> > some thoughts on his scheduling algorithm, since that is what you do a
> > lot of ;-)
> >
> > It could well be he modified M-LLF into G-EDF, but I'm behind in my
> > reading here, so I'll have to leave that up to others.

Using deadlines as the only measure on multi-core will fail as you must 
consider time (of deadline-miss) in a different way.

In UP, this is given implicitly as you only have a single processor. In MC you 
need to do this the hard way, namely compute the point in time not when the 
task misses the deadline, but when it will *eventually* fail a dealine. By 
doing that, you combine deadline, wcet and granted time in one variable, and 
you have a *single* variable to compare.

By doing this in a global sense, you can avoid bin-packing, load-balancing and 
a lot of the issues that seem to be keeping the PI-people busy. But I think 
I'm going to stay away from that topic now (as I haven't had the time to give 
those emails their deserved attention.

I think M^2-LLF would be as good a name as EFF, but I wanted to emphasize the 
usage of the two failure-variables (the static and the dynamic).

> I meant to say something about this algorithm earlier that may be
> worthwhile.  If I understand Hendrik's algorithm correctly, it falls
> within a class of global schedulers for which bounded deadline
> tardiness is guaranteed (as long as total utilization doesn't exceed
> the system's capacity).  

the tardiness is either 0 or bounded, depending on what you want (and what you 
will do with tasks that do miss their deadlines when they block on locks).

> This follows from results in: 
>
> H. Leontyev and J. Anderson, "Generalized Tardiness Bounds for Global
> Multiprocessor Scheduling",  Proceedings of the 28th IEEE Real-Time
> Systems Symposium, pp. 413-422, December 2007.

Is this available outside locked portals?

> This is a positive thing w.r.t. wanting to support soft real-time
> workloads.  However, global EDF also has this property and (I would
> think) is easier to implement (I'm just guessing here -- we haven't
> actually implemented any algorithm that involves laxities in
> LITMUS^RT).  Ted Baker did some work on an algorithm called EDZL
> (EDF until zero laxity) that is essentially a hybrid of these two
> algorithms.  In simulations we've done (not based on real implementations),
> EDZL exhibits really low tardiness (almost non-existent).  EDZL may
> give you the benefits of using laxities where useful and be easier
> to implement (but that's just my guess)



-- 
     henrik
