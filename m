Return-Path: <linux-kernel-owner+w=401wt.eu-S1161199AbXAZTL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161199AbXAZTL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 14:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161198AbXAZTL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 14:11:59 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:34364 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161193AbXAZTL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 14:11:58 -0500
Date: Sat, 27 Jan 2007 00:41:13 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: akpm@osdl.org, Gautham Shenoy <ego@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: Fw: Re: [mm PATCH 4/6] RCU: (now) CPU hotplug
Message-ID: <20070126191113.GA14770@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20070124011519.GG1613@linux.vnet.ibm.com> <20070124090111.GC27221@in.ibm.com> <20070124161559.GA1762@linux.vnet.ibm.com> <20070124210645.GA19650@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070124210645.GA19650@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 02:36:45AM +0530, Dipankar Sarma wrote:
> On Wed, Jan 24, 2007 at 08:15:59AM -0800, Paul E. McKenney wrote:
> 
> It should be relatively easy. Setting the offlined cpu's flags
> to neutral state should do the trick in most cases.
> I will send out the patches tomorrow after reviewing the code
> some more.

Famous last words. 

It turns out that I have been bitten by the ugly cpu hotplug
locking mess while trying to get preemptible RCU code working
with CPU hotplug. The per-subsystem locking thing isn't really
user-friendly. Here is the dependency -

In cpu hotplug path (after CPU_LOCK_ACQUIRE) -

CPU_DOWN_PREPARE:sched domains -> detach_destroy_domains() ->
			synchronize_sched() -> sched_setaffinity()

sched_setaffinity() tries to acquire the scheduler cpu hotplug
mutex and deadlocks.

I see no easy way of getting around this - doing "cpu hotplug locked"
version of all those APIs would add lots of code which is bad.
We could try Gautham's idea of letting  each subsystem maintain
its own online cpu mask, but I bet implementing sched_setaffinity()
would not be very easy despite this.

What is the status on this now ? Is this a good example to
show why per-subsystem locks might be unmaintainable ? Can
we go back to a simple scalable refcount model
for CPU hotplug now ?

Thanks
Dipankar
