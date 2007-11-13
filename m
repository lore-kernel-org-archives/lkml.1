Return-Path: <linux-kernel-owner+w=401wt.eu-S1762683AbXKMVSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762683AbXKMVSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760767AbXKMVSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:18:17 -0500
Received: from gate.crashing.org ([63.228.1.57]:57788 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760553AbXKMVSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:18:15 -0500
Subject: Re: [PATCH] Align PCI memory regions to page size (4K) - Fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: gregkh@suse.de, barak@neocleus.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, guy@neocleus.com
In-Reply-To: <20071028.180807.165828961.davem@davemloft.net>
References: <20071028193104.GA13956@suse.de>
	 <9392A06CB0FDC847B3A530B3DC174E7B03C96F36@mse10be1.mse10.exchange.ms>
	 <20071028200336.GA14563@suse.de>
	 <20071028.180807.165828961.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 14 Nov 2007 08:17:33 +1100
Message-Id: <1194988653.28605.4.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-10-28 at 18:08 -0700, David Miller wrote:
> From: Greg KH <gregkh@suse.de>
> Date: Sun, 28 Oct 2007 13:03:36 -0700
> 
> > But doesn't aligning such regions on that alignment break some devices
> > as that is not what the device is asking for in the BIOS?
> 
> There are also platforms where bootup firmware chooses the
> allocations, and that is what we use no matter what.  This is so that
> when breaking into the firmware for debugging the firmware can still
> access the console device where it had mapped it in the first place.
> 
> We really can't do things this way.

Agreed.

Though he's trying to fix a real issue, his patch is not the right
approach imho.

A better approach would be to have a mechanism to be triggered by the
hypervisor administration tools that will attempt to reassign -that-
specific device if it happens to share pages with another.

The remapping would thus only happen for that single device, after it's
been put in control of the hypervisor (no host driver is bound, maybe
just an HV specific "bridging" driver is), and only when the action of
assigning it to the partition is performed, so that if the machine
crashes as a result, at least you know why :-)

So something like your hypervisor binds a special driver to a device
that is to be reflected to a partition, at which point we are sure no
other driver is using it, then that driver can call something in the pci
layer that attempts to re-assign the device resources to keep it in a
separate page.

A patch implementing such a helper, and maybe reserving the rest of the
MMIO page via some dummy resource to make sure nobody else gets in, that
would make more sense.

Ben.


