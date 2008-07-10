Return-Path: <linux-kernel-owner+w=401wt.eu-S1758876AbYGJVPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876AbYGJVPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 17:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbYGJVPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 17:15:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:55029 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755408AbYGJVPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 17:15:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,340,1212390000"; 
   d="scan'208";a="589411722"
Date: Thu, 10 Jul 2008 14:15:13 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
Message-ID: <20080710211513.GL1678@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com> <m1prplv71d.fsf@frodo.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1prplv71d.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 01:05:50PM -0700, Eric W. Biederman wrote:
> 
> At a quick skim nothing looks really bad, nothing looks really bad,
> but you are dealing in an area of code that could be made much nicer
> and if we are going to support a noticeably different style of irq
> management we need to get in some of those pending cleanups so the
> code does not fall down under it's own wait.
> 
> Suresh Siddha <suresh.b.siddha@intel.com> writes:
> 
> > irq migration in the presence of interrupt-remapping is done from the
> > process-context as opposed to interrupt-context. Interrupt-remapping
> > infrastrucutre allows us to do this migration in a simple fashion (atleast for
> > edge triggered interrupts).
> 
> Unless I have misread things this irq migration remains racy, as I did not
> see any instructions that would guarantee that in flight irqs were flushed
> to the cpus local apics before we cleaned up the destination.

Flushing the interrupt entry cache will take care of this. We modify the IRTE
and then flush the interrupt entry cache before cleaning up the original
vector allocated.

Any new interrupts from the device will see the new entry. Old in flight
interrupts will be registered at the CPU before the flush of the cache is
complete.

> 
> You are sizing an array as NR_IRQS this is something there should be sufficient
> existing infrastructure to avoid.  Arrays sized by NR_IRQS is a significant
> problem both for scaling the system up and down so ultimately we need to kill
> this.  For now we should not introduce any new arrays.

Ok. Ideally dynamic_irq_init()/cleanup() can take care of this. or
create_irq()/destroy_irq() and embed this as a pointer somewhere inside
irq_desc. I need to take a look at this more closer and post a fix up patch.

> 
> A lot of your code is generic, and some of it is for just x86_64.  Since the
> cpus are capable of running in 32bit mode.  We really need to implement x86_32
> and x86_64 support in the same code base.  Which I believe means factoring out
> pieces of io_apic_N.c into things such as msi.c that can be shared between the
> two architectures.

Yes, As you and Ingo mentioned, there is nothing 64bit specific and one
can easily add the 32bit support. But before that we need, some more
x86 unification and I am very short on resources currently :(

thanks,
suresh
