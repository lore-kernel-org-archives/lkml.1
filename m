Return-Path: <linux-kernel-owner+w=401wt.eu-S1759459AbXHQRLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459AbXHQRLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 13:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbXHQRK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 13:10:57 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59892 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755293AbXHQRK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 13:10:56 -0400
Date: Fri, 17 Aug 2007 12:10:53 -0500
To: Paul Mackerras <paulus@samba.org>
Cc: Michael Neuling <mikey@neuling.org>, Andrew Morton <akpm@osdl.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] Add scaled time to taskstats based process accounting
Message-ID: <20070817171053.GB4261@austin.ibm.com>
References: <20070816070922.37B5370074@localhost.localdomain> <20070816163850.GU4261@austin.ibm.com> <18116.52784.132826.595409@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18116.52784.132826.595409@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2007 at 08:22:40AM +1000, Paul Mackerras wrote:
> Linas Vepstas writes:
> 
> > My gut impression (maybe wrong?) is that the scaled time is,
> > in a certain sense, "more accurate" than the unscaled time.
> 
> The "unscaled" time is just time, as in "how many seconds did this
> task spend on the CPU".  It's what all the tools (except a certain
> proprietary workload manager) expect.  Top, ps, etc. get unhappy if
> the times reported (user, system, hardirq, softirq, idle, stolen)
> don't add up to elapsed wall-clock time.

OK, so to keep the tools happy, the total time needs to add up
to wall-clock time.  Which tells me that the "scaled idle time"
should be defined as "wall clock time minus the other stuff".

> The "scaled" time is really CPU cycles divided by some arbitrary
> factor (the notional CPU frequency).  So yes it does give some
> indication of how much progress the task should have made, in some
> sense.

Yes, good, that's what I was expecting.  As a sysadmin and/or 
back-of-the-envelope performance person, I would certainly like 
to have ps and top report the scaled time. When I do "performance 
tuning", I almost always can get away with quick-n-dirty use of
vmstat and top, and only rarely have to descend into more complex 
tools.  I'd hate to loose this quick-n-dirty utility, which,
again ... my gut impression is that these numbers suddenly turn 
mostly meaningless.

That is, if I run the same task 3 times over the next few hours,
will vmstat/top/ps report more or less he same figures?  I'm 
concerned that they won't ... that I'll see different values
come out, depending on whether the chip is overheating, or whether
some other partition is stealing, or whatever causes this thing to 
dynamically scale.

> Both measures are useful.  Because the current user API is in terms of
> real time rather than cycles, we have to continue reporting real time,
> not scaled time, which is why the existing interfaces report unscaled
> time, and the scaled time values are reported through a new extension
> to the taskstats interface.

This begs the question of "what is the real, actual elapsed time?" 
... currently, the "real time" depends very much on how often your 
process got scheduled -- but, if your process is scheduled but 
(due to scaling) isn't "actually running", should that count towards 
the "real time"?

---
I supose that its inevitable that this stuff will get more complex;
I'm just trying to make sure we don't end up doing this backwards,
and deciding to change it around later.

I already notice that "stolen time" is causing confusion in some 
areas.  Its disconcerting to have lots of cores, and lots of threads
per core, only to find that some of your time has been "stolen".
I'm still wondering ... was this the right way to report this?

--linas
