Return-Path: <linux-kernel-owner+w=401wt.eu-S1764222AbXK3EeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764222AbXK3EeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 23:34:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756775AbXK3Edx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 23:33:53 -0500
Received: from mga05.intel.com ([192.55.52.89]:41405 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754865AbXK3Edw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 23:33:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,231,1194249600"; 
   d="scan'208";a="408727505"
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200711301429.15664.nickpiggin@yahoo.com.au>
References: <1196155985.25646.31.camel@ymzhang>
	 <200711301346.22573.nickpiggin@yahoo.com.au>
	 <1196392527.25646.65.camel@ymzhang>
	 <200711301429.15664.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=utf-8
Date: Fri, 30 Nov 2007 12:32:09 +0800
Message-Id: <1196397129.25646.78.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-30 at 14:29 +1100, Nick Piggin wrote:
> On Friday 30 November 2007 14:15, Zhang, Yanmin wrote:
> > On Fri, 2007-11-30 at 13:46 +1100, Nick Piggin wrote:
> > > On Wednesday 28 November 2007 09:57, Arjan van de Ven wrote:
> 
> > > > sounds like a bad idea; volanomark (well, technically the jvm behind
> > > > it) is abusing sched_yield() by assuming it does something it really
> > > > doesn't do, and as it happens some of the earlier 2.6 schedulers
> > > > accidentally happened to behave in a way that was nice for this
> > > > benchmark.
> > >
> > > OK, why is this still happening? Haven't we been asking JVMs to use
> > > futexes or posix locking for years and years now? Are there any sane
> > > jvms that _don't_ use yield?
> >
> > I think it's an issue of volanomark (a kind of java application) instead of
> > JVM.
> 
> volanomark itself and not the jvm is calling sched_yield()? Do we have
> any non-toy threaded java apps? (what's JAVA in the kernel-perf tests?)
I run lots of well-known benchmarks and volanoMark is the one who gets the largest
impact from sched_yield.

As for real-applications which use sched_yield, mostly, they are not open sources.
Yesterday, I got to know someone was using sched_yield in his network C programs,
but he didn't want to share the sources with me.

> 
> 
> > > > Todays kernel has a different behavior somewhat (and before people
> > > > scream "regression"; sched_yield() behavior isn't really specified and
> > > > doesn't make any sense at all, whatever you get is what you get....
> > > > it's pretty much an insane defacto behavior that is incredibly tied to
> > > > which decisions the scheduler makes how, and no app can depend on that
> > >
> > > It is a performance regression. Is there any reason *not* to use the
> > > "compat" yield by default?
> >
> > There is no, so I suggest to set sched_compat_yield=1 by default.
> > If sched_compat_yield=0, kernel almost does nothing but returns. When
> > sched_compat_yield=1, it is closer to the meaning of sched_yield man page.
> 
> sched_yield() is really only defined for posix realtime scheduling
> AFAIK, which talks about priority lists. 
> 
> SCHED_OTHER is defined to be a single priority, below the rest of the
> realtime priorities. So at first you *might* say that the process
> should then be made to run only after all other SCHED_OTHER processes,
> however there is no such ordering requirement for SCHED_OTHER
> scheduling. The SCHED_OTHER scheduler can run any task at any time.
> 
> That said, I think people would *expect* that call be much closer to
> the compat behaviour than the current default. And that's definitely
> what Linux has done in the past. So there really does need to be a
> good reason to change it like this IMO.
That's indeed what I am thinking.

I am running many testing(SPECjbb/SPECjbb2005/cpu2000/iozone/dbench/tbench...) to 
see if there is any regression if sched_compat_yield=1. I think there is no
regression and the testing is just to double-check.

> 
> 
> > > As you say, for SCHED_OTHER tasks, yield
> > > can do almost anything. We may as well do something that isn't a
> > > regression...
> >
> > I just found SCHED_OTHER in man sched_setscheduler. Is it SCHED_NORMAL in
> > the latest kernel?
> 
> Yes, SCHED_NORMAL is SCHED_OTHER. Don't know why it got renamed...
Thanks.
