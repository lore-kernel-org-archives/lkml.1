Return-Path: <linux-kernel-owner+w=401wt.eu-S1762761AbYFLOOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762761AbYFLOOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 10:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758813AbYFLOO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 10:14:27 -0400
Received: from ns2.suse.de ([195.135.220.15]:42723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbYFLOOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 10:14:25 -0400
Date: Thu, 12 Jun 2008 16:14:20 +0200
From: Olaf Dabrunz <od@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Olaf Dabrunz <od@suse.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Jon Masters <jonathan@jonmasters.org>,
       LKML <linux-kernel@vger.kernel.org>, Stefan Assmann <sassmann@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ihno Krumreich <ihno@suse.de>,
       Sven Dietrich <sdietrich@suse.de>, Daniel Gollub <dgollub@suse.de>,
       Felix Foerster <ffoerster@suse.de>
Subject: Re: [PATCH 2/7] reroute PCI interrupt to legacy boot interrupt
	equivalent
Message-ID: <20080612141420.GA6809@suse.de>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	Jon Masters <jonathan@jonmasters.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Stefan Assmann <sassmann@suse.de>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Ihno Krumreich <ihno@suse.de>, Sven Dietrich <sdietrich@suse.de>,
	Daniel Gollub <dgollub@suse.de>, Felix Foerster <ffoerster@suse.de>
References: <12124107071847-git-send-email-od@suse.de> <12124107074065-git-send-email-od@suse.de> <alpine.LFD.1.10.0806031213360.3235@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.1.10.0806031213360.3235@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay. We tried to address everything before we send new
patches and replies, and there were other tasks to do as well.

On 03-Jun-08, Thomas Gleixner wrote:
> On Mon, 2 Jun 2008, Olaf Dabrunz wrote:
> > +
> > +#ifdef CONFIG_X86_IO_APIC
> > +	/*
> > +	 * Some chipsets (e.g. intel 6700PXH) generate a legacy INTx when the
> > +	 * IRQ entry in the chipset's IO-APIC is masked (as, e.g. the RT kernel
> > +	 * does during interrupt handling). When this INTx generation cannot be
> > +	 * disabled, we reroute these interrupts to their legacy equivalent to
> > +	 * get rid of spurious interrupts.
> > +	 */
> > +        if (reroute_to_boot_interrupts) {
> > +		switch (bridge_has_boot_interrupt_variant(bus)) {
> > +		case 0:
> > +			/* no rerouting necessary */
> > +			break;
> > +
> > +		case VARIANT_INTEL_BUS_INT_REMAPPING:
> > +			/*
> > +			 * Remap according to INTx routing table in 6700PXH
> > +			 * specs, intel order number 302628-002, section
> > +			 * 2.15.2. Other chipsets (80332, ...) have the same
> > +			 * mapping and are handled here as well.
> > +			 */
> 
>   They generate INTA,B,C,D messages. What makes sure, that those are
>   always routed to IRQ 16,17,18,19 ?

We made sure by following the IRQ routing through the bridges and the
ICHs. For the MCHs in our test machines no special IRQ routing is
documented, and we tested that the IRQs end up on the ICH (the RIRR bit
is set on the ICH's IO-APIC IRQ line). The testing of the rerouting
patch showed that it works.

But the handling of IRQs in the MCHs is not completely clear (as pointed
out by Maciej W. Rozycki). I found out some interesting bits there now,
and a followup on this is in preparation.

We also need to document the other analysis and ideas that went into the
patch.

>   IIRC we have seen those spurious interrupts on IRQ 9 and 12 as well.

Was that an AMD/ATI, Broadcomm or some other non-intel chip? (We can
switch off the boot IRQs for the AMD/ATI and Broadcomm chips we saw, so
no re-routing needed there.) I have looked at the intel ICH datasheets
from ICH[0] to ICH9 and all of them route PCI IRQs to IRQs 16 to 24. 

> > +			printk(KERN_INFO "pci irq %d -> rerouted to legacy "
> > +					 "irq %d\n", ret, (ret % 4) + 16);
> > +			ret = (ret % 4) + 16;
> > +			break;
> > +
> > +		default:
> > +			printk(KERN_INFO "not rerouting irq %d to legacy irq: "
> > +					 "unknown mapping\n", ret);
> > +			break;
> > +		}
> > +	}
> > +#endif /* CONFIG_X86_IO_APIC */
> > +
> >  	return ret;
> >  }
> >  
> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> > index 6245486..6173be5 100644
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -1375,8 +1375,57 @@ int nobootirqquirk_setup(char *str)
> >  	return 1;
> >  }
> >  __setup("nobootirqquirk", nobootirqquirk_setup);
> > -#endif /* CONFIG_X86_IO_APIC */
> >  
> > +/*
> > + * Boot interrupts on some chipsets cannot be turned off. For these chipsets,
> > + * remap the original interrupt in the linux kernel to the boot interrupt, so
> > + * that a PCI device's interrupt handler is installed on the boot interrupt
> > + * line instead.
> > + */
> > +int reroute_to_boot_interrupts;
> > +EXPORT_SYMBOL(reroute_to_boot_interrupts);
> > +
> > +struct quirk_bootirq_reroute_dev
> > +	quirk_bootirq_reroute_devs[MAX_QUIRK_BOOTIRQ_REROUTE_DEVS];
> > +EXPORT_SYMBOL(quirk_bootirq_reroute_devs);
> 
> Please use a consistent name space. This is about ioapic quirks so the
> whole stuff should use ioapic_quirk_XXX or something like this.
> 
> Also why dont we put this information into the pci_dev structure
> instead of having these tables and exports ?

Yes. A variant of the patch using pci_dev was in the queue, and we use
this now.

(The reason we used the extra tables and exports was to avoid touching
pci_dev late in our release cycle. But I also believe the pci_dev
solution is cleaner for upstream. To give proper credit, Daniel Gollub
also suggested this to us.)

Regards,

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

