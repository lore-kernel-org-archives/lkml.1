Return-Path: <linux-kernel-owner+w=401wt.eu-S1755644AbYLEIIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbYLEIIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbYLEIIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:08:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34176 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbYLEIIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:08:42 -0500
Date: Fri, 5 Dec 2008 09:08:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
Message-ID: <20081205080813.GA2030@elte.hu>
References: <20081204225345.654705757@linutronix.de> <18744.29747.728320.652642@cargo.ozlabs.ibm.com> <20081205063131.GB12785@elte.hu> <18744.56857.259756.129894@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18744.56857.259756.129894@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> > 
> > * Paul Mackerras <paulus@samba.org> wrote:
> [snip]
> > > One thing that this sort of thing can't do is to get values from 
> > > multiple counters that correlate with each other.  For instance, we 
> > > would often want to count, say, L2 cache misses and instructions 
> > > completed at the same time, and be able to read both counters at very 
> > > close to the same time, so that we can measure average L2 cache misses 
> > > per instruction completed, which is useful.
> > 
> > This can be done in a very natural way with our abstraction, and the 
> > "hello.c" example happens to do exactly that:
> 
> Has hello.c been posted?  I can't find it in any of the posts from you 
> or Thomas.  Am I just being blind? :)

Sorry, was late at night when we did the release - monitor.c was posted - 
and i just posted hello.c it half an hour ago :)

> >   aldebaran:~/perf-counter-test> ./hello
> >   doing perf_counter_open() call:
> >   counter[0]... fd: 3.
> >   counter[1]... fd: 4.
> >   counter[0] delta: 10866 cycles
> >   counter[1] delta: 414 cycles
> >   counter[0] delta: 23640 cycles
> >   counter[1] delta: 3673 cycles
> >   counter[0] delta: 28225 cycles
> >   counter[1] delta: 3695 cycles
> > 
> > This counts cycles executed and instructions executed, and reads the two 
> > counters out at the same time.
> 
> Isn't it two separate read() calls to read the two counters?  If so, 
> the only way the two values are actually going to correspond to the 
> same point in time is if the task being monitored is stopped.  In which 
> case the monitoring task needs to use ptrace or something similar in 
> order to make sure that the monitored task is actually stopped.

It doesnt matter in practice.

Also, look at our code: we buffer notification events and do not have to 
stop the thread for recording the context information.

Also, if you _do_ care about getting immediate readouts, the _monitoring_ 
task can be set to higher priority. (not that i'd advocate it in general: 
any task stopping or scheduling can destroy a workload's true behavior)

> If the monitored task is not stopped, then the interval between the two 
> reads will be sufficient to render the results useless - particularly 
> since the monitoring task could get preempted for an arbitrary length 
> of time between the two reads.  But even if it doesn't, the hundreds of 
> cycles between the two reads will introduce considerable imprecision in 
> the results.

Even if the two read()s are done apart, stopping a task is _far_ more 
intrusive to the event flow of a single application. Most workloads are 
multithreaded - so stopping a task causes another task to be scheduled 
in, which would not have occured were the profiling more transparent and 
less intrusive.

Furthermore, even for the special case of single task monitoring, a 
context-switch is more expensive than a system call.

Furthermore, in most of the practical cases there's very few events 
happening between two read()s. The interval of profiling versus the 
interval between two reads()s is a couple of orders of magnitude.

This 'task has to be stopped' aspect is a red herring that has no 
technical basis.

> There really is value in being able to read all the counters you're 
> using in one system call.

It's possible with our code too: what you are asking for is in essence a 
sys_read_fds() system call extension - a bit like readv(), but from a 
vector of separate fds.

Such kind of 'group system call facility' has been suggested several 
times in the past - but ... never got anywhere because system calls are 
cheap enough, it really does not count in practice.

It could be implemented, and note that because our code uses a proper 
Linux file descriptor abstraction, such a sys_read_fds() facility would 
help _other_ applications as well, not just performance counters.

But it brings complications: demultiplexing of error conditions on 
individual counters is a real pain with any compound abstraction. We very 
consciously went with the 'one fd, one object, one counter' design.

	Ingo
