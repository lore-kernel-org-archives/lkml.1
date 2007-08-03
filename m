Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbXHCE4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbXHCE4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 00:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbXHCE4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 00:56:10 -0400
Received: from 1wt.eu ([62.212.114.60]:1106 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbXHCE4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 00:56:09 -0400
Date: Fri, 3 Aug 2007 06:53:22 +0200
From: Willy Tarreau <w@1wt.eu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>,
       Roman Zippel <zippel@linux-m68k.org>, Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070803045321.GB6002@1wt.eu>
References: <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net> <Pine.LNX.4.64.0708010439050.1817@scrub.home> <20070801112229.GA11710@elte.hu> <20070803030436.GO11166@waste.org> <1186113467.3996.0.camel@laptopd505.fenrus.org> <20070803041808.GA6002@1wt.eu> <1186115480.3996.2.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186115480.3996.2.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 09:31:19PM -0700, Arjan van de Ven wrote:
> On Fri, 2007-08-03 at 06:18 +0200, Willy Tarreau wrote:
> > On Thu, Aug 02, 2007 at 08:57:47PM -0700, Arjan van de Ven wrote:
> > > On Thu, 2007-08-02 at 22:04 -0500, Matt Mackall wrote:
> > > > On Wed, Aug 01, 2007 at 01:22:29PM +0200, Ingo Molnar wrote:
> > > > > 
> > > > > * Roman Zippel <zippel@linux-m68k.org> wrote:
> > > > > 
> > > > > > [...] e.g. in this example there are three tasks that run only for 
> > > > > > about 1ms every 3ms, but they get far more time than should have 
> > > > > > gotten fairly:
> > > > > > 
> > > > > >  4544 roman     20   0  1796  520  432 S 32.1  0.4   0:21.08 lt
> > > > > >  4545 roman     20   0  1796  344  256 R 32.1  0.3   0:21.07 lt
> > > > > >  4546 roman     20   0  1796  344  256 R 31.7  0.3   0:21.07 lt
> > > > > >  4547 roman     20   0  1532  272  216 R  3.3  0.2   0:01.94 l
> > > > > 
> > > > > Mike and me have managed to reproduce similarly looking 'top' output, 
> > > > > but it takes some effort: we had to deliberately run a non-TSC 
> > > > > sched_clock(), CONFIG_HZ=100, !CONFIG_NO_HZ and !CONFIG_HIGH_RES_TIMERS.
> > > > 
> > > > ..which is pretty much the state of play for lots of non-x86 hardware.
> > > 
> > > question is if it's significantly worse than before. With a 100 or
> > > 1000Hz timer, you can't expect perfect fairness just due to the
> > > extremely rough measurement of time spent...
> > 
> > Well, at least we're able to *measure* that task 'l' used 3.3% and
> > that tasks 'lt' used 32%.
> 
> It's not measured if you use jiffies level stuff. It's at best sampled!

But if we rely on the same sampling method, at least we will report
something consistent with what happens. And sampling is often the
correct method to get finer resolution on a macroscopic scale.

I mean, we're telling users that we include the "completely fair scheduler"
in 2.6.23, a scheduler which will ensure that all tasks get a fair share of
CPU time. A user starts top and sees 33%+32%+32+3% for 4 tasks while he
would have expected to see 25%+25%+25%+25%. You can try to explain users
that it's the fairest distribution, but they will have a hard time believing
it, especially when they measure the time spent on CPU with the "time"
command. OK this is all sampling, but we should try to avoid relying on
different sources of data for computation and reporting. Time and Top
should report something close to 4*25% for comparable tasks. And if not,
because of some sampling problem, maybe the scheduler cannot be that fair
in some situations, but either it should make use of the sampling time
and top use, or top and time should rely on the view of the scheduler.

I'll try to quickly hack up a program which makes use of rdtsc from
userspace to precisely measure user-space time, and disable TSC use
from the kernel to see how the values diverge.

Regards,
Willy

