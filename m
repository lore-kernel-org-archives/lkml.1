Return-Path: <linux-kernel-owner+w=401wt.eu-S932930AbZKXNkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930AbZKXNkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 08:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932894AbZKXNkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 08:40:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:55634 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892AbZKXNki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 08:40:38 -0500
Subject: Re: [PATCH v6] x86/apic: limit irq affinity
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dimitri Sivanich <sivanich@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Arjan van de Ven <arjan@infradead.org>,
       David Miller <davem@davemloft.net>,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <alpine.LFD.2.00.0911241246470.24119@localhost.localdomain>
References: <20091120211139.GB19106@sgi.com>
	 <m1r5rrr9v5.fsf@fess.ebiederm.org> <20091122011457.GA16910@sgi.com>
	 <alpine.LFD.2.00.0911241246470.24119@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 14:39:46 +0100
Message-ID: <1259069986.4531.1453.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 14:20 +0100, Thomas Gleixner wrote:
> On Sat, 21 Nov 2009, Dimitri Sivanich wrote:
> 
> > On Sat, Nov 21, 2009 at 10:49:50AM -0800, Eric W. Biederman wrote:
> > > Dimitri Sivanich <sivanich@sgi.com> writes:
> > > 
> > > > This patch allows for hard numa restrictions to irq affinity on x86 systems.
> > > >
> > > > Affinity is masked to allow only those cpus which the subarchitecture
> > > > deems accessible by the given irq.
> > > >
> > > > On some UV systems, this domain will be limited to the nodes accessible
> > > > to the irq's node.  Initially other X86 systems will not mask off any cpus
> > > > so non-UV systems will remain unaffected.
> > > 
> > > Is this a hardware restriction you are trying to model?
> > > If not this seems wrong.
> > 
> > Yes, it's a hardware restriction.
> 
> Nevertheless I think that this is the wrong approach.
> 
> What we really want is a notion in the irq descriptor which tells us:
> this interrupt is restricted to numa node N.
> 
> The solution in this patch is just restricted to x86 and hides that
> information deep in the arch code. 
> 
> Further the patch adds code which should be in the generic interrupt
> management code as it is useful for other purposes as well:
> 
> Driver folks are looking for a way to restrict irq balancing to a
> given numa node when they have all the driver data allocated on that
> node. That's not a hardware restriction as in the UV case but requires
> a similar infrastructure.
> 
> One possible solution would be to have a new flag:
>  IRQF_NODE_BOUND    - irq is bound to desc->node
> 
> When an interrupt is set up we would query with a new irq_chip
> function chip->get_node_affinity(irq) which would default to an empty
> implementation returning -1. The arch code can provide its own
> function to return the numa affinity which would express the hardware
> restriction.
> 
> The core code would restrict affinity settings to the cpumask of that
> node without any need for the arch code to check it further.
> 
> That same infrastructure could be used for the software restriction of
> interrupts to a node on which the device is bound.
> 
> Having it in the core code also allows us to expose this information
> to user space so that the irq balancer knows about it and does not try
> to randomly move the affinity to cpus which are not in the allowed set
> of the node.

I think we should not combine these two cases.

Node-bound devices simply prefer the IRQ to be routed to a cpu 'near'
that node, hard-limiting them to that node is policy and is not
something we should do.

Defaulting to the node-mask is debatable, but is, I think, something we
could do. But I think we should allow user-space to write any mask as
long as the hardware can indeed route the IRQ that way, even when
clearly stupid.

Which is where the UV case comes in, they cannot route IRQs to every
CPU, so it makes sense to limit the possible masks being written. I do
however fully agree that that should be done in generic code, as I can
quite imagine more hardware than UV having limitations in this regard.

Furthermore, the /sysfs topology information should include IRQ routing
data in this case.

