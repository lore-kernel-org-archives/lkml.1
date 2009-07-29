Return-Path: <linux-kernel-owner+w=401wt.eu-S1752745AbZG2I0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbZG2I0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 04:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZG2I0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 04:26:10 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:59766 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbZG2I0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 04:26:08 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC][PATCH 5/5] perfcounter: Add support for kernel hardware
 breakpoints
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: prasad@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <20090729003607.GC5104@nowhere>
References: <c62985530907240702h2b2de14bw2f0d475f46067e4e@mail.gmail.com>
	 <1248445569.6987.74.camel@twins> <20090724174723.GA11985@nowhere>
	 <1248519416.5780.12.camel@laptop> <20090725141918.GA5295@nowhere>
	 <1248538972.5780.25.camel@laptop> <20090725235702.GA5082@in.ibm.com>
	 <1248684817.6987.1573.camel@twins> <20090728010349.GB5147@nowhere>
	 <1248765877.6987.2754.camel@twins>  <20090729003607.GC5104@nowhere>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 10:28:52 +0200
Message-Id: <1248856132.6987.3034.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 02:36 +0200, Frederic Weisbecker wrote:
> On Tue, Jul 28, 2009 at 09:24:37AM +0200, Peter Zijlstra wrote:
> > On Tue, 2009-07-28 at 03:03 +0200, Frederic Weisbecker wrote:
> > > > Thirdly, we can multiplex perf counters beyond their hardware maximum,
> > > > something you simply cannot do for a debug interface.
> > > 
> > > 
> > > Again, I'm stuck in what you mean by multiplexing here :-)
> > 
> > If you'd create say 16 breakpoint counters, we'd RR them over the 4
> > available hardware breakpoints (or less when others are taken by someone
> > else).
> > 
> > Since its all statistics anyway, we can simply scale the event counts up
> > by the time-share they received.
> >
> 
> Aah, ok I understand now.
> But I fear it may kill the accuracy of the breakpoints statistics.
> It's fine for a theoretical linear rate of breakpoint events.
> But what happens if we are profiling something much more unstable
> with a rain of hits in a small window of memory between large timeframes?
> If we have a breakpoint inside this window of memory and this breakpoint
> is not plugged, waiting for its turn in the RR, we loose this rain of events.

You don't have to overload the breakpoint set, but we will if you create
more than there are hardware resources available.

If the RR period is independent of the application and significantly
shorter than the sample duration, statistics will be usable.

Sure, they'll not be perfect, but we can improve our confidence interval
by running longer. At some point it really doesn't matter anymore.

Take your example, of small bursts of events, due to the first
assumption - the RR period being independent of the application - we're
bound to see those busts in a proportional number of sample windows.

If the full sample duration is in the same order of the RR period, then
yes, you'll have a fair chance of missing the burst -- don't do that
then :-)

If you know you'll be running very very short, use attr.pinned, to
request a counter that'll not be multiplexed.



