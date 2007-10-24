Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbXJXE65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbXJXE65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 00:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbXJXE6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 00:58:47 -0400
Received: from iabervon.org ([66.92.72.58]:55069 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbXJXE6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 00:58:46 -0400
Date: Wed, 24 Oct 2007 00:58:45 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org, jeff@garzik.org, linas@austin.ibm.com,
       chunhao.huang@hotmail.com, gregkh@suse.de, htejun@gmail.com,
       brice.goglin@gmail.com, david.gaarenstroom@gmail.com,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       linux-ide@vger.kernel.org, brice@myri.com, mchan@broadcom.com
Subject: Re: [PATCH 0/4]: Resolve MSI vs. INTX_DISABLE quirks.
In-Reply-To: <20071023.195108.69018458.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0710240046220.32497@iabervon.org>
References: <20071023.195108.69018458.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007, David Miller wrote:

> 
> The forthcoming patches are also available from:
> 
> 	kernel.org:/pub/scm/linux/kernel/git/davem/msiquirk-2.6.git
> 
> and clean up the handling of the common quirk wherein setting
> INTX_DISABLE will mistakedly disable MSI generation for some
> devices.
> 
> For devices without that problem, we want to keep the pci_intx() calls
> in drivers/pci/msi.c because those help protect against devices
> with the opposite problem.  Such devices always generate INTX
> interrupts even when MSI is enabled, unless INTX_DISABLE is set.
> 
> Michael, please pay special attention to patch #3.  I think I
> picked the correct PCI device IDs to match for the quirk
> (5714* and 5780*) but it's possible we might need more elaborate
> checks here.  It at least worked properly for the chips in my
> Niagara system.

I'm not sure all of the pci_intx() calls in msi.c should be skipped when 
the quirk applies; I think some of them might be there so that the legacy 
interrupt won't be delivered while MSI is turned off (since the handler 
isn't listening for the legacy interrupts). I'd guess this would cause 
people to have their MSI-capable device kill their non-MSI-capable device 
when they restore their laptop (and the shared interrupt fires and gets 
stuck at just the wrong time). No idea if this is a real concern, but I'm 
pretty sure that not all of those calls are recent.

> In addition to the Tigon3 cases, I added quirk entries for the
> SB700/800 SATA chips and the IXP SB400 USB controllers.

There's a couple of ATA drivers that look like they might be trying to 
work around the same bug, but it's a bit hard to tell. It might be good to 
have them use the quirk (or set the flag) because it's cleaner.

	-Daniel
*This .sig left intentionally blank*
