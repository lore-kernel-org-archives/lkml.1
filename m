Return-Path: <linux-kernel-owner+w=401wt.eu-S1763704AbXFGQ2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763704AbXFGQ2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750923AbXFGQ2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:28:09 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:3065 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbXFGQ2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:28:08 -0400
Date: Thu, 7 Jun 2007 18:27:43 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Jan Glauber <jan.glauber@de.ibm.com>, David Miller <davem@davemloft.net>,
       akpm@osdl.org, mingo@elte.hu, ak@suse.de, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>
Subject: Re: [patch] i386/x86_64: smp_call_function locking inconsistency
Message-ID: <20070607162743.GA9433@osiris.ibm.com>
References: <20070208203210.GB9798@osiris.ibm.com> <20070208.124328.88477956.davem@davemloft.net> <20070209084221.GA8259@osiris.boeblingen.de.ibm.com> <1171025838.5349.14.camel@localhost.localdomain> <a781481a0706070707j301ba886h10f4607fd6a6e8de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0706070707j301ba886h10f4607fd6a6e8de@mail.gmail.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >So either all spin_lock_bh's should be converted to spin_lock,
> >which would limit smp_call_function()/smp_call_function_single()
> >to process context & irqs enabled.
> >Or the spin_lock's could be converted to spin_lock_bh which would
> >make it possible to call these two functions even if in softirq
> >context. AFAICS this should be safe.
> 
> Actually, I agree with David and Andi here:
> 
> On 2/9/07, David Miller <davem@davemloft.net> wrote:
> >I think it's logically simpler if we disallow smp_call_function*()
> >from any kind of asynchronous context.  But I'm sure your driver
> >has a true need for this for some reason.
> 
> and
> 
> On 2/9/07, Andi Kleen <ak@suse.de> wrote:
> >I'm not so sure. Perhaps drop _bh in both and stick a WARN_ON_ONCE in
> >to catch the cases?
> 
> Replacing the _bh variants and making smp_call_function{_single}
> illegal from all contexts but process is fine for x86_64, as we
> don't really have any driver that needs to use this from softirq
> context in the x86_64 tree. This means it becomes dissimilar to
> s390, but similar to powerpc, mips, alpha, sparc64 semantics.
> I'll prepare and submit a patch for the same, shortly.

Calling an smp_call_* function from any context but process context is
a bug. We didn't notice this initially when we used smp_call_function
from softirq context... until we deadlocked ;)
So s390 is the same as any other architecture wrt this.

> On 2/9/07, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> >Another thing that comes into my mind is smp_call_function together
> >with cpu hotplug. Who is responsible that preemption and with that
> >cpu hotplug is disabled?
> >Is it the caller or smp_call_function itself?
> >If it's smp_call_function then s390 would be broken, since
> >then we would have
> >int cpus = num_online_cpus()-1;
> >in preemptible context... I agree: what a mess :)
> 
> and
> 
> On 2/9/07, Jan Glauber <jan.glauber@de.ibm.com> wrote:
> >If preemption must be disabled before smp_call_function() we should have
> >the same semantics for all smp_call_function_* variants.
> 
> I don't see any CPU hotplug / preemption disabling issues here.
> Note that both smp_call_function() and smp_call_function_single()
> on x86_64 acquire the call_lock spinlock before using cpu_online_map
> via num_online_cpus(). And spin_lock() does preempt_disable() on both
> SMP and !SMP, so we're safe. [ But we're not explicitly disabling
> preemption and depending on spin_lock() instead, so a comment would
> be in order? ]

Calling smp_call_function_single() with preemption enabled is pointless.
You might be scheduled on the cpu you want to send an IPI to and get
-EBUSY as return... If cpu hotplug is enabled the target cpu might even
be gone when smp_call_function_single() gets executed.

Avi Kivity has already a patch which introduces an on_cpu() function which
looks quite like on_each_cpu(). That way you don't have to open code this
stuff over and over again:

preempt_disable();
if (cpu == smp_processor_id())
	func();
else
	smp_call_function_single(...);
preempt_enable();

There are already quite a few of these around.
