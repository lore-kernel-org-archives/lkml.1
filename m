Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbYGKGH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbYGKGH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 02:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbYGKGHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 02:07:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:35369 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbYGKGHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 02:07:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,343,1212390000"; 
   d="scan'208";a="307835308"
Date: Thu, 10 Jul 2008 23:07:15 -0700
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
Subject: Re: [patch 23/26] x64, x2apic/intr-remap: MSI and MSI-X support for interrupt remapping infrastructure
Message-ID: <20080711060714.GT1678@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com> <20080710182239.205057000@linux-os.sc.intel.com> <m1fxqhdxji.fsf@frodo.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1fxqhdxji.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 06:22:57PM -0700, Eric W. Biederman wrote:
> > As MSI is edge triggered, irq migration is a simple atomic update(of vector
> > and cpu destination) of IRTE and flushing the hardware cache.
> 
> A couple of things.  I believe MSI edge triggered irqs can always be migrated
> safely outside of irq context.
> 
> Flushing the hardware cache sounds like it will flush the irqs towards the cpu.
> How do we flush the inflight irqs flushed to the apic.  Does a register read work?

As I mentioned in other thread, we are waiting for the queued invalidation
descriptor to complete (in qi_submit_sync()). That will register the inflight
ones at the cpu's apic before setting the descriptor completion.

> For MSI irqs going directly to the cpu it should, as long as the cpu and local
> apic count as the same device from the perspective of pci ordering rules.
> 
> > +++ tree-x86/arch/x86/kernel/io_apic_64.c 2008-07-10 09:52:34.000000000 -0700
> > @@ -2289,6 +2289,9 @@
> >
> >       dynamic_irq_cleanup(irq);
> >
> > +#ifdef CONFIG_INTR_REMAP
> > +     free_irte(irq);
> > +#endif
> >       spin_lock_irqsave(&vector_lock, flags);
> >       __clear_irq_vector(irq);
> >       spin_unlock_irqrestore(&vector_lock, flags);
> > @@ -2307,11 +2310,42 @@
> >
> >       tmp = TARGET_CPUS;
> >       err = assign_irq_vector(irq, tmp);
> > -     if (!err) {
> > -             cpus_and(tmp, cfg->domain, tmp);
> > -             dest = cpu_mask_to_apicid(tmp);
> > +     if (err)
> > +             return err;
> > +
> > +     cpus_and(tmp, cfg->domain, tmp);
> > +     dest = cpu_mask_to_apicid(tmp);
> 
> Can we simplify this a little.  In particular have a function
> 
> struct IOAPIC_ROUTE_entry x86_map_irq(irq, mask);
> 
> Where x86_map_irq would ultimately figure out the path to the cpu.
> In the simple case it would just call assign_irq_vector();
> When irqs are remapped it would perform the additional

But we already know that the irq's are remapped, as we are using different
irq_chip's when irq's are remapped.

> map_irq_to_irte_handle();
> modify_irte(irq, &irte);
> 
> And then have the generic msi code and the ioapic code.
> Map from the struct IOAPIC_ROUTE_entry or whatever to the appropriate bits for the hardware
> they control.
> 
> That should allows us a lot more flexibility going forward with less code then is in your
> patches.

Are you talking about the setup code or the migration code? Because in migration
code, we don't even touch MSI/IO-apic devices (for edge atleast) and we
already use different irq_chip's for that.

For initial setup, I agree that it can use some simplifications. It's getting
late here and I will look at all your suggestions tomorrow.

thanks,
suresh
