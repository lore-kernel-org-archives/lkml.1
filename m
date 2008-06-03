Return-Path: <linux-kernel-owner+w=401wt.eu-S1757657AbYFCXBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657AbYFCXBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 19:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbYFCXBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 19:01:34 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:63318 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbYFCXBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 19:01:33 -0400
Date: Tue, 3 Jun 2008 15:59:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Olaf Dabrunz <od@suse.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Jon Masters <jonathan@jonmasters.org>,
       LKML <linux-kernel@vger.kernel.org>, Stefan Assmann <sassmann@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 2/7] reroute PCI interrupt to legacy boot interrupt
 equivalent
Message-Id: <20080603155903.4bec13b9.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.1.10.0806031213360.3235@apollo.tec.linutronix.de>
References: <12124107071847-git-send-email-od@suse.de>
	<12124107074065-git-send-email-od@suse.de>
	<alpine.LFD.1.10.0806031213360.3235@apollo.tec.linutronix.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2008 12:37:58 +0200 (CEST) Thomas Gleixner wrote:

> On Mon, 2 Jun 2008, Olaf Dabrunz wrote:
> > From: Stefan Assmann <sassmann@suse.de>
> > 
> > Some chipsets (e.g. intel 6700PXH) generate a legacy INTx when the
> > IRQ entry in the chipset's IO-APIC is masked (as, e.g. the RT kernel
> > does during interrupt handling). On chipsets where this INTx generation
> > cannot be disabled, we reroute the valid interrupts to their legacy
> > equivalent to get rid of spurious interrupts that might otherwise bring
> > down (vital) interrupt lines through spurious interrupt detection in
> > note_interrupt().
> > 
> > The patch should eventually simply use another bitfield in the pci_dev
> > structure for the rerouting variant. This was in another variant of the patch
> > by Daniel Gollub. It is the cleanest and most simple approach.
> > 
> > This patch benefited from discussions with Alexander Graf, Torsten Duwe,
> > Ihno Krumreich, Daniel Gollub, Hannes Reinecke. The conclusions we drew
> > and the patch itself are the authors' responsibility alone.
> > 
> > Signed-off-by: Stefan Assmann <sassmann@suse.de>
> > Signed-off-by: Olaf Dabrunz <od@suse.de>
> > ---
> >  drivers/acpi/pci_irq.c     |   63 ++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/pci/quirks.c       |   51 ++++++++++++++++++++++++++++++++++-
> >  include/linux/pci.h        |    2 +
> >  include/linux/pci_ids.h    |    4 +++
> >  include/linux/pci_quirks.h |   28 +++++++++++++++++++
> >  5 files changed, 147 insertions(+), 1 deletions(-)
> >  create mode 100644 include/linux/pci_quirks.h
> > 
> > diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
> > index 89022a7..ebdfbfe 100644
> > --- a/drivers/acpi/pci_irq.c
> > +++ b/drivers/acpi/pci_irq.c
> > @@ -384,6 +384,34 @@ acpi_pci_free_irq(struct acpi_prt_entry *entry,
> >  	return irq;
> >  }
> >  
> > +#ifdef CONFIG_X86_IO_APIC
> > +static int
> > +bridge_has_boot_interrupt_variant(struct pci_bus *bus)
> 
> one line
> 
> > +{
> > +	struct pci_bus *bus_it;
> > +	int i;
> > +
> > +	for (bus_it = bus ; bus_it ; bus_it = bus_it->parent) {

Along with Thomas's comments:

spacing:
	for (bus_it = bus; bus_it; bus_it = bus_it->parent) {

and additions to Documentation/kernel-parameters.txt, please.


> > +		if (!bus_it->self)
> > +			return 0;
> > +
> > +		printk(KERN_INFO "vendor=%04x device=%04x\n", bus_it->self->vendor,
> > +				bus_it->self->device);
> > +		for (i = 0; i < MAX_QUIRK_BOOTIRQ_REROUTE_DEVS; i++) {
> > +			if (quirk_bootirq_reroute_devs[i].vendor == 0)
> > +				return 0;
> > +
> > +			if (quirk_bootirq_reroute_devs[i].vendor == bus_it->self->vendor &&
> > +			    quirk_bootirq_reroute_devs[i].device == bus_it->self->device)
> > +				return quirk_bootirq_reroute_devs[i].quirk_variant;
> > +		}
> > +	}
> > +	return 0;
> > +}


---
~Randy
