Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbXLMF1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbXLMF1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 00:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbXLMF1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 00:27:01 -0500
Received: from gate.crashing.org ([63.228.1.57]:47688 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbXLMF1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 00:27:00 -0500
Subject: Re: Possible issue with dangling PCI BARs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4760B37E.3010002@shaw.ca>
References: <fa.YfTvVN5C3e6zwXPW5biWgeZ9XXc@ifi.uio.no>
	 <fa.EhUqlM3V3y3HCcQkLBLSEKTJxBs@ifi.uio.no>
	 <fa.4FjaYKIciOijtgO+0DDrMkrLjv0@ifi.uio.no>  <4760B37E.3010002@shaw.ca>
Content-Type: text/plain
Date: Thu, 13 Dec 2007 16:26:42 +1100
Message-Id: <1197523602.15741.114.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> We could do a bit better than that - a common use case with 
> pci_enable_device_bars would be where the device has some IO space that 
> we don't care about because we only want to use MMIO space. If we only 
> want to enable MMIO BARs then we don't need to enable IO decoding, and 
> in that case it doesn't matter if we failed to find space for the IO 
> space and it overlaps something else.

Yes, we could at least separate memory from IO.

> It looks like we already handle the "not enabling IO decoding" part in 
> this case, except that it doesn't look like we ever would disable the 
> decoding if it was already enabled.

Yup.

> For the case where you say "I want to enable decoding for this MMIO BAR, 
> but not that one", though, I don't see an obvious way to provide that 
> guarantee with certainty. Normally, one would expect that if a BAR is 
> mapped safely outside the decode window of a PCI bridge it's behind, 
> that it won't ever see the requests and can't respond to them. However, 
> the Intel chipset MMCONFIG overlap fiasco appears to show that this is 
> not always the case and in some cases the device can see and respond to 
> requests outside of the bridge's decode window (with higher decode 
> priority than the MMCONFIG aperture, even)..

Yup, which is why I believe we would be reasonably safe if we did
something along the lines of: when we fail to assign a resource, we
disable decoding on the device. Either both or only the "side" (IO vs.
MEM) of the resource we failed assigning.

In addition, we modify pcibios_enable_device() to verify that if it's
going to enable MEM or IO, there is no BAR of that type that is left
unassigned, even if those aren't part of the mask.

I can try to whip up some code tomorrow I suppose, though I'm always
afraid some dodgy x86 setup will blow up...

Cheers,
Ben.


