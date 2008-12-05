Return-Path: <linux-kernel-owner+w=401wt.eu-S1755014AbYLEIPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbYLEIPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbYLEIPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:15:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51067
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750720AbYLEIPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:15:20 -0500
Date: Fri, 05 Dec 2008 00:15:20 -0800 (PST)
Message-Id: <20081205.001520.79526444.davem@davemloft.net>
To: mingo@elte.hu
Cc: paulus@samba.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       eranian@googlemail.com, dada1@cosmosbay.com, robert.richter@amd.com,
       arjan@infradead.org, hpa@zytor.com, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081205080813.GA2030@elte.hu>
References: <20081205063131.GB12785@elte.hu>
	<18744.56857.259756.129894@cargo.ozlabs.ibm.com>
	<20081205080813.GA2030@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 5 Dec 2008 09:08:13 +0100

> 
> * Paul Mackerras <paulus@samba.org> wrote:
> 
> > Ingo Molnar writes:
> > > 
> > > * Paul Mackerras <paulus@samba.org> wrote:
> > [snip]
> > > > One thing that this sort of thing can't do is to get values from 
> > > > multiple counters that correlate with each other.  For instance, we 
> > > > would often want to count, say, L2 cache misses and instructions 
> > > > completed at the same time, and be able to read both counters at very 
> > > > close to the same time, so that we can measure average L2 cache misses 
> > > > per instruction completed, which is useful.
> > > 
> > > This can be done in a very natural way with our abstraction, and the 
> > > "hello.c" example happens to do exactly that:
> > 
> > Has hello.c been posted?  I can't find it in any of the posts from you 
> > or Thomas.  Am I just being blind? :)
> 
> Sorry, was late at night when we did the release - monitor.c was posted - 
> and i just posted hello.c it half an hour ago :)
> 
> > >   aldebaran:~/perf-counter-test> ./hello
> > >   doing perf_counter_open() call:
> > >   counter[0]... fd: 3.
> > >   counter[1]... fd: 4.
> > >   counter[0] delta: 10866 cycles
> > >   counter[1] delta: 414 cycles
> > >   counter[0] delta: 23640 cycles
> > >   counter[1] delta: 3673 cycles
> > >   counter[0] delta: 28225 cycles
> > >   counter[1] delta: 3695 cycles
> > > 
> > > This counts cycles executed and instructions executed, and reads the two 
> > > counters out at the same time.
> > 
> > Isn't it two separate read() calls to read the two counters?  If so, 
> > the only way the two values are actually going to correspond to the 
> > same point in time is if the task being monitored is stopped.  In which 
> > case the monitoring task needs to use ptrace or something similar in 
> > order to make sure that the monitored task is actually stopped.
> 
> It doesnt matter in practice.

Yes it DOES!

If I want to know if a code block triggers event X or Y, and your read
call triggers one of those events, I can't figure out the answer to my
profiling problem.

That is completely fundamental to all of this.  And this is why this
proposal is a non-workable solution.


> Also, look at our code: we buffer notification events and do not have to 
> stop the thread for recording the context information.

But that's what monitoring libraries want, they want to stop the task
and inspect it.

Look at the PAPI library.  If you can't implement what that thing
provides, all the real users of profiling information can't use
this stuff.

> Even if the two read()s are done apart, stopping a task is _far_ more 
> intrusive to the event flow of a single application.

I really don't think you get the use case for these kinds of
facilities.

Once again I encourage you to look at the test programs, test cases,
and wonderful documentation provided with the PAPI and perfmon2
library bits.  That's how people want to use this stuff.  Ignore
at your own peril :-)

