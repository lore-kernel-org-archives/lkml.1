Return-Path: <linux-kernel-owner+w=401wt.eu-S1762125AbZDQS6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762125AbZDQS6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 14:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760072AbZDQS6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 14:58:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:48644 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbZDQS6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 14:58:44 -0400
Subject: Re: Scheduler regression: Too frequent timer interrupts(?)
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0904171410540.28536@qirst.com>
References: <alpine.DEB.1.10.0904161539130.23632@qirst.com>
	 <1239951613.23397.4107.camel@laptop>
	 <alpine.DEB.1.10.0904170941020.11877@qirst.com>
	 <1239977776.23397.4590.camel@laptop>
	 <alpine.DEB.1.10.0904171021360.20239@qirst.com>
	 <1239979901.23397.4638.camel@laptop>
	 <alpine.DEB.1.10.0904171100510.21575@qirst.com>
	 <20090417153520.GA29968@elte.hu>
	 <alpine.DEB.1.10.0904171142050.13734@qirst.com>
	 <1239985426.23397.4757.camel@laptop> <20090417164918.GK8253@elte.hu>
	 <alpine.DEB.1.10.0904171335490.28603@qirst.com>
	 <1239991892.23397.4905.camel@laptop>
	 <alpine.DEB.1.10.0904171410540.28536@qirst.com>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 20:58:39 +0200
Message-Id: <1239994719.23397.4979.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-17 at 14:20 -0400, Christoph Lameter wrote:
> On Fri, 17 Apr 2009, Peter Zijlstra wrote:
> 
> > Something like this is nice to compare between kernels. Chris'
> > suggestion of timing a simple fixed loop:
> >
> > $ time (let i=1000000; while [ $i -gt 0 ]; do let i--; done)
> >
> > real    0m14.389s
> > user    0m13.787s
> > sys     0m0.498s
> >
> > Is also useful, since it gives an absolute measure of time available to
> > user-space.
> >
> > Although I suspect a simple C while(i--); might be better due to less
> > code involved.
> 
> The absolute time available to user space is not that important. It is
> important that the processor stays available during latency critical
> operations and is not taken away by the OS. The intervals that the OS
> takes the processor away determine the mininum interval that the
> application has to react to events (f.e. RDMA transfers via Infiniband,
> or operations on requests coming in via shared memory). These operations
> often must occur in parallel on multiple cores. Processing is delayed if
> any of the cores encounters a delay due to OS noise.

So you have hard deadlines in the order of us? Are these SCHED_FIFO
tasks or SCHED_OTHER?

> The latencytest code simulates a busy processor (no system calls, all
> memory is prefaulted). For some reasons Linux is increasingly taking time
> away from such processes (that intentionally run uncontended on a
> dedicated processor). This causes regressions so that current upstream is
> not usable for these applications.
> 
> It would be best for these applications if the processor would be left
> undisturbed. There is likely not much that the OS needs to do on a busy
> processor if there are no competing threads and if there is no I/O taking
> place.

Agreed -- that would be nice.

I can't really match the pattern to anything. The one thing that worried
me was sched_clock_tick(), which does a GTOD to sync the clocks between
cpus.

Your Xeon is a core2 class machine and should have relatively stable
TSC, however its also a dual socket, which I think defeats the
stable-ness.

What clocksource do you have?

cat /sys/devices/system/clocksource/clocksource0/current_clocksource

Thing is, that doesn't really match the .23 is expensive and .25 isn't.

Also, looking over the rest of the scheduler tick code, I can't really
see what would be so expensive.

