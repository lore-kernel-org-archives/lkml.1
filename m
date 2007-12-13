Return-Path: <linux-kernel-owner+w=401wt.eu-S1758802AbXLMJEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802AbXLMJEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 04:04:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbXLMJEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 04:04:11 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:52958 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbXLMJED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 04:04:03 -0500
Date: Thu, 13 Dec 2007 12:04:03 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Robert Hancock <hancockr@shaw.ca>
Cc: benh@kernel.crashing.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Possible issue with dangling PCI BARs
Message-ID: <20071213120403.B21124@jurassic.park.msu.ru>
References: <fa.YfTvVN5C3e6zwXPW5biWgeZ9XXc@ifi.uio.no> <fa.EhUqlM3V3y3HCcQkLBLSEKTJxBs@ifi.uio.no> <fa.4FjaYKIciOijtgO+0DDrMkrLjv0@ifi.uio.no> <4760B37E.3010002@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <4760B37E.3010002@shaw.ca>; from hancockr@shaw.ca on Wed, Dec 12, 2007 at 10:22:22PM -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 10:22:22PM -0600, Robert Hancock wrote:
> For the case where you say "I want to enable decoding for this MMIO BAR, 
> but not that one", though, I don't see an obvious way to provide that 
> guarantee with certainty. Normally, one would expect that if a BAR is 
> mapped safely outside the decode window of a PCI bridge it's behind, 
> that it won't ever see the requests and can't respond to them. However, 
> the Intel chipset MMCONFIG overlap fiasco appears to show that this is 
> not always the case and in some cases the device can see and respond to 
> requests outside of the bridge's decode window (with higher decode 
> priority than the MMCONFIG aperture, even)..

>From my reading of Intel specs, these priority decode rules apply only
to legacy VGA aperture (which doesn't have a BAR anyway) - that's why you
cannot have both internal and external VGA working together on these
chipsets. But for any normal BAR classic PCI bridge decode still works
as expected.

However, mapping a BAR outside the decode window of a PCI bridge
can be dangerous for another reason - it could clash with DMA from
a sibling device. Either with DMA to system RAM, if you put that BAR
below the parent bridge window, or with MSI, if you put it above...

So disabling memory or IO decode in a command register seems to be
the only safe option. This depends on architecture, though.

Ivan.
