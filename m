Return-Path: <linux-kernel-owner+w=401wt.eu-S934363AbXFFPY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934363AbXFFPY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 11:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760168AbXFFPYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 11:24:48 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56340 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758739AbXFFPYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 11:24:47 -0400
Date: Wed, 6 Jun 2007 20:54:40 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>, Ashok Raj <ashok.raj@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, akpm@linux-foundation.org,
       Dipankar <dipankar@in.ibm.com>
Subject: Re: CPU hotplug: system hang on CPU hot remove during `pfmon --system-wide'
Message-ID: <20070606152440.GA32558@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <87bqg5emqk.wl%takeuchi_satoru@jp.fujitsu.com> <20070528065550.GL6157@in.ibm.com> <alpine.LFD.0.98.0705291347320.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705291347320.26602@woody.linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 01:56:24PM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 28 May 2007, Srivatsa Vaddagiri wrote:
> >
> > 	So is it settled now on what approach we are going to follow (freezer 
> > vs lock based) for cpu hotplug? I thought that Linus was not favouring freezer 
> > based approach sometime back ..
> 
> As far as I'm concerned, we should
>  - use "preempt_disable()" to protect against CPU's coming and going 
>  - use "stop_machine()" or similar that already honors preemption, and 
>    which I trust a whole lot  more than freezer.
>  - .. especially since this is already how we are supposed to be protected 
>    against CPU's going away, and we've already started doing that (for an 
>    example of this, see things like e18f3ffb9c from Andrew)
> 

Yes, provided that the code sections which need protection against CPU's 
coming and going don't block, we surely can use preempt_disable/preempt_enable
for refcounting. But we do have scenarios where such code sections do
block. Vatsa has quoted a few of them in his mail.


> It really does seem fairly straightforward to make "__cpu_up()" be called 
> through stop_machine too. Looking at _cpu_down:
> 
>         mutex_lock(&cpu_bitmask_lock);
>         p = __stop_machine_run(take_cpu_down, NULL, cpu);
>         mutex_unlock(&cpu_bitmask_lock);
> 
> and then looking at _cpu_up:
> 
>         mutex_lock(&cpu_bitmask_lock);
>         ret = __cpu_up(cpu);
>         mutex_unlock(&cpu_bitmask_lock);
> 
> I just go "Aww, wouldn't it be nice to just make that "__cpu_up()" call be 
> done through __stop_machine_run() too?"
> 

Sure, we can do it. But what is it going to solve?

The whole section from CPU_UP/DOWN_PREPARE to CPU_ONLINE/DEAD
is supposed to be atomic and not just __cpu_up/take_cpu_down.
These are the sections where subsystems create/destroy their per-cpu
resources.

Remember, the cpufreq problem was originally caused because we were 
releasing the cpu_bitmask_lock before handling CPU_DEAD, where some of
the cpufreq specific per-cpu data was being freed. And thus, we were
operating on stale data in the window between the release of 
cpu_bitmask_lock and handling of CPU_DEAD.

> Hmm?
> 
> Then, you could get the "cpu_bitmask_lock" if you need to sleep, but if 
> you don't want to do that (and quite often you don't), just doing a 
> "preempt_disable()" or taking a spinlock will *also* guarantee that no new 
> CPU's suddenly show up, so it's safe to look at the CPU online bitmasks.
> 
> Do we really need anything else?
> 

* We don't need locks/mutexes because (bad) experience tells us that
  in this case, locking is not the right model. 

* Despite having implemented it, I am not very much convinced about
  freezer because it hides the cpu-hotplug details from subsystems, which
  IMHO is not a good thing. 

* Like every other resource, if people don't want a cpu to go down/come up, 
  they should bump up an associated refcount. But since we need
  this refcounting model to allow blocking code sections too, we cannot
  use preempt_enable/disable. 

Therefore sir, we do need nice scalable refcounting model :)

> As mentioned, it's actually fairly easy to add verification calls to make 
> sure that certain accesses are done with preemption disabled, so..
> 
> 			Linus

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
