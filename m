Return-Path: <linux-kernel-owner+w=401wt.eu-S1765618AbXLUBDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765618AbXLUBDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 20:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757249AbXLUBDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 20:03:09 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32982 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752313AbXLUBDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 20:03:07 -0500
Date: Thu, 20 Dec 2007 17:00:39 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Richard Henderson <rth@twiddle.net>
cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
       Keith Packard <keithp@keithp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: PCI resource problems caused by improper address rounding
In-Reply-To: <20071221003913.GA6220@twiddle.net>
Message-ID: <alpine.LFD.0.9999.0712201650090.21557@woody.linux-foundation.org>
References: <alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org> <47680489.6040809@redhat.com> <alpine.LFD.0.9999.0712180946030.21557@woody.linux-foundation.org> <20071218202234.GA24525@twiddle.net> <alpine.LFD.0.9999.0712181240280.21557@woody.linux-foundation.org>
 <20071218215143.GA24769@twiddle.net> <alpine.LFD.0.9999.0712181412530.21557@woody.linux-foundation.org> <alpine.LFD.0.9999.0712181722260.21557@woody.linux-foundation.org> <20071220215204.GA5636@twiddle.net> <alpine.LFD.0.9999.0712201406190.21557@woody.linux-foundation.org>
 <20071221003913.GA6220@twiddle.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 Dec 2007, Richard Henderson wrote:
>
> This breaks in odd cases where the amount of memory in the system
> is not a nice round number.  Like throwing two 128MB sticks into
> a system that already has 2gb.  A 512MB allocation will get placed
> back at 2gb, on top of the end of ram.

No, no, you misunderstand.

The kernel *always* takes known memory allocations into account. The 
"minimum PCI starting allocation" value is not there to protect memory we 
know about: the resource management already does that!

So if you have real memory of 2GB+128MB, and you want a 512MB allocation, 
then yes, maybe the "preferred starting point" would be rounded back down 
to 2GB, but the resource allocator would still take known resources into 
account, and skip that address as being a conflict, and then try the next 
address that suits the alignment requirements, and try to see if there's a 
big enough hole at the 2.5GB mark.

So it would all work fine.

The reason we have that "min" parameter is not because of those _known_ 
resources, it's exactly because we have been bitten too many times by 
BIOSes that lay out magic undocumented resources in memory that we simply 
don't know about, because they aren't standard BAR resources, but some 
other special magic stuff. Things like the special ACPI areas that the 
northbridge recognizes, but aren't exposed as regular BAR's, but as just 
magic registers hidden in some undocumented NB register space.

So the reason we have those PCIBIOS_MIN_IO/MEM things is not because we'd 
trample on top of memory without them, it's because we might trample the 
BIOS resources that it never told us about!

Quite often, that's things like stolen RAM that doesn't show up in the 
e820 tables (it *should* show up as "reserved", but BIOS writers are 
generally incompetent drug-addicts picked up from the streets, who just 
randomly change BIOS tables until Windows boots on the machine), or the 
afore-mentioned magic IO registers for some special motherboard resource.

> In order to get this kind of thing to work, you'd have to have a hard 
> and a soft minimum.

We do have that "hard limit" - the resource management keeps track of all 
the resources it already knows about. The "soft limit" is exactly that 
PCIBIOS_MIN_MEM (which on a PC is that "pci_mem_start" variable). It's 
just a hint, but it's a pretty important one, exactly because we've been 
burned so many times by crap firmware and undocumented memory and MMIO 
ranges.

				Linus
