Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbXKNISp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbXKNISp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 03:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbXKNISh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 03:18:37 -0500
Received: from gate.crashing.org ([63.228.1.57]:55474 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbXKNISg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 03:18:36 -0500
Subject: Re: [PATCH] Align PCI memory regions to page size (4K) - Fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: David Miller <davem@davemloft.net>, gregkh@suse.de, barak@neocleus.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       guy@neocleus.com
In-Reply-To: <20071114062157.GA30203@colo.lackof.org>
References: <20071028193104.GA13956@suse.de>
	 <9392A06CB0FDC847B3A530B3DC174E7B03C96F36@mse10be1.mse10.exchange.ms>
	 <20071028200336.GA14563@suse.de>
	 <20071028.180807.165828961.davem@davemloft.net>
	 <1194988653.28605.4.camel@pasglop> <20071114062157.GA30203@colo.lackof.org>
Content-Type: text/plain
Date: Wed, 14 Nov 2007 19:16:18 +1100
Message-Id: <1195028178.28865.32.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-11-13 at 23:21 -0700, Grant Grundler wrote:
> 
> > So something like your hypervisor binds a special driver to a device
> > that is to be reflected to a partition, at which point we are sure
> no
> > other driver is using it, then that driver can call something in the
> pci
> > layer that attempts to re-assign the device resources to keep it in
> a
> > separate page.
> 
> We already have that "something": pci_enable_device().
> The guest OS "Arch" code can then do the reassignment.
> See "3.1 Enable the PCI device" in Documentation/pci.txt.

No, that can't be done there because that would mean the guest OS has
the ability to reassign resources of PCI devices which is really not
something you want. You really want the host OS to do that -before- it
makes the device visible to the guest imho.

> The Hypervisor could be responsible for making the right devices
> visible to the appropriate partitions/guests by intercepting the
> PCI bus walk and/or hotplug support. I don't think you
> should need any dummy resource/drivers in the guest OS.

I'm not talking about a dummy resource/driver in the guest OS, but
rather, in the host. When a PCI device, that is visible to the host, is
to be "reflected" into a guest, it makes sense to have a proxy driver
take over in the host from a resource management point of view, thus
making this device effectively "used" and thus preventing another
process or partition from trying to bind to it. That proxy driver can
then be responsible for doing the appropriate resource tweaking before
making the device effectively visible to the guest. It might make sense
to provide a helper in the PCI layer to make that easier tho.

Ben.


