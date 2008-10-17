Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbYJQTSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbYJQTSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 15:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbYJQTR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 15:17:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41892 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbYJQTR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 15:17:58 -0400
X-Greylist: delayed 6760 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2008 15:17:58 EDT
Date: Fri, 17 Oct 2008 15:17:54 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: "Luck, Tony" <tony.luck@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC patch 15/15] LTTng timestamp x86
In-Reply-To: <20081017184215.GB9874@Krystal>
Message-ID: <alpine.DEB.1.10.0810171513480.22097@gandalf.stny.rr.com>
References: <20081016232729.699004293@polymtl.ca> <20081016234657.837704867@polymtl.ca> <alpine.LFD.2.00.0810161701470.3288@nehalem.linux-foundation.org> <20081017012835.GA30195@Krystal> <57C9024A16AD2D4C97DC78E552063EA3532D455F@orsmsx505.amr.corp.intel.com>
 <20081017172515.GA9639@goodmis.org> <57C9024A16AD2D4C97DC78E552063EA3533458AC@orsmsx505.amr.corp.intel.com> <20081017184215.GB9874@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Fri, 17 Oct 2008, Mathieu Desnoyers wrote:

> * Luck, Tony (tony.luck@intel.com) wrote:
> > > I agree that one cache line bouncer is devastating to performance. But
> > > as Mathieu said, it is better than a global tracer with lots of bouncing
> > > going on.
> > 
> > Scale up enough, and it becomes more than just a performance problem.
> > When SGI first tried to boot on 512 cpus they found the kernel hung
> > completely because of a single global atomic counter for how many
> > interrupts there were.  With HZ=1024 and 512 cpus the ensuing cache
> > line bouncing storm from each interrupt took longer to resolve than
> > the interval between interrupts.
> > 
> > With higher event rates (1KHz seems relatively low) this wall will
> > be a problem for smaller systems too.
> > 
> 
> Hrm, on such systems
> - *large* amount of cpus
> - no synchronized TSCs

What about selective counting? Or have counters per nodes? If you are
dealing with a race, most cases, the race is not happening against CPUs
not sharing a node. Those not sharing will try hard not to ever use the
same cache lines.


> 
> What would be the best approach to order events ? Do you think we should
> consider using HPET, event though it's painfully slow ? Would it be
> faster than cache-line bouncing on such large boxes ? With a frequency
> around 10MHz, that would give a 100ns precision, which should be enough
> to order events. However, HPET is known for its poor performances, which
> I doubt will do better than the cache-line bouncing alternative.
> 
> > > ftrace does not have a global counter, but on some boxes with out of
> > > sync TSCs, it could not find race conditions. I had to pull in logdev,
> > > which found the race right away, because of this atomic counter.
> > 
> > Perhaps this needs to be optional (and run-time switchable).  Some
> > users (tracking performance issues) will want the  tracer to have
> > the minumum possible effect on the system.  Others (chasing race
> > conditions) will want the best possible ordering of events between
> > cpus[*].
> > 
> 
> Yup, I think this solution would work. The user could specify the time
> source for a specific set of buffers (a trace) through debugfs files.
> 
> > -Tony
> > 
> > [*] I'd still be concerned that a heavyweight strict ordering might
> > perturb the system enough to make the race disappear when tracing
> > is enabled.
> > 
> 
> Yes, it's true that it may make the race disappear, but what has been
> seen in the field (Steven could confirm that) is that it usually makes
> the race more likely to appear due to an enlarged race window. But I
> guess it all depends on where the activated instrumentation is.

I've seen both. 9 out of 10 times, the tracer helps induce the race. But 
I've had that 1 out of 10 where it makes the race go away.

Actually, what happens is that I'll start adding trace markers (printk 
like traces), and the race will happen quicker. Then I'll add a few more 
markers and the race goes away. Those are the worst ;-)

-- Steve

