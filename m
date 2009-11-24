Return-Path: <linux-kernel-owner+w=401wt.eu-S932902AbZKXNVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902AbZKXNVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 08:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757877AbZKXNVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 08:21:33 -0500
Received: from www.tglx.de ([62.245.132.106]:43710 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757581AbZKXNVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 08:21:32 -0500
Date: Tue, 24 Nov 2009 14:20:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dimitri Sivanich <sivanich@sgi.com>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Arjan van de Ven <arjan@infradead.org>,
       David Miller <davem@davemloft.net>,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH v6] x86/apic: limit irq affinity
In-Reply-To: <20091122011457.GA16910@sgi.com>
Message-ID: <alpine.LFD.2.00.0911241246470.24119@localhost.localdomain>
References: <20091120211139.GB19106@sgi.com> <m1r5rrr9v5.fsf@fess.ebiederm.org> <20091122011457.GA16910@sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Nov 2009, Dimitri Sivanich wrote:

> On Sat, Nov 21, 2009 at 10:49:50AM -0800, Eric W. Biederman wrote:
> > Dimitri Sivanich <sivanich@sgi.com> writes:
> > 
> > > This patch allows for hard numa restrictions to irq affinity on x86 systems.
> > >
> > > Affinity is masked to allow only those cpus which the subarchitecture
> > > deems accessible by the given irq.
> > >
> > > On some UV systems, this domain will be limited to the nodes accessible
> > > to the irq's node.  Initially other X86 systems will not mask off any cpus
> > > so non-UV systems will remain unaffected.
> > 
> > Is this a hardware restriction you are trying to model?
> > If not this seems wrong.
> 
> Yes, it's a hardware restriction.

Nevertheless I think that this is the wrong approach.

What we really want is a notion in the irq descriptor which tells us:
this interrupt is restricted to numa node N.

The solution in this patch is just restricted to x86 and hides that
information deep in the arch code. 

Further the patch adds code which should be in the generic interrupt
management code as it is useful for other purposes as well:

Driver folks are looking for a way to restrict irq balancing to a
given numa node when they have all the driver data allocated on that
node. That's not a hardware restriction as in the UV case but requires
a similar infrastructure.

One possible solution would be to have a new flag:
 IRQF_NODE_BOUND    - irq is bound to desc->node

When an interrupt is set up we would query with a new irq_chip
function chip->get_node_affinity(irq) which would default to an empty
implementation returning -1. The arch code can provide its own
function to return the numa affinity which would express the hardware
restriction.

The core code would restrict affinity settings to the cpumask of that
node without any need for the arch code to check it further.

That same infrastructure could be used for the software restriction of
interrupts to a node on which the device is bound.

Having it in the core code also allows us to expose this information
to user space so that the irq balancer knows about it and does not try
to randomly move the affinity to cpus which are not in the allowed set
of the node.

Thanks,

	tglx
