Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbXKZToV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbXKZToV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 14:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbXKZToO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 14:44:14 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:50503 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753607AbXKZToN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 14:44:13 -0500
Date: Mon, 26 Nov 2007 11:44:12 -0800
From: Micah Dowty <micah@vmware.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Kyle Moffett <mrmacman_g4@mac.com>, Cyrus Massoumi <cyrusm@gmx.net>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Mike Galbraith <efault@gmx.de>,
       Paul Menage <menage@google.com>,
       Peter Williams <pwil3058@bigpond.net.au>
Subject: Re: High priority tasks break SMP balancer?
Message-ID: <20071126194412.GC21266@vmware.com>
References: <20071117010352.GA13666@vmware.com> <b647ffbd0711171110q9f695e1qb42ba73dc23b626d@mail.gmail.com> <20071119185116.GA28173@vmware.com> <b647ffbd0711191422q6be59c44gfbc72f0fc3167768@mail.gmail.com> <20071119230516.GC4736@vmware.com> <20071120055755.GE20436@elte.hu> <20071120180643.GD4736@vmware.com> <b647ffbd0711201347tedf7ac0sc6476118353feab3@mail.gmail.com> <20071122074652.GA6502@vmware.com> <b647ffbd0711220453i15e786ubbb02c3431869048@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0711220453i15e786ubbb02c3431869048@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

Thank you for the detailed explanation of the scheduler behaviour I've
been seeing.

On Thu, Nov 22, 2007 at 01:53:02PM +0100, Dmitry Adamushko wrote:
> >  - Is there a good way to detect, without any kernel debug flags
> >    set, whether the current machine has any scheduling domains
> >    that are missing the SD_BALANCE_NEWIDLE bit?
> 
> e.g. by reading its config and kernel version. But as a generic way
> (sort of API for user-space), I guess, no.

Would it be reasonable perhaps to look for the numa_* entries in
/proc/zoneinfo, vmstat, or slabinfo?

> > I'm looking for
> >    a good way to work around the problem I'm seeing with VMware's
> >    code. Right now the best I can do is disable all thread priority
> >    elevation when running on an SMP machine with Linux 2.6.20 or
> >    later.
> 
> why are your application depends on the load-balancer's decisions?
> Maybe it's just smth wrong with its logic instead? :-/

The application doesn't really depend on the load-balancer's decisions
per se, it just happens that this behaviour I'm seeing on NUMA systems
is extremely bad for performance.

In this context, the application is a virtual machine runtime which is
executing either an SMP VM or it's executing a guest which has a
virtual GPU. In either case, there are at least three threads:

  - Two virtual CPU/GPU threads, which are nice(0) and often CPU-bound
  - A low-latency event handling thread, at nice(-10)

The event handling thread performs periodic tasks like delivering
timer interrupts and completing I/O operations. It isn't expected to
use much CPU, but it does run very frequently. To get the best latency
performance, we've been running it at nice(-10). The intention is that
this event handling thread should usually be able to preempt either of
the CPU-bound threads.

The behaviour we expect is that on a system which is otherwise lightly
loaded, the two CPU-bound threads each get nearly an entire physical
CPU to themselves. The event handling thread periodically wakes up,
preempts one of the CPU-bound threads briefly, then goes to sleep and
yields the CPU back to one of the CPU-bound threads.

The actual behaviour I see when the load balancer makes this
unfavorable decision is that the two CPU-bound threads share a single
CPU, and the other CPU is mostly idle. Best case, the virtual machine
runs half as fast as it could be running. Worst case it runs much
slower, because the CPU-bound threads often need to wait for each
other to catch up if they don't always run at about the same
rate. This involves a lot of extra synchronization overhead.

My current workaround for this is to avoid ever boosting our thread
priority on a kernel in which this problem could occur. Currently this
is any 2.6.20 or later kernel running with at least two CPUs. I'd like
to narrow this test now to only cover kernels with NUMA enabled.

Hopefully this explains why the scheduler behaviour I've observed is
undesirable for this particular workload. I would be surprised if I'm
the only one who has a workload that is negatively impacted by it, but
it does seem difficult to reconcile this workload's requirements with
the cache properties expected from a NUMA-aware scheduler.

Is there something I'm doing wrong, or is this just a weakness in the
current scheduler implementation? If it's the latter, are there any
planned improvements?

Thank you again,
--Micah
