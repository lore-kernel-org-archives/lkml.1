Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbZLDQma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbZLDQma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 11:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbZLDQm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 11:42:27 -0500
Received: from relay1.sgi.com ([192.48.179.29]:43403 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756308AbZLDQm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 11:42:26 -0500
Date: Fri, 4 Dec 2009 10:42:27 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Miller <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v6] x86/apic: limit irq affinity
Message-ID: <20091204164227.GA28378@sgi.com>
References: <alpine.LFD.2.00.0911241443110.24119@localhost.localdomain> <20091124065022.6933be1a@infradead.org> <m1ws1f6csh.fsf@fess.ebiederm.org> <20091125074033.4c46c1b0@infradead.org> <20091203165004.GA14665@sgi.com> <Pine.WNT.4.64.0912030851500.13880@ppwaskie-MOBL2.amr.corp.intel.com> <20091203170149.GA15151@sgi.com> <Pine.WNT.4.64.0912030905530.16084@ppwaskie-MOBL2.amr.corp.intel.com> <20091203171946.GC15151@sgi.com> <Pine.WNT.4.64.0912031048590.8104@ppwaskie-MOBL2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.WNT.4.64.0912031048590.8104@ppwaskie-MOBL2.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 10:50:47AM -0800, Waskiewicz Jr, Peter P wrote:
> On Thu, 3 Dec 2009, Dimitri Sivanich wrote:
> 
> > On Thu, Dec 03, 2009 at 09:07:21AM -0800, Waskiewicz Jr, Peter P wrote:
> > > On Thu, 3 Dec 2009, Dimitri Sivanich wrote:
> > > 
> > > > On Thu, Dec 03, 2009 at 08:53:23AM -0800, Waskiewicz Jr, Peter P wrote:
> > > > > On Thu, 3 Dec 2009, Dimitri Sivanich wrote:
> > > > > 
> > > > > > On Wed, Nov 25, 2009 at 07:40:33AM -0800, Arjan van de Ven wrote:
> > > > > > > On Tue, 24 Nov 2009 09:41:18 -0800
> > > > > > > ebiederm@xmission.com (Eric W. Biederman) wrote:
> > > > > > > > Oii.
> > > > > > > > 
> > > > > > > > I don't think it is bad to export information to applications like
> > > > > > > > irqbalance.
> > > > > > > > 
> > > > > > > > I think it pretty horrible that one of the standard ways I have heard
> > > > > > > > to improve performance on 10G nics is to kill irqbalance.
> > > > > > > 
> > > > > > > irqbalance does not move networking irqs; if it does there's something
> > > > > > > evil going on in the system. But thanks for the bugreport ;)
> > > > > > 
> > > > > > It does move networking irqs.
> > > > > > 
> > > > > > > 
> > > > > > > we had that; it didn't work.
> > > > > > > what I'm asking for is for the kernel to expose the numa information;
> > > > > > > right now that is the piece that is missing.
> > > > > > > 
> > > > > > 
> > > > > > I'm wondering if we should expose that numa information in the form of a node or the set of allowed cpus, or both?
> > > > > > 
> > > > > > I'm guessing 'both' is the correct answer, so that apps like irqbalance can make a qualitative decision based on the node (affinity to cpus on this node is better), but an absolute decision based on allowed cpus (I cannot change affinity to anything but this set of cpus).
> > > > > 
> > > > > That's exactly what my patch in the thread "irq: Add node_affinity CPU 
> > > > > masks for smarter irqbalance hints" is doing.  I've also done the 
> > > > > irqbalance changes based on that kernel patch, and Arjan currently has 
> > > > > that patch.
> > > > 
> > > > So if I understand correctly, you're patch takes care of the qualitative portion of it (we prefer to set affinity to these cpus, which may be on more than one node), but not the restrictive part of it (we cannot change affinity to anything but these cpus)?
> > > 
> > > That is correct.  The patch provides an interface to both the kernel 
> > > (functions) and /proc for userspace to set a CPU mask.  That is the 
> > > preferred mask for the interrupt to be balanced on.  Then irqbalance will 
> > > make decisions on how to balance within that provided mask, if it in fact 
> > > has been provided.
> > 
> > What if it's not provided?  Will irqbalance make decisions based on the numa_node of that irq (I would hope)?
> 
> If it's not provided, then irqbalance will continue to do what it does 
> today.  No changes.

So no numa awareness for ethernet irqs.

I'm wondering what needs to be exposed in proc/irq at this point.

Do we expose separate cpu masks for everything?  There are really 3 possible pieces of affinity information:  your node_affinity (optionally selected by the driver according to allocations), my restricted_affinity (set by the specific arch), and numa_node affinity (the 'home' node of the device).  Do we show cpumasks for all of these, or maybe show numa_node in place of a cpumask for the 'home' node of the device?

With all of that information apps like irqbalance should be able to make some good decisions, but things can get confusing if there are too many masks.

Also, if I manually change affinity, irqbalance can change that affinity from under me, correct?  That's fine as long as it's stated that that's how things will work (turn off irqbalance or run oneshot mode for manual setting).

> 
> > 
> > Also, can we add a restricted mask as I mention above into this scheme?  If we can't send an IRQ to some node, we don't want to bother attempting to change affinity to cpus on that node (hopefully code in the kernel will eventually restrict this).
> > 
> 
> The interface allows you to put in any CPU mask.  The way it's written 
> now, whatever mask you put in, irqbalance *only* balances within that 
> mask.  It won't ever try and go outside that mask.

OK.  Given that, it might be nice to combine the restricted cpus that I'm describing with your node_affinity mask, but we could expose them as separate masks (node_affinity and restricted_affinity, as I describe above).

> 
> > As a matter of fact, driver's allocating rings, buffers, queues on other nodes should optimally be made aware of the restriction.
> 
> The idea is that the driver will do its memory allocations for everything 
> across nodes.  When it does that, it will use the kernel interface 
> (function call) to set the corresponding mask it wants for those queue 
> resources.  That is my end-goal for this code.
> 

OK, but we will eventually have to reject any irqbalance attempts to send irqs to restricted nodes.
