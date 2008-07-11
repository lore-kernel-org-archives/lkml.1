Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbYGKCfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbYGKCfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 22:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbYGKCfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 22:35:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:17545 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774AbYGKCfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 22:35:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,341,1212390000"; 
   d="scan'208";a="589994587"
Date: Thu, 10 Jul 2008 19:35:09 -0700
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
Message-ID: <20080711023509.GR1678@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com> <m1prplv71d.fsf@frodo.ebiederm.org> <20080710211513.GL1678@linux-os.sc.intel.com> <m1bq15gxml.fsf@frodo.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bq15gxml.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 03:52:50PM -0700, Eric W. Biederman wrote:
> Suresh Siddha <suresh.b.siddha@intel.com> writes:
> 
> > Flushing the interrupt entry cache will take care of this. We modify the IRTE
> > and then flush the interrupt entry cache before cleaning up the original
> > vector allocated.
> >
> > Any new interrupts from the device will see the new entry. Old in flight
> > interrupts will be registered at the CPU before the flush of the cache is
> > complete.
> 
> That sounds nice in principle.  I saw cpu cache flushes, I saw writes.
> I did not see any reads which is necessary to get that behavior with
> the standard pci transaction rules.

qi_flush_iec() will submit an invalidation descriptor and will wait
till it finishes the invalidation of the interrupt entry cache.
qi_submit_sync() will do the job. Descriptor completion ensures that
the inflight interrupts are flushed.

> Having seen enough little races and misbehaving hardware I'm very paranoid
> about irq migration.  The current implementation is belt and suspenders
> and I still think there are races that I have missed.

Eric, This process irq migration is done on the cutting edge hardware
which was designed with all the feedback and experiences in the mind ;)

And also, I don't think we are deviating much from what we are currently doing.
We are still using cleanup vector etc, to clean up the previous vector
allocation.

> >> You are sizing an array as NR_IRQS this is something there should be
> > sufficient
> >> existing infrastructure to avoid.  Arrays sized by NR_IRQS is a significant
> >> problem both for scaling the system up and down so ultimately we need to kill
> >> this.  For now we should not introduce any new arrays.
> >
> > Ok. Ideally dynamic_irq_init()/cleanup() can take care of this. or
> > create_irq()/destroy_irq() and embed this as a pointer somewhere inside
> > irq_desc. I need to take a look at this more closer and post a fix up patch.
> 
> Sounds good.  Ultimately we are looking at handler_data or chip_data.
> There are very specific rules that meant I could not use them for
> the msi data but otherwise I don't remember exactly what the are for.
> IOMMU are covered though.

IOMMU is covered as part of pci_dev (pci_sysdata). But in the case of
interrupt-remapping, there are some interrupt resources like ioapics and
hpet, which don't have the corresponding pci dev. Will take a look at this.

> At least for msi the code you are working on was essentially unified
> when it was written, it just happened to have two copies.  I don't
> think I'm asking for heaving lifting.  Mostly just putting code that
> is touched into something other then the growing monstrosity that is
> ioapic.c

We can create msi.c which handles MSI specific handling. I will
look into this. But I def welcome somone beating me in posting those
patches :) I made a note of this however.

> Further can we please see some better abstractions.  In particular can
> we generate a token for the irq destination.  And have the msi and
> ioapic setup read that token and program it into the hardware.  The
> rules for which bits go where is exactly the same both with and
> without irq_remapping so having an if statement there seems to obscure
> what is really happening.  Especially if as it appears that we may be used
> the new token format with x2apics without remapping.

unfortunately x2apic can't be enabled with out enabling interrupt-remapping.
Interrupts don't work in majority of the configurations (as I mentioned
earlier). Programming IOAPIC RTE's and MSI address/data registers are
completely different based on the presence of interrupt-remapping.

> 
> My primary concern is that the end result be well factored irq handling code
> so it is possible to get in there and look at the code and maintain it.
> 
> A small part of that is the 32bit support.  Another part are the missing
> abstractions I described.  I don't know what else since I have barely scratched the surface patch
> review wise.

Please keep the expert comments coming.

thanks,
suresh
