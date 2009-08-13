Return-Path: <linux-kernel-owner+w=401wt.eu-S1751743AbZHMAvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbZHMAvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 20:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZHMAvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 20:51:10 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40303 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbZHMAvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 20:51:09 -0400
Date: Wed, 12 Aug 2009 17:51:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: CONFIG_PREEMPT_RCU in next/mmotm
Message-ID: <20090813005108.GZ6779@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090809053308.GD6866@linux.vnet.ibm.com> <Pine.LNX.4.64.0908091209150.23855@sister.anvils> <Pine.LNX.4.64.0908091346450.27358@sister.anvils> <20090809185753.GG6866@linux.vnet.ibm.com> <Pine.LNX.4.64.0908092139090.3194@sister.anvils> <20090809211629.GJ6866@linux.vnet.ibm.com> <20090810033907.GA1530@linux.vnet.ibm.com> <20090810224345.GA17730@linux.vnet.ibm.com> <20090812013422.GA23187@linux.vnet.ibm.com> <20090812092250.GD21655@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812092250.GD21655@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 11:22:50AM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Should these tests pass...

Things are working much better, but I can still cause failures by
hotplugging CPUs with zero wait time between them while concurrently
modprobe-ing and rmmod-ing rcutorture repeatedly while running
CONFIG_PREEMPT_RCU.  I increased the kernel's lifespan by an order of
magnitude or so by simplifying rcupreempt's hotplug code path.

And I just -know- that I will deeply regret having described my test
process, given that my life is much easier when my RCU testing is more
rigorous than anyone else's.  ;-)

The remaining (known) problem appears to be due to a kthread_stop()
deadlock between the migration threads and a few of rcutorture's kthreads.
In this deadlock, rcutorture is waiting for one of the fakewriters
to stop (via kthread_stop()), while the fakewriter is waiting for
synchronize_rcu() to complete.  The migration thread's CPU-hotplug
notifier is blocked in kthread_stop() because rcutorture holds the
kthread_stop() mutex.

I could argue that CPU hotplug should allow RCU grace periods to
proceed regardless, but I believe that the problem is that some thread
is preempted in the middle of an RCU read-side critical section, but
cannot be migrated to a CPU that could run it due to the fact that the
migration kthread is stuck in its CPU-hotplug notifier.  RCU being what
it is, it seems reasonable for me to instead arrange so that rcutorture
never invokes kthread_stop() unless it knows that the target thread cannot
possibly be in the midst of synchronize_rcu().  That said, there is the
concern that this general pattern might rear its ugly head elsewhere.

> > Unless someone tells me otherwise, I will make a patch series 
> > intended to replace tip/core/rcu commits 7fe616c5d ("Simplify RCU 
> > CPU-hotplug notification"), 04b06256c ("Fix RCU & CPU hotplug 
> > hang"), and 7256cf0e83b ("Add diagnostic check for a possible 
> > CPU-hotplug race"), re-run all tests on that patchset, and submit 
> > the series.  I expect the resulting patch set to have three 
> > patches, one to split out boot-time initialization for RCU_TREE, a 
> > second to create the cpu_notifier() API, and the third to make RCU 
> > use it.

While thinking this over, I am rebasing as described above, and doing
full-up testing at each step.  No more Mr. Nice Guy!!!  ;-)

In the meantime, can anyone tell me why we only let one kthread stop at
a time?

> Sure - we can reasonably rebase portions of that stack of commits:
> 
>  earth4:~/tip> gll linus..core/rcu
>  7256cf0: rcu: Add diagnostic check for a possible CPU-hotplug race
>  04b0625: rcu: Fix RCU & CPU hotplug hang
>  7fe616c: rcu: Simplify RCU CPU-hotplug notification
>  240ebbf: rcu: Add synchronize_sched_expedited() rcutorture doc + updates
>  0acc512: rcu: Add synchronize_sched_expedited() torture tests
>  03b042b: rcu: Add synchronize_sched_expedited() primitive
>  c17ef45: rcu: Remove Classic RCU
> 
> Please mention the magic words "please reset core/rcu to 240ebbf 
> before applying these patches" in the mail to me, should i forget in 
> the days to come.

Will do!

> (hm, what was i supposed to not forget? Weird.)

I can't remember.  ;-)

							Thanx, Paul
