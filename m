Return-Path: <linux-kernel-owner+w=401wt.eu-S1764122AbXK3DQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764122AbXK3DQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 22:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933818AbXK3DQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 22:16:44 -0500
Received: from mga05.intel.com ([192.55.52.89]:13019 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932291AbXK3DQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 22:16:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,231,1194249600"; 
   d="scan'208";a="408661938"
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200711301346.22573.nickpiggin@yahoo.com.au>
References: <1196155985.25646.31.camel@ymzhang>
	 <20071127145747.5f4d0aca@laptopd505.fenrus.org>
	 <200711301346.22573.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=utf-8
Date: Fri, 30 Nov 2007 11:15:27 +0800
Message-Id: <1196392527.25646.65.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-30 at 13:46 +1100, Nick Piggin wrote:
> On Wednesday 28 November 2007 09:57, Arjan van de Ven wrote:
> > On Tue, 27 Nov 2007 17:33:05 +0800
> >
> > "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:
> > > If echo "1">/proc/sys/kernel/sched_compat_yield before starting
> > > volanoMark testing, the result is very good with kernel 2.6.24-rc3 on
> > > my 16-core tigerton.
> > >
> > > 1) If /proc/sys/kernel/sched_compat_yield=1, comparing with 2.6.22,
> > > 2.6.24-rc3 has more than 70% improvement;
> > > 2) If /proc/sys/kernel/sched_compat_yield=0, comparing with 2.6.22,
> > > 2.6.24-rc3 has more than 80% regression;
> > >
> > > On other machines, the volanoMark result also has much improvement if
> > > /proc/sys/kernel/sched_compat_yield=1.
> > >
> > > Would you like to change function yield_task_fair to delete codes
> > > around sysctl_sched_compat_yield, or just initiate it to 1?
> >
> > sounds like a bad idea; volanomark (well, technically the jvm behind
> > it) is abusing sched_yield() by assuming it does something it really
> > doesn't do, and as it happens some of the earlier 2.6 schedulers
> > accidentally happened to behave in a way that was nice for this
> > benchmark.
> 
> OK, why is this still happening? Haven't we been asking JVMs to use
> futexes or posix locking for years and years now? Are there any sane
> jvms that _don't_ use yield?
I think it's an issue of volanomark (a kind of java application) instead of JVM.

> 
> 
> > Todays kernel has a different behavior somewhat (and before people
> > scream "regression"; sched_yield() behavior isn't really specified and
> > doesn't make any sense at all, whatever you get is what you get....
> > it's pretty much an insane defacto behavior that is incredibly tied to
> > which decisions the scheduler makes how, and no app can depend on that
> 
> It is a performance regression. Is there any reason *not* to use the
> "compat" yield by default?
There is no, so I suggest to set sched_compat_yield=1 by default.
If sched_compat_yield=0, kernel almost does nothing but returns. When
sched_compat_yield=1, it is closer to the meaning of sched_yield man page.

> As you say, for SCHED_OTHER tasks, yield
> can do almost anything. We may as well do something that isn't a
> regression...
I just found SCHED_OTHER in man sched_setscheduler. Is it SCHED_NORMAL in
the latest kernel?

> 
> 
> > in any way. In fact, I've proposed to make sched_yield() just do an
> > msleep(1)... that'd be closer to what sched_yield is supposed to do
> > standard wise than any of the current behaviors .... ;_
> 
> What makes you say that? IIRC of all the things that sched_yeild can
> do, it is not allowed to block. So this is about the only thing that
> will break the standard...
