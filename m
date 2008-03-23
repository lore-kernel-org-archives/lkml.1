Return-Path: <linux-kernel-owner+w=401wt.eu-S1760405AbYCWKat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405AbYCWKat (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 06:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbYCWKal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 06:30:41 -0400
Received: from aun.it.uu.se ([130.238.12.36]:50262 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839AbYCWKak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 06:30:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18406.12612.194477.944676@harpo.it.uu.se>
Date: Sun, 23 Mar 2008 11:30:28 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Tejun Heo <htejun@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, jeff@garzik.org, kurt@roeckx.be,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.25-rc6] sata_promise: fix hardreset hotplug quirk
In-Reply-To: <47E5CCC3.3000301@gmail.com>
References: <200803221421.m2MEL1oY021558@harpo.it.uu.se>
	<47E5CCC3.3000301@gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo writes:
 > Hello, Mikael.
 > 
 > Mikael Pettersson wrote:
 > > There is an undocumented hardware quirk in Promise's SATA controllers,
 > > where a SATA COMRESET causes the controller to signal hotplug events.
 > > These unexpected interrupts confuse libata's error handler and cause
 > > a sequence of failed reset attempts until EH finally gives up.
 > 
 > Actually, this is common to many SATA controllers.  Lots of them raise
 > PHY event or hotplug interrupt during COMRESET and they all plug PHY
 > events from ->freeze.

Hmm, no I didn't know that. It's still undocumented, but perhaps
shouldn't be called a "quirk" if it's as common as you say.

 > > Although SATA hotplug status and control is per-port, it resides in
 > > a single register shared by all ports. Therefore accesses to it must
 > > be serialised: the controller's host->lock is used for that. The
 > > interrupt handler is also adjusted so its hotplug register accesses
 > > are inside the region protected by host->lock.
 > 
 > Hmmm... This is supposed to be handled by setting ap->lock appropriately
 > and ap->lock already is initialized to &host->lock, so sticking with
 > ap->lock is the right thing to do.

I'll check this. The code relies on the lock being shared by all ports,
so at a minimum it will need a comment stating that requirement.

 > > +static void pdc_sata_disable_hotplug(const struct ata_port *ap)
 > > +{
 > > +	struct ata_host *host = ap->host;
 > > +	void __iomem *host_mmio = host->iomap[PDC_MMIO_BAR];
 > > +	unsigned int hotplug_offset = pdc_sata_hotplug_offset(ap);
 > > +	unsigned int ata_no = pdc_sata_ata_port_to_ata_no(ap);
 > > +	u32 hotplug_status;
 > > +
 > > +	spin_lock(&host->lock);
 > > +
 > > +	hotplug_status = readl(host_mmio + hotplug_offset);
 > > +	hotplug_status |= 0x11 << (ata_no + 16);
 > > +	writel(hotplug_status, host_mmio + hotplug_offset);
 > > +	readl(host_mmio + hotplug_offset); /* flush */
 > > +
 > > +	spin_unlock(&host->lock);
 > > +}
 > > +
 > > +static void pdc_sata_enable_hotplug(const struct ata_port *ap)
 > > +{
 > > +	struct ata_host *host = ap->host;
 > > +	void __iomem *host_mmio = host->iomap[PDC_MMIO_BAR];
 > > +	unsigned int hotplug_offset = pdc_sata_hotplug_offset(ap);
 > > +	unsigned int ata_no = pdc_sata_ata_port_to_ata_no(ap);
 > > +	u32 hotplug_status;
 > > +
 > > +	spin_lock(&host->lock);
 > > +
 > > +	hotplug_status = readl(host_mmio + hotplug_offset);
 > > +	hotplug_status |= 0x11 << ata_no;
 > > +	hotplug_status &= ~(0x11 << (ata_no + 16));
 > > +	writel(hotplug_status, host_mmio + hotplug_offset);
 > > +	readl(host_mmio + hotplug_offset); /* flush */
 > > +
 > > +	spin_unlock(&host->lock);
 > > +}
 > > +
 > >  static void pdc_freeze(struct ata_port *ap)
 > >  {
 > >  	void __iomem *mmio = ap->ioaddr.cmd_addr;
 > > @@ -643,6 +717,12 @@ static void pdc_freeze(struct ata_port *
 > >  	readl(mmio + PDC_CTLSTAT); /* flush */
 > >  }
 > >  
 > > +static void pdc_sata_freeze(struct ata_port *ap)
 > > +{
 > > +	pdc_sata_disable_hotplug(ap);
 > > +	pdc_freeze(ap);
 > > +}
 > 
 > ->freeze() is called with ap->lock held, trying to lock host->lock
 > inside pdc_sata_enable/disable_hotplug() will result in deadlock.  Have
 > you tested w/ SMP configuration or spinlock debugging turned on?

No, I'll do that and fix whatever damage occurs.

/Mikael
