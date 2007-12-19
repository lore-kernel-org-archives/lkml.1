Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbXLSAbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbXLSAbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbXLSAau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:30:50 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:36631 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448AbXLSAat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:30:49 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: PCI resource problems caused by improper address rounding
Date: Tue, 18 Dec 2007 17:29:40 -0700
User-Agent: KMail/1.9.6
Cc: Richard Henderson <rth@twiddle.net>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
       Keith Packard <keithp@keithp.com>
References: <47671377.6000405@redhat.com> <20071218202234.GA24525@twiddle.net> <alpine.LFD.0.9999.0712181240280.21557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712181240280.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200712181729.41215.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 December 2007 02:09:15 pm Linus Torvalds wrote:
> 
> On Tue, 18 Dec 2007, Richard Henderson wrote:
> > 
> > I've added dmesg, /proc/iomem, and lspci -v output to that bug.
> > 
> > Basically, we have
> > 
> > 	c0000000-cfffffff : free
> > 	ddf00000-dfefffff : PCI Bus #04
> > 	e0000000-efffffff : pnp 00:0b
> > 	f0000000-fedfffff : less than 256MB
> 
> Gaah. 
> 
> That really is very unlucky. That 256M only goes at one point in the low 
> 4GB, but the thing is, it fits perfectly well above it, and dammit, that 
> resource is explicitly a 64-bit resource or a really good reason. 
> 
> However, I wonder about that
> 
> 	e0000000-efffffff : pnp 00:0b
> 
> thing. I actually suspect that that whole allocation is literally *meant* 
> for that 256MB graphics aperture, but the kernel explicitly avoids it 
> because it's listed in the PnP tables.
> 
> I wonder what the heck is the point of that pnp entry. Just for fun, can 
> you try to just disable CONFIG_PNP, and see if it all works then?

00:0b must be a "motherboard" device, probably PNP0C01 or PNP0C02.
Those are catch-all devices with no real programming model associated
with them; they only describe resource usage.  AFAICT, they're mostly
used to describe legacy stuff like interrupt controllers, timers, etc.

My laptop has the same range for one of its PNP0C02 devices.  I'll
try to dig up a chipset spec and see what might look like that range.

We used to ignore anything past the first 8 I/O port regions and 4
memory regions (PNP_MAX_PORT and PNP_MAX_MEM), but those limits have
been recently bumped a bit [1].  That will cause additional reservations
that may explain some of the issues we're seeing.

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a7839e960675b549f06209d18283d5cee2ce9261

> Björn Helgaas added to Cc to clarify what those pnp entries tend to mean, 
> and whether there is possibly some way to match up a specific pnp entry 
> with the PCI device that might want to use it. Because that is a nice 
> 256MB region that really doesn't seem to make sense for anything else than 
> the graphics buffer - there's nothing else in your system that seems 
> likely (although I guess it could be for some docking port, but even then 
> I'd have expected one of the PCI bridges to map it!)
> 
> But apart from the question about that pnp 00:0b device, the kernel 
> resource allocation really does look perfectly fine, and while we could 
> shoe-horn it into the low 4GB in this case by just hoping that there is 
> nothing undocumented there (and there probably isn't), it's really 
> annoying considering that big graphics areas are a hell of a good reason 
> to use those 64-bit resources.
> 
> It's not like 256MB is even as large as they come, half-gig graphics cards 
> are getting to be fairly common at the high end, and X absolutely _has_ to 
> be able to handle a 64-bit address for those. 
> 
> Also, I'm surprised it doesn't work with X already: the ChangeLog for X 
> says that there are "Minor fixes to the handling of 64-bit PCI BARs [..]" 
> in 4.6.99.18, so I'd have assumed that XFree86-4.7.0 should be able to 
> handle this perfectly well.
> 
> I'll add Keithp to the cc too, to see if the X issues can be clarified. 
> Maybe he can set us right. But maybe you just have an old X server? If so, 
> considering the situation, I really think the kernel has done a good job 
> already, and I'd be *very* nervous about making the kernel allocate new 
> PCI resources right after the end-of-memory thing.
> 
> I bet it would work in this case, but as mentioned, we definitely know of 
> cases where the BIOS did *not* document the magic memory region that was 
> stolen for UMA graphics, and trying to put PCI devices just after the top 
> of reserved memory in the e820 list causes machines to not work at all 
> because the address decoding will clash.
> 
> Of course, we could also make the minimum address more of a *hint*, and 
> only make the resource allocator only abut the top-of-known-memory when it 
> absolutely has to, but on the other hand, in this case it really doesn't 
> have to, since there's just _tons_ of space for 64-bit resources. So the 
> correct thing really does seem to be to just use the 64-bit hw that is 
> there.
> 
> > That would have been an excellent comment to add to that code then,
> > rather than just "rounding up to the next 1MB area", because purely
> > as rounding code it is erroneous.
> 
> Patches to add comments are welcome. There are few enough people who 
> actually work on the PCI resource allocation code these days (I wish there 
> were more), and it's very rare that anybody else than me or Ivan ends up 
> even *looking* at it. So it's not been a big issue.
> 
> 				Linus
> 


