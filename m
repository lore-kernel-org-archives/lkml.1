Return-Path: <linux-kernel-owner+w=401wt.eu-S1760516AbYCEIio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760516AbYCEIio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 03:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbYCEIie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 03:38:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33346 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127AbYCEIid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 03:38:33 -0500
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Jackson <pj@sgi.com>
Cc: Max Krasnyanskiy <maxk@qualcomm.com>, mingo@elte.hu, tglx@linutronix.de,
       oleg@tv-sign.ru, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       rientjes@google.com
In-Reply-To: <20080304191159.a02be58b.pj@sgi.com>
References: <20080227222103.673194000@chello.nl>
	 <1204311351.6243.130.camel@lappy> <20080229190223.GA17820@elte.hu>
	 <47C87084.3090208@qualcomm.com> <1204318980.6243.133.camel@lappy>
	 <47C8771C.1070001@qualcomm.com> <1204545445.11412.6.camel@twins>
	 <20080303113621.1dfdda87.pj@sgi.com> <1204567052.6241.4.camel@lappy>
	 <20080303121033.c8c9651c.pj@sgi.com> <1204568316.8514.18.camel@twins>
	 <20080304013534.4e51ae48.pj@sgi.com> <1204628762.6241.46.camel@lappy>
	 <47CDA885.3000103@qualcomm.com>  <20080304191159.a02be58b.pj@sgi.com>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 09:37:52 +0100
Message-Id: <1204706272.6241.79.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-03-04 at 19:11 -0600, Paul Jackson wrote:
> Max K wrote:
> > Yeah, that would definitely be awkward.
> 
> Yeah - agreed - awkward.
> 
> Forget that idea (allowing the same irq in multiple 'irqs' files.)
> 
> It seems to me that we get into trouble trying to cram that 'system'
> cpuset into the cpuset hierarchy, where that system cpuset is there to
> hold a list of irqs, but is only partially a good fit for the existing
> cpuset hierarchy.
> 
> Could this irq configuration be partly a system-wide configuration
> decision (which irqs are 'system' irqs), and partly a per-cpuset
> decision -- which cpusets (such as a real-time one) want to disable
> the usual system irqs that everyone else gets.
> 
> The cpuset portion of this should take only a single per-cpuset Boolean
> flag -- which if set True (1), asks the system to "please leave my CPUs
> off the list of CPUs receiving the usual system irqs."
> 
> Then the list of "usual system irqs" would be established in some /proc
> or /sys configuration.  Such irqs would be able to go to any CPUs
> except those CPUs which found themselves in a cpuset with the above
> per-cpuset Boolean flag set True (1).

How about we make this in-kernel boot set, that by default contains all
IRQs, all unbounded kthreads and all of user-space.

To be compatible with your existing clients you only need to move all
the IRQs to the root domain.

(Upgrading a kernel would require distributing some new userspace
anyway, right? - and we could offer a .config option to disable the boot
set for those who do upgrade kernels without upgrading user-space).

Then, once you want to make use of the new features, you have to update
your batch scheduler to only make use of load_balance and not
cpus_exclusive (as they're only interested in sched_domains, right?)

So if you want to do IRQ isolation and batch scheduling on the same
machine (as is not possible now) you need to update userspace as said
before; so that it allows for the overlapping cpuset.

For example, on a 32 cpu machine:

/cgroup/boot 0-1 (kthreads - initial userspace)
/cgroup/irqs 0-27 (most irqs)
/cgroup/batch_A 2-5
/cgroup/batch_B 6-13
/cgroup/another_big_app 14-27
/cgroup/RT-domain 28-31 (my special irq)

So by providing a .config option for strict backward compatibility, a
simple way for runtime compatibility (moving all IRQs to the root) which
should be easy to do if the kernel upgrade is accompanied by a (limited)
user-space upgrade.

And once all the features need to be used together (something that is
now not possible - so new usage) then the code that relies on
cpus_exclusive to create sched_domains needs to be changed to use
load_balance instead.

Does that sound like a feasible plan?

> How does all this interact with /proc/irq/N/smp_affinity?

Much the same way the cpuset cpus_allowed interacts with a task's
cpus_allowed. That is, cs->cpus_allowed is a mask on top of the provided
affinity.

If for some reason the cs->cpus_allowed changes in such a way that the
user-specified mask becomes empty (irq->cpus_allowed & cs->cpus_allowed
== 0), then print a message and set it to the full mask
(irq->cpus_allowed = cs->cpus_allowed).

If for some reason the cs->cpus_allowed changes in such a way that the
mask is physically impossible (set_irq_affinity(cs->cpus_allowed)
fails), then print a message and move the IRQ to the parent set.



