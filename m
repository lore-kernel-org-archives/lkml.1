Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbZFAQTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbZFAQTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 12:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbZFAQTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 12:19:32 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51104 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbZFAQTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 12:19:31 -0400
Date: Mon, 1 Jun 2009 09:19:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] cpuhotplug: introduce try_get_online_cpus()
Message-ID: <20090601161931.GC6698@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4A1F9CEE.5090305@cn.fujitsu.com> <20090529133118.1c7b16c2.akpm@linux-foundation.org> <200906011701.51637.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906011701.51637.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 05:01:50PM +0930, Rusty Russell wrote:
> On Sat, 30 May 2009 06:01:18 am Andrew Morton wrote:
> > I do think that we should look at
> > alternative (non-trylocky) ways of fixing them.
> 
> Speculating: we could add a "keep_cpu()" (FIXME: improve name) which is kind 
> of like get_cpu() only doesn't disable preemption and only stops *this* cpu 
> from going down.
> 
> Not sure where that gets us, but if someone's going to dig deep into this it 
> might help.

I have been beating up on the approach of disabling preemption to pin down
a single CPU, and although it is working, it is no faster than simply
doing get_online_cpus() and it is much much more subtle and complex.
I am not sure that I have all the races properly accounted for, and I
am failing to see the point of having something quite this ugly in the
kernel when much simpler alternatives exist.

The main vulnerability is the possibility that someone will invoke
synchroniize_rcu_expedited() while holding a mutex that is also acquired
in a CPU-hotplug notifier, as Lai noted.  But this is easily handled
given a primitive that will say whether the current CPU is executing in a
CPU-hotplug notifier.  This primitive is permitted to sometimes mistakenly
say that the current CPU is executing in a CPU-hotplug notifier when it
is not (as long as it doesn't do so too often), but not vice versa.

One way to implement this would be to have such a primitive simply say
whether or not a CPU-hotplug operation is currently in effect.  Yes, this
is racy, but not when it matters -- you cannot possibly exit a CPU-hotplug
operation while executing in a CPU-hotplug notifier.  For example,
the following exported from kernel/cpu.c would work just fine:

	bool cpu_hotplug_in_progress(void)
	{
		return cpu_hotplug.active_writer != NULL;
	}

I believe that we should be OK moving forward with an updated version of
http://lkml.org/lkml/2009/5/22/332 even without the deadlock avoidance.
Having the deadlock avoidance would be better, of course, so I will use
something like the above on the next patch.

Thoughts?

							Thanx, Paul
