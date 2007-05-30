Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbXE3Qr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbXE3Qr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 12:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbXE3Qru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 12:47:50 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57865 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbXE3Qru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 12:47:50 -0400
Date: Wed, 30 May 2007 22:25:57 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>, Ashok Raj <ashok.raj@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       Dipankar <dipankar@in.ibm.com>
Subject: Re: CPU hotplug: system hang on CPU hot remove during `pfmon --system-wide'
Message-ID: <20070530165557.GB1626@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <87bqg5emqk.wl%takeuchi_satoru@jp.fujitsu.com> <20070528065550.GL6157@in.ibm.com> <alpine.LFD.0.98.0705291347320.26602@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705291347320.26602@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 01:56:24PM -0700, Linus Torvalds wrote:
> As far as I'm concerned, we should
>  - use "preempt_disable()" to protect against CPU's coming and going 
>  - use "stop_machine()" or similar that already honors preemption, and 
>    which I trust a whole lot  more than freezer.
>  - .. especially since this is already how we are supposed to be protected 
>    against CPU's going away, and we've already started doing that (for an 
>    example of this, see things like e18f3ffb9c from Andrew)
> 
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
> Hmm?
> 
> Then, you could get the "cpu_bitmask_lock" if you need to sleep,

and that's where all the problems started - sleepers needing to take that mutex 
recursively (which we did/do not support).

	foo() takes cpu_bitmask_lock and calls
	  foo_bar() which also needs cpu_bitmask_lock

What is a solution to that?

	- Forget (hide?) this whole locking mess by using freezer, which
	  is what Andrew wanted us to shoot for :) I am somewhat biased
	  with Andrew here in that I think it will lead to more stabler cpu 
	  hotplug code over time. Again I know some people will beg to differ 
	  on this view.

	- extend mutexes to support recursion (which I gather Linux has 
	  religiously avoided so far)

	- invent a special lock for cpu hotplug which supports recursion. 
	  This is what Gautham tried doing with [1], with the bonus that it 
	  made the lock extremely scalable for readers by using per-cpu 
	  reference counters and RCU. He is preparing to resend those patches 
	  against latest kernel atm

	- Anything else you can think of?

[1] http://lkml.org/lkml/2006/10/26/73


> but if you don't want to do that (and quite often you don't), just doing a 
> "preempt_disable()" or taking a spinlock will *also* guarantee that no new 
> CPU's suddenly show up, so it's safe to look at the CPU online bitmasks.
> 
> Do we really need anything else?

see above

> As mentioned, it's actually fairly easy to add verification calls to make 
> sure that certain accesses are done with preemption disabled, so..

-- 
Regards,
vatsa
