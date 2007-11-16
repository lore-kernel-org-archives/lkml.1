Return-Path: <linux-kernel-owner+w=401wt.eu-S935292AbXKPWOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935292AbXKPWOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 17:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760545AbXKPWOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 17:14:06 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:35013 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935148AbXKPWOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 17:14:05 -0500
Date: Fri, 16 Nov 2007 14:14:04 -0800
From: Micah Dowty <micah@vmware.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Kyle Moffett <mrmacman_g4@mac.com>, Cyrus Massoumi <cyrusm@gmx.net>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Mike Galbraith <efault@gmx.de>,
       Paul Menage <menage@google.com>,
       Peter Williams <pwil3058@bigpond.net.au>
Subject: Re: High priority tasks break SMP balancer?
Message-ID: <20071116221404.GC31527@vmware.com>
References: <2FAA6826-653E-482F-A037-C539BAEEA1DA@mac.com> <20071115191408.GA4914@vmware.com> <Pine.LNX.4.64.0711151206370.28639@schroedinger.engr.sgi.com> <20071115202425.GC4914@vmware.com> <Pine.LNX.4.64.0711151328090.29711@schroedinger.engr.sgi.com> <20071115213510.GA16079@vmware.com> <Pine.LNX.4.64.0711151830260.31691@schroedinger.engr.sgi.com> <20071116024408.GA20322@vmware.com> <20071116060700.GD16273@elte.hu> <b647ffbd0711160248v444d8f64ic72a17fcb56adc6d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0711160248v444d8f64ic72a17fcb56adc6d@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 11:48:50AM +0100, Dmitry Adamushko wrote:
> could you try to change either :
> 
> cat /proc/sys/kernel/sched_stat_granularity
> 
> put it to the value equal to a tick on your system

This didn't seem to have any effect.

> or just remove bit #3 (which is responsible for 8 == 1000) here:
> 
> cat /proc/sys/kernel/sched_features
> 
> (this one is enabled by default in 2.6.23.1)

Aha. Turning off bit 3 appears to instantly fix my problem while it's
occurring in an existing process, and I can't reproduce it on any new
processes afterward.

> anyway, when it comes to calculating rq->cpu_load[], a nice(0) cpu-hog
> task (on cpu_0) may generate a similar load (contribute to
> rq->cpu_load[]) as e.g. some negatively reniced task (on cpu_1) which
> runs only periodically (say, once in a tick for N ms., etc.) [*]
> 
> The thing is that the higher a prio of the task, the bigger 'weight'
> it has (prio_to_wait[] table in sched.c) ... and roughly, the load it
> generates is not only 'proportional' to 'run-time per fixed interval
> of time' but also to its 'weight'. That's why the [*] above.

Right. I gathered from reading the scheduler source earlier that the
load average is intended to be proportional to the priority of the
task, but I was really confused by the fairly nondeterministic effect
on the cpu_load average that my test process is having.

> so you may have a situation :
> 
> cpu_0 : e.g. a nice(-20) task running periodically every tick and
> generating, say ~10% cpu load ;

Part of the problem may be that my high-priority task can run much
more often than every tick. In my test case and in the VMware code
that I originally observed the problem in, the thread can wake up
based on /dev/rtc or on a device IRQ. Either of these can happen much
more frequently than the scheduler tick, if I understand correctly.

> cpu_1 : 2-3 nice(0) cpu-hog tasks ;
> 
> both cpus may be seen with similar rq->load_cpu[]...

When I try this, cpu0 has a cpu_load[] of over 10000 and cpu1 has a
load of 2048 or so.

> yeah, one would
> argue that one of the cpu hogs could be migrated to cpu_0 and consume
> remaining 'time slots' and it would not "disturb" the nice(-20) task
> as :
> it's able to preempt the lower prio task whenever it want (provided,
> fine-grained kernel preemption) and we don't care that much of
> trashing of caches here.

Yes, that's the behaviour I expected to see (and what my application
would prefer).

> btw., without the precise load balancing, there can be situations when
> the nice(-20) (or say, a RT periodic task) can be even not seen (i.e.
> don't contribute to cpu_load[]) on cpu_0...
> we do sampling every tick (sched.c :: update_cpu_load()) and consider
> this_rq->ls.load.weight at this particular moment (that is the sum of
> 'weights' for all runnable tasks on this rq)... and it may well be
> that the aforementioned high-priority task is just never (or likely,
> rarely) runnable at this particular moment (it runs for short interval
> of time in between ticks).

Indeed. I think this is the major contributor to the nondeterminism
I'm seeing.

Thanks much,
--Micah
