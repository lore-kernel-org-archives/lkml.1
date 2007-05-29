Return-Path: <linux-kernel-owner+w=401wt.eu-S1764971AbXE2U5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764971AbXE2U5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757533AbXE2U5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:57:07 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752929AbXE2U5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:57:04 -0400
Date: Tue, 29 May 2007 13:56:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>, Ashok Raj <ashok.raj@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       Dipankar <dipankar@in.ibm.com>
Subject: Re: CPU hotplug: system hang on CPU hot remove during `pfmon
 --system-wide'
In-Reply-To: <20070528065550.GL6157@in.ibm.com>
Message-ID: <alpine.LFD.0.98.0705291347320.26602@woody.linux-foundation.org>
References: <87bqg5emqk.wl%takeuchi_satoru@jp.fujitsu.com>
 <20070528065550.GL6157@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 May 2007, Srivatsa Vaddagiri wrote:
>
> 	So is it settled now on what approach we are going to follow (freezer 
> vs lock based) for cpu hotplug? I thought that Linus was not favouring freezer 
> based approach sometime back ..

As far as I'm concerned, we should
 - use "preempt_disable()" to protect against CPU's coming and going 
 - use "stop_machine()" or similar that already honors preemption, and 
   which I trust a whole lot  more than freezer.
 - .. especially since this is already how we are supposed to be protected 
   against CPU's going away, and we've already started doing that (for an 
   example of this, see things like e18f3ffb9c from Andrew)

It really does seem fairly straightforward to make "__cpu_up()" be called 
through stop_machine too. Looking at _cpu_down:

        mutex_lock(&cpu_bitmask_lock);
        p = __stop_machine_run(take_cpu_down, NULL, cpu);
        mutex_unlock(&cpu_bitmask_lock);

and then looking at _cpu_up:

        mutex_lock(&cpu_bitmask_lock);
        ret = __cpu_up(cpu);
        mutex_unlock(&cpu_bitmask_lock);

I just go "Aww, wouldn't it be nice to just make that "__cpu_up()" call be 
done through __stop_machine_run() too?"

Hmm?

Then, you could get the "cpu_bitmask_lock" if you need to sleep, but if 
you don't want to do that (and quite often you don't), just doing a 
"preempt_disable()" or taking a spinlock will *also* guarantee that no new 
CPU's suddenly show up, so it's safe to look at the CPU online bitmasks.

Do we really need anything else?

As mentioned, it's actually fairly easy to add verification calls to make 
sure that certain accesses are done with preemption disabled, so..

			Linus
