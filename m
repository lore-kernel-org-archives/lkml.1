Return-Path: <linux-kernel-owner+w=401wt.eu-S1763317AbXEWJ0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763317AbXEWJ0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 05:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756947AbXEWJ01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 05:26:27 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:2525 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351AbXEWJ00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 05:26:26 -0400
Date: Wed, 23 May 2007 13:26:34 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Wayne Sherman <wsherman@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: PCI device problem - MMCONFIG, cannot allocate resource region, resource collisions
Message-ID: <20070523132634.A16545@jurassic.park.msu.ru>
References: <46524A6D.5050601@gmail.com> <200705220858.51604.jbarnes@virtuousgeek.org> <46537ADE.1060103@gmail.com> <200705221631.22456.jbarnes@virtuousgeek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <200705221631.22456.jbarnes@virtuousgeek.org>; from jbarnes@virtuousgeek.org on Tue, May 22, 2007 at 04:31:22PM -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 04:31:22PM -0700, Jesse Barnes wrote:
> On Tuesday, May 22, 2007, Wayne Sherman wrote:
> > If so, the D-Link is not being mapped into the 
> > right region, and the bridge it is behind does not have enough memory
> > assigned to it (ff500000-ff5fffff : PCI Bus #02).
> 
> Sounds familiar.  There are lots of cases where bridge windows aren't 
> allocated properly so devices behind them are invisible or can't work.  
> Check out the attached patch from Ivan, if you 
> pass 'pci=assign-bus-resources' to your kernel at boot time, the code will 
> try to reallocate bridge space for you if needed.

No, it won't help. The 1M range (ff500000-ff5fffff) is more than enough.
The reason why the D-Link resource is not getting assigned is rather
interesting: as Wayne wrote

> Here is the D-LINK NIC:
> # od -t x4 /sys/devices/pci0000:00/0000:00:14.4/0000:02:02.0/config
> 
> 0000000 49011186 80b00117 00000011 00004010
			    ^^^^^^
which means that the device class is 0 (not defined).
And in drivers/pci/setup-bus.c we have

		/* Don't touch classless devices or host bridges or ioapics.  */
		if (class == PCI_CLASS_NOT_DEFINED ||
		    class == PCI_CLASS_BRIDGE_HOST)
			continue;

The short term fix would be to assign proper device class to D-Link NIC
using pci quirk, but I believe a proper solution is to remove all sorts of
"if (class == PCI_xxx)" limitations (alpha, for example needs none of them)
from generic code and mark critical stuff with IORESOURCE_PCI_FIXED
in arch-specific way...

Ivan.
