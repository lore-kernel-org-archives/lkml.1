Return-Path: <linux-kernel-owner+w=401wt.eu-S1757766AbZGQFBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766AbZGQFBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 01:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757757AbZGQFBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 01:01:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44605 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488AbZGQFA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 01:00:59 -0400
Subject: Re: [PATCH 1/2] vga: implements VGA arbitration on Linux
From: Dave Airlie <airlied@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tiago Vignatti <tiago.vignatti@nokia.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
In-Reply-To: <20090714153509.51bbec27@lxorguk.ukuu.org.uk>
References: <1247576250-16274-1-git-send-email-tiago.vignatti@nokia.com>
	 <1247576250-16274-2-git-send-email-tiago.vignatti@nokia.com>
	 <20090714153509.51bbec27@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 15:00:42 +1000
Message-Id: <1247806842.3572.12.camel@clockmaker.usersys.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-14 at 15:35 +0100, Alan Cox wrote:
> > +#ifndef __ARCH_HAS_VGA_ENABLE_RESOURCES
> > +static inline void vga_enable_resources(struct pci_dev *pdev,
> > +					unsigned int rsrc)
> > +{
> > +	struct pci_bus *bus;
> > +	struct pci_dev *bridge;
> > +	u16 cmd;
> > +
> > +#ifdef DEBUG
> > +	printk(KERN_DEBUG "%s\n", __func__);
> > +#endif
> > +	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
> > +	if (rsrc & (VGA_RSRC_LEGACY_IO | VGA_RSRC_NORMAL_IO))
> > +		cmd |= PCI_COMMAND_IO;
> > +	if (rsrc & (VGA_RSRC_LEGACY_MEM | VGA_RSRC_NORMAL_MEM))
> > +		cmd |= PCI_COMMAND_MEMORY;
> > +	pci_write_config_word(pdev, PCI_COMMAND, cmd);
> 
> Locking question - what locks this lot against hotplug also touching
> bridge settings ?
> 
> > +
> > +	if (!(rsrc & VGA_RSRC_LEGACY_MASK))
> > +		return;
> > +
> > +	bus = pdev->bus;
> > +	while (bus) {
> > +		bridge = bus->self;
> > +		if (bridge) {
> > +			pci_read_config_word(bridge, PCI_BRIDGE_CONTROL,
> > +					     &cmd);
> > +			if (!(cmd & PCI_BRIDGE_CTL_VGA)) {
> > +				cmd |= PCI_BRIDGE_CTL_VGA;
> > +				pci_write_config_word(bridge,
> > +						      PCI_BRIDGE_CONTROL,
> > +						      cmd);
> > +			}
> > +		}
> > +		bus = bus->parent;
> > +	}
> > +}
> > +#endif
> 
> 
> > +	/* The one who calls us should check for this, but lets be sure... */
> > +	if (pdev == NULL)
> > +		pdev = vga_default_device();
> 
> What if the BIOS provided device was hot unplugged ?
> 
> > +		conflict = __vga_tryget(vgadev, rsrc);
> > +		spin_unlock_irqrestore(&vga_lock, flags);
> > +		if (conflict == NULL)
> > +			break;
> > +
> > +
> > +		/* We have a conflict, we wait until somebody kicks the
> > +		 * work queue. Currently we have one work queue that we
> 
> If two drivers own half the resources and both are waiting for the rest
> what handles the deadlock

Okay I've been thinking a bit about this one, and I think the best
answer is if you hold a lock you can't upgrade, you must drop all the
locks and relock with the new list of things you want. This means if you
have an IO lock you can't go getting the mem lock without dropping the
io lock first and getting both of them in one hit.

Anyone see any issues with that?

I'm also going to add normal locks so I'll change the userspace API to
pass 4 values or'ed together, legacyio, legacymem, normalio, normalmem
or none, then the locking should act like this:

device doesn't decode VGA: normal io/mem locks always pass, legact
io/mem locks always fail. don't touch main lock

device decodes VGA: (acts like read/write lock)

asks for normal mem/io locks: if no locks or only other normal locks are
held by devices that decode VGA, then take main lock as a reader and
enable decodes. If someone holds lock as a write block waiting for it.

asks for VGA mem/io locks, if no locks are held, take main lock as a
writer. If main lock has readers already, block waiting for a write lock
on it.

Does this sound sane?

Dave.

