Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbYE0IiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbYE0IiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 04:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756373AbYE0Ihy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 04:37:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58544 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756316AbYE0Ihx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 04:37:53 -0400
Date: Tue, 27 May 2008 10:37:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@qumranet.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Question about interrupt routing and irq allocation
Message-ID: <20080527083729.GF29246@elte.hu>
References: <483B34CA.8000600@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483B34CA.8000600@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> I'm working on a pv driver for hvm Xen guests.  That is, when booting 
> Linux in a fully-virtualized Xen domain, it can still access the 
> underlying Xen device model to get more efficient device access, 
> bypassing all the hardware emulation.
>
> Xen implements this by creating a "Xen platform device" on the 
> emulated PCI bus, which is a bit like a PCI-Xenbus bridge: the pci 
> device driver which discovers this device can then use it to register 
> a xenbus, and which then allows all the xenbus drivers to discover 
> their devices.  This device has an interrupt which is asserted when 
> any Xen event channel has a pending event.
>
> Now one way to handle this interrupt is just make it a single irq 
> which all xenbus drivers share.  They would then treat the event 
> channel bit array like an internal device register to disambiguate who 
> should get the interrupt.  That's what the current out of tree drivers 
> do, and it works OK.  The main problem is that all the interrupts are 
> mushed together, and can't be accounted for separately, given separate 
> affinities, etc.  It also means that there's a gratuitous difference 
> between the pv-on-hvm and pv-on-pv drivers, even though they're 
> functionally identical.
>
> The other approach would be to treat it as some kind of interrupt 
> daisy-chain device.  The PCI-xenbus driver gets the interrupt, scans 
> the event channels, maps those onto distinct irqs and then 
> (re-)delivers them appropriately.  This means that the system would 
> have a mixture of PIC, APIC and Xen interrupt sources.  The main 
> problem I see with this is how to allocate irqs for the routing of 
> event channels to irqs (which, as I understand it, is equivalent to 
> mapping IOAPIC pins to local APIC irqs).
>
> Is there some way to allocate irqs reliably, in a way which won't 
> conflict with APIC-based interrupt sources?  If I scan the irq_desc 
> array looking for entries without any chip, can I claim them and use 
> them for my Xen-irq-chip, or will that cause later conflicts?  Should 
> I just raise NR_IRQs and start using irqs above 224?
>
> This is not an area I've looked at before, so it's quite likely I'm 
> getting details wrong.  Are there any other examples of devices like 
> this, either in the x86 world, or in general?

hm, in theory the highest quality method would be to do this on the 
genirq level and register your own special "Xen irq-chip" methods. [see 
include/linux/irq.h's "struct irq_chip" and kernel/irq/*.c]

you can use set_irq_chip() to claim a specific irq and set up its 
handling at the highest level. That way you dont have to do anything in 
the x86 hw vector space at all and you'd avoid all the overhead and 
complications of x86 irq vectors. You can control how these interrupts 
are named in /proc/interrupts, etc.

but this needs synchronization with all the other entities that claim 
specific irqs and expect to be able to get them. MSI already does that 
to a certain level, see arch_setup_msi_irq() / set_irq_msi(). But that 
wastes x86 vectors and we dont really want to waste them as you dont 
actually want to use any separate per irq hw vectoring mechanism for 
these interrupts.

So the most intelligent method would be to reserve the Linux irq itself 
but not the vector, i.e. allocate from irq_cfg[] in 
arch/x86/kernel/io_apic_64.c so that the irq number does not get reused 
- setting irq_cfg[irq].vector to -1 will achieve that.

	Ingo
