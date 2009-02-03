Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbZBCQxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbZBCQxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZBCQxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:53:10 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55739 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbZBCQxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:53:09 -0500
In-Reply-To: <1233606782.10184.4.camel@laptop>
Subject: Re: Performance counter API review was [patch] Performance Counters for
 Linux, v3
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Veen <arjan@infradead.org>, Carl Love <carll@us.ibm.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, Peter Anvin <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Robert Richter <robert.richter@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFE9E8DD82.D93054FC-ON86257552.0051C2AC-86257552.005CBF59@us.ibm.com>
From: Maynard Johnson <mpjohn@us.ibm.com>
Date: Tue, 3 Feb 2009 10:53:02 -0600
X-MIMETrack: Serialize by Router on d27ml103/27/M/IBM(Release 8.0.2FP1|January 12, 2009) at
 02/03/2009 10:53:03 AM
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> wrote on 02/02/2009 02:33:01 PM:

> On Mon, 2009-02-02 at 12:03 -0800, Corey Ashford wrote:
> > Andi Kleen wrote:
> > [snip]
> > > - Global tracing. Right now there seem to be two modi: per task and
> > > per CPU. But a common variant is global tracing of all CPUs. While
this
> > > could be in theory done right now by attaching to each CPU
> > > this has the problem that it doesn't interact very well with CPU
> > > hot plug. The application would need to poll for additional/lost
> > > CPUs somehow and then re-attach to them (or detach). This would
> > > likely be quite clumsy and slow. It would be better if the
> kernel supported
> > > that better.
> > >
> > > Or alternative here is to do nothing and keep oprofile for that job
> > > (which it doesn't do that badly)
> > >
> >
> > This issue is of particular interest to us, from the IBM Power
toolchain
> > perspective.
> >
> > Ingo, do you think it would be feasible to add an ability to open a
> > single file descriptor that could give global counting (and sampling)
on
> > all CPU's?  I realize this would entail creating a context per cpu in
> > the kernel.
> >
> > How to present the count data back to user space is another issue.  For

> > example, do you sum the counts of a particular event type across all
> > CPUs or do you keep them separate, and have the user space app read
them
> > up per-cpu  (perhaps not knowing exactly which cpu they come from)?
> >
> > I realize that perfmon doesn't have this ability either, it's currently

> > per-cpu as well for global counting.
> >
> > But it seems as long as you are going so far as providing a thread
> > inheritance feature (which I assume uses a summing approach for
> > providing counts back to user space), that this "pan-cpu" counting
> > feature might not be too difficult to implement.  It sure would
simplify
> > the life of user space apps, as Andi said.
>
> Doing a single fd for all cpus is going to suck chunks because its going
> to be a global serialization point.
Right, a single fd is probably not the way to go, since some users are
going to want to see per-cpu counts.  The user tool can do the accumulation
for global counts.  However, expecting the user tool to manage the opening
of per-cpu fds is less than ideal for several reasons, as has already been
stated by others.

I suggest allowing cpu=-1 and pid=-1 to be passed on the perf_counter_open
call (which should require root authority for security reasons -- as does
cpu=<cpu#> and pid=-1).  With such a capability, the OProfile kernel driver
code could be re-written on top of PCL instead of continuing to maintain so
much processor-specific code (which no doubt would duplicate a lot of
processor-specific PCL code).  And, of course, this capability could be
used by other performance tools, as well.
>
> Also, why would you be profiling while doing a hotplug? Both cpu
> profiling, and hotplug, are administrator operations, just don't do
> that.
Surely you jest.  Profiling, an administrator operation?  Maybe on your
laptop.

-Maynard
>
> The inheritance thing will also suffer this issue, if you're going to do
> reads of your fds at any other point than at the end -- it will have to
> walk the whole inheritance tree and sum all the values (or propagate
> interrupts up the tree). Which sounds rather expensive.
>
>
>

