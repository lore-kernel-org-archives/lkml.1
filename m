Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbXK0RNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbXK0RNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 12:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756946AbXK0RNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 12:13:32 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:39357 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756091AbXK0RNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 12:13:31 -0500
Date: Tue, 27 Nov 2007 09:13:31 -0800
From: Micah Dowty <micah@vmware.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Kyle Moffett <mrmacman_g4@mac.com>, Cyrus Massoumi <cyrusm@gmx.net>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Mike Galbraith <efault@gmx.de>,
       Paul Menage <menage@google.com>,
       Peter Williams <pwil3058@bigpond.net.au>
Subject: Re: High priority tasks break SMP balancer?
Message-ID: <20071127171331.GA9066@vmware.com>
References: <20071119185116.GA28173@vmware.com> <b647ffbd0711191422q6be59c44gfbc72f0fc3167768@mail.gmail.com> <20071119230516.GC4736@vmware.com> <20071120055755.GE20436@elte.hu> <20071120180643.GD4736@vmware.com> <b647ffbd0711201347tedf7ac0sc6476118353feab3@mail.gmail.com> <20071122074652.GA6502@vmware.com> <b647ffbd0711220453i15e786ubbb02c3431869048@mail.gmail.com> <20071126194412.GC21266@vmware.com> <b647ffbd0711270121v691ec06bjf62166c83929d844@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0711270121v691ec06bjf62166c83929d844@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 10:21:12AM +0100, Dmitry Adamushko wrote:
> On 26/11/2007, Micah Dowty <micah@vmware.com> wrote:
> >
> > The application doesn't really depend on the load-balancer's decisions
> > per se, it just happens that this behaviour I'm seeing on NUMA systems
> > is extremely bad for performance.
> >
> > In this context, the application is a virtual machine runtime which is
> > executing either an SMP VM or it's executing a guest which has a
> > virtual GPU. In either case, there are at least three threads:
> >
> >   - Two virtual CPU/GPU threads, which are nice(0) and often CPU-bound
> >   - A low-latency event handling thread, at nice(-10)
> >
> > The event handling thread performs periodic tasks like delivering
> > timer interrupts and completing I/O operations.
> 
> Are I/O operations initiated by these "virtual CPU/GPU threads"?
> 
> If so, would it make sense to have per-CPU event handling threads
> (instead of one global)? They would handle I/O operations initiated
> from their respective CPUs to (hopefully) achieve better data locality
> (esp. if the most part of the involved data is per-CPU).
> 
> Then let the load balancer to evenly distribute the "virtual CPU/GPU
> threads" or even (at least, as an experiment) fix them to different
> CPUs as well?
> 
> sure, the scenario is highly dependent on a nature of those
> 'events'... and I can just speculate here :-) (but I'd imagine
> situations when such a scenario would scale better).

We already do this when it makes sense to. The high priority "event"
thread is mostly used for asynchronous events- timers (driven by
/dev/rtc), completion of disk or USB I/O, etc. These are things that
happen asynchronously to the virtual CPU, and which may or may not
need to interrupt the virtual CPU at some point.

Another good example is audio. We have another thread (which ideally
is high-priority) which processes audio events asynchronously from the
virtual CPUs. The CPUs manipulate some shared memory to queue up audio
data, but while the audio is playing there is no direct control path
between the two threads. The virtual CPU reads/writes audio registers
whenever it needs to emulate accesses to the audio device, and the
audio thread wakes up any time the hardware needs more samples to
play. The two threads are asynchronous with very little shared
synchronization.

Hopefully that clarifies our situation a bit. Thanks again,
--Micah
