Return-Path: <linux-kernel-owner+w=401wt.eu-S934301AbXJPRWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934301AbXJPRWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 13:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbXJPRWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 13:22:01 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55259 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753484AbXJPRV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 13:21:59 -0400
Date: Tue, 16 Oct 2007 10:20:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Gautham R Shenoy <ego@in.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Rusty Russel <rusty@rustcorp.com.au>,
       Dipankar Sarma <dipankar@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@us.ibm.com>
Subject: Re: [RFC PATCH 0/4] Refcount Based Cpu-Hotplug Revisit.
In-Reply-To: <20071016103308.GA9907@in.ibm.com>
Message-ID: <alpine.LFD.0.999.0710161015510.6887@woody.linux-foundation.org>
References: <20071016103308.GA9907@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Oct 2007, Gautham R Shenoy wrote:
> 
> Patch 1/4: Implements the core refcount + waitqueue model.
> Patch 2/4: Replaces all the lock_cpu_hotplug/unlock_cpu_hotplug instances
> 	   with get_online_cpus()/put_online_cpus()
> Patch 3/4: Replaces the subsystem mutexes (we do have three of them now, 
>            in sched.c, slab.c and workqueue.c) with get_online_cpus,
> 	   put_online_cpus.
> Patch 4/4: Eliminates the CPU_DEAD and CPU_UP_CANCELLED event handling
>  	   from workqueue.c
> 
> The patch series has survived an overnight test with kernbench on i386.
> and has been tested with Paul Mckenney's latest preemptible rcu code.
> 
> Awaiting thy feedback!

Well, afaik, the patch series is fairly clean, and I'm obviously perfectly 
happy with the approach, so I have no objections. 

But it looks buggy. This:

	+static void cpu_hotplug_begin(void)
	+{
	+       mutex_lock(&cpu_hotplug.lock);
	+       cpu_hotplug.active_writer = current;
	+       while (cpu_hotplug.refcount) {
	+               mutex_unlock(&cpu_hotplug.lock);
	+               wait_for_completion(&cpu_hotplug.readers_done);
	+               mutex_lock(&cpu_hotplug.lock);
	+       }
	+
	+}

drops the cpu_hotplug.lock, which - as far as I can see - means that 
another process can come in and do the same, and mess up the 
"active_writer" thing. The oerson that actually *gets* the lock may not be 
the same one that has "active_writer" set to itself. No? Am I missing 
something.

So I think this needs (a) more people looking at it (I think I found a 
bug, who knows if there are more subtle ones lurking) and (b) lots of 
testing. 

			Linus
