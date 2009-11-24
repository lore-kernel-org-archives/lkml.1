Return-Path: <linux-kernel-owner+w=401wt.eu-S934336AbZKXVyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934336AbZKXVyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933965AbZKXVyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:54:41 -0500
Received: from www.tglx.de ([62.245.132.106]:48920 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934319AbZKXVyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:54:38 -0500
Date: Tue, 24 Nov 2009 22:51:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dimitri Sivanich <sivanich@sgi.com>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Miller <davem@davemloft.net>,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v6] x86/apic: limit irq affinity
In-Reply-To: <20091124214121.GA15182@sgi.com>
Message-ID: <alpine.LFD.2.00.0911242243160.24119@localhost.localdomain>
References: <20091120211139.GB19106@sgi.com> <m1r5rrr9v5.fsf@fess.ebiederm.org> <20091122011457.GA16910@sgi.com> <alpine.LFD.2.00.0911241246470.24119@localhost.localdomain> <1259069986.4531.1453.camel@laptop> <alpine.LFD.2.00.0911241443110.24119@localhost.localdomain>
 <20091124065022.6933be1a@infradead.org> <m1ws1f6csh.fsf@fess.ebiederm.org> <20091124214121.GA15182@sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009, Dimitri Sivanich wrote:

> On Tue, Nov 24, 2009 at 09:41:18AM -0800, Eric W. Biederman wrote:
> > As for the UV code, what we are looking at is a fundamental irq
> > routing property.  Those irqs cannot be routed to some cpus.  That is
> > something the code that sets up the routes needs to be aware of.
> 
> Correct.  We can't allow an interrupt to be routed to an invalid node.
> 
> > Dimitri could you put your the extra code in assign_irq_vector instead
> > of in the callers of assign_irq_vector?  Since the probably is not
> > likely to stay unique we probably want to put the information you base
> > things on in struct irq_desc, but the logic I seems to live best in
> > in assign_irq_vector.
>
> So you're saying continue to use the node value in irq_desc, or add
> a cpumask there (which will add some size to that structure)?  I'll
> have to take another look at assign_irq_vector, but as things are
> currently structured, we don't return any sort of valid cpumask that
> we'd need for further processing in the caller functions.  One would
> need to pass that back or store that cpumask someplace, like
> irq_desc?

Please do not put anything complex into x86 code at all. Such designs
are likely to happen on other architectures and as I said before we
want to have

1) the decision function what's valid and not in the generic code

2) a way to expose that information as part of the irq interface to
   user space.

So what's wrong with a per irq_chip function which returns the cpumask
which is valid for irq N ?

That function would be called to check the affinity mask in
set_irq_affinity and to dump the mask to /proc/irq/N/possible_cpus or
whatever name we agree on.

That way we don't have to worry about where in the x86 code the
decision should reside as you simply would always get valid masks from
the core code.

That just works and is neither restricted to UV nor to x86.

Thanks,

	tglx
