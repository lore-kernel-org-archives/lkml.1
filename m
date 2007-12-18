Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbXLRVYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbXLRVYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbXLRVSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:18:04 -0500
Received: from are.twiddle.net ([64.81.246.98]:35611 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbXLRVRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:17:42 -0500
X-Greylist: delayed 3172 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2007 16:17:42 EST
Date: Tue, 18 Dec 2007 12:22:34 -0800
From: Richard Henderson <rth@twiddle.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>
Subject: Re: PCI resource problems caused by improper address rounding
Message-ID: <20071218202234.GA24525@twiddle.net>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>
References: <47671377.6000405@redhat.com> <alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org> <47680489.6040809@redhat.com> <alpine.LFD.0.9999.0712180946030.21557@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712180946030.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 10:21:50AM -0800, Linus Torvalds wrote:
> > https://bugzilla.redhat.com/show_bug.cgi?id=425794#c0
> 
> That bugzilla entry doesn't even have a dmesg output or anything like 
> that. I'd really like to see what the 

I've added dmesg, /proc/iomem, and lspci -v output to that bug.

Basically, we have

	c0000000-cfffffff : free
	ddf00000-dfefffff : PCI Bus #04
	e0000000-efffffff : pnp 00:0b
	f0000000-fedfffff : less than 256MB

The annoying part is that there's no device (that I can see) 
behind PCI Bus #04, so it might as well be disabled and that
entire d0000000-dfffffff area reclaimed.

> That patch might as well just do
> 
> 	pci_mem_start = gapstart;
> 
> and get rid of all that rounding code entirely, since the patch just 
> assumes that it's safe to use memory after gapstart (which is known to not 
> be true, and is the whole and only reason for that code in the first 
> place: BIOSes *invariably* get resource allocation wrong, and forget to 
> tell us about some resource they set up).

That would have been an excellent comment to add to that code then,
rather than just "rounding up to the next 1MB area", because purely
as rounding code it is erroneous.

> The *other* patch in the bugzilla entry seems more correct, in that yes, 
> we should make sure that we don't allocate resources over 4G if the 
> resource won't fit. That said, I think that patch is wrong too: we should 
> just fix pcibios_align_resource() to check that case for MEM resouces (the 
> same way it already knows about the magic rules for IO resources).

I'll give that patch a try, modified a tad to still include the
force_32_bit quirk.

> So I'd suggest just fixing pcibios_align_resource() instead. Something 
> like the appended might work (and then you could perhaps quirk it to 
> always clear the PCI_BASE_ADDRESS_MEM_TYPE_64 thing for VGA controllers, 

That won't work, because PCI_BASE_ADDRESS_MEM_TYPE_64 controls how
many bits need to be written back to the BAR.  If we changed that
to PCI_BASE_ADDRESS_MEM_TYPE_32, we wouldn't clear the high 32-bits
of the BAR.

> ... and that would be an X server issue!).

Of course, fixing the X server to *handle* 64-bit BARs is the correct
solution.  I've no idea how involved that is, but I have a sneeking
suspicion that it uses that damned CARD32 datatype for everything.


r~
